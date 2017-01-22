#!/bin/sh



python2 ../nodemcu-uploader/nodemcu-uploader.py upload *lua --compile
gzip index.html
python2 ../nodemcu-uploader/nodemcu-uploader.py upload index.html.gz
gunzip index.html
