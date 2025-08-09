pipeline {

    agent { docker { image 'node:24-alpine3.21' } }

    stages {
        stage('Build') {
            steps {
                echo 'Building..'                
                sh 'node --version'
            }
        }
        stage('Test') {
            steps {
                echo 'Testing..'
            }
        }
        stage('Deploy') {
            steps {
                echo 'Deploying....'
            }
        }
    }
}