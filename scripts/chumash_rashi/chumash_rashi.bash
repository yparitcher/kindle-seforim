#!/bin/bash


#####
# directories
#####
scripts="./scripts/chumash_rashi"
css="$scripts/chumash_rashi.css"
intermediate="./intermediate/chumash_rashi"
source="./Orayta-Books/BooksSrc"
rashisource="/005_mprsi_mkra/03_rsi/1_torh"
mikrasource="/001_mkra/01_torh"
output="./output/chumash_rashi"


convertsefer() {

	input=$1
	folderout=$2
	fileout=$3
	title=$(echo $fileout | sed -e 's/_/ /g' )
	ext=$4
	args=("$input" "$folderout$fileout.$ext" --subset-embedded-fonts --extra-css "$css" --chapter '//*[@class="parshah" or @class="aliyah"]' --chapter-mark "pagebreak" --start-reading-at '//*[@class="parshah"]' --language "he" --base-font-size "16" --title "$title" --authors 'חומש רשי' --level1-toc '//*[@class="parshah" or @class="aliyah"]' --toc-title "תוכן ענינים")
	if [[ $ext == "epub" ]]; then args+=(--no-default-epub-cover); fi;
	if [[ $5 == "embed" ]]; then args+=(--embed-font-family "SBL Hebrew"); fi;
	ebook-convert "${args[@]}"
}


if [[ ! -d "$intermediate/mikra" ]]; then mkdir -p "$intermediate/mikra"; fi;

for i in $source$mikrasource/*.txt; do
	dest=$(basename $i)
	sed -e 's#<BR><span class="Aliyah">\([^<>]\{1,7\}\)</span>#@ \1#g' $i > $intermediate/mikra/$dest;
done

if [[ ! -d "$intermediate/rashi" ]]; then mkdir -p "$intermediate/rashi"; fi;

for i in $source$rashisource/*.txt; do
	dest=$(basename $i)
	sed -e 's#{{[^{}]\{1,2\}}} ##g' -e 's#<b>#<span class="rashih">#g' -e 's#</b># - </span>#g' $i > $intermediate/rashi/$dest;
done

for i in $intermediate/rashi/*.txt; do
	rashiname=$(basename $i)
	prefix=${rashiname:0:2}
	mikraname=$intermediate/mikra/a$prefix*.txt
	$scripts/chumash_rashi.awk $i $intermediate/mikra/$(basename $mikraname) > $intermediate/$(basename $mikraname)
done

for i in $intermediate/*.txt; do
	$scripts/chumash_rashi_parsha.awk -v "basefolder=$intermediate" $i
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
