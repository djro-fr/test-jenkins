pipeline {
    // Pas d'agent global, chaque stage aura son propre agent
    agent none 

    stages {
        stage('Build') {
            agent {
                docker {
                    image 'djrofr/la-belle-app-react'
                    args '-u root:root' 
                }
            }
            steps {
                // Installe Git dans l'image Alpine
                echo 'Git Installation in Alpine'
                sh 'apk update && apk add --no-cache git'

                echo 'Building: React with Vite'               
                sh '''
                    cd app \
                    npm install \
                    npm run dev
                '''
            }
        }
        stage('Test') {
            agent {
                docker {
                    image 'djrofr/la-belle-app-react'
                }
            }            
            steps {
                echo 'Testing..'
            }
        }
        stage('Deploy') {
            agent {
                docker {
                    image 'djrofr/la-belle-app-react'
                }
            }            
            steps {
                echo 'Deploying....'
            }
        }
    }
}