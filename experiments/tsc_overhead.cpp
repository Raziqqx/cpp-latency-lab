// Stage 3: how much does the timer itself cost?
//
// Times an empty tsc_start() -> tsc_end() pair many times and prints the
// distribution. This is the floor: every later measurement includes it.
//
// Plain main(), not a Google Benchmark: we want every individual sample,
// not an average. (benchmark_main is still linked by CMake, but our main()
// takes priority, so it never runs.)

#include "tsc.hpp"

#include <algorithm>
#include <cstddef>
#include <cstdint>
#include <cstdio>
#include <vector>

int main() {
    // Step 1: how many TSC ticks per nanosecond (expect ~2.80 on this machine).
    const double ticks_per_ns = tsc_calibrate();
    std::printf("TSC: %.4f ticks/ns (%.1f MHz)\n\n", ticks_per_ns, ticks_per_ns * 1000.0);

    // Step 2: allocate every sample up front. push_back inside the loop would
    // occasionally reallocate and copy, adding fake outliers to the tail.
    constexpr std::size_t kSamples = 100'000;
    constexpr std::size_t kWarmup = 1'000;
    std::vector<std::uint64_t> samples(kSamples);

    // Step 3: warm-up. The first runs pay one-off costs (cold instruction
    // cache, clock ramping up, untouched pages). Discard them.
    for (std::size_t i = 0; i < kWarmup; ++i) {
        const auto a = tsc_start();
        const auto b = tsc_end();
        (void)a;
        (void)b;
    }

    // Step 4: the measurement. Nothing between start and end, so each sample
    // is the cost of the timer itself.
    for (std::size_t i = 0; i < kSamples; ++i) {
        const auto a = tsc_start();
        const auto b = tsc_end();
        samples[i] = b - a;
    }

    // Step 5: sort so percentiles are just indexes.
    std::sort(samples.begin(), samples.end());

    // Step 6: percentile p (0.0 - 1.0) -> sample at index p * (n - 1).
    auto pct = [&](double p) {
        const auto idx = static_cast<std::size_t>(p * static_cast<double>(samples.size() - 1));
        return samples[idx];
    };

    // Step 7: print ticks and ns side by side.
    auto row = [&](const char* name, std::uint64_t ticks) {
        std::printf("%-6s %8llu ticks %10.1f ns\n", name,
                    static_cast<unsigned long long>(ticks),
                    static_cast<double>(ticks) / ticks_per_ns);
    };

    std::printf("%zu samples (after %zu warm-up)\n", kSamples, kWarmup);
    row("min", samples.front());
    row("p50", pct(0.50));
    row("p99", pct(0.99));
    row("p99.9", pct(0.999));
    row("max", samples.back());

    return 0;
}
