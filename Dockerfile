FROM node:12.8

RUN groupmod -g 1001 node \
  && usermod -u 1001 -g 1001 node

WORKDIR /app

COPY package*.json ./

RUN npm ci --only=production

COPY . .

ARG COMMIT_SHA
ENV ENV_COMMIT_SHA=${COMMIT_SHA}

EXPOSE 8080

CMD [ "npm", "run", "start" ]
