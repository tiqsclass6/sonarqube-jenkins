# Jenkins Pipeline with Snyk Security and Terraform Deployment

## 📌 Overview

This repository contains a **Jenkins pipeline** that automates:

- **Code checkout from GitHub**
- **Dependency installation**
- **Security scanning with Snyk**
- **Generating SARIF reports for GitHub Code Scanning**
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
  npm install -g snyk snyk-to-sarif
  ```

- Verifies installation using:

  ```sh
  snyk --version
  ```

- Required for **security vulnerability scanning and SARIF generation**.

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

### **6️⃣ Snyk Security Scan & Generate SARIF Report**

- **Authenticates with Snyk** using a securely stored API token (`SNYK_TOKEN`).
- Runs security checks on **all project files**:

  ```sh
  snyk test --all-projects --json > snyk.json || echo "Snyk scan encountered issues, but pipeline continues."
  ```

- Converts the JSON output to **SARIF format** for GitHub Code Scanning:

  ```sh
  snyk-to-sarif < snyk.json > snyk.sarif
  ```

- Publishes results to **Snyk.io** for continuous monitoring with **correct project tags**:

  ```sh
  snyk monitor --org=<SNYK_ORG> --project-name=<SNYK_PROJECT> \
      --project-tags="project-owner=Imported_By,environment=Internal,business-criticality=Medium,lifecycle=Sandbox"
  ```

### **7️⃣ Upload SARIF Report to GitHub Code Scanning**

- Uses `curl` to upload the SARIF report to GitHub's **Code Scanning Dashboard**.
- Ensures authentication using **GitHub Credentials** stored in Jenkins.

  ```sh
  curl -H "Authorization: token $GITHUB_AUTH_TOKEN" \
       -H "Accept: application/vnd.github.v3+json" \
       -X POST \
       --data-binary @snyk.sarif \
       https://api.github.com/repos/<GITHUB_REPO>/code-scanning/sarifs
  ```

### **8️⃣ Initialize Terraform**

- Runs:

  ```sh
  terraform init
  ```

  to **initialize Terraform** and configure the backend for storing the state.

### **9️⃣ Validate Terraform**

- Ensures the **Terraform configuration is valid** before applying changes.
- Runs:

  ```sh
  terraform validate
  ```

### **🔯 Plan Terraform**

- Generates an execution plan using:

  ```sh
  terraform plan -out=tfplan
  ```

- Uses AWS credentials to verify **the infrastructure changes before deployment**.

### **💪 Apply Terraform (Deploy Infrastructure)**

- **Requires manual approval** before applying infrastructure changes.
- Once approved, runs:

  ```sh
  terraform apply -auto-approve tfplan
  ```

- **Deploys AWS resources** according to the Terraform configuration.

### **🏰 Deploy Application**

- Deploys the application after infrastructure is provisioned.
- Placeholder stage to include commands for **Docker/Kubernetes deployments** if needed.

### **🛠 Destroy Terraform (Optional)**

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

3. **GitHub Token for SARIF Upload**
   - **ID:** `GITHUB_TOKEN`
   - **Type:** Secret Text
   - **Value:** _(GitHub Personal Access Token with `security_events` & `repo` permissions)_

---

## 💪 Next Steps

1. **Commit the Jenkinsfile** to the GitHub repository.
2. **Ensure AWS, Snyk, and GitHub credentials are added in Jenkins**.
3. **Run the pipeline manually or configure a webhook for automatic triggers**.

---

## 🔥 Key Features & Benefits

✅ **Automated security scanning with Snyk**  
✅ **SARIF report upload for GitHub Code Scanning**  
✅ **Infrastructure automation using Terraform**  
✅ **Secure authentication using Jenkins Credentials**  
✅ **Approval-based Terraform deployment for controlled releases**  
