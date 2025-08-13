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
                //    Affiche les logs pour le débogage en cas d'erreur
                sh '''
                    # Fonction pour afficher les messages sans le "+" de Jenkins
                    log() {
                        echo "→ $1" >&2  # Redirige vers stderr pour éviter le "+"
                    }

                    cd app_syl                   
                   
                    log " 1- Installation des dépendances pour Selenium"
                    log " ...................."
                    apt-get update && apt-get install -y firefox-esr wget netcat-openbsd
                    wget https://github.com/mozilla/geckodriver/releases/download/v0.34.0/geckodriver-v0.34.0-linux64.tar.gz
                    tar -xvzf geckodriver-v0.34.0-linux64.tar.gz
                    chmod +x geckodriver
                    mv geckodriver /usr/bin/

                    log " 2- Lance Vite en arrière-plan (sur 0.0.0.0)"
                    log "  et récupère le PID pour pouvoir tuer le processus plus tard"
                    log " ...................."
                    npm run dev -- --host 0.0.0.0 > react.log 2>&1 &
                    PID=$!  

                    log " 3- Attends que le port 5173 soit ouvert"
                    log " ...................."
                    log "Attente du démarrage de Vite sur le port ${REACT_APP_PORT}..."
                    MAX_ATTEMPTS=15
                    ATTEMPT=0
                    while ! nc -z localhost ${REACT_APP_PORT}; do
                    if [ $ATTEMPT -ge $MAX_ATTEMPTS ]; then
                        echo "Timeout: Le port ${REACT_APP_PORT} n'est pas accessible après $MAX_ATTEMPTS tentatives"
                        cat react.log
                        exit 1
                    fi
                    ATTEMPT=$((ATTEMPT + 1))
                    sleep 2
                    echo "Tentative $ATTEMPT/$MAX_ATTEMPTS..."
                    done
                    echo "Vite est prêt !"
                    
                    log " 4- Exécute les tests Selenium avec Firefox"
                    log ":::::::::::::::::::::::::::::::::::::::::::"
                    npm run ui_test
                    log ":::::::::::::::::::::::::::::::::::::::::::"

                    log " 5- Arrête Vite même si les tests échouent, "
                    log "    Affiche les logs pour le débogage en cas d'erreur"
                    log " ...................."
                    kill $PID || true
                    cat react.log 
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