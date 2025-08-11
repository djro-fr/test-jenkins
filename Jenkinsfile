pipeline {

    agent {
        docker {
            image 'node:24-alpine3.21'
            args '-u root:root' // Exécute le conteneur en tant que root
        }
    }

    stages {
        stage('Git') {
            steps {
                // Installe Git dans l'image Alpine
                echo 'Git Installation in Alpine'
                sh '''apk update && apk add --no-cache git'''
            }
        }
        stage('Build') {
            steps {
                echo 'Building : React with Vite'               
                sh '''
                    npm create vite@latest my-app -- --template react -- --yes \
                    cd my-app \
                    npm install \
                    npm run dev
                '''
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