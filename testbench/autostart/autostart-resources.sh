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

OPTS="-default -debugcart +confirmonexit -minimized -console --silent +remotemonitor +binarymonitor -nativemonitor -warp --limitcycles 20000000"

function makeref0
{
echo "AutostartHandleTrueDriveEmulation=0" > test.ref
echo "TrapDevice8="$1 >> test.ref
echo "BusDevice8="$2 >> test.ref
echo "Drive8TrueEmulation="$3 >> test.ref
echo "AutostartHandleTrueDriveEmulation=0" >> test.ref
echo "TrapDevice8="$4 >> test.ref
echo "BusDevice8="$5 >> test.ref
echo "Drive8TrueEmulation="$6 >> test.ref
echo "AutostartHandleTrueDriveEmulation=0" >> test.ref
echo "TrapDevice8="$7 >> test.ref
echo "BusDevice8="$8 >> test.ref
echo "Drive8TrueEmulation="$9 >> test.ref
}

function makeref0fail
{
echo "AutostartHandleTrueDriveEmulation=0" > test.ref
echo "TrapDevice8="$1 >> test.ref
echo "BusDevice8="$2 >> test.ref
echo "Drive8TrueEmulation="$3 >> test.ref
echo "AutostartHandleTrueDriveEmulation=0" >> test.ref
echo "TrapDevice8="$4 >> test.ref
echo "BusDevice8="$5 >> test.ref
echo "Drive8TrueEmulation="$6 >> test.ref
#echo "AutostartHandleTrueDriveEmulation=0" >> test.ref
#echo "TrapDevice8="$7 >> test.ref
#echo "BusDevice8="$8 >> test.ref
#echo "Drive8TrueEmulation="$9 >> test.ref
}

function makeref1
{
echo "AutostartHandleTrueDriveEmulation=1" > test.ref
echo "TrapDevice8="$1 >> test.ref
echo "BusDevice8="$2 >> test.ref
echo "Drive8TrueEmulation="$3 >> test.ref
echo "AutostartHandleTrueDriveEmulation=1" >> test.ref
echo "TrapDevice8="$4 >> test.ref
echo "BusDevice8="$5 >> test.ref
echo "Drive8TrueEmulation="$6 >> test.ref
echo "AutostartHandleTrueDriveEmulation=1" >> test.ref
echo "TrapDevice8="$7 >> test.ref
echo "BusDevice8="$8 >> test.ref
echo "Drive8TrueEmulation="$9 >> test.ref
}

function makeref1fail
{
echo "AutostartHandleTrueDriveEmulation=1" > test.ref
echo "TrapDevice8="$1 >> test.ref
echo "BusDevice8="$2 >> test.ref
echo "Drive8TrueEmulation="$3 >> test.ref
echo "AutostartHandleTrueDriveEmulation=1" >> test.ref
echo "TrapDevice8="$4 >> test.ref
echo "BusDevice8="$5 >> test.ref
echo "Drive8TrueEmulation="$6 >> test.ref
#echo "AutostartHandleTrueDriveEmulation=1" >> test.ref
#echo "TrapDevice8="$7 >> test.ref
#echo "BusDevice8="$8 >> test.ref
#echo "Drive8TrueEmulation="$9 >> test.ref
}

############################################################################

function test_c64_disk_not_handle_tde
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
)

RESULTS=(
    '0 0 0  0 0 0  0 0 0'
    '0 0 1  0 0 1  0 0 1'
    '0 1 0  0 1 0  0 1 0'
    '0 1 1  0 1 1  0 1 1'
    '1 0 0  1 0 0  1 0 0'
    '1 0 1  1 0 1  1 0 1'
    '1 1 0  1 1 0  1 1 0'
    '1 1 1  1 1 1  1 1 1'
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
)

rm -f test.log

n=0
for each in "${CMDLINE[@]}" ; do
    rm -f test1.log
#    echo $n "- " RESUL:"${RESULTS[$n]}"
    echo -ne "* " "$each"
    echo "* " "$each" >> test.log
    $EMUDIR/x64sc $OPTS $each -moncommands resources-c64-disk.mon autostart-c64-tde.d64 > /dev/null
    ret=$?
#    echo "["$ret"]"

    # extract logged results
    grep '=' test1.log  > test2.log

    # make a reference
    if [ "${EXPECTED[$n]}" == "1" ]; then
        makeref0fail ${RESULTS[$n]}
    else
        makeref0 ${RESULTS[$n]}
    fi

    if ! diff -q test.ref test2.log &>/dev/null; then
        echo -e " [ "$RED"failed"$NC" ] ";
        cat test2.log
        echo "-ref:"
        cat test.ref
#       echo $EMUDIR/x64sc $OPTS $each -moncommands resources-c64-disk.mon autostart-c64-tde.d64
    else
        if [ "${EXPECTED[$n]}" == "1" ]; then
            echo -e " [ "$GREEN"failed - expected"$NC" ] ";
        else
            echo -e " [ "$GREEN"ok"$NC" ] ";
        fi

    fi

    cat test2.log >> test.log
#    rm test1.log
    ((n++))
done

#cat test.log

}

function test_c64_disk_handle_tde
{

CMDLINE=(
    '-autostart-handle-tde +trapdevice8 +busdevice8 +drive8truedrive' # no device (must fail)
    '-autostart-handle-tde +trapdevice8 +busdevice8 -drive8truedrive'
    '-autostart-handle-tde +trapdevice8 -busdevice8 +drive8truedrive' # only bus device
    '-autostart-handle-tde +trapdevice8 -busdevice8 -drive8truedrive' # tde + bus device
    '-autostart-handle-tde -trapdevice8 +busdevice8 +drive8truedrive'
    '-autostart-handle-tde -trapdevice8 +busdevice8 -drive8truedrive' # tde + trap device
    '-autostart-handle-tde -trapdevice8 -busdevice8 +drive8truedrive'
    '-autostart-handle-tde -trapdevice8 -busdevice8 -drive8truedrive'
)

# 1st and second row are the same?
# -> no? if TDE enabled in final config, ONLY TDE is enabled in the "reset" config (2nd)

RESULTS=(
    '1 0 0  1 0 0  0 0 0' # no device (use traps)
    '0 0 1  0 0 1  0 0 1'
    '0 1 0  0 1 0  0 1 0'
    '0 1 1  0 1 1  0 1 1' # tde + bus device
    '1 0 0  1 0 0  1 0 0'
    '1 0 1  1 0 1  1 0 1' # tde + trap device
    '1 1 0  1 1 0  1 1 0'
    '1 1 1  1 1 1  1 1 1'
)

rm test.log

n=0
for each in "${CMDLINE[@]}" ; do
    rm -f test1.log
#    echo $n "- " RESUL:"${RESULTS[$n]}"
    echo -ne "* " "$each"
    echo "* " "$each" >> test.log
    $EMUDIR/x64sc $OPTS $each -moncommands resources-c64-disk.mon autostart-c64-tde.d64 > /dev/null
    ret=$?

    # extract logged results
    grep '=' test1.log  > test2.log
    # make a reference
    makeref1 ${RESULTS[$n]}

    if ! diff -q test.ref test2.log &>/dev/null; then
        echo -e " [ "$RED"failed"$NC" ] ";
        cat test2.log
        echo "-ref:"
        cat test.ref
    else
        echo -e " [ "$GREEN"ok"$NC" ] ";
#        cat test2.log
    fi

    cat test2.log >> test.log
#    rm test1.log
    ((n++))
done

#cat test.log

}

###########################################################################

function test_vic20_disk_not_handle_tde
{

# CAUTION: xvic does NOT support "bus device" yet

CMDLINE=(
    '+autostart-handle-tde +trapdevice8 +busdevice8 +drive8truedrive' # no device (must fail)
    '+autostart-handle-tde +trapdevice8 +busdevice8 -drive8truedrive'
    '+autostart-handle-tde +trapdevice8 -busdevice8 +drive8truedrive' # only bus device
    '+autostart-handle-tde +trapdevice8 -busdevice8 -drive8truedrive'
    '+autostart-handle-tde -trapdevice8 +busdevice8 +drive8truedrive'
    '+autostart-handle-tde -trapdevice8 +busdevice8 -drive8truedrive'
    '+autostart-handle-tde -trapdevice8 -busdevice8 +drive8truedrive'
    '+autostart-handle-tde -trapdevice8 -busdevice8 -drive8truedrive'
)

RESULTS=(
    '0 0 0  0 0 0  0 0 0' # no device (must fail)
    '0 0 1  0 0 1  0 0 1'
    '0 0 0  0 0 0  0 0 0' # only bus device (expected failure)
    '0 0 1  0 0 1  0 0 1'
    '1 0 0  1 0 0  1 0 0'
    '1 0 1  1 0 1  1 0 1'
    '1 0 0  1 0 0  1 0 0'
    '1 0 1  1 0 1  1 0 1'
)

EXPECTED=(
    '1' # no device (must fail)
    '0'
    '1' # only bus device (expected failure)
    '0'
    '0'
    '0'
    '0'
    '0'
)

#rm test.log

n=0
for each in "${CMDLINE[@]}" ; do
    rm -f test1.log test2.log
#    echo $n "- " RESUL:"${RESULTS[$n]}"
    echo -ne "* " "$each"
    echo "* " "$each" >> test.log
    $EMUDIR/xvic $OPTS $each -moncommands resources-vic20-disk.mon autostart-vic20-tde.d64 > /dev/null
    ret=$?

    # extract logged results
    grep '=' test1.log  > test2.log

    # make a reference
    if [ "${EXPECTED[$n]}" == "1" ]; then
        makeref0fail ${RESULTS[$n]}
    else
        makeref0 ${RESULTS[$n]}
    fi

    if ! diff -q test.ref test2.log &>/dev/null; then
        echo -e " [ "$RED"failed"$NC" ] ";
        cat test2.log
        echo "-ref:"
        cat test.ref
    else
        if [ "${EXPECTED[$n]}" == "1" ]; then
            echo -e " [ "$GREEN"failed - expected"$NC" ] ";
        else
            echo -e " [ "$GREEN"ok"$NC" ] ";
        fi
    fi

    cat test2.log >> test.log
#    rm test1.log
    ((n++))
done

#cat test.log

}

# CAUTION: xvic does NOT support "bus device" yet

function test_vic20_disk_handle_tde
{

CMDLINE=(
    '-autostart-handle-tde +trapdevice8 +busdevice8 +drive8truedrive'   # no device
    '-autostart-handle-tde +trapdevice8 +busdevice8 -drive8truedrive'
    '-autostart-handle-tde +trapdevice8 -busdevice8 +drive8truedrive'   # only bus device
    '-autostart-handle-tde +trapdevice8 -busdevice8 -drive8truedrive'   # bus device + tde
    '-autostart-handle-tde -trapdevice8 +busdevice8 +drive8truedrive'
    '-autostart-handle-tde -trapdevice8 +busdevice8 -drive8truedrive'
    '-autostart-handle-tde -trapdevice8 -busdevice8 +drive8truedrive'
    '-autostart-handle-tde -trapdevice8 -busdevice8 -drive8truedrive'   # bus, trap, tde
)

# 1st and second row are the same?
# if TDE enabled in final config, ONLY TDE is enabled in the "reset" config (2nd)

RESULTS=(
    '1 0 0  1 0 0  0 0 0'   # no device (use traps for autostart)
    '0 0 1  0 0 1  0 0 1'
    '1 0 0  1 0 0  0 0 0'   # only bus device (use traps for autostart)
    '0 0 1  0 0 1  0 0 1'   # bus device + tde
    '1 0 0  1 0 0  1 0 0'
    '1 0 1  1 0 1  1 0 1'   # traps, tde
    '1 0 0  1 0 0  1 0 0'   # traps
    '1 0 1  1 0 1  1 0 1'   # bus, trap, tde (use traps for autostart)
)

#rm test.log

n=0
for each in "${CMDLINE[@]}" ; do
#    echo $n "- " RESUL:"${RESULTS[$n]}"
    rm -f test1.log test2.log
    echo -ne "* " "$each"
    echo "* " "$each" >> test.log
    $EMUDIR/xvic $OPTS $each -moncommands resources-vic20-disk.mon autostart-vic20-tde.d64 > /dev/null
    ret=$?

    # extract logged results
    grep '=' test1.log  > test2.log

    # make a reference
#    if [ "${EXPECTED[$n]}" == "1" ]; then
#        makeref1fail ${RESULTS[$n]}
#    else
        makeref1 ${RESULTS[$n]}
#    fi

    if ! diff -q test.ref test2.log &>/dev/null; then
        echo -e " [ "$RED"failed"$NC" ] ";
        cat test2.log
        echo "-ref:"
        cat test.ref
    else
        echo -e " [ "$GREEN"ok"$NC" ] ";
#        cat test2.log
    fi

    cat test2.log >> test.log
#    rm test1.log
    ((n++))
done

#cat test.log

}

###########################################################################

function test_pet_disk_not_handle_tde
{

# CAUTION: xpet does NOT support "trap device" yet

CMDLINE=(
    '+autostart-handle-tde +trapdevice8 +busdevice8 +drive8truedrive' # no device (must fail)
    '+autostart-handle-tde +trapdevice8 +busdevice8 -drive8truedrive'
    '+autostart-handle-tde +trapdevice8 -busdevice8 +drive8truedrive' # only bus device
    '+autostart-handle-tde +trapdevice8 -busdevice8 -drive8truedrive'
    '+autostart-handle-tde -trapdevice8 +busdevice8 +drive8truedrive' # only trap device
    '+autostart-handle-tde -trapdevice8 +busdevice8 -drive8truedrive'
    '+autostart-handle-tde -trapdevice8 -busdevice8 +drive8truedrive'
    '+autostart-handle-tde -trapdevice8 -busdevice8 -drive8truedrive'
)

RESULTS=(
    '0 0 0  0 0 0  0 0 0' # no device (must fail)
    '0 0 1  0 0 1  0 0 1'
    '0 1 0  0 1 0  0 1 0'
    '0 1 1  0 1 1  0 1 1'
    '0 0 0  0 0 0  0 0 0' # only trap device (expected failure)
    '0 0 1  0 0 1  0 0 1'
    '0 1 0  0 1 0  0 1 0'
    '0 1 1  0 1 1  0 1 1'
)

EXPECTED=(
    '1' # no device (must fail)
    '0'
    '0' # only bus device (expected failure)
    '0'
    '1' # only trap device (expected failure)
    '0'
    '0'
    '0'
)

#rm test.log

n=0
for each in "${CMDLINE[@]}" ; do
    rm -f test1.log test2.log
#    echo $n "- " RESUL:"${RESULTS[$n]}"
    echo -ne "* " "$each"
    echo "* " "$each" >> test.log
    $EMUDIR/xpet $OPTS $each -moncommands resources-pet-disk.mon autostart-pet-tde.d82 > /dev/null
    ret=$?
#    echo "["$ret"]"

    # extract logged results
    grep '=' test1.log  > test2.log

    # make a reference
    if [ "${EXPECTED[$n]}" == "1" ]; then
        makeref0fail ${RESULTS[$n]}
    else
        makeref0 ${RESULTS[$n]}
    fi

    if ! diff -q test.ref test2.log &>/dev/null; then
        echo -e " [ "$RED"failed"$NC" ] ";
        cat test2.log
        echo "-ref:"
        cat test.ref
    else
        if [ "${EXPECTED[$n]}" == "1" ]; then
            echo -e " [ "$GREEN"failed - expected"$NC" ] ";
        else
            echo -e " [ "$GREEN"ok"$NC" ] ";
        fi
    fi

    cat test2.log >> test.log
#    rm test1.log
    ((n++))
done

#cat test.log

}

# CAUTION: xpet does NOT support "trap device" yet

function test_pet_disk_handle_tde
{

CMDLINE=(
    '-autostart-handle-tde +trapdevice8 +busdevice8 +drive8truedrive'   # no device
    '-autostart-handle-tde +trapdevice8 +busdevice8 -drive8truedrive'   # tde
    '-autostart-handle-tde +trapdevice8 -busdevice8 +drive8truedrive'
    '-autostart-handle-tde +trapdevice8 -busdevice8 -drive8truedrive'   # bus + tde
    '-autostart-handle-tde -trapdevice8 +busdevice8 +drive8truedrive'   # only trap device
    '-autostart-handle-tde -trapdevice8 +busdevice8 -drive8truedrive'   # trap device + tde
    '-autostart-handle-tde -trapdevice8 -busdevice8 +drive8truedrive'
    '-autostart-handle-tde -trapdevice8 -busdevice8 -drive8truedrive'   # bus, trap, tde
)

# 1st and second row are the same?
# if TDE enabled in final config, ONLY TDE is enabled in the "reset" config (2nd)


RESULTS=(
# HACKHACK: currently for PET, enabling bus device also enables TDE in the autostart sequence
#   '0 1 1  0 1 1  0 0 0'   # no device (use bus device for autostart)
    '0 1 0  0 1 0  0 0 0'   # no device (use bus device for autostart)
    '0 0 1  0 0 1  0 0 1'
    '0 1 0  0 1 0  0 1 0'   # only bus device
    '0 1 1  0 1 1  0 1 1'
# HACKHACK: currently for PET, enabling bus device also enables TDE in the autostart sequence
#   '0 1 1  0 1 1  0 0 0'   # only trap device (use bus device for autostart)
    '0 1 0  0 1 0  0 0 0'   # only trap device (use bus device for autostart)
    '0 0 1  0 0 1  0 0 1'   # trap device + tde
    '0 1 0  0 1 0  0 1 0'
    '0 1 1  0 1 1  0 1 1'   # bus, trap, tde (use bus device for autostart)
)

#rm test.log

n=0
for each in "${CMDLINE[@]}" ; do
#    echo $n "- " RESUL:"${RESULTS[$n]}"
    rm -f test1.log test2.log
    echo -ne "* " "$each"
    echo "* " "$each" >> test.log
    $EMUDIR/xpet $OPTS $each -moncommands resources-pet-disk.mon autostart-pet-tde.d82 > /dev/null
    ret=$?
#   echo "["$ret"]"

    # extract logged results
    grep '=' test1.log  > test2.log

    # make a reference
#    if [ "${EXPECTED[$n]}" == "1" ]; then
#        makeref1fail ${RESULTS[$n]}
#    else
        makeref1 ${RESULTS[$n]}
#    fi

    if ! diff -q test.ref test2.log &>/dev/null; then
        echo -e " [ "$RED"failed"$NC" ] ";
        cat test2.log
        echo "-ref:"
        cat test.ref
        echo $EMUDIR/xpet $OPTS $each -moncommands resources-pet-disk.mon autostart-pet-tde.d82
    else
        echo -e " [ "$GREEN"ok"$NC" ] ";
#        cat test2.log
    fi

    cat test2.log >> test.log
#    rm test1.log
    ((n++))
done

#cat test.log

}

function cleanup
{
rm -f test.ref
rm -f test1.log
rm -f test2.log
}


function testx64sc
{
echo "c64 (d64)"
test_c64_disk_not_handle_tde
test_c64_disk_handle_tde
}

function testxvic
{
echo "vic20 (d64)"
test_vic20_disk_not_handle_tde
test_vic20_disk_handle_tde
}

function testxpet
{
echo "pet (d64)"
test_pet_disk_not_handle_tde
test_pet_disk_handle_tde
}

function dohelp
{
    echo "autostart-resources.sh <options> <emulator(s)>"
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
#    echo " xplus4"
    echo " xpet"
#    echo " xcbm2"
#    echo " xcbm5x0"
}

if [ -z "${@:1:1}" ] ; then
    dohelp
    exit
else

echo "checking drive related resources before and during autostart:"

rm -f test.log

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
#        xplus4)
#                testxplus4
#            ;;
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
#                testxplus4

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
