# Создайте и однократно выполните скрипт (в этом скрипте нельзя использовать условный оператор и операторы проверки свойств и значений), 
# который будет пытаться создать директорию test в домашней директории. Если создание директории пройдет успешно, скрипт выведет 
# в файл ~/report сообщение вида "catalog test was created successfully" и создаст в директории test файл с именем 
# Дата_Время_Запуска_Скрипта. 
# Затем независимо от результатов предыдущего шага скрипт должен опросить с помощью команды ping хост www.net_nikogo.ru и, если этот хост
# недоступен, дописать сообщение об ошибке в файл ~/report. Сообщение об ошибке должно начинаться с текущей Дата_Время, а затем содержать 
# через пробел произвольный текст сообщения об ошибке.

#!/bin/bash

timestamp=$(date +"%Y-%m-%d_%H:%M:%S")

mkdir /home/valerie/test 2>/dev/null && {
    echo 'catalog test was created successfully' >> /home/valerie/report;
    touch /home/valerie/test/$timestamp;
}

ping -c 1 www.net_nikogo.ru >/dev/null || echo "$timestamp host is unreachable" >> /home/valerie/report

# >2/dev/null: 2 stands for stderr
# 2>&1: redirect stderr contents to the stdout
