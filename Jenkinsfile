pipeline {

    agent { docker { image 'node:22.18.0-alpine3.22' } }

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