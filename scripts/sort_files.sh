#!/bin/bash
#
# Copyright (c) 2018 Y Paritcher
#

start=a_root.html
root=./source/
sorted=./sorted/
#current=$root

splitfiles(){

#	if [[ $split != "" ]]
#		then echo "$split"
#	fi
	
	for i in $@; do
	
		start="$(iconv -f WINDOWS-1255 "$root$i" | grep -a '<script> begin (.*\");</script>' | sed 's/<script> begin (.*"\(.*\)",".*");<\/script>/\1/' | sed -e 's/ /_/g' -e 's/\r//')"
		if [[ ! -d $sorted$source$current$start ]]
			then mkdir "$sorted$source$current$start"
		fi
		
		resultsplit="$(iconv -f WINDOWS-1255 "$root$i" | grep -a -e '<script>	AddIndex(.*, \"book_start\"); </script>' -e '<script>	AddIndex(.*, \"book_mid\"); </script>' -e '<script>	AddIndex(.*, \"book_end\"); </script>' | sed -e 's/.*<script>	AddIndex(.*\"\(.*\)", \"book_start\"); <\/script>/\1/' -e 's/.*<script>	AddIndex(.*\"\(.*\)", \"book_mid\"); <\/script>/\1/' -e 's/.*<script>	AddIndex(.*\"\(.*\)\", \"book_end\"); <\/script>/\1/' | sed -e "s#\(.*\)#$sorted$source$current$start/\1#" -e 's/ /_/g' -e 's/\r/\n/')"
		for x in $resultsplit; do
			ln -rs "$root$(basename $x)" "$x"
		done

		resultsplit2="$(iconv -f WINDOWS-1255 "$root$i" | grep -a '<script>	AddIndex(.*, \"all_book\"); </script>' | sed 's/.*<script>	AddIndex(.*\"\(.*\)\", \"all_book\"); <\/script>/\1/' | sed -e "s#\(.*\)#$sorted$source$current$start/\1#" -e 's/ /_/g' -e 's/\r/\n/')"
		ln -rs "$root$(basename "$resultsplit2")" "$resultsplit2"
	done

}

files(){

	local source="$source$current"
	for i in $@; do
		if [[ "$i" =~ d_.* ]]
			then local current="$(iconv -f WINDOWS-1255 $root$i | grep -a '<script> begin (.*\");</script>' | sed 's/<script> begin (.*"\(.*\)",".*");<\/script>/\1/' | sed -e 's/\r//' -e 's/ /_/g')/"
			if [[ ! -d $sorted$source$current ]]
				then mkdir "$sorted$source$current"
			fi
		fi
	
		result="$(iconv -f WINDOWS-1255 $root$i | grep -a '<script>	AddIndex(.*, \"book\"); </script>' | sed 's/.*<script>	AddIndex(.*\"\(.*\)\", \"book\"); <\/script>/\1/' | sed -e "s#\(.*\)#$sorted$source$current\1#" -e 's/\r/\n/')"
		for z in $result; do
			ln -rs "$root$(basename $z)" "$z"
		done


		split="$(iconv -f WINDOWS-1255 $root$i | grep -a '<script>	AddIndex(.*, \"splited_book\"); </script>' | sed 's/.*<script>	AddIndex(.*\"\(.*\)\", \"splited_book\"); <\/script>/\1/' | sed 's/\r//')"
		
		splitfiles "$split"

		if [[ $(iconv -f WINDOWS-1255 $root$i | grep -a '<script>	AddIndex(.*, \"folder\"); </script>' | sed 's/.*<script>	AddIndex(.*\"\(.*\)", \"folder\"); <\/script>/\1/') != "" ]]
			then files $(iconv -f WINDOWS-1255 $root$i | grep -a '<script>	AddIndex(.*, \"folder\"); </script>' | sed 's/.*<script>	AddIndex(.*\"\(.*\)", \"folder\"); <\/script>/\1/' | sed 's/\r/\n/')
		fi

	done
}

roots="./source/d_root__035_mshnh_torh_lhrmbm.html ./source/d_root__030_tlmod_bbly.html ./source/d_root__020_mshnh.html ./source/d_root__003_ctobym.html ./source/d_root__001_torh.html ./source/d_root__002_nbyaym.html ./source/d_root__040_hlch_1.html"

files $start


