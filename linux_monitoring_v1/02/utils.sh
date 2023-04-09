#!/bin/bash

# Получение сетевого имени
HOSTNAME=$(hostname)

# Получение
USER=$(whoami)

# Получение текущиего пользователь который запустил скрипт
OS=$(get_os_name)

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