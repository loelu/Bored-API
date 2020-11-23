FROM node:15

WORKDIR /usr/src/app

COPY package*.json ./
RUN npm install --only=production
COPY . .
RUN npm run build

USER node

EXPOSE 5000
CMD [ "node", "server.js" ]