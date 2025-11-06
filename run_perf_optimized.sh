#!/bin/bash

# Script to run performance analysis with perf on optimized version

# Check and fix perf_event_paranoid setting
CURRENT_PARANOID=$(cat /proc/sys/kernel/perf_event_paranoid 2>/dev/null)
if [ -z "$CURRENT_PARANOID" ]; then
    echo "Warning: Cannot read perf_event_paranoid. You may need to run with sudo."
elif [ "$CURRENT_PARANOID" -gt 1 ]; then
    echo "Warning: perf_event_paranoid is set to $CURRENT_PARANOID"
    echo "Attempting to set it to -1 (requires sudo)..."
    sudo sysctl -w kernel.perf_event_paranoid=-1 2>/dev/null
    if [ $? -eq 0 ]; then
        echo "✓ perf_event_paranoid set to -1"
    else
        echo "⚠ Failed to set perf_event_paranoid. Please run manually:"
        echo "  sudo sysctl -w kernel.perf_event_paranoid=-1"
        echo "Or run this script with sudo."
    fi
fi

echo "Compiling optimized program..."
g++ -O0 -g -o performance_test_optimized performance_test_optimized.cpp

if [ $? -ne 0 ]; then
    echo "Compilation error!"
    exit 1
fi

echo "Running perf record on optimized version..."
# Use higher frequency and ensure we capture samples
perf record -g -F 1000 --call-graph dwarf ./performance_test_optimized

echo "Generating perf report..."
perf report > perf_report_optimized.txt 2>&1

# Check if we have samples
if [ ! -f "perf.data" ] || [ ! -s "perf.data" ]; then
    echo "⚠ Warning: perf.data is empty or missing!"
    echo "The program may have run too fast. Try increasing workload or sampling frequency."
    exit 1
fi

echo "Saving perf output for FlameGraph..."
perf script > perf_script_optimized.out 2>&1

# Check if script output has content
if [ ! -s "perf_script_optimized.out" ]; then
    echo "⚠ Warning: perf_script_optimized.out is empty!"
    echo "No samples were captured. The program may need to run longer."
    exit 1
fi

SAMPLE_COUNT=$(wc -l < perf_script_optimized.out 2>/dev/null || echo "0")
echo "Captured $SAMPLE_COUNT samples"

echo "✓ Analysis complete!"
echo "Generated files:"
echo "  - perf_report_optimized.txt: perf report"
echo "  - perf_script_optimized.out: output for FlameGraph ($SAMPLE_COUNT samples)"

