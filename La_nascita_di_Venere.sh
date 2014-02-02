
setname="La_nascita_di_Venere"
tiles=$setname/tiles/

mkdir $setname
cd $setname
wget -O 00.jpg -nc http://upload.wikimedia.org/wikipedia/commons/9/95/Sandro_Botticelli_-_La_nascita_di_Venere_-_Google_Art_Project-x0-y0.jpg
wget -O 01.jpg -nc http://upload.wikimedia.org/wikipedia/commons/b/b1/Sandro_Botticelli_-_La_nascita_di_Venere_-_Google_Art_Project-x1-y0.jpg
wget -O 02.jpg -nc http://upload.wikimedia.org/wikipedia/commons/c/c2/Sandro_Botticelli_-_La_nascita_di_Venere_-_Google_Art_Project-x2-y0.jpg
wget -O 03.jpg -nc http://upload.wikimedia.org/wikipedia/commons/b/b8/Sandro_Botticelli_-_La_nascita_di_Venere_-_Google_Art_Project-x3-y0.jpg

wget -O 04.jpg -nc http://upload.wikimedia.org/wikipedia/commons/a/a4/Sandro_Botticelli_-_La_nascita_di_Venere_-_Google_Art_Project-x0-y1.jpg
wget -O 05.jpg -nc http://upload.wikimedia.org/wikipedia/commons/0/0d/Sandro_Botticelli_-_La_nascita_di_Venere_-_Google_Art_Project-x1-y1.jpg
wget -O 06.jpg -nc http://upload.wikimedia.org/wikipedia/commons/b/b5/Sandro_Botticelli_-_La_nascita_di_Venere_-_Google_Art_Project-x2-y1.jpg
wget -O 07.jpg -nc http://upload.wikimedia.org/wikipedia/commons/2/24/Sandro_Botticelli_-_La_nascita_di_Venere_-_Google_Art_Project-x3-y1.jpg

wget -O 08.jpg -nc http://upload.wikimedia.org/wikipedia/commons/4/4f/Sandro_Botticelli_-_La_nascita_di_Venere_-_Google_Art_Project-x0-y2.jpg
wget -O 09.jpg -nc http://upload.wikimedia.org/wikipedia/commons/9/9b/Sandro_Botticelli_-_La_nascita_di_Venere_-_Google_Art_Project-x1-y2.jpg
wget -O 10.jpg -nc http://upload.wikimedia.org/wikipedia/commons/9/9f/Sandro_Botticelli_-_La_nascita_di_Venere_-_Google_Art_Project-x2-y2.jpg
wget -O 11.jpg -nc http://upload.wikimedia.org/wikipedia/commons/0/02/Sandro_Botticelli_-_La_nascita_di_Venere_-_Google_Art_Project-x3-y2.jpg

gm montage -monitor -geometry +0+0 -tile 4x3 *.jpg tmp.miff

mkdir $tiles
gm convert -monitor tmp.miff -crop 1280x960 $tiles/%03d.jpg

cd $tiles
ffmpeg -f image2 -pattern_type glob -i '*.jpg' -r 25 -vcodec mpeg4 -b 30000k -vf scale=1280:-1 -y all.mp4
