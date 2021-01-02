
# FIXME: set default config, old c64, pepto palette
MICRO64OPTS+=" -PAL"
MICRO64OPTS+=" +VICSINGLEPIXELCLOCK"
MICRO64OPTS+=" +WARP"
MICRO64OPTS+=" +DEBUGCART +AUTOSTART +FASTAUTOSTART"
#MICRO64OPTS+=" -raminitstartvalue 255 -raminitvalueinvert 4"

# extra options for the different ways tests can be run
MICRO64OPTSEXITCODE+=" +HIDE"
MICRO64OPTSSCREENSHOT+=" +HIDE"

# X and Y offsets for saved screenshots. when saving a screenshot in the
# computers reset/startup screen, the offset gives the top left pixel of the
# top left character on screen.
MICRO64SXO=32
MICRO64SYO=40

MICRO64REFSXO=32
MICRO64REFSYO=35

function micro64_check_environment
{
    MICRO64="$EMUDIR"micro64
    if ! [ -x "$(command -v $MICRO64)" ]; then
        echo 'Error: '$MICRO64' not found.' >&2
        exit 1
    fi
    # is this correct?
    emu_default_videosubtype="6569"
}

# $1  option
# $2  test path
function micro64_get_options
{
#    echo micro64_get_options "$1" "$2"
    exitoptions=""
    case "$1" in
        "default")
                exitoptions=""
            ;;
        "vicii-pal")
#                exitoptions=""
                testprogvideotype="PAL"
            ;;
        "vicii-ntsc")
#                exitoptions=""
                testprogvideotype="NTSC"
            ;;
        "vicii-ntscold")
#                exitoptions=""
                testprogvideotype="NTSCOLD"
            ;;
        "vicii-old") 
                if [ x"$testprogvideotype"x == x"PAL"x ]; then
                    # "old" PAL
#                    exitoptions="-VICIImodel 6569"
                    testprogvideosubtype="6569"
                fi
                if [ x"$testprogvideotype"x == x"NTSC"x ]; then
                    # "old" NTSC
#                    exitoptions="-VICIImodel 6567"
                    testprogvideosubtype="6567"
                fi
            ;;
        "vicii-new") 
                if [ x"$testprogvideotype"x == x"PAL"x ]; then
                    # "new" PAL
#                    exitoptions="-VICIImodel 8565"
                    testprogvideosubtype="8565"
                fi
                if [ x"$testprogvideotype"x == x"NTSC"x ]; then
                    # "new" NTSC
#                    exitoptions="-VICIImodel 8562"
                    testprogvideosubtype="8562"
                fi
            ;;
        "cia-old")
                exitoptions="-CIA6526"
                new_cia_enabled=0
            ;;
        "cia-new")
                exitoptions="-CIA6526A"
                new_cia_enabled=1
            ;;
        "sid-old")
                exitoptions="-SID6581"
                new_sid_enabled=0
            ;;
        "sid-new")
                exitoptions="-SID8580"
                new_sid_enabled=1
            ;;
        "reu512k")
                exitoptions="+REUMODE=3"
                reu_enabled=1
            ;;
        "geo256k")
                exitoptions="+NEORAMMODE=2"
                georam_enabled=1
            ;;
        *)
                exitoptions=""
                if [ "${1:0:9}" == "mountd64:" ]; then
                    exitoptions="+mount1541d8=$2/${1:9}"
                    mounted_d64="${1:9}"
                    echo -ne "(disk:${1:9}) "
                fi
                if [ "${1:0:9}" == "mountg64:" ]; then
                    exitoptions="+mount1541d8=$2/${1:9}"
                    mounted_g64="${1:9}"
                    echo -ne "(disk:${1:9}) "
                fi
                if [ "${1:0:9}" == "mountcrt:" ]; then
                    exitoptions="+mountcrt=$2/${1:9}"
                    mounted_crt="${1:9}"
                    echo -ne "(cartridge:${1:9}) "
                fi
            ;;
    esac
}

# $1  option
# $2  test path
function micro64_get_cmdline_options
{
#    echo micro64_get_cmdline_options "$1" "$2"
    exitoptions=""
    case "$1" in
        "PAL")
                exitoptions=""
            ;;
#        "NTSC")
#                exitoptions=""
#            ;;
#        "NTSCOLD")
#                exitoptions=""
#            ;;
        "8565") # "new" PAL
                exitoptions="-VIC8565"
            ;;
#        "8562") # "new" NTSC
#                exitoptions=""
#            ;;
        "6526") # "old" CIA
                exitoptions="-CIA6526"
            ;;
        "6526A") # "new" CIA
                exitoptions="-CIA6526A"
            ;;
    esac
}

# called once before any tests run
function micro64_prepare
{
    true
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
# $4  test full path+name (may be empty)
# $5- extra options for the emulator
function micro64_run_screenshot
{
    if [ "$2" == "" ] ; then
        screenshottest="$mounted_crt"
    else
        screenshottest="$2"
    fi

    mkdir -p "$1"/".testbench"
    rm -f "$1"/.testbench/"$screenshottest"-micro64.png
    if [ $verbose == "1" ]; then
        echo $MICRO64 $MICRO64OPTS $MICRO64OPTSSCREENSHOT ${@:5} "+DEBUGLIMITCYCLES=""$3" "+DEBUGEXITVICBITMAP=""$1"/.testbench/"$screenshottest"-micro64.png "$4"
    fi
    $MICRO64 $MICRO64OPTS $MICRO64OPTSSCREENSHOT ${@:5} "+DEBUGLIMITCYCLES=""$3" "+DEBUGEXITVICBITMAP=""$1"/.testbench/"$screenshottest"-micro64.png "$4" 1> /dev/null
    exitcode=$?
    if [ $exitcode -ne 0 ]
    then
        if [ $exitcode -ne 1 ]
        then
            if [ $exitcode -ne 255 ]
            then
                echo -ne "\nerror: call to $MICRO64 failed.\n"
#                exit -1
            fi
        fi
    fi
    if [ -f "$refscreenshotname" ]
    then

        # defaults for PAL
        MICRO64REFSXO=32
        MICRO64REFSYO=35
        MICRO64SXO=32
        MICRO64SYO=40
        
# micro64 cant do NTSC
    
        if [ $verbose == "1" ]; then
            echo ./cmpscreens "$refscreenshotname" "$MICRO64REFSXO" "$MICRO64REFSYO" "$1"/.testbench/"$screenshottest"-micro64.png "$MICRO64SXO" "$MICRO64SYO"
        fi
        ./cmpscreens "$refscreenshotname" "$MICRO64REFSXO" "$MICRO64REFSYO" "$1"/.testbench/"$screenshottest"-micro64.png "$MICRO64SXO" "$MICRO64SYO"
        exitcode=$?
    else
        echo -ne "reference screenshot missing - "
        exitcode=255
    fi
}

################################################################################
# reset
# run test program
# exit when write to $d7ff occurs - the value written determines success (=$00) or fail (=$ff)
# exit after $timeout cycles (exitcode=$01)

# $1  test path
# $2  test program name
# $3  timeout cycles
# $4  test full path+name (may be empty)
# $5- extra options for the emulator
function micro64_run_exitcode
{
    if [ $verbose == "1" ]; then
        echo $MICRO64 $MICRO64OPTS $MICRO64OPTSEXITCODE ${@:5} "+DEBUGLIMITCYCLES=""$3" "$4"
    fi
    $MICRO64 $MICRO64OPTS $MICRO64OPTSEXITCODE ${@:5} "+DEBUGLIMITCYCLES=""$3" "$4" 1> /dev/null
    exitcode=$?
    if [ $verbose == "1" ]; then
        echo $MICRO64 "exited with: " $exitcode
    fi
}
