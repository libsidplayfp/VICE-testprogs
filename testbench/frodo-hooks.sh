FRODOOPTS+=" -c /dev/null"  # start with default settings
FRODOOPTS+=" FastReset=true"
FRODOOPTS+=" LimitSpeed=false"
FRODOOPTS+=" ShowLEDs=false"
FRODOOPTS+=" AutoStart=true"

# extra options for the different ways tests can be run
FRODOOPTSEXITCODE+=" TestBench=true"
FRODOOPTSSCREENSHOT+=" TestBench=true"

function frodo_check_environment
{
    FRODO="$EMUDIR"Frodo
    if ! [ -x "$(command -v $FRODO)" ]; then
        echo 'Error: '$FRODO' not found.' >&2
        exit 1
    fi

    emu_default_videosubtype="6569"
}

# $1  option
# $2  test path
function frodo_get_options
{
    exitoptions=""
    case "$1" in
        "default")
                exitoptions=""
            ;;
        "sid-old")
                exitoptions="SIDType=6581"
                new_sid_enabled=0
            ;;
        "sid-new")
                exitoptions="SIDType=8580"
                new_sid_enabled=1
            ;;
        "reu128k")
                exitoptions="REUType=128K"
                reu_enabled=1
            ;;
        "reu256k")
                exitoptions="REUType=256K"
                reu_enabled=1
            ;;
        "reu512k")
                exitoptions="REUType=512K"
                reu_enabled=1
            ;;
        "geo512k")
                exitoptions="REUType=GEORAM"
                georam_enabled=1
            ;;
        *)
                exitoptions=""
                if [ "${1:0:9}" == "mountd64:" ]; then
                    exitoptions="DrivePath8=$2/${1:9}"
                    mounted_d64="${1:9}"
                    echo -ne "(disk:${1:9}) "
                fi
                if [ "${1:0:9}" == "mountg64:" ]; then
                    exitoptions="DrivePath8=$2/${1:9}"
                    mounted_g64="${1:9}"
                    echo -ne "(disk:${1:9}) "
                fi
                if [ "${1:0:9}" == "mountcrt:" ]; then
                    exitoptions="Cartridge=$2/${1:9}"
                    mounted_crt="${1:9}"
                    echo -ne "(cartridge:${1:9}) "
                fi
            ;;
    esac
}

# $1  option
# $2  test path
function frodo_get_cmdline_options
{
    exitoptions=""
}

# called once before any tests run
function frodo_prepare
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
function frodo_run_screenshot
{
    if [ "$2" == "" ] ; then
        screenshottest="$mounted_crt"
    else
        screenshottest="$2"
    fi

    mkdir -p "$1"/".testbench"
    rm -f "$1"/.testbench/"$screenshottest"-frodo.png
    if [ x"$2"x == x""x ]; then
        TESTPROGFULLPATH=""
    else
        TESTPROGFULLPATH="LoadProgram="$1"/"$2""
    fi
    if [ $verbose == "1" ]; then
        echo $FRODO $FRODOOPTS $FRODOOPTSSCREENSHOT ${@:5} "TestMaxFrames="$(($3/19656)) "TestScreenshot=$1"/.testbench/"$screenshottest"-frodo.bmp $TESTPROGFULLPATH
    fi
    $FRODO $FRODOOPTS $FRODOOPTSSCREENSHOT ${@:5} "TestMaxFrames="$(($3/19656)) "TestScreenshot=$1"/.testbench/"$screenshottest"-frodo.bmp $TESTPROGFULLPATH 1> /dev/null 2> /dev/null
    exitcode=$?
    if [ $exitcode -ne 0 ]
    then
        if [ $exitcode -ne 1 ]
        then
            if [ $exitcode -ne 255 ]
            then
                echo -ne "\nerror: call to $FRODO failed.\n"
            fi
        fi
    fi
    if [ -f "$refscreenshotname" ]
    then
    
        # defaults for PAL
        FRODOREFSXO=32
        FRODOREFSYO=35
        FRODOSXO=32
        FRODOSYO=35
    
        if [ "${refscreenshotvideotype}" == "NTSC" ]; then
            FRODOREFSXO=32
            FRODOREFSYO=23
        fi

        # when either the testbench was run with --ntsc, or the test is ntsc-specific,
        # then we need the offsets on the NTSC screenshot
        if [ "${videotype}" == "NTSC" ] || [ "${testprogvideotype}" == "NTSC" ]; then
            FRODOSXO=32
            FRODOSYO=23
        fi

        if [ $verbose == "1" ]; then
            echo ./cmpscreens "$refscreenshotname" "$FRODOREFSXO" "$FRODOREFSYO" "$1"/.testbench/"$screenshottest"-frodo.bmp "$FRODOSXO" "$FRODOSYO"
        fi
        ./cmpscreens "$refscreenshotname" "$FRODOREFSXO" "$FRODOREFSYO" "$1"/.testbench/"$screenshottest"-frodo.bmp "$FRODOSXO" "$FRODOSYO"
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
function frodo_run_exitcode
{
    if [ x"$2"x == x""x ]; then
        TESTPROGFULLPATH=""
    else
        TESTPROGFULLPATH="LoadProgram="$1"/"$2""
    fi
    if [ $verbose == "1" ]; then
        echo $FRODO $FRODOOPTS $FRODOOPTSEXITCODE ${@:5} "TestMaxFrames="$(($3/19656)) $TESTPROGFULLPATH
    fi
    $FRODO $FRODOOPTS $FRODOOPTSEXITCODE ${@:5} "TestMaxFrames="$(($3/19656)) $TESTPROGFULLPATH 1> /dev/null 2> /dev/null
    exitcode=$?
    if [ $verbose == "1" ]; then
        echo "exited with: " $exitcode
    fi
}
