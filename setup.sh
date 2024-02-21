#!/bin/bash

# Detect the processor architecture
ARCH=$(uname -m)

# Use the 'branch' environment variable if set, otherwise default to 'main'
branch="${branch:-main}"

# Execute architecture-specific script based on detected architecture
case "$ARCH" in
    x86_64)
        echo "Detected x86_64 architecture. Executing x86_64-specific script."
        curl -sSL "https://raw.githubusercontent.com/AheadAviation/nautobot_enablement/${branch}/setup_x86_64.sh" | bash
        ;;
    arm64)
        echo "Detected arm64 architecture. Executing arm64-specific script."
        curl -sSL "https://raw.githubusercontent.com/AheadAviation/nautobot_enablement/${branch}/setup_arm64.sh" | bash
        ;;
    *)
        echo "Unsupported architecture: $ARCH"
        exit 1
        ;;
esac
