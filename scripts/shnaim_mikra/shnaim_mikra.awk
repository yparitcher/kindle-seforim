#!/usr/bin/awk -f

BEGIN {
    type = "0";
    perek = "0";
    meforeshperek = "0";
    meforeshposuk = "0";
    RS = "[$^@~!]";
    FS = "\n";
}

FNR==NR{
	switch (type){
		case "~":
			meforeshperek = $1;
			break;
		case "!": 
			{
			meforeshposuk = $1;
			$1 = "";
			meforesh[meforeshperek meforeshposuk]=$0;
			break;
			}
		default :
			break;
		
	}
	type = RT;
	next;
}

{
	switch (type){
		case "$": 
			printf "<h1 class=\"seferh\">" $1 "</h1>\n";
			break;
		case "^": 
			printf "<h2 class=\"parshah\">" $1 "</h2>\n";
			break;
		case "@": 
			printf "<h3 class=\"aliyah\">" $1 "</h3>\n";
			break;
		case "~": 
			printf "<h4 class=\"perekh\">" $1 "</h4>\n";
			perek = $1;
			break;
		case "!": 
			{
			count=perek $1;
			printf "<p class=\"posuk\"><b class=\"posukh\">" $1 "</b><span class=\"mikra\">";
			$1="";
			printf $0;
			printf "</span><span class=\"mikra2\">";
			printf $0;
			printf "</span>\n";
			if (meforesh[count] != ""){ 
				printf "<span class=\"targum\">";
				printf meforesh[count];
				printf "</span></p>\n" ;
			}
			break;
			}
		default :
			break;
	}
	type = RT;

 }
