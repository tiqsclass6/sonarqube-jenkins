# 🧪 SonarQube-Jenkins CI/CD Pipeline

This repository contains a Jenkins Pipeline (`Jenkinsfile`) that automates **static code analysis using SonarQube** and the **build and deployment process** of an application.

---

## 📋 Prerequisites

### 📂 Clone the Repository

To get started locally or configure Jenkins:

```bash
git clone https://github.com/tiqsclass6/sonarqube-jenkins.git
cd sonarqube-jenkins
code .
```

Ensure the following are in place before using this pipeline:

- ✅ Jenkins installed and properly configured
- ✅ [SonarQube](https://www.sonarqube.org/) account and project set up
- ✅ GitHub repository connected to Jenkins
- ✅ SonarScanner tool installed on the Jenkins server
- ✅ SonarQube authentication token stored as Jenkins credentials
- ✅ Jenkins credentials and global tools properly configured

---

## 🚀 Pipeline Overview

The Jenkins pipeline automates the following steps:

1. 🛠 **Checkout Code** – Pulls source code from the GitHub repository
2. 🔍 **SonarQube Analysis** – Performs static code analysis
3. 🏗 **Build Application** – Compiles and packages the code
4. 🚚 **Deploy Application** – Deploys the application to your environment

---

## ⚙️ Environment Variables

The following environment variables are used in the `Jenkinsfile`:

| Variable              | Description                                         |
|-----------------------|-----------------------------------------------------|
| `SONAR_SCANNER`       | SonarScanner tool name configured in Jenkins       |
| `SONAR_TOKEN`         | SonarQube authentication token                     |
| `SONAR_PROJECT_URL`   | SonarQube project dashboard URL                    |
| `SONAR_HOST_URL`      | SonarQube server URL                               |
| `SONAR_PROJECT_KEY`   | Unique key for the SonarQube project               |
| `SONAR_PROJECT_NAME`  | Display name of the SonarQube project              |
| `SONAR_ORG`           | SonarQube organization identifier (for SonarCloud) |

---

## 🧪 Pipeline Stages

### 1. 📦 Checkout Code

- Retrieves the latest source code from the GitHub repository using the Jenkins `git` step.

### 2. 🔍 SonarQube Analysis

- Executes static code analysis using SonarScanner:

```bash
${SONAR_SCANNER}/bin/sonar-scanner \
  -Dsonar.projectKey=${SONAR_PROJECT_KEY} \
  -Dsonar.organization=${SONAR_ORG} \
  -Dsonar.host.url=${SONAR_HOST_URL} \
  -Dsonar.login=${SONAR_TOKEN}
```

- Results are automatically pushed to your SonarQube dashboard.

### 3. 🛠 Build Application

- Uses Maven to compile and package the code:

```bash
mvn clean install
```

### 4. 🚀 Deploy Application

- Deploys the build artifact to your environment.
- Deployment may involve **SSH commands**, **containerization (Docker)**, or **cloud infrastructure scripts**.

---

## 📄 Jenkinsfile Contents

Below is the full content of the `Jenkinsfile` used to automate the CI/CD process:

```groovy
pipeline {
    agent any

    environment {
        SONAR_SCANNER = tool 'SonarScanner1'
        SONAR_TOKEN = credentials('SONARQUBE_TOKEN')
        SONAR_HOST_URL = 'https://sonarcloud.io'
        SONAR_PROJECT_KEY = 'your-project-key'
        SONAR_PROJECT_NAME = 'Your Project Name'
        SONAR_ORG = 'your-organization'
    }

    stages {
        stage('Checkout Code') {
            steps {
                git url: 'https://github.com/tiqsclass6/sonarqube-jenkins.git', branch: 'main'
            }
        }

        stage('SonarQube Analysis') {
            steps {
                withSonarQubeEnv('SonarCloud') {
                    script {
                        def scannerHome = tool 'SonarScanner1'
                        sh """
                        export JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64
                        export PATH=$JAVA_HOME/bin:$PATH
                        ${scannerHome}/bin/sonar-scanner \
                            -Dsonar.projectKey=${SONAR_PROJECT_KEY} \
                            -Dsonar.projectName=${SONAR_PROJECT_NAME} \
                            -Dsonar.sources=. \
                            -Dsonar.host.url=${SONAR_HOST_URL} \
                            -Dsonar.language=terraform \
                            -Dsonar.organization=${SONAR_ORG} \
                            -X
                        """
                    }
                }
            }
        }

        stage('Check SonarQube Report') {
            steps {
                script {
                    def reportExists = fileExists('report-task.txt')
                    if (!reportExists) {
                        def userResponse = input message: "SonarScanner did not generate 'report-task.txt'. Continue?", parameters: [
                            choice(name: 'Proceed', choices: ['Yes', 'No'], description: 'Select Yes to continue, No to stop.')
                        ]
                        if (userResponse == 'No') {
                            error("SonarScanner failed, stopping the build.")
                        }
                    }
                }
            }
        }
    }

    post {
        always {
            cleanWs()
        }
    }
}
```

1. **Open Jenkins Dashboard**

2. **Create a New Pipeline:**
   - Click **"New Item"** → Enter a name → Select **"Pipeline"** → Click **OK**

3. **Configure the Pipeline:**
   - Select **"Pipeline script from SCM"**
   - Choose **Git**
   - Enter your **repository URL**
   - Set **"Script Path"** to `Jenkinsfile`

4. **Save and Build:**
   - Click **Save**
   - Click **Build Now** to trigger your pipeline

---

## 📊 Viewing SonarQube Results

- Access the SonarQube project dashboard:
  👉 [View Project Dashboard](${SONAR_PROJECT_URL})

- Review:
  - ✅ Code quality metrics
  - 🔒 Security vulnerabilities
  - ⚠️ Technical debt and maintainability

---

## 🧯 Troubleshooting Issues

If you encounter problems while running the pipeline, consider the following tips:

### 🔑 Authentication Issues

- Ensure your SonarQube token is added correctly in Jenkins under **Manage Jenkins → Credentials**.
- Make sure the credential ID matches the one used in the `Jenkinsfile`.

### 🧰 Tool Configuration

- Confirm that **SonarQube Scanner** is properly configured in Jenkins under **Global Tool Configuration**.
- Check that the `tool` name used in the pipeline matches the name configured in Jenkins.

### 🌐 Network & Connectivity

- Validate that Jenkins can access the SonarQube server URL specified in `SONAR_HOST_URL`.
- If using a self-hosted SonarQube, verify firewall rules or proxy configurations.

### 🧪 Build Failures

- Make sure your Maven project compiles correctly outside Jenkins.
- Review build logs for any missing dependencies or plugin errors.

### 🔍 SonarQube Errors

- Confirm that `sonar.projectKey`, `sonar.organization`, and `sonar.projectName` match what's in SonarQube.
- Check the SonarQube dashboard for any scanner-related errors or permissions issues.

### 🐞 Debugging Tips

- Add `echo` statements in your Jenkinsfile to print environment variables.
- Use `sh 'env'` to print all available environment variables for debugging purposes.

---

## 📎 Related Tools & Resources

- [SonarQube Documentation](https://docs.sonarsource.com/)
- [Jenkins Pipeline Syntax](https://www.jenkins.io/doc/book/pipeline/syntax/)
- [SonarScanner CLI](https://docs.sonarsource.com/sonarqube/latest/analyzing-source-code/scanners/sonarscanner/)

---
