## Build Stage 1
# syntax=docker/dockerfile:1
FROM node:alpine3.16 as builder
LABEL "maintainer"="isaac@experiment.com"

# install curl
# RUN apk add curl --no-cache

# Specify the directory inside the image in which all commands will run
WORKDIR /usr/src/app

# Copy package files and install dependencies
COPY package*.json ./
RUN npm install

# Copy all of the app files into the image
COPY . .

EXPOSE 5001

# HEALTHCHECK --interval=30s --timeout=3s \
#   CMD curl -f http://localhost:5001/api/todos || exit 1

CMD ["npm", "run", "dev"]

## Build Stage 2

# Build react client
FROM node:alpine3.16

# Working directory be app
WORKDIR /usr/src/app

COPY package*.json ./

###  Installing dependencies

RUN npm install

# copy previous stage build
COPY --from=builder /usr/src/app/dist ./dist

# expose this port so application can be reached 
EXPOSE 3000

CMD ["npm","start"]