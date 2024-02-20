#!/bin/bash

#Install Arista Containerlab
bash -c "$(curl -sL https://get.containerlab.dev)"

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
pipx install --include-deps ansible
source ~/.bashrc