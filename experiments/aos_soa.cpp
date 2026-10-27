// Stage 4, experiment 3: Array of Structs vs Struct of Arrays.
//
// Sum ONE field (qty) over n records, stored two ways:
//   AoS  std::vector<Record>: each record's fields sit together, so the
//        qty values are spread out, one per record
//   SoA  one std::vector per field: all qty values sit together
//
// AoS is run with two record sizes to show the cost grows with how much
// unused data sits between the values you want:
//   AoS/16  16 B record ( 4 B qty + 12 B other fields): 4 per cache line
//   AoS/64  64 B record ( 4 B qty + 60 B other fields): 1 per cache line,
//           a realistic size for an order or a market-data quote
//   SoA      4 B per qty: 16 per cache line
//
//   elements   SoA       AoS/16    AoS/64
//   1 Ki       4 KB      16 KB     64 KB    (L1 48 KB, L2 2 MB)
//   64 Ki      256 KB    1 MB      4 MB     (L3 24 MB)
//   1 Mi       4 MB      16 MB     64 MB
//   4 Mi       16 MB     64 MB     256 MB   (RAM)
//
// Prediction:
//   SoA:    ~0.13 ns/elem everywhere (same as the Stage 2 vector sum)
//   AoS/16: ~4x SoA once out of L1 (4x the bytes per useful value)
//   AoS/64: ~16x SoA in RAM (a whole cache line per value), and no
//           SIMD in any case because the values aren't adjacent

#include <benchmark/benchmark.h>

#include <cstddef>
#include <cstdint>
#include <numeric>
#include <random>
#include <vector>

template <std::size_t Bytes>
struct Record {
    std::int32_t qty;
    char other[Bytes - sizeof(std::int32_t)];  // stands in for price, symbol, timestamps...
};
static_assert(sizeof(Record<16>) == 16 && sizeof(Record<64>) == 64);

// Same random qty values for every layout (fixed seed), so the sums match.
static std::vector<std::int32_t> make_qty(std::size_t n) {
    std::mt19937 gen(42);
    std::uniform_int_distribution<std::int32_t> dis(1, 1'000);

    std::vector<std::int32_t> v(n);
    for (auto& x : v) x = dis(gen);
    return v;
}

static void set_ns_per_elem(benchmark::State& state, std::size_t n) {
    state.counters["ns/elem"] = benchmark::Counter(
        static_cast<double>(n),
        benchmark::Counter::kIsIterationInvariantRate | benchmark::Counter::kInvert);
}

template <std::size_t Bytes>
static void BM_AoS(benchmark::State& state) {
    const auto n = static_cast<std::size_t>(state.range(0));
    const auto qty = make_qty(n);

    std::vector<Record<Bytes>> records(n);  // value-initialised: other[] is zeros
    for (std::size_t i = 0; i < n; ++i) records[i].qty = qty[i];

    for (auto _ : state) {
        long long sum = 0;
        for (const auto& r : records) sum += r.qty;
        benchmark::DoNotOptimize(sum);
    }
    set_ns_per_elem(state, n);
}

static void BM_SoA(benchmark::State& state) {
    const auto n = static_cast<std::size_t>(state.range(0));
    // In a real SoA there'd be more vectors (price, symbol, ...). The sum
    // only touches this one, so they'd never be loaded.
    const auto qty = make_qty(n);

    for (auto _ : state) {
        long long sum = 0;
        for (auto q : qty) sum += q;
        benchmark::DoNotOptimize(sum);
    }
    set_ns_per_elem(state, n);
}

// 1 Ki to 4 Mi elements, x4 per step.
BENCHMARK(BM_SoA)->RangeMultiplier(4)->Range(1 << 10, 1 << 22);
BENCHMARK(BM_AoS<16>)->Name("BM_AoS/16B")->RangeMultiplier(4)->Range(1 << 10, 1 << 22);
BENCHMARK(BM_AoS<64>)->Name("BM_AoS/64B")->RangeMultiplier(4)->Range(1 << 10, 1 << 22);
