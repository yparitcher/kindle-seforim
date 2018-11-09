#!/usr/bin/awk -f

BEGIN {
    RS = "<h1 class=\"seferh\">";
    FS = "\n";
    type = "0";
	out = ""
	OFS=""
}

{
	if (type == "<h1 class=\"seferh\">") { 
		sefer = gensub(/ *([^ <][^<]*[^ <]) *<\/h1>/, "\\1", 1, $1);
		gsub(/ /, "_", sefer)
		out = basefolder "/" sefer ".html"
		print type$0 > out; 
		
	}
	type = RT;
}
