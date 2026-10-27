#pragma once
#include <x86intrin.h>
#include <stdint.h>
#include <chrono>

inline uint64_t tsc_start(){
    _mm_lfence();
    uint64_t ret = __rdtsc();
    _mm_lfence();
    return ret;
} 


inline uint64_t tsc_end(){
    unsigned int i{};
    uint64_t ret = __rdtscp(&i);
    _mm_lfence();
    return ret;
} 

inline double tsc_calibrate(){

    unsigned int aux{};
    auto t0 = std::chrono::steady_clock::now();
    uint64_t c0 =  __rdtscp(&aux);

    
    // Busy-wait ~100 ms
    while (std::chrono::steady_clock::now() - t0 < std::chrono::milliseconds(100)) {
        // spin
    }
    
    uint64_t c1 = __rdtscp(&aux);   // serializing read
    auto t1 = std::chrono::steady_clock::now();

    // Elapsed time in nanoseconds (double for fractional ns)
    double elapsed_ns = std::chrono::duration<double, std::nano>(t1 - t0).count();

    // TSC ticks per nanosecond
    return static_cast<double>(c1 - c0) / elapsed_ns;
}