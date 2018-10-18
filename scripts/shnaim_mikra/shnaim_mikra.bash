#!/bin/bash


#####
# directories
#####
scripts="./scripts/shnaim_mikra"
css="$scripts/shnaim_mikra.css"
intermediate="./intermediate/shnaim_mikra"
source="./Orayta-Books/BooksSrc"
targumsource="/005_mprsi_mkra/01_trgom"
mikrasource="/001_mkra/01_torh"
output="./output/shnaim_mikra"


convertsefer() {

	input=$1
	folderout=$2
	fileout=$3
	title=$(echo $fileout | sed -e 's/_/ /g' )
	ext=$4
	args=("$input" "$folderout$fileout.$ext" --subset-embedded-fonts --extra-css "$css" --chapter '//*[@class="parshah" or @class="aliyah"]' --chapter-mark "pagebreak" --start-reading-at '//*[@class="parshah"]' --language "he" --base-font-size "16" --title "$title" --authors 'שניים מקרא' --level1-toc '//*[@class="parshah" or @class="aliyah"]' --toc-title "תוכן ענינים")
	if [[ $ext == "epub" ]]; then args+=(--no-default-epub-cover); fi;
	if [[ $5 == "embed" ]]; then args+=(--embed-font-family "SBL Hebrew"); fi;
	ebook-convert "${args[@]}"
}


if [[ ! -d "$intermediate/mikra" ]]
	then mkdir -p "$intermediate/mikra"
fi

for i in $source$mikrasource/*.txt; do
	dest=$(basename $i)
	sed -e 's#<BR><span class="Aliyah">\([^<>]\{1,7\}\)</span>#@ \1#g' $i > $intermediate/mikra/$dest;
done

for i in $source$targumsource/*.txt; do
	targumname=$(basename $i)
	prefix=${targumname:0:2}
	mikraname=$intermediate/mikra/a$prefix*.txt
	$scripts/shnaim_mikra.awk $i $intermediate/mikra/$(basename $mikraname) > $intermediate/$(basename $mikraname)
done

for i in $intermediate/*.txt; do
	$scripts/shnaim_mikra_parsha.awk -v "basefolder=$intermediate" $i
done


if [[ ! -d "$output/kindle_font" ]]; then mkdir -p "$output/kindle_font"; fi;
if [[ ! -d "$output/kindle" ]]; then mkdir -p "$output/kindle"; fi;

if [[ ! -d "$output/epub" ]]; then mkdir -p "$output/epub"; fi;
if [[ ! -d "$output/epub_font" ]]; then mkdir -p "$output/epub_font"; fi;

for i in $intermediate/*.html; do
	name=$(basename --suffix=.html $i)
	convertsefer "$i" "$output/kindle/" "$name" "azw3" &
	convertsefer "$i" "$output/kindle_font/" "$name" "azw3" "embed"  &
	convertsefer "$i" "$output/epub/" "$name" "epub" &
	convertsefer "$i" "$output/epub_font/" "$name" "epub" "embed" &
	wait
done
