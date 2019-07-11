#!/bin/bash

set -e

#####
# directories
#####
startpoint="Arukh_HaShulchan"
scripts="./scripts/$startpoint"
css="$scripts/$startpoint.css"
intermediate="./intermediate/$startpoint"
source="./sefaria"
output="./output/$startpoint"
gematriya="$source/gematriya.js"
chelek=("Orach_Chaim" "Yoreh_De'ah" "Even_HaEzer" "Choshen_Mishpat")

convertsefer() {

	input=$1
	folderout=$2
	fileout=$3
	ext=$4
	args=("$input" "$folderout$fileout.$ext" --subset-embedded-fonts --extra-css "$css" --chapter '//*[name()="h2" or name()="h3"]' --chapter-mark "none" --language "he" --base-font-size "16" --authors 'יחיאל מיכל הלוי אפשטיין' --toc-title "תוכן ענינים" --comments 'The Arukh HaShulchan, via sefaria under the CC-BY-SA' --page-breaks-before '/')
	if [[ $ext == "epub" ]]; then args+=(--no-default-epub-cover); fi;
	if [[ $5 == "embed" ]]; then args+=(--embed-font-family "SBL Hebrew"); fi;
	ebook-convert "${args[@]}"
}


if [[ ! -d "$intermediate" ]]; then mkdir -p "$intermediate"; fi;
for i in ${chelek[@]}; do
	apiname="$startpoint,_$i"
	if [[ ! -f "$intermediate/$apiname.json" ]]; then
		wget -O "$intermediate/$apiname.json" "https://www.sefaria.org/api/texts/$apiname?pad=0";
	fi;
done

for i in $intermediate/*.json; do
	dest="$(basename --suffix .json $i)"
	node "$scripts/$startpoint.js" "$i" "../../$source/gematriya.js" > "$intermediate/$dest.html"
	sed -i -e 's#<i [^<>]*></i>##g' -e 's#<br>##g' "$intermediate/$dest.html"
done

if [[ ! -d "$output/kindle" ]]; then mkdir -p "$output/kindle"; fi;
if [[ ! -d "$output/epub" ]]; then mkdir -p "$output/epub"; fi;

for i in $intermediate/*.html; do
	name=$(basename --suffix=.html $i)
	convertsefer "$i" "$output/kindle/" "$name" "azw3" &
	convertsefer "$i" "$output/epub/" "$name" "epub" &
	wait
done
