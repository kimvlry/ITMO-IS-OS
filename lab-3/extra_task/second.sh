#!/bin/bash

PIPE="pipe"
if [ ! -p "$PIPE" ]; then
    mkfifo "$PIPE"
fi

trap 'rm -rf "$PIPE"' EXIT

read_message() {
    while true; do
        if read message <"$PIPE"; then
            if [[ $message == "TERM" ]]; then
                echo "USER 1 exits chat"
                break
            fi
            echo "USER1: $message"
        fi
    done
    exit 0
}

write_message{
    echo -n "enter message: "
    while true; do
        read message
        if [[ $message == "TERM" ]]; then
            echo "$message" >"$PIPE"
            break
        fi
        echo "$message" >"$PIPE"
    done
    exit 0
}

echo "chat is running"
echo "enter 'TERM' to exit"

write_message &
read_message &

wait

rm -f "$PIPE"
