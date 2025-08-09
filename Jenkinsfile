pipeline {

    agent { docker { image 'node:22.14.0-alpine3.22' } }

    stages {
        stage('Build') {
            steps {
                echo 'Building..14'                
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