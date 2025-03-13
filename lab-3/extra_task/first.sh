#!/bin/bash

PIPE="pipe"
if [ ! -p "$PIPE" ]; then
    mkfifo "$PIPE"
fi

read_message() {
    while true; do
        if read -t 1 message <"$PIPE"; then
            if [[ $message == "TERM" ]]; then
                echo "Пользователь 2 вышел из чата."
                break
            fi
            echo "Пользователь 2: $message"
        fi
    done
    exit 0
}

write_message() {
    while true; do
        echo "Введите ваше сообщение:"
        read message
        if [[ $message == "TERM" ]]; then
            echo "$message" >"$PIPE"
            break
        fi
        echo "$message" >"$PIPE"
    done
    exit 0
}

echo "Пользователь 1 подключен к чату."
echo "Введите 'TERM', чтобы выйти из чата."

read_message &
write_message &

wait

rm -f "$PIPE"
