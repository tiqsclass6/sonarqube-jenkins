#!/bin/bash

# Enable strict error handling
set -euo pipefail

echo "🔍 Installing Snyk Security Scan..."

# Ensure Node.js and npm are installed
if ! command -v node >/dev/null 2>&1 || ! command -v npm >/dev/null 2>&1; then
    echo "ERROR: Node.js and npm are required to install Snyk."
    echo "Please install Node.js (https://nodejs.org) and try again."
    exit 1
fi

# Install Snyk globally using npm
echo "📦 Installing Snyk via npm..."
npm install -g snyk

# Verify installation
if command -v snyk >/dev/null 2>&1; then
    echo "Snyk installed successfully!"
    snyk --version
else
    echo "ERROR: Snyk installation failed."
    exit 1
fi

echo "Snyk is now available for security scans."