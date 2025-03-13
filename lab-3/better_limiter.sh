#!/bin/bash

if [ ! -f "PIDs.txt" ]; then
    echo "no PIDs.txt"
    exit 1
fi

first=$(head -n 1 "PIDs.txt")
third=$(sed -n '3p' "PIDs.txt")

ps -p "$first" || { echo "first process not found"; exit 1; }
ps -p "$third" || { echo "third process not found"; exit 1; }

percent_limit=10

slice_name="first_process.slice"
echo "[Slice]
CPUQuota=${percent_limit}%" | sudo tee /etc/systemd/system/$slice_name
sudo systemctl daemon-reload
sudo systemctl set-property --runtime --pid=$first CPUQuota=${percent_limit}%

echo "Limited process $first to $percent_limit% CPU"
kill "$third" >/dev/null 2>&1 && echo "Killed process $third" || echo "Failed to kill process $third"

{
    while true; do
        cpu_usage=$(top -bn1 -p $first | tail -n +8 | awk '{print $9}')
        echo "Process $first CPU usage: $cpu_usage%"
        sleep 5
    done
} &
