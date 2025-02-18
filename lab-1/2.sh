#! /bin/bash 
# Считывать строки с клавиатуры, пока не будет введена строка "q". 
# После этого вывести последовательность считанных строк в виде одной строки.

ans=""

while true;
do 
    read line 
	if [[ $line == "q" ]];
		then break;
	fi;
	ans+="$line "
done

echo "$ans"
