FROM node:22-alpine AS builder

WORKDIR /juice-shop

# 1. Skopiuj wszystko na raz
COPY . .

# 2. Teraz dopiero instaluj dependencies
RUN npm ci

# 3. Buduj frontend i backend
RUN npm run build:frontend
RUN npm run build:server

# 4. Czyść niepotrzebne pliki
RUN rm -rf frontend/node_modules frontend/.angular frontend/src/assets

# 5. Przygotuj logi i właściciela
RUN mkdir logs && chown -R node:node logs

USER node

EXPOSE 3000

CMD ["node", "build/app"]
