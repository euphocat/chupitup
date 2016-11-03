#!/usr/bin/env bash

# this file path
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# move up to project root
cd $DIR/..

PATH="$PATH:./node_modules/.bin"

rm build/* -Rf

cp assets/* build/ -R & cp src/index.html build/

elm-make src/Blog.elm --output=build/Blog.js --warn

lessc less/main.less > build/styles.css