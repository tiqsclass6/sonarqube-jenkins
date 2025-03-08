pipeline {
    agent any

    environment {
        AWS_REGION = 'us-east-1'
        SONARQUBE_TOKEN = credentials('SONARQUBE_TOKEN')
        SONAR_PROJECT_KEY = 'tiqsclass6_sonarqube-jenkins'
        SONAR_ORG = 'tiqs'
    }

    stages {
        stage('Checkout Code') {
            steps {
                script {
                    echo "Checking out source code from GitHub..."
                    checkout([
                        $class: 'GitSCM',
                        branches: [[name: '*/main']],
                        userRemoteConfigs: [[url: 'https://github.com/tiqsclass6/sonarqube-jenkins']]
                    ])
                    echo "Code checkout successful."
                    sh 'ls -la'
                }
            }
        }

        stage('SonarQube Analysis') {
            steps {
                withSonarQubeEnv('SonarCloud') { // Use the actual configured SonarQube installation name
                    sh '''
                        sonar-scanner \
                        -Dsonar.projectKey=tiqsclass6_sonarqube-jenkins \
                        -Dsonar.host.url=https://sonarcloud.io \
                        -Dsonar.organization=tiqs \
                        -Dsonar.login=$SONARQUBE_TOKEN
                    '''
                }
            }
        }

        stage('Quality Gate Check') {
            steps {
                script {
                    timeout(time: 5, unit: 'MINUTES') {
                        def qg = waitForQualityGate()
                        if (qg.status != 'OK') {
                            echo "WARNING: Quality Gate failed, but continuing build."
                        }
                    }
                }
            }
        }
    }

    post {
        always {
            echo 'Pipeline execution completed.'
        }
    }
}