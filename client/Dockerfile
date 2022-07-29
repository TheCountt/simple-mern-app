# syntax=docker/dockerfile:1
# Build react client
FROM node:alpine3.16

# Working directory be app
WORKDIR /usr/src/app

COPY package*.json ./

###  Installing dependencies

RUN npm install

# copy local files to app folder
COPY . .

# expose this port so application can be reached 
EXPOSE 3000

CMD ["npm","start"]