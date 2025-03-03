pipeline {
    agent any

    environment {
        AWS_REGION = 'us-east-1' // AWS region
    }

    stages {
        stage('Set AWS Credentials') {
            steps {
                withCredentials([
                    [
                        $class: 'AmazonWebServicesCredentialsBinding',
                        credentialsId: 'Jenkins3',
                        accessKeyVariable: 'AWS_ACCESS_KEY_ID',
                        secretKeyVariable: 'AWS_SECRET_ACCESS_KEY'
                    ]
                ]) {
                    sh '''
                    export AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID
                    export AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY
                    aws sts get-caller-identity # Verify AWS credentials
                    '''
                }
            }
        }

        stage('Checkout Code') {
            steps {
                git branch: 'main', url: 'https://github.com/tiqsclass6/synk-jenkins'
            }
        }

        stage('Build') {
            steps {
                echo 'Building the project...'
            }
        }

        stage('Snyk Security Scan (Pre-Deploy)') {
            steps {
                snykSecurity(
                    snykInstallation: 'Snyk-CLI',
                    snykTokenId: 'snyk_token',
                    monitorProjectOnBuild: true,
                    failOnIssues: false
                )
            }
        }

        stage('Test') {
            steps {
                echo 'Running tests...'
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
                snykSecurity(
                    snykInstallation: 'Snyk-CLI',
                    snykTokenId: 'snyk_token',
                    monitorProjectOnBuild: true, // Enables continuous tracking in Snyk UI
                    failOnIssues: false  // Monitoring should not block deployment
                )
            }
        }
    }

    post {
        always {
            echo 'Pipeline execution completed. Monitoring continues...'
        }
        success {
            echo 'Deployment and security scans completed successfully!'
        }
        failure {
            echo 'Pipeline execution failed! Check the logs for issues.'
        }
    }

    triggers {
        cron('H 2 * * 1-5') // Runs Snyk monitoring every weekday at 2 AM
    }
}
