#!/usr/bin/env bash

source ./vars.sh
source ./colors.sh

cd ${PROJECT_DIR}

# hack to always get warnings
# rm elm-stuff/build-artifacts -Rf

ELM_MAKE_RESULT=$(elm-make src/Blog.elm --warn --output=build/Blog.js --yes)

if [[ $ELM_MAKE_RESULT != Success* ]] ;
then
    exit 1
else
    success "$ELM_MAKE_RESULT"
fi


echo $ELM_MAKE_RESULT 1>&2

success "Elm compilation"

uglifyjs build/Blog.js \
        -o build/Blog.min.js \
        --screw-ie8 \
        --source-map Blog.min.js.map \
        --source-map-url Blog.min.js.map \
        --source-map-root ""

success "Uglifying"
