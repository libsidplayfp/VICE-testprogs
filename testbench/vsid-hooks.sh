
VSIDOPTS+=" -default"
#VSIDOPTS+=" -VICIIfilter 0"
#VSIDOPTS+=" -VICIIextpal"
#VSIDOPTS+=" -VICIIpalette pepto-pal.vpl"
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

VSIDREFSXO=32
VSIDREFSYO=35

function vsid_check_environment
{
    VSID="$EMUDIR"vsid
}

# $1  option
# $2  test path
function vsid_get_options
{
#    echo vsid_get_options "$1" "$2"
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
        "vicii-ntscold")
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
function vsid_get_cmdline_options
{
#    echo vsid_get_cmdline_options "$1" "$2"
    exitoptions=""
    case "$1" in
        "PAL")
                exitoptions="-pal"
            ;;
        "NTSC")
                exitoptions="-ntsc"
            ;;
        "NTSCOLD")
                exitoptions="-ntscold"
            ;;
        "6526") # "old" CIA
                exitoptions="-ciamodel 0"
            ;;
        "6526A") # "new" CIA
                exitoptions="-ciamodel 1"
            ;;
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
function vsid_run_screenshot
{
    extraopts=""$4" "$5" "$6""
#    echo $VSID "$1"/"$2"
    mkdir -p "$1"/".testbench"
    rm -f "$1"/.testbench/"$2"-vsid.png
    $VSID $VSIDOPTS $VSIDOPTSSCREENSHOT $extraopts "-limitcycles" "$3" "-exitscreenshot" "$1"/.testbench/"$2"-vsid.png "$1"/"$2" 1> /dev/null 2> /dev/null
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
        ./cmpscreens "$refscreenshotname" "$VSIDREFSXO" "$VSIDREFSYO" "$1"/.testbench/"$2"-vsid.png "$VSIDSXO" "$VSIDSYO"
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
function vsid_run_exitcode
{
    extraopts=""$4" "$5" "$6""
#    echo "extraopts=" $extraopts
#    echo $VSID $VSIDOPTS $extraopts "-limitcycles" "$3" "$1"/"$2"
    $VSID $VSIDOPTS $VSIDOPTSEXITCODE $extraopts "-limitcycles" "$3" "$1"/"$2" 1> /dev/null 2> /dev/null
    exitcode=$?
#    echo "exited with: " $exitcode
}
