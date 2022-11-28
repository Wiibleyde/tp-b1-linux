#!/bin/bash
echo "Machine name : $(hostname)"
echo "OS $(cat /etc/*release | grep PRETTY_NAME | cut -d= -f2) and kernel version is $(uname -r)"
ip=$(ip -4 addr | grep inet | tr -s ' ' | cut -d' ' -f3 | cut -d$'\n' -f2)
echo "IP address is $ip"
echo "RAM : $(free -mh | grep Mem | awk '{print $3}') memory avialable on $(free -mh | grep Mem | awk '{print $2}') total memory"
echo "Disk : $(df -h | grep /dev/sda3 | awk '{print $4}') space left"
echo "Top 5 processes by RAM usage :"
process=$(ps -eo pid,ppid,cmd,%mem,%cpu --sort=-%mem | head -n 6)
filtered=$(echo "$process" | tail -n 5 | awk '{print $3}')
while read -r line; do
    echo "  -  $line"
done <<< "$filtered"
echo "Listening ports :"
fullline=$(ss -tulpnH4 | tr -s ' ' | cut -d' ' -f1,5,7 | tail -n +2)
while read -r line; do
    protocol=$(echo "$line" | cut -d' ' -f1)
    port=$(echo "$line" | cut -d' ' -f2 | cut -d':' -f2)
    service=$(echo "$line" | cut -d' ' -f3 | cut -d'"' -f2)
    echo "  -  $protocol $port : $service"
done <<< "$fullline"
curl -s https://cataas.com/cat > ./cat.jpg
echo "Here is your random cat : ./cat.jpg"

