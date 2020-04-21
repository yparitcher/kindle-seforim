#!/usr/bin/awk -f

BEGIN {
    type = "0";
    perek = "0";
    RS = "[$#~!]";
    FS = "\n";
}

{
	switch (type){
		case "$": 
			printf "<title>" $1 "</title>\n";
			printf "<h1 class=\"seferh\">" $1 "</h1>\n";
			break;
		case "#": 
			printf "<h2 class=\"halachos\">" $1 "</h2>\n";
			break;
		case "~": 
			printf "<h2 class=\"Siman\">" $1 "</h2>\n";
			perek = $1;
			break;
		case "!": 
			{
			printf "<div class=\"seif\"><b class=\"seifh\">"$1 "</b>";
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
