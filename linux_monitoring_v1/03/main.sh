#!/bin/bash

# Импортируем функции из utils.sh
source ./utils.sh

# Проверяем, все ли 4 параметра заданы
if [ $# -ne 4 ]; then
    echo "Usage: $0 <bg_color_val_names> <font_color_val_names> <bg_color_vals> <font_color_vals>"
    echo "       bg_color_val_names     - background color of labels (HOSTNAME, TIMEZONE, USER, etc.)"
    echo "       font_color_val_names   - foreground color of labels (HOSTNAME, TIMEZONE, USER, etc.)"
    echo "       bg_color_vals          - background color of values"
    echo "       font_color_vals        - foreground color of values"
    echo "       Available colors:"
    echo "       1 - white"
    echo "       2 - red"
    echo "       3 - green"
    echo "       4 - blue"
    echo "       5 - purple"
    echo "       6 - black"
    exit 1
fi

# Проверяем, все ли параметры являются числовыми и находятся в пределах диапазона [1..6]
for i in {1..4}; do
    if ! [[ ${!i} =~ ^[1-6]$ ]]; then
        echo "Error: Parameter color must be a number between 1 and 6."
        echo "       Available colors:"
        echo "       1 - white"
        echo "       2 - red"
        echo "       3 - green"
        echo "       4 - blue"
        echo "       5 - purple"
        echo "       6 - black"
        exit 1
    fi
done

# Проверьяем, отличаются ли цвет шрифта и фона имен значений
if [ "${1}" = "${2}" ] || [ "${3}" = "${4}" ]; then
    echo "Error: Font and background colors of one column must not match. Please try again."
    read -p "Do you want to run the script again with different parameters? (Y/N) " choice
    if [[ ${choice} =~ ^[Yy]$ ]]; then
        echo "Usage: $0 <bg_color_val_names> <font_color_val_names> <bg_color_vals> <font_color_vals>"
        exit 1
    else
        exit 1
    fi
fi

# Цветовая палитра
bg_color_val_names=('47' '41' '42' '44' '45' '40')
font_color_val_names=('97' '91' '92' '94' '95' '90')
bg_color_vals=('47' '41' '42' '44' '45' '40')
font_color_vals=('97' '91' '92' '94' '95' '90')

# Устанавливаем цветовые коды на основе параметров
bg_val_names=${bg_color_val_names[$1 - 1]}
font_val_names=${font_color_val_names[$2 - 1]}
bg_vals=${bg_color_vals[$3 - 1]}
font_vals=${font_color_vals[$4 - 1]}

# Вывод значений на экран с цветами
printf "\e[${bg_val_names};${font_val_names}mHOSTNAME = \e[0m\e[${bg_vals};${font_vals}m%s\e[0m\n" "$HOSTNAME"
printf "\e[${bg_val_names};${font_val_names}mTIMEZONE = \e[0m\e[${bg_vals};${font_vals}m%s\e[0m\n" "$(get_timezone)"
printf "\e[${bg_val_names};${font_val_names}mUSER = \e[0m\e[${bg_vals};${font_vals}m%s\e[0m\n" "$USER"
printf "\e[${bg_val_names};${font_val_names}mOS = \e[0m\e[${bg_vals};${font_vals}m%s\e[0m\n" "$(get_os_name)"
printf "\e[${bg_val_names};${font_val_names}mDATE = \e[0m\e[${bg_vals};${font_vals}m%s\e[0m\n" "$DATE"
printf "\e[${bg_val_names};${font_val_names}mUPTIME = \e[0m\e[${bg_vals};${font_vals}m%s\e[0m\n" "$UPTIME"
printf "\e[${bg_val_names};${font_val_names}mUPTIME_SEC = \e[0m\e[${bg_vals};${font_vals}m%s\e[0m\n" "$UPTIME_SEC"
printf "\e[${bg_val_names};${font_val_names}mIP = \e[0m\e[${bg_vals};${font_vals}m%s\e[0m\n" "$(get_ip)"
printf "\e[${bg_val_names};${font_val_names}mMASK = \e[0m\e[${bg_vals};${font_vals}m%s\e[0m\n" "$(get_mask)"
printf "\e[${bg_val_names};${font_val_names}mGATEWAY = \e[0m\e[${bg_vals};${font_vals}m%s\e[0m\n" "$(get_gateway)"
printf "\e[${bg_val_names};${font_val_names}mRAM_TOTAL = \e[0m\e[${bg_vals};${font_vals}m%s\e[0m\n" "$(get_ram_gb)"
printf "\e[${bg_val_names};${font_val_names}mRAM_USED = \e[0m\e[${bg_vals};${font_vals}m%s\e[0m\n" "$(get_ram_used)"
printf "\e[${bg_val_names};${font_val_names}mRAM_FREE= \e[0m\e[${bg_vals};${font_vals}m%s\e[0m\n" "$(get_ram_free)"
printf "\e[${bg_val_names};${font_val_names}mSPACE_ROOT = \e[0m\e[${bg_vals};${font_vals}m%s\e[0m\n" "$(get_space_root)"
printf "\e[${bg_val_names};${font_val_names}mSPACE_ROOT_USED = \e[0m\e[${bg_vals};${font_vals}m%s\e[0m\n" "$(get_space_root_used)"
printf "\e[${bg_val_names};${font_val_names}mSPACE_ROOT_FREE = \e[0m\e[${bg_vals};${font_vals}m%s\e[0m\n" "$(get_space_root_free)"

exit 0
