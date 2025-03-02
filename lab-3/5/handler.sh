#!/bin/bash

PIPE="../pipe"
MODE="+"
NUM=1

while true; do
    read INPUT < $PIPE
    if [[ "$INPUT" == "INVALID" ]] || [[ "$INPUT" == "QUIT" ]] ; then
        echo "quitting handler"
        break
    else
        case $INPUT in
            "+")
                MODE="+"
                ;;
            "*")
                MODE="*"
                ;;
            *)
                case $MODE in 
                    "+")
                        NUM=$((NUM+INPUT))
                        echo "$NUM"
                        ;;
                    "*")
                        NUM=$((NUM*INPUT))
                        echo "$NUM"
                        ;;
                    *)
                        ;;
                esac
        esac
    fi
done


