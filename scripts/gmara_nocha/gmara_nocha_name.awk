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
		sefer = gensub(/ ? ?(<span class="pirush">)?([^ <][^<]*[^ <]) ?(<\/span>)?<\/h1>/, "\\2", 1, $1);
		gsub(/ /, "_", sefer)
		out = basefolder "/" sefer ".html"
		print type$0 > out; 
		
	}
	type = RT;
}
