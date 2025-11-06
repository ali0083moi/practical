#!/bin/bash

# Script to fix perf permissions
# This script adjusts perf_event_paranoid to allow perf to work

echo "Checking current perf_event_paranoid setting..."
CURRENT=$(cat /proc/sys/kernel/perf_event_paranoid 2>/dev/null)

if [ -z "$CURRENT" ]; then
    echo "Error: Cannot read /proc/sys/kernel/perf_event_paranoid"
    echo "Please run this script with sudo or as root."
    exit 1
fi

echo "Current value: $CURRENT"

if [ "$CURRENT" -gt 1 ]; then
    echo "Setting perf_event_paranoid to -1 (requires sudo)..."
    sudo sysctl -w kernel.perf_event_paranoid=-1
    
    if [ $? -eq 0 ]; then
        echo "✓ Successfully set perf_event_paranoid to -1"
        echo ""
        echo "To make this permanent, add the following to /etc/sysctl.conf:"
        echo "  kernel.perf_event_paranoid = -1"
        echo ""
        echo "Or run:"
        echo "  echo 'kernel.perf_event_paranoid = -1' | sudo tee -a /etc/sysctl.conf"
        echo "  sudo sysctl -p"
    else
        echo "✗ Failed to set perf_event_paranoid"
        exit 1
    fi
else
    echo "✓ perf_event_paranoid is already set to $CURRENT (acceptable)"
fi

