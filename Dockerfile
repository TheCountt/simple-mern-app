# syntax=docker/dockerfile:1
FROM node:alpine3.16
# FROM node:18.5.0 #
LABEL "maintainer"="isaac@exp.com"

# Specify the directory inside the image in which all commands will run
WORKDIR /usr/src/app

# Copy package files and install dependencies
COPY package*.json ./
RUN npm install

# Copy all of the app files into the image
COPY . .

EXPOSE 5001

CMD ["npm", "run", "dev"]