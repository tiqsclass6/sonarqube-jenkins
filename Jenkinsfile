pipeline {
    agent any

    environment {
        AWS_REGION = 'us-east-1' // AWS region
    }

    triggers {
        cron('H 2 * * 1-5') // Runs every weekday (Monday-Friday) at 2 AM UTC
    }

    stages {
        stage('Checkout Code') {
            steps {
                script {
                    echo "Checking out source code from GitHub..."
                    
                    try {
                        checkout([$class: 'GitSCM',
                            branches: [[name: '*/main']],
                            userRemoteConfigs: [[url: 'https://github.com/tiqsclass6/synk-jenkins']]
                        ])
                        echo "Code checkout successful."
                    } catch (Exception e) {
                        echo "Git checkout failed. Check repository URL and branch."
                        error("Pipeline failed due to Git checkout error.")
                    }

                    echo "Listing workspace contents..."
                    sh 'ls -la'
                }
            }
        }

        stage('Install Node.js & npm') {
            steps {
                script {
                    echo "Installing Node.js and npm..."
                    sh '''
                    curl -fsSL https://deb.nodesource.com/setup_18.x | bash -
                    sudo apt-get install -y nodejs
                    node -v
                    npm -v
                    '''
                }
            }
        }

        stage('Install Snyk') {
            steps {
                script {
                    echo "Installing Snyk..."
                    sh 'chmod +x snyk.sh && ./snyk.sh'  // Run the uploaded Snyk installation script
                }
            }
        }

        stage('Install Dependencies') {
            steps {
                script {
                    echo "Checking for dependencies..."

                    if (fileExists('package.json')) {
                        echo "Node.js project detected. Installing dependencies..."
                        sh 'npm install || echo "npm install failed, check logs for details."'
                    } else if (fileExists('requirements.txt')) {
                        echo "Python project detected. Installing dependencies..."
                        sh 'pip install -r requirements.txt || echo "pip install failed, check logs for details."'
                    } else if (fileExists('pom.xml')) {
                        echo "Java project detected. Running Maven build..."
                        sh 'mvn clean install || echo "Maven build failed, check logs for details."'
                    } else {
                        echo "No recognized dependency file found. Skipping dependency installation."
                    }
                }
            }
        }

        stage('Build') {
            steps {
                script {
                    if (fileExists('package.json')) {
                        echo "Node.js project detected. Installing dependencies..."
                        sh 'npm install'
                    } else if (fileExists('requirements.txt')) {
                        echo "Python project detected. Installing dependencies..."
                        sh 'pip install -r requirements.txt'
                    } else if (fileExists('pom.xml')) {
                        echo "Java project detected. Running Maven build..."
                        sh 'mvn clean install'
                    } else {
                        echo "No recognized dependency file found. Skipping installation."
                    }
                }
            }
        }

        stage('Snyk Scan') {
            steps {
                script {
                    echo "Running Snyk security scan..."
                    sh 'ls -la'

                    if (fileExists('package.json')) {
                        echo "package.json found. Running Snyk scan for Node.js project..."
                        sh 'snyk test --file=package.json || echo "Snyk scan encountered issues, but pipeline continues."'
                    } else {
                        echo "package.json not found. Skipping Snyk scan."
                    }
                }
            }
        }

        stage('Terraform Setup & Validation') {
            steps {
                sh '''
                terraform init
                terraform validate
                '''
            }
        }

        stage('Terraform Plan') {
            steps {
                sh 'terraform plan -out=tfplan'
            }
        }

        stage('Terraform Apply') {
            steps {
                input message: "Approve Terraform Apply?", ok: "Deploy"
                sh 'terraform apply -auto-approve tfplan'
            }
        }

        stage('Deploy') {
            steps {
                echo 'Deploying application...'
            }
        }
        
        stage('Snyk Continuous Monitoring (Post-Deploy)') {
            steps {
                script {
                    echo "Running Snyk Continuous Monitoring after deployment..."

                    try {
                        snykSecurity(
                            snykInstallation: 'Snyk-CLI',
                            snykTokenId: 'snyk_token',
                            monitorProjectOnBuild: true,
                            failOnIssues: false
                        )
                        echo "Snyk Continuous Monitoring completed successfully."
                    } catch (Exception e) {
                        echo "Snyk monitoring encountered an issue: ${e.message}"
                        echo "Pipeline will continue, but please check the logs."
                    }
                }
            }
        }

        stage('Terraform Destroy') {
            steps {
                input message: "Approve Terraform Destroy?", ok: "Destroy"
                sh '''
                terraform destroy -auto-approve
                '''
            }
        }
    }

    post {
        always {
            echo 'Pipeline execution completed. Monitoring continues...'
        }
    }
}