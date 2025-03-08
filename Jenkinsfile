pipeline {
    agent any

    environment {
        SONAR_SCANNER = tool 'SonarScanner'
        SONAR_TOKEN = credentials('SONARQUBE_TOKEN')
        SONAR_PROJECT_URL = 'https://sonarcloud.io/project/overview?id=tiqsclass6_sonarqube-jenkins'
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
                        export PATH=$SONAR_SCANNER/bin:$PATH
                        sonar-scanner \
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
                script {
                    echo "SonarQube analysis complete. View results at: ${SONAR_PROJECT_URL}"
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