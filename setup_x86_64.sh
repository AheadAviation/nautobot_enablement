#!/bin/bash

# Update package list
sudo apt-get update

# Install required packages
sudo apt-get install -y apt-transport-https ca-certificates curl software-properties-common git

# Install Docker
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
sudo apt-get update
sudo apt-get install -y docker-ce

# Install Docker Compose
sudo curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

# Verify Installation
docker --version
docker-compose --version

#docker post-install stuff
groupadd docker
usermod -aG docker $USER
usermod -aG docker-compose $USER
su -c $USER
systemctl enable docker.service
systemctl enable containerd.service
source ~/.bashrc

#install gdown so we can get arista images
pip3 install gdown
mkdir -p ~/arista/eos_images
cd ~/arista/eos_images
gdown --fuzzy https://drive.google.com/file/d/1NhmEw1m9mdqm7qGaq7xzCnIzuTgS4qHt/view?usp=drive_link
docker import cEOS-lab-4.31.2F.tar ceos-lab:4.31.2F
cd ~/arista
git config --global useremail "autolab@ahead.com"
git config --global user.email "autolab@ahead.com"

#install containerlab
bash -c "$(curl -sL https://get.containerlab.dev)"
groupadd containerlab
usermod -aG containerlab $USER
su -c $USER

# Install Ansible
echo -e "Installing Ansible"
add-apt-repository --yes --update ppa:ansible/ansible
pip install ansible
source ~/.bashrc

# Clone your repository
git clone https://github.com/AheadAviation/nautobot_enablement.git
cd nautobot_enablement

# Run Docker Compose
docker-compose up -d
