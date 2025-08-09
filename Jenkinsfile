pipeline {

    agent { docker { image 'node:24-alpine3.21' } }

    stages {
        stage('Build') {
            steps {
                echo 'Building..'               
                sh 'npx create-react-app my-app'
                sh 'cd my-app'
                sh 'npm start'
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