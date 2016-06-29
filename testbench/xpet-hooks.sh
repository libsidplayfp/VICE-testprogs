
XPET="$VICEDIR"/xpet
XPETOPTS+=" -default"
#XPETOPTS+=" -VICIIfilter 0"
#XPETOPTS+=" -VICIIextpal"
#XPETOPTS+=" -VICIIpalette vice.vpl"
XPETOPTS+=" -warp"
#XPETOPTS+=" -console"
XPETOPTS+=" -debugcart"

# extra options for the different ways tests can be run
# FIXME: the emulators may crash when making screenshots when emu was started
#        with -console
XPETOPTSEXITCODE+=" -console"
XPETOPTSSCREENSHOT+=""

# X and Y offsets for saved screenshots. when saving a screenshot in the
# computers reset/startup screen, the offset gives the top left pixel of the
# top left character on screen.
XPETSXO=32
XPETSYO=35

XPETREFSXO=32
XPETREFSYO=35

# $1  option
# $2  test path
function xpet_get_options
{
#    echo xpet_get_options "$1"
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
        *)
                exitoptions=""
            ;;
    esac
}

# $1  option
# $2  test path
function xpet_get_cmdline_options
{
#    echo xpet_get_cmdline_options "$1"
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
function xpet_run_screenshot
{
    extraopts=""$4" "$5" "$6""
#    echo $XPET "$1"/"$2"
    mkdir -p "$1"/".testbench"
    rm -f "$1"/.testbench/"$2"-xpet.png
    $XPET $XPETOPTS $XPETOPTSSCREENSHOT $extraopts "-limitcycles" "$3" "-exitscreenshot" "$1"/.testbench/"$2"-xpet.png "$1"/"$2" 1> /dev/null
    exitcode=$?
    if [ $exitcode -ne 0 ]
    then
        if [ $exitcode -ne 1 ]
        then
            if [ $exitcode -ne 255 ]
            then
                echo -ne "\nerror: call to $XPET failed.\n"
                exit -1
            fi
        fi
    fi
    if [ -f "$refscreenshotname" ]
    then
        ./cmpscreens "$refscreenshotname" "$XPETREFSXO" "$XPETREFSYO" "$1"/.testbench/"$2"-xpet.png "$XPETSXO" "$XPETSYO"
        exitcode=$?
    else
        echo -ne "reference screenshot missing - "
        exitcode=255
    fi
}

################################################################################
# reset
# run test program
# exit when write to 8bff occurs - the value written determines success (=1) or fail (other > 1)
# exit after $timeout cycles
# save a screenshot at exit (?)

# $1  test path
# $2  test program name
# $3  timeout cycles
function xpet_run_exitcode
{
    extraopts=""$4" "$5" "$6""
#    echo "extraopts=" $extraopts
#    echo $XPET $XPETOPTS $extraopts "-limitcycles" "$3" "$1"/"$2"
    $XPET $XPETOPTS $XPETOPTSEXITCODE $extraopts "-limitcycles" "$3" "$1"/"$2" 1> /dev/null
#    $XPET $XPETOPTS $extraopts "-limitcycles" "$3" "$1"/"$2"
    exitcode=$?
#    echo "exited with: " $exitcode
}
