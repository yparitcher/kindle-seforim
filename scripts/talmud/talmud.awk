#!/usr/bin/awk -f

BEGIN {
    type = "0";
    perek = "0";
    meforeshperek = "0";
    meforeshposuk = "0";
    RS = "[$^~]";
    FS = "\n";
}

FNR==NR{
	switch (type){
		case "^":
			meforeshperek = $1;
			break;
		case "~": 
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
			printf "<h2 class=\"perekh\">" $1 "</h2>\n";
			perek = $1;
			break;
		case "~": 
			{
			count=perek $1;
			printf "<div class=\"daf\"><h3 class=\"dafh\">" $1 "</h3>";
			$1="";
			printf $0;
			printf "</div>\n";
			if (meforesh[count] != ""){ 
				printf "<div class=\"rashi\"><h4 class=\"hrashi\">רש״י</h4><span class=\"rashi\">";
				printf meforesh[count];
				printf "</span></div>\n" ;
			}
			break;
			}
		default :
			break;
	}
	type = RT;

 }
