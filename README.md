# Nautobot Enablement Lab

## Overview

The Nautobot Enablement Lab is designed to facilitate a hands-on experience with Nautobot, an open-source Network Source of Truth and Network Automation Platform. This lab environment, powered by Docker, offers a quick and streamlined setup process, enabling users to dive straight into exploring Nautobot's capabilities without the overhead of manual configuration.

This lab is ideal for network engineers, architects, and technical consultants who are looking to integrate Nautobot into their network automation workflows. By leveraging Docker and Docker Compose, we provide a reproducible and isolated setup that mirrors real-world applications.

### Features

- **Automated Environment Setup:** Utilizing Docker and Docker Compose for easy and consistent deployment.
- **Real-World Application:** Configured to reflect common use cases and network automation scenarios.
- **Customization and Expansion:** Easily modify the Docker Compose files and environment configurations to experiment with different setups.

## Getting Started

### Prerequisites

- A fresh Ubuntu server (18.04 or newer recommended).
- Internet connection on the server.
- Basic familiarity with Docker, Docker Compose, and Git.

### Setup Instructions

1. **Prepare Your Ubuntu Server:** Ensure your system is up-to-date with the latest packages.

2. **Install Docker and Docker Compose:** Our setup script will handle the installation of these components.

3. **Clone the Repository and Deploy:**

To set up the Nautobot Enablement Lab, run the following command in your server's terminal. This command will download the setup script from our repository and execute it, performing all necessary steps to get your lab environment up and running.

```bash
curl -sSL https://raw.githubusercontent.com/AheadAviation/nautobot_enablement/main/setup.sh | bash
```

4. **Accessing Nautobot:**

Once the setup is complete, Nautobot will be accessible through your web browser. Navigate to `http://<your-server-ip>:8079` for the web interface and `https://<your-server-ip>:8442` for secure access.

### Next Steps

After the setup, you're ready to explore Nautobot's features. Consider the following activities:

- **Explore the UI:** Familiarize yourself with the Nautobot user interface and its functionalities.
- **Automation Workflows:** Start creating your automation workflows using Nautobot's built-in tools and integrations.
- **Customization:** Dive into the `docker-compose.yml` and `.env` files to customize your Nautobot environment.

## Support and Contribution

For issues, suggestions, or contributions, please open an issue or pull request in our GitHub repository. Your feedback and contributions are valuable to us as we strive to make this lab as effective and user-friendly as possible.

---

Ensure to replace `<your-server-ip>` with the actual IP address of your server where Nautobot is hosted. This README template provides a comprehensive guide for users to get started with your Nautobot Enablement Lab, outlining the purpose, setup instructions, and next steps for exploring Nautobot's capabilities.
