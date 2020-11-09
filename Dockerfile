FROM node:15

WORKDIR /usr/src/app

COPY . .
RUN npm install --only=production
RUN npm run build

USER node

EXPOSE 5000
CMD [ "node", "server.js" ]