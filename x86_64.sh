#!/bin/bash

# Check for x86_64 architecture
ARCH=$(uname -m)
if [ "$ARCH" != "x86_64" ]; then
    echo "This script is intended only for x86_64 architecture."
    exit 1
fi

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

# Install Git
sudo apt-get install -y git

# Clone your repository
git clone https://github.com/AheadAviation/nautobot_enablement.git
cd nautobot_enablement

# Run Docker Compose
docker-compose up -d
