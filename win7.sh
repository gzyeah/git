#!/bin/bash
GETSTAT=$(virsh list --all | grep win7sp1-work | awk -F' ' '{print $3}')

if [ $GETSTAT == 'shut' ]
then
	read -p  "win7 now is down, start it now?[y/n]" yn
	if [ $yn == 'y' ] || [ $yn == 'Y' ]
	then
		virsh start win7sp1-work && vncviewer :2 -FullScreen &>/dev/null &
		echo "start win7 vm..."
	else
		echo "Do noting!~"
	fi
else
	echo -e "\033[032mThe win7 vm is on\033[0m"
	read -p "Do you want to start vnc connent?[y/n]" YN
	if [ $YN == 'y' ] ||  [ $YN == 'Y' ]
	then
		vncviewer :2 -FullScreen &>/dev/null &
	else
		echo "Do noting!~"
	fi
fi
