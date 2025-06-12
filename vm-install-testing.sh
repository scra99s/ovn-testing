# this is giving a kernel null pointer issue
virt-install \
  --name scrapps-vm-01 \
  --ram 512 \
  --vcpus 1 \
  --cpu qemu64 \
  --disk size=1,format=qcow2,bus=virtio \
  --cdrom /opt/alpine-virt-3.21.3-x86_64.iso \
  --graphics vnc,listen=0.0.0.0,password=pass \
  --os-variant alpinelinux3.21 \
  --boot cdrom,hd,menu=on

# Installing Alpine Linux in a VM using virt-install
# apk add cfdisk util-linux syslinux
# Run `setup-alpine` to configure Alpine Linux
# Run 'setup-disk /dev/vda' to partition the disk

# Export the vm XML configuration
# virsh dumpxml scrapps-vm-01 > scrapps-vm-01.xml

# deplou the the vm
# virsh define scrapps-vm-01.xml