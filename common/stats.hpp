#pragma once
// Percentile summary for per-sample TSC timings.
//
// Usage:
//   std::vector<std::uint64_t> samples(n);   // fill with tsc_end() - tsc_start()
//   print_header();
//   print_row("label", summarise(samples), ticks_per_ns);

#include <algorithm>
#include <cstddef>
#include <cstdint>
#include <cstdio>
#include <vector>

struct Percentiles {
    std::uint64_t min, p50, p99, p999, max;  // in TSC ticks
};

// Sorts samples in place (so percentiles are just indexes) and picks them out.
inline Percentiles summarise(std::vector<std::uint64_t>& samples) {
    std::sort(samples.begin(), samples.end());

    // percentile p (0.0 - 1.0) -> sample at index p * (n - 1)
    auto pct = [&](double p) {
        const auto idx = static_cast<std::size_t>(p * static_cast<double>(samples.size() - 1));
        return samples[idx];
    };
    return {samples.front(), pct(0.50), pct(0.99), pct(0.999), samples.back()};
}

inline void print_header() {
    std::printf("%-14s %9s %9s %9s %9s %11s %10s\n",
                "", "min ns", "p50 ns", "p99 ns", "p99.9 ns", "max ns", "p99.9/p50");
}

// One row, converted from ticks to ns. The last column is the tail ratio.
inline void print_row(const char* label, const Percentiles& p, double ticks_per_ns) {
    auto ns = [&](std::uint64_t ticks) { return static_cast<double>(ticks) / ticks_per_ns; };
    std::printf("%-14s %9.1f %9.1f %9.1f %9.1f %11.1f %9.2fx\n",
                label, ns(p.min), ns(p.p50), ns(p.p99), ns(p.p999), ns(p.max),
                static_cast<double>(p.p999) / static_cast<double>(p.p50));
}
