#!/bin/bash

set -e

#####
# directories
#####
startpoint="Shulchan_Aruch_Harav"
scripts="./scripts/$startpoint"
css="$scripts/$startpoint.css"
intermediate="./intermediate/$startpoint"
source="./Orayta-Books/BooksSrc/080_poskim_ahronim/030_solhn_uroc_hrb"
output="./output/$startpoint"


convertsefer() {

	input=$1
	folderout=$2
	fileout=$3
	title=$(echo $fileout | sed -e 's/_/ /g' )
	ext=$4
	args=("$input" "$folderout$fileout.$ext" --subset-embedded-fonts --extra-css "$css" --chapter '//*[@class="Siman"]' --chapter-mark "pagebreak" --start-reading-at '//*[@class="seferh"]' --language "he" --base-font-size "16" --title "$title" --authors 'הרבי הזקן' --level1-toc '//*[@class="halachos"]' --level2-toc '//*[@class="Siman"]' --toc-title "תוכן ענינים")
	if [[ $ext == "epub" ]]; then args+=(--no-default-epub-cover); fi;
	if [[ $5 == "embed" ]]; then args+=(--embed-font-family "SBL Hebrew"); fi;
	ebook-convert "${args[@]}"
}


if [[ ! -d "$intermediate" ]]; then mkdir -p "$intermediate"; fi;
if [[ ! -d "$intermediate/temp" ]]; then mkdir -p "$intermediate/temp"; fi;

for i in $source/*.txt; do
	dest=$(basename $i)
	sed -E -e 's/&lt//g' -e 's/&gt//g' -e 's/<.?sup>//g' -e 's/&nbsp/ /g' -e 's/<.?div[^>]*>//g' -e '/a target/d' -e '/a href/d' $i > $intermediate/temp/$dest;
done

for i in $intermediate/temp/*.txt; do
	"$scripts/$startpoint.awk" "$i" > "$intermediate/$(basename $i)"
done

for i in $intermediate/*.txt; do
	"$scripts/name_$startpoint.awk" -v "basefolder=$intermediate" $i
done

#if [[ ! -d "$output/kindle_font" ]]; then mkdir -p "$output/kindle_font"; fi;
if [[ ! -d "$output/kindle" ]]; then mkdir -p "$output/kindle"; fi;

if [[ ! -d "$output/epub" ]]; then mkdir -p "$output/epub"; fi;
#if [[ ! -d "$output/epub_font" ]]; then mkdir -p "$output/epub_font"; fi;

for i in $intermediate/*.html; do
	name=$(basename --suffix=.html $i)
	convertsefer "$i" "$output/kindle/" "$name" "azw3" &
#	convertsefer "$i" "$output/kindle_font/" "$name" "azw3" "embed"  &
	convertsefer "$i" "$output/epub/" "$name" "epub" &
#	convertsefer "$i" "$output/epub_font/" "$name" "epub" "embed" &
	wait
done
