#!/bin/bash

# Ensure the script is run with root privileges
if [ "$(id -u)" != "0" ]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi
#Hide the restart services screen and just handle it in the background
#https://askubuntu.com/questions/1367139/apt-get-upgrade-auto-restart-services
sed -i 's/#$nrconf{restart} = '"'"'i'"'"';/$nrconf{restart} = '"'"'a'"'"';/g' /etc/needrestart/needrestart.conf

#Docker has an issue with cgroups and systemd. This is a workaround to fix it.
# Replace GRUB_CMDLINE_LINUX="" with GRUB_CMDLINE_LINUX="systemd.unified_cgroup_hierarchy=0"
sed -i 's/GRUB_CMDLINE_LINUX=""/GRUB_CMDLINE_LINUX="systemd.unified_cgroup_hierarchy=0"/' /etc/default/grub
update-grub

# Update package list
apt-get update

# Install required packages
apt-get install -y apt-transport-https ca-certificates curl software-properties-common git network-manager net-tools open-vm-tool

# Install Docker
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
apt-get update
apt-get install -y docker-ce

# Install Docker Compose
curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose

# Verify Installation
docker --version
docker-compose --version

# Docker post-installation steps
groupadd docker || true  # Ignore error if group already exists
usermod -aG docker $SUDO_USER

# Check if pip3 is installed, install if not
if ! command -v pip3 &> /dev/null; then
    apt-get install -y python3-pip
fi

# Install gdown with pip3
pip3 install gdown

# Download Arista images
mkdir -p ~/arista/eos_images
cd ~/arista/eos_images
gdown --fuzzy https://drive.google.com/file/d/1NhmEw1m9mdqm7qGaq7xzCnIzuTgS4qHt/view?usp=drive_link
docker import cEOS-lab-4.31.2F.tar ceos-lab:4.31.2F

# Configure git
cd ~/arista
git config --global user.name "autoLab"
git config --global user.email "autolab@ahead.com"

# Install containerlab
bash -c "$(curl -sL https://get.containerlab.dev)"
groupadd containerlab || true  # Ignore error if group already exists
usermod -aG containerlab $SUDO_USER

# Install Ansible
echo -e "Installing Ansible"
add-apt-repository --yes --update ppa:ansible/ansible
apt-get install -y ansible

# Clone your repository
git clone https://github.com/AheadAviation/nautobot_enablement.git
cd nautobot_enablement

# Run Docker Compose
# docker-compose up -d

# Reminder for the user
sleep 10
echo "The system will now reboot to apply changes. Please log back in and run the following command: docker-compose up -d"
reboot