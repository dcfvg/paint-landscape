#!/bin/bash

if [[ $# -eq 0 ]] # check if a param is entered
then
	echo 'warning ! no url list path set'
	exit 0
fi

function initenv {
	assets="assets"
	url="$assets/url"
	result="$assets/result"

	mkdir -v $assets $result $url
}
function initproject {

	setpath="$result/$setname"
	
	raw="$setpath/raw"	# orignal images
	tmp="$setpath/tmp"	# tmp folder
	mov="$setpath/mov"	# result as mp4
	stk="$setpath/stk"	# result as tiles

	mkdir -v $setpath $tmp $mov $stk $raw
}
function gettilesHD {
	i=0
	for file in $(cat $urlpath)
	do	
		id=`printf %02d $i`
		wget -nc -O "$raw/$id.jpg" $file
		((i++))
		
		x=${file: -5 :1}
		y=${file: -8 :1}
		
	done
	tilesetsize="$(($x + 1))x$(($y + 1))"
	printf "tiles: $i \t tilesetsize: $tilesetsize"
}
function tilemontage {
	gm montage -monitor -geometry +0+0 -tile $tilesetsize "$raw/*.jpg" "$tmp/$setname.miff"
}
function stack {
	for res in ${resolutions[@]} 
	do
		tilepath="$stk/tiles-$res"
		mkdir $tilepath
		
		echo "tiles @$res"
		gm convert "$tmp/$setname.miff" -crop $res +adjoin $tilepath/%05d.jpg
		gm mogrify -background black -extent $res $tilepath/*jpg
		
		echo "mov @$res"
		ffmpeg -f image2 -pattern_type glob -i "$tilepath/*.jpg" \
		-r 25 -vcodec mpeg4 -b 30000k \
		-y $mov/setname-$res.mp4
	done
}

resolutions=("1280x960" "1920x1080")

for urlpath in `find $1 -iname "*.md" -type f`
do
	echo "starting $setname"

	urlfile=$(basename $urlpath)
	setname="${urlfile%.*}"
	
    clear
	initenv			# create basic folder tree 
	initproject		# create folder tree
	gettilesHD		# get tiles from url
	tilemontage		# assemble all tiles in one .miff image
	stack			# create tiles from the .miff image and compile them into a movie
done