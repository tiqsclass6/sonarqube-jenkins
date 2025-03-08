pipeline {
    agent any

    environment {
        SONAR_SCANNER = tool name: 'SonarQube', type: 'hudson.plugins.sonar.SonarRunnerInstallation'
        SONAR_TOKEN = credentials('SONARQUBE_TOKEN')
    }

    stages {
        stage('Checkout Code') {
            steps {
                git url: 'https://github.com/tiqsclass6/sonarqube-jenkins.git', branch: 'main'
            }
        }

        stage('SonarQube Analysis') {
            steps {
                withSonarQubeEnv('SonarQube') {
                    sh """
                        ${SONAR_SCANNER}/bin/sonar-scanner \
                        -Dsonar.projectKey=tiqsclass6_sonarqube-jenkins \
                        -Dsonar.organization=tiqs \
                        -Dsonar.sources=. \
                        -Dsonar.host.url=https://sonarcloud.io \
                        -Dsonar.login=${SONAR_TOKEN} \
                        -Dsonar.scm.provider=git \
                        -Dsonar.java.binaries=target/classes \
                        -Dsonar.sourceEncoding=UTF-8 \
                        -Dsonar.verbose=true
                    """
                }
            }
        }

    post {
        always {
            cleanWs()
        }
    }
}