# syntax=docker/dockerfile:1
FROM node:alpine3.16
LABEL "maintainer"="isaac@experiment.com"

# install curl
RUN apk add curl --no-cache

# Specify the directory inside the image in which all commands will run
WORKDIR /usr/src/app

# Copy package files and install dependencies
COPY package*.json ./
RUN npm install

# Copy all of the app files into the image
COPY . .

EXPOSE 5001

HEALTHCHECK --interval=30s --timeout=3s \
  CMD curl -f http://localhost:5001/api/todos || exit 1

CMD ["npm", "run", "dev"]