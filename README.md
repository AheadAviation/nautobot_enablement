# Nautobot Enablement Lab / Nerd Ahead CLI

## Overview

The Nautobot Enablement Lab is designed to facilitate a hands-on experience with Nautobot, an open-source Network Source of Truth and Network Automation Platform. This lab environment, powered by Docker, offers a quick and streamlined setup process, enabling users to dive straight into exploring Nautobot's capabilities without the overhead of manual configuration.

This lab is ideal for network engineers, architects, and technical consultants who are looking to integrate Nautobot into their network automation workflows. By leveraging Docker and Docker Compose, we provide a reproducible and isolated setup that mirrors real-world applications.

### Features

- **Automated Environment Setup:** Utilizing Docker and Docker Compose for easy and consistent deployment.
- **Real-World Application:** Configured to reflect common use cases and network automation scenarios.
- **Customization and Expansion:** Easily modify the Docker Compose files and environment configurations to experiment with different setups.

## Getting Started

### Prerequisites

- Windows Subsystem for Linux (WSL) or a fresh Ubuntu server (18.04 or newer required).
- Internet connection on the server.
- Basic familiarity with Docker, Docker Compose, and Git.

### Setup Instructions

1. **Prepare Your Ubuntu Server:** Ensure your system is up-to-date with the latest packages.

2. **Install Docker, Containerlab, and the Nerd Ahead CLI:** Our setup script will handle the installation of these components.

   To set up the Nautobot Enablement Lab, run the following command in your server's terminal. This command will download the setup script from our repository and execute it, performing all necessary steps to setup and install all requirements to run the lab scenarios.

```bash
curl -sSL https://raw.githubusercontent.com/AheadAviation/nautobot_enablement/main/setup.sh | bash
```
3. **Change into correct directory and activate python virtual environment:**
   cd /home/$USER/nautobot_enablement/ && source nautobot_enablement_venv/bin/activate

4. **Deploy Lab Scenario using Nerd Ahead CLI:**

To get started with the enablement lab and Nautobot stack, you need to:

  1. Copy the necessary environment variables to configure the components used within the lab scenarios.
  
    ```bash
    # Setup environment variables (edit the .env file to your liking)
    cp example.env .env
    ```
  
  2. Test everything is working by deploying a lab that has most of the components configured and ready to go.
	  
    ```bash
    # Start the network lab
    nerd-ahead-cli lab deploy --scenario basic-nautobot --sudo
    ```
          

> NOTE: Our lab comes with a `basic-nautobot` setup, providing you with everything you need to get started with exploring the Nautobot stack right away. This setup includes pre-configured tools and detailed step-by-step instructions to help you explore and learn without any hassle. Head over to the [instructions](./scenarios/basic-nautobot/README.md) section to begin!


5. **Accessing Nautobot:**

Once the setup is complete, Nautobot will be accessible through your web browser. Navigate to `http://<your-server-ip>:8079` for the web interface and `https://<your-server-ip>:8442` for secure access.

---

## Managing Lab Environment with `nerd-ahead-cli`

The `nerd-ahead-cli` utility tool simplifies managing and monitoring the network lab and observability stack set up within this repository. It provides a suite of commands designed to streamline various tasks associated with your network infrastructure.

### Top-Level Commands

The `nerd-ahead-cli` utility includes five main commands to help manage the environment:

- **`nerd-ahead-cli containerlab`**: Manages the `containerlab` pre-configured setup. All lab scenarios presented in the chapters operate under this network lab configuration.

- **`nerd-ahead-cli docker`**: Manages the Docker Compose setups for each lab scenario. It ensures the appropriate containers are running for each specific lab exercise.

- **`nerd-ahead-cli lab`**: A wrapper utility that combines `nerd-ahead-cli containerlab` and various `nerd-ahead-cli docker` commands to perform major actions. For example:

  - `nerd-ahead-cli lab purge`: Cleans up all running environments.
  - `nerd-ahead-cli lab prepare --scenario basic-nautobot`: Purges any scenario that is up and prepares the environment for basic-nautobot scenario.

- **`nerd-ahead-cli utils`**: Contains utility commands for interacting with the lab environment. This includes scripts for enabling/disabling an interface on a network device to simulate interface flapping and other useful actions.


### Next Steps

After the setup, you're ready to explore Nautobot's features. Consider the following activities:

- **Explore the UI:** Familiarize yourself with the Nautobot user interface and its functionalities.
- **Automation Workflows:** Start creating your automation workflows using Nautobot's built-in tools and integrations.
- **Customization:** Dive into the `docker-compose.yml` and `.env` files to customize your Nautobot environment.                                                                                                                                         

## Support and Contribution

For issues, suggestions, or contributions, please open an issue or pull request in our GitHub repository. Your feedback and contributions are valuable to us as we strive to make this lab as effective and user-friendly as possible.

