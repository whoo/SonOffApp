#!/bin/sh

for a in file.lua gpio.lua http.lua mqtt.lua r_init.lua safe.lua setup.lua telnet.lua test.lua time.lua tools.lua setup.html.gz style.css.gz
do
echo "$a  ---"
./TelnetUpload.py "$a" c | socat - tcp4:$1:2323
echo ""
done

./TelnetUpload.py "init.lua" | socat - tcp4:$1:2323
