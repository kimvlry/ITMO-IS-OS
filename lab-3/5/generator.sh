#!/bin/bash

PIPE="../pipe"

echo "select mode ('+' for addititon or '*' for multiplication),"
echo "input numerical operand (basic mode is '+')"
echo "or type 'QUIT' to exit app"

while true; do
    read INPUT
    if [[ "$INPUT" =~ ^[0-9]+$ ]] || [[ "$INPUT" == "+" ]] || [[ "$INPUT" == "*" ]]; then
        echo "$INPUT" > $PIPE
    elif [[ "$INPUT" == "QUIT" ]]; then
        echo "QUIT" > $PIPE
        echo "quitting generator"
        break
    else 
        echo "INVALID" > $PIPE
        echo "quitting generator"
        break
    fi
done

