#!/bin/bash
#
# buildx 

set -x

cd $(dirname $0)

ROOTDIR=$(pwd)

version=v$(cat .version) || exit 1

git submodule update --init --recursive
cd ${ROOTDIR}/beats/ && git checkout ${version}

function gobuild(){
	CGO_ENABLED=0 go build -o ${ROOTDIR}/out/${beat}-${version}-${GOOS}-${GOARCH} .
}

#for beat in $(ls |grep beat)
for beat in filebeat
do
{
	echo $beat
	cd ${ROOTDIR}/beats/$beat

	GOOS=linux GOARCH=amd64 gobuild
	GOOS=linux GOARCH=arm64 gobuild

}
done


