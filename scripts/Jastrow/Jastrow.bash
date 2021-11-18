#!/bin/bash


#####
# directories
#####
startpoint="Jastrow"
scripts="./scripts/$startpoint"
intermediate="./intermediate/$startpoint"
output="./output/$startpoint"

if [[ ! -d "$intermediate" ]]; then mkdir -p "$intermediate"; fi;

#counter=1
#while read i; do
#	dest="$(printf '%02d' $counter)_$i"
#	dest="${dest// /_}"
#	if [[ ! -f "$intermediate/$dest.json" ]]; then
#		wget -O "$intermediate/$dest.json" "https://www.sefaria.org/api/texts/$i?pad=0";
#	fi;
#	counter=$(($counter+1));
#done << EOF
#EOF

uri="Jastrow,_א"

if [[ ! -f "$intermediate/$startpoint" ]]; then
	while [[ -n "$uri" ]]; do 
		wget -qO "$intermediate/$startpoint.json" "https://www.sefaria.org/api/texts/$uri?multiple=1000";
		uri=$(node "$scripts/$startpoint.js" "$intermediate/$startpoint" "$intermediate/$startpoint.json")
		echo $uri
		if [[ -f "$intermediate/$startpoint.json" ]]; then 
			rm "$intermediate/$startpoint.json"; 
		fi
	done
fi

if [[ ! -d "$output" ]]; then mkdir -p "$output"; fi;

pyglossary "$intermediate/$startpoint" "$output/$startpoint.ifo" --write-options=sametypesequence=h --read-format=Tabfile

