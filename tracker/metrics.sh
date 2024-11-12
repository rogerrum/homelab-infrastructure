#!/bin/bash

# Define the Pushgateway URL with hostname as instance
hostname=$(hostname)
pushgateway_url="https://pushgateway.rsr.net/metrics/job/server_metrics/instance/$hostname"

# Get the last reboot time
last_reboot_time=$(uptime -s)
last_reboot_time_epoch=$(date -d "$last_reboot_time" +%s)

# Get the last update time
if [ -f /var/lib/apt/periodic/update-success-stamp ]; then
  last_updated_time=$(stat -c %y /var/lib/apt/periodic/update-success-stamp)
else
  last_updated_time=$(grep " upgrade " /var/log/dpkg.log | tail -n 1 | awk '{print $1, $2}')
fi
last_updated_time_epoch=$(date -d "$last_updated_time" +%s)

# Run both commands to get the number of updates available
updates_available_apt_list=$(apt list --upgradable 2>/dev/null | grep -c '^')
updates_available_apt_get=$(apt-get -s upgrade | grep -P '^\d+ upgraded' | awk '{print $1}')

# Compare the results and use the one that lists more updates
if [ "$updates_available_apt_list" -ge "$updates_available_apt_get" ]; then
  updates_available=$updates_available_apt_list
else
  updates_available=$updates_available_apt_get
fi

# Check if a reboot is needed
if [ -f /var/run/reboot-required ]; then
  reboot_needed=1
else
  reboot_needed=0
fi

# Get the host IP
host_ip=$(ip -4 addr show | grep -oP '(?<=inet\s)192\.\d+\.\d+\.\d+' | paste -sd, -)

# Get the last login time
last_login_time=$(last -F | head -n 1 | awk '{print $5, $6, $7, $8}')
last_login_time_epoch=$(date -d "$last_login_time" +%s)

# Get the CPU usage
cpu_usage=$(top -bn1 | grep "Cpu(s)" | sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | awk '{print 100 - $1}')

# Get the memory usage
mem_usage=$(free | grep Mem | awk '{print $3/$2 * 100.0}')

# Get the disk space usage
disk_space_used=$(df / | grep / | awk '{print $5}' | sed 's/%//g')
disk_space_free=$(df / | grep / | awk '{print $4}')

# Push the metrics to the Pushgateway
cat <<EOF | curl --insecure --data-binary @- "$pushgateway_url"
  server_last_reboot_time{host="$hostname",host_ip="$host_ip"} $last_reboot_time_epoch
  server_last_updated_time{host="$hostname",host_ip="$host_ip"} $last_updated_time_epoch
  server_updates_available{host="$hostname",host_ip="$host_ip"} $updates_available
  server_reboot_needed{host="$hostname",host_ip="$host_ip"} $reboot_needed
  server_last_login_time{host="$hostname",host_ip="$host_ip"} $last_login_time_epoch
  server_cpu_usage{host="$hostname",host_ip="$host_ip"} $cpu_usage
  server_mem_usage{host="$hostname",host_ip="$host_ip"} $mem_usage
  server_disk_space_used{host="$hostname",host_ip="$host_ip"} $disk_space_used
  server_disk_space_free{host="$hostname",host_ip="$host_ip"} $disk_space_free
EOF
