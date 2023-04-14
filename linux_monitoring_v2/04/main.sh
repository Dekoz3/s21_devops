#!/bin/bash

declare -a response_codes=("200" "201" "400" "401" "403" "404" "500" "501" "502" "503")
declare -a methods=("GET" "POST" "PUT" "PATCH" "DELETE")
declare -a user_agents=("Mozilla" "Google Chrome" "Opera" "Safari" "Internet Explorer" "Microsoft Edge" "Crawler and bot" "Library and net tool")

for i in {1..5}; do
    log_file="nginx_log_day_${i}.log"
    mkdir -p "log/"
    touch "log/$log_file"
    num_entries=$((RANDOM % 901 + 100))
    
    for ((j = 0; j < num_entries; j++)); do
        ip="$(shuf -i 1-255 -n 1).$(shuf -i 1-255 -n 1).$(shuf -i 1-255 -n 1).$(shuf -i 1-255 -n 1)"
        response_code="${response_codes[RANDOM % ${#response_codes[@]}]}"
        method="${methods[RANDOM % ${#methods[@]}]}"
        date="$(date -d "today -${i} days" "+%d/%b/%Y:%H:%M:%S %z")"
        request_url="/path/to/resource"
        user_agent="${user_agents[RANDOM % ${#user_agents[@]}]}"
        
        echo "$ip - - [$date] \"$method $request_url HTTP/1.1\" $response_code 0 \"-\" \"$user_agent\"" >> "log/$log_file"
    done
done

# Response codes
# 200: OK
# 201: Created
# 400: Bad Request
# 401: Unauthorized
# 403: Forbidden
# 404: Not Found
# 500: Internal Server Error
# 501: Not Implemented
# 502: Bad Gateway
# 503: Service Unavailable