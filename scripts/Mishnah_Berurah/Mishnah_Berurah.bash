#!/bin/bash

set -e

#####
# directories
#####
startpoint="Mishnah_Berurah"
scripts="./scripts/$startpoint"
css="$scripts/$startpoint.css"
intermediate="./intermediate/$startpoint"
source="./sefaria"
output="./output/$startpoint"
gematriya="$source/gematriya.js"
shulchanaruch="Shulchan_Arukh,_Orach_Chayim"

convertsefer() {

	input=$1
	folderout=$2
	fileout=$3
	ext=$4
	args=("$input" "$folderout$fileout.$ext" --subset-embedded-fonts --extra-css "$css" --chapter '//*[name()="h2" or name()="h3"]' --chapter-mark "none" --language "he" --authors 'חפץ חיים' --toc-title "תוכן ענינים" --comments 'The Mishnah Berurah, via sefaria under the CC-BY-SA' --page-breaks-before '/')
	if [[ $ext == "epub" ]]; then args+=(--no-default-epub-cover); fi;
	if [[ $5 == "embed" ]]; then args+=(--embed-font-family "SBL Hebrew"); fi;
	ebook-convert "${args[@]}"
}


if [[ ! -d "$intermediate" ]]; then mkdir -p "$intermediate"; fi;

for i in {1..697}; do
	if [[ ! -f "$intermediate/$i.json" ]]; then
		wget -O "$intermediate/$i.json" "https://www.sefaria.org/api/texts/$shulchanaruch.$i?commentary=1";
	fi;
done

echo "<title>משנה ברורה</title>" > "$intermediate/$startpoint.html"

for i in {1..697}; do
	node "$scripts/$startpoint.js" "$intermediate/$i.json" "../../$source/gematriya.js" >> "$intermediate/$startpoint.html"
done

sed -i -e 's#<i [^<>]*></i>##g' -e 's#<br>##g' -e 's#<small#<span class="hagah"#g' -e 's#</small#</span#g' -e 's#"pirush">(\([^)]*\)) \([^–]*\) – #"pirush"><span class="pirushh">\1) </span><span class="ph">\2 </span>#' "$intermediate/$startpoint.html"

if [[ ! -d "$output/kindle" ]]; then mkdir -p "$output/kindle"; fi;
if [[ ! -d "$output/epub" ]]; then mkdir -p "$output/epub"; fi;

for i in $intermediate/*.html; do
	name=$(basename --suffix=.html $i)
	convertsefer "$i" "$output/kindle/" "$name" "azw3" &
	convertsefer "$i" "$output/epub/" "$name" "epub" &
	wait
done
