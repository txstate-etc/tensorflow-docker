# tensorflow-docker
A dockerfile for building tensorflow from source. Targets node (tfjs-node) running in debian.

# Usage
This is meant to be used as a build-stage image for node servers that require @tensorflow/tfjs-node. It provides a .tar.gz of the tensorflow binary, compiled with minimal processor instruction set requirements (-march=core2), inside debian (currently uses image `node:12-buster-slim`).

A node service that depends on this would have a Dockerfile something like this:
```Dockerfile
FROM tensorflow-docker:v1 AS tf
FROM node:12-buster-slim
# package.json should have a dependency on @tensorflow/tfjs-node
COPY package.json ./

RUN npm install && rm -rf /usr/src/app/node_modules/\@tensorflow/tfjs-node/deps/*

WORKDIR /usr/src/app/node_modules/@tensorflow/tfjs-node/deps
COPY --from=tf /root/libtensorflow.tar.gz ./
RUN tar -xf libtensorflow.tar.gz && rm libtensorflow.tar.gz

WORKDIR /usr/src/app
COPY src src
# etc
```
