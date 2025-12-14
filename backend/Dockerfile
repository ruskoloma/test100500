FROM node:24-alpine

WORKDIR /app

COPY app.js package*.json ./

RUN npm ci

EXPOSE 3000

CMD ["node", "app.js"]
