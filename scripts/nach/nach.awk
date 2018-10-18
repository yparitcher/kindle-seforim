#!/usr/bin/awk -f

BEGIN {
    type = "0";
    RS = "[$~!]";
    FS = "\n";
	out = ""
}

{
	switch (type){
		case "$": 
			sefer = gensub(/ *([^ ].*[^ ]) */, "\\1", 1, $1);
			gsub(/ /, "_", sefer)
			out = basefolder "/" sefer ".html"
			break;
		case "~": 
			printf "<h2 class=\"perekh\">" $1 "</h2>\n" > out;
			break;
		case "!": 
			{
			printf "<div class=\"posuk\"><span class=\"posukh\">" $1 "</span>" > out;
			$1="";
			printf $0 > out;
			printf "</div>\n" > out;
			break;
			}
		default :
			break;
	}
	type = RT;

 }
