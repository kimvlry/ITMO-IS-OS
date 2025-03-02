#!/bin/bash
if [ ! -f "PIDs.txt" ]; then
    echo "no PIDs.txt"
    exit 1
fi

first=$(head -n 1 "PIDs.txt")
third=$(head -n 3 "PIDs.txt")

if [ ! ps -p "$first" ] >/dev/null; then
    echo "first proccess not found"
    exit 1
fi

if [ ! ps -p "$third" ] >/dev/null; then
    echo "third proccess not found"
    exit 1
fi

percent_limit=10
while true; do
    cpu_usage=$(ps -p "$first" -o %cpu --no-headers)
    if (( $(bc <<< "$cpu_usage > $percent_limit") )); then
        renice -n 10 -p "$first"
    else 
        echo "all good"
        break
    fi
done
echo "less 10"

kill -9 "$third"
echo "killed 3"

