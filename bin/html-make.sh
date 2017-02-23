#!/usr/bin/env bash

cd bin > /dev/null 2>&1

source ./vars.sh
source ./colors.sh

cd ${PROJECT_DIR}

cp ${PROJECT_DIR}/src/*.html ${BUILD_DIR}