# On utilise une image Node.js sur Alpine pour le build
# Étape de Build : On construit notre application React. 
# Installation des dépendances et création des fichiers de production 
FROM node:alpine as build

# Répertoire de travail
WORKDIR /app

# On copie les fichiers package (npm)
COPY package*.json ./

# On installe les dépendances Node
RUN npm install

# On copie le reste des fichiers de l'application
COPY . .

# On construit le build de l'application
RUN npm run build

# ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

# Pour le déploiement, on utilise une image Apache pour servir l'application
# Étape de Runtime : on utilise une image httpd:alpine (avec Apache)
# pour servir les fichiers statiques générés lors de l'étape de build.
FROM httpd:alpine

# Copie des fichiers de build dans le répertoire d'Apache
COPY --from=build /app/dist /usr/local/apache2/htdocs/

# Copie de la configuration Apache
COPY httpd.conf /usr/local/apache2/conf/httpd.conf

# On expose le port 80
EXPOSE 80
    