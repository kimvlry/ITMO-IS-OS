#!/bin/bash

PIPE="pipe"
if [ ! -p "$PIPE" ]; then
    mkfifo "$PIPE"
fi

trap 'rm -f "$PIPE"; exit' EXIT SIGINT

read_messages() {
    while true; do
        if read -t 1 message <"$PIPE"; then
            if [[ "$message" == "TERM" ]]; then
                echo "USER2 exited the chat."
                break
            fi
            echo "USER2: $message"
        fi
    done
}

send_messages() {
    while true; do
        echo -n "Your message: "
        read message
        if [[ "$message" == "TERM" ]]; then
            echo "$message" >"$PIPE"
            break
        fi
        echo "$message" >"$PIPE"
    done
}

echo "Chat started. Type 'TERM' to exit."

read_messages &
send_messages &

wait
