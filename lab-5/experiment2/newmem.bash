#!/bin/bash

N=$1
if [ -z "$1" ]; then
    echo "pass N"
    exit
fi

declare -a arr

while true;  do
    if (( ${#arr[@]} > $N )); then
        echo "arr size reached $N"
        exit
    fi
    arr+=(1 2 3 4 5 6 7 8 9 10)
done 

