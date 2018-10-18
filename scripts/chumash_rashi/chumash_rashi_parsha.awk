#!/usr/bin/awk -f

BEGIN {
    RS = "<h2 class=\"parshah\">";
    FS = "\n";
    type = "0";
	out = ""
	OFS=""
}

{
	if (type == "<h2 class=\"parshah\">") { 
		parsha = gensub(/ *([^ <][^<]*[^ <]) *<\/h2>/, "\\1", 1, $1);
		gsub(/ /, "_", parsha)
		out = basefolder "/" parsha ".html"
		print RT $0 > out; 
		
	}
	type = RT;
}
