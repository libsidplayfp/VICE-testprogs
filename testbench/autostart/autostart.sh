#! /bin/bash

source ../Makefile.config

VERBOSE=0

function dotest
{

checkopts="$3 $4 $5 $6 $7 $8 $9 ${10} ${11} ${12} ${13}"

if [ "$VERBOSE" == "1" ] ; then
    echo "-_"
    echo $VICEDIR/$1 -default $checkopts -debugcart -limitcycles $LIMITCYCLES $2
fi

echo -ne $1" "$checkopts" # "

../$VICEDIR/$1 -default $checkopts -debugcart -console -warp -limitcycles $LIMITCYCLES $2 1> /dev/null 2> /dev/null
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

# prg autostart modes are:
# 0 : virtual filesystem
# 1 : inject to ram (there might be no drive)
# 2 : copy to d64

function alltests_prg
{
echo $EMU":"$PROGPRE-X.$PROGEXT
dotest $EMU $PROGPRE-tde-disk.$PROGEXT -default $OPTS

dotest $EMU $PROGPRE-tde.$PROGEXT         $OPTS -truedrive +virtualdev -autostartprgmode 0 +autostart-handle-tde -autostart-warp
dotest $EMU $PROGPRE-tde.$PROGEXT         $OPTS -truedrive +virtualdev -autostartprgmode 0 +autostart-handle-tde +autostart-warp
dotest $EMU $PROGPRE-tde.$PROGEXT         $OPTS -truedrive -virtualdev -autostartprgmode 0 +autostart-handle-tde -autostart-warp
dotest $EMU $PROGPRE-tde.$PROGEXT         $OPTS -truedrive -virtualdev -autostartprgmode 0 +autostart-handle-tde +autostart-warp
dotest $EMU $PROGPRE-none.$PROGEXT        $OPTS +truedrive +virtualdev -autostartprgmode 0 +autostart-handle-tde -autostart-warp
dotest $EMU $PROGPRE-none.$PROGEXT        $OPTS +truedrive +virtualdev -autostartprgmode 0 +autostart-handle-tde +autostart-warp
dotest $EMU $PROGPRE-vfs.$PROGEXT         $OPTS +truedrive -virtualdev -autostartprgmode 0 +autostart-handle-tde -autostart-warp
dotest $EMU $PROGPRE-vfs.$PROGEXT         $OPTS +truedrive -virtualdev -autostartprgmode 0 +autostart-handle-tde +autostart-warp

dotest $EMU $PROGPRE-tde.$PROGEXT         $OPTS -truedrive +virtualdev -autostartprgmode 1 +autostart-handle-tde -autostart-warp
dotest $EMU $PROGPRE-tde.$PROGEXT         $OPTS -truedrive +virtualdev -autostartprgmode 1 +autostart-handle-tde +autostart-warp
dotest $EMU $PROGPRE-tde.$PROGEXT         $OPTS -truedrive -virtualdev -autostartprgmode 1 +autostart-handle-tde -autostart-warp
dotest $EMU $PROGPRE-tde.$PROGEXT         $OPTS -truedrive -virtualdev -autostartprgmode 1 +autostart-handle-tde +autostart-warp
dotest $EMU $PROGPRE-none.$PROGEXT        $OPTS +truedrive +virtualdev -autostartprgmode 1 +autostart-handle-tde -autostart-warp
dotest $EMU $PROGPRE-none.$PROGEXT        $OPTS +truedrive +virtualdev -autostartprgmode 1 +autostart-handle-tde +autostart-warp
dotest $EMU $PROGPRE-vfs.$PROGEXT         $OPTS +truedrive -virtualdev -autostartprgmode 1 +autostart-handle-tde -autostart-warp
dotest $EMU $PROGPRE-vfs.$PROGEXT         $OPTS +truedrive -virtualdev -autostartprgmode 1 +autostart-handle-tde +autostart-warp

dotest $EMU $PROGPRE-tde-disk.$PROGEXT    $OPTS -truedrive +virtualdev -autostartprgmode 2 +autostart-handle-tde -autostart-warp
dotest $EMU $PROGPRE-tde-disk.$PROGEXT    $OPTS -truedrive +virtualdev -autostartprgmode 2 +autostart-handle-tde +autostart-warp
dotest $EMU $PROGPRE-tde-disk.$PROGEXT    $OPTS -truedrive -virtualdev -autostartprgmode 2 +autostart-handle-tde -autostart-warp
dotest $EMU $PROGPRE-tde-disk.$PROGEXT    $OPTS -truedrive -virtualdev -autostartprgmode 2 +autostart-handle-tde +autostart-warp
dotest $EMU $PROGPRE-none.$PROGEXT        $OPTS +truedrive +virtualdev -autostartprgmode 2 +autostart-handle-tde -autostart-warp
dotest $EMU $PROGPRE-none.$PROGEXT        $OPTS +truedrive +virtualdev -autostartprgmode 2 +autostart-handle-tde +autostart-warp
dotest $EMU $PROGPRE-vdrive-disk.$PROGEXT $OPTS +truedrive -virtualdev -autostartprgmode 2 +autostart-handle-tde -autostart-warp
dotest $EMU $PROGPRE-vdrive-disk.$PROGEXT $OPTS +truedrive -virtualdev -autostartprgmode 2 +autostart-handle-tde +autostart-warp

dotest $EMU $PROGPRE-tde.$PROGEXT         $OPTS -truedrive +virtualdev -autostartprgmode 0 -autostart-handle-tde -autostart-warp
dotest $EMU $PROGPRE-tde.$PROGEXT         $OPTS -truedrive +virtualdev -autostartprgmode 0 -autostart-handle-tde +autostart-warp
dotest $EMU $PROGPRE-tde.$PROGEXT         $OPTS -truedrive -virtualdev -autostartprgmode 0 -autostart-handle-tde -autostart-warp
dotest $EMU $PROGPRE-tde.$PROGEXT         $OPTS -truedrive -virtualdev -autostartprgmode 0 -autostart-handle-tde +autostart-warp
dotest $EMU $PROGPRE-none.$PROGEXT        $OPTS +truedrive +virtualdev -autostartprgmode 0 -autostart-handle-tde -autostart-warp
dotest $EMU $PROGPRE-none.$PROGEXT        $OPTS +truedrive +virtualdev -autostartprgmode 0 -autostart-handle-tde +autostart-warp
dotest $EMU $PROGPRE-vfs.$PROGEXT         $OPTS +truedrive -virtualdev -autostartprgmode 0 -autostart-handle-tde -autostart-warp
dotest $EMU $PROGPRE-vfs.$PROGEXT         $OPTS +truedrive -virtualdev -autostartprgmode 0 -autostart-handle-tde +autostart-warp

dotest $EMU $PROGPRE-tde.$PROGEXT         $OPTS -truedrive +virtualdev -autostartprgmode 1 -autostart-handle-tde -autostart-warp
dotest $EMU $PROGPRE-tde.$PROGEXT         $OPTS -truedrive +virtualdev -autostartprgmode 1 -autostart-handle-tde +autostart-warp
dotest $EMU $PROGPRE-tde.$PROGEXT         $OPTS -truedrive -virtualdev -autostartprgmode 1 -autostart-handle-tde -autostart-warp
dotest $EMU $PROGPRE-tde.$PROGEXT         $OPTS -truedrive -virtualdev -autostartprgmode 1 -autostart-handle-tde +autostart-warp
dotest $EMU $PROGPRE-none.$PROGEXT        $OPTS +truedrive +virtualdev -autostartprgmode 1 -autostart-handle-tde -autostart-warp
dotest $EMU $PROGPRE-none.$PROGEXT        $OPTS +truedrive +virtualdev -autostartprgmode 1 -autostart-handle-tde +autostart-warp
dotest $EMU $PROGPRE-vfs.$PROGEXT         $OPTS +truedrive -virtualdev -autostartprgmode 1 -autostart-handle-tde -autostart-warp
dotest $EMU $PROGPRE-vfs.$PROGEXT         $OPTS +truedrive -virtualdev -autostartprgmode 1 -autostart-handle-tde +autostart-warp

dotest $EMU $PROGPRE-tde-disk.$PROGEXT    $OPTS -truedrive +virtualdev -autostartprgmode 2 -autostart-handle-tde -autostart-warp
dotest $EMU $PROGPRE-tde-disk.$PROGEXT    $OPTS -truedrive +virtualdev -autostartprgmode 2 -autostart-handle-tde +autostart-warp
dotest $EMU $PROGPRE-tde-disk.$PROGEXT    $OPTS -truedrive -virtualdev -autostartprgmode 2 -autostart-handle-tde -autostart-warp
dotest $EMU $PROGPRE-tde-disk.$PROGEXT    $OPTS -truedrive -virtualdev -autostartprgmode 2 -autostart-handle-tde +autostart-warp
dotest $EMU $PROGPRE-none.$PROGEXT        $OPTS +truedrive +virtualdev -autostartprgmode 2 -autostart-handle-tde -autostart-warp
dotest $EMU $PROGPRE-none.$PROGEXT        $OPTS +truedrive +virtualdev -autostartprgmode 2 -autostart-handle-tde +autostart-warp
dotest $EMU $PROGPRE-vdrive-disk.$PROGEXT $OPTS +truedrive -virtualdev -autostartprgmode 2 -autostart-handle-tde -autostart-warp
dotest $EMU $PROGPRE-vdrive-disk.$PROGEXT $OPTS +truedrive -virtualdev -autostartprgmode 2 -autostart-handle-tde +autostart-warp
echo "---"
}

function alltests_disk
{
echo $EMU":"$PROGPRE-X.$PROGEXT
dotest $EMU $PROGPRE-tde-image.$PROGEXT -default $OPTS

# the prg mode should make no difference when we are starting a disk image
# -> the following block repeats 3 times
dotest $EMU $PROGPRE-tde-image.$PROGEXT    $OPTS -truedrive +virtualdev -autostartprgmode 0 +autostart-handle-tde -autostart-warp
dotest $EMU $PROGPRE-tde-image.$PROGEXT    $OPTS -truedrive +virtualdev -autostartprgmode 0 +autostart-handle-tde +autostart-warp
dotest $EMU $PROGPRE-tde-image.$PROGEXT    $OPTS -truedrive -virtualdev -autostartprgmode 0 +autostart-handle-tde -autostart-warp
dotest $EMU $PROGPRE-tde-image.$PROGEXT    $OPTS -truedrive -virtualdev -autostartprgmode 0 +autostart-handle-tde +autostart-warp
dotest $EMU $PROGPRE-none-image.$PROGEXT   $OPTS +truedrive +virtualdev -autostartprgmode 0 +autostart-handle-tde -autostart-warp
dotest $EMU $PROGPRE-none-image.$PROGEXT   $OPTS +truedrive +virtualdev -autostartprgmode 0 +autostart-handle-tde +autostart-warp
dotest $EMU $PROGPRE-vdrive-image.$PROGEXT $OPTS +truedrive -virtualdev -autostartprgmode 0 +autostart-handle-tde -autostart-warp
dotest $EMU $PROGPRE-vdrive-image.$PROGEXT $OPTS +truedrive -virtualdev -autostartprgmode 0 +autostart-handle-tde +autostart-warp

dotest $EMU $PROGPRE-tde-image.$PROGEXT    $OPTS -truedrive +virtualdev -autostartprgmode 1 +autostart-handle-tde -autostart-warp
dotest $EMU $PROGPRE-tde-image.$PROGEXT    $OPTS -truedrive +virtualdev -autostartprgmode 1 +autostart-handle-tde +autostart-warp
dotest $EMU $PROGPRE-tde-image.$PROGEXT    $OPTS -truedrive -virtualdev -autostartprgmode 1 +autostart-handle-tde -autostart-warp
dotest $EMU $PROGPRE-tde-image.$PROGEXT    $OPTS -truedrive -virtualdev -autostartprgmode 1 +autostart-handle-tde +autostart-warp
dotest $EMU $PROGPRE-none-image.$PROGEXT   $OPTS +truedrive +virtualdev -autostartprgmode 1 +autostart-handle-tde -autostart-warp
dotest $EMU $PROGPRE-none-image.$PROGEXT   $OPTS +truedrive +virtualdev -autostartprgmode 1 +autostart-handle-tde +autostart-warp
dotest $EMU $PROGPRE-vdrive-image.$PROGEXT $OPTS +truedrive -virtualdev -autostartprgmode 1 +autostart-handle-tde -autostart-warp
dotest $EMU $PROGPRE-vdrive-image.$PROGEXT $OPTS +truedrive -virtualdev -autostartprgmode 1 +autostart-handle-tde +autostart-warp

dotest $EMU $PROGPRE-tde-image.$PROGEXT    $OPTS -truedrive +virtualdev -autostartprgmode 2 +autostart-handle-tde -autostart-warp
dotest $EMU $PROGPRE-tde-image.$PROGEXT    $OPTS -truedrive +virtualdev -autostartprgmode 2 +autostart-handle-tde +autostart-warp
dotest $EMU $PROGPRE-tde-image.$PROGEXT    $OPTS -truedrive -virtualdev -autostartprgmode 2 +autostart-handle-tde -autostart-warp
dotest $EMU $PROGPRE-tde-image.$PROGEXT    $OPTS -truedrive -virtualdev -autostartprgmode 2 +autostart-handle-tde +autostart-warp
dotest $EMU $PROGPRE-none-image.$PROGEXT   $OPTS +truedrive +virtualdev -autostartprgmode 2 +autostart-handle-tde -autostart-warp
dotest $EMU $PROGPRE-none-image.$PROGEXT   $OPTS +truedrive +virtualdev -autostartprgmode 2 +autostart-handle-tde +autostart-warp
dotest $EMU $PROGPRE-vdrive-image.$PROGEXT $OPTS +truedrive -virtualdev -autostartprgmode 2 +autostart-handle-tde -autostart-warp
dotest $EMU $PROGPRE-vdrive-image.$PROGEXT $OPTS +truedrive -virtualdev -autostartprgmode 2 +autostart-handle-tde +autostart-warp

# "handle tde at autostart" will let autostart disable TDE in favour if virtual devices
# however, this does not change anything in the final state, so again all of the above repeats

dotest $EMU $PROGPRE-tde-image.$PROGEXT    $OPTS -truedrive +virtualdev -autostartprgmode 0 -autostart-handle-tde -autostart-warp
dotest $EMU $PROGPRE-tde-image.$PROGEXT    $OPTS -truedrive +virtualdev -autostartprgmode 0 -autostart-handle-tde +autostart-warp
dotest $EMU $PROGPRE-tde-image.$PROGEXT    $OPTS -truedrive -virtualdev -autostartprgmode 0 -autostart-handle-tde -autostart-warp
dotest $EMU $PROGPRE-tde-image.$PROGEXT    $OPTS -truedrive -virtualdev -autostartprgmode 0 -autostart-handle-tde +autostart-warp
dotest $EMU $PROGPRE-none-image.$PROGEXT   $OPTS +truedrive +virtualdev -autostartprgmode 0 -autostart-handle-tde -autostart-warp
dotest $EMU $PROGPRE-none-image.$PROGEXT   $OPTS +truedrive +virtualdev -autostartprgmode 0 -autostart-handle-tde +autostart-warp
dotest $EMU $PROGPRE-vdrive-image.$PROGEXT $OPTS +truedrive -virtualdev -autostartprgmode 0 -autostart-handle-tde -autostart-warp
dotest $EMU $PROGPRE-vdrive-image.$PROGEXT $OPTS +truedrive -virtualdev -autostartprgmode 0 -autostart-handle-tde +autostart-warp

dotest $EMU $PROGPRE-tde-image.$PROGEXT    $OPTS -truedrive +virtualdev -autostartprgmode 1 -autostart-handle-tde -autostart-warp
dotest $EMU $PROGPRE-tde-image.$PROGEXT    $OPTS -truedrive +virtualdev -autostartprgmode 1 -autostart-handle-tde +autostart-warp
dotest $EMU $PROGPRE-tde-image.$PROGEXT    $OPTS -truedrive -virtualdev -autostartprgmode 1 -autostart-handle-tde -autostart-warp
dotest $EMU $PROGPRE-tde-image.$PROGEXT    $OPTS -truedrive -virtualdev -autostartprgmode 1 -autostart-handle-tde +autostart-warp
dotest $EMU $PROGPRE-none-image.$PROGEXT   $OPTS +truedrive +virtualdev -autostartprgmode 1 -autostart-handle-tde -autostart-warp
dotest $EMU $PROGPRE-none-image.$PROGEXT   $OPTS +truedrive +virtualdev -autostartprgmode 1 -autostart-handle-tde +autostart-warp
dotest $EMU $PROGPRE-vdrive-image.$PROGEXT $OPTS +truedrive -virtualdev -autostartprgmode 1 -autostart-handle-tde -autostart-warp
dotest $EMU $PROGPRE-vdrive-image.$PROGEXT $OPTS +truedrive -virtualdev -autostartprgmode 1 -autostart-handle-tde +autostart-warp

dotest $EMU $PROGPRE-tde-image.$PROGEXT    $OPTS -truedrive +virtualdev -autostartprgmode 2 -autostart-handle-tde -autostart-warp
dotest $EMU $PROGPRE-tde-image.$PROGEXT    $OPTS -truedrive +virtualdev -autostartprgmode 2 -autostart-handle-tde +autostart-warp
dotest $EMU $PROGPRE-tde-image.$PROGEXT    $OPTS -truedrive -virtualdev -autostartprgmode 2 -autostart-handle-tde -autostart-warp
dotest $EMU $PROGPRE-tde-image.$PROGEXT    $OPTS -truedrive -virtualdev -autostartprgmode 2 -autostart-handle-tde +autostart-warp
dotest $EMU $PROGPRE-none-image.$PROGEXT   $OPTS +truedrive +virtualdev -autostartprgmode 2 -autostart-handle-tde -autostart-warp
dotest $EMU $PROGPRE-none-image.$PROGEXT   $OPTS +truedrive +virtualdev -autostartprgmode 2 -autostart-handle-tde +autostart-warp
dotest $EMU $PROGPRE-vdrive-image.$PROGEXT $OPTS +truedrive -virtualdev -autostartprgmode 2 -autostart-handle-tde -autostart-warp
dotest $EMU $PROGPRE-vdrive-image.$PROGEXT $OPTS +truedrive -virtualdev -autostartprgmode 2 -autostart-handle-tde +autostart-warp

echo "---"
}

# x64
function testx64
{
LIMITCYCLES=30000000
EMU=x64
OPTS=-fslongnames
echo "the first four tests fail as expected. TDE enabled, handle TDE disabled and autostartmode 0 can not work."
PROGPRE=./autostart-c64
PROGEXT=prg
alltests_prg
echo "when handling TDE at autostart, all tests pass:"
PROGPRE=./autostart-c64
PROGEXT=d64
#alltests_disk
}

# x64sc
function testx64sc
{
LIMITCYCLES=30000000
EMU=x64sc
OPTS=
echo "the first four tests fail as expected. TDE enabled, handle TDE disabled and autostartmode 0 can not work."
PROGPRE=./autostart-c64
PROGEXT=prg
alltests_prg
echo "when handling TDE at autostart, all tests pass:"
PROGPRE=./autostart-c64
PROGEXT=d64
alltests_disk
}

# x128 (c64 mode)
function testx128
{
LIMITCYCLES=10000000
EMU=x128
OPTS=-go64
echo "the first four tests fail as expected. TDE enabled, handle TDE disabled and autostartmode 0 can not work."
PROG=./selftest/c64-pass.prg
alltests
echo "all tests pass"
PROG=./selftest/c64-pass.d64
alltests

# x128 (VIC)
EMU=x128
OPTS=-40col
echo "the first four tests fail as expected. TDE enabled, handle TDE disabled and autostartmode 0 can not work."
PROG=./selftest/c128-pass.prg
alltests
echo "all tests pass"
PROG=./selftest/c128-pass.d64
alltests

# x128 (VDC)
EMU=x128
OPTS=-80col
echo "the first four tests fail as expected. TDE enabled, handle TDE disabled and autostartmode 0 can not work."
PROG=./selftest/c128-pass.prg
alltests
echo "all tests pass"
PROG=./selftest/c128-pass.d64
alltests
}

# vic20
function testxvic
{
LIMITCYCLES=12000000
EMU=xvic
OPTS="-memory 8k"
echo "the first four tests fail as expected. TDE enabled, handle TDE disabled and autostartmode 0 can not work."
PROG=./selftest/vic20-pass.prg
alltests
echo "all tests pass"
PROG=./selftest/vic20-pass.d64
alltests
}

# x64dtv
function testx64dtv
{
LIMITCYCLES=50000000
EMU=x64dtv
OPTS=
echo "the first four tests fail as expected. TDE enabled, handle TDE disabled and autostartmode 0 can not work."
PROG=./selftest/dtv-pass.prg
alltests
echo "all tests pass"
PROG=./selftest/dtv-pass.d64
alltests
}

# xplus4
function testxplus4
{
LIMITCYCLES=20000000
EMU=xplus4
OPTS=
echo "the first four tests fail as expected. TDE enabled, handle TDE disabled and autostartmode 0 can not work."
PROG=./selftest/plus4-pass.prg
alltests
echo "all tests pass"
PROG=./selftest/plus4-pass.d64
alltests
}

# xpet
function testxpet
{
LIMITCYCLES=20000000
EMU=xpet
OPTS="-drive8type 8250"
echo "the first four tests fail as expected. TDE enabled, handle TDE disabled and autostartmode 0 can not work."
echo "FIXME: the same four tests fail with handle TDE enabled - this should not happen"
PROG=./selftest/pet-pass.prg
alltests
echo "all tests pass"
PROG=./selftest/pet-pass.d82
alltests
}

# xscpu64
function testxscpu64
{
LIMITCYCLES=12000000
EMU=xscpu64
OPTS=
echo "the first four tests fail as expected. TDE enabled, handle TDE disabled and autostartmode 0 can not work."
PROG=./selftest/scpu-pass.prg
alltests
echo "all tests pass"
PROG=./selftest/scpu-pass.d64
alltests
}

# xcbm2
function testxcbm2
{
LIMITCYCLES=80000000
EMU=xcbm2
OPTS="-drive8type 8250"
echo "the first four tests fail as expected. TDE enabled, handle TDE disabled and autostartmode 0 can not work."
echo "FIXME: the same four tests fail with handle TDE enabled - this should not happen"
PROG=./selftest/cbm610-pass.prg
alltests
echo "all tests pass"
PROG=./selftest/cbm610-pass.d82
alltests
}

# xcbm5x0
function testxcbm5x0
{
LIMITCYCLES=80000000
EMU=xcbm5x0
OPTS="-drive8type 8250"
echo "the first four tests fail as expected. TDE enabled, handle TDE disabled and autostartmode 0 can not work."
echo "FIXME: the same four tests fail with handle TDE enabled - this should not happen"
PROG=./selftest/cbm510-pass.prg
alltests
echo "all tests pass"
PROG=./selftest/cbm510-pass.d82
alltests
}

function dohelp
{
    echo "checkautostart.sh <options> <emulator(s)>"
    echo "options:"
    echo " -v --verbose     verbose mode"
    echo "emulators:"
    echo " x64"
    echo " x64sc"
    echo " x64dtv"
    echo " xscpu64"
    echo " x128"
    echo " xvic"
    echo " xplus4"
    echo " xpet"
    echo " xcbm2"
    echo " xcbm5x0"
}

if [ -z "${@:1:1}" ] ; then
    dohelp
    exit
else

if [ "$VICEDIR" == "" ] ; then
    VICEDIR="../../trunk/vice/src/"
fi
echo "using VICE dir:" $VICEDIR

for thisarg in "$@"
do
#    echo "arg:" "$thisarg"
    case "$thisarg" in
        --verbose)
                VERBOSE=1
            ;;
        -v)
                VERBOSE=1
            ;;
        xpet)
                testxpet
            ;;
        xcbm2)
                testxcbm2
            ;;
        xcbm5x0)
                testxcbm5x0
            ;;
        xplus4)
                testxplus4
            ;;
        xscpu64)
                testxscpu64
            ;;
        xvic)
                testxvic
            ;;
        x128)
                testx128
            ;;
        x64sc)
                testx64sc
            ;;
        x64)
                testx64
            ;;
        x64dtv)
                testx64dtv
            ;;
        all) # do all
                testx64sc
                testx64
                testx64dtv
                testxscpu64
                testx128
                testxvic
                testxplus4
                testxpet
                testxcbm2
                testxcbm5x0
            ;;
        *)
                echo "unknown option:" "$thisarg"
                dohelp
                exit
            ;;
    esac

done

fi
