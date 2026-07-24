#! /bin/bash
GREEN='\033[1;32m'
RED='\033[1;31m'
NC='\033[0m'

SCRIPT_DIR=$(cd $(dirname "${BASH_SOURCE[0]}") && pwd)

source $SCRIPT_DIR/../Makefile.config

VERBOSE=0

function checkemudir
{
    if [ "$EMUDIR" == "" ] ; then
        EMUDIR=$SCRIPT_DIR/../../../trunk/vice/src/
        if [ -d "$EMUDIR" ] ; then
            echo "warning: EMUDIR not defined, using "$EMUDIR
        else
            echo "error: EMUDIR not defined and trunk not found."
            exit -1
        fi
    else
        if [ -d "$EMUDIR" ] ; then
            echo "using VICE dir:" $EMUDIR
        else
            echo "error: "$EMUDIR" does not exist."
            exit -1
        fi
    fi
}

cd $SCRIPT_DIR;

############################################################################

OPTS="-default -debugcart +confirmonexit -minimized -console --silent +remotemonitor +binarymonitor -nativemonitor -warp --limitcycles 100000000"

function test_c64_prg
{

CMDLINE=(
    '+autostart-handle-tde +trapdevice8 +busdevice8 +drive8truedrive'
    '+autostart-handle-tde +trapdevice8 +busdevice8 -drive8truedrive'
    '+autostart-handle-tde +trapdevice8 -busdevice8 +drive8truedrive'
    '+autostart-handle-tde +trapdevice8 -busdevice8 -drive8truedrive'
    '+autostart-handle-tde -trapdevice8 +busdevice8 +drive8truedrive'
    '+autostart-handle-tde -trapdevice8 +busdevice8 -drive8truedrive'
    '+autostart-handle-tde -trapdevice8 -busdevice8 +drive8truedrive'
    '+autostart-handle-tde -trapdevice8 -busdevice8 -drive8truedrive'

    '-autostart-handle-tde +trapdevice8 +busdevice8 +drive8truedrive'
    '-autostart-handle-tde +trapdevice8 +busdevice8 -drive8truedrive'
    '-autostart-handle-tde +trapdevice8 -busdevice8 +drive8truedrive'
    '-autostart-handle-tde +trapdevice8 -busdevice8 -drive8truedrive'
    '-autostart-handle-tde -trapdevice8 +busdevice8 +drive8truedrive'
    '-autostart-handle-tde -trapdevice8 +busdevice8 -drive8truedrive'
    '-autostart-handle-tde -trapdevice8 -busdevice8 +drive8truedrive'
    '-autostart-handle-tde -trapdevice8 -busdevice8 -drive8truedrive'
)

EXPECTED=(
    '1' # no device (must fail)
    '0'
    '0'
    '0'
    '0'
    '0'
    '0'
    '0'

    '1' # no device (must fail)
    '0'
    '0'
    '0'
    '0'
    '0'
    '0'
    '0'
)

rm -f test.log

n=0
for each in "${CMDLINE[@]}" ; do
    rm -f test1.log
#    echo $n "- " RESUL:"${RESULTS[$n]}"
    echo -ne "* (odd) " "$each"
    echo "* (odd) " "$each" >> test.log
    $EMUDIR/x64sc $OPTS $each drivemem-c64-odd.prg > /dev/null
    ret=$?
#    echo "["$ret"]"

    if [ "$ret" == "0" ]; then
        echo -e " [ "$GREEN"ok"$NC" ] ";
    else
        if [ "${EXPECTED[$n]}" == "1" ]; then
            echo -e " [ "$GREEN"failed - expected"$NC" ] ";
        else
            echo -e " [ "$RED"failed"$NC" ] ";
            echo $EMUDIR/x64sc $OPTS $each drivemem-c64-odd.prg
        fi
    fi

    rm -f test1.log
#    echo $n "- " RESUL:"${RESULTS[$n]}"
    echo -ne "* (even)" "$each"
    echo "* (even)" "$each" >> test.log
    $EMUDIR/x64sc $OPTS $each drivemem-c64-even.prg > /dev/null
    ret=$?
#    echo "["$ret"]"

    if [ "$ret" == "0" ]; then
        echo -e " [ "$GREEN"ok"$NC" ] ";
    else
        if [ "${EXPECTED[$n]}" == "1" ]; then
            echo -e " [ "$GREEN"failed - expected"$NC" ] ";
        else
            echo -e " [ "$RED"failed"$NC" ] ";
            echo $EMUDIR/x64sc $OPTS $each drivemem-c64-even.prg
        fi
    fi

    ((n++))
done

#cat test.log

}

# CAUTION: xvic does NOT support "bus device" yet

function test_vic20_prg
{

CMDLINE=(
    '+autostart-handle-tde +trapdevice8 +busdevice8 +drive8truedrive'
    '+autostart-handle-tde +trapdevice8 +busdevice8 -drive8truedrive'
    '+autostart-handle-tde +trapdevice8 -busdevice8 +drive8truedrive'
    '+autostart-handle-tde +trapdevice8 -busdevice8 -drive8truedrive'
    '+autostart-handle-tde -trapdevice8 +busdevice8 +drive8truedrive'
    '+autostart-handle-tde -trapdevice8 +busdevice8 -drive8truedrive'
    '+autostart-handle-tde -trapdevice8 -busdevice8 +drive8truedrive'
    '+autostart-handle-tde -trapdevice8 -busdevice8 -drive8truedrive'

    '-autostart-handle-tde +trapdevice8 +busdevice8 +drive8truedrive'
    '-autostart-handle-tde +trapdevice8 +busdevice8 -drive8truedrive'
    '-autostart-handle-tde +trapdevice8 -busdevice8 +drive8truedrive'
    '-autostart-handle-tde +trapdevice8 -busdevice8 -drive8truedrive'
    '-autostart-handle-tde -trapdevice8 +busdevice8 +drive8truedrive'
    '-autostart-handle-tde -trapdevice8 +busdevice8 -drive8truedrive'
    '-autostart-handle-tde -trapdevice8 -busdevice8 +drive8truedrive'
    '-autostart-handle-tde -trapdevice8 -busdevice8 -drive8truedrive'
)

EXPECTED=(
    '1' # no device (must fail)
    '0'
    '1' # bus device only (must fail)
    '0'
    '0'
    '0'
    '0'
    '0'

    '1' # no device (must fail)
    '0'
    '1' # bus device only (must fail)
    '0'
    '0'
    '0'
    '0'
    '0'
)

rm -f test.log

n=0
for each in "${CMDLINE[@]}" ; do
    rm -f test1.log
#    echo $n "- " RESUL:"${RESULTS[$n]}"
    echo -ne "* (odd) " "$each"
    echo "* (odd) " "$each" >> test.log
    $EMUDIR/xvic $OPTS $each drivemem-vic20-odd.prg > /dev/null
    ret=$?
#    echo "["$ret"]"

    if [ "$ret" == "0" ]; then
        echo -e " [ "$GREEN"ok"$NC" ] ";
    else
        if [ "${EXPECTED[$n]}" == "1" ]; then
            echo -e " [ "$GREEN"failed - expected"$NC" ] ";
        else
            echo -e " [ "$RED"failed"$NC" ] ";
            echo $EMUDIR/xvic $OPTS $each drivemem-vic20-odd.prg
        fi
    fi

    rm -f test1.log
#    echo $n "- " RESUL:"${RESULTS[$n]}"
    echo -ne "* (even)" "$each"
    echo "* (even)" "$each" >> test.log
    $EMUDIR/xvic $OPTS $each drivemem-vic20-even.prg > /dev/null
    ret=$?
#    echo "["$ret"]"

    if [ "$ret" == "0" ]; then
        echo -e " [ "$GREEN"ok"$NC" ] ";
    else
        if [ "${EXPECTED[$n]}" == "1" ]; then
            echo -e " [ "$GREEN"failed - expected"$NC" ] ";
        else
            echo -e " [ "$RED"failed"$NC" ] ";
            echo $EMUDIR/xvic $OPTS $each drivemem-vic20-even.prg
        fi
    fi

    ((n++))
done

#cat test.log

}

# CAUTION: xpet does NOT support "trap device" yet

function test_pet_prg
{

CMDLINE=(
    '+autostart-handle-tde +trapdevice8 +busdevice8 +drive8truedrive'
    '+autostart-handle-tde +trapdevice8 +busdevice8 -drive8truedrive'
    '+autostart-handle-tde +trapdevice8 -busdevice8 +drive8truedrive'
    '+autostart-handle-tde +trapdevice8 -busdevice8 -drive8truedrive'
    '+autostart-handle-tde -trapdevice8 +busdevice8 +drive8truedrive'
    '+autostart-handle-tde -trapdevice8 +busdevice8 -drive8truedrive'
    '+autostart-handle-tde -trapdevice8 -busdevice8 +drive8truedrive'
    '+autostart-handle-tde -trapdevice8 -busdevice8 -drive8truedrive'

    '-autostart-handle-tde +trapdevice8 +busdevice8 +drive8truedrive'
    '-autostart-handle-tde +trapdevice8 +busdevice8 -drive8truedrive'
    '-autostart-handle-tde +trapdevice8 -busdevice8 +drive8truedrive'
    '-autostart-handle-tde +trapdevice8 -busdevice8 -drive8truedrive'
    '-autostart-handle-tde -trapdevice8 +busdevice8 +drive8truedrive'
    '-autostart-handle-tde -trapdevice8 +busdevice8 -drive8truedrive'
    '-autostart-handle-tde -trapdevice8 -busdevice8 +drive8truedrive'
    '-autostart-handle-tde -trapdevice8 -busdevice8 -drive8truedrive'
)

EXPECTED=(
    '1' # no device (must fail)
    '0'
    '0'
    '0'
    '1' # trap device only (must fail)
    '0'
    '0'
    '0'

    '1' # no device (must fail)
    '0'
    '0'
    '0'
    '1' # trap device only (must fail)
    '0'
    '0'
    '0'
)

rm -f test.log

n=0
for each in "${CMDLINE[@]}" ; do
    rm -f test1.log
#    echo $n "- " RESUL:"${RESULTS[$n]}"
    echo -ne "* (odd) " "$each"
    echo "* (odd) " "$each" >> test.log
    $EMUDIR/xpet $OPTS $each drivemem-pet-odd.prg > /dev/null
    ret=$?
#    echo "["$ret"]"

    if [ "$ret" == "0" ]; then
        echo -e " [ "$GREEN"ok"$NC" ] ";
    else
        if [ "${EXPECTED[$n]}" == "1" ]; then
            echo -e " [ "$GREEN"failed - expected"$NC" ] ";
        else
            echo -e " [ "$RED"failed"$NC" ] ";
            echo $EMUDIR/xpet $OPTS $each drivemem-pet-odd.prg
        fi
    fi

    rm -f test1.log
#    echo $n "- " RESUL:"${RESULTS[$n]}"
    echo -ne "* (even)" "$each"
    echo "* (even)" "$each" >> test.log
    $EMUDIR/xpet $OPTS $each drivemem-pet-even.prg > /dev/null
    ret=$?
#    echo "["$ret"]"

    if [ "$ret" == "0" ]; then
        echo -e " [ "$GREEN"ok"$NC" ] ";
    else
        if [ "${EXPECTED[$n]}" == "1" ]; then
            echo -e " [ "$GREEN"failed - expected"$NC" ] ";
        else
            echo -e " [ "$RED"failed"$NC" ] ";
            echo $EMUDIR/xpet $OPTS $each drivemem-pet-even.prg
        fi
    fi

    ((n++))
done

#cat test.log

}

function test_plus4_prg
{

CMDLINE=(
    '+autostart-handle-tde +trapdevice8 +busdevice8 +drive8truedrive'
    '+autostart-handle-tde +trapdevice8 +busdevice8 -drive8truedrive'
    '+autostart-handle-tde +trapdevice8 -busdevice8 +drive8truedrive'
    '+autostart-handle-tde +trapdevice8 -busdevice8 -drive8truedrive'
    '+autostart-handle-tde -trapdevice8 +busdevice8 +drive8truedrive'
    '+autostart-handle-tde -trapdevice8 +busdevice8 -drive8truedrive'
    '+autostart-handle-tde -trapdevice8 -busdevice8 +drive8truedrive'
    '+autostart-handle-tde -trapdevice8 -busdevice8 -drive8truedrive'

    '-autostart-handle-tde +trapdevice8 +busdevice8 +drive8truedrive'
    '-autostart-handle-tde +trapdevice8 +busdevice8 -drive8truedrive'
    '-autostart-handle-tde +trapdevice8 -busdevice8 +drive8truedrive'
    '-autostart-handle-tde +trapdevice8 -busdevice8 -drive8truedrive'
    '-autostart-handle-tde -trapdevice8 +busdevice8 +drive8truedrive'
    '-autostart-handle-tde -trapdevice8 +busdevice8 -drive8truedrive'
    '-autostart-handle-tde -trapdevice8 -busdevice8 +drive8truedrive'
    '-autostart-handle-tde -trapdevice8 -busdevice8 -drive8truedrive'
)

EXPECTED=(
    '1' # no device (must fail)
    '0'
    '0'
    '0'
    '0'
    '0'
    '0'
    '0'

    '1' # no device (must fail)
    '0'
    '0'
    '0'
    '0'
    '0'
    '0'
    '0'
)

rm -f test.log

n=0
for each in "${CMDLINE[@]}" ; do
    rm -f test1.log
#    echo $n "- " RESUL:"${RESULTS[$n]}"
    echo -ne "* (odd) " "$each"
    echo "* (odd) " "$each" >> test.log
    $EMUDIR/xplus4 $OPTS $each drivemem-plus4-odd.prg > /dev/null
    ret=$?
#    echo "["$ret"]"

    if [ "$ret" == "0" ]; then
        echo -e " [ "$GREEN"ok"$NC" ] ";
    else
        if [ "${EXPECTED[$n]}" == "1" ]; then
            echo -e " [ "$GREEN"failed - expected"$NC" ] ";
        else
            echo -e " [ "$RED"failed"$NC" ] ";
            echo $EMUDIR/xplus4 $OPTS $each drivemem-plus4-odd.prg
        fi
    fi

    rm -f test1.log
#    echo $n "- " RESUL:"${RESULTS[$n]}"
    echo -ne "* (even)" "$each"
    echo "* (even)" "$each" >> test.log
    $EMUDIR/xplus4 $OPTS $each drivemem-plus4-even.prg > /dev/null
    ret=$?
#    echo "["$ret"]"

    if [ "$ret" == "0" ]; then
        echo -e " [ "$GREEN"ok"$NC" ] ";
    else
        if [ "${EXPECTED[$n]}" == "1" ]; then
            echo -e " [ "$GREEN"failed - expected"$NC" ] ";
        else
            echo -e " [ "$RED"failed"$NC" ] ";
            echo $EMUDIR/xplus4 $OPTS $each drivemem-plus4-even.prg
        fi
    fi

    ((n++))
done

#cat test.log

}

function testx64sc
{
echo "c64 (prg)"
test_c64_prg
}

function testxvic
{
echo "vic20 (prg)"
test_vic20_prg
}

function testxpet
{
echo "pet (prg)"
test_pet_prg
}

function testxplus4
{
echo "plus4 (prg)"
test_plus4_prg
}

function dohelp
{
    echo "autostart-drivemem.sh <options> <emulator(s)>"
    echo "options:"
    echo " -v --verbose     verbose mode"
    echo "emulators:"
    echo " all"
#    echo " x64"
    echo " x64sc"
#    echo " x64dtv"
#    echo " xscpu64"
#    echo " x128"
    echo " xvic"
    echo " xplus4"
    echo " xpet"
#    echo " xcbm2"
#    echo " xcbm5x0"
}

function cleanup
{
rm -f test.ref
rm -f test1.log
rm -f test2.log
}

if [ -z "${@:1:1}" ] ; then
    dohelp
    exit
else

rm -f test.log

echo "checking drive memory after autostart:"

checkemudir

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
#        xcbm2)
#                testxcbm2
#            ;;
#        xcbm5x0)
#                testxcbm5x0
#            ;;
        xplus4)
                testxplus4
            ;;
#        xscpu64)
#                testxscpu64
#            ;;
        xvic)
                testxvic
            ;;
#        x128)
#                testx128
#            ;;
        x64sc)
                testx64sc
            ;;
#        x64)
#                testx64
#            ;;
#        x64dtv)
#                testx64dtv
#            ;;
        all) # do all
                testx64sc
                testxvic
                testxpet
                testxplus4

#                testx64
#                testx64dtv
#                testxscpu64
#                testx128
#                testxcbm2
#                testxcbm5x0
            ;;
        *)
                echo "unknown option:" "$thisarg"
                dohelp
                exit
            ;;
    esac

done

cleanup

fi
