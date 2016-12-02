#!/usr/bin/env bash

killall node > /dev/null 2>&1

# this file path
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# move up to project root
cd $DIR/..

./bin/build.sh

docker start my-mongo-dev

live-server build/ --entry-file=index.html & nodemon ./server/index.js
