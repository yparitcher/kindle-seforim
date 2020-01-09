#!/usr/bin/awk -f

BEGIN {
    type = "0";
    perek = "0";
    RS = "[$^~]";
    FS = "\n";
}

{
	switch (type){
		case "$": 
			printf "<h1 class=\"seferh\">" $1 "</h1>\n";
			break;
		case "^": 
			printf "<h2 class=\"perekh\">" $1 "</h2>\n";
			perek = $1;
			break;
		case "~": 
			{
			printf "<div class=\"daf\"><h3 class=\"dafh\">" $1 "</h3>";
			$1="";
			printf "%s", $0;
			printf "</div>\n";
			break;
			}
		default :
			break;
	}
	type = RT;
}
