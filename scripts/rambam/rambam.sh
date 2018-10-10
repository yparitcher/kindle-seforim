#!/bin/bash

intermediate="./intermediate/rambam"
scripts="./scripts/rambam"
source="./Orayta-Books/BooksSrc/050_rmbm"
baseout="./output/kindle/rambam"
fontbaseout="./output/kindle_SBL_font/rambam"

parser() {
	sed -e 's#{{[^{}]\+}}##g' -e 's#{##g' -e 's#}##g' -e 's#<TRIM>##g' -e 's#  # #g' -e 's#  # #g' -e 's#<BR><HR><BR>#\n#g' $1 | $scripts/rambam.awk > $intermediate/$(basename $1);
}

convertsefer() {

	filename="$1"
	title=$(grep -o -m1 -e '<h1 class="sefert">.\+</h1>' $1 | sed -e 's#<h1 class="sefert">##' -e 's#</h1>##' )
	if [[ $title == "" ]]
		then title=$(grep -o -m1 -e '<h2 class="halachost">.\+</h2>' $1 | sed -e 's#<h2 class="halachost">##' -e 's#</h2>##' )
	fi
	output="$2_$(echo $title | sed -e 's/ /_/g' )"
	fileout="$baseout/$3"
	if [[ ! -d "$fileout" ]]
		then mkdir -p $fileout
	fi
	fileout2="$fontbaseout/$3"
	if [[ ! -d "$fileout2" ]]
		then mkdir -p $fileout2
	fi
	ebook-convert "$filename" "$fileout/$output.azw3" --subset-embedded-fonts --extra-css "$scripts/rambam.css" --chapter-mark "rule" --start-reading-at '//*[@class="sefer"]' --language "he" --base-font-size "16" --title "$title" --authors 'רמב"ם' --level1-toc '//*[@class="sefert"]' --level2-toc '//*[@class="halachost"]' --level3-toc '//*[@class="perekt"]'
	ebook-convert "$filename" "$fileout2/$output.azw3" --subset-embedded-fonts --extra-css "$scripts/rambam.css" --chapter-mark "rule" --start-reading-at '//*[@class="sefer"]' --language "he" --base-font-size "16" --title "$title" --authors 'רמב"ם' --level1-toc '//*[@class="sefert"]' --level2-toc '//*[@class="halachost"]' --level3-toc '//*[@class="perekt"]' --embed-font-family "SBL Hebrew" 

}

convertthreechapter() {
	filename="$1"
	output="$(basename -s .html $filename)"
	title="רמבם_$output"
	fileout="$baseout/$2"
	if [[ ! -d "$fileout" ]]
		then mkdir -p $fileout
	fi
	fileout2="$fontbaseout/$2"
	if [[ ! -d "$fileout2" ]]
		then mkdir -p $fileout2
	fi
	ebook-convert "$filename" "$fileout/$output.azw3" --subset-embedded-fonts --extra-css "$scripts/rambam.css" --chapter-mark "rule" --start-reading-at '//*[name()="h1" or name()="h2" or name()="h3"]' --language "he" --base-font-size "16" --title "$title" --authors 'רמב"ם' --level1-toc '//*[name()="h1" or name()="h2" or name()="h3"]'
	ebook-convert "$filename" "$fileout2/$output.azw3" --subset-embedded-fonts --extra-css "$scripts/rambam.css" --chapter-mark "rule" --start-reading-at '//*[name()="h1" or name()="h2" or name()="h3"]' --language "he" --base-font-size "16" --title "$title" --authors 'רמב"ם' --level1-toc '//*[name()="h1" or name()="h2" or name()="h3"]' --embed-font-family "SBL Hebrew" 

}

convertfont() {

	filename="$1"
	title=$(grep -o -m1 -e '<h1 class="sefert">.\+</h1>' $1 | sed -e 's#<h1 class="sefert">##' -e 's#</h1>##' )
	output="$2_$(echo $title | sed -e 's/ /_/g' )"
	fileout="$fontbaseout/sefer"
	if [[ ! -d "$fileout" ]]
		then mkdir -p $fileout
	fi
	ebook-convert "$filename" "$fileout/$output.azw3" --subset-embedded-fonts --extra-css "$scripts/rambam.css" --chapter-mark "rule" --start-reading-at '//*[@class="sefer"]' --language "he" --base-font-size "16" --title "$title" --authors 'רמב"ם' --level1-toc '//*[@class="sefert"]' --level2-toc '//*[@class="halachost"]' --level3-toc '//*[@class="perekt"]' --embed-font-family "SBL Hebrew" 

}

if [[ ! -d "$intermediate" ]]
	then mkdir -p "$intermediate"
fi

for i in $source/*.txt; do
	parser $i;
done

sed -i -e 's#<! end perek>##' "$intermediate/0028_RAMBAM-OVERVIEW_L0.txt"
printf "<! end perek>\n<! end perek>\n" >> "$intermediate/0020_RAMBAM-POSITIVE_MITZVAH_L0.txt"
printf "<! end perek>\n<! end perek>\n" >> "$intermediate/0024_RAMBAM-NEGITIVE_MITZVAH_L0.txt"
printf "<! end perek>\n<! end perek>\n<! end perek>\n" >> "$intermediate/0028_RAMBAM-OVERVIEW_L0.txt"
printf "<! end perek>\n<! end perek>\n<! end perek>\n" >> "$intermediate/0010_RAMBAM-MRG_L0.txt"

$scripts/rambam_sefer.awk $intermediate/*.txt;

if [[ ! -d "$intermediate/three_perek" ]]
	then mkdir -p "$intermediate/three_perek"
fi

$scripts/rambam_three_perek.awk -v "basefolder=$intermediate/three_perek" $intermediate/*.txt;


counter=1
for i in $intermediate/*.html; do
	convertsefer $i "$(printf "%02d" $counter)" "sefer";
#	convertfont $i "$(printf "%02d" $counter)";
	counter=$(($counter+1));
done;
for i in $intermediate/three_perek/*.html; do
	convertthreechapter $i "threeperek"
done;
