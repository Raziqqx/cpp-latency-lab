// Stage 3 checkpoint: does the tail grow when the timed region gets longer?
//
// Times one sum of an int array per sample, with our own rdtsc timer, at
// sizes from L1 to beyond L2. Prints percentiles and the p99.9/p50 ratio.
// The "empty" row is the timer's own cost (see tsc_overhead.cpp).
//
// Prediction (write yours before running):
//   p50 grows with size; the p99.9/p50 ratio grows too, because a longer
//   region gives interrupts more chances to land inside it.

#include "stats.hpp"
#include "tsc.hpp"

#include <benchmark/benchmark.h>  // only for benchmark::DoNotOptimize

#include <cstddef>
#include <cstdint>
#include <cstdio>
#include <numeric>
#include <random>
#include <vector>

constexpr std::size_t kSamples = 100'000;
constexpr std::size_t kWarmup = 1'000;

// Same idea as make_data in dno_bench.cpp: random, so the compiler can't
// pre-compute the sum; fixed seed, so runs are comparable.
static std::vector<int> make_data(std::size_t n) {
    std::mt19937 gen(42);
    std::uniform_int_distribution<int> dis(1, 100);

    std::vector<int> v(n);
    for (auto& x : v) x = dis(gen);
    return v;
}

// Times the sum of an n-int array kSamples times, one sample per sum.
static Percentiles time_sum(std::size_t n) {
    const auto data = make_data(n);
    std::vector<std::uint64_t> samples(kSamples);

    auto one_sum = [&] {
        const auto a = tsc_start();
        long long sum = std::accumulate(data.begin(), data.end(), 0LL);
        // Keeps the sum alive. Its "memory" clobber also forces the sum to be
        // recomputed every iteration instead of hoisted out of the loop.
        benchmark::DoNotOptimize(sum);
        const auto b = tsc_end();
        return b - a;
    };

    for (std::size_t i = 0; i < kWarmup; ++i) one_sum();
    for (std::size_t i = 0; i < kSamples; ++i) samples[i] = one_sum();

    return summarise(samples);
}

static Percentiles time_empty() {
    std::vector<std::uint64_t> samples(kSamples);
    for (std::size_t i = 0; i < kSamples; ++i) {
        const auto a = tsc_start();
        const auto b = tsc_end();
        samples[i] = b - a;
    }
    return summarise(samples);
}

int main() {
    const double ticks_per_ns = tsc_calibrate();
    std::printf("TSC %.4f ticks/ns, %zu samples per row\n\n", ticks_per_ns, kSamples);

    print_header();
    print_row("empty", time_empty(), ticks_per_ns);

    // 256 B and 4 KB fit in L1 (48 KB), 64 KB and 1 MB in L2 (2 MB).
    for (std::size_t n : {64u, 1024u, 16384u, 262144u}) {
        char label[32];
        std::snprintf(label, sizeof label, "sum %zu", n);
        print_row(label, time_sum(n), ticks_per_ns);
    }
    return 0;
}
