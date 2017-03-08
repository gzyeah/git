#!/bin/bash

VMPATH=/var/lib/libvirt/images
VMFILE="do280-classroom-vda-bak.qcow2 do280-node-vda-bak.qcow2 do280-master-vdb-bak.qcow2 do280-workstation-vda-bak.qcow2 do280-master-vda-bak.qcow2 do280-node-vdb-bak.qcow2"
ORIGIN="do280-classroom-vda.qcow2 do280-master-vda.qcow2 do280-node-vdb.qcow2 do280-classroom-vda.qcow2 do280-node-vda.qcow2 do280-master-vdb.qcow2 do280-workstation-vda.qcow2"

echo "Removing VM qcow2.."

for f in ${VMFILE}
do
  echo "Removing ${f}"
  rm -f ${VMPATH}/${f}
done

echo -e "\nRe-creating VM qcow2.."

for i in ${ORIGIN}
do
  k=$(echo ${i} | sed 's/.qcow2/-bak.qcow2/g')
  echo "Re-creating ${k}"
  qemu-img create -f qcow2 -b ${VMPATH}/${i} ${VMPATH}/${k}
done

echo -e "\nDone!"
