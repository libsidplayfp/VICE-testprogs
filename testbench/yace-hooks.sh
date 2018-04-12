
#YACEOPTS+=" -default"
#YACEOPTS+=" -VICIIfilter 0"
#YACEOPTS+=" -VICIIextpal"
#YACEOPTS+=" -VICIIpalette pepto-pal.vpl"
YACEOPTS+=" -test"
#YACEOPTS+=" -window" # opens a preview window
YACEOPTS+=" -warp" # sets emulator speed to max
YACEOPTS+=" -silent" # don't show output
#YACEOPTS+=" -debugcart" # not need, only active in YACETest.exe
#YACEOPTS+=" -console"   # not need, YACETest.exe is already console application

# extra options for the different ways tests can be run
#YACEOPTSEXITCODE+=" -console"
YACEOPTSSCREENSHOT+=""

# X and Y offsets for saved screenshots. when saving a screenshot in the
# computers reset/startup screen, the offset gives the top left pixel of the
# top left character on screen.
#
# for PAL use  32x35
# for NTSC use 32x23
YACESXO=32
YACESYO=35

# the same for the reference screenshots
YACEREFSXO=32
YACEREFSYO=35

function yace_check_environment
{
    if [ `uname` == "Linux" ]
    then
        if ! [ -x "$(command -v wine)" ]; then
            echo 'Error: wine not installed.' >&2
            exit 1
        fi
        export WINEDEBUG=-all
        YACE="wine"
        YACE+=" $EMUDIR"YACE64Windows.exe
    else
        YACE="$EMUDIR"YACE64Windows.exe
    fi

    # is this correct?
    emu_default_videosubtype="6569"
}

# $1  option
# $2  test path
function yace_get_options
{
#    echo yace_get_options "$1" "$2"
    exitoptions=""
    case "$1" in
        "default")
                exitoptions=""
            ;;
        "vicii-pal")
                exitoptions="-pal"
                testprogvideotype="PAL"
            ;;
        "vicii-ntsc")
                exitoptions="-ntsc"
                testprogvideotype="NTSC"
            ;;
#        "vicii-ntscold")
#                exitoptions="-ntscold" # not supported by yace
#            ;;
#        "cia-old")
#                exitoptions="-ciamodel 0" # not supported by yace
#                new_cia_enabled=0
#            ;;
#        "cia-new")
#                exitoptions="-ciamodel 1" # not supported by yace
#                new_cia_enabled=1
#            ;;
#        "sid-old")
#                exitoptions="-sidenginemodel 256" # ??? should always be the old one
#                new_sid_enabled=0
#            ;;
#        "sid-new")
#                exitoptions="-sidenginemodel 257" # not supported by yace
#                new_sid_enabled=1
#            ;;
        "reu512k")
                exitoptions="-reu 512"
                reu_enabled=1
            ;;
#        "geo256k")
#                exitoptions="-georam -georamsize 256" # not supported by yace
#                georam_enabled=1
#            ;;
        *)
                exitoptions=""
                if [ "${1:0:9}" == "mountd64:" ]; then # d64 supported by yace, but currently not by YACETest.exe
                    exitoptions="-8 $2/${1:9}"
                    echo -ne "(disk:${1:9}) "
                fi
                if [ "${1:0:9}" == "mountg64:" ]; then # g64 supported by yace, but currently not by YACETest.exe
                    exitoptions="-8 $2/${1:9}"
                    echo -ne "(disk:${1:9}) "
                fi
                if [ "${1:0:9}" == "mountcrt:" ]; then # crt supported by yace, but currently not by YACETest.exe
                    exitoptions="-cartcrt $2/${1:9}"
                    echo -ne "(cartridge:${1:9}) "
                fi
            ;;
    esac
}


# $1  option
# $2  test path
function yace_get_cmdline_options
{
#    echo yace_get_cmdline_options "$1" "$2"
    exitoptions=""
    case "$1" in
        "PAL")
                exitoptions="-pal"
            ;;
        "NTSC")
                exitoptions="-ntsc"
            ;;
#        "NTSCOLD")
#                exitoptions="-ntscold" # not supported by yace
#            ;;
#        "8565") # "new" PAL
#                exitoptions="-VICIImodel 8565" # not supported by yace
#            ;;
#        "8562") # "new" NTSC
#                exitoptions="-VICIImodel 8562" # not supported by yace
#            ;;
    esac
}

################################################################################
# reset
# run test program
# exit when write to $d7ff occurs - the value written determines success (=$00) or fail (=$ff)
# exit after $timeout cycles (exitcode=$01)
# save a screenshot at exit - success or failure is determined by comparing screenshots

# $1  test path
# $2  test program name
# $3  timeout cycles
function yace_run_screenshot
{
    TESTDIR=$(cd $1; pwd)

    if [ `uname` == "Linux" ]
    then
        TESTDIRWINE=z:$TESTDIR
    else
        TESTDIRWINE=$TESTDIR
    fi
    
    OLDCWD=`pwd`
    cd $EMUDIR
    extraopts=""$4" "$5" "$6""

#    echo 1:$1
#    echo 2:$2
#    echo TESTDIR:$TESTDIR
#    echo TESTDIRWINE:$TESTDIRWINE

#    echo $YACE "$1"/"$2"
    mkdir -p "$TESTDIR"/".testbench"
    rm -f "$TESTDIR"/.testbench/"$2"-yace.png
    
    if [ $verbose == "1" ]; then
        echo "RUN: " $YACE $YACEOPTS $YACEOPTSSCREENSHOT $extraopts "-limitcycles" "$3" "-exitscreenshot" "$TESTDIRWINE"/.testbench/"$2"-yace.png "$TESTDIRWINE"/"$2" "1> /dev/null"
    fi
    $YACE $YACEOPTS $YACEOPTSSCREENSHOT $extraopts "-limitcycles" "$3" "-exitscreenshot" "$TESTDIRWINE"/.testbench/"$2"-yace.png -ar -l "$TESTDIRWINE"/"$2" 1> /dev/null
    exitcode=$?
    cd $OLDCWD

    if [ $exitcode -ne 0 ]
    then
        if [ $exitcode -ne 1 ]
        then
            if [ $exitcode -ne 255 ]
            then
                echo -ne "\nerror: call to $YACE failed.\n"
                exit -1
            fi
        fi
    fi
    if [ -f "$refscreenshotname" ]
    then
    
        # defaults for PAL
        YACEREFSXO=32
        YACEREFSYO=35
        YACESXO=32
        YACESYO=35
    
        if [ "${refscreenshotvideotype}" == "NTSC" ]; then
            YACEREFSXO=32
            YACEREFSYO=23
        fi

        # when either the testbench was run with --ntsc, or the test is ntsc-specific,
        # then we need the offsets on the NTSC screenshot
        if [ "${videotype}" == "NTSC" ] || [ "${testprogvideotype}" == "NTSC" ]; then
            YACESXO=32
            YACESYO=23
        fi

        ./cmpscreens "$refscreenshotname" "$YACEREFSXO" "$YACEREFSYO" "$TESTDIR"/.testbench/"$2"-yace.png "$YACESXO" "$YACESYO"
        exitcode=$?
    else
        echo -ne "reference screenshot missing - "
        exitcode=255
    fi
#    echo "exited with: " $exitcode
}

################################################################################
# reset
# run test program
# exit when write to $d7ff occurs - the value written determines success (=$00) or fail (=$ff)
# exit after $timeout cycles (exitcode=$01)

# $1  test path
# $2  test program name
# $3  timeout cycles
function yace_run_exitcode
{
    TESTDIR=$(cd $1; pwd)
    if [ `uname` == "Linux" ]
    then
        TESTDIRWINE=z:$TESTDIR
    else
        TESTDIRWINE=$TESTDIR
    fi
    
    OLDCWD=`pwd`
    cd $EMUDIR
    extraopts=""$4" "$5" "$6""
    
#    echo 1:$1
#    echo 2:$2
#    echo TESTDIR:$TESTDIR
#    echo TESTDIRWINE:$TESTDIRWINE
    
    if [ $verbose == "1" ]; then
        echo "RUN: " $YACE $YACEOPTS $YACEOPTSEXITCODE $extraopts "-limitcycles" "$3" -ar -l "$TESTDIRWINE"/"$2" "1> /dev/null"
    fi
    $YACE $YACEOPTS $YACEOPTSEXITCODE $extraopts "-limitcycles" "$3" -ar -l "$TESTDIRWINE"/"$2" 1> /dev/null
    exitcode=$?
#    echo "exited with: " $exitcode
    cd $OLDCWD
}
