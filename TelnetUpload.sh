#!/bin/bash

FILE=$1

echo "file.open(\""$FILE"\",\"w\")"

while read line 
do
sleep 0.5
rline=$(echo $line |sed -e 's/\"/\\\"/g')
echo "file.writeline(\"$rline\")"
done < $FILE
echo "file.close()"

### | socat - tcp4:<IP>:2323
