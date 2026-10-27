// Stage 4, experiment 2: vector vs list traversal.
//
// Same values, same sum, three memory layouts:
//   vector         contiguous ints, 4 B each
//   list/inorder   std::list built by push_back in a fresh process: malloc
//                  hands out nodes one after another, so they sit in memory
//                  in traversal order
//   list/shuffled  same list after sort(): sort relinks nodes without moving
//                  them, so following next pointers jumps around memory
//
// Sizes go from L1 to RAM. A list node is ~32 B (two pointers + int +
// padding + malloc header), so a list needs ~8x the memory of a vector:
//   elements   vector    list
//   1 Ki       4 KB      32 KB    both in L1 (48 KB)
//   16 Ki      64 KB     512 KB   L2 (2 MB)
//   256 Ki     1 MB      8 MB     vector L2, list L3 (24 MB)
//   4 Mi       16 MB     128 MB   vector L3, list RAM
//
// ns/elem column = time per element (lower is better).
//
// Prediction:
//   vector:        ~0.12 ns/elem at every size (SIMD + prefetcher, as Stage 2)
//   list/inorder:  ~1 ns/elem: one dependent pointer load per element, no
//                  SIMD, but addresses are sequential so the prefetcher helps
//   list/shuffled: same as inorder in L1, then much worse each cache level,
//                  ~50-100 ns/elem in RAM (every node a cache miss)

#include <benchmark/benchmark.h>

#include <cstdint>
#include <list>
#include <numeric>
#include <random>
#include <vector>

// Random values (fixed seed): the compiler can't pre-compute the sum, and
// sorting by value gives a random traversal order.
static std::vector<int> make_values(std::size_t n) {
    std::mt19937 gen(42);
    std::uniform_int_distribution<int> dis(1, 1'000'000);

    std::vector<int> v(n);
    for (auto& x : v) x = dis(gen);
    return v;
}

static void set_ns_per_elem(benchmark::State& state, std::size_t n) {
    // Rate (per second) of n elements per iteration, inverted -> seconds per
    // element, printed with an SI prefix (e.g. "1.2n" = 1.2 ns).
    state.counters["ns/elem"] = benchmark::Counter(
        static_cast<double>(n),
        benchmark::Counter::kIsIterationInvariantRate | benchmark::Counter::kInvert);
}

static void BM_Vector(benchmark::State& state) {
    const auto n = static_cast<std::size_t>(state.range(0));
    const auto data = make_values(n);

    for (auto _ : state) {
        long long sum = std::accumulate(data.begin(), data.end(), 0LL);
        benchmark::DoNotOptimize(sum);
    }
    set_ns_per_elem(state, n);
}

static void BM_ListInOrder(benchmark::State& state) {
    const auto n = static_cast<std::size_t>(state.range(0));
    const auto values = make_values(n);
    const std::list<int> data(values.begin(), values.end());

    for (auto _ : state) {
        long long sum = std::accumulate(data.begin(), data.end(), 0LL);
        benchmark::DoNotOptimize(sum);
    }
    set_ns_per_elem(state, n);
}

static void BM_ListShuffled(benchmark::State& state) {
    const auto n = static_cast<std::size_t>(state.range(0));
    const auto values = make_values(n);
    std::list<int> data(values.begin(), values.end());
    data.sort();  // relinks nodes by value: memory order != traversal order

    for (auto _ : state) {
        long long sum = std::accumulate(data.begin(), data.end(), 0LL);
        benchmark::DoNotOptimize(sum);
    }
    set_ns_per_elem(state, n);
}

// 1 Ki to 4 Mi elements, x4 per step.
BENCHMARK(BM_Vector)->RangeMultiplier(4)->Range(1 << 10, 1 << 22);
BENCHMARK(BM_ListInOrder)->RangeMultiplier(4)->Range(1 << 10, 1 << 22);
BENCHMARK(BM_ListShuffled)->RangeMultiplier(4)->Range(1 << 10, 1 << 22);
