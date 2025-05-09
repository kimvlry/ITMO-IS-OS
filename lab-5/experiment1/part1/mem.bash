# Подготовительный этап:
# 1. Создайте скрипт mem.bash, реализующий следующий сценарий.
# 2. Скрипт выполняет бесконечный цикл.
# 3. Перед началом выполнения цикла создается пустой массив и счетчик шагов, инициализированный нулем.
# 4. На каждом шаге цикла в конец массива добавляется последовательность из 10 элементов, например: 
#    (1 2 3 4 5 6 7 8 9 10).
# 5. Каждый 100000-ый шаг в файл report.log добавляется строка с текущим значением размера массива.
# 6. Перед запуском скрипта файл report.log обнуляется.
#
#
# Первый этап:
# Задача – оценить изменения параметров, выводимых утилитой top в процессе работы созданного скрипта.
# 
# Ход эксперимента:
# 1. Запустите созданный скрипт mem.bash. Дождитесь аварийной остановки процесса и вывода в консоль
#    последних сообщений системного журнала.
# 2. Зафиксируйте в отчете последнюю запись журнала - значения параметров, с которыми произошла 
#    аварийная остановка процесса. Также зафиксируйте значение в последней строке файла report.log.
# 3. Подготовьте две консоли. В первой запустите утилиту top. Во второй запустите скрипт и 
#    переключитесь на первую консоль. Убедитесь, что в top появился запущенный скрипт.
# 4. Наблюдайте за следующими значениями (и фиксируйте их изменения во времени в отчете):
#    - значения параметров памяти системы (верхние две строки над основной таблицей);
#    i
#    - значения параметров в строке таблицы, соответствующей работающему скрипту;
#    - изменения в верхних пяти процессах (как меняется состав и позиции этих процессов).
# 5. Проводите наблюдения и фиксируйте их в отчете до аварийной остановки процесса скрипта и его 
#    исчезновения из перечня процессов в top.
# 6. Посмотрите с помощью команды `dmesg | grep "mem.bash"` последние две записи о скрипте в системном 
#    журнале и зафиксируйте их в отчете. Также зафиксируйте значение в последней строке файла report.log.
#
#
#
# !/bin/bash

report="report.log"
top_log="top.log"

> $report
> $top_log

counter=0
declare -a arr 

(
    while true; do
        echo "$(date)" >> $top_log
        top -b -n 1 | head -n 12 >> $top_log
        echo -e "\n" >> $top_log
        sleep 1
    done
) & 
top_pid=$!

trap 'kill $top_pid' EXIT

while true;  do
    arr+=(1 2 3 4 5 6 7 8 9 10)
    counter=$((counter + 1))
    if ((counter % 10000 == 0)); then 
        echo "step: $counter, arr size: ${#arr[@]}" >> $report
    fi
done 

