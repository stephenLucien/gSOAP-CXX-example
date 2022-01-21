#!/bin/bash
TOP_DIR=$(dirname $(realpath ${BASH_SOURCE}))
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
    make -j`nproc`
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
make all