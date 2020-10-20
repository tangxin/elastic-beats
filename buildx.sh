#!/bin/bash
#
# buildx 

set -x

cd $(dirname $0)

ROOTDIR=$(pwd)

version=$(cat .version) || exit 1

git submodule update --init --recursive

cd ${ROOTDIR}/beats/ && git checkout ${version}
for beat in $(ls |grep beat)
do
{
	echo $beat
	cd ${ROOTDIR}/beats/$beat
	export GOOS=linux
	export GOARCH=arm64
	CGO_ENABLED=0 go build -o ${ROOTDIR}/out/${beat}-${version}-${GOOS}-${GOARCH} .
	export GOARCH=amd64
	CGO_ENABLED=0 go build -o ${ROOTDIR}/out/${beat}-${version}-${GOOS}-${GOARCH} .
	# GOOS=linux GOARCH=arm64 go build -o ${ROOTDIR}/out/${beat}-${version}-${GOOS}-${GOARCH} .
	# GOOS=linux GOARCH=amd64 go build -o ${ROOTDIR}/out/${beat}-${version}-${GOOS}-${GOARCH} .
}
done

