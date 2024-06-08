#!/bin/bash
echo "Changing netplan to DHCP..."
cd /etc/netplan
sudo mv "00-installer-config.yaml" "00-config.yaml.bak"

echo "Grab interface name"
interface_name=$(ip link show | grep -E 'ens' | awk '{print substr($2, 1, length($2)-1)}' | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')
echo -e "$interface_name\n"

echo "network:
    version: 2
    renderer: networkd
    ethernets:
        $interface_name:
            dhcp4: true" | sudo tee /etc/netplan/00-dhcp-config.yaml > /dev/null
sudo netplan apply

echo "Complete"