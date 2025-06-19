FROM node:22-alpine AS builder

WORKDIR /juice-shop

# Skopiuj wszystko (lub przynajmniej frontend i package*.json)
COPY . .

# (opcjonalnie) zainstaluj narzędzia budujące dla natywnych paczek
RUN apk add --no-cache python3 make g++

RUN npm ci --only=production

RUN npm run build

RUN rm -rf frontend/node_modules frontend/.angular frontend/src/assets

RUN mkdir logs && chown -R node:node logs

USER node

EXPOSE 3000

CMD ["node", "build/app.js"]
