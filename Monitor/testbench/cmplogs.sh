#! /bin/bash

RED="\e[91;40m"
GREEN="\e[92;40m"
YELLOW="\e[93;40m"
MAGENTA="\e[95;40m"
OFF="\e[0m"

ERROR=0

if [ ! -f "$1" ]; then
    echo -e $RED"Error:"$OFF "file does not exist:" $1
    exit -1
fi

if [ ! -f "$2" ]; then
    echo -e $MAGENTA"Warning:"$OFF "no reference file given" for $1
    cat $1
    echo ""
    exit -1
fi

echo -ne "comparing $1 and $2 ... "

# compare unmodified log and ref
diff -q $1 $2 > /dev/null
if [ $? -eq 1 ]; then
    echo -ne "[" $RED"Error"$OFF "]"
    ERROR=1
else
    echo -ne "[" $GREEN"OK"$OFF "]"
fi

if [ "$ERROR" -eq "1" ]; then

# filter timing related stuff from the logs
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
    echo -e ""
else
    echo -e " Without timing: [" $GREEN"OK"$OFF "]"
fi
    diff $1 $2
    echo ""

else
    echo ""
fi

rm -f $1.tmp
rm -f $2.tmp

if [ "$ERROR" -eq "1" ]; then
    exit -1
fi
