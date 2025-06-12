#!/bin/bash

function genUniqMac() {
  _hash=$(echo -n "$1" | md5sum | cut -c1-12)
  echo "02:${_hash:0:2}:${_hash:2:2}:${_hash:4:2}:${_hash:6:2}:${_hash:8:2}"
}

# The logical switch ports (LSP) used by the VMs can be defined as a normal string e.g. vm1-lsp, 
# however, when using virsh to define the VMs interfaceID, the LSPs must be defined with a UUID,
# so I am naming the LSPs with a UUID so virsh can reference them.
VM1_LSP=d3bb254b-6473-48af-9c2f-ad645105d29d
VM2_LSP=1f45bc55-ffec-4699-8a36-dc1bdf96e479

# Create DHCP options for 2 router ports
DHCP1=$(ovn-nbctl create dhcp_options cidr=10.0.1.0/24 options='{"server_id"="10.0.1.1", "server_mac"="02:00:00:00:01:01", "lease_time"="3600", "router"="10.0.1.1"}')
DHCP2=$(ovn-nbctl create dhcp_options cidr=10.0.2.0/24 options='{"server_id"="10.0.2.1", "server_mac"="02:00:00:00:02:02", "lease_time"="3600", "router"="10.0.2.1"}')

# Create logical router and configure 2 ports for connecting to the logical switches
ovn-nbctl lr-add lr01
ovn-nbctl lrp-add lr01 lr01-lrp01 02:00:00:00:01:01 10.0.1.1/24
ovn-nbctl lrp-add lr01 lr01-lrp02 02:00:00:00:02:02 10.0.2.1/24

# Create logical switch, configure router ports and vm ports.
ovn-nbctl ls-add ls01
ovn-nbctl set Logical_Switch ls01 other_config:subnet="10.0.1.0/24"
ovn-nbctl lsp-add ls01 ls01-lr01
ovn-nbctl lsp-set-type ls01-lr01 router
ovn-nbctl lsp-set-addresses ls01-lr01 router
ovn-nbctl lsp-set-options ls01-lr01 router-port=lr01-lrp01

ovn-nbctl lsp-add ls01 $VM1_LSP
ovn-nbctl lsp-set-addresses $VM1_LSP "$(genUniqMac scrapps-vm-01)"
ovn-nbctl set Logical_Switch_Port $VM1_LSP dhcpv4_options=$DHCP1

ovn-nbctl ls-add ls02
ovn-nbctl set Logical_Switch ls01 other_config:subnet="10.0.2.0/24"
ovn-nbctl lsp-add ls02 ls02-lr01
ovn-nbctl lsp-set-type ls02-lr01 router
ovn-nbctl lsp-set-addresses ls02-lr01 router
ovn-nbctl lsp-set-options ls02-lr01 router-port=lr01-lrp02

ovn-nbctl lsp-add ls02 $VM2_LSP
ovn-nbctl lsp-set-addresses $VM2_LSP "$(genUniqMac scrapps-vm-02)"
ovn-nbctl set Logical_Switch_Port $VM2_LSP dhcpv4_options=$DHCP2

# Deine and start the VMs
# virsh define scrapps-vm-01.xml
# virsh define scrapps-vm-02.xml

# virsh start scrapps-vm-01
# virsh start scrapps-vm-02

# bash define-vms.sh
