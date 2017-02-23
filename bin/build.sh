#!/usr/bin/env bash

start=`date +%s%N`

cd bin

# include variables
source ./vars.sh
source ./colors.sh

# add the node_modules bin to the current PATH
PATH="$PATH:$PROJECT_DIR/node_modules/.bin"

# clean the build dir
rm ${BUILD_DIR} -Rf && mkdir ${BUILD_DIR}

cp ${PROJECT_DIR}/assets/* ${BUILD_DIR} -R

# Html make
./html-make.sh

# Elm make
./elm-make.sh

# CSS
./css.sh $@

success "Moving bower components to build folder"
cp ${PROJECT_DIR}/bower_components/ ${BUILD_DIR} -R

end=`date +%s%N`
runtime=$(($((end-start))/1000000))
BUILD_DONE="Build is done in $runtime ms"

success "$BUILD_DONE"
notify -t "Elm blog Chupitup" -m "${BUILD_DONE}"
