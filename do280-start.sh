#!/bin/bash

HOSTS="do280-f0 classroom master node workstation"
ACTION=$1

if [ ${ACTION} != "stop" ]; then
  ACTION="start"
fi

if [ ${ACTION} == "start" ]; then
  brctl addbr virbr1
  ip link set virbr1 up
  ip a add 172.25.0.249/24 dev virbr0
  for i in ${HOSTS}
  do
     virsh start ${i}
  done
  exit 0
else
  for i in ${HOSTS}
  do
     virsh destroy ${i}
  done
  brctl delbr virbr1
  exit0
fi
