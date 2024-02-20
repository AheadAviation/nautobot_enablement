#!/bin/bash


#Hide the restart services screen and just handle it in the background
#https://askubuntu.com/questions/1367139/apt-get-upgrade-auto-restart-services
sed -i 's/#$nrconf{restart} = '"'"'i'"'"';/$nrconf{restart} = '"'"'a'"'"';/g' /etc/needrestart/needrestart.conf

# Update all packages and Add the repository to Apt sources for docker:

add-apt-repository --yes --update ppa:deadsnakes/ppa 
apt-get update && apt-get upgrade -y

# Install some basic packages
apt-get install -y aptitude ca-certificates curl git gnupg2 network-manager net-tools open-vm-tools software-properties-common wget yamllint
# Install Python3 and some basic Python3 packages
apt-get install -y python3 python3-pip python3-venv python3-dev python3-pip python3-venv python3-dev python3-setuptools python3-wheel python3-apt

# Add Docker's official GPG key:
install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
chmod a+r /etc/apt/keyrings/docker.asc
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  tee /etc/apt/sources.list.d/docker.list > /dev/null
# Install Docker
apt-get update
apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin docker-compose
apt-get install -y docker-compose

#docker post-install stuff
groupadd docker
usermod -aG docker $USER
usermod -aG docker-compose $USER
su -c $USER
systemctl enable docker.service
systemctl enable containerd.service
source ~/.bashrc

#install gdown so we can get arista images from Balasko
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

#Install Nautobot
echo -e "Installing Nautobot"
cd ~
git clone https://github.com/AheadAviation/nautobot_enablement
cd nautobot_enablement
docker compose up -d
echo -e "Install Script completed"
