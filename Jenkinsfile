pipeline {
    agent {
        docker {
            image 'node:14'
        }
    }

    stages {
        stage('Prepare Environment') {
            steps {
                sh "bash devops/install-docker-and-docker-compose.sh"
                sh "npm install"
            }
        }
        stage('Build') {
            steps {
                sh "npm run build"
            }
        }
        stage('SonarQube Analysis') {
            steps {
                withSonarQubeEnv('https://sonar:9000/'){
                    sh "npm run sonar"
                }
                timeout(time:10, unit: 'MINUTES'){
                    waitForQualityGate abortPipeline: true
                }
            }   
        }
        stage('Unit Tests') {
            steps {
                echo "pass unit tests at the moment"
            }
        }
        stage('Security Tests with ZAP') {
            steps {
                sh "docker-compose up --build -d"
                sh "docker run --user root --rm -v \$(pwd):/zap/wrk/:rw -t owasp/zap2docker-stable zap-baseline.py -t http://172.17.0.1:5000 -x report.xml || true"
            }
            post {
                always {
                    junit 'report.xml'
                    sh "docker-compose down"
                }
            }
        }
        stage('Acceptance Test') {
            steps {
                sh "npm run test"
            }
            post {
                always {
                    junit 'test/integration-test-results.xml'
                    junit 'test/db-test-results.xml'
                }
            }
        }
        stage('Build image') {
            steps {
                sh "docker build -t viclo/boredapi:test docker build -t viclo/boredapi:latest -t viclo/boredapi:test"
            }
        }
        stage('Push test tag to dockerhub') {
            environment {
                DOCKER_CREDS = credentials('DOCKER_LOGIN')
            }
            steps {
                sh "docker login -u $DOCKER_CREDS_USR -p $DOCKER_CREDS_PSW"
                sh "docker push viclo/boredapi:test"
            }
        }
        stage('Scan image') {
            environment {
                DOCKER_CREDS = credentials('DOCKER_LOGIN')
            }
            steps {
                sh "make clair-up"
                sh "make clair-run-test"
            }
            post {
                always {
                    sh "make clair-stop"
                }
            }
        }
        stage('Push latest tag to dockerhub') {
            environment {
                DOCKER_CREDS = credentials('DOCKER_LOGIN')
            }
            steps {
                sh "docker login -u $DOCKER_CREDS_USR -p $DOCKER_CREDS_PSW"
                sh "docker push viclo/boredapi:latest"
            }
        }
    }
    post {
        success {
            notifyTeams("Pipeline was successful", "SUCCESS")
        }
        failure {
            notifyTeams("Pipeline failed", "FAILURE")
        }
    }
}


def notifyTeams(msg, status) {
    office365ConnectorSend message: "${msg}", status:"${status}", webhookUrl:'${webhookUrl}' 
}
