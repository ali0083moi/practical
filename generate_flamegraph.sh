#!/bin/bash

# Script to generate FlameGraph from perf output

if [ ! -f "perf_script.out" ]; then
    echo "Error: perf_script.out file not found!"
    echo "Please run run_perf_analysis.sh first."
    exit 1
fi

# Check if FlameGraph exists
if [ ! -d "FlameGraph" ]; then
    echo "Downloading FlameGraph..."
    git clone https://github.com/brendangregg/FlameGraph.git
fi

echo "Generating FlameGraph..."
cd FlameGraph
perf script | ./stackcollapse-perf.pl | ./flamegraph.pl > ../flamegraph_before.svg
cd ..

echo "✓ FlameGraph generated: flamegraph_before.svg"

