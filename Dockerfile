# syntax=docker/dockerfile:1
## Build stage 1
FROM node:lts-alpine3.16 AS ui-build

# Specify the directory inside the image in which all commands will run
WORKDIR /usr/src/app

# copy files from client folder on machine to client folder in container
COPY client/ ./client/

# change directory to client and run subsequent commands
RUN cd client && npm install

# expose this port so application can be reached 
EXPOSE 3000


## Build Stage 2
FROM node:lts-alpine3.16 AS server-build

# Specify the directory inside the image in which all commands will run
WORKDIR /usr/src/app

# copy folder from previous build
COPY --from=ui-build /usr/src/app/client/ ./client/

# Copy package files and install dependencies
COPY package*.json ./
RUN npm install

# Copy all of the app files into the image
COPY . .

EXPOSE 5001

CMD ["npm", "run", "dev"]