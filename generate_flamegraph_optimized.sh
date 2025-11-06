#!/bin/bash

# Script to generate FlameGraph from optimized perf output

# Check if FlameGraph exists
if [ ! -d "FlameGraph" ]; then
    echo "Downloading FlameGraph..."
    git clone https://github.com/brendangregg/FlameGraph.git
fi

# Determine input source
if [ -f "perf_script_optimized.out" ]; then
    echo "Using perf_script_optimized.out file..."
    INPUT_SOURCE="perf_script_optimized.out"
elif [ -f "perf.data" ]; then
    echo "Using perf.data file (generating script output)..."
    perf script > perf_script_optimized.out 2>/dev/null
    if [ $? -eq 0 ] && [ -f "perf_script_optimized.out" ]; then
        INPUT_SOURCE="perf_script_optimized.out"
    else
        echo "Error: Failed to generate perf_script_optimized.out from perf.data"
        exit 1
    fi
else
    echo "Error: Neither perf_script_optimized.out nor perf.data found!"
    echo "Please run run_perf_optimized.sh first."
    exit 1
fi

echo "Generating FlameGraph from $INPUT_SOURCE..."
cd FlameGraph
cat ../$INPUT_SOURCE | ./stackcollapse-perf.pl | ./flamegraph.pl > ../flamegraph_after.svg
cd ..

if [ -f "flamegraph_after.svg" ]; then
    FILE_SIZE=$(stat -f%z flamegraph_after.svg 2>/dev/null || stat -c%s flamegraph_after.svg 2>/dev/null || echo "0")
    if [ "$FILE_SIZE" -gt 0 ]; then
        echo "✓ FlameGraph generated successfully: flamegraph_after.svg"
    else
        echo "✗ Error: Generated FlameGraph file is empty"
        exit 1
    fi
else
    echo "✗ Error: Failed to generate FlameGraph"
    exit 1
fi

