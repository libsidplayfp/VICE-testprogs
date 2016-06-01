
XCBM5X0=../../trunk/vice/src/xcbm5x0
XCBM5X0OPTS+=" -default"
XCBM5X0OPTS+=" -model 510"
XCBM2OPTS+=" -virtualdev"
XCBM2OPTS+=" +truedrive"
#XCBM5X0OPTS+=" -VICIIfilter 0"
#XCBM5X0OPTS+=" -VICIIextpal"
#XCBM5X0OPTS+=" -VICIIpalette vice.vpl"
XCBM5X0OPTS+=" -warp"
XCBM5X0OPTS+=" -debugcart"
#XCBM5X0OPTS+=" -console"

# extra options for the different ways tests can be run
# FIXME: the emulators may crash when making screenshots when emu was started
#        with -console
XCBM5X0OPTSEXITCODE+=" -console"
XCBM5X0OPTSSCREENSHOT+=""

# X and Y offsets for saved screenshots. when saving a screenshot in the
# computers reset/startup screen, the offset gives the top left pixel of the
# top left character on screen.
XCBM5X0SXO=32
XCBM5X0SYO=35

XCBM5X0REFSXO=32
XCBM5X0REFSYO=35

# $1  option
# $2  test path
function xcbm5x0_get_options
{
#    echo xcbm5x0_get_options "$1"
    exitoptions=""
    case "$1" in
        "default")
                exitoptions=""
            ;;
        "crtc-pal")
                exitoptions="-pal"
            ;;
        "crtc-ntsc")
                exitoptions="-ntsc"
            ;;
        "crtc-ntscold")
                exitoptions="-ntscold"
            ;;
        "cia-old")
                exitoptions="-ciamodel 0"
            ;;
        "cia-new")
                exitoptions="-ciamodel 1"
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
#    echo xcbm5x0_get_cmdline_options "$1"
    exitoptions=""
    case "$1" in
        "PAL")
                exitoptions="-pal"
            ;;
        "NTSC")
                exitoptions="-ntsc"
            ;;
    esac
}

################################################################################
# reset
# run test program
# exit when write to d7ff occurs (any value)
# exit after $timeout cycles
# save a screenshot at exit - success or failure is determined by comparing screenshots

# $1  test path
# $2  test program name
# $3  timeout cycles
function xcbm5x0_run_screenshot
{
    extraopts=""$4" "$5" "$6""
#    echo $XCBM5X0 "$1"/"$2"
    mkdir -p "$1"/".testbench"
    rm -f "$1"/.testbench/"$2"-xcbm5x0.png
#    echo $XCBM5X0 $XCBM5X0OPTS $XCBM5X0OPTSSCREENSHOT $extraopts "-limitcycles" "$3" "-exitscreenshot" "$1"/.testbench/"$2"-xcbm5x0.png "$1"/"$2"
    $XCBM5X0 $XCBM5X0OPTS $XCBM5X0OPTSSCREENSHOT $extraopts "-limitcycles" "$3" "-exitscreenshot" "$1"/.testbench/"$2"-xcbm5x0.png "$1"/"$2" 1> /dev/null
    exitcode=$?
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
    if [ -f "$refscreenshotname" ]
    then
        ./cmpscreens "$refscreenshotname" "$XCBM5X0REFSXO" "$XCBM5X0REFSYO" "$1"/.testbench/"$2"-xcbm5x0.png "$XCBM5X0SXO" "$XCBM5X0SYO"
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
# exit when write to d7ff occurs - the value written determines success (=1) or fail (other > 1)
# exit after $timeout cycles
# save a screenshot at exit (?)

# $1  test path
# $2  test program name
# $3  timeout cycles
function xcbm5x0_run_exitcode
{
    extraopts=""$4" "$5" "$6""
#    echo $XCBM5X0 "$1"/"$2"
    $XCBM5X0 $XCBM5X0OPTS $XCBM5X0OPTSEXITCODE $extraopts "-limitcycles" "$3" "$1"/"$2" 1> /dev/null
    exitcode=$?
#    echo "exited with: " $exitcode
}
