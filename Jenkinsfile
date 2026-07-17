pipeline {
    agent any

    stages {
        stage('Clone Repository') {
            steps {
                git branch: 'main', url: 'https://github.com/birajaprasadswain4-dot/DevOps-project.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                sh 'docker build -t mywebsite ./app'
            }
        }

        stage('Run Container') {
            steps {
                sh '''
                docker stop mywebsite-container || true
                docker rm mywebsite-container || true
                docker run -d --name mywebsite-container -p 8081:80 mywebsite
                '''
            }
        }
    }
}