pipeline {

    agent {
        docker {
            image 'node:24-alpine3.21'
            args '-u root:root' // Exécute le conteneur en tant que root
        }
    }

    stages {
        stage('Checkout') {
            steps {
                // Installe Git dans l'image Alpine
                echo 'Installation de Git dans Alpine'
                sh 'apk update'
                sh 'apk add git'
            }
            steps {
                checkout scm
            }
        }
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