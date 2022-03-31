
XCBM5X0OPTS+=" -default"
XCBM5X0OPTS+=" -model 510"
XCBM5X0OPTS+=" -virtualdev8"
XCBM5X0OPTS+=" +drive8truedrive"
#XCBM5X0OPTS+=" -VICIIfilter 0"
#XCBM5X0OPTS+=" -VICIIextpal"
#XCBM5X0OPTS+=" -VICIIpalette pepto-pal.vpl"
XCBM5X0OPTS+=" -warp"
XCBM5X0OPTS+=" -debugcart"
XCBM5X0OPTS+=" -jamaction 1"
#XCBM5X0OPTS+=" -console"
XCBM5X0OPTS+=" -drive8extend 0"

# extra options for the different ways tests can be run
# FIXME: the emulators may crash when making screenshots when emu was started
#        with -console
XCBM5X0OPTSEXITCODE+=" -console"
#XCBM5X0OPTSSCREENSHOT+=" -minimized"
XCBM5X0OPTSSCREENSHOT+=" -console"

# X and Y offsets for saved screenshots. when saving a screenshot in the
# computers reset/startup screen, the offset gives the top left pixel of the
# top left character on screen.
XCBM5X0SXO=32
XCBM5X0SYO=35

XCBM5X0REFSXO=32
XCBM5X0REFSYO=35

function xcbm5x0_check_environment
{
    XCBM5X0="$EMUDIR"xcbm5x0
}

# $1  option
# $2  test path
function xcbm5x0_get_options
{
#    echo xcbm5x0_get_options "$1" "$2"
    exitoptions=""
    case "$1" in
        "default")
                exitoptions=""
            ;;
        "crtc-pal")
                exitoptions="-pal"
                testprogvideotype="PAL"
            ;;
        "crtc-ntsc")
                exitoptions="-ntsc"
                testprogvideotype="NTSC"
            ;;
        "crtc-ntscold")
                exitoptions="-ntscold"
                testprogvideotype="NTSCOLD"
            ;;
        "cia-old")
                exitoptions="-ciamodel 0"
                new_cia_enabled=0
            ;;
        "cia-new")
                exitoptions="-ciamodel 1"
                new_cia_enabled=1
            ;;
        "sid-old")
                exitoptions="-sidenginemodel 256"
                new_sid_enabled=0
            ;;
        "sid-new")
                exitoptions="-sidenginemodel 257"
                new_sid_enabled=1
            ;;
        *)
                exitoptions=""
            ;;
    esac
}

# $1  option
# $2  test path
function xcbm5x0_get_cmdline_options
{
#    echo xcbm5x0_get_cmdline_options "$1" "$2"
    exitoptions=""
    case "$1" in
        "PAL")
                exitoptions="-pal"
            ;;
        "NTSC")
                exitoptions="-ntsc"
            ;;
        "6526") # "old" CIA
                exitoptions="-ciamodel 0"
            ;;
        "6526A") # "new" CIA
                exitoptions="-ciamodel 1"
            ;;
    esac
}

# called once before any tests run
function xcbm5x0_prepare
{
    true
}

################################################################################
# reset
# run test program
# exit when write to $daff occurs - the value written determines success (=$00) or fail (=$ff)
# exit after $timeout cycles (exitcode=$01)
# save a screenshot at exit - success or failure is determined by comparing screenshots

# $1  test path
# $2  test program name
# $3  timeout cycles
# $4  test full path+name (may be empty)
# $5- extra options for the emulator
function xcbm5x0_run_screenshot
{
    if [ "$2" == "" ] ; then
        screenshottest="$mounted_crt"
    else
        screenshottest="$2"
    fi

    mkdir -p "$1"/".testbench"
    rm -f "$1"/.testbench/"$screenshottest"-xcbm5x0.png
    if [ $verbose == "1" ]; then
        echo $XCBM5X0 $XCBM5X0OPTS $XCBM5X0OPTSSCREENSHOT ${@:5} "-limitcycles" "$3" "-exitscreenshot" "$1"/.testbench/"$screenshottest"-xcbm5x0.png "$4"
    fi
    $XCBM5X0 $XCBM5X0OPTS $XCBM5X0OPTSSCREENSHOT ${@:5} "-limitcycles" "$3" "-exitscreenshot" "$1"/.testbench/"$screenshottest"-xcbm5x0.png "$4" 1> /dev/null 2> /dev/null
    exitcode=$?
    
    if [ $verbose == "1" ]; then
        echo $XCBM5X0 "exited with: " $exitcode
    fi
    
    if [ $exitcode -ne 0 ]
    then
        if [ $exitcode -ne 1 ]
        then
            if [ $exitcode -ne 255 ]
            then
                echo -ne "\nerror: call to $XCBM5X0 failed.\n"
                exit -1
            fi
        fi
    fi

    if [ $exitcode -eq 0 ] || [ $exitcode -eq 255 ]
    then
        if [ -f "$refscreenshotname" ]
        then
            ./cmpscreens "$refscreenshotname" "$XCBM5X0REFSXO" "$XCBM5X0REFSYO" "$1"/.testbench/"$screenshottest"-xcbm5x0.png "$XCBM5X0SXO" "$XCBM5X0SYO"
            exitcode=$?
        else
            echo -ne "reference screenshot missing - "
            exitcode=255
        fi
    fi
#    echo "exited with: " $exitcode
}

################################################################################
# reset
# run test program
# exit when write to $daff occurs - the value written determines success (=$00) or fail (=$ff)
# exit after $timeout cycles (exitcode=$01)

# $1  test path
# $2  test program name
# $3  timeout cycles
# $4  test full path+name (may be empty)
# $5- extra options for the emulator
function xcbm5x0_run_exitcode
{
    if [ $verbose == "1" ]; then
        echo $XCBM5X0 $XCBM5X0OPTS $XCBM5X0OPTSEXITCODE ${@:5} "-limitcycles" "$3" "$4"
    fi
    $XCBM5X0 $XCBM5X0OPTS $XCBM5X0OPTSEXITCODE ${@:5} "-limitcycles" "$3" "$4" 1> /dev/null 2> /dev/null
    exitcode=$?
#    echo "exited with: " $exitcode
}
