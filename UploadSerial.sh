#!/bin/sh



nodemcu-uploader upload *lua --compile


nodemcu-uploader upload setup.html.gz style.css.gz

#for a in  *.html 
#do
#gzip $a
#python2 ../nodemcu-uploader/nodemcu-uploader.py upload "$a.gz"
#gunzip $a
#
#done
