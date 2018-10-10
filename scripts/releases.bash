#!/bin/bash

output="./output/"
if [[ ! -d "./releases" ]]
	then mkdir -p ./releases
fi
cd $output
for d in */; do
	cd $d
	zip -Tr "../../releases/$(basename $d)" .
	cd ..
done
