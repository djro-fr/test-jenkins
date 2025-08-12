# On utilise une image Node.js sur Alpine pour le build
# Étape de Build : On construit notre application React. 
# Installation des dépendances et création des fichiers de production 
FROM node:alpine AS build

# Répertoire de travail
WORKDIR /app

# On copie les fichiers package (npm)
COPY app_syl/package*.json ./

# On installe les dépendances Node
RUN npm install

# Copie le reste des fichiers de l'application depuis le répertoire app_syl
COPY app_syl/ .

# On construit le build de l'application
RUN npm run build