#!/bin/sh



python2 ../nodemcu-uploader/nodemcu-uploader.py upload *lua --compile


for a in  *.html 
do
gzip $a
python2 ../nodemcu-uploader/nodemcu-uploader.py upload "$a.gz"
gunzip $a

done
