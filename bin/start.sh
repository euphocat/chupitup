#!/usr/bin/env bash

killall node > /dev/null 2>&1

# this file path
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# move up to project root
./bin/build.sh

live-server build/ --entry-file=index.html
