#!/bin/bash

HANDLER_PID=$(cat handlerPID.txt)

echo "select mode ('+' for addititon or '*' for multiplication),"
echo "or type 'TERM' to exit app"

while true; do
    read INPUT
    case $INPUT in
        "+")
            kill -USR1 "$HANDLER_PID"
            ;;
        "*")
            kill -USR2 "$HANDLER_PID"
            ;;
        "TERM")
            kill -TERM "$HANDLER_PID"
            ;;
        *)
            ;;
    esac
done

