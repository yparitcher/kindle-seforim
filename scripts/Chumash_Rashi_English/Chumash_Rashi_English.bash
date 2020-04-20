#!/bin/bash


#####
# directories
#####
startpoint="Chumash_Rashi_English"
scripts="./scripts/$startpoint"
css="$scripts/$startpoint.css"
intermediate="./intermediate/$startpoint"
source="./sefaria"
output="./output/$startpoint"
gematriya="$source/gematriya.js"
commentary="rashi"

convertsefer() {

	input=$1
	folderout=$2
	fileout=$3
	ext=$4
	args=("$input" "$folderout$fileout.$ext" --subset-embedded-fonts --extra-css "$css" --chapter '//*[name()="h2" or name()="h3"]' --chapter-mark "none" --language "he" --base-font-size "14" --authors 'חומש רשי' --toc-title "תוכן ענינים" --comments 'Rashi Chumash, Metsudah Publications, 2009 via sefaria under the CC BY 3.0' --sr1-replace '<br>' --page-breaks-before '/')
	if [[ $ext == "epub" ]]; then args+=(--no-default-epub-cover); fi;
	if [[ $5 == "embed" ]]; then args+=(--embed-font-family "SBL Hebrew"); fi;
	ebook-convert "${args[@]}"
}


if [[ ! -d "$intermediate" ]]; then mkdir -p "$intermediate"; fi;

counter=1
while read i; do
	dest="$(printf '%02d' $counter)_$i"
	dest="${dest// /_}"
	if [[ ! -f "$intermediate/$dest.json" ]]; then
		wget -O "$intermediate/$dest.json" "https://www.sefaria.org/api/texts/$i?pad=0&ven=Metsudah_Chumash,_Metsudah_Publications,_2009&vhe=Tanach_with_Ta'amei_Hamikra";
	fi;
	counter=$(($counter+1));
done << EOF
$(node $scripts/chumash.js "$source/index.json")
EOF

if [[ ! -d "$intermediate/$commentary" ]]; then mkdir -p "$intermediate/$commentary"; fi;

counter=1
while read i; do
	dest="$(printf '%02d' $counter)_$i"
	dest="${dest//Rashi on /}"
	dest="${dest// /_}"
	if [[ ! -f "$intermediate/$commentary/$dest.json" ]]; then
		wget -O "$intermediate/$commentary/$dest.json" "https://www.sefaria.org/api/texts/$i?pad=0&ven=Rashi_Chumash,_Metsudah_Publications,_2009&vhe=Rashi_Chumash,_Metsudah_Publications,_2009";
	fi;
	counter=$(($counter+1));
done << EOF
$(node $scripts/rashi.js "$source/index.json")
EOF

echo "0" > "$intermediate/count"

for i in $intermediate/*.json; do
	alt="$intermediate/$commentary/$(basename $i)"
	if [ -f "$alt" ]; then
		dest="$(basename --suffix .json $i)"
		node "$scripts/$startpoint.js" "$i" "$alt" "../../$source/gematriya.js" "$intermediate/" "$intermediate/count"
	fi
done

if [[ ! -d "$output/kindle" ]]; then mkdir -p "$output/kindle"; fi;
if [[ ! -d "$output/epub" ]]; then mkdir -p "$output/epub"; fi;

for i in $intermediate/*.html; do
	name=$(basename --suffix=.html $i)
	convertsefer "$i" "$output/kindle/" "$name" "azw3" &
	convertsefer "$i" "$output/epub/" "$name" "epub" &
	wait
done
