# Basic Nautobot Scenario

The goal of this lab scenario is to showcase a comprehensive Nautobot stack using open-source tools. It integrates most of the configurations and system designs provided in the chapters of the book, offering a practical, hands-on environment to explore these tools in action.

### Checking the Lab Environment

To check if the lab environment is running, use the following command:

```bash
nerd-ahead-cli lab show
```

This command will display all the containers and Containerlab devices currently running. If none are listed, you can start the environment with:

```bash
nerd-ahead-cli lab prepare --scenario basic-nautobot
```

---

## Component Overview and Interaction Guide

The following are sections for each components describing their role and how to interact with them. An important thing to highlight is that you will need to get the necessary credentials for the lab environment stored in your `.env` file. When in search of the credentials look there.

### Network Devices (`cEOS`)

The `cEOS` devices are simulated network routers running in Containerlab. They serve as the data sources for the lab, mimicking real-world network equipment.

#### Checking the Containerlab Topology

To view the current network topology and ensure the devices are running, use the following command:

```bash
nerd-ahead-cli containerlab inspect

# If sudo mode is needed
nerd-ahead-cli containerlab inspect --sudo
```

This will display a detailed overview of the Containerlab environment, including the status of the `cEOS` devices.

If is giving you an error about permissions, you might need to run the command in `sudo` mode, by either passing the command line flag or setting the environment variable `LAB_SUDO=true` in your `.env` file.

#### Logging into the Devices

You can log into the `cEOS` devices using SSH to perform network operations, such as shutting down interfaces or viewing configuration details:

```bash
# Example connecting to ceos-02 using the default nerd-ahead-cli credentials
ssh nerd-ahead-cli@ceos-02
```

Once logged in, you can execute standard network commands. For example, to shut down an interface:

```bash
configure
interface Ethernet2
no shutdown
```

This command shuts down the `Ethernet2` interface, which will trigger alerts and logs that can be observed through the observability stack.

#### Commands to Interact with the Devices

Here are some useful commands to interact with the `cEOS` devices:

- **Check Interface Status:**

  ```bash
  show interfaces status
  ```

- **View Logs:**

  ```bash
  show logging
  ```

- **Ping Test:** Useful to generate some lightweight traffic and check it on the dashboards

  ```bash
  ping <destination_ip> size 1400
  ```

### Nautobot

Nautobot acts as the source of truth for the network. It enriches data collected by Telegraf and Logstash with additional context, such as device metadata or topology information.

### Verifying and Populating Nautobot

Before populating Nautobot with data from your network devices, ensure that the Nautobot service is fully operational. Here are three methods to verify its readiness:

1. **Check the `nautobot` Service Health:**
   Run the following command to check the status of the `nautobot` service:

   ```bash
   nerd-ahead-cli lab show | grep nautobot
   ```

   If the service is still starting, you will see a message indicating its health status as `(health: starting)`. For example:

   ```shell
   ❯ nerd-ahead-cli lab show | grep nautobot
   nautobot            docker.io/networktocode/nautobot:2.2-py3.10    "/docker-entrypoint.…"   nautobot            About a minute ago   Up About a minute (health: starting)   0.0.0.0:8080->8080/tcp, :::8080->8080/tcp, 0.0.0.0:8443->8443/tcp, :::8443->8443/tcp
   ```

2. **Review the `nautobot` Logs:**
   You can follow the logs of the Nautobot container to monitor its startup process. Use the command:

   ```bash
   nerd-ahead-cli docker logs nautobot --tail 10 --follow
   ```

   Wait until you see the message `Nautobot initialized!`, which confirms that Nautobot is ready for use.

Once Nautobot is ready, you can populate it with data from your network devices by running the following command:

```bash
nerd-ahead-cli utils load-nautobot
```

This command will load the necessary data into Nautobot, making it fully operational and ready for use with the other components in your observability stack.

#### Accessing Nautobot

You can access Nautobot via its web interface:

```
http://<lab-machine-address>:8079
```

Login to explore network device inventories, view relationships, and check the data being fed into Grafana.

#### Enriching Data

Nautobot can be queried using its GraphQL API. For example, to enrich device data in Grafana:

```graphql
{
  devices {
    name
    site {
      name
    }
  }
}
```

This query will return device names and their corresponding sites, which can then be used to add context to your Grafana visualizations, enhancing the insights you can derive from your observability data.

6. **Provide Feedback:**

   If you have any ideas or feedback on what to integrate or alert on for this lab scenario, feel free to open a discussion or issue in the GitHub repository.
