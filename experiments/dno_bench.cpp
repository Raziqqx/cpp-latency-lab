// Stage 2: how benchmarks lie.
//
// Two benchmarks do the same work: sum a vector of random ints.
//   BM_SumDiscarded       throws the result away -> the compiler deletes the sum
//   BM_SumDoNotOptimize   passes the result to DoNotOptimize -> the sum survives
//
// There is no main() here. CMake links benchmark::benchmark_main, which
// provides one that runs every BENCHMARK(...) registered below.

#include <benchmark/benchmark.h>

#include <numeric>
#include <random>
#include <vector>

// Setup shared by both benchmarks. Runs outside the timed loop.
// The values are random so the compiler can't know them at compile time
// and pre-compute the sum (the constant-input trap).
static std::vector<int> make_data(std::size_t n) {
    std::mt19937 gen(42);  // fixed seed: same data every run, so runs are comparable
    std::uniform_int_distribution<int> dis(1, 100);

    std::vector<int> v(n);
    for (auto& x : v) x = dis(gen);
    return v;
}

static void BM_SumDiscarded(benchmark::State& state) {
    // --- setup (not timed) ---
    const auto data = make_data(static_cast<std::size_t>(state.range(0)));

    // --- timed loop: the library picks how many times to run this ---
    for (auto _ : state) {
        long long sum = std::accumulate(data.begin(), data.end(), 0LL);
        (void)sum;  // silences the "unused variable" warning, does NOT keep the work
    }
}

static void BM_SumDoNotOptimize(benchmark::State& state) {
    const auto data = make_data(static_cast<std::size_t>(state.range(0)));

    for (auto _ : state) {
        long long sum = std::accumulate(data.begin(), data.end(), 0LL);
        benchmark::DoNotOptimize(sum);  // compiler must assume sum is read
    }
}

// Sizes from 64 to 1M ints (256 B to 4 MB), multiplying by 8 each step.
// If a benchmark really does the work, its time should grow with the size.
BENCHMARK(BM_SumDiscarded)->Range(64, 1 << 20);
BENCHMARK(BM_SumDoNotOptimize)->Range(64, 1 << 20);
