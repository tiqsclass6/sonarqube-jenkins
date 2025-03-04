#!/bin/bash

# Enable strict error handling
set -euo pipefail

echo "Installing Snyk Security Scan..."

# Ensure Node.js and npm are installed
if ! command -v node >/dev/null 2>&1 || ! command -v npm >/dev/null 2>&1; then
    echo "ERROR: Node.js and npm are required to install Snyk."
    echo "Please install Node.js (https://nodejs.org) and try again."
    exit 1
fi

# Ensure SNYK_TOKEN is available
if [[ -z "${SNYK_TOKEN:-}" ]]; then
    echo "ERROR: SNYK_TOKEN environment variable is not set. Please configure it in Jenkins."
    exit 1
fi

# Install or update Snyk globally using npm
if command -v snyk >/dev/null 2>&1; then
    echo "Snyk is already installed. Updating to the latest version..."
    npm update -g snyk
else
    echo "Installing Snyk via npm..."
    npm install -g snyk
fi

# Verify installation
if command -v snyk >/dev/null 2>&1; then
    echo "Snyk installed successfully!"
    snyk --version
else
    echo "ERROR: Snyk installation failed."
    exit 1
fi

# Authenticate with Snyk
echo "Authenticating with Snyk..."
snyk auth "$SNYK_TOKEN"

echo "Snyk installation and authentication completed successfully."