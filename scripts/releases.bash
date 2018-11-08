#!/bin/bash

rm -r ./releases/*
cp -ar ./output/* ./releases/

cd ./releases
for d in */*/; do
	cd $d
	zip -jmT "$(dirname $d)" * &
	cd -
done
wait
