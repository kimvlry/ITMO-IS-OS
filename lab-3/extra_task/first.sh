#!/bin/bash

PIPE="pipe"
if [ ! -p "$PIPE" ]; then
    mkfifo "$PIPE"
fi

read_message() {
    while true; do
        if read message <"$PIPE"; then
            if [[ $message == "TERM" ]]; then
                echo "USER 2 exits chat."
                break
            fi
            echo "USER 2: $message"
        fi
    done
    exit 0
}

write_message() {
    while true; do
        echo "enter message:"
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

read_message &
write_message &

wait

rm -f "$PIPE"
