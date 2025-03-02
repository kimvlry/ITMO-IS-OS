#!/bin/bash

echo $$ > "handlerPID.txt"
MODE="+"
NUM=1

addition() { MODE="+" }
multiplication() { MODE="*" }
termination() {
    echo "quitting handler"
    exit 0
}

trap 'addition' USR1
trap 'multiplication' USR2
trap 'termination' TERM

while true; do
    sleep 1

    case "$MODE" in 
        "+")
            NUM=$((NUM+2))
            ;;
        "*")
            NUM=$((NUM*2))
            ;;
        *)
            ;;
    esac
done
