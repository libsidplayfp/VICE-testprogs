#! /bin/bash

SCRIPT_DIR=$(cd $(dirname "${BASH_SOURCE[0]}") && pwd)

if [ -f "$SCRIPT_DIR/Makefile.config" ] ; then
    source $SCRIPT_DIR/Makefile.config
else
    if [ -f "$SCRIPT_DIR/../Makefile.config" ] ; then
        source $SCRIPT_DIR/../Makefile.config
    fi
fi

HEX=hexdump

VERBOSE=0

function checkfile_prg
{
CHECKFILE=`basename "$1"`
CHECKDIR="$2"
TESTDIR="test/prg/$3/$CHECKFILE"

mkdir -p "$TESTDIR" 2> /dev/null > /dev/null

# check the original .crt file
$CARTCONV -c "$CHECKDIR/$CHECKFILE" 2> /dev/null > /dev/null
if [ "$?" = "255" ]; then
    echo -ne "$CHECKDIR/$CHECKFILE: "
    $CARTCONV -c "$CHECKDIR/$CHECKFILE"
    return
fi

# extract the .crt file into .prg file(s)
if [ "$VERBOSE" = "1" ]; then
    echo $CARTCONV -i "$CHECKDIR/$CHECKFILE" -o "$TESTDIR/$CHECKFILE.prg" --options-file "$TESTDIR/$CHECKFILE.txt"
fi
$CARTCONV -t prg -i "$CHECKDIR/$CHECKFILE" -o "$TESTDIR/$CHECKFILE.prg" --options-file "$TESTDIR/$CHECKFILE.txt" 2>&1  > /dev/null

if [ -f "$TESTDIR/$CHECKFILE.prg" ]; then
    IFS=,
    read n1 n2 n3 n4 n5 n6 n7 n8 n9 n10 < "$TESTDIR/$CHECKFILE.txt"
#    echo $CARTCONV "$n1" "$n2" "$n3" "$n4" "$n5" "$n6" "$n7" "$n8" "$n9" "$n10" -o $TESTDIR/$CHECKFILE
    $CARTCONV "$n1" "$n2" "$n3" "$n4" "$n5" "$n6" "$n7" "$n8" "$n9" "$n10" -o $TESTDIR/$CHECKFILE 2>&1 > /dev/null
else
    echo "Error: could not extract" "$TESTDIR/$CHECKFILE.prg"
    echo "------------------------------------"
    return
fi

if [ -f "$CHECKDIR/$CHECKFILE" ] && [ -f "$TESTDIR/$CHECKFILE" ] ; then

    if diff -q "$CHECKDIR/$CHECKFILE" "$TESTDIR/$CHECKFILE" 2> /dev/null > /dev/null; then
    #    echo "ok"
        rm -f "$TESTDIR/$CHECKFILE"
        rm -f "$TESTDIR/$CHECKFILE.txt"
        rm -f "$TESTDIR/$CHECKFILE.prg"
        rmdir "$TESTDIR"
    else
        echo "Failed:" $CHECKFILE "prg -> crt"
#        if [ -f "$CHECKDIR/$CHECKFILE" ] && [ -f "$TESTDIR/$CHECKFILE" ] ; then
            $HEX "$CHECKDIR/$CHECKFILE" > left
            $HEX "$TESTDIR/$CHECKFILE" > right
            diff left right | head
            rm left right
#        fi
    #    $CARTCONV -f "$TESTDIR/$CHECKFILE"
        echo "------------------------------------"
    fi

else
    echo "Error: could not rebuild" "$TESTDIR/$CHECKFILE"
    echo "------------------------------------"
fi

}

function checkfile_bin
{
CHECKFILE=`basename "$1"`
CHECKDIR="$2"
TESTDIR="test/bin/$3/$CHECKFILE"

mkdir -p "$TESTDIR" 2> /dev/null > /dev/null

# check the original .crt file
$CARTCONV -c "$CHECKDIR/$CHECKFILE" 2> /dev/null > /dev/null
if [ "$?" = "255" ]; then
    echo -ne "$CHECKDIR/$CHECKFILE: "
    $CARTCONV -c "$CHECKDIR/$CHECKFILE"
    return
fi


$CARTCONV -t bin -i "$CHECKDIR/$CHECKFILE" -o "$TESTDIR/$CHECKFILE.bin" --options-file "$TESTDIR/$CHECKFILE.txt"  2>&1 > /dev/null

if [ -f "$TESTDIR/$CHECKFILE.bin" ]; then
    IFS=,
    read n1 n2 n3 n4 n5 n6 n7 n8 n9 n10 < "$TESTDIR/$CHECKFILE.txt"
    if [ "$VERBOSE" = "1" ]; then
        echo    $CARTCONV "$n1" "$n2" "$n3" "$n4" "$n5" "$n6" "$n7" "$n8" "$n9" "$n10" -o $TESTDIR/$CHECKFILE
    fi
    $CARTCONV "$n1" "$n2" "$n3" "$n4" "$n5" "$n6" "$n7" "$n8" "$n9" "$n10" -o $TESTDIR/$CHECKFILE 2>&1 > /dev/null
else
    echo "Error: could not extract" "$TESTDIR/$CHECKFILE.bin"
    echo "------------------------------------"
    return
fi

if [ -f "$CHECKDIR/$CHECKFILE" ] && [ -f "$TESTDIR/$CHECKFILE" ] ; then

    if diff -q "$CHECKDIR/$CHECKFILE" "$TESTDIR/$CHECKFILE" 2> /dev/null > /dev/null; then
    #    echo "ok"
        rm -f "$TESTDIR/$CHECKFILE"
        rm -f "$TESTDIR/$CHECKFILE.txt"
        rm -f "$TESTDIR/$CHECKFILE.bin"
        rmdir "$TESTDIR"
    else
        echo "Failed:" $CHECKFILE "bin -> crt"
#        if [ -f "$CHECKDIR/$CHECKFILE" ] && [ -f "$TESTDIR/$CHECKFILE" ] ; then
            $HEX "$CHECKDIR/$CHECKFILE" > left
            $HEX "$TESTDIR/$CHECKFILE" > right
            diff left right | head
            rm left right
#        fi
    #    $CARTCONV -f "$TESTDIR/$CHECKFILE"
        echo "------------------------------------"
    fi

else
    echo "Error: could not rebuild" "$TESTDIR/$CHECKFILE"
    echo "------------------------------------"
fi

}

function checkdir
{
CHECKDIR="$1"

for i in $CHECKDIR/*.crt; do
#echo testing "$i" " "
checkfile_bin "$i" "$1" "$2"
checkfile_prg "$i" "$1" "$2"
#echo "------------------------------------"
done

}

function dohelp
{
    echo "cartconv-test.sh <cartdir> <target> <options>"
    echo "options:"
    echo " -v --verbose     verbose mode"
}

if [ -z "${@:1:1}" ] ; then
    dohelp
    exit
else

if [ "$CARTCONV" == "" ] ; then
    CARTCONV=$SCRIPT_DIR/../../trunk/vice/src/tools/cartconv/cartconv
    if [ -x "$CARTCONV" ] ; then
        echo "Warning: CARTCONV not defined, using "$CARTCONV
    else
        echo "Error: CARTCONV not defined and trunk not found."
        exit -1
    fi
else
    if [ -x "$CARTCONV" ] ; then
        echo "Using VICE dir:" $CARTCONV
    else
        echo "Error: "$CARTCONV" does not exist."
        exit -1
    fi
fi


if [ -d "$1" ] ; then
    TESTDIR=$1
    echo "Directory with testfiles:" $TESTDIR
else
    dohelp
    exit -1
fi

case "$2" in
    c64)
            SYSTEM=c64
        ;;
    vic20)
            SYSTEM=vic20
        ;;
    plus4)
            SYSTEM=plus4
        ;;
    c128)
            SYSTEM=c128
        ;;
    cbm2)
            SYSTEM=cbm2
        ;;
    *)
            echo "Unknown option:" "$2"
            dohelp
            exit
        ;;
esac

for thisarg in "${@:3}"
do
#    echo "arg:" "$thisarg"
    case "$thisarg" in
        --verbose)
                VERBOSE=1
            ;;
        -v)
                VERBOSE=1
            ;;
        *)
                echo "Unknown option:" "$thisarg"
                dohelp
                exit
            ;;
    esac

done

fi

checkdir $TESTDIR $SYSTEM

