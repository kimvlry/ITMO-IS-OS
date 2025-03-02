#!/bin/bash

while true; do 
    let x=2*2;
done &
echo $! > PIDs.txt

while true; do
    let x=2*2;
done &
echo $! >> PIDs.txt

while true; do
    let x=2*2;
done &

echo $! >> PIDs.txt
