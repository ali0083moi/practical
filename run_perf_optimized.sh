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
perf record -g -F 99 ./performance_test_optimized

echo "Generating perf report..."
perf report > perf_report_optimized.txt

echo "Saving perf output for FlameGraph..."
perf script > perf_script_optimized.out

echo "✓ Analysis complete!"
echo "Generated files:"
echo "  - perf_report_optimized.txt: perf report"
echo "  - perf_script_optimized.out: output for FlameGraph"

