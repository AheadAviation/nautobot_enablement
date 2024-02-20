# Get the name of the network interface
#set output to green
GREEN='\033[0;32m'
DEFTERMCOLOR='\033[0m'

#Grab ENS Name and set it to a variable
echo -e "Script will let you change your static IP."
echo -e "This is the name of your network interface:"
interface_name=$(ip link show | grep -E 'ens' | awk '{print substr($2, 1, length($2)-1)}' | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')
echo -e "$interface_name\n"

# Tell the user the current IP address
echo -e "${DEFTERMCOLOR}This is your current IP address:"
hostname -I | awk '{print "'$GREEN'" $1}'
echo -e "\n"


#ubuntu 22.04 uses 00-installer-config.yaml as the defaut after a manual install - lets back it up
echo -e "Backing up the current netplan configuration"
sudo -s cp /etc/netplan/00-installer-config.yaml /etc/netplan/00-installer-config.yaml.bak
ls -la /etc/netplan
echo -e "\n\n\n\n ${DEFTERMCOLOR}"




read -p "Static IP Address detected - Do you want to change the IP address or DNS Servers? [Y/n]: " change_ip_address

if [[ $change_ip_address =~ ^[Yy]$ || $change_ip_address == "" ]]; then
    # Prompt the user for an IP address
    read -p "Enter your new static IP address: " ip_address
    read -p "Enter your Subnet Mask Bits (8/16/24 etc): " subnet_mask
    # Strip leading slash if present
    subnet_mask=${subnet_mask//\//}
    read -p "What's the default gateway for this network: " default_gateway
    read -p "Do you want to use default DNS servers (8.8.8.8, 8.8.4.4)? [Y/n]: " use_default_dns

    if [[ $use_default_dns =~ ^[Nn]$ ]]; then
        # Prompt the user for custom DNS servers
        read -p "Enter your custom DNS servers (comma-separated): " custom_dns_servers
    fi
    # Display the entered variables to the user
    echo -e "Here is what you entered"
    echo -e "IP Address: $ip_address"
    echo -e "Subnet Mask: $subnet_mask"
    echo -e "Default Gateway: $default_gateway"
    if [[ $use_default_dns =~ ^[Yy]$ || $use_default_dns == "" ]]; then
        echo -e "Using Google as the Default DNS Server (8.8.8.8, 8.8.4.4)"
    else
        echo -e "Custom DNS Servers: $custom_dns_servers"
    fi
    echo -e "\n\n"

    # Ask if the user wants to proceed with the changes
    read -p "Do you wish to proceed with the changes? [Y/n]: " proceed_changes
      
    if [[ $proceed_changes =~ ^[Yy]$ || $proceed_changes == "" ]]; then
        # Proceed with the changes
        echo "Proceeding with the changes..."
        # Set the static IP address
        sudo -s netplan set network.ethernets.$interface_name.addresses=[$ip_address/$subnet_mask]
        sudo -s netplan set network.ethernets.$interface_name.routes='[{"to":"default", "via": "'$default_gateway'"}]'
        sudo -s netplan set network.ethernets.$interface_name.dhcp4=false
   
        if [[ $use_default_dns =~ ^[Yy]$ || $use_default_dns == "" ]]; then
            # Set the default DNS servers
            sudo -s netplan set network.ethernets.$interface_name.nameservers.addresses=['8.8.8.8','8.8.4.4']
        else
            # Set the custom DNS servers
            sudo -s netplan set network.ethernets.$interface_name.nameservers.addresses=[$custom_dns_servers]
        fi
    else
        echo "Changes aborted."
    fi
fi
