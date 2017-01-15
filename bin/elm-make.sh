#!/usr/bin/env bash

cd bin > /dev/null 2>&1

source ./vars.sh
source ./colors.sh

cd ${PROJECT_DIR}

# hack to always get warnings
# rm elm-stuff/build-artifacts -Rf

ELM_MAKE_RESULT=$(elm-make src/Main.elm --warn --output=build/Main.js --yes)

if [[ $ELM_MAKE_RESULT != Success* ]] ;
then
    exit 1
else
    success "$ELM_MAKE_RESULT"
fi


echo $ELM_MAKE_RESULT 1>&2

success "Elm compilation"

uglifyjs build/Main.js \
        -o build/Main.min.js \
        --screw-ie8

success "Uglifying"
