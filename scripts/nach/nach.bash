#!/bin/bash


#####
# directories
#####
scripts="./scripts/nach"
css="$scripts/nach.css"
intermediate="./intermediate/nach"
source="./Orayta-Books/BooksSrc"
rashisource="/005_mprsi_mkra/03_rsi/1_torh"
mikrasource="/001_mkra/01_torh"
output="./output/nach"


convertsefer() {

	input=$1
	folderout=$2
	fileout=$3
	title=$(echo $fileout | sed -e 's/_/ /g' )
	ext=$4
	args=("$input" "$folderout$fileout.$ext" --subset-embedded-fonts --extra-css "$css" --chapter '//*[@class="perekh"]' --chapter-mark "pagebreak" --start-reading-at '//*[@class="perekh"]' --language "he" --base-font-size "16" --title "$title" --authors 'נ"ך' --level1-toc '//*[@class="perekh"]' --toc-title "תוכן ענינים")
	if [[ $ext == "epub" ]]; then args+=(--no-default-epub-cover); fi;
	if [[ $5 == "embed" ]]; then args+=(--embed-font-family "SBL Hebrew"); fi;
	ebook-convert "${args[@]}"
}


if [[ ! -d "$intermediate" ]]; then mkdir -p "$intermediate"; fi;

for i in $source/001_mkra/02_nbiaim/*.txt $source/001_mkra/03_ctobim/*.txt; do
	$scripts/nach.awk -v "basefolder=$intermediate" $i;
done


#if [[ ! -d "$output/kindle_font" ]]; then mkdir -p "$output/kindle_font"; fi;
if [[ ! -d "$output/kindle" ]]; then mkdir -p "$output/kindle"; fi;

if [[ ! -d "$output/epub" ]]; then mkdir -p "$output/epub"; fi;
#if [[ ! -d "$output/epub_font" ]]; then mkdir -p "$output/epub_font"; fi;

for i in $intermediate/*.html; do
	name=$(basename --suffix=.html $i)
	convertsefer "$i" "$output/kindle/" "$name" "azw3" &
	#convertsefer "$i" "$output/kindle_font/" "$name" "azw3" "embed"  &
	convertsefer "$i" "$output/epub/" "$name" "epub" &
	#convertsefer "$i" "$output/epub_font/" "$name" "epub" "embed" &
	wait
done
