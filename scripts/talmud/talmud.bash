#!/bin/bash


#####
# directories
#####
scripts="./scripts/talmud"
css="$scripts/talmud.css"
intermediate="./intermediate/talmud"
source="./Orayta-Books/BooksSrc"
rashisource="/040_rasonim_ss/01_rsi"
mikrasource="/030_tlmod_bbli"
output="./output/talmud"


convertsefer() {

	input=$1
	folderout=$2
	fileout=$3
	title=$(echo $fileout | sed -e 's/_/ /g' )
	ext=$4
	args=("$input" "$folderout$fileout.$ext" --subset-embedded-fonts --extra-css "$css" --chapter '//*[@class="perekh"]' --chapter-mark "pagebreak" --start-reading-at '//*[@class="seferh"]' --language "he" --base-font-size "16" --title "$title" --authors 'חומש רשי' --level1-toc '//*[@class="perekh"]' --level2-toc '//*[@class="dafh"]' --toc-title "תוכן ענינים")
	if [[ $ext == "epub" ]]; then args+=(--no-default-epub-cover); fi;
	if [[ $5 == "embed" ]]; then args+=(--embed-font-family "SBL Hebrew"); fi;
	ebook-convert "${args[@]}"
}


if [[ ! -d "$intermediate/talmud" ]]; then mkdir -p "$intermediate/mikra"; fi;

for i in $source$mikrasource/*.txt; do
	dest=$(basename $i)
	sed -E 's#<!--[[:alpha:]]+-->##g' $i > $intermediate/mikra/$dest;
done

if [[ ! -d "$intermediate/rashi" ]]; then mkdir -p "$intermediate/rashi"; fi;

for i in $source$rashisource/*.txt; do
	dest=$(basename $i)
	sed -e 's#<[bB]>#<span class="rashih">#g' -e 's#</[bB]>.#. - </span>#g' $i > $intermediate/rashi/$dest;
done

for i in $intermediate/rashi/*.txt; do
	rashiname="$(basename --suffix 2.txt $i)"
	mikraname=$intermediate/mikra/"$rashiname"1.txt
	$scripts/talmud.awk "$i" "$mikraname" > "$intermediate/$(basename --suffix _L1.txt $mikraname).txt"
done

for i in $intermediate/*.txt; do
	$scripts/talmud_name.awk -v "basefolder=$intermediate" $i
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
