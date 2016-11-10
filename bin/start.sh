#!/usr/bin/env bash

# this file path
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# move up to project root
cd $DIR/..

./bin/build.sh

live-server build/ --entry-file=index.html & nodemon ./server/index.js
