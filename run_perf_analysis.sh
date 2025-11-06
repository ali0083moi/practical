#!/bin/bash

# Script to run performance analysis with perf

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

