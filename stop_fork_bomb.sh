#!/bin/bash

# Script to stop Fork Bomb
# This script finds and kills all fork_bomb processes

echo "Searching for fork_bomb processes..."

# Find all fork_bomb processes
PIDS=$(pgrep -f fork_bomb)

if [ -z "$PIDS" ]; then
    echo "No fork_bomb processes found."
    exit 0
fi

echo "Found processes: $PIDS"
echo "Stopping processes..."

# Kill all processes
for PID in $PIDS; do
    echo "Killing PID: $PID"
    kill -9 $PID 2>/dev/null
done

# Wait a bit
sleep 1

# Check again
REMAINING=$(pgrep -f fork_bomb)
if [ -z "$REMAINING" ]; then
    echo "✓ All fork_bomb processes stopped."
else
    echo "⚠ Some processes are still running: $REMAINING"
    echo "Retrying with killall..."
    killall -9 fork_bomb 2>/dev/null
fi

