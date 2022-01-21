#!/bin/bash
TOP_DIR=$(dirname $(realpath ${BASH_SOURCE}))
BEAR=$(which bear)
if test -n "$BEAR";then
BEAR_APPEND="$BEAR --append"
fi
cd $TOP_DIR

export CC=gcc
export CXX=g++
GSOAP_SRC_DIR=$TOP_DIR/gsoap-2.8
SOAPCPP2=$TOP_DIR/gsoap-2.8/gsoap/soapcpp2

if test ! -e "$GSOAP_SRC_DIR";then 
    unzip gsoap_2.8.117.zip
fi

if test ! -e "$SOAPCPP2";then
    cd $GSOAP_SRC_DIR
    ./configure
    cd -
    $BEAR_APPEND make -j`nproc` -C $GSOAP_SRC_DIR
    CODE=$?
    test 0 -ne $CODE && exit $CODE
fi

export GSOAP_SRC_DIR SOAPCPP2
export C_API_HEADER=hello.h
export SERVER_BIN=hello.cgi
export CLIENT_BIN=client
export GEN_DIR=gen
export BUILD_DIR=build

make clean
make gen_from_api_header
# generate compile_commands.json if `bear` exists,
# thus VSCode with clangd plugin will do a great job.
$BEAR_APPEND make -j`nproc` all 