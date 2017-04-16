#!/bin/sh



python2 ../nodemcu-uploader/nodemcu-uploader.py upload *lua --compile


python2 ../nodemcu-uploader/nodemcu-uploader.py upload setup.html.gz style.css.gz

#for a in  *.html 
#do
#gzip $a
#python2 ../nodemcu-uploader/nodemcu-uploader.py upload "$a.gz"
#gunzip $a
#
#done
