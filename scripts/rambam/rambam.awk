#!/usr/bin/awk -f

BEGIN {
    type = "0";
    chap = "0";
    RS = "[$@~!]";
    FS = "\n"
}

{
	switch (type){
		case "$": 
			printf "<p class=\"sefer\"><h1 class=\"sefert\">" $1 "</h1>";
			$1="";
			$2="";
			printf $0
			printf "</p>\n" ;
			break;
		case "@": 
			printf "<p class=\"halachos\"><h2 class=\"halachost\">" $1 "</h2>";
			$1="";
			printf $0
			printf "</p>\n" ;
			break;
		case "~": 
			printf "<p class=\"perek\"><h3 class=\"perekt\">" $1 "</h3>";
			if ((RT == "~" && $1 !~ /נוסח ברכות התפלה וסידורן/ && $1 !~/נוסח ברכת המזון/)||(RT == "")) chap = "1";
			$1="";
			printf $0;
			printf "</p>\n" ;
			if (chap  == "1") 
			{
				printf "<! end perek>\n";
				chap = "0";
			}
			break;
		case "!": 
			{
			printf "<p class=\"law\"><b class=\"lawt\">" $1 ")</b>";
			$1="";
			printf $0
			printf "</p>\n" ;
			if (RT ~ /[$@~]/ || RT == "") printf "<! end perek>\n";
			break;
			}
		default :
			break;
	}
	type = RT;

 }
