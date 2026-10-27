// Stage 4, experiment 6: std::map vs std::unordered_map vs flat sorted vector.
//
// Look up random existing keys in a container of n (key, value) pairs:
//   map       red-black tree: one heap node per entry, log2(n) pointer hops
//   unordered hash table: hash -> bucket -> node (std::unordered_map is
//             node-based too: each entry is its own heap allocation)
//   flat      sorted std::vector<pair> + std::lower_bound: binary search
//             over contiguous memory, no pointers
//   flat_branchless  same vector, binary search with a cmov per step
//             instead of a jump (added after flat turned out slow in cache)
//   linear   unsorted std::vector<pair>, scan from the start (n <= 4096)
//
// One lookup per benchmark iteration. The lookup keys come from a list of
// 64 Ki random keys so the branch predictor can't memorise the order (see
// virtual_crtp.cpp: it learns short repeating patterns).
//
// Sizes: 16, 256, 4 Ki, 64 Ki, 1 Mi entries. A map node is ~48 B (3
// pointers + colour + key + value), so 1 Mi entries ~ 48 MB > L3 (24 MB).
//
// Prediction:
//   n = 16:   linear fastest (16 compares in one or two cache lines),
//             flat close, map/unordered slower (pointer chasing / hashing)
//   n = 4 Ki: unordered fastest (O(1)), flat next (12 steps in cache),
//             map slowest (12 dependent pointer hops)
//   n = 1 Mi: unordered still ~1-2 cache misses -> fastest; flat ~20 steps,
//             the last ~8 miss cache; map ~20 dependent misses -> slowest
//             by far (~1 us?)

#include <benchmark/benchmark.h>

#include <algorithm>
#include <cstddef>
#include <cstdint>
#include <map>
#include <random>
#include <unordered_map>
#include <utility>
#include <vector>

using Key = std::uint64_t;
using Value = std::uint64_t;
constexpr std::size_t kLookups = 64 * 1024;  // power of two: cheap wrap

struct Data {
    std::vector<Key> keys;     // the n keys, in random (insertion) order
    std::vector<Key> lookups;  // kLookups keys drawn from `keys`
};

static Data make_data(std::size_t n) {
    std::mt19937_64 gen(42);
    Data d;
    d.keys.resize(n);
    for (auto& k : d.keys) k = gen();  // 64-bit random: duplicates are vanishingly rare

    std::uniform_int_distribution<std::size_t> pick(0, n - 1);
    d.lookups.resize(kLookups);
    for (auto& k : d.lookups) k = d.keys[pick(gen)];
    return d;
}

static void set_ns_per_lookup(benchmark::State& state) {
    state.counters["ns/lookup"] = benchmark::Counter(
        1.0, benchmark::Counter::kIsIterationInvariantRate | benchmark::Counter::kInvert);
}

// The loop is the same for every container; Find returns the value for key.
template <class Find>
static void run_lookups(benchmark::State& state, const Data& d, Find find) {
    std::size_t i = 0;
    for (auto _ : state) {
        Value v = find(d.lookups[i]);
        benchmark::DoNotOptimize(v);
        i = (i + 1) & (kLookups - 1);
    }
    set_ns_per_lookup(state);
}

static void BM_Map(benchmark::State& state) {
    const auto d = make_data(static_cast<std::size_t>(state.range(0)));
    std::map<Key, Value> m;
    for (auto k : d.keys) m.emplace(k, k ^ 1);

    run_lookups(state, d, [&](Key k) { return m.find(k)->second; });
}

static void BM_Unordered(benchmark::State& state) {
    const auto d = make_data(static_cast<std::size_t>(state.range(0)));
    std::unordered_map<Key, Value> m;
    for (auto k : d.keys) m.emplace(k, k ^ 1);

    run_lookups(state, d, [&](Key k) { return m.find(k)->second; });
}

static void BM_Flat(benchmark::State& state) {
    const auto d = make_data(static_cast<std::size_t>(state.range(0)));
    std::vector<std::pair<Key, Value>> v;
    for (auto k : d.keys) v.emplace_back(k, k ^ 1);
    std::sort(v.begin(), v.end());

    run_lookups(state, d, [&](Key k) {
        auto it = std::lower_bound(v.begin(), v.end(), k,
                                   [](const auto& p, Key key) { return p.first < key; });
        return it->second;
    });
}

// Same sorted vector, but a branchless lower_bound: each step picks the
// half with a conditional move instead of a jump, so there's nothing to
// mispredict. (Each step of std::lower_bound is a 50/50 branch on random
// keys, like branchy.cpp at 50%.)
static void BM_FlatBranchless(benchmark::State& state) {
    const auto d = make_data(static_cast<std::size_t>(state.range(0)));
    std::vector<std::pair<Key, Value>> v;
    for (auto k : d.keys) v.emplace_back(k, k ^ 1);
    std::sort(v.begin(), v.end());

    run_lookups(state, d, [&](Key k) {
        const std::pair<Key, Value>* base = v.data();
        std::size_t len = v.size();
        while (len > 1) {
            const std::size_t half = len / 2;
            base = base[half].first < k ? base + half : base;  // cmov, not a jump
            len -= half;
        }
        return (base + (base->first < k))->second;
    });
}

static void BM_Linear(benchmark::State& state) {
    const auto d = make_data(static_cast<std::size_t>(state.range(0)));
    std::vector<std::pair<Key, Value>> v;
    for (auto k : d.keys) v.emplace_back(k, k ^ 1);

    run_lookups(state, d, [&](Key k) {
        auto it = std::find_if(v.begin(), v.end(), [k](const auto& p) { return p.first == k; });
        return it->second;
    });
}

#define SIZES ->ArgName("n")->Arg(16)->Arg(256)->Arg(4096)->Arg(65536)->Arg(1 << 20)

BENCHMARK(BM_Map)->Name("map") SIZES;
BENCHMARK(BM_Unordered)->Name("unordered") SIZES;
BENCHMARK(BM_Flat)->Name("flat") SIZES;
BENCHMARK(BM_FlatBranchless)->Name("flat_branchless") SIZES;
BENCHMARK(BM_Linear)->Name("linear")->ArgName("n")->Arg(16)->Arg(256)->Arg(4096);
