#!/usr/bin/env bash

source ./vars.sh

cd ${PROJECT_DIR}

# hack to always get warnings
#rm elm-stuff/build-artifacts -Rf

elm-make src/Blog.elm --warn --output=build/Blog.js --yes
