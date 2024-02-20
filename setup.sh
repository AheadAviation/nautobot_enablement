#!/bin/bash

# Ensure running as root
if [ "$(id -u)" -ne 0 ]; then
  echo "This script must be run as root" >&2
  exit 1
fi

# Detect architecture, distribution, and version
ARCH=$(dpkg --print-architecture)
OS=$(awk -F= '/^NAME/{print $2}' /etc/os-release | tr -d '"')
VERSION=$(awk -F= '/^VERSION_ID/{print $2}' /etc/os-release | tr -d '"')

# Update package list and upgrade packages
apt-get update && apt-get upgrade -y

# Install required packages
apt-get install -y apt-transport-https ca-certificates curl software-properties-common git aptitude gnupg2 network-manager net-tools open-vm-tools wget yamllint python3 python3-pip python3-venv python3-dev python3-setuptools python3-wheel python3-apt

# Docker and Docker Compose Installation
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo \
  "deb [arch=$ARCH signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
apt-get update
apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Enable and start Docker
systemctl enable docker.service
systemctl enable containerd.service

# Add current user to Docker and containerlab groups
groupadd docker || true
groupadd containerlab || true
usermod -aG docker $SUDO_USER
usermod -aG containerlab $SUDO_USER

# Install Python3 packages
pip3 install gdown ansible --upgrade

# Arista Containerlab and Ansible Installation
bash -c "$(curl -sL https://get.containerlab.dev)"
add-apt-repository --yes --update ppa:ansible/ansible
pipx install --include-deps ansible

# Git configurations
git config --global user.email "autolab@ahead.com"

# Install Nautobot
echo "Installing Nautobot"
git clone https://github.com/AheadAviation/nautobot_enablement.git /opt/nautobot_enablement
cd /opt/nautobot_enablement
docker-compose up -d
echo "Nautobot installation completed"

# Apply needrestart configuration to suppress restart dialogs
sed -i 's/#$nrconf{restart} = '"'"'i'"'"';/$nrconf{restart} = '"'"'a'"'"';/g' /etc/needrestart/needrestart.conf

# Reload shell to apply changes
echo "Please logout and log back in for group changes to take effect."
