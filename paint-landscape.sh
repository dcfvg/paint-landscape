
setname="In_the_Conservatory"
tiles=$setname/tiles/

mkdir $setname
cd $setname

wget -nc -O 00.jpg http://upload.wikimedia.org/wikipedia/commons/d/d5/In_the_Conservatory-x0-y0.jpg
wget -nc -O 01.jpg http://upload.wikimedia.org/wikipedia/commons/e/e4/In_the_Conservatory-x1-y0.jpg
wget -nc -O 02.jpg http://upload.wikimedia.org/wikipedia/commons/9/9d/In_the_Conservatory-x2-y0.jpg
wget -nc -O 03.jpg http://upload.wikimedia.org/wikipedia/commons/a/a7/In_the_Conservatory-x0-y1.jpg
wget -nc -O 04.jpg http://upload.wikimedia.org/wikipedia/commons/2/24/In_the_Conservatory-x1-y1.jpg
wget -nc -O 05.jpg http://upload.wikimedia.org/wikipedia/commons/2/29/In_the_Conservatory-x2-y1.jpg
wget -nc -O 06.jpg http://upload.wikimedia.org/wikipedia/commons/a/a4/In_the_Conservatory-x0-y2.jpg
wget -nc -O 07.jpg http://upload.wikimedia.org/wikipedia/commons/a/aa/In_the_Conservatory-x1-y2.jpg
wget -nc -O 08.jpg http://upload.wikimedia.org/wikipedia/commons/3/33/In_the_Conservatory-x2-y2.jpg

# gm montage -monitor -geometry +0+0 -tile 3x3 *.jpg final.miff

mkdir tiles
#gm convert final.miff -crop 1280x960 +adjoin tiles/tile-%05d.jpg

cd tiles
ffmpeg -f image2 -pattern_type glob -i '*.jpg' -r 25 -vcodec mpeg4 -b 30000k -vf scale=1280:-1 -y all.mp4