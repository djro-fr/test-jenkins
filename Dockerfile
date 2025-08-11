# Image de base Node.js avec Alpine
FROM node:24-alpine3.21

# Install de Git
RUN apk update && apk add --no-cache git

# On crée le répertoire de travail
WORKDIR /

# On installe React dans le répertoire de l'application
RUN npm create vite@latest app -- --template react -- --yes

# On se déplace dans le répertoire de l'application pour les prochaines commandes
WORKDIR /app

# On copie les fichiers de configuration npm de l'app
COPY package*.json ./

# On copie tous les fichiers de l'app
COPY . .

