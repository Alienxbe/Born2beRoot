#!/bin/bash

ARCHITECTURE=$(uname -a)
CPU_PHYS=$(lscpu| awk '/^CPU\(s\)/ {print $2}')
CPU_VIRT=$(cat /proc/cpuinfo | grep processor | wc -l)
CPU_LOAD=$(uptime | awk '{print $9}')

MEM_TOT=$(free -m | awk '/Mem/ {print $2}')
MEM_USED=$(free -m | awk '/Mem/ {print $3}')

DISK_TOT=$(df -h --total | awk '/total/ {print $2}')
DISK_USED=$(df -h --total | awk '/total/ {print $3}')
DISK_PCT=$(df -h --total | awk '/total/ {print $5}')

LAST_BOOT=$(who -b | awk '{print $3" "$4}')
LVM=$(lsblk| awk '/root/ {print $6}')
TCP_CONNECTION=$(ss -s | awk '/TCP:/ {print $2}')
SUDO_COUNT=$(expr $(cat /var/log/sudo/logs42 | wc -l) / 2)

wall <<	End_Of_Message
	#Architecture: $ARCHITECTURE 
	#CPU: $CPU_PHYS
	#vCPU: $CPU_VIRT
	#Memory usage: `echo $MEM_USED $MEM_TOT | awk '{printf "%d/%dMB (%.2f%%)\n", $(1), $(2), ($1/$2)*100}'`
	#Disk usage: $DISK_USED/$DISK_TOT ($DISK_PCT)
	#CPU load: `echo ${CPU_LOAD::-1} | awk '{printf "%d%%\n", ($1)*100}'`
	#Last boot: $LAST_BOOT
	#LVM use: `if [ "$LVM" = "lvm" ];
	then
		echo "yes"
	else
		echo "no"
	fi`
	#TCP connection: $TCP_CONNECTION ESTABLISHED
	#User log: `who | wc -l`
	`ip -br a show $(ip route show default | awk '{print $5}') | sed 's/\/[[:digit:]]\{1,3\}//g' | awk '{printf "#Network: IP %s (%s)\n", $3, $4}'`	
	#Sudo: $SUDO_COUNT
End_Of_Message
