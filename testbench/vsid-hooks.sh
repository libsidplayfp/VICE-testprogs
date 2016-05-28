
VSID=../../trunk/vice/src/vsid
VSIDOPTS+=" -default"
#VSIDOPTS+=" -VICIIfilter 0"
#VSIDOPTS+=" -VICIIextpal"
#VSIDOPTS+=" -VICIIpalette vice.vpl"
VSIDOPTS+=" -warp"
#VSIDOPTS+=" -console"
VSIDOPTS+=" -debugcart"

# extra options for the different ways tests can be run
# FIXME: the emulators may crash when making screenshots when emu was started
#        with -console
VSIDOPTSEXITCODE+=" -console"
VSIDOPTSSCREENSHOT+=""

# X and Y offsets for saved screenshots. when saving a screenshot in the
# computers reset/startup screen, the offset gives the top left pixel of the
# top left character on screen.
VSIDSXO=32
VSIDSYO=35

# $1  option
# $2  test path
function vsid_get_options
{
#    echo vsid_get_options "$1"
    exitoptions=""
    case "$1" in
        "default")
                exitoptions=""
            ;;
        "vicii-pal")
                exitoptions="-pal"
            ;;
        "vicii-ntsc")
                exitoptions="-ntsc"
            ;;
        "vicii-ntscold")
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

################################################################################
# reset
# run test program
# exit when write to d7ff occurs (any value)
# exit after $timeout cycles
# save a screenshot at exit - success or failure is determined by comparing screenshots

# $1  test path
# $2  test program name
# $3  timeout cycles
function vsid_run_screenshot
{
    extraopts=""$4" "$5" "$6""
#    echo $VSID "$1"/"$2"
    mkdir -p "$1"/".testbench"
    rm -f "$1"/.testbench/"$2"-vsid.png
    $VSID $VSIDOPTS $VSIDOPTSSCREENSHOT $extraopts "-limitcycles" "$3" "-exitscreenshot" "$1"/.testbench/"$2"-vsid.png "$1"/"$2" 1> /dev/null
    exitcode=$?
    if [ $exitcode -ne 0 ]
    then
        if [ $exitcode -ne 1 ]
        then
            if [ $exitcode -ne 255 ]
            then
                echo -ne "\nerror: call to $VSID failed.\n"
                exit -1
            fi
        fi
    fi

    if [ -f "$refscreenshotname" ]
    then
        ./cmpscreens "$refscreenshotname" 32 35 "$1"/.testbench/"$2"-vsid.png "$VSIDSXO" "$VSIDSYO"
        exitcode=$?
    else
        echo -ne "reference screenshot missing - "
        exitcode=255
    fi
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
function vsid_run_exitcode
{
    extraopts=""$4" "$5" "$6""
#    echo "extraopts=" $extraopts
#    echo $VSID $VSIDOPTS $extraopts "-limitcycles" "$3" "$1"/"$2"
    $VSID $VSIDOPTS $VSIDOPTSEXITCODE $extraopts "-limitcycles" "$3" "$1"/"$2" 1> /dev/null
#    $VSID $VSIDOPTS $extraopts "-limitcycles" "$3" "$1"/"$2"
    exitcode=$?
#    echo "exited with: " $exitcode
}
