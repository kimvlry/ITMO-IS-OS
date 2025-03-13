#!/bin/bash

PIPE="pipe"
if [ ! -p "$PIPE" ]; then
    mkfifo "$PIPE"
fi

read() {
    if read message <"$PIPE"; then 
        if [[ $message == "TERM" ]]; then       
            echo "they exit chat"
            break
        fi
        echo "THEM: $message"
    fi    
}

write() {
    echo "enter your message:"
    read message
    if [[ $message == "TERM" ]]; then
        echo $message>$PIPE
        break
    fi
    echo "$message">$PIPE
}    

echo "USER2 is connected">$PIPE
echo "enter TERM to exit chat"

while true; do
    read
    write
done 

rm -rf $PIPE
