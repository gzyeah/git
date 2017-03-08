#!/bin/bash
XMLTEMPLATE=/etc/libvirt/qemu/CentOS7-Min-Base.xml
XMLPATH=/etc/libvirt/qemu
IMGTEMPLATE=/var/lib/libvirt/images/CentOS-7-Min-Base.qcow2
IMGPATH=/var/lib/libvirt/images

read -p "Input the name of VM you want to create: " VMNAME
if [ -z ${VMNAME} ]; then
    echo "Empty Name!"
    exit 1
fi
VMXML=${XMLPATH}/${VMNAME}.xml
VMIMG=${IMGPATH}/${VMNAME}.qcow2

#Prepare XML file
cp ${XMLTEMPLATE} ${VMXML}
sed -i "s#<name>.*</name>#<name>${VMNAME}</name>#g" ${VMXML}
sed -i "s#<source file.*/>#<source file='${VMIMG}'/>#g" ${VMXML}
echo "XML file is Ready!"

#Prepare QCOW2 file
qemu-img create -f qcow2 -b ${IMGTEMPLATE} ${VMIMG} &> /dev/null
if [ $? -eq 0 ]; then
  echo "QCOW file is Ready!"
else
  echo "QCOW file create fail!"
  exit 1
fi

#Define VM
virsh define ${VMXML}
if [ $? -eq 0 ]; then
  echo "VM ${VMXML} is defined!"
else
  echo "VM ${VMXML} define fail!"
  exit 2
fi

#Startup VM
read -p "Would you want to start it now?[y/n] " yn
if [ "${yn}" == "y" ]; then
    virsh start ${VMNAME}
    VNCPort=$(virsh dumpxml ${VMNAME}  |grep vnc | awk '{print $3}' | sed 's/port=//g' | sed "s/'//g")
    read -p "Startuping ${VMNAME} ....Do you want to connect VNC?[y/n]" vncyn
    if  [ "{vncyn}" == "y" ]; then
       vncviewer :${VNCPort} -ViewOnly -Shared &
    fi
    echo "VNC Port is at ${VNCPort}"
fi
