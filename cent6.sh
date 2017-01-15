#!/bin/bash
VM='CentOS6-1'
result=1
timeout=25
GETSTAT=$(virsh list --all | grep $VM | awk -F' ' '{print $3}')

if [ $GETSTAT == 'shut' ]
then
	read -p  "$VM now is down, start it now?[y/n]" yn
	if [ $yn == 'y' ] || [ $yn == 'Y' ]
	then
		virsh start $VM
		echo "starting $VM...Please Wait!" 
		sleep 1
		echo "tring to connenct to $VM..."
		while true
		do
			clear
			echo "wait for $timeout seconds..."
			VMIP=$(virsh net-dhcp-leases default | grep 52:54:00:38:9f:ff | awk -F' ' '{print $5}' | sed 's/\/.*//g')
			if [ -n ${VMIP} ]
			then
				ping -W 1 -c 1 ${VMIP} &>/dev/null
				result=$?
			else
				result=1
				break
			fi
			sleep 1
			timeout=$((${timeout}-1))
			if [ $timeout -eq 0 ]
			then
				exit 2
			fi
		done
#		for i in $(seq 30 -1 1)
#		do
#			echo  "Wait for $i seconds..."
#			sleep 1
#			clear
#		done
		echo "${VMIP}aaa"
		sleep 2
		ssh ${VMIP}

	else
		echo "Do noting!~"
	fi
else
	echo -e "\033[032mThe $VM vm is on\033[0m"
	read -p "Do you want to start ssh connent?[y/n]" YN
	if [ $YN == 'y' ] ||  [ $YN == 'Y' ]
	then
		VMIP=$(virsh net-dhcp-leases default | grep 52:54:00:38:9f:ff | awk -F' ' '{print $5}' | sed 's/\/.*//g')
		echo ${VMIP}
		ssh ${VMIP}
	else
		echo "Do noting!~"
	fi
fi
