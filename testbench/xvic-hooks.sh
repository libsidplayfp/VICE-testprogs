
XVICOPTS+=" -default"
XVICOPTS+=" -VICfilter 0"
XVICOPTS+=" -VICextpal"
XVICOPTS+=" -VICpalette mike-pal.vpl"
XVICOPTS+=" -warp"
XVICOPTS+=" -debugcart"
XVICOPTS+=" -basicload"
#XVICOPTS+=" -console"

# extra options for the different ways tests can be run
# FIXME: the emulators may crash when making screenshots when emu was started
#        with -console
XVICOPTSEXITCODE+=" -console"
XVICOPTSSCREENSHOT+=""

# X and Y offsets for saved screenshots. when saving a screenshot in the
# computers reset/startup screen, the offset gives the top left pixel of the
# top left character on screen.
XVICSXO=96
XVICSYO=48

XVICREFSXO=96
XVICREFSYO=48

function xvic_check_environment
{
    XVIC="$EMUDIR"xvic
}

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
        "sid-old")
                exitoptions="-sidenginemodel 256"
            ;;
        "sid-new")
                exitoptions="-sidenginemodel 257"
            ;;
        "vic20-8k")
                exitoptions="-memory 8k"
            ;;
        "vic20-32k")
                exitoptions="-memory all"
            ;;
        "geo256k")
                exitoptions="-georam -georamsize 256"
                georam_enabled=1
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

# $1  option
# $2  test path
function xvic_get_cmdline_options
{
#    echo xvic_get_cmdline_options "$1"
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
        "8K")
                exitoptions="-memory 8k"
            ;;
    esac
}

################################################################################
# reset
# run test program
# exit when write to $910f occurs - the value written determines success (=$00) or fail (=$ff)
# exit after $timeout cycles (exitcode=$01)
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
        # defaults for PAL
        XVICSXO=96
        XVICSYO=48
        XVICREFSXO=96
        XVICREFSYO=48
        
#        echo [ "${refscreenshotvideotype}" "${videotype}" ]
    
        if [ "${refscreenshotvideotype}" == "NTSC" ]; then
            XVICREFSXO=40
            XVICREFSYO=22
        fi
    
        if [ "${videotype}" == "NTSC" ]; then
            XVICSXO=40
            XVICSYO=22
        fi

#        echo ./cmpscreens "$refscreenshotname" "$XVICREFSXO" "$XVICREFSYO" "$1"/.testbench/"$2"-xvic.png "$XVICSXO" "$XVICSYO"
        ./cmpscreens "$refscreenshotname" "$XVICREFSXO" "$XVICREFSYO" "$1"/.testbench/"$2"-xvic.png "$XVICSXO" "$XVICSYO"
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
# exit when write to $910f occurs - the value written determines success (=$00) or fail (=$ff)
# exit after $timeout cycles (exitcode=$01)

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
