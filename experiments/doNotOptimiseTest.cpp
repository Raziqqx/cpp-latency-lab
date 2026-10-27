// Part 1: watch the compiler delete unused work, in the assembly.
//
// This is a plain main(), not a Google Benchmark: nothing is timed.
// The point is to compare two builds with objdump:
//   asm line commented out  -> results/no_dno.s  (sum deleted, no vpaddq)
//   asm line active         -> results/dno.s     (vectorised sum loop survives)
// Rebuild between the two, or both dumps come from the same binary.

#include <random>
#include <array>
#include <algorithm>
#include <numeric>

// Hand-rolled version of benchmark::DoNotOptimize.
// asm volatile("" ...) emits no instructions, but the compiler can't see
// inside it, so it must assume the asm does something with its inputs:
//   "r,m"(value)  value is an input, in a register or in memory, so it has
//                 to be computed and actually exist there
//   "memory"      the asm may read or write any memory, so pending stores
//                 must happen first (this part is what ClobberMemory does)
//   volatile      don't delete or move the asm, even though it has no outputs
//
// template <class T>
// inline void doNotOptimise(T const& value) {
//     asm volatile("" : : "r,m"(value) : "memory");
// }

int main() {

    // First attempt: a loop the compiler can work out at compile time.
    // Even with doNotOptimise, counter is just the constant 5, so the loop
    // folds away. Keeping the result alive doesn't help if the input is known.
    //
    // int a = 5, counter = 0;
    // while (a > 0) {
    //     counter++;
    //     a--;
    // }
    //
    // doNotOptimise(counter);

    // constexpr: std::array's size is a template argument, so it must be
    // known at compile time.
    constexpr int N = 1000;
    std::array<int,N> arr;

    // Random values from random_device, so the compiler can't know the data
    // and pre-compute the sum. random_device reads from the OS, which the
    // compiler can't prove is side-effect free, so this part is never deleted.
    std::random_device rd;
    std::mt19937 gen(rd());
    std::uniform_int_distribution<> dis(1,100);

    std::generate(arr.begin(), arr.end(), [&](){return dis(gen);});

    // 0LL makes accumulate add in long long, so each int is widened to 64 bits
    // (vpmovsxdq) before being added (vpaddq).
    long long sum = std::accumulate(arr.begin(),arr.end(),0LL);

    // Same trick as doNotOptimise, written inline. Comment this line out and
    // the sum above disappears from the assembly, because nothing reads it.
    asm volatile("" :: "r,m"(sum) : "memory");

    return 0;
}
