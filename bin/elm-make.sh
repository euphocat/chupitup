#!/usr/bin/env bash

source ./vars.sh
source ./colors.sh



cd ${PROJECT_DIR}

# hack to always get warnings
# rm elm-stuff/build-artifacts -Rf

elm-make src/Blog.elm --warn --output=build/Blog.js --yes

success "Elm compilation"

uglifyjs build/Blog.js \
        -o build/Blog.min.js \
        --screw-ie8 \
        --source-map build/Blog.min.js.map


success "Uglifying"
