#!/bin/bash

# Ensure the script is run with root privileges
if [ "$(id -u)" != "0" ]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi

WORK_DIR=/home/$SUDO_USER/
branch="${branch:-main}"

cd $WORK_DIR

# Setup git
if git config --get user.email >/dev/null 2>&1; then
  echo "Git config 'user.email' exists. Leaving alone."
else
  echo "Git config 'user.name' doesn't exist. Setting to autolab@ahead.com as a default."
  git config --global user.email "autolab@ahead.com"
fi

# Pull down repo into home directory
git clone --branch ${branch} https://github.com/AheadAviation/nautobot_enablement.git

cd nautobot_enablement

# Update package list
apt-get update

# Install required packages
apt-get install -y apt-transport-https ca-certificates curl software-properties-common git python3-venv

# Install Docker
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" -y
apt-get update
apt-get install -y docker-ce

# Verify Installation
docker --version
docker compose version

# Docker post-installation steps
groupadd docker || true  # Ignore error if group already exists
usermod -aG docker $SUDO_USER

# Check if pip3 is installed, install if not
if ! command -v pip3 &> /dev/null; then
    apt-get install -y python3-pip
fi

# Create python virtual environment
python3 -m venv nautobot_enablement_venv

source ./nautobot_enablement_venv/bin/activate

pip3 install .

# Download Arista images
mkdir -p $WORK_DIR/arista/eos_images

FILE=$WORK_DIR/arista/eos_images/cEOS-lab-4.31.2F.tar
if [ ! -f "$FILE" ]; then
    gdown --fuzzy https://drive.google.com/file/d/1NhmEw1m9mdqm7qGaq7xzCnIzuTgS4qHt/view?usp=drive_link -O $FILE --no-check-certificate
fi

IMAGE_NAME="ceos-lab:4.31.2F"

# Import downloaded .tar as Docker image 
if docker images -q "$IMAGE_NAME" >/dev/null 2>&1; then
  echo "Image $IMAGE_NAME exists. No import necessary."
else
  docker import $FILE $IMAGE_NAME
fi

# Install containerlab
bash -c "$(curl -sL https://get.containerlab.dev)"
groupadd containerlab || true  # Ignore error if group already exists
usermod -aG containerlab $SUDO_USER

# Reminder for the user
echo "Please log out and log back in for group changes to take effect."
