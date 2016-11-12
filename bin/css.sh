#!/usr/bin/env bash

source ./vars.sh

cd ${PROJECT_DIR}

mkdir ${CSS_BUILD_PATH}

for library in "${CSS_LIBRARIES[@]}"
do
	cp ./node_modules/${library} ${CSS_BUILD_PATH}
done

if [[ $1 = "--no-watch" ]]; then
    autoless --no-watch less ${CSS_BUILD_PATH}
else
    autoless less ${CSS_BUILD_PATH} &
fi