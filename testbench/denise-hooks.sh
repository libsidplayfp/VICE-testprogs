
# FIXME: set default config, old c64, pepto palette
DENISEOPTS+=" -no-driver"
DENISEOPTS+=" -debugcart"
DENISEOPTS+=" -ane-magic 0xef"

# extra options for the different ways tests can be run
DENISEOPTSEXITCODE+=" -no-gui"
DENISEOPTSSCREENSHOT+=" -no-gui"

# X and Y offsets for saved screenshots. when saving a screenshot in the
# computers reset/startup screen, the offset gives the top left pixel of the
# top left character on screen.
DENISESXO=32
DENISESYO=35

DENISEREFSXO=32
DENISEREFSYO=35

function denise_check_environment
{
    DENISE="$EMUDIR"Denise
    if ! [ -x "$(command -v $DENISE)" ]; then
        echo 'Error: '$DENISE' not found.' >&2
        exit 1
    fi
    # is this correct?
    emu_default_videosubtype="6569"
}

# $1  option
# $2  test path
function denise_get_options
{
#    echo denise_get_options "$1" "$2"
    exitoptions=""
    case "$1" in
        "default")
                exitoptions=""
            ;;
        "vicii-pal")
                exitoptions="-vic-6569R3"
                testprogvideotype="PAL"
            ;;
        "vicii-ntsc")
                exitoptions="-vic-8562"
                testprogvideotype="NTSC"
            ;;
#        "vicii-ntscold")
#                exitoptions=""
#                testprogvideotype="NTSCOLD"
#            ;;
        "vicii-old") 
                if [ x"$testprogvideotype"x == x"PAL"x ]; then
                    # "old" PAL
                    exitoptions="-vic-6569R3"
                    testprogvideosubtype="6569"
                fi
                if [ x"$testprogvideotype"x == x"NTSC"x ]; then
                    # "old" NTSC
                    exitoptions="-vic-6567R8"
                    testprogvideosubtype="6567"
                fi
            ;;
        "vicii-new") 
                if [ x"$testprogvideotype"x == x"PAL"x ]; then
                    # "new" PAL
                    exitoptions="-vic-8565"
                    testprogvideosubtype="8565"
                fi
                if [ x"$testprogvideotype"x == x"NTSC"x ]; then
                    # "new" NTSC
                    exitoptions="-vic-8562"
                    testprogvideosubtype="8562"
                fi
            ;;
        "cia-old")
                exitoptions="-cia-6526"
                new_cia_enabled=0
            ;;
        "cia-new")
                exitoptions="-cia-6526a"
                new_cia_enabled=1
            ;;
        "sid-old")
                exitoptions="-sid-6581"
                new_sid_enabled=0
            ;;
        "sid-new")
                exitoptions="-sid-8580"
                new_sid_enabled=1
            ;;
        "reu512k")
                exitoptions="-reu 512"
                reu_enabled=1
            ;;
#        "geo256k")
#                exitoptions="+NEORAMMODE=2"
#                georam_enabled=1
#            ;;
        *)
                exitoptions=""
                if [ "${1:0:9}" == "mountd64:" ]; then
                    exitoptions=" $2/${1:9}"
                    mounted_d64="${1:9}"
                    echo -ne "(disk:${1:9}) "
                fi
                if [ "${1:0:9}" == "mountg64:" ]; then
                    exitoptions=" $2/${1:9}"
                    mounted_g64="${1:9}"
                    echo -ne "(disk:${1:9}) "
                fi
                if [ "${1:0:9}" == "mountcrt:" ]; then
                    exitoptions=" $2/${1:9}"
                    mounted_crt="${1:9}"
                    echo -ne "(cartridge:${1:9}) "
                fi
            ;;
    esac
}

# $1  option
# $2  test path
function denise_get_cmdline_options
{
#    echo denise_get_cmdline_options "$1" "$2"
    exitoptions=""
    case "$1" in
        "PAL")
                exitoptions=""
            ;;
#        "NTSC")
#                exitoptions=""
#            ;;
#        "NTSCOLD")
#                exitoptions=""
#            ;;
        "8565") # "new" PAL
                exitoptions="-VIC8565"
            ;;
#        "8562") # "new" NTSC
#                exitoptions=""
#            ;;
        "6526") # "old" CIA
                exitoptions="-CIA6526"
            ;;
        "6526A") # "new" CIA
                exitoptions="-CIA6526A"
            ;;
    esac
}

# called once before any tests run
function denise_prepare
{
    true
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
# $4  test full path+name (may be empty)
# $5- extra options for the emulator
function denise_run_screenshot
{
    if [ "$2" == "" ] ; then
        screenshottest="$mounted_crt"
    else
        screenshottest="$2"
    fi

    mkdir -p "$1"/".testbench"
    rm -f "$1"/.testbench/"$screenshottest"-denise.png
    if [ $verbose == "1" ]; then
        echo $DENISE $DENISEOPTS $DENISEOPTSSCREENSHOT ${@:5} "-limitcycles""$3" "-exitscreenshot" "$1"/.testbench/"$screenshottest"-denise.png "$4"
    fi
    $DENISE $DENISEOPTS $DENISEOPTSSCREENSHOT ${@:5} "-limitcycles""$3" "-exitscreenshot" "$1"/.testbench/"$screenshottest"-denise.png "$4" 1> /dev/null
    exitcode=$?
    if [ $exitcode -ne 0 ]
    then
        if [ $exitcode -ne 1 ]
        then
            if [ $exitcode -ne 255 ]
            then
                echo -ne "\nerror: call to $DENISE failed.\n"
                exit -1
            fi
        fi
    fi
    if [ -f "$refscreenshotname" ]
    then

        # defaults for PAL
        DENISEREFSXO=32
        DENISEREFSYO=35
        DENISESXO=32
        DENISESYO=35
        
        #FIXME: NTSC
    
        if [ $verbose == "1" ]; then
            echo ./cmpscreens "$refscreenshotname" "$DENISEREFSXO" "$DENISEREFSYO" "$1"/.testbench/"$screenshottest"-denise.png "$DENISESXO" "$DENISESYO"
        fi
        ./cmpscreens "$refscreenshotname" "$DENISEREFSXO" "$DENISEREFSYO" "$1"/.testbench/"$screenshottest"-denise.png "$DENISESXO" "$DENISESYO"
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
# $4  test full path+name (may be empty)
# $5- extra options for the emulator
function denise_run_exitcode
{
    if [ $verbose == "1" ]; then
        echo $DENISE $DENISEOPTS $DENISEOPTSEXITCODE ${@:5} "-limitcycles" "$3" "$4"
    fi
    $DENISE $DENISEOPTS $DENISEOPTSEXITCODE ${@:5} "-limitcycles" "$3" "$4" 1> /dev/null 2> /dev/null
    exitcode=$?
    if [ $verbose == "1" ]; then
        echo $DENISE "exited with: " $exitcode
    fi
}
