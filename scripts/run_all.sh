#!/usr/bin/env bash
# Build in Release and run every experiment, pinned, with repetitions.
# Output (text + Google Benchmark JSON + machine info) goes to
# results/<hostname>-<timestamp>/.
#
# Usage: scripts/run_all.sh [cpu] [second_cpu]
#   cpu         CPU to pin single-threaded experiments to (default 2)
#   second_cpu  other CPU for false_sharing's second thread (default 4)
#   REPS=10 scripts/run_all.sh   more repetitions (default 5)
#
# Takes ~5-10 minutes. Close other programs and plug in the laptop first.

set -euo pipefail
cd "$(dirname "$0")/.."

CPU=${1:-2}
CPU2=${2:-4}
REPS=${REPS:-5}
OUT="results/$(hostname)-$(date +%Y%m%d-%H%M%S)"
mkdir -p "$OUT"

echo "== build (Release)"
cmake -B build -DCMAKE_BUILD_TYPE=Release > /dev/null
cmake --build build -j "$(nproc)"

echo "== machine info -> $OUT/machine.txt"
{
    echo "date:      $(date -Is)"
    echo "git:       $(git rev-parse --short HEAD 2>/dev/null || echo none)$(git diff --quiet 2>/dev/null || echo ' (uncommitted changes)')"
    echo "cpu:       $(lscpu | sed -n 's/^Model name: *//p')"
    echo "kernel:    $(uname -r)"
    echo "compiler:  $(c++ --version | head -1)"
    echo "tsc:       $(dmesg 2>/dev/null | grep -o 'tsc: Detected .*' | head -1 || true)"
    if grep -qi microsoft /proc/version; then
        echo "WSL2:      yes (Hyper-V guest: no perf hardware counters, extra noise)"
    fi
    echo "pinned to: cpu $CPU (false_sharing: cpus $CPU and $CPU2), repetitions: $REPS"
    echo
    lscpu
} > "$OUT/machine.txt"

# Google Benchmark experiments: median/mean/stddev/cv of REPS runs.
for exp in dno_bench slowpath vector_list aos_soa branchy virtual_crtp maps; do
    echo "== $exp"
    taskset -c "$CPU" "./build/$exp" \
        --benchmark_repetitions="$REPS" \
        --benchmark_report_aggregates_only=true \
        --benchmark_out="$OUT/$exp.json" \
        --benchmark_out_format=json \
        | tee "$OUT/$exp.txt"
done

# Own-main experiments (rdtsc percentiles, two threads).
echo "== tsc_overhead"
taskset -c "$CPU" ./build/tsc_overhead | tee "$OUT/tsc_overhead.txt"
echo "== tsc_sum"
taskset -c "$CPU" ./build/tsc_sum | tee "$OUT/tsc_sum.txt"
echo "== false_sharing"
./build/false_sharing "$CPU" "$CPU2" | tee "$OUT/false_sharing.txt"

echo
echo "done: $OUT"
