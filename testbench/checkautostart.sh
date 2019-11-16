#! /bin/bash

source Makefile.config

if [ "$VICEDIR" == "" ] ; then
    VICEDIR="../../trunk/vice/src/"
fi
echo "using VICE dir:" $VICEDIR

function dotest
{

checkopts="$3 $4 $5 $6 $7 $8 $9 ${10} ${11} ${12} ${13}"

#echo $VICEDIR/$1 -debugcart -console -warp -limitcycles $LIMITCYCLES $checkopts $2

echo -ne $1" "$checkopts" # "

$VICEDIR/$1 $checkopts -debugcart -console -warp -limitcycles $LIMITCYCLES $2 1> /dev/null 2> /dev/null
exitcode=$?

#echo $exitcode
GREEN='\033[1;32m'
RED='\033[1;31m'
NC='\033[0m'
case "$exitcode" in
    0)
            echo -ne $GREEN
            exitstatus="ok"
        ;;
    1)
            echo -ne $RED
            exitstatus="timeout"
        ;;
    255)
            echo -ne $RED
            exitstatus="error"
        ;;
    *)
            echo -ne $RED
            exitstatus="error"
        ;;
esac
echo -e "$exitstatus" $NC

}

function alltests
{
echo $EMU":"$PROG
dotest $EMU $PROG -default $OPTS
dotest $EMU $PROG $OPTS +truedrive +virtualdev -autostartprgmode 0 -autostart-handle-tde -autostart-warp
dotest $EMU $PROG $OPTS +truedrive +virtualdev -autostartprgmode 0 -autostart-handle-tde +autostart-warp
dotest $EMU $PROG $OPTS -truedrive +virtualdev -autostartprgmode 0 -autostart-handle-tde -autostart-warp
dotest $EMU $PROG $OPTS -truedrive +virtualdev -autostartprgmode 0 -autostart-handle-tde +autostart-warp
dotest $EMU $PROG $OPTS +truedrive -virtualdev -autostartprgmode 0 -autostart-handle-tde -autostart-warp
dotest $EMU $PROG $OPTS +truedrive -virtualdev -autostartprgmode 0 -autostart-handle-tde +autostart-warp
dotest $EMU $PROG $OPTS -truedrive -virtualdev -autostartprgmode 0 -autostart-handle-tde -autostart-warp
dotest $EMU $PROG $OPTS -truedrive -virtualdev -autostartprgmode 0 -autostart-handle-tde +autostart-warp
dotest $EMU $PROG $OPTS +truedrive +virtualdev -autostartprgmode 1 -autostart-handle-tde -autostart-warp
dotest $EMU $PROG $OPTS +truedrive +virtualdev -autostartprgmode 1 -autostart-handle-tde +autostart-warp
dotest $EMU $PROG $OPTS -truedrive +virtualdev -autostartprgmode 1 -autostart-handle-tde -autostart-warp
dotest $EMU $PROG $OPTS -truedrive +virtualdev -autostartprgmode 1 -autostart-handle-tde +autostart-warp
dotest $EMU $PROG $OPTS +truedrive -virtualdev -autostartprgmode 1 -autostart-handle-tde -autostart-warp
dotest $EMU $PROG $OPTS +truedrive -virtualdev -autostartprgmode 1 -autostart-handle-tde +autostart-warp
dotest $EMU $PROG $OPTS -truedrive -virtualdev -autostartprgmode 1 -autostart-handle-tde -autostart-warp
dotest $EMU $PROG $OPTS -truedrive -virtualdev -autostartprgmode 1 -autostart-handle-tde +autostart-warp
dotest $EMU $PROG $OPTS +truedrive +virtualdev -autostartprgmode 2 -autostart-handle-tde -autostart-warp
dotest $EMU $PROG $OPTS +truedrive +virtualdev -autostartprgmode 2 -autostart-handle-tde +autostart-warp
dotest $EMU $PROG $OPTS -truedrive +virtualdev -autostartprgmode 2 -autostart-handle-tde -autostart-warp
dotest $EMU $PROG $OPTS -truedrive +virtualdev -autostartprgmode 2 -autostart-handle-tde +autostart-warp
dotest $EMU $PROG $OPTS +truedrive -virtualdev -autostartprgmode 2 -autostart-handle-tde -autostart-warp
dotest $EMU $PROG $OPTS +truedrive -virtualdev -autostartprgmode 2 -autostart-handle-tde +autostart-warp
dotest $EMU $PROG $OPTS -truedrive -virtualdev -autostartprgmode 2 -autostart-handle-tde -autostart-warp
dotest $EMU $PROG $OPTS -truedrive -virtualdev -autostartprgmode 2 -autostart-handle-tde +autostart-warp

dotest $EMU $PROG $OPTS +truedrive +virtualdev -autostartprgmode 0 +autostart-handle-tde -autostart-warp
dotest $EMU $PROG $OPTS +truedrive +virtualdev -autostartprgmode 0 +autostart-handle-tde +autostart-warp
dotest $EMU $PROG $OPTS -truedrive +virtualdev -autostartprgmode 0 +autostart-handle-tde -autostart-warp
dotest $EMU $PROG $OPTS -truedrive +virtualdev -autostartprgmode 0 +autostart-handle-tde +autostart-warp
dotest $EMU $PROG $OPTS +truedrive -virtualdev -autostartprgmode 0 +autostart-handle-tde -autostart-warp
dotest $EMU $PROG $OPTS +truedrive -virtualdev -autostartprgmode 0 +autostart-handle-tde +autostart-warp
dotest $EMU $PROG $OPTS -truedrive -virtualdev -autostartprgmode 0 +autostart-handle-tde -autostart-warp
dotest $EMU $PROG $OPTS -truedrive -virtualdev -autostartprgmode 0 +autostart-handle-tde +autostart-warp
dotest $EMU $PROG $OPTS +truedrive +virtualdev -autostartprgmode 1 +autostart-handle-tde -autostart-warp
dotest $EMU $PROG $OPTS +truedrive +virtualdev -autostartprgmode 1 +autostart-handle-tde +autostart-warp
dotest $EMU $PROG $OPTS -truedrive +virtualdev -autostartprgmode 1 +autostart-handle-tde -autostart-warp
dotest $EMU $PROG $OPTS -truedrive +virtualdev -autostartprgmode 1 +autostart-handle-tde +autostart-warp
dotest $EMU $PROG $OPTS +truedrive -virtualdev -autostartprgmode 1 +autostart-handle-tde -autostart-warp
dotest $EMU $PROG $OPTS +truedrive -virtualdev -autostartprgmode 1 +autostart-handle-tde +autostart-warp
dotest $EMU $PROG $OPTS -truedrive -virtualdev -autostartprgmode 1 +autostart-handle-tde -autostart-warp
dotest $EMU $PROG $OPTS -truedrive -virtualdev -autostartprgmode 1 +autostart-handle-tde +autostart-warp
dotest $EMU $PROG $OPTS +truedrive +virtualdev -autostartprgmode 2 +autostart-handle-tde -autostart-warp
dotest $EMU $PROG $OPTS +truedrive +virtualdev -autostartprgmode 2 +autostart-handle-tde +autostart-warp
dotest $EMU $PROG $OPTS -truedrive +virtualdev -autostartprgmode 2 +autostart-handle-tde -autostart-warp
dotest $EMU $PROG $OPTS -truedrive +virtualdev -autostartprgmode 2 +autostart-handle-tde +autostart-warp
dotest $EMU $PROG $OPTS +truedrive -virtualdev -autostartprgmode 2 +autostart-handle-tde -autostart-warp
dotest $EMU $PROG $OPTS +truedrive -virtualdev -autostartprgmode 2 +autostart-handle-tde +autostart-warp
dotest $EMU $PROG $OPTS -truedrive -virtualdev -autostartprgmode 2 +autostart-handle-tde -autostart-warp
dotest $EMU $PROG $OPTS -truedrive -virtualdev -autostartprgmode 2 +autostart-handle-tde +autostart-warp
echo "---"
}

# x64
function testx64 
{
LIMITCYCLES=10000000
EMU=x64
OPTS=
PROG=./selftest/c64-pass.prg
alltests
PROG=./selftest/c64-pass.d64
alltests
}

# x64sc
function testx64sc 
{
LIMITCYCLES=10000000
EMU=x64sc
OPTS=
PROG=./selftest/c64-pass.prg
alltests
PROG=./selftest/c64-pass.d64
alltests
}

# x128 (c64 mode)
function testx128
{
LIMITCYCLES=10000000
EMU=x128
OPTS=-go64
PROG=./selftest/c64-pass.prg
alltests
PROG=./selftest/c64-pass.d64
alltests

# x128 (VIC)
EMU=x128
OPTS=-40col
PROG=./selftest/c128-pass.prg
alltests
PROG=./selftest/c128-pass.d64
alltests

# x128 (VDC)
EMU=x128
OPTS=-80col
PROG=./selftest/c128-pass.prg
alltests
PROG=./selftest/c128-pass.d64
alltests
}

# vic20
function testxvic
{
LIMITCYCLES=10000000
EMU=xvic
OPTS="-memory 8k"
PROG=./selftest/vic20-pass.prg
alltests
PROG=./selftest/vic20-pass.d64
alltests
}

# x64dtv
function testx64dtv
{
LIMITCYCLES=50000000
EMU=x64dtv
OPTS=
PROG=./selftest/dtv-pass.prg
alltests
PROG=./selftest/dtv-pass.d64
alltests
}

# xplus4
function testxplus4
{
LIMITCYCLES=10000000
EMU=xplus4
OPTS=
PROG=./selftest/plus4-pass.prg
alltests
PROG=./selftest/plus4-pass.d64
alltests
}

# xpet
function testxpet
{
LIMITCYCLES=20000000
EMU=xpet
OPTS="-drive8type 8250"
PROG=./selftest/pet-pass.prg
alltests
PROG=./selftest/pet-pass.d82
alltests
}

# xscpu64
function testxscpu64
{
LIMITCYCLES=10000000
EMU=xscpu64
OPTS=
PROG=./selftest/scpu-pass.prg
alltests
PROG=./selftest/scpu-pass.d64
alltests
}

# xcbm2
function testxcbm2
{
LIMITCYCLES=80000000
EMU=xcbm2
OPTS="-drive8type 8250"
PROG=./selftest/cbm610-pass.prg
alltests
PROG=./selftest/cbm610-pass.d82
alltests
}

# xcbm5x0
function testxcbm5x0
{
LIMITCYCLES=80000000
EMU=xcbm5x0
OPTS="-drive8type 8250"
PROG=./selftest/cbm510-pass.prg
alltests
PROG=./selftest/cbm510-pass.d82
alltests
}

testx128
testx64sc
testx64
testxvic
testxplus4
testx64dtv
testxscpu64
testxpet
testxcbm2
testxcbm5x0
