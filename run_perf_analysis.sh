#!/bin/bash

# Script to run performance analysis with perf

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

echo "Compiling program..."
g++ -O0 -g -o performance_test performance_test.cpp

if [ $? -ne 0 ]; then
    echo "Compilation error!"
    exit 1
fi

echo "Running perf record..."
perf record -g -F 99 ./performance_test

echo "Generating perf report..."
perf report > perf_report.txt

echo "Saving perf output for FlameGraph..."
perf script > perf_script.out

echo "✓ Analysis complete!"
echo "Generated files:"
echo "  - perf_report.txt: perf report"
echo "  - perf_script.out: output for FlameGraph"

