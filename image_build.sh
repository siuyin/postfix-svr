#!/bin/sh
# image_build.sh
PGM='postfix'
MAIN_VER=20150630c
#MAIN_VER=`date +%Y%m%d`
SUB_VER=-no-av
VER=${MAIN_VER}${SUB_VER}

docker build -t siuyin/${PGM}:${VER} .
