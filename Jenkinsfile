pipeline {
    agent any
    environment {
        AWS_REGION = 'us-east-1' // Specify your AWS region
    }
    stages {
        stage('Set AWS Credentials') {
            steps {
                withCredentials([[
                    $class: 'AmazonWebServicesCredentialsBinding',
                    credentialsId: 'Jenkins3' // Replace with your Jenkins credential ID
                ]]) {
                    sh 'aws sts get-caller-identity' // Test AWS credentials
                }
            }
        }
        stage('Checkout Code') {
            steps {
                git branch: 'main', url: 'https://github.com/tiqsclass6/synk-jenkins' // Replace with your Git repository URL
            }
        }
        stage('Initialize Terraform') {
            steps {
                sh '''
                terraform init
                '''
            }
        }
        stage('Validate Terraform') {
            steps {
                sh '''
                terraform validate
                '''
            }
        }
        stage('Plan Terraform') {
            steps {
                sh '''
                terraform plan -out=tfplan
                '''
            }
        }
        stage('Apply Terraform') {
            steps {
                input message: "Approve Terraform Apply?", ok: "Deploy"
                sh '''
                terraform apply -auto-approve tfplan
                '''
            }
        }

        stage('Terraform Destroy') {
            steps {
                input message: "Do you want to destroy the Terraform resources?", ok: "Destroy"
                withCredentials([[ 
                    $class: 'AmazonWebServicesCredentialsBinding',
                    credentialsId: 'Jenkins3',
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
    
    post {
        success {
            echo 'Terraform deployment completed successfully!'
        }
        failure {
            echo 'Terraform deployment failed!'
        }
    }
}