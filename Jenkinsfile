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
                echo 'Building: React with Vite'               
                sh '''
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