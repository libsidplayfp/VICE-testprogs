
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
XVICOPTSSCREENSHOT+=" -minimized"

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
#    echo xvic_get_options "$1" "$2"
    exitoptions=""
    case "$1" in
        "default")
                exitoptions=""
            ;;
        "vic-pal")
                exitoptions="-pal"
                testprogvideotype="PAL"
            ;;
        "vic-ntsc")
                exitoptions="-ntsc"
                testprogvideotype="NTSC"
            ;;
        "vic-ntscold")
                exitoptions="-ntscold"
                testprogvideotype="NTSCOLD"
            ;;
        "sid-old")
                exitoptions="-sidenginemodel 256"
                new_sid_enabled=0
            ;;
        "sid-new")
                exitoptions="-sidenginemodel 257"
                new_sid_enabled=1
            ;;
        "vic20-8k")
                exitoptions="-memory 8k"
                memory_expansion_enabled="8K"
            ;;
        "vic20-32k")
                exitoptions="-memory all"
                memory_expansion_enabled="32K"
            ;;
        "geo256k")
                exitoptions="-georam -georamsize 256"
                georam_enabled=1
            ;;
        *)
                exitoptions=""
                if [ "${1:0:9}" == "mountd64:" ]; then
                    exitoptions="-8 $2/${1:9}"
                    mounted_d64="${1:9}"
                    echo -ne "(disk:${1:9}) "
                fi
                if [ "${1:0:9}" == "mountg64:" ]; then
                    exitoptions="-8 $2/${1:9}"
                    mounted_g64="${1:9}"
                    echo -ne "(disk:${1:9}) "
                fi
            ;;
    esac
}

# $1  option
# $2  test path
function xvic_get_cmdline_options
{
#    echo xvic_get_cmdline_options "$1" "$2"
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
        "32K")
                exitoptions="-memory all"
            ;;
    esac
}

# called once before any tests run
function xvic_prepare
{
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
# $4  test full path+name (may be empty)
# $5- extra options for the emulator
function xvic_run_screenshot
{
    mkdir -p "$1"/".testbench"
    rm -f "$1"/.testbench/"$2"-xvic.png
    if [ $verbose == "1" ]; then
        echo $XVIC $XVICOPTS $XVICOPTSSCREENSHOT ${@:5} "-limitcycles" "$3" "-exitscreenshot" "$1"/.testbench/"$2"-xvic.png "$4"
    fi
    $XVIC $XVICOPTS $XVICOPTSSCREENSHOT ${@:5} "-limitcycles" "$3" "-exitscreenshot" "$1"/.testbench/"$2"-xvic.png "$4" 1> /dev/null 2> /dev/null
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
    
        # when either the testbench was run with --ntsc, or the test is ntsc-specific,
        # then we need the offsets on the NTSC screenshot
        if [ "${videotype}" == "NTSC" ] || [ "${testprogvideotype}" == "NTSC" ]; then
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
# $4  test full path+name (may be empty)
# $5- extra options for the emulator
function xvic_run_exitcode
{
    if [ $verbose == "1" ]; then
        echo $XVIC $XVICOPTS $XVICOPTSEXITCODE ${@:5} "-limitcycles" "$3" "$4" "1> /dev/null 2> /dev/null"
        $XVIC $XVICOPTS $XVICOPTSEXITCODE ${@:5} "-limitcycles" "$3" "$4" 2> /dev/null | grep "cycles elapsed" | tr '\n' '-'
        exitcode=${PIPESTATUS[0]}
    else
        $XVIC $XVICOPTS $XVICOPTSEXITCODE ${@:5} "-limitcycles" "$3" "$4" 1> /dev/null 2> /dev/null
        exitcode=$?
    fi
#    echo "exited with: " $exitcode
}
