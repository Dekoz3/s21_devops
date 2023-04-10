# Linux Monitoring v1.0

1. [Проба пера](#1-проба-пера)
2. [Исследование системы](#2-исследование-системы)
3. [Визуальное оформление вывода для скрипта исследования системы](#3-визуальное-оформление-вывода-для-скрипта-исследования-системы)


### 1. [Проба пера](#1-проба-пера)

> Перед тем, как приступать к помощи коллеге, Джон решил проверить свои знания на совсем небольшой программе.

**== Задание ==**

Написать bash-скрипт. Скрипт запускается с одним параметром. Параметр текстовый. <br>
Скрипт выводит значение параметра.<br>
Если параметр - число, то должно выводится сообщение о некорректности ввода.

Для запуска скрипта нужно, чтобы у файла были права на выполнение. Это можно сделать с помощью команды `chmod`.

Допустим, что скрипт находится в файле `main.sh` в текущей директории. Чтобы выдать права на выполнение скрипта, нужно выполнить следующую команду:

``` bash 
chmod +x main.sh
```

Команда chmod изменяет права доступа к файлу. Символ `+` указывает на то, что нужно добавить права, а `x` означает право на выполнение. После этого команды `ls -l` должна отобразить права доступа, включающие `x` для файла `main.sh`.

После этого скрипт можно запустить, используя команду `./main.sh`, предварительно перейдя в директорию, где находится скрипт, если это необходимо.

``` bash 
./main.sh
```
> Сам скрипт находится в папке `01`

```bash
#!/bin/bash

# Проверяем количество переданных параметров
if [ $# -ne 1 ]; then
    echo "Ошибка: скрипт принимает только один параметр."
    exit 1
fi

# Проверяем, что параметр не пустой
if [ -z "$1" ]; then
    echo "Ошибка: параметр не может быть пустым."
    exit 1
fi

# Проверяем, что параметр не является числом
if echo "$1" | grep -qE '^[A-Z]?+[a-z]?+[+-.,=]?[0-9]+[A-Z]?+[a-z]?+([+-.,=][0-9]+)?+[+-.,=]?+[A-Z]?+[a-z]?$'; then
    echo "Ошибка: параметр не может быть числом."
    exit 1
fi

# Проверяем, что параметр не содержит цифры
if [[ "$1" =~ [0-9] ]]; then
    echo "Ошибка: параметр содержит цифру."
    exit 1
fi

# Выводим значение параметра
echo "Параметр: $1"
```

<details>
  <summary>Тесты</summary>
  
1. Параметр является текстовой строкой:

``` bash
./main.sh "Hello World"
```

Результат:

``` bash
Параметр: Hello World
```

2. Параметр содержит цифру:

``` bash
./main.sh "Hello 123 World"
```

Результат:

``` bash
Ошибка: параметр содержит цифру.
```

3. Параметр является числом:

``` bash
./main.sh 123
```

Результат:

``` bash
Ошибка: параметр не может быть числом.
```

4. Параметр является числом:

``` bash
./main.sh ""
```

Результат:

``` bash
Ошибка: параметр не может быть пустым.
```
5. Параметр является числом:

``` bash
./main.sh "Hello" "World"
```

Результат:

``` bash
Ошибка: скрипт принимает только один параметр.
```
6. Параметр является числом:

``` bash
./main.sh "He2llo World"
```

Результат:

``` bash
Ошибка: параметр содержит цифру.
```
</details>

## 2. [Исследование системы](#2-исследование-системы)

**== Задание ==**

Написать bash-скрипт. Скрипт должен вывести на экран информацию в виде:<br>
`HOSTNAME` = сетевое имя <br>
`TIMEZONE` = временная зона в виде: America/New_York UTC -5 (временная зона, должна браться из системы и быть корректной для текущего местоположения) <br>
`USER` = текущий пользователь который запустил скрипт <br>
`OS` = тип и версия операционной системы <br>
`DATE` = текущее время в виде: 12 May 2020 12:24:36 <br>
`UPTIME` = время работы системы <br>
`UPTIME_SEC` = время работы системы в секундах <br>
`IP` = ip-адрес машины в любом из сетевых интерфейсов <br>
`MASK` = сетевая маска любого из сетевых интерфейсов в виде: xxx.xxx.xxx.xxx <br>
`GATEWAY` = ip шлюза по умолчанию <br>
`RAM_TOTAL` = размер оперативной памяти в Гб c точностью три знака после запятой в виде: 3.125 GB <br>
`RAM_USED` = размер используемой памяти в Гб c точностью три знака после запятой <br>
`RAM_FREE` = размер свободной памяти в Гб c точностью три знака после запятой <br>
`SPACE_ROOT` = размер рутового раздела в Mб с точностью два знака после запятой в виде: 254.25 MB <br>
`SPACE_ROOT_USED` = размер занятого пространства рутового раздела в Mб с точностью два знака после запятой <br>
`SPACE_ROOT_FREE` = размер свободного пространства рутового раздела в Mб с точностью два знака после запятой <br>

- После вывода значений предложить записать данные в файл (предложить пользователю ответить Y/N). Ответы `Y` и `y` считаются положительными, все прочие - отрицательными.
При согласии пользователя, в текущей директории создать файл содержащий информацию, которая была выведена на экран.
- Название файла должно иметь вид: `DD_MM_YY_HH_MM_SS.status` (Время в имени файла должно указывать момент сохранения данных).

> Сам скрипт находится в папке `02` \
> `main.sh`
``` bash
#!/bin/bash

# Импортируем функции из utils.sh
source ./utils.sh

# Вывод значений на экран
echo "HOSTNAME = $HOSTNAME"
echo "TIMEZONE = $(get_timezone)"
echo "USER = $USER"
echo "OS = $(get_os_name)"
echo "DATE = $DATE"
echo "UPTIME = $UPTIME"
echo "UPTIME_SEC = $UPTIME_SEC"
echo "IP = $(get_ip)"
echo "MASK = $(get_mask)"
echo "GATEWAY = $(get_gateway)"
echo "RAM_TOTAL = $(get_ram_gb)"
echo "RAM_USED = $(get_ram_used)"
echo "RAM_FREE = $(get_ram_free)"
echo "SPACE_ROOT = $(get_space_root)"
echo "SPACE_ROOT_USED = $(get_space_root_used)"
echo "SPACE_ROOT_FREE = $(get_space_root_free)"

# запрашиваем у пользователя, нужно ли записать данные в файл
read -p "Would you like to save this information to a file? (Y/N) " choice

# если пользователь согласен, сохраняем данные в файл
if [[ ${choice} =~ ^[Yy]$ ]]; then
  # формируем имя файла
  filename="$(date +'%d_%m_%y_%H_%M_%S').status"
  # записываем данные в файл
  {
    echo "HOSTNAME = $HOSTNAME"
    echo "TIMEZONE = $(get_timezone)"
    echo "USER = $USER"
    echo "OS = $(get_os_name)"
    echo "DATE = $DATE"
    echo "UPTIME = $UPTIME"
    echo "UPTIME_SEC = $UPTIME_SEC"
    echo "IP = $(get_ip)"
    echo "MASK = $(get_mask)"
    echo "GATEWAY = $(get_gateway)"
    echo "RAM_TOTAL = $(get_ram_gb)"
    echo "RAM_USED = $(get_ram_used)"
    echo "RAM_FREE = $(get_ram_free)"
    echo "SPACE_ROOT = $(get_space_root)"
    echo "SPACE_ROOT_USED = $(get_space_root_used)"
    echo "SPACE_ROOT_FREE = $(get_space_root_free)"
  } >"${filename}"
  echo "Information saved to file: ${filename}"
else
  echo "Information not saved to file"
fi
```

> `utils.sh`
``` bash
#!/bin/bash

# Получение сетевого имени
HOSTNAME=$(hostname)

# Получение текущиего пользователь который запустил скрипт
USER=$(whoami)

# Получение текущего время в виде: 12 May 2020 12:24:36
DATE=$(date +"%d %b %Y %T")

# Получение времени работы системы
UPTIME=$(uptime -p)

# Получение времени работы системы в секундах
UPTIME_SEC=$(awk '{print int($1)}' /proc/uptime)

# Функция для получения временной зона в виде: America/New_York UTC -5 
function get_timezone() {
  local timezone=$(timedatectl | grep 'Time zone' | awk '{print $3, $4}' | sed 's/,\([^,]*\)$/)\1/')
  echo "${timezone}"
}

# Функция для получения имени ОС
function get_os_name() {
  if [ -f /etc/os-release ]; then
    # Используем /etc/os-release, если он есть
    source /etc/os-release
    echo $PRETTY_NAME
  elif [ -f /etc/redhat-release ]; then
    echo $(cat /etc/redhat-release)
  elif [ -f /etc/lsb-release ]; then
    # Используем /etc/lsb-release для Ubuntu
    source /etc/lsb-release
    echo $DISTRIB_DESCRIPTION
  else
    echo "Unknown"
  fi
}

# Функция для получения IP-адрес машины в любом из сетевых интерфейсов
function get_ip() {
  local ip=$(ip addr show | grep 'inet ' | grep -v '127.0.0.1' | awk '{print $2}' | cut -d/ -f1)
  echo "${ip}"
}

# Функция для получения ip шлюза по умолчанию
function get_gateway() {
  local gateway=$(ip route show default | awk '/default/{print $3}')
  echo "${gateway}"
}

# Функция для получения сетевой маски любого из сетевых интерфейсов в виде: xxx.xxx.xxx.xxx
function get_mask() {
  local mask=$(ifconfig | grep -w 'inet' | awk '{print $4}' | head -n 1)
  echo "${mask}"
}

# Функция для получения размера памяти в гигабайтах с точностью трем знакам после запятой
function get_ram_gb() {
  local ram_kb=$(grep -i 'memtotal' /proc/meminfo | awk '{print $2}')
  local ram_gb=$(echo "scale=3; $ram_kb/1024/1024" | bc)
  echo "$ram_gb GB"
}

# Функция для получения размера используемой памяти в гигабайтах с точностью трем знакам после запятой
function get_ram_used() {
  local ram_used=$(free | awk '/Mem:/ {printf("%.3f", $3/1024/1024);}')
  echo "${ram_used} GB"
}

# Функция для получения размера свободной памяти в гигабайтах с точностью трем знакам после запятой
function get_ram_free() {
  local ram_free=$(free | awk '/Mem:/ {printf("%.3f", $4/1024/1024);}')
  echo "${ram_free} GB"
}

# Функция для получения размера рутового раздела в мегабайтах с точностью двумя знаками после запятой
function get_space_root() {
  local space_root=$(df -BM / | awk 'NR==2{print $2}' | sed 's/M//')
  echo "${space_root} MB"
}

# Функция для получения размера занятого пространства на рутовом разделе в мегабайтах с точностью двумя знаками после запятой
function get_space_root_used() {
  local space_root_used=$(df -BM / | awk 'NR==2{print $3}' | sed 's/M//')
  echo "${space_root_used} MB"
}

# Функция для получения размера свободного пространства на рутовом разделе в мегабайтах с точностью двумя знаками после запятой
function get_space_root_free() {
  local space_root_free=$(df -BM / | awk 'NR==2{print $4}' | sed 's/M//')
  echo "${space_root_free} MB"
}
```
<details>
  <summary>Вывод</summary>
  HOSTNAME = linux-lenovo <br>
  TIMEZONE = Asia/Tashkent (+05) <br>
  USER = rama <br>
  OS = Manjaro Linux <br>
  DATE = 10 апр 2023 03:39:42 <br>
  UPTIME = up 11 hours, 22 minutes <br>
  UPTIME_SEC = 40962 <br>
  IP = 192.168.0.102 <br>
  172.17.0.1 <br>
  MASK = 255.255.0.0 <br>
  GATEWAY = 192.168.0.1 <br>
  RAM_TOTAL = 15.476 GB <br>
  RAM_USED = 6.183 GB <br>
  RAM_FREE = 3.575 GB <br>
  SPACE_ROOT = 97858 MB <br>
  SPACE_ROOT_USED = 80568 MB <br>
  SPACE_ROOT_FREE = 12274 MB <br>
  Would you like to save this information to a file? (Y/N) y <br>
  Information saved to file: 10_04_23_03_39_46.status
</details>

## 3. [Визуальное оформление вывода для скрипта исследования системы](#3-визуальное-оформление-вывода-для-скрипта-исследования-системы)

**== Задание ==**

Написать bash-скрипт. 
За основу взять скрипт из [Исследование системы](#2-исследование-системы) и убрать из него часть, ответственную за сохранение данных в файл. Скрипт запускается с 4 параметрами. 
> Параметры числовые. От 1 до 6, например: `main.sh 1 3 4 5` \
> Обозначения цветов: (1 - white, 2 - red, 3 - green, 4 - blue, 5 – purple, 6 - black)
- **Параметр 1** - это фон названий значений (HOSTNAME, TIMEZONE, USER и т.д.)
- **Параметр 2** - это цвет шрифта названий значений (HOSTNAME, TIMEZONE, USER и т.д.)
- **Параметр 3** - это фон значений (после знака '=')
- **Параметр 4** - это цвет шрифта значений (после знака '=')

1. Цвета шрифта и фона одного столбца не должны совпадать.
2. При вводе совпадающих значений должно выводится сообщение, описывающее проблему, и предложение повторно вызвать скрипт.
3. После вывода сообщения, программа должна корректно завершится.

> Часть логики.
```bash
#!/bin/bash



```


## Task lists

- [x] First effort :tada:
- [x] System research :tada:
- [ ] Visual output design for the system research script :tada:
- [ ] Configuring visual output design for the system research script.
- [ ] File system research