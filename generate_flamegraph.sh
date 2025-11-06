#!/bin/bash

# Script to generate FlameGraph from perf output

# Check if FlameGraph exists
if [ ! -d "FlameGraph" ]; then
    echo "Downloading FlameGraph..."
    git clone https://github.com/brendangregg/FlameGraph.git
fi

# Determine input source
if [ -f "perf_script.out" ]; then
    echo "Using perf_script.out file..."
    INPUT_SOURCE="perf_script.out"
elif [ -f "perf.data" ]; then
    echo "Using perf.data file (generating script output)..."
    perf script > perf_script.out 2>/dev/null
    if [ $? -eq 0 ] && [ -f "perf_script.out" ]; then
        INPUT_SOURCE="perf_script.out"
    else
        echo "Error: Failed to generate perf_script.out from perf.data"
        exit 1
    fi
else
    echo "Error: Neither perf_script.out nor perf.data found!"
    echo "Please run run_perf_analysis.sh first."
    exit 1
fi

echo "Generating FlameGraph from $INPUT_SOURCE..."
cd FlameGraph
cat ../$INPUT_SOURCE | ./stackcollapse-perf.pl | ./flamegraph.pl > ../flamegraph_before.svg
cd ..

if [ -f "flamegraph_before.svg" ]; then
    FILE_SIZE=$(stat -f%z flamegraph_before.svg 2>/dev/null || stat -c%s flamegraph_before.svg 2>/dev/null || echo "0")
    if [ "$FILE_SIZE" -gt 0 ]; then
        echo "✓ FlameGraph generated successfully: flamegraph_before.svg"
    else
        echo "✗ Error: Generated FlameGraph file is empty"
        exit 1
    fi
else
    echo "✗ Error: Failed to generate FlameGraph"
    exit 1
fi

