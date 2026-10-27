// Stage 4, experiment 4: branchy vs branchless.
//
// Loop: sum every element >= 128 of an array of ints in [0, 256).
//   branchy    if (x >= 128) sum += x;   compiled as a real conditional jump
//   branchless sum += x & mask;           mask is all ones or all zeros,
//                                         computed without a jump
//   compiler   the plain if-version, compiled however GCC -O3 likes
//
// GCC -O3 removes the branch from the plain if-version by itself (it turns
// it into SIMD compares + masks), which would make branchy and branchless
// identical. To measure a real branch, branchy and branchless are compiled
// with vectorisation and if-conversion switched off via the optimize
// attribute. "compiler" shows what you'd get without that.
//
// Arg = percent of elements >= 128, in random order (0, 1, 10, 25, 50),
// or 101 = 50% but SORTED (all small values first, then all big ones).
// 32 Ki ints = 128 KB (L2), the same data for every variant.
//
// Prediction:
//   branchy:    fast at 0% / 1% / sorted (predictable), worst at 50%
//               random: half the branches mispredict, ~15-20 cycles each
//   branchless: the same at every percent and order, a bit slower than
//               branchy at 0% (always does the and + add)
//   compiler:   fastest everywhere (SIMD, no branch)

#include <benchmark/benchmark.h>

#include <algorithm>
#include <cstddef>
#include <cstdint>
#include <random>
#include <vector>

constexpr std::size_t kN = 32 * 1024;
constexpr int kSorted = 101;

static std::vector<int> make_data(int pct_big) {
    std::mt19937 gen(42);
    std::uniform_int_distribution<int> small(0, 127), big(128, 255), roll(0, 99);
    const int pct = pct_big == kSorted ? 50 : pct_big;

    std::vector<int> v(kN);
    for (auto& x : v) x = roll(gen) < pct ? big(gen) : small(gen);
    if (pct_big == kSorted) std::sort(v.begin(), v.end());
    return v;
}

#define NO_AUTO_BRANCHLESS \
    __attribute__((noinline, optimize("no-tree-vectorize", "no-if-conversion", "no-if-conversion2")))

NO_AUTO_BRANCHLESS long long sum_branchy(const int* p, std::size_t n) {
    long long sum = 0;
    for (std::size_t i = 0; i < n; ++i)
        if (p[i] >= 128) sum += p[i];
    return sum;
}

NO_AUTO_BRANCHLESS long long sum_branchless(const int* p, std::size_t n) {
    long long sum = 0;
    for (std::size_t i = 0; i < n; ++i) {
        // (p[i] - 128) >> 31 is all ones if p[i] < 128, else zero
        // (arithmetic shift of a negative int). Invert it: keep the big ones.
        const int mask = ~((p[i] - 128) >> 31);
        sum += p[i] & mask;
    }
    return sum;
}

[[gnu::noinline]] long long sum_compiler(const int* p, std::size_t n) {
    long long sum = 0;
    for (std::size_t i = 0; i < n; ++i)
        if (p[i] >= 128) sum += p[i];
    return sum;
}

template <long long (*Sum)(const int*, std::size_t)>
static void BM_Sum(benchmark::State& state) {
    const auto data = make_data(static_cast<int>(state.range(0)));
    for (auto _ : state) {
        auto s = Sum(data.data(), data.size());
        benchmark::DoNotOptimize(s);
    }
    state.counters["ns/elem"] = benchmark::Counter(
        static_cast<double>(kN),
        benchmark::Counter::kIsIterationInvariantRate | benchmark::Counter::kInvert);
}

#define ARGS ->ArgName("pct_big")->Arg(0)->Arg(1)->Arg(10)->Arg(25)->Arg(50)->Arg(kSorted)

BENCHMARK(BM_Sum<sum_branchy>)->Name("branchy") ARGS;
BENCHMARK(BM_Sum<sum_branchless>)->Name("branchless") ARGS;
BENCHMARK(BM_Sum<sum_compiler>)->Name("compiler") ARGS;
