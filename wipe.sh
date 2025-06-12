#!/bin/bash
set -e

echo "### Deleting all OVN logical routers ..."
for lr in $(ovn-nbctl list logical_router | grep name | awk '{print $3}'); do
    echo "Deleting router: $lr"
    ovn-nbctl lr-del "$lr"
done

echo "### Deleting all OVN logical switches ..."
for ls in $(ovn-nbctl list logical_switch | grep name | awk '{print $3}'); do
    echo "Deleting switch: $ls"
    ovn-nbctl ls-del "$ls"
done

echo "### Deleting all OVN logical ports ..."
for lsp in $(ovn-nbctl list logical_switch_port | grep -Pe "^name" | awk '{print $3}'); do
    echo "Deleting logical port: $lsp"
    ovn-nbctl lsp-del "$lsp"
done

echo "### Deleting all VMs/domains (virsh) ..."
for dom in $(virsh list --all --name); do
    if [ -n "$dom" ]; then
        echo "Destroying and undefining VM: $dom"
        virsh destroy "$dom" || true
        virsh undefine "$dom" || true
    fi
done

echo "### Deleting all OVN DHCP options ..."
for dhcpOption in $(ovn-nbctl list dhcp_options | grep _uuid | awk '{print $3}'); do
    echo "Deleting DHCP option: $dhcpOption"
    ovn-nbctl dhcp-options-del "$dhcpOption"
done

echo "### Wipe complete!"
