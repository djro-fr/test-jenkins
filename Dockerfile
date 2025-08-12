# On utilise une image Node.js sur Alpine pour le build
# Étape de Build : On construit notre application React. 
# Installation des dépendances et création des fichiers de production 
FROM node:alpine AS build

# Répertoire de travail
WORKDIR /app_syl

# On copie les fichiers package (npm)
COPY package*.json ./

# On installe les dépendances Node
RUN npm install

# On copie le reste des fichiers de l'application
COPY . .

# On construit le build de l'application
RUN npm run build