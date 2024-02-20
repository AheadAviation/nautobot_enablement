#!/bin/bash


# Get the name of the network interface
#set output to green
GREEN='\033[0;32m'
DEFTERMCOLOR='\033[0m'

#Grab ENS Name and set it to a variable
echo -e "Script will let you convert from DHCP to STATIC."
echo -e "This is the name of your network interface:"
interface_name=$(ip link show | grep -E 'ens' | awk '{print substr($2, 1, length($2)-1)}' | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')
echo -e "$interface_name\n"

# Tell the user the current IP address
echo -e "${DEFTERMCOLOR}This is your current IP address:"
hostname -I | awk '{print "'$GREEN'" $1}'
echo -e "\n"


#ubuntu 22.04 uses 00-installer-config.yaml as the defaut after a manual install - lets back it up before we continue
echo -e "Backing up the current netplan configuration"
sudo -s cp /etc/netplan/00-installer-config.yaml /etc/netplan/00-installer-config.yaml.bak
ls -la /etc/netplan

#Check if DHCP is enabled
DHCPENABLED=$(netplan get all | grep dhcp4 | awk {'print $2'})
if [[ $DHCPENABLED == "true" ]]; then
    read -p "DHCP is detected - Do you want to change from DHCP to STATIC and set IP information? [Y/n]: " change_to_static
    while [[ ! $change_to_static =~ ^[YyNn]$ ]]; do
        read -p "Please answer with 'Y' or 'N': " change_to_static
    done
    if [[ $change_to_static =~ ^[Yy]$ || $change_to_static == "" ]]; then
        # Prompt the user for an IP address
        read -p "Enter your new static IP address: " ip_address
        read -p "Enter your Subnet Mask Bits (8/16/24 etc): " subnet_mask
        #strip leading slash if present
        subnet_mask=${subnet_mask//\//}
        read -p "What's the default gateway for this network: " default_gateway
        read -p "Do you want to use default DNS servers (8.8.8.8, 8.8.4.4)? [Y/n]: " use_default_dns
        while [[ ! $use_default_dns =~ ^[YyNn]$ ]]; do
            read -p "Please answer with 'Y' or 'N': " use_default_dns
        done

        # Set the static IP address via netplan
        echo -e "Disabling DHCP on interface $interface_name"
        sudo -s netplan set network.ethernets.$interface_name.dhcp4=false
        echo -e "Setting the static IP address to $interface_name/$subet_mask"
        sudo -s netplan set network.ethernets.$interface_name.addresses=[$ip_address/$subnet_mask]
        echo -e "Setting the default route to $default_gateway"
        sudo -s netplan set network.ethernets.$interface_name.routes='[{"to":"default", "via": "'$default_gateway'"}]'
        

        if [[ $use_default_dns =~ ^[Yy]$ || $use_default_dns == "" ]]; then
            # Set the default DNS servers
            echo -e "Setting the default DNS servers"
            sudo -s netplan set network.ethernets.$interface_name.nameservers.addresses=['8.8.8.8','8.8.4.4']
        else
            # Prompt the user for custom DNS servers
            read -p "Enter your custom DNS servers (comma-separated): " custom_dns_servers
            # Set the custom DNS servers
            echo -e "Setting the custom DNS servers to $custom_dns_servers"
            sudo -s netplan set network.ethernets.$interface_name.nameservers.addresses=[$custom_dns_servers]
        fi

        # Apply the changes
        echo "Applying changes...You will need to reconnect"
        sudo -s netplan apply

    fi