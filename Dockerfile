FROM node:22-alpine AS builder

WORKDIR /juice-shop

# 1. Skopiuj aplikację i narzędzia do obrazu
COPY . .
COPY tools /tools

# 2. Zainstaluj dependencies
RUN npm ci

# 3. Buduj frontend i backend
RUN npm run build:frontend
RUN npm run build:server

# 4. Czyść niepotrzebne pliki frontendowe, żeby zmniejszyć obraz
RUN rm -rf frontend/node_modules frontend/.angular frontend/src/assets

# 5. Przygotuj katalog na logi i nadaj prawa dla użytkownika node
RUN mkdir logs && chown -R node:node logs

USER node

EXPOSE 3000

CMD ["node", "build/app"]

