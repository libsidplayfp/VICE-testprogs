
XPLUS4OPTS+=" -default"
XPLUS4OPTS+=" -TEDfilter 0"
XPLUS4OPTS+=" -TEDextpal"
XPLUS4OPTS+=" -TEDpalette colodore_ted.vpl"
XPLUS4OPTS+=" -TEDsaturation 1000"
XPLUS4OPTS+=" -TEDbrightness 1000"
XPLUS4OPTS+=" -TEDcontrast 1000"
XPLUS4OPTS+=" -TEDgamma 1000"
XPLUS4OPTS+=" -TEDtint 1000"
XPLUS4OPTS+=" -warp"
XPLUS4OPTS+=" -debugcart"
#XPLUS4OPTS+=" -console"
XPLUS4OPTS+=" -jamaction 1"
XPLUS4OPTS+=" -drive8extend 0"

# extra options for the different ways tests can be run
# FIXME: the emulators may crash when making screenshots when emu was started
#        with -console
XPLUS4OPTSEXITCODE+=" -console"
#XPLUS4OPTSSCREENSHOT+=" -minimized"
XPLUS4OPTSSCREENSHOT+=" -console"

# X and Y offsets for saved screenshots. when saving a screenshot in the
# computers reset/startup screen, the offset gives the top left pixel of the
# top left character on screen.
XPLUS4SXO=32
XPLUS4SYO=35

XPLUS4REFSXO=32
XPLUS4REFSYO=35

function xplus4_check_environment
{
    XPLUS4="$EMUDIR"xplus4
}

# $1  option
# $2  test path
function xplus4_get_options
{
#    echo xplus4_get_options "$1" "$2"
    exitoptions=""
    case "$1" in
        "default")
                exitoptions=""
            ;;
        "ted-pal")
                exitoptions="-pal"
                testprogvideotype="PAL"
            ;;
        "ted-ntsc")
                exitoptions="-ntsc"
                testprogvideotype="NTSC"
            ;;
        "ted-ntscold")
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
        *)
                exitoptions=""
                if [ "${1:0:9}" == "mountd64:" ]; then
                    exitoptions="-8 $2/${1:9}"
                    mounted_d64="${1:9}"
                    echo -ne "(disk:${1:9}) "
                fi
                if [ "${1:0:9}" == "mountd71:" ]; then
                    exitoptions="-drive8type 1571 -8 $2/${1:9}"
                    mounted_d64="${1:9}"
                    echo -ne "(disk:${1:9}) "
                fi
                if [ "${1:0:9}" == "mountg64:" ]; then
                    exitoptions="-8 $2/${1:9}"
                    mounted_g64="${1:9}"
                    echo -ne "(disk:${1:9}) "
                fi
                if [ "${1:0:9}" == "mountp64:" ]; then
                    exitoptions="-8 $2/${1:9}"
                    mounted_p64="${1:9}"
                    echo -ne "(disk:${1:9}) "
                fi
                if [ "${1:0:9}" == "mountcrt:" ]; then
                    exitoptions="-cartcrt $2/${1:9}"
                    mounted_crt="${1:9}"
                    echo -ne "(cartridge:${1:9}) "
                fi
            ;;

    esac
}

# $1  option
# $2  test path
function xplus4_get_cmdline_options
{
#    echo xplus4_get_cmdline_options "$1" "$2"
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
    esac
}

# called once before any tests run
function xplus4_prepare
{
    true
}

################################################################################
# reset
# run test program
# exit when write to $fdcf occurs - the value written determines success (=$00) or fail (=$ff)
# exit after $timeout cycles (exitcode=$01)
# save a screenshot at exit - success or failure is determined by comparing screenshots

# $1  test path
# $2  test program name
# $3  timeout cycles
# $4  test full path+name (may be empty)
# $5- extra options for the emulator
function xplus4_run_screenshot
{
    if [ "$2" == "" ] ; then
        screenshottest="$mounted_crt"
    else
        screenshottest="$2"
    fi

    mkdir -p "$1"/".testbench"
    rm -f "$1"/.testbench/"$screenshottest"-xplus4.png
    if [ $verbose == "1" ]; then
        echo $XPLUS4 $XPLUS4OPTS $XPLUS4OPTSSCREENSHOT ${@:5} "-limitcycles" "$3" "-exitscreenshot" "$1"/.testbench/"$screenshottest"-xplus4.png "$4"
    fi
    $XPLUS4 $XPLUS4OPTS $XPLUS4OPTSSCREENSHOT ${@:5} "-limitcycles" "$3" "-exitscreenshot" "$1"/.testbench/"$screenshottest"-xplus4.png "$4" 1> /dev/null 2> /dev/null
    exitcode=$?
    
    if [ $verbose == "1" ]; then
        echo $XPLUS4 "exited with: " $exitcode
    fi
    
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

    if [ $exitcode -eq 0 ] || [ $exitcode -eq 255 ]
    then
        if [ -f "$refscreenshotname" ]
        then
            ./cmpscreens "$refscreenshotname" "$XPLUS4REFSXO" "$XPLUS4REFSYO" "$1"/.testbench/"$screenshottest"-xplus4.png "$XPLUS4SXO" "$XPLUS4SYO"
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
# exit when write to $fdcf occurs - the value written determines success (=$00) or fail (=$ff)
# exit after $timeout cycles (exitcode=$01)

# $1  test path
# $2  test program name
# $3  timeout cycles
# $4  test full path+name (may be empty)
# $5- extra options for the emulator
function xplus4_run_exitcode
{
    if [ $verbose == "1" ]; then
        echo $XPLUS4 $XPLUS4OPTS $XPLUS4OPTSEXITCODE ${@:5} "-limitcycles" "$3" "$4"
    fi
    $XPLUS4 $XPLUS4OPTS $XPLUS4OPTSEXITCODE ${@:5} "-limitcycles" "$3" "$4" 1> /dev/null 2> /dev/null
    exitcode=$?
#    echo "exited with: " $exitcode
}
