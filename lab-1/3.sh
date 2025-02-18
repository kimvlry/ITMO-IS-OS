#! /bin/bash
# Создать текстовое меню с четырьмя пунктами. При вводе пользователем номера пункта меню
#происходит запуск редактора nano, редактора vi, браузера links или выход из меню.

menu="choose the option:
    1. open nano
    2. open vi
    3. open links browser
    4. exit"
echo "$menu"

while true;
do 
    read option
    case $option in
        1)
            nano
            ;;
        2) 
            vi
            ;;
        3)
            links
            ;;
        4)
            break
            ;;
        *)
            echo "invalid input."
            echo "$menu"
            ;;
    esac
done


