#!/bin/bash


#####
# directories
#####
startpoint="Steinsaltz_talmud_H_E"
scripts="./scripts/$startpoint"
css="$scripts/$startpoint.css"
intermediate="./intermediate/$startpoint"
source="./sefaria"
output="./output/$startpoint"
gematriya="$source/gematriya.js"

convertsefer() {

	input=$1
	folderout=$2
	fileout=$3
	ext=$4
	args=("$input" "$folderout$fileout.$ext" --subset-embedded-fonts --extra-css "$css" --chapter '//*[name()="h2" or name()="h3"]' --chapter-mark "none" --language "he" --base-font-size "14" --authors 'תלמוד' --toc-title "תוכן ענינים" --comments 'The William Davidson digital edition of the Koren Noé Talmud, with commentary by Rabbi Adin Steinsaltz Even-Israel via sefaria under the CC BY-NC 4.0' --sr1-replace '<br>' --page-breaks-before '/')
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
		wget -O "$intermediate/$dest.json" "https://www.sefaria.org/api/texts/$i?pad=0";
	fi;
	counter=$(($counter+1));
done << EOF
$(nodejs $scripts/index.js "$source/index.json")
EOF

for i in $intermediate/*.json; do
	dest="$(basename --suffix .json $i)"
	nodejs "$scripts/$startpoint.js" "$i" "../../$source/gematriya.js" > "$intermediate/$dest.html"
done

if [[ ! -d "$output/kindle" ]]; then mkdir -p "$output/kindle"; fi;
if [[ ! -d "$output/epub" ]]; then mkdir -p "$output/epub"; fi;

for i in $intermediate/*.html; do
	name=$(basename --suffix=.html $i)
	convertsefer "$i" "$output/kindle/" "$name" "azw3" &
	convertsefer "$i" "$output/epub/" "$name" "epub" &
	wait
done
