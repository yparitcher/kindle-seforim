#!/usr/bin/awk -f

BEGIN {
    RS = "<! end perek>";
    number=1;
}

{
	numberpad = sprintf( "%04d", number);
    out = basefolder "/" numberpad ".html";
	print > out;
	if (RT == "<! end perek>") { print RS > out; }
	if ((RT == "<! end perek>") && (number < 1017)) { number++; }	
}
