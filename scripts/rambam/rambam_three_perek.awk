#!/usr/bin/awk -f

BEGIN {
    RS = "<! end perek>";
    number=1;
    counter=0;
}

{
	numberpad = sprintf( "%03d", number);
    out = basefolder "/" numberpad ".html";
	print > out;
	if (RT == "<! end perek>") { print RS > out; }
	if (RT == "<! end perek>") { 
		counter++;
		if (!(counter % 3) && (number < 339)) { number++; }
	}	
}
