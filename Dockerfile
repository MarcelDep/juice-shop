FROM node:22-alpine AS builder

WORKDIR /juice-shop

# Skopiuj aplikację i narzędzia do obrazu
COPY . .
COPY tools /tools

# Dodaj tools do PATH
ENV PATH="/tools:${PATH}"

# Zainstaluj dependencies i narzędzia systemowe
RUN apk add --no-cache bash curl openjdk11 \
    && npm ci

# Buduj frontend i backend
RUN npm run build:frontend
RUN npm run build:server

# Usuń zbędne pliki frontendowe, aby zmniejszyć obraz
RUN rm -rf frontend/node_modules frontend/.angular frontend/src/assets

# Przygotuj katalog na logi i nadaj prawa dla użytkownika node
RUN mkdir logs && chown -R node:node logs

USER node

EXPOSE 3000

CMD ["node", "build/app"]


