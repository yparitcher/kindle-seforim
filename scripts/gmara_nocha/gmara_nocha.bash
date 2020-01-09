#!/bin/bash

set -e

#####
# directories
#####
scripts="./scripts/gmara_nocha"
css="$scripts/gmara_nocha.css"
intermediate="./intermediate/gmara_nocha"
source="./Orayta-Books/BooksSrc/032_gmara_nocha"
output="./output/gmara_nocha"


convertsefer() {

	input=$1
	folderout=$2
	fileout=$3
	title=$(echo $fileout | sed -e 's/_/ /g' )
	ext=$4
	args=("$input" "$folderout$fileout.$ext" --subset-embedded-fonts --extra-css "$css" --chapter '//*[@class="perekh"]' --chapter-mark "pagebreak" --start-reading-at '//*[@class="seferh"]' --language "he" --base-font-size "16" --title "$title" --authors 'תלמוד' --level1-toc '//*[@class="perekh"]' --level2-toc '//*[@class="dafh"]' --toc-title "תוכן ענינים")
	if [[ $ext == "epub" ]]; then args+=(--no-default-epub-cover); fi;
	if [[ $5 == "embed" ]]; then args+=(--embed-font-family "SBL Hebrew"); fi;
	ebook-convert "${args[@]}"
}


if [[ ! -d "$intermediate/temp" ]]; then mkdir -p "$intermediate/temp"; fi;

for i in $source/*.txt; do
	dest=$(basename $i)
	sed -E 's/^#/\^/' $i > $intermediate/temp/$dest;
done

for i in $intermediate/temp/*.txt; do
	$scripts/gmara_nocha.awk "$i" > "$intermediate/$(basename --suffix _L1.txt $i)"
done

for i in $intermediate/*.txt; do
	$scripts/gmara_nocha_name.awk -v "basefolder=$intermediate" $i
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
