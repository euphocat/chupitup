#!/usr/bin/env bash

source ./vars.sh

docker stop my-mongo-dev
docker rm my-mongo-dev
docker run -p 27017:27017 -v ${PROJECT_DIR}/db:/data/db --name my-mongo-dev -d mongo mongod
