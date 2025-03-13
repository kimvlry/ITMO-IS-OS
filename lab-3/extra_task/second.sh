#!/bin/bash

PIPE="pipe"
if [ ! -p "$PIPE" ]; then
    mkfifo "$PIPE"
fi

read() {
    while true; do
        if read message <"$PIPE"; then 
            if [[ $message == "TERM" ]]; then       
                echo "they exit chat"
                break
            fi
            echo "THEM: $message"
        fi
    done
}

write() {
    while true; do
        echo "enter your message:"
        read message
        if [[ $message == "TERM" ]]; then
            echo $message>$PIPE
            break
        fi
        echo "$message">$PIPE
    done
}    

echo "USER2 is connected">$PIPE
echo "enter TERM to exit chat"

read & 
write & 

wait 
rm -rf $PIPE
