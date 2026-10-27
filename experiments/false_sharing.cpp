// Stage 4, experiment 7: false sharing.
//
// Two threads, each pinned to its own CPU, each incrementing ITS OWN
// counter. They never touch each other's data, but:
//   adjacent   both counters in the same 64 B cache line -> every write by
//              one core invalidates the line in the other core's cache,
//              and the line bounces between them
//   padded64   each counter alignas(64): its own cache line
//   padded128  each counter alignas(128): Intel's L2 "adjacent line"
//              prefetcher fetches lines in 128 B pairs, so 64 B apart can
//              still interfere a little
//   single     one thread alone: the no-contention baseline
// Each layout is run with two kinds of increment (see Op below): a plain
// load + store, and an atomic fetch_add.
//
// Usage: ./build/false_sharing [cpuA cpuB]   (default 2 4)
// Run it for two CPUs on different cores (2 4) and for two hyperthreads of
// the same core (2 3 in WSL's reported topology): siblings share an L1, so
// there's no line to bounce.
//
// Prediction (made with the store version only):
//   single / padded: ~0.3 ns per increment (a load + store per iteration)
//   adjacent: 10-30x slower (each write waits for the line to come back
//             from the other core, ~tens of ns)
//   siblings: no false-sharing penalty (same L1), but slower than single
//             because two threads share one core's execution units
// The store version then showed NO penalty, which is why fetch_add was added.

#include <algorithm>
#include <atomic>
#include <chrono>
#include <cstdint>
#include <cstdio>
#include <cstdlib>
#include <thread>
#include <vector>

#include <pthread.h>
#include <sched.h>

constexpr std::uint64_t kIters = 50'000'000;
constexpr int kReps = 5;

struct Adjacent {
    std::atomic<std::uint64_t> a{0};
    std::atomic<std::uint64_t> b{0};
};

template <std::size_t Align>
struct Padded {
    alignas(Align) std::atomic<std::uint64_t> a{0};
    alignas(Align) std::atomic<std::uint64_t> b{0};
};

static_assert(sizeof(Adjacent) == 16);
static_assert(sizeof(Padded<64>) == 128 && sizeof(Padded<128>) == 256);

static void pin_to(int cpu) {
    cpu_set_t set;
    CPU_ZERO(&set);
    CPU_SET(cpu, &set);
    if (pthread_setaffinity_np(pthread_self(), sizeof set, &set) != 0) {
        std::fprintf(stderr, "can't pin to cpu %d\n", cpu);
        std::exit(1);
    }
}

// Two ways to increment. Both are atomic so the compiler can't keep the
// counter in a register or merge the stores.
//   store: relaxed load + store = plain mov/add/mov, no locked instruction.
//          The store goes into the store buffer and the next load is
//          forwarded from there, so the core rarely waits for the line.
//   rmw:   fetch_add = lock add. A locked instruction needs the line in its
//          own cache AT THAT MOMENT and drains the store buffer first, so
//          every increment pays for wherever the line currently is.
enum class Op { Store, Rmw };

template <Op op>
static void count(std::atomic<std::uint64_t>& c) {
    for (std::uint64_t i = 0; i < kIters; ++i) {
        if constexpr (op == Op::Store)
            c.store(c.load(std::memory_order_relaxed) + 1, std::memory_order_relaxed);
        else
            c.fetch_add(1, std::memory_order_relaxed);
    }
}

// Runs one counter per thread on the given CPUs; returns ns per increment
// (wall time of the whole run / kIters).
template <Op op>
static double run(std::atomic<std::uint64_t>* a, std::atomic<std::uint64_t>* b, int cpu_a, int cpu_b) {
    std::atomic<int> ready{0};
    std::atomic<bool> go{false};

    auto worker = [&](std::atomic<std::uint64_t>* c, int cpu) {
        pin_to(cpu);
        ready.fetch_add(1);
        while (!go.load()) {}  // start both threads at the same moment
        count<op>(*c);
    };

    std::vector<std::thread> threads;
    threads.emplace_back(worker, a, cpu_a);
    if (b) threads.emplace_back(worker, b, cpu_b);

    const int n = b ? 2 : 1;
    while (ready.load() < n) {}
    const auto t0 = std::chrono::steady_clock::now();
    go.store(true);
    for (auto& t : threads) t.join();
    const auto t1 = std::chrono::steady_clock::now();

    return std::chrono::duration<double, std::nano>(t1 - t0).count() / kIters;
}

template <class Make>
static double median_of_reps(Make make_and_run) {
    std::vector<double> r(kReps);
    for (auto& x : r) x = make_and_run();
    std::sort(r.begin(), r.end());
    return r[kReps / 2];
}

struct Row {
    double single, adjacent, padded64, padded128;
};

template <Op op>
static Row measure(int cpu_a, int cpu_b) {
    {
        // Warm-up, discarded: whatever runs first paid for clock ramp-up
        // and was consistently slower before this was added.
        Padded<64> c;
        run<op>(&c.a, &c.b, cpu_a, cpu_b);
    }
    Row r;
    r.single = median_of_reps([&] {
        Adjacent c;
        return run<op>(&c.a, nullptr, cpu_a, cpu_b);
    });
    r.adjacent = median_of_reps([&] {
        Adjacent c;
        return run<op>(&c.a, &c.b, cpu_a, cpu_b);
    });
    r.padded64 = median_of_reps([&] {
        Padded<64> c;
        return run<op>(&c.a, &c.b, cpu_a, cpu_b);
    });
    r.padded128 = median_of_reps([&] {
        Padded<128> c;
        return run<op>(&c.a, &c.b, cpu_a, cpu_b);
    });
    return r;
}

int main(int argc, char** argv) {
    const int cpu_a = argc > 2 ? std::atoi(argv[1]) : 2;
    const int cpu_b = argc > 2 ? std::atoi(argv[2]) : 4;
    std::printf("cpus %d and %d, %llu increments per thread, median of %d\n\n", cpu_a, cpu_b,
                static_cast<unsigned long long>(kIters), kReps);

    const Row st = measure<Op::Store>(cpu_a, cpu_b);
    const Row rmw = measure<Op::Rmw>(cpu_a, cpu_b);

    std::printf("%-10s %12s %10s %12s %10s\n", "layout", "store ns/inc", "vs single", "rmw ns/inc",
                "vs single");
    auto line = [&](const char* name, double s, double r) {
        std::printf("%-10s %12.2f %9.1fx %12.2f %9.1fx\n", name, s, s / st.single, r, r / rmw.single);
    };
    line("single", st.single, rmw.single);
    line("adjacent", st.adjacent, rmw.adjacent);
    line("padded64", st.padded64, rmw.padded64);
    line("padded128", st.padded128, rmw.padded128);
    return 0;
}
