pipeline {
    agent any

    environment {
        SONAR_SCANNER = tool 'SonarScanner' // Ensure the tool name matches Jenkins configuration
        SONAR_TOKEN = credentials('SONARQUBE_TOKEN')
        SONAR_PROJECT_URL = 'https://sonarcloud.io/project/overview?id=tiqsclass6_sonarqube-jenkins'
        SONAR_HOST_URL = 'https://sonarcloud.io'
        SONAR_PROJECT_KEY = 'tiqsclass6_sonarqube-jenkins'
        SONAR_PROJECT_NAME = 'SonarQube-Jenkins'
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
                withSonarQubeEnv('SonarQube') {
                    script {
                        def scannerHome = tool 'SonarScanner1'
                        sh """
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

                // Check for 'report-task.txt' and prompt user if missing
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