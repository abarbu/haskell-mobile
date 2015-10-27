#!/bin/bash

set -euf -o pipefail

export DIR=$(pwd)

cd $DIR/hello
docker run -it --privileged --net=host -v $PWD:/src abarbu/nativescript tns platform add android
cd $DIR/hello/app
docker run -it -v $PWD:/src abarbu/stack-ghcjs-nativescript:lts-3.0 ghcjs App.hs
