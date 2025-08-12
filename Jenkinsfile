pipeline {
    // Pas d'agent global, chaque stage aura son propre agent
    agent none 

    environment {
        // Variables d'environnement nécessaires pour le déploiement
        DOCKER_IMAGE = 'djrofr/la-belle-app-react'
    }

    stages {
        stage('BUILD: Checkout Git') {
            agent {
                docker {
                    image 'node:alpine'
                    args '-u root' // Exécute le conteneur en tant qu'utilisateur root
                }
            }
            steps {
                sh '''
                    apk add --no-cache git  # Installe Git
                    git --version
                '''
                checkout([
                    $class: 'GitSCM',
                    branches: [[name: '*/test-react']],
                    extensions: [],
                    userRemoteConfigs: [[url: 'https://github.com/djro-fr/test-jenkins.git']]
                ])
            }    }
        }
        stage('BUILD: Installation dépendances') {
            // Installation des dépendances nécessaires
            // pour construire et exécuter l'application
            agent {
                docker {
                    // Image Node.js sur Alpine
                    image 'node:alpine' 
                }
            }
            steps {
                echo 'Node Dependencies'
                sh '''
                    npm create vite@latest app_syl -- --template react \
                    cd app_syl \
                    npm install'''
            }
        }
        stage('TEST: Exécution des tests unitaires') {
            // Exécution des tests unitaires 
            // pour vérifier que le code est exempt d'erreurs
            agent {
                docker {
                    // Image Node.js sur Alpine pour les tests
                    image 'node:alpine' 
                }
            }
            steps {
                echo 'Unit Tests with Jest'
                sh 'npm test' 
            }
        }
        stage('TEST: Exécution des tests d\'intégration') {
            // Exécution des tests d'intégration
            agent {
                docker {
                    // Image Node.js sur Alpine pour les tests
                    image 'node:alpine'
                }
            }
            steps {
                echo 'Tests d\'intégration'
            }
        }
        stage('BUILD: Build Docker Image') {
            // Construction de l'image Docker pour l'application
            agent {
                docker {
                    // Image Docker stable pour construire l'image
                    image 'docker:stable' 
                }
            }  
            steps {
                script {
                    sh "docker build -t ${DOCKER_IMAGE} ."
                }
            }
        }
        stage('DEPLOY: Exécution Container Docker') {
            // Exécution du conteneur Docker pour s'assurer que
            // l'application s'exécute correctement dans un environnement conteneurisé
            agent {
                docker {
                    // Image Docker stable pour exécuter le conteneur
                    image 'docker:stable' 
                }
            }
            steps {
                script {
                    echo 'Déploiement de l\'application en container...'
                    // sh "docker run -p 80:80 --rm ${DOCKER_IMAGE}"
                }
            }
        }
        stage('DEPLOY: Déploiement serveur') {
            // Déploiement de l'application sur un serveur
            agent {
                docker {
                    image 'alpine' // Utilise une image Alpine légère pour le déploiement
                }
            }
            steps {
                script {
                    echo 'Déploiement de l\'application...'
                    // Ajoutez ici les commandes pour déployer votre application
                }
            }
        }
    }
}