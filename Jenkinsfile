pipeline {
    agent any

    tools {
        nodejs 'NodeJS-18' // Uses Node.js installed via Jenkins Global Tool Configuration
    }

    environment {
        AWS_REGION = 'us-east-1' // AWS region
        SNYK_TOKEN = credentials('SNYK_TOKEN') 
    }

    triggers {
        cron('H 2 * * 1-5') // Runs every weekday (Monday-Friday) at 2 AM UTC
    }

    stages {
        stage('Set AWS Credentials') {
            steps {
                withCredentials([[
                    $class: 'AmazonWebServicesCredentialsBinding',
                    credentialsId: 'snyk_cred',
                    accessKeyVariable: 'AWS_ACCESS_KEY_ID',
                    secretKeyVariable: 'AWS_SECRET_ACCESS_KEY'
                ]]) {
                    sh '''
                    export AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID
                    export AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY
                    aws sts get-caller-identity
                    '''
                }
            }
        }
        
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

        stage('Install Snyk') {
            steps {
                script {
                    echo "Installing Snyk..."
                    sh 'npm install -g snyk'
                    sh 'snyk --version'
                }
            }
        }

        stage('Update Dependencies') {
            steps {
                script {
                    echo "Checking for outdated npm packages..."
                    sh '''
                    npm install -g npm-check-updates
                    ncu -u
                    npm install
                    '''
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

        stage('Snyk Scan') {
            steps {
                script {
                    echo "Authenticating with Snyk..."
                    sh 'snyk auth $SNYK_TOKEN'

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

        stage('Initialize Terraform') {
            steps {
                sh 'terraform init'
            }
        }

        stage('Validate Terraform') {
            steps {
                sh 'terraform validate'
            }
        } 

        stage('Plan Terraform') {
            steps {
                withCredentials([[
                    $class: 'AmazonWebServicesCredentialsBinding',
                    credentialsId: 'snyk_cred',
                    accessKeyVariable: 'AWS_ACCESS_KEY_ID',
                    secretKeyVariable: 'AWS_SECRET_ACCESS_KEY'
                ]]) {
                    sh '''
                    export AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID
                    export AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY
                    terraform plan -out=tfplan
                    '''
                }
            }
        }

        stage('Apply Terraform') {
            steps {
                input message: "Approve Terraform Apply?", ok: "Deploy"
                withCredentials([[
                    $class: 'AmazonWebServicesCredentialsBinding',
                    credentialsId: 'snyk_cred',
                    accessKeyVariable: 'AWS_ACCESS_KEY_ID',
                    secretKeyVariable: 'AWS_SECRET_ACCESS_KEY'
                ]]) {
                    sh '''
                    export AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID
                    export AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY
                    terraform apply -auto-approve tfplan
                    '''
                }
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
                            snykTokenId: 'SNYK_TOKEN',
                            monitorProjectOnBuild: true,
                            failOnIssues: false
                        )
                        echo "Snyk Continuous Monitoring completed successfully."
                    } catch (Exception e) {
                        echo "Snyk monitoring encountered an issue: ${e}"
                        echo "Pipeline will continue, but please check the logs."
                    }
                }
            }
        }

        stage('Destroy Terraform') {
            steps {
                input message: "Do you want to destroy the Terraform resources?", ok: "Destroy"
                withCredentials([[
                    $class: 'AmazonWebServicesCredentialsBinding',
                    credentialsId: 'snyk_cred',
                    accessKeyVariable: 'AWS_ACCESS_KEY_ID',
                    secretKeyVariable: 'AWS_SECRET_ACCESS_KEY'
                ]]) {
                    sh '''
                    export AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID
                    export AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY
                    terraform destroy -auto-approve
                    '''
                }
            }
        }
    }

    post {
        always {
            echo 'Pipeline execution completed. Monitoring continues...'
        }
    }
}