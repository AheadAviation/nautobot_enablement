# Nautobot and Arista Containers Lab Guide

## Overview

This lab guide is designed to help you set up a learning environment featuring Nautobot and Arista containers. You'll learn how to onboard devices into Nautobot and apply configurations to Arista devices using an Excel document. This hands-on experience will enhance your understanding of network automation and configuration management.

## Prerequisites

- Access to a Unix-based operating system (Ubuntu or macOS)
- Basic understanding of containerization and network configuration concepts

## Lab Setup

### Step 1: Initial Script Execution

Run the following script to prepare your environment. This script will automatically detect your OS (Ubuntu or macOS), install necessary prerequisites, and configure base setups for both Arista and Nautobot containers.

```sh
curl -sSL https://raw.githubusercontent.com/AheadAviation/nautobot_enablement/main/setup.sh | bash
```

### Step 2: Verifying Container Setup

Ensure that the Nautobot and Arista containers are up and running. These containers are pre-configured with base IP, hostname, and login information.

## Configuration and Verification

### Step 3: Onboarding Devices with Nautobot

1. Navigate to the Nautobot GUI.
2. Complete the onboarding wizard to import the Arista devices.

### Step 4: Verification of Onboarded Devices

Verify that the devices have been correctly onboarded by checking specific variables (to be determined).

### Step 5: Excel Document Review

Review the Excel document located in the Git repository. It contains the desired leaf/spine configuration for the Docker Arista devices.

## Deployment

### Step 6: Running the Custom Job

Execute the custom job created by AHEAD. This job will:
- Convert the Excel document configurations
- Import them into Nautobot using a Python script

### Step 7: Configuration Review in Nautobot

Inspect the imported configuration through the Nautobot GUI to ensure accuracy.

### Step 8: Deploying Configuration to Arista Devices

Run the deployment job in Nautobot to push configurations to the Arista devices.

### Step 9: Verifying Arista Configurations

SSH into the Arista devices to verify the leaf/spine configuration has been applied successfully.

## Conclusion

Congratulations! You have successfully completed the Nautobot and Arista containers lab. This exercise has given you practical experience in network automation and configuration management using modern tools and technologies.
