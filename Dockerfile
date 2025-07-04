FROM node:22-alpine AS builder

WORKDIR /juice-shop

COPY package*.json ./

RUN npm ci --only=production

COPY . .

RUN npm run build

RUN rm -rf frontend/node_modules frontend/.angular frontend/src/assets

RUN mkdir logs && chown -R node:node logs

USER node

EXPOSE 3000

CMD ["node", "build/app.js"]
