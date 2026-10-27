# cpp-latency-lab

Small, focused C++ experiments on what makes code fast or slow at the
nanosecond level: caches, branch prediction, memory layout, dispatch and
false sharing. Each one measures averages with Google Benchmark, and the
rdtsc tools in `common/` measure p50/p99/p99.9 tails.

For every experiment I wrote a prediction first, then measured, then
explained the result from the assembly. Several predictions were wrong;
those are listed under [What surprised me](#what-surprised-me).

## Machine

| | |
|---|---|
| CPU | Intel Core i5-14500HX (6 P-cores + 8 E-cores, 20 threads) |
| Caches | L1d 48 KB, L2 2 MB per core, L3 24 MB shared |
| TSC | 2803.2 MHz, invariant (`constant_tsc`, `nonstop_tsc`) |
| OS | Ubuntu 22.04 on **WSL2** (kernel 6.6.114.1-microsoft-standard-WSL2) |
| Compiler | GCC 11.4, `-O3 -march=native` (Release) |

**WSL2 caveats.** These numbers come from a Hyper-V virtual machine, which
affects them in four ways:
- `perf` only has software events. The hypervisor doesn't pass through the
  CPU's hardware counters (`dmesg`: *"no PMU driver, software events only"*),
  so cache-miss and branch-miss explanations here come from assembly and
  timing, not from counters.
- The hypervisor adds noise: occasional pauses of 10–100 µs show up in the
  max and p99.9 columns.
- WSL reports a fake CPU topology (10 identical cores × 2 threads), so
  `taskset` can't choose a P-core over an E-core.
- A full run is about 10–20% slower than single experiments run on their
  own, probably because the laptop gets hot and lowers its clock speed.

I plan to rerun everything on a bare-metal Linux server with hardware
counters.

## Reproduce

Requires Linux (or WSL2), CMake ≥ 3.20, a C++20 compiler and Git. Google
Benchmark is downloaded automatically by CMake.

```bash
git clone <this repo> && cd cpp-latency-lab
scripts/run_all.sh            # builds in Release, runs everything pinned to cpu 2
```

It takes about 8 minutes. Results (text, JSON and `machine.txt`) go to
`results/<hostname>-<timestamp>/`. Options: `scripts/run_all.sh <cpu>
<second_cpu>`, and `REPS=10` for more repetitions (default 5). Close other
programs and plug in the laptop before running.

Run one experiment:

```bash
cmake -B build -DCMAKE_BUILD_TYPE=Release && cmake --build build -j
taskset -c 2 ./build/maps --benchmark_repetitions=5 --benchmark_report_aggregates_only=true
```

## Layout

```
common/tsc.hpp       rdtsc timer: lfence;rdtsc;lfence ... rdtscp;lfence, plus calibration
common/stats.hpp     sort samples, print min/p50/p99/p99.9/max and the tail ratio
experiments/*.cpp    one executable per file (added to the build automatically)
scripts/run_all.sh   build + run everything + save results
results/             saved runs
```

## Experiments and results

All results are medians of 5 repetitions, pinned to one CPU, from
`results/DESKTOP-R7JI5EA-20261028-002151/`.

### 1. Benchmarks lie: `dno_bench`, `doNotOptimiseTest`

*Does discarding a result let the compiler delete the work you're timing?*

| sum of n ints | result thrown away | `DoNotOptimize(result)` |
|---|---|---|
| 64 | 0.000 ns | 9.6 ns |
| 4096 | 0.000 ns | 582 ns |
| 1 Mi | 0.000 ns | 181 µs |

The discarded version takes the same time at every size: the compiler
deleted the timed loop's body completely. You can prove it in three ways:
the time is physically impossible, it doesn't scale with size, and the
assembly between `StartKeepRunning` and `FinishKeepRunning` is empty.

### 2. Timer cost and tails: `tsc_overhead`, `tsc_sum`

*What does the rdtsc timer itself cost, and why is p99.9 sometimes many times the median?*

| region | p50 | p99.9 | max | p99.9 / p50 |
|---|---|---|---|---|
| empty (timer only) | 21.8 ns | 37.1 ns | 41 µs | 1.7× |
| sum of 1 Ki ints | 169 ns | 281 ns | 75 µs | 1.7× |
| sum of 16 Ki ints | 1.96 µs | 20.6 µs | 150 µs | **10.5×** |
| sum of 256 Ki ints | 31.8 µs | 168 µs | 4.0 ms | 5.3× |

The timer itself costs about 20 ns, so only regions much longer than that
are worth timing individually. The tail ratio peaks at a middle length. The
chance of an interrupt landing inside the region grows with its length, but
how much the interruption hurts is about (work + interruption) / work.

### 3. Slowpath removal: `slowpath`

*Is one flag check plus an out-of-line error handler faster than an if-else chain of error checks?*

| ns per order | 0% errors | 1% errors | 10% errors |
|---|---|---|---|
| if-else chain, handler inlined | **2.2** | 3.8 | 20.1 |
| if-else chain, `noinline` handler | 2.8 | 4.7 | 23.2 |
| single flag, handler inlined | 4.2 | 6.3 | 22.6 |
| single flag, `noinline` handler | 4.1 | 5.9 | 25.4 |

**My prediction was wrong.** Branches that are always predicted correctly
are nearly free, and the flag version does more arithmetic (about 25
instructions vs about 17). Inlining the handler into the flag version
forces `push rbp; push rbx` onto the hot path. The talk's advice still
applies in a real system with cold caches and many branches, which a tight
benchmark loop can't reproduce.

### 4. Vector vs list traversal: `vector_list`

*How much does memory layout alone change the cost of summing the same values?*

| ns per element | 1 Ki | 64 Ki | 1 Mi | 4 Mi |
|---|---|---|---|---|
| `vector` | 0.13 | 0.16 | 0.16 | 0.26 |
| `list`, nodes in memory order | 1.9 | 3.4 | 4.5 | 4.8 |
| `list`, nodes shuffled | 2.0 | 15.3 | 123 | **151** |

Following list pointers is a chain of dependent loads (about 13× slower
than the vector even in L1). Shuffling the nodes also stops the prefetcher
from helping. After that, the cost per element is just the latency of
whichever cache level, or RAM, holds the list.

### 5. AoS vs SoA: `aos_soa`

*Is summing one field faster when that field's values are stored together (SoA) than inside 16 B or 64 B structs (AoS)?*

| ns per element | 1 Ki | 64 Ki | 1 Mi | 4 Mi |
|---|---|---|---|---|
| SoA (4 B values) | 0.13 | 0.16 | 0.17 | 0.22 |
| AoS, 16 B records | 0.48 | 0.46 | 0.92 | 1.22 |
| AoS, 64 B records | 0.45 | 1.57 | 3.97 | **3.84** |

There are two separate effects. In cache, AoS is about 3× slower because it
loses SIMD: GCC either produces a scalar loop or spends about 14 shuffle
instructions for every 8 records. Out of cache, it's limited by bandwidth:
AoS/64 uses 4 of the 64 bytes in each cache line it loads, which works out
to about 17 GB/s of mostly wasted traffic.

### 6. Branchy vs branchless: `branchy`

*How much does an unpredictable branch cost, and when does removing it pay off?*

| ns per element | 0% | 10% | 50% random | 50% sorted |
|---|---|---|---|---|
| branchy (real `jle`) | 0.37 | 1.88 | **5.05** | 0.41 |
| branchless (`sar` + `andn`) | 0.56 | 0.55 | 0.56 | 0.57 |
| plain code, GCC `-O3` | 0.15 | 0.16 | 0.16 | 0.14 |

The percentages are the share of elements that pass the `if`. A mispredict
costs about 8–9 ns here. At `-O3`, GCC removes the branch by itself and
vectorizes the loop. To get a real branch for comparison, I had to turn off
vectorization and if-conversion with
`__attribute__((optimize("no-tree-vectorize","no-if-conversion")))`.

### 7. Virtual vs CRTP: `virtual_crtp`

*What does a virtual call cost compared to static dispatch, and how much of that is not knowing the call target?*

| ns per call (65536 calls) | |
|---|---|
| virtual, type visible to compiler (devirtualized) | 0.19 |
| CRTP | 0.18 |
| virtual through an opaque pointer, one type | 1.66 |
| switch on `variant::index()`, 2 types in random order | 5.5 |
| `std::visit`, 2 types in random order | 8.6 |
| virtual, 2 types in random order | 9.0 |

To stop the compiler devirtualizing the call, pass the pointer through
`benchmark::DoNotOptimize(ptr)`. Then the compiler can't know the
object's type. Once the compiler can see the type, a virtual call costs
nothing extra. The cost comes from blocking inlining (and with it SIMD) and
from unpredictable call targets. GCC 11's `std::visit` is still an indirect
call through a table of function pointers.

### 8. Map comparison: `maps`

*Which container gives the fastest lookup of existing keys, from 16 entries up to 1 Mi?*

| ns per lookup | 16 | 256 | 4 Ki | 64 Ki | 1 Mi |
|---|---|---|---|---|---|
| `std::map` | 25 | 54 | 102 | 284 | 1075 |
| `std::unordered_map` | 5.3 | 12.4 | **13.6** | **17.8** | **33.7** |
| sorted vector + `std::lower_bound` | 24 | 54 | 80 | 139 | 344 |
| sorted vector + branchless binary search | **5.0** | **9.9** | 19.2 | 49.8 | 242 |
| unsorted vector, linear scan | 15 | 44 | 506 | | |

`std::lower_bound` is slow even when everything is in L1, because every
step of the search is a 50/50 branch that mispredicts about half the time.
Choosing each half with a conditional move (`cmov`) instead makes it 4–5×
faster, and it beats the hash map up to a few hundred entries.

### 9. False sharing: `false_sharing`

*Do two threads slow each other down when they write to different variables that happen to share a cache line?*

| ns per increment (cpus 2 + 4) | plain load + store | `fetch_add` |
|---|---|---|
| one thread | 0.38 | 6.3 |
| two threads, counters in the same cache line | 0.38 | **23.6** |
| two threads, `alignas(64)` | 0.33 | 5.9 |
| two threads, `alignas(128)` | 0.32 | 5.9 |

With `fetch_add`, sharing a cache line makes each increment about 4×
slower, and padding the counters to separate lines removes the penalty.
**With plain stores there's no penalty at all.** The store buffer absorbs
the writes, the next load is answered from the store buffer, and a single
transfer of the cache line covers many buffered stores. An atomic
read-modify-write must own the line at the moment it executes, so it can't
hide the transfers this way.

## What surprised me

1. **The if-else chain beat the "optimized" single-flag check** (`slowpath`).
   Correctly predicted branches are almost free, so the extra arithmetic in
   the flag version cost more than it saved.
2. **`std::lower_bound` loses mostly to branch mispredicts, not to cache
   misses** (`maps`). A branchless binary search was 4–5× faster on the same
   sorted data.
3. **The branch predictor learned my "random" data** (`virtual_crtp`). The
   same 4096-element random pattern repeated on every benchmark iteration,
   and the predictor memorized it (1.1 ns per call vs 5.5 ns with 65536
   elements). Test data that repeats isn't random to the CPU.
4. **Plain stores don't show false sharing; atomic read-modify-writes do**
   (`false_sharing`).
5. **The compiler removed things I wanted to measure, four times:** the sum
   I didn't use (`dno_bench`), a `memcpy` to a `static` buffer that nothing
   read (`slowpath`), the branch in `branchy` (it vectorized it), and the
   virtual call when the type was visible (`virtual_crtp`). Each time, the
   assembly is what showed it.
6. **A freshly built `std::list` is unrealistically fast** (`vector_list`),
   because malloc happens to place its nodes in order. After a shuffle it
   was 30× slower in RAM.

## Next

- Rerun on bare-metal Linux with `perf stat` hardware counters
  (branch-misses, cache-misses, dTLB misses), using the real P-core and
  hyperthread layout.
- Follow-up experiments: an open-addressing hash map, the Eytzinger memory
  layout for binary search, a reader/writer version of false sharing, and a
  test of `slowpath` with a cold instruction cache.
