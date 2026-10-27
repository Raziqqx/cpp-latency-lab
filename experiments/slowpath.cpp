// Stage 4, experiment 1: slowpath removal (Carl Cook, "When a Microsecond
// Is an Eternity", CppCon 2017).
//
// Same order checks written two ways:
//   chain  if (errA) handleA(); else if (errB) handleB(); ... else send();
//          one branch per check, error handling mixed into the hot path
//   flags  compute all checks into one bitmask without branching, then
//          if (!flags) send(); else handle_errors(flags);
//          one branch on the hot path
// Each in two versions: error handlers forced inline (their code sits in
// the hot function) or noinline (moved out to separate functions).
//
// The hot functions are noinline themselves, so each variant is a separate
// symbol: compare their sizes with
//   nm -C --size-sort build/slowpath | grep process_
//
// Arg = error rate per mille (0 = never, 10 = 1%, 100 = 10%).
//
// Prediction: flags+noinline fastest and smallest; chain+inline slowest.
// With 0 errors every branch is perfectly predicted, so the gap is small.
// It should grow at 10% errors, where the chain mispredicts more.

#include <benchmark/benchmark.h>

#include <cstddef>
#include <cstdint>
#include <cstdio>
#include <cstring>
#include <random>
#include <vector>

struct Order {
    std::int64_t price;   // in ticks
    std::int32_t qty;
    std::int32_t symbol;
};

constexpr std::int32_t kMaxQty = 10'000;
constexpr std::int32_t kNumSymbols = 500;
constexpr std::int64_t kMaxNotional = 50'000'000;

// --- Error handling (the slow path) ----------------------------------------
// Deliberately big (snprintf pulls in a lot of code), like real logging.

static char g_log[256];
static std::uint64_t g_errors;

[[gnu::always_inline]] inline void log_error(const Order& o, const char* what) {
    std::snprintf(g_log, sizeof g_log, "reject %s: px=%lld qty=%d sym=%d", what,
                  static_cast<long long>(o.price), o.qty, o.symbol);
    ++g_errors;
}

[[gnu::noinline]] void log_error_cold(const Order& o, const char* what) {
    log_error(o, what);
}

// Inline = handler code is pasted into the hot function.
template <bool Inline>
[[gnu::always_inline]] inline void on_error(const Order& o, const char* what) {
    if constexpr (Inline) log_error(o, what);
    else log_error_cold(o, what);
}

// --- The hot path ----------------------------------------------------------
// "Send": encode the order into a wire buffer and return a checksum.

// Not static: nothing in this file reads g_wire, so if it were static the
// compiler could prove the memcpy is a dead store and delete it (it did).
unsigned char g_wire[64];

[[gnu::always_inline]] inline std::uint32_t send(const Order& o) {
    std::memcpy(g_wire, &o, sizeof o);
    return static_cast<std::uint32_t>(o.price) ^ static_cast<std::uint32_t>(o.qty * 31 + o.symbol);
}

// --- Variant 1: if-else chain ----------------------------------------------

template <bool Inline>
[[gnu::noinline]] std::uint32_t process_chain(const Order& o) {
    if (o.price <= 0) on_error<Inline>(o, "price");
    else if (o.qty <= 0 || o.qty > kMaxQty) on_error<Inline>(o, "qty");
    else if (o.symbol < 0 || o.symbol >= kNumSymbols) on_error<Inline>(o, "symbol");
    else if (o.price * o.qty > kMaxNotional) on_error<Inline>(o, "notional");
    else return send(o);
    return 0;
}

// --- Variant 2: single flag check ------------------------------------------

enum : std::uint32_t { kBadPrice = 1, kBadQty = 2, kBadSymbol = 4, kBadNotional = 8 };

template <bool Inline>
[[gnu::always_inline]] inline void handle_errors(const Order& o, std::uint32_t flags) {
    if (flags & kBadPrice) on_error<Inline>(o, "price");
    if (flags & kBadQty) on_error<Inline>(o, "qty");
    if (flags & kBadSymbol) on_error<Inline>(o, "symbol");
    if (flags & kBadNotional) on_error<Inline>(o, "notional");
}

template <bool Inline>
[[gnu::noinline]] void handle_errors_cold(const Order& o, std::uint32_t flags) {
    handle_errors<Inline>(o, flags);
}

template <bool Inline>
[[gnu::noinline]] std::uint32_t process_flags(const Order& o) {
    // | on bools instead of || so every check is evaluated without branching.
    const std::uint32_t flags =
        (o.price <= 0) * kBadPrice |
        ((o.qty <= 0) | (o.qty > kMaxQty)) * kBadQty |
        ((o.symbol < 0) | (o.symbol >= kNumSymbols)) * kBadSymbol |
        (o.price * o.qty > kMaxNotional) * kBadNotional;

    if (!flags) return send(o);  // the only branch on the hot path

    if constexpr (Inline) handle_errors<Inline>(o, flags);
    else handle_errors_cold<Inline>(o, flags);
    return 0;
}

// --- Benchmarks ------------------------------------------------------------

// 4096 orders x 16 B = 64 KB: random, so the compiler can't predict them;
// error_permille of them break one random check.
static std::vector<Order> make_orders(int error_permille) {
    std::mt19937 gen(42);
    std::uniform_int_distribution<std::int64_t> px(100, 5'000);
    std::uniform_int_distribution<std::int32_t> qty(1, 1'000);
    std::uniform_int_distribution<std::int32_t> sym(0, kNumSymbols - 1);
    std::uniform_int_distribution<int> roll(0, 999);
    std::uniform_int_distribution<int> which(0, 3);

    std::vector<Order> v(4096);
    for (auto& o : v) {
        o = {px(gen), qty(gen), sym(gen)};
        if (roll(gen) < error_permille) {
            switch (which(gen)) {
                case 0: o.price = -1; break;
                case 1: o.qty = kMaxQty + 1; break;
                case 2: o.symbol = kNumSymbols; break;
                case 3: o.qty = kMaxQty; o.price = kMaxNotional; break;
            }
        }
    }
    return v;
}

template <std::uint32_t (*Process)(const Order&)>
static void BM_Process(benchmark::State& state) {
    const auto orders = make_orders(static_cast<int>(state.range(0)));
    std::size_t i = 0;
    for (auto _ : state) {
        benchmark::DoNotOptimize(Process(orders[i]));
        i = (i + 1) & (orders.size() - 1);  // size is a power of two: cheap wrap
    }
}

BENCHMARK(BM_Process<process_chain<true>>)->Name("chain/inline")->Arg(0)->Arg(10)->Arg(100);
BENCHMARK(BM_Process<process_chain<false>>)->Name("chain/noinline")->Arg(0)->Arg(10)->Arg(100);
BENCHMARK(BM_Process<process_flags<true>>)->Name("flags/inline")->Arg(0)->Arg(10)->Arg(100);
BENCHMARK(BM_Process<process_flags<false>>)->Name("flags/noinline")->Arg(0)->Arg(10)->Arg(100);
