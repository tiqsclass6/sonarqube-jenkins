pipeline {
    agent any

    environment {
        SONAR_TOKEN = credentials('SONARQUBE_TOKEN')
        SONAR_PROJECT_URL = 'https://sonarcloud.io/project/overview?id=tiqsclass6_sonarqube-jenkins'
        SONAR_HOST_URL = 'https://sonarcloud.io'
        SONAR_PROJECT_KEY = 'tiqsclass6_sonarqube-jenkins'
        SONAR_PROJECT_NAME = 'sonarqube-jenkins'
        SONAR_ORG = 'tiqs'
    }

    stages {
        stage('Checkout Code') {
            steps {
                git url: 'https://github.com/tiqsclass6/sonarqube-jenkins.git', branch: 'main'
            }
        }

        stage('SonarQube Analysis') {
            steps {
                withSonarQubeEnv('sq1') {
                    script {
                        def scannerHome = tool 'test'
                        sh """
                        ${scannerHome}/bin/sonar-scanner \
                            -Dsonar.projectKey=${SONAR_PROJECT_KEY} \
                            -Dsonar.projectName=${SONAR_PROJECT_NAME} \
                            -Dsonar.sources=. \
                            -Dsonar.host.url=${SONAR_HOST_URL} \
                            -Dsonar.language=terraform \
                            -Dsonar.organization=${SONAR_ORG} 
                        """
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