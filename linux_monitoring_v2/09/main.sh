#!/bin/bash

while true; do
    # Collect system metrics
    cpu_usage=$(top -bn1 | grep "Cpu(s)" | sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | awk '{print 100 - $1}')
    total_memory=$(free -m | awk 'NR==2{print $2}')
    used_memory=$(free -m | awk 'NR==2{print $3}')
    disk_usage=$(df -h / | awk 'NR==2{print $5}' | tr -d '%')
    
    # Create an HTML page in Prometheus format
    cat << EOF > /var/www/html/metrics.html
# HELP cpu_usage CPU usage percentage
# TYPE cpu_usage gauge
cpu_usage $cpu_usage
# HELP total_memory Total memory in megabytes
# TYPE total_memory gauge
total_memory $total_memory
# HELP used_memory Used memory in megabytes
# TYPE used_memory gauge
used_memory $used_memory
# HELP disk_usage Disk usage percentage
# TYPE disk_usage gauge
disk_usage $disk_usage
EOF
    
    # Wait for 3 seconds before updating the metrics again
    sleep 3
done
