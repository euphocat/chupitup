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

cp ${PROJECT_DIR}/assets/* ${BUILD_DIR} -R & cp ${PROJECT_DIR}/src/index.html ${BUILD_DIR}

# Elm make
./elm-make.sh

# CSS
./css.sh $@

cp ${PROJECT_DIR}/node_modules/Notify/dist/vanilla-notify.css ${PROJECT_DIR}/${CSS_BUILD_PATH}
mkdir ${BUILD_DIR}/js
cp ${PROJECT_DIR}/node_modules/Notify/dist/vanilla-notify.js ${BUILD_DIR}/js/

end=`date +%s%N`
runtime=$(($((end-start))/1000000))
BUILD_DONE="Build is done in $runtime ms"

success "$BUILD_DONE"
notify -t "Elm blog Chupitup" -m "${BUILD_DONE}"
