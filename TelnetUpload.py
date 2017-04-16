#!/usr/bin/env python3


import re
import time
import sys
import base64

if (len(sys.argv)>1):
    name=sys.argv[1]
else:
    print("%s: name.lua [copmile] | socat - tcp4:host:2323"%sys.argv[0])
    exit(0)


if (len(sys.argv)==3):
    option=sys.argv[2]
else:
    option=0


def upload(name,option):
    f=open(name,"r")
    print('file.open("%s","w")'%name)
    sys.stdout.flush() 
    time.sleep(0.5)
    for line in f:
        b=line.rstrip()
        b=re.escape(b)
        print('file.writeline("'+b+'")')
        sys.stdout.flush() 
        time.sleep(0.5)
    print('file.close()')
    if (option):
        print('node.compile("%s")'%name)
        print('file.remove("%s")'%name)




def uploadgz(name):
    
    print('file.open("temp.64","w")')
    sys.stdout.flush()
    time.sleep(0.5)
    f=open(name,"rb")
    buf=base64.b64encode(f.read())

    tb=[re.escape(buf[i:i+64].decode()) for i in range(0, len(buf), 64)]
    
    for b in tb:
        print('file.write("%s")'%b)
        sys.stdout.flush()
        time.sleep(0.5)
    print('file.close()')
    print('save64("%s")'%name)




if (name[-3:]=="lua"):
    upload(name,option)
else:
    uploadgz(name)


