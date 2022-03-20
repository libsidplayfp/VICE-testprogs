

EMU64OPTS+=" --reset-ini"

EMU64OPTS+=" --video-filter-off"
EMU64OPTS+=" --double-texture-off"
EMU64OPTS+=" --set-palette 7"
EMU64OPTS+=" --warp"
EMU64OPTS+=" --debugcart"
#EMU64OPTS+="  --nosplash"

# extra options for the different ways tests can be run
#EMU64OPTSEXITCODE+=" --nosplash --minimized"
#EMU64OPTSSCREENSHOT+=" --nosplash --minimized"
EMU64OPTSEXITCODE+=" --nogui"
EMU64OPTSSCREENSHOT+=" --nogui"

# X and Y offsets for saved screenshots. when saving a screenshot in the
# computers reset/startup screen, the offset gives the top left pixel of the
# top left character on screen.
#
# for PAL use  32x35
# for NTSC use 32x23
EMU64SXO=32
EMU64SYO=35

# the same for the reference screenshots
EMU64REFSXO=32
EMU64REFSYO=35


function emu64_check_environment
{

    if [ `uname` == "Linux" ]
    then
        if [ -f "$EMUDIR"emu64.exe ]; then
            echo "found .exe file, using wine"
            if ! [ -x "$(command -v wine)" ]; then
                echo 'Error: wine not installed.' >&2
                exit 1
            fi
            export WINEDEBUG=-all
            EMU64="wine"
            EMU64+=" $EMUDIR"emu64.exe
        else
            EMU64="$EMUDIR"emu64
        fi
    else
        EMU64="$EMUDIR"emu64.exe
    fi
    # is this correct?
    emu_default_videosubtype="6569"
}

# $1  option
# $2  test path
function emu64_get_options
{
#    echo emu64_get_options "$1" "$2"
    exitoptions=""
    case "$1" in
        "default")
                exitoptions=""
            ;;
        "vicii-pal")
#                exitoptions="-pal"
                testprogvideotype="PAL"
            ;;
        "vicii-ntsc")
#                exitoptions="-ntsc"
                testprogvideotype="NTSC"
            ;;
        "vicii-ntscold")
#                exitoptions="-ntscold"
                testprogvideotype="NTSCOLD"
            ;;
        "vicii-old") 
                if [ x"$testprogvideotype"x == x"PAL"x ]; then
                    # "old" PAL
#                    exitoptions="-VICIImodel 6569"
                    testprogvideosubtype="6569"
                fi
                if [ x"$testprogvideotype"x == x"NTSC"x ]; then
                    # "old" NTSC
#                    exitoptions="-VICIImodel 6567"
                    testprogvideosubtype="6567"
                fi
            ;;
        "vicii-new") 
                if [ x"$testprogvideotype"x == x"PAL"x ]; then
                    # "new" PAL
#                    exitoptions="-VICIImodel 8565"
                    testprogvideosubtype="8565"
                fi
                if [ x"$testprogvideotype"x == x"NTSC"x ]; then
                    # "new" NTSC
#                    exitoptions="-VICIImodel 8562"
                    testprogvideosubtype="8562"
                fi
            ;;
        "cia-old")
#FIXME: unclear what the CIA type is
#                exitoptions="-ciamodel 0"
                new_cia_enabled=0
            ;;
        "cia-new")
#FIXME: unclear what the CIA type is
#                exitoptions="-ciamodel 1"
                new_cia_enabled=1
            ;;
        "sid-old")
                exitoptions="--set-sidtype 0"
                new_sid_enabled=0
            ;;
        "sid-new")
                exitoptions="--set-sidtype 1"
                new_sid_enabled=1
            ;;
        "reu512k")
#FIXME: REU is always 16MB
                exitoptions="--enable-reu"
                reu_enabled=1
            ;;
        "geo512k")
#FIXME: GEORAM is always 2MB
                exitoptions="--enable-georam"
                georam_enabled=1
            ;;
        *)
                exitoptions=""
                if [ "${1:0:9}" == "mountd64:" ]; then
                    exitoptions="--mount-disk 8 $2/${1:9}"
                    mounted_d64="${1:9}"
                    echo -ne "(disk:${1:9}) "
                fi
                if [ "${1:0:9}" == "mountg64:" ]; then
                    exitoptions="--mount-disk 8 $2/${1:9}"
                    mounted_g64="${1:9}"
                    echo -ne "(disk:${1:9}) "
                fi
                if [ "${1:0:9}" == "mountcrt:" ]; then
                    exitoptions="--mount-crt $2/${1:9}"
                    mounted_crt="${1:9}"
                    echo -ne "(cartridge:${1:9}) "
                fi
            ;;
    esac
}


# $1  option
# $2  test path
function emu64_get_cmdline_options
{
#    echo emu64_get_cmdline_options "$1" "$2"
    exitoptions=""
#    case "$1" in
#        "PAL")
#                exitoptions="-pal"
#            ;;
#        "NTSC")
#                exitoptions="-ntsc"
#            ;;
#        "NTSCOLD")
#                exitoptions="-ntscold"
#            ;;
#        "8565") # "new" PAL
#                exitoptions="-VICIImodel 8565"
#            ;;
#        "8562") # "new" NTSC
#                exitoptions="-VICIImodel 8562"
#            ;;
#    esac
}

# called once before any tests run
function emu64_prepare
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
function emu64_run_screenshot
{
    if [ "$2" == "" ] ; then
        screenshottest="$mounted_crt"
    else
        screenshottest="$2"
    fi

    mkdir -p "$1"/".testbench"
    rm -f "$1"/.testbench/"$screenshottest"-emu64.png
    if [ x"$2"x == x""x ]; then
        TESTPROGFULLPATH=""
    else
        TESTPROGFULLPATH="--autostart "$1"/"$2""
    fi
    if [ $verbose == "1" ]; then
        echo $EMU64 $EMU64OPTS $EMU64OPTSSCREENSHOT ${@:5} "--limitcycles" "$3" "--exitscreenshot" "$1"/.testbench/"$screenshottest"-emu64.png $TESTPROGFULLPATH
    fi
    $EMU64 $EMU64OPTS $EMU64OPTSSCREENSHOT ${@:5} "--limitcycles" "$3" "--exitscreenshot" "$1"/.testbench/"$screenshottest"-emu64.png $TESTPROGFULLPATH 1> /dev/null 2> /dev/null
    exitcode=$?
    if [ $exitcode -ne 0 ]
    then
        if [ $exitcode -ne 1 ]
        then
            if [ $exitcode -ne 255 ]
            then
                echo -ne "\nerror: call to $EMU64 failed.\n"
                exit -1
            fi
        fi
    fi
    if [ -f "$refscreenshotname" ]
    then
    
        # defaults for PAL
        EMU64REFSXO=32
        EMU64REFSYO=35
        EMU64SXO=32
        EMU64SYO=35
    
        if [ "${refscreenshotvideotype}" == "NTSC" ]; then
            EMU64REFSXO=32
            EMU64REFSYO=23
        fi

        # when either the testbench was run with --ntsc, or the test is ntsc-specific,
        # then we need the offsets on the NTSC screenshot
        if [ "${videotype}" == "NTSC" ] || [ "${testprogvideotype}" == "NTSC" ]; then
            EMU64SXO=32
            EMU64SYO=23
        fi

        if [ $verbose == "1" ]; then
            echo ./cmpscreens "$refscreenshotname" "$EMU64REFSXO" "$EMU64REFSYO" "$1"/.testbench/"$screenshottest"-emu64.png "$EMU64SXO" "$EMU64SYO"
        fi
        ./cmpscreens "$refscreenshotname" "$EMU64REFSXO" "$EMU64REFSYO" "$1"/.testbench/"$screenshottest"-emu64.png "$EMU64SXO" "$EMU64SYO"
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
# exit when write to $d7ff occurs - the value written determines success (=$00) or fail (=$ff)
# exit after $timeout cycles (exitcode=$01)

# $1  test path
# $2  test program name
# $3  timeout cycles
# $4  test full path+name (may be empty)
# $5- extra options for the emulator
function emu64_run_exitcode
{
    if [ x"$2"x == x""x ]; then
        TESTPROGFULLPATH=""
    else
        TESTPROGFULLPATH="--autostart "$1"/"$2""
    fi
    if [ $verbose == "1" ]; then
        echo $EMU64 $EMU64OPTS $EMU64OPTSEXITCODE ${@:5} "--limitcycles" "$3" $TESTPROGFULLPATH "1> /dev/null 2> /dev/null"
    fi
    $EMU64 $EMU64OPTS $EMU64OPTSEXITCODE ${@:5} "--limitcycles" "$3" $TESTPROGFULLPATH 1> /dev/null 2> /dev/null
    exitcode=$?
    if [ $verbose == "1" ]; then
        echo "exited with: " $exitcode
    fi
}
