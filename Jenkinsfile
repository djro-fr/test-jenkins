pipeline {
    // Pas d'agent global, chaque stage aura son propre agent
    agent none 

    environment {
        // Variables d'environnement nécessaires pour le déploiement
        DOCKER_HUB_USERNAME = 'djrofr'
        DOCKER_IMAGE = 'la-belle-app-react'
        REACT_APP_URL = 'http://localhost:5173'
        REACT_APP_PORT = '5173'  
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
                // installe Git
                sh '''
                    apk add --no-cache git 
                    git --version
                '''
                // Utilise la configuration SCM définie dans le projet Jenkins
                checkout scm 
            }    
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
                echo "Node Dependencies"
                sh '''
                    cd app_syl
                    npm install
                '''
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
                echo "Unit Tests with Jest"
                sh '''
                    cd app_syl
                    npm run unit_test'''
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
                echo "Tests d'intégration"
            }
        }
        stage('TEST: Exécution des tests UI (Selenium)') {      
            agent {
                docker {
                    // Utilise une image Node.js standard
                    image 'node:20'
                    args '-u root'
                }
            }
            steps {
                // 1- Installation des dépendances pour Selenium
                // 2- Lance Vite en arrière-plan (sur 0.0.0.0)
                //    et récupère le PID pour pouvoir tuer le processus plus tard
                // 3- Attends que le port 5173 soit ouvert
                // 4- Exécute les tests Selenium avec Firefox
                // 5- Arrête Vite même si les tests échouent, 
                //    Affiche les echos pour le débogage en cas d'erreur
                sh '''
                    cd app_syl

                    # Installation des dépendances
                    printf "\n\033[1;32m→ 1- Installation des dépendances pour Selenium \033[0m\n"
                    apt-get update -qq > /dev/null
                    apt-get install -y firefox-esr wget netcat-openbsd > /dev/null
                    wget https://github.com/mozilla/geckodriver/releases/download/v0.34.0/geckodriver-v0.34.0-linux64.tar.gz -q
                    tar -xvzf geckodriver-v0.34.0-linux64.tar.gz
                    chmod +x geckodriver
                    mv geckodriver /usr/bin/

                    # Lancement de Vite
                    printf "\n\033[1;32m→ 2- Lancement de Vite sur le port ${REACT_APP_PORT} \033[0m\n"
                    npm run dev -- --host 0.0.0.0 > react.log 2>&1 &
                    PID=$!
                    sleep 10

                    # Vérification du port
                    printf "\n\033[1;32m→ 3- Vérification du port ${REACT_APP_PORT} \033[0m\n"
                    MAX_ATTEMPTS=15
                    ATTEMPT=0
                    while ! nc -z localhost ${REACT_APP_PORT}; do
                        if [ $ATTEMPT -ge $MAX_ATTEMPTS ]; then
                            echo -e "\033[1;31m❌ Timeout: Port ${REACT_APP_PORT} inaccessible \033[0m\n" >&2
                            cat react.log >&2
                            exit 1
                        fi
                        ATTEMPT=$((ATTEMPT + 1))
                        sleep 2
                        echo -e "\033[1;33m→ Tentative $ATTEMPT/$MAX_ATTEMPTS... \033[0m\n" >&2
                    done
                    printf "\n\033[1;32m✅ Vite est prêt sur le port ${REACT_APP_PORT} ! \033[0m\n"

                    # Exécution des tests
                    printf "\n\033[1;32m→ 4- Exécution des tests Selenium \033[0m\n"
                    npm run ui_test

                    # Nettoyage
                    printf "\n\033[1;32m→ 5- Nettoyage \033[0m\n"
                    kill $PID || true
                    cat react.log >&2
                '''
            }
        }
        stage('BUILD: Build Docker Image') {
            agent {
                docker {
                    image 'docker:stable'
                    args '-v /var/run/docker.sock:/var/run/docker.sock -u root'
                }
            }
            steps {
                script {
                    withCredentials([string(
                        credentialsId: 'docker_hub_token', 
                        variable: 'DOCKER_HUB_TOKEN')]) {
                        sh '''
                            echo $DOCKER_HUB_TOKEN | \
                            docker login -u $DOCKER_HUB_USERNAME --password-stdin
                        '''
                    }
                    sh '''
                        docker build -t ${DOCKER_IMAGE} . &&
                        docker tag ${DOCKER_IMAGE} $DOCKER_HUB_USERNAME/${DOCKER_IMAGE}:latest &&
                        docker push $DOCKER_HUB_USERNAME/${DOCKER_IMAGE}:latest
                    '''
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
                    // Monte le socket Docker et exécute en tant que root
                    args '-v /var/run/docker.sock:/var/run/docker.sock -u root' 
                }
            }
            steps {
                script {
                    echo "Déploiement de l\'application en container..."
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
                    echo "Déploiement de l\'application..."
                    // Ajoutez ici les commandes pour déployer votre application
                }
            }
        }
    }
}