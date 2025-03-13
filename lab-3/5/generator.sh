# Создайте пару скриптов: генератор и обработчик. 
# Процесс «Генератор» передает информацию процессу «Обработчик» с помощью именованного канала. 
#
# Процесс «Обработчик» должен осуществлять следующую обработку переданных строк: 
# если строка содержит единственный символ «+», то процесс обработчик переключает режим на «сложение» 
# и ждет ввода численных данных. 
# Если строка содержит единственный символ «*», то обработчик переключает режим на «умножение» 
# и ждет ввода численных данных. 
# Если строка содержит целое число, то обработчик осуществляет текущую активную операцию
# (выбранный режим) над текущим значением вычисляемой переменной и считанным значением
# (например, складывает или перемножает результат предыдущего вычисления со считанным числом). 
#
# При запуске скрипта режим устанавливается в «сложение», а вычисляемая переменная приравнивается к 1. 
# В случае получения строки QUIT скрипт «Обработчик» выдает сообщение о плановой остановке и оба
# скрипта завершают работу. 
# В случае получения любых других значений строки оба скрипта завершают работу с сообщением 
# об ошибке входных данных.

#!/bin/bash

PIPE="pipe"

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

