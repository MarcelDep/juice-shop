FROM node:22-alpine AS builder

WORKDIR /juice-shop

# Kopiujemy package.json i package-lock.json
COPY package*.json ./

# Instalujemy wszystkie dependencies (dev i prod) bo frontend build tego wymaga
RUN npm ci

# Kopiujemy resztę plików
COPY . .

# Budujemy frontend i backend
RUN npm run build:frontend
RUN npm run build:server

# Usuwamy frontendowe node_modules oraz niepotrzebne pliki, żeby zmniejszyć obraz
RUN rm -rf frontend/node_modules frontend/.angular frontend/src/assets

# Tworzymy folder na logi i zmieniamy właściciela
RUN mkdir logs && chown -R node:node logs

# Ustawiamy użytkownika node
USER node

# Otwieramy port
EXPOSE 3000

# Uruchamiamy aplikację
CMD ["node", "build/app"]
