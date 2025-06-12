# KVM and deps.
apt install -y gcc make curl perl bzip2 terminator

snap install code --classic

apt install -y qemu-kvm libvirt-daemon-system libvirt-clients bridge-utils virt-manager qemu-system

# OpenVswitch (OVS).
apt install -y openvswitch-switch openvswitch-common

# Open virtual network (OVN) (master)
apt install -y ovn-central ovn-common ovn-host

adduser scrapps kvm
adduser scrapps libvirt

# Sets up the OVS database connections for externals
# ovn-nbctl set-connection ptcp:6641
# ovn-sbctl set-connection ptcp:6642
# ovs-appctl ovsdb-server ovsdb-server/add-remote ptcp:6640
# ovs-vsctl set open_vswitch . \
#   external_ids:ovn-remote=unix:/run/ovn/ovnsb_db.sock \
#   external_ids:ovn-encap-type=geneve \
#   external_ids:ovn-encap-ip=127.0.0.1
# ovs-vsctl set open_vswitch . \
#   external_ids:ovn-remote=ptcp:6641 \
#   external_ids:ovn-remote=ptcp:6642 \
#   external_ids:ovn-encap-type=geneve \
#   external_ids:ovn-encap-ip=172.0.0.1