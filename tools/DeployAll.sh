#!/bin/bash


for a in cuisine chambre salon ventilos
do
echo "[$a]"
./TelnetUpload.py mqtt.lua compile |socat - tcp4:"$a":2323
./TelnetUpload.py tools.lua compile |socat - tcp4:"$a":2323
./TelnetUpload.py r_init.lua compile |socat - tcp4:"$a":2323
done
