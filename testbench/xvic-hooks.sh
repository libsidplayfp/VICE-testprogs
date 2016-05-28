
XVIC=../../trunk/vice/src/xvic
XVICOPTS+=" -default"
#XVICOPTS+=" -VICIIfilter 0"
#XVICOPTS+=" -VICIIextpal"
#XVICOPTS+=" -VICIIpalette vice.vpl"
XVICOPTS+=" -warp"
XVICOPTS+=" -debugcart"
#XVICOPTS+=" -console"

# extra options for the different ways tests can be run
# FIXME: the emulators may crash when making screenshots when emu was started
#        with -console
XVICOPTSEXITCODE+=" -console"
XVICOPTSSCREENSHOT+=""

# X and Y offsets for saved screenshots. when saving a screenshot in the
# computers reset/startup screen, the offset gives the top left pixel of the
# top left character on screen.
XVICSXO=32
XVICSYO=35

# $1  option
# $2  test path
function xvic_get_options
{
#    echo xvic_get_options "$1"
    exitoptions=""
    case "$1" in
        "default")
                exitoptions=""
            ;;
        "vic-pal")
                exitoptions="-pal"
            ;;
        "vic-ntsc")
                exitoptions="-ntsc"
            ;;
        "vic-ntscold")
                exitoptions="-ntscold"
            ;;
        *)
                exitoptions=""
                if [ "${1:0:9}" == "mountd64:" ]; then
                    exitoptions="-8 $2/${1:9}"
                    echo -ne "(disk:${1:9}) "
                fi
                if [ "${1:0:9}" == "mountg64:" ]; then
                    exitoptions="-8 $2/${1:9}"
                    echo -ne "(disk:${1:9}) "
                fi
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
function xvic_run_screenshot
{
    extraopts=""$4" "$5" "$6""
#    echo $XVIC "$1"/"$2"
    mkdir -p "$1"/".testbench"
    rm -f "$1"/.testbench/"$2"-xvic.png
#    echo $XVIC $XVICOPTS $XVICOPTSSCREENSHOT $extraopts "-limitcycles" "$3" "-exitscreenshot" "$1"/.testbench/"$2"-xvic.png "$1"/"$2"
    $XVIC $XVICOPTS $XVICOPTSSCREENSHOT $extraopts "-limitcycles" "$3" "-exitscreenshot" "$1"/.testbench/"$2"-xvic.png "$1"/"$2" 1> /dev/null
    exitcode=$?
    if [ $exitcode -ne 0 ]
    then
        if [ $exitcode -ne 1 ]
        then
            if [ $exitcode -ne 255 ]
            then
                echo -ne "\nerror: call to $XVIC failed.\n"
                exit -1
            fi
        fi
    fi
    if [ -f "$refscreenshotname" ]
    then
        ./cmpscreens "$refscreenshotname" 32 35 "$1"/.testbench/"$2"-xvic.png "$XVICSXO" "$XVICSYO"
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
function xvic_run_exitcode
{
    extraopts=""$4" "$5" "$6""
#    echo $XVIC "$1"/"$2"
    $XVIC $XVICOPTS $XVICOPTSEXITCODE $extraopts "-limitcycles" "$3" "$1"/"$2" 1> /dev/null
    exitcode=$?
#    echo "exited with: " $exitcode
}
