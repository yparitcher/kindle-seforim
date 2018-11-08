#!/bin/bash

#####
# directories
#####
intermediate="./intermediate/rambam"
scripts="./scripts/rambam"
source="./Orayta-Books/BooksSrc/050_rmbm"
baseout="./output/rambam/kindle"
fontbaseout="./output/rambam/kindle_font"
epubbaseout="./output/rambam/epub"
epubfontbaseout="./output/rambam/epub_font"

parser() {
	sed -e 's#{{[^{}]\+}}##g' -e 's#{##g' -e 's#}##g' -e 's#<TRIM>##g' -e 's#  # #g' -e 's#  # #g' -e 's#<BR><HR><BR>#\n#g' $1 | $scripts/rambam.awk > $intermediate/$(basename $1);
}

convertsefer() {

	input="$1"
	output="$2"
	ext="$3"
	folderout=$4
	title="$5"
	args=("$input" "$folderout/$output.$ext" --subset-embedded-fonts --extra-css "$scripts/rambam.css" --chapter '//*[@class="sefert" or @class="halachost" or @class="perekt"]' --chapter-mark "pagebreak" --start-reading-at '//*[@class="sefer"]' --language "he" --base-font-size "16" --title "$title" --authors 'רמב"ם' --level1-toc '//*[@class="sefert" or @class="halachost" or @class="perekt"]' --toc-title "תוכן ענינים")
	if [[ $ext == "epub" ]]; then args+=(--no-default-epub-cover); fi;
	if [[ $6 == "embed" ]]; then args+=(--embed-font-family "SBL Hebrew"); fi;
	ebook-convert "${args[@]}"	
}


#####
# parse input
#####
if [[ ! -d "$intermediate" ]]; then mkdir -p "$intermediate"; fi;

for i in $source/*.txt; do parser $i; done;


#####
# divide perakim
#####
sed -i -e 's#<! end perek>##' "$intermediate/0028_RAMBAM-OVERVIEW_L0.txt"
sed -i -e 's#\(אלהי ישראל:\)  #</p>\1\n<! end perek>\n<p class="sefer">#' -e 's#\(בין אחרון:\) #</p>\1\n<! end perek>\n<p class="sefer">#' "$intermediate/0010_RAMBAM-MRG_L0.txt"
printf "<! end perek>\n" >> "$intermediate/0010_RAMBAM-MRG_L0.txt"

sed -i -e 's#\(<p class="law"><b class="lawt"> פד)</b>\)#<! end perek>\n\1#' -e 's#\(<p class="law"><b class="lawt"> קסז)</b>\)#<! end perek>\n\1#' "$intermediate/0020_RAMBAM-POSITIVE_MITZVAH_L0.txt"

sed -i -e 's#\(<p class="law"><b class="lawt"> קכג)</b>\)#<! end perek>\n\1#' -e 's#\(<p class="law"><b class="lawt"> רמה)</b>\)#<! end perek>\n\1#' "$intermediate/0024_RAMBAM-NEGITIVE_MITZVAH_L0.txt"

sed -i -e 's#\(ושמונה מצוות לא תעשה.  </p>\)#\1\n<! end perek>#' -e 's#\(ותשע עשרה מצוות לא תעשה.  </p>\)#\1\n<! end perek>#' "$intermediate/0028_RAMBAM-OVERVIEW_L0.txt"
printf "<! end perek>\n" >> "$intermediate/0028_RAMBAM-OVERVIEW_L0.txt"

#####
# make sefer
#####
$scripts/rambam_sefer.awk $intermediate/*.txt;

#####
# make 3 perek
#####
if [[ ! -d "$intermediate/three_perek" ]]; then mkdir -p "$intermediate/three_perek"; fi;
$scripts/rambam_three_perek.awk -v "basefolder=$intermediate/three_perek" $intermediate/*.txt;

#
# one chapter modifications
#
sed -i -e '805d' "$intermediate/0040_RAMBAM_AHAVA_L1.txt"
sed -i -e 's#\(סליק נוסח ההגדה  </p>\)#\1\n<! end perek>#' "$intermediate/0050_RAMBAM-ZMANIM_L1.txt"

#####
# make 3 perek
#####
if [[ ! -d "$intermediate/one_perek" ]]; then mkdir -p "$intermediate/one_perek"; fi;
$scripts/rambam_one_perek.awk -v "basefolder=$intermediate/one_perek" $intermediate/*.txt;


#####
# make output directories
#####
if [[ ! -d "$baseout" ]]; then mkdir -p $baseout; fi
#if [[ ! -d "$fontbaseout" ]]; then mkdir -p $fontbaseout; fi
if [[ ! -d "$epubbaseout" ]]; then mkdir -p $epubbaseout; fi
#if [[ ! -d "$epubfontbaseout" ]]; then mkdir -p $epubfontbaseout; fi


#####
# output sefer
#####
counter=1
for i in $intermediate/*.html; do

	title2=$(grep -o -m1 -e '<h1 class="sefert">.\+</h1>' $i | sed -e 's#<h1 class="sefert">##' -e 's#</h1>##' )
	if [[ $title2 == "" ]]
		then title2=$(grep -o -m1 -e '<h2 class="halachost">.\+</h2>' $i | sed -e 's#<h2 class="halachost">##' -e 's#</h2>##' )
	fi
	output2="$(printf "%02d" $counter)_$(echo $title2 | sed -e 's/ /_/g' )"

	convertsefer $i "$output2" "azw3" "$baseout" "$title2" &
#	convertsefer $i "$output2" "azw3" "$fontbaseout" "$title2" "embed" &
	convertsefer $i "$output2" "epub" "$epubbaseout" "$title2" &
#	convertsefer $i "$output2" "epub" "$epubfontbaseout" "$title2" "embed" &
	counter=$(($counter+1));
	wait
done;

###########################################################################

convertthreechapter() {
	version="$3"
	filename="$1"
	output="$(basename -s .html $filename)"
	title="רמבם_$version_$output"
	fileout="$baseout/$2"
	if [[ ! -d "$fileout" ]]
		then mkdir -p $fileout
	fi
	fileout2="$fontbaseout/$2"
	if [[ ! -d "$fileout2" ]]
		then mkdir -p $fileout2
	fi
	fileout3="$epubbaseout/$2"
	if [[ ! -d "$fileout3" ]]
		then mkdir -p $fileout3
	fi
	fileout4="$epubfontbaseout/$2"
	if [[ ! -d "$fileout4" ]]
		then mkdir -p $fileout4
	fi
	ebook-convert "$filename" "$fileout/$output.azw3" --subset-embedded-fonts --extra-css "$scripts/rambam.css" --chapter-mark "rule" --start-reading-at '//*[name()="h1" or name()="h2" or name()="h3"]' --language "he" --base-font-size "16" --title "$title" --authors 'רמב"ם' --level1-toc '//*[name()="h1" or name()="h2" or name()="h3"]' &
	ebook-convert "$filename" "$fileout2/$output.azw3" --subset-embedded-fonts --extra-css "$scripts/rambam.css" --chapter-mark "rule" --start-reading-at '//*[name()="h1" or name()="h2" or name()="h3"]' --language "he" --base-font-size "16" --title "$title" --authors 'רמב"ם' --level1-toc '//*[name()="h1" or name()="h2" or name()="h3"]' --embed-font-family "SBL Hebrew" &
	ebook-convert "$filename" "$fileout3/$output.epub" --subset-embedded-fonts --extra-css "$scripts/rambam.css" --chapter-mark "rule" --start-reading-at '//*[name()="h1" or name()="h2" or name()="h3"]' --language "he" --base-font-size "16" --title "$title" --authors 'רמב"ם' --level1-toc '//*[name()="h1" or name()="h2" or name()="h3"]' --no-default-epub-cover &
	ebook-convert "$filename" "$fileout4/$output.epub" --subset-embedded-fonts --extra-css "$scripts/rambam.css" --chapter-mark "rule" --start-reading-at '//*[name()="h1" or name()="h2" or name()="h3"]' --language "he" --base-font-size "16" --title "$title" --authors 'רמב"ם' --level1-toc '//*[name()="h1" or name()="h2" or name()="h3"]' --embed-font-family "SBL Hebrew" --no-default-epub-cover &
	wait
}

#####
# output 3 perek
#####
#for i in $intermediate/three_perek/*.html; do
#	convertthreechapter $i "threeperek" "ג-פ"
#	qwertyu=1
#done;

#####
# output 1 perek
#####
#for i in $intermediate/one_perek/*.html; do
#	convertthreechapter $i "oneperek" "פ-א"
#done;
