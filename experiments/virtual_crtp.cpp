// Stage 4, experiment 5: virtual dispatch vs CRTP.
//
// A handler turns each price tick into a value; the loop sums the values
// over n ticks (Arg: 4096 or 65536). The handler is called one of these ways:
//   virtual/known    virtual call, but the compiler can see the concrete
//                    type -> it devirtualises: no real virtual call
//   virtual/opaque   same object, but its pointer is passed through
//                    DoNotOptimize so the compiler can't know the type ->
//                    a real indirect call every tick (always the same target)
//   virtual/mixed    a different object per tick, two types in random
//                    order -> indirect call with an unpredictable target
//   crtp             static dispatch through a template base: the call is
//                    an ordinary inlined function
//   variant/mixed    std::variant of the two CRTP types, random order,
//                    std::visit: the usual alternative to virtual for a
//                    known, closed set of types
//   switch/mixed     same variants, dispatched by hand with if on index()
//
// Why two tick counts: the same random pattern repeats every iteration, and
// the branch predictor can learn a 4096-long pattern but not a 65536-long
// one. Only the 65536 rows show the cost of a truly unpredictable branch.
//
// Prediction (made before adding switch/mixed and the 65536 size):
//   known == crtp (both inlined, probably SIMD), fastest
//   opaque ~1-2 ns per tick: a call + return that can't be inlined, but
//          the target is always the same so it's predicted
//   mixed: much worse, ~half the indirect calls mispredict (~5 ns+)
//   variant/mixed: a switch instead of an indirect call, but the branch
//          is still random -> close to virtual/mixed

#include <benchmark/benchmark.h>

#include <cstddef>
#include <cstdint>
#include <random>
#include <variant>
#include <vector>


// --- Virtual ---------------------------------------------------------------

struct Handler {
    virtual ~Handler() = default;
    virtual std::int64_t on_tick(std::int32_t px) const = 0;
};

struct Fee : Handler {
    std::int64_t on_tick(std::int32_t px) const override { return px * 3LL + 7; }
};

struct Spread : Handler {
    std::int64_t on_tick(std::int32_t px) const override { return px * 2LL - 5; }
};

// --- CRTP ------------------------------------------------------------------
// The base calls the derived class's impl() through a static_cast: the
// type is known at compile time, so there's nothing to look up at runtime.

template <class Derived>
struct HandlerBase {
    std::int64_t on_tick(std::int32_t px) const {
        return static_cast<const Derived*>(this)->impl(px);
    }
};

struct FeeC : HandlerBase<FeeC> {
    std::int64_t impl(std::int32_t px) const { return px * 3LL + 7; }
};

struct SpreadC : HandlerBase<SpreadC> {
    std::int64_t impl(std::int32_t px) const { return px * 2LL - 5; }
};

// --- Data ------------------------------------------------------------------

static std::vector<std::int32_t> make_ticks(std::size_t n_ticks) {
    std::mt19937 gen(42);
    std::uniform_int_distribution<std::int32_t> px(100, 5'000);
    std::vector<std::int32_t> v(n_ticks);
    for (auto& x : v) x = px(gen);
    return v;
}

// true = Fee, false = Spread, random 50/50 per tick
static std::vector<bool> make_kinds(std::size_t n_ticks) {
    std::mt19937 gen(7);
    std::bernoulli_distribution coin(0.5);
    std::vector<bool> v(n_ticks);
    for (std::size_t i = 0; i < n_ticks; ++i) v[i] = coin(gen);
    return v;
}

static void set_ns_per_tick(benchmark::State& state, std::size_t n_ticks) {
    state.counters["ns/tick"] = benchmark::Counter(
        static_cast<double>(n_ticks),
        benchmark::Counter::kIsIterationInvariantRate | benchmark::Counter::kInvert);
}

// --- Benchmarks ------------------------------------------------------------

static void BM_VirtualKnown(benchmark::State& state) {
    const auto n_ticks = static_cast<std::size_t>(state.range(0));
    const auto ticks = make_ticks(n_ticks);
    Fee fee;
    const Handler& h = fee;  // compiler can see h is a Fee
    for (auto _ : state) {
        std::int64_t sum = 0;
        for (auto px : ticks) sum += h.on_tick(px);
        benchmark::DoNotOptimize(sum);
    }
    set_ns_per_tick(state, n_ticks);
}

static void BM_VirtualOpaque(benchmark::State& state) {
    const auto n_ticks = static_cast<std::size_t>(state.range(0));
    const auto ticks = make_ticks(n_ticks);
    Fee fee;
    const Handler* h = &fee;
    // DoNotOptimize on the pointer: the compiler must assume it may have
    // changed to point at anything, so it no longer knows the type.
    benchmark::DoNotOptimize(h);
    for (auto _ : state) {
        std::int64_t sum = 0;
        for (auto px : ticks) sum += h->on_tick(px);
        benchmark::DoNotOptimize(sum);
    }
    set_ns_per_tick(state, n_ticks);
}

static void BM_VirtualMixed(benchmark::State& state) {
    const auto n_ticks = static_cast<std::size_t>(state.range(0));
    const auto ticks = make_ticks(n_ticks);
    const auto kinds = make_kinds(n_ticks);
    Fee fee;
    Spread spread;
    std::vector<const Handler*> handlers(n_ticks);
    for (std::size_t i = 0; i < n_ticks; ++i)
        handlers[i] = kinds[i] ? static_cast<const Handler*>(&fee) : &spread;

    for (auto _ : state) {
        std::int64_t sum = 0;
        for (std::size_t i = 0; i < n_ticks; ++i) sum += handlers[i]->on_tick(ticks[i]);
        benchmark::DoNotOptimize(sum);
    }
    set_ns_per_tick(state, n_ticks);
}

static void BM_Crtp(benchmark::State& state) {
    const auto n_ticks = static_cast<std::size_t>(state.range(0));
    const auto ticks = make_ticks(n_ticks);
    FeeC fee;
    for (auto _ : state) {
        std::int64_t sum = 0;
        for (auto px : ticks) sum += fee.on_tick(px);
        benchmark::DoNotOptimize(sum);
    }
    set_ns_per_tick(state, n_ticks);
}

static void BM_VariantMixed(benchmark::State& state) {
    const auto n_ticks = static_cast<std::size_t>(state.range(0));
    const auto ticks = make_ticks(n_ticks);
    const auto kinds = make_kinds(n_ticks);
    std::vector<std::variant<FeeC, SpreadC>> handlers(n_ticks);
    for (std::size_t i = 0; i < n_ticks; ++i)
        if (!kinds[i]) handlers[i] = SpreadC{};

    for (auto _ : state) {
        std::int64_t sum = 0;
        for (std::size_t i = 0; i < n_ticks; ++i)
            sum += std::visit([&](const auto& h) { return h.on_tick(ticks[i]); }, handlers[i]);
        benchmark::DoNotOptimize(sum);
    }
    set_ns_per_tick(state, n_ticks);
}

// Same variants, but dispatched by hand on index() instead of std::visit.
// GCC 11's std::visit calls through a table of function pointers (an
// indirect call, like virtual); here both bodies are visible, inlinable code.
static void BM_SwitchMixed(benchmark::State& state) {
    const auto n_ticks = static_cast<std::size_t>(state.range(0));
    const auto ticks = make_ticks(n_ticks);
    const auto kinds = make_kinds(n_ticks);
    std::vector<std::variant<FeeC, SpreadC>> handlers(n_ticks);
    for (std::size_t i = 0; i < n_ticks; ++i)
        if (!kinds[i]) handlers[i] = SpreadC{};

    for (auto _ : state) {
        std::int64_t sum = 0;
        for (std::size_t i = 0; i < n_ticks; ++i) {
            if (handlers[i].index() == 0) sum += std::get<0>(handlers[i]).on_tick(ticks[i]);
            else sum += std::get<1>(handlers[i]).on_tick(ticks[i]);
        }
        benchmark::DoNotOptimize(sum);
    }
    set_ns_per_tick(state, n_ticks);
}

#define TICKS ->ArgName("ticks")->Arg(4096)->Arg(65536)

BENCHMARK(BM_VirtualKnown)->Name("virtual/known") TICKS;
BENCHMARK(BM_VirtualOpaque)->Name("virtual/opaque") TICKS;
BENCHMARK(BM_VirtualMixed)->Name("virtual/mixed") TICKS;
BENCHMARK(BM_Crtp)->Name("crtp") TICKS;
BENCHMARK(BM_VariantMixed)->Name("variant/mixed") TICKS;
BENCHMARK(BM_SwitchMixed)->Name("switch/mixed") TICKS;
