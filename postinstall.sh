#!/bin/bash

# Update all packages and Add the repository to Apt sources for docker:

sudo -s add-apt-repository --yes --update ppa:deadsnakes/ppa 
sudo -s apt-get update && sudo -s apt-get upgrade -y

# Install some basic packages
sudo -s apt-get install -y aptitude ca-certificates curl git gnupg2 network-manager net-tools open-vm-tools software-properties-common wget yamllint
# Install Python3 and some basic Python3 packages
sudo -s apt-get install -y python3 python3-pip python3-venv python3-dev python3-pip python3-venv python3-dev python3-setuptools python3-wheel python3-apt

# Add Docker's official GPG key:
sudo -s install -m 0755 -d /etc/apt/keyrings
sudo -s curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo -s chmod a+r /etc/apt/keyrings/docker.asc
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo -s tee /etc/apt/sources.list.d/docker.list > /dev/null
# Install Docker
sudo -s apt-get update
sudo -s apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin docker-compose
sudo -s apt-get install -y docker-compose

#docker post-install stuff
sudo -s groupadd docker
sudo -s usermod -aG docker $USER
su -c $USER
sudo -s systemctl enable docker.service
sudo -s systemctl enable containerd.service
sudo -s source ~/.bashrc
#Install Arista Containerlab
sudo -s bash -c "$(curl -sL https://get.containerlab.dev)"
#install gdown so we can get arista images from Balasko
sudo -s pip3 install gdown
sudo -s mkdir -p ~/arista/eos_images 
sudo -s cd ~/arista
docker pull ghcr.io/arista-netdevops-community/avd-all-in-one-container/avd-all-in-one:<tag>
sudo -s cd ~/arista/eos_images
sudo -s gdown --fuzzy https://drive.google.com/file/d/1NhmEw1m9mdqm7qGaq7xzCnIzuTgS4qHt/view?usp=drive_link
docker import cEOS-lab-4.31.2F.tar ceos-lab:4.31.2F
cd ~/arista
git clone https://github.com/arista-netdevops-community/avd-quickstart-containerlab.git
cd avd-quickstart-containerlab
sudo -s git remote remove origin
sudo -s sed -i 's/4\.28\.0/4.31.2/g' ~/arista/avd-quickstart-containerlab/CSVs_EVPN_MLAG/clab.yml
sudo -s sed -i 's/4\.28\.0/4.31.2/g' ~/arista/avd-quickstart-containerlab/CSVs_EVPN_AA/clab.yml
git config --global useremail "autolab@ahead.com"
git config --global user.email "autolab@ahead.com"
make build

# Install Ansible
echo -e "Installing Ansible"
sudo -s add-apt-repository --yes --update ppa:ansible/ansible
sudo -s pipx install --include-deps ansible
sudo -s source ~/.bashrc

#Install Nautobot
#echo -e "Installing Nautobot"
#cd ~
#sudo -s git clone https://github.com/AheadAviation/nautobot_enablement
#cd nautobot_enablement
#docker compose up -d
#echo -e "Install Script completed"
