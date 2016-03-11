
XPLUS4=../../trunk/vice/src/xplus4
XPLUS4OPTS+=" -default"
#XPLUS4OPTS+=" -VICIIfilter 0"
#XPLUS4OPTS+=" -VICIIextpal"
#XPLUS4OPTS+=" -VICIIpalette vice.vpl"
XPLUS4OPTS+=" -warp"
XPLUS4OPTS+=" -debugcart"
#XPLUS4OPTS+=" -console"

# extra options for the different ways tests can be run
# FIXME: the emulators may crash when making screenshots when emu was started
#        with -console
XPLUS4OPTSEXITCODE+=" -console"
XPLUS4OPTSSCREENSHOT+=""

# X and Y offsets for saved screenshots. when saving a screenshot in the
# computers reset/startup screen, the offset gives the top left pixel of the
# top left character on screen.
XPLUS4SXO=32
XPLUS4SYO=35

function xplus4_get_options
{
#    echo xplus4_get_options "$1"
    exitoptions=""
    case "$1" in
        "default")
                exitoptions=""
            ;;
        "ted-pal")
                exitoptions="-pal"
            ;;
        "ted-ntsc")
                exitoptions="-ntsc"
            ;;
        "ted-ntscold")
                exitoptions="-ntscold"
            ;;
        *)
                exitoptions=""
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
function xplus4_run_screenshot
{
    extraopts=""$4" "$5" "$6""
#    echo $XPLUS4 "$1"/"$2"
    mkdir -p "$1"/".testbench"
    rm -f "$1"/.testbench/"$2"-x64.png
#    echo $XPLUS4 $XPLUS4OPTS $XPLUS4OPTSSCREENSHOT $extraopts "-limitcycles" "$3" "-exitscreenshot" "$1"/.testbench/"$2"-x64.png "$1"/"$2"
    $XPLUS4 $XPLUS4OPTS $XPLUS4OPTSSCREENSHOT $extraopts "-limitcycles" "$3" "-exitscreenshot" "$1"/.testbench/"$2"-x64.png "$1"/"$2" 1> /dev/null
    exitcode=$?
    if [ $exitcode -ne 0 ]
    then
        if [ $exitcode -ne 1 ]
        then
            if [ $exitcode -ne 255 ]
            then
                echo -ne "\nerror: call to $XPLUS4 failed.\n"
                exit -1
            fi
        fi
    fi
    if [ -f "$1"/references/"$2".png ]
    then
        ./cmpscreens "$1"/references/"$2".png 32 35 "$1"/.testbench/"$2"-x64.png "$XPLUS4SXO" "$XPLUS4SYO"
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
function xplus4_run_exitcode
{
    extraopts=""$4" "$5" "$6""
#    echo $XPLUS4 "$1"/"$2"
    $XPLUS4 $XPLUS4OPTS $XPLUS4OPTSEXITCODE $extraopts "-limitcycles" "$3" "$1"/"$2" 1> /dev/null
    exitcode=$?
#    echo "exited with: " $exitcode
}
