#!/bin/bash
#
# Copyright (c) 2018 Y Paritcher
#

convertebook(){

	filename="$1"
	base="$(basename $filename)"
	meta="$(ebook-meta $filename)"
	output="$(grep 'Title               : ' <<< "$meta" | sed -e 's/Title               : //' -e 's/ /_/g')"
	if [[ -n "$(echo $base | grep -e '_all')" ]]
		then suffix="_all"
	elif [[ -n "$(echo $base | grep -e '_part_')" ]]
		then suffix="_$(echo $base | sed -E 's#.*_([0-9]+)\.html#\1#')"
	fi
	if [[ ! -e ./output/$output$suffix.azw3 ]] || [[ $filename -nt ./output/$output$suffix.azw3 ]]
		then ebook-convert "$filename" "./output/$output$suffix.azw3"
	fi
}
export -f convertebook

work="$(find ./intermediate/ -name *.html -print)"
parallel convertebook ::: $work
