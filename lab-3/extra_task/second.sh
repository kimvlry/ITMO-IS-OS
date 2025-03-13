#!/bin/bash

PIPE="pipe"
if [ ! -p "$PIPE" ]; then
    mkfifo "$PIPE"
fi

trap 'rm -f "$PIPE"; exit' EXIT SIGINT

read_messages() {
    while true; do
        if read -t 1 message <"$PIPE"; then
            if [[ -n $message ]]; then
                if [[ "$message" == "TERM" ]]; then
                    echo "USER1 exited the chat."
                    break
                fi
                echo "USER1: $message"
            fi
        fi
    done
}

send_messages() {
    while true; do
        echo -n "Your message: "
        read message
        if [[ -n $message ]]; then
            if [[ "$message" == "TERM" ]]; then
                echo "$message" >"$PIPE"
                break
            fi
            echo "$message" >"$PIPE"
        fi
    done
}

echo "Chat started. Type 'TERM' to exit."

read_messages &
send_messages

