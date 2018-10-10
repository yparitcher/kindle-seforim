#!/usr/bin/awk -f

BEGIN {
    RS = "<! end perek>";
	number=1
}

BEGINFILE {
	out = FILENAME ".html"
}

{
	print > out;
	if ((number % 3) == 0 && RT == "<! end perek>") { print "<h4 class=\"perekthreedivide\">***</h4>" > out; }
	if (RT == "<! end perek>") { print RS > out; }
	if (RT == "<! end perek>") {number ++}
}
