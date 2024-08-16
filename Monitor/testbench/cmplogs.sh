#! /bin/bash

RED="\e[91;40m"
GREEN="\e[92;40m"
YELLOW="\e[93;40m"
MAGENTA="\e[95;40m"
OFF="\e[0m"


if [ ! -f "$2" ]; then
    echo -e $MAGENTA"Warning:"$OFF "no reference file given" for $1
    exit 0;
fi

if [ ! -f "$1" ]; then
    echo -e $RED"Error:"$OFF "no file given at all"
    exit -1;
fi

echo -ne "comparing $1 and $2... "

cat $1 | \
    sed -e 's:\(^#[0-9]* (.*)\).*:\1:g' | \
    sed -e 's:[0-9]*$::g' | \
    sed -e 's:\(^>[C8].*\) [[:print:]]*$:\1:g' | \
    sed -e 's:[^[:print:]]: :g' | \
    sed -e 's:  : :g' | \
    sed -e 's: *$::g' \
    > $1.tmp

cat $2 | \
    sed -e 's:\(^#[0-9]* (.*)\).*:\1:g' | \
    sed -e 's:[0-9]*$::g' | \
    sed -e 's:\(^>[C8].*\) [[:print:]]*$:\1:g' | \
    sed -e 's:[^[:print:]]: :g' | \
    sed -e 's:  : :g' | \
    sed -e 's: *$::g' \
    > $2.tmp

diff -q $1.tmp $2.tmp > /dev/null
if [ $? -eq 1 ]; then
    echo -e "[" $RED"Error"$OFF "]"
    diff $1.tmp $2.tmp
else
    echo -e "[" $GREEN"OK"$OFF "]"
fi

rm -f $1.tmp
rm -f $2.tmp

exit 0;
