#! /bin/bash

# get arguments
if [ "$1" = "-m" ]; then
    meld=true
    shift
fi
src1=$1
src2=$2

# analyze
./analyze $src1 > /tmp/dump1.txt
./analyze $src2 > /tmp/dump2.txt

# present results
if [ "$meld" = "true" ]; then
    meld /tmp/dump1.txt /tmp/dump2.txt
else
    diff -y -W 160 /tmp/dump1.txt /tmp/dump2.txt
fi

# eof
