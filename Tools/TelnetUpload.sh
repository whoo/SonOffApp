#!/bin/bash

FILE=$1
COMPILE=$2

echo "file.open(\""$FILE"\",\"w\")"

while read line
do
sleep 0.5
rline=$(echo -e "$line" |sed -e 's/\"/\\\"/g')
echo "file.writeline(\"$rline\")"
done < $FILE
echo "file.close()"
echo ""

if [ ! "x${COMPILE}" = "x" ]
then
	echo "node.compile(\"$FILE\")"
	sleep 1
	echo "file.remove(\"$FILE\")"
fi


### | socat - tcp4:<IP>:2323
