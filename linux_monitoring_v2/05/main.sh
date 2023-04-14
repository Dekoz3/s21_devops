#!/bin/bash

log_file="$(pwd)/../04/log/nginx_log_day_3.log"

function sort_by_response_code() {
    awk '{print $9, $0}' "$log_file" | sort -n | cut -d ' ' -f2-
}

function unique_ips() {
    awk '{print $1}' "$log_file" | sort -u
}

function error_requests() {
    awk '($9 >= 400 && $9 < 600) {print}' "$log_file"
}

function unique_ips_with_errors() {
    awk '($9 >= 400 && $9 < 600) {print $1}' "$log_file" | sort -u
}

if [[ $# -ne 1 ]]; then
    echo "Usage: $0 <option>"
    echo "Options:"
    echo "        1 - All entries sorted by response code"
    echo "        2 - All unique IPs found in the entries"
    echo "        3 - All requests with errors (response code - 4xx or 5xx)"
    echo "        4 - All unique IPs found among the erroneous requests"
    exit 1
fi

option="$1"

case "$option" in
    1) sort_by_response_code ;;
    2) unique_ips ;;
    3) error_requests ;;
    4) unique_ips_with_errors ;;
    *)
        echo "Error: Invalid option. Choose 1, 2, 3, or 4."
        exit 1
    ;;
esac