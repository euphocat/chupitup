#!/usr/bin/env bash

CSS_BUILD_PATH="build/css/"
CSS_LIBRARIES=(
"font-awesome/css/font-awesome.min.css"
"font-awesome/css/font-awesome.css.map"
"purecss/build/pure-min.css"
"purecss/build/grids-responsive-min.css"
)

BIN_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
PROJECT_DIR=${BIN_DIR}/..
BUILD_DIR=${PROJECT_DIR}/build