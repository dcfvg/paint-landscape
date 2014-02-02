#!/bin/bash

assets="assets"
url="$assets/url"	# url list
result="$assets/result"


mkdir -v $assets $result $url
resolutions=("1280x960" "1920x1080")




if [[ $# -eq 0 ]]
then
	echo 'warning ! no url list'
	exit 0
fi

urlpath=$1
urlfile=$(basename $urlpath)
setname="${urlfile%.*}"

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
		echo "wget -nc -O $id.jpg $file"
		((i++))
		
		x=${file: -5 :1}
		y=${file: -8 :1}
		
	done
	tilesetsize="$(($x + 1))x$(($y + 1))"
	echo "tilesetsize $tilesetsize"
}
function tilemontage {
	echo gm montage -monitor -geometry +0+0 -tile $tilesetsize "$raw/*.jpg" "$tmp/$setname.miff"
}
function stack {
	for res in ${resolutions[@]} 
	do
		tilepath="$stk/tiles-$res"
		mkdir $tilepath
		gm convert "$tmp/$setname.miff" -crop $res +adjoin $tilepath/%05d.jpg
		
		ffmpeg -f image2 -pattern_type glob -i "$tilepath/*.jpg" \
		-r 25 -vcodec mpeg4 -b 30000k -vf \
		-y $mov/setname-$res.mp4
	done
}

echo "starting $setname"

initproject		# create folder tree
gettilesHD		# get tiles from url
tilemontage		# assemble all tiles in one .miff image
stack			# create tiles from the .miff image and compile them into a movie
