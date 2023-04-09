#!/bin/bash

# Импортируем функции из utils.sh
source ./utils.sh

# Вывод значений на экран
echo "HOSTNAME = $HOSTNAME"
echo "TIMEZONE = $(get_timezone)"
echo "USER = $USER"
echo "OS = $OS"
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
    echo "OS = $OS"
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