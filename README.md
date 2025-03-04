# Jenkins Pipeline with Snyk Security and Terraform Deployment

## 📌 Overview

This repository contains a **Jenkins pipeline** that automates:

- **Code checkout from GitHub**
- **Dependency installation**
- **Security scanning with Snyk**
- **Terraform infrastructure deployment**
- **Application deployment**
- **Optional Terraform destroy process**

The pipeline follows best practices for **CI/CD security and infrastructure automation**.

---

## 🚀 How the Jenkinsfile Works

The **Jenkinsfile** defines an automated **CI/CD pipeline** using the following stages:

### **1️⃣ Set AWS Credentials**

- Retrieves AWS access credentials stored in **Jenkins Credentials Manager**.
- Uses `withCredentials` to set environment variables for **AWS authentication**.
- Runs:

  ```sh
  aws sts get-caller-identity
  ```

  to verify the credentials.

### **2️⃣ Checkout Code**

- Pulls the latest code from the GitHub repository.
- Runs:

  ```sh
  git checkout main
  ```

  to ensure the pipeline is running against the latest version.

### **3️⃣ Install Snyk**

- Ensures **Snyk CLI** is installed globally using:

  ```sh
  npm install -g snyk
  ```

- Verifies installation using:

  ```sh
  snyk --version
  ```

- Required for **security vulnerability scanning**.

### **4️⃣ Update Dependencies**

- Checks for outdated npm packages and updates them using:

  ```sh
  npm install -g npm-check-updates
  ncu -u
  npm install
  ```

### **5️⃣ Install Dependencies**

- Ensures the necessary dependencies are installed before running the application.
- Uses:

  ```sh
  npm install
  ```

  if a `package.json` file is found.

### **6️⃣ Snyk Security Scan & Publish to Snyk.io**

- **Authenticates with Snyk** using a securely stored API token (`SNYK_TOKEN`).
- Runs security checks:

  ```sh
  snyk test --org=<SNYK_ORG> --project-name=<SNYK_PROJECT>
  ```

- Publishes results to **Snyk.io** for continuous monitoring:

  ```sh
  snyk monitor --org=<SNYK_ORG> --project-name=<SNYK_PROJECT>
  ```

### **7️⃣ Initialize Terraform**

- Runs:

  ```sh
  terraform init
  ```

  to **initialize Terraform** and configure the backend for storing the state.

### **8️⃣ Validate Terraform**

- Ensures the **Terraform configuration is valid** before applying changes.
- Runs:

  ```sh
  terraform validate
  ```

### **9️⃣ Plan Terraform**

- Generates an execution plan using:

  ```sh
  terraform plan -out=tfplan
  ```

- Uses AWS credentials to verify **the infrastructure changes before deployment**.

### **🔟 Apply Terraform (Deploy Infrastructure)**

- **Requires manual approval** before applying infrastructure changes.
- Once approved, runs:

  ```sh
  terraform apply -auto-approve tfplan
  ```

- **Deploys AWS resources** according to the Terraform configuration.

### **1️⃣1️⃣ Deploy Application**

- Deploys the application after infrastructure is provisioned.
- Placeholder stage to include commands for **Docker/Kubernetes deployments** if needed.

### **1️⃣2️⃣ Destroy Terraform (Optional)**

- **Requires manual approval** before destroying infrastructure.
- If approved, runs:

  ```sh
  terraform destroy -auto-approve
  ```

- **Decommissions all AWS resources** created by Terraform.

---

## 🔧 Jenkins Setup Requirements

Before running the pipeline, ensure the following **Jenkins configurations**:

### **🔹 Install Required Plugins**

- **Pipeline** (`workflow-aggregator`)
- **Snyk Security Scanner**
- **Amazon Web Services SDK**
- **NodeJS Plugin**
- **Git Plugin**

### **🔹 Set Up Jenkins Credentials**

1. **AWS Credentials**
   - **ID:** `snyk_cred`
   - **Type:** AWS Access Key & Secret

2. **Snyk API Token**
   - **ID:** `SNYK_TOKEN`
   - **Type:** Secret Text
   - **Value:** _(Your Snyk API Key)_

---

## 🏗 How to Run the Pipeline

1. **Commit the Jenkinsfile** to the GitHub repository.
2. **Create a new Jenkins pipeline job** and set the **GitHub repository URL**.
3. **Ensure AWS & Snyk credentials are added in Jenkins**.
4. **Run the pipeline manually or configure a webhook for automatic triggers**.

---

## 🔥 Snyk Installation & Authentication Script (`snyk.sh`)

This script installs Snyk, ensures it's up to date, and authenticates it.

```bash
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
```

---

## 📚 Additional Resources

- [Jenkins Documentation](https://www.jenkins.io/doc/)
- [Snyk CLI Guide](https://docs.snyk.io/)
- [Terraform Documentation](https://developer.hashicorp.com/terraform/docs)

---

## 🎯 Key Features & Benefits

✅ **Automated security scanning with Snyk**  
✅ **Prevents security vulnerabilities before deployment**  
✅ **Infrastructure automation using Terraform**  
✅ **Secure authentication using Jenkins Credentials**  
✅ **Approval-based Terraform deployment for controlled releases**  
