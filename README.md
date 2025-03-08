# SonarQube-Jenkins CI/CD Pipeline

This repository contains a Jenkins pipeline (`Jenkinsfile`) that automates code analysis with SonarQube and the deployment process.

## Prerequisites

- **Jenkins** installed and configured.
- **SonarQube** account and project set up.
- **GitHub repository** linked with Jenkins.
- **SonarScanner tool** installed on Jenkins.
- **SonarQube authentication token** stored in Jenkins credentials.

## Pipeline Overview

The Jenkins pipeline consists of multiple stages that automate the process of checking out code, performing static analysis with SonarQube, and deploying the application.

### Environment Variables

The following environment variables are defined in the pipeline:

- `SONAR_SCANNER`: SonarQube scanner tool name configured in Jenkins.
- `SONAR_TOKEN`: Credentials for authenticating with SonarQube.
- `SONAR_PROJECT_URL`: SonarQube project overview link.
- `SONAR_HOST_URL`: SonarQube server URL.
- `SONAR_PROJECT_KEY`: Unique key for the SonarQube project.
- `SONAR_PROJECT_NAME`: Name of the SonarQube project.
- `SONAR_ORG`: SonarQube organization identifier.

## Pipeline Stages

### 1. Checkout Code

- Pulls the latest code from the repository.
- Uses the Jenkins `git` step to retrieve the source code.

### 2. SonarQube Analysis

- Runs static code analysis using SonarScanner.
- Executes the following command:

  ```sh
  ${SONAR_SCANNER}/bin/sonar-scanner \
    -Dsonar.projectKey=${SONAR_PROJECT_KEY} \
    -Dsonar.organization=${SONAR_ORG} \
    -Dsonar.host.url=${SONAR_HOST_URL} \
    -Dsonar.login=${SONAR_TOKEN}
  ```

- Sends results to the SonarQube dashboard.

### 3. Build Application

- Compiles the application source code.
- Uses `mvn clean install` for Java-based projects.

### 4. Deploy Application

- Deploys the application to a specified environment.
- May include SSH deployment commands or containerization steps.

## Setting Up the Jenkins Pipeline

1. **Open Jenkins Dashboard**

2. **Create a New Pipeline**:

   - Click "New Item" and select "Pipeline".
   - Enter a name and click "OK".

3. **Configure the Pipeline**:

   - Select "Pipeline script from SCM".
   - Choose "Git" and enter the repository URL.
   - Set "Script Path" to `Jenkinsfile`.

4. **Save and Build**:

   - Click "Save".
   - Click "Build Now" to run the pipeline.

## Viewing SonarQube Results

- Visit the SonarQube project dashboard at `${SONAR_PROJECT_URL}`.
- Review code quality metrics and security vulnerabilities.
