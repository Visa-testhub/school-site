#!/usr/bin/bash

# This script generates a system status report and saves it to a file.

#get date
GENERATED_AT=$(date '+%Y-%m-%d %H:%M:%S %Z %z')

#get uptime
UPTIME=$(uptime -p)

#get disk usage
DISK_USAGE=$(df -P / | awk 'NR==2 {gsub(/%/, "", $5); print $5}')

#get total memory
MEM_TOTAL=$(free -m | awk '/^Mem:/ {print $2}')

#get mem available
MEM_AVAILABLE=$(free -m | awk '/^Mem:/ {print $7}')

get_disk_status() {
	if (( $1 > 80)); then
		echo "WARNING"
	else
		echo "OK"
	fi
}

#Print to json file
echo "{" > /var/www/school-site/site/viikko3/assets/status.json
echo "  \"generated_at\": \"$GENERATED_AT\"," >> /var/www/school-site/site/viikko3/assets/status.json
echo "  \"uptime\": \"$UPTIME\"," >> /var/www/school-site/site/viikko3/assets/status.json
echo "  \"disk_usage\": $DISK_USAGE," >> /var/www/school-site/site/viikko3/assets/status.json
echo "  \"mem_total\": $MEM_TOTAL," >> /var/www/school-site/site/viikko3/assets/status.json
echo "  \"mem_available\": $MEM_AVAILABLE," >> /var/www/school-site/site/viikko3/assets/status.json
echo "  \"disk_status\": \"$(get_disk_status $DISK_USAGE)\"" >> /var/www/school-site/site/viikko3/assets/status.json
echo "}" >> /var/www/school-site/site/viikko3/assets/status.json