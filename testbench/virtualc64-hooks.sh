
VIRTUALC64OPTS+=" -default"
VIRTUALC64OPTS+=" -model c64c"
#VIRTUALC64OPTS+=" -model c64 -ntsc "
VIRTUALC64OPTS+=" -VICIIfilter 0"
VIRTUALC64OPTS+=" -VICIIextpal"
VIRTUALC64OPTS+=" -VICIIpalette pepto-pal.vpl"
VIRTUALC64OPTS+=" -VICIIextpal"
VIRTUALC64OPTS+=" -VICIIsaturation 1000"
VIRTUALC64OPTS+=" -VICIIbrightness 1000"
VIRTUALC64OPTS+=" -VICIIcontrast 1000"
VIRTUALC64OPTS+=" -VICIIgamma 1000"
VIRTUALC64OPTS+=" -VICIItint 1000"
VIRTUALC64OPTS+=" -warp"
#VIRTUALC64OPTS+=" -console"
VIRTUALC64OPTS+=" -debugcart"
VIRTUALC64OPTS+=" -jamaction 1"
#VIRTUALC64OPTS+=" -raminitstartvalue 255 -raminitvalueinvert 4"

#VIRTUALC64OPTS+=" -autostartprgmode 1"

#VIRTUALC64OPTS+=" -raminitstartvalue 0"
#VIRTUALC64OPTS+=" -raminitvalueinvert 8"
#VIRTUALC64OPTS+=" -raminitpatterninvert 0"
#VIRTUALC64OPTS+=" -raminitvalueoffset 0"
#VIRTUALC64OPTS+=" -raminitpatterninvertvalue 0"
#VIRTUALC64OPTS+=" -raminitstartrandom 0"
#VIRTUALC64OPTS+=" -raminitrepeatrandom 0"
#VIRTUALC64OPTS+=" -raminitrandomchance 1"
VIRTUALC64OPTS+=" -drive8extend 0"
VIRTUALC64OPTS+=" +easyflashcrtwrite"

# extra options for the different ways tests can be run
VIRTUALC64OPTSEXITCODE+=" -console"
#VIRTUALC64OPTSSCREENSHOT+=" -minimized"
VIRTUALC64OPTSSCREENSHOT+=" -console"

# X and Y offsets for saved screenshots. when saving a screenshot in the
# computers reset/startup screen, the offset gives the top left pixel of the
# top left character on screen.
VIRTUALC64SXO=32
VIRTUALC64SYO=35

VIRTUALC64REFSXO=32
VIRTUALC64REFSYO=35

function virtualc64_check_environment
{
    VIRTUALC64="$EMUDIR"virtualc64
    
    emu_default_videosubtype="8565"
}

# $1  option
# $2  test path
function virtualc64_get_options
{
#    echo virtualc64_get_options "$1" "$2"
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
                exitoptions="-ntsc -power60"
                testprogvideotype="NTSC"
            ;;
        "vicii-ntscold")
                exitoptions="-ntscold -power60"
                testprogvideotype="NTSCOLD"
            ;;
        "vicii-old") 
                if [ x"$testprogvideotype"x == x"PAL"x ]; then
                    # "old" PAL
                    exitoptions="-VICIImodel 6569"
                    testprogvideosubtype="6569"
                fi
                if [ x"$testprogvideotype"x == x"NTSC"x ]; then
                    # "old" NTSC
                    exitoptions="-VICIImodel 6567"
                    testprogvideosubtype="6567"
                fi
            ;;
        "vicii-new") 
                if [ x"$testprogvideotype"x == x"PAL"x ]; then
                    # "new" PAL
                    exitoptions="-VICIImodel 8565"
                    testprogvideosubtype="8565"
                fi
                if [ x"$testprogvideotype"x == x"NTSC"x ]; then
                    # "new" NTSC
                    exitoptions="-VICIImodel 8562"
                    testprogvideosubtype="8562"
                fi
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
        "reu128k")
                exitoptions="-reu -reusize 128"
                reu_enabled=1
            ;;
        "reu256k")
                exitoptions="-reu -reusize 256"
                reu_enabled=1
            ;;
        "reu512k")
                exitoptions="-reu -reusize 512"
                reu_enabled=1
            ;;
        "reu1m")
                exitoptions="-reu -reusize 1024"
                reu_enabled=1
            ;;
        "reu2m")
                exitoptions="-reu -reusize 2048"
                reu_enabled=1
            ;;
        "reu4m")
                exitoptions="-reu -reusize 4096"
                reu_enabled=1
            ;;
        "reu8m")
                exitoptions="-reu -reusize 8192"
                reu_enabled=1
            ;;
        "reu16m")
                exitoptions="-reu -reusize 16384"
                reu_enabled=1
            ;;
        "geo512k")
                exitoptions="-georam -georamsize 512"
                georam_enabled=1
            ;;
        "plus60k")
                exitoptions="-memoryexphack 2"
                plus60k_enabled=1
            ;;
        "plus256k")
                exitoptions="-memoryexphack 3"
                plus256k_enabled=1
            ;;
        "dqbb")
                exitoptions="-dqbb"
                dqbb_enabled=1
            ;;
        "ramcart128k")
                exitoptions="-ramcart -ramcartsize 128"
                ramcart_enabled=1
            ;;
        "isepic")
                exitoptions="-isepicswitch -isepic"
                isepic_enabled=1
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
function virtualc64_get_cmdline_options
{
#    echo virtualc64_get_cmdline_options "$1" "$2"
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
        "6569") # "old" PAL
                exitoptions="-VICIImodel 6569"
            ;;
        "8565") # "new" PAL
                exitoptions="-VICIImodel 8565"
            ;;
        "6567") # "old" NTSC
                exitoptions="-VICIImodel 6567"
            ;;
        "8562") # "new" NTSC
                exitoptions="-VICIImodel 8562"
            ;;
        "6526") # "old" CIA
                exitoptions="-ciamodel 0"
            ;;
        "6526A") # "new" CIA
                exitoptions="-ciamodel 1"
            ;;
    esac
}

# called once before any tests run
function virtualc64_prepare
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
function virtualc64_run_screenshot
{
    if [ "$2" == "" ] ; then
        screenshottest="$mounted_crt"
    else
        screenshottest="$2"
    fi

    mkdir -p "$1"/".testbench"
    rm -f "$1"/.testbench/"$screenshottest"-virtualc64.png
    if [ $verbose == "1" ]; then
        echo $VIRTUALC64 $VIRTUALC64OPTS $VIRTUALC64OPTSSCREENSHOT ${@:5} "-limitcycles" "$3" "-exitscreenshot" "$1"/.testbench/"$screenshottest"-virtualc64.png "$4"
        $VIRTUALC64 $VIRTUALC64OPTS $VIRTUALC64OPTSSCREENSHOT ${@:5} "-limitcycles" "$3" "-exitscreenshot" "$1"/.testbench/"$screenshottest"-virtualc64.png "$4" 2> /dev/null | grep "cycles elapsed" | tr '\n' ' '
        exitcode=${PIPESTATUS[0]}
    else
        $VIRTUALC64 $VIRTUALC64OPTS $VIRTUALC64OPTSSCREENSHOT ${@:5} "-limitcycles" "$3" "-exitscreenshot" "$1"/.testbench/"$screenshottest"-virtualc64.png "$4" 1> /dev/null 2> /dev/null
        exitcode=$?
    fi    
    
    if [ $verbose == "1" ]; then
        echo $VIRTUALC64 "exited with: " $exitcode
    fi
    
    if [ $exitcode -ne 0 ]
    then
        if [ $exitcode -ne 1 ]
        then
            if [ $exitcode -ne 255 ]
            then
                echo -ne "\nerror: call to $VIRTUALC64 failed.\n"
                exit -1
            fi
        fi
    fi

    if [ $exitcode -eq 0 ] || [ $exitcode -eq 255 ]
    then
        if [ -f "$refscreenshotname" ]
        then

            # defaults for PAL
            VIRTUALC64REFSXO=32
            VIRTUALC64REFSYO=35
            VIRTUALC64SXO=32
            VIRTUALC64SYO=35
            
#            echo [ refscreenshotvideotype:"${refscreenshotvideotype}" videotype:"${videotype}" testprogvideomode:"${testprogvideomode}"]
        
            if [ "${refscreenshotvideotype}" == "NTSC" ]; then
                VIRTUALC64REFSXO=32
                VIRTUALC64REFSYO=23
            fi
        
            # when either the testbench was run with --ntsc, or the test is ntsc-specific,
            # then we need the offsets on the NTSC screenshot
            if [ "${videotype}" == "NTSC" ] || [ "${testprogvideotype}" == "NTSC" ]; then
                VIRTUALC64SXO=32
                VIRTUALC64SYO=23
            fi
        
    #        echo ./cmpscreens "$refscreenshotname" "$VIRTUALC64REFSXO" "$VIRTUALC64REFSYO" "$1"/.testbench/"$screenshottest"-virtualc64.png "$VIRTUALC64SXO" "$VIRTUALC64SYO"
            ./cmpscreens "$refscreenshotname" "$VIRTUALC64REFSXO" "$VIRTUALC64REFSYO" "$1"/.testbench/"$screenshottest"-virtualc64.png "$VIRTUALC64SXO" "$VIRTUALC64SYO"
            exitcode=$?
        else
            echo -ne "reference screenshot missing - "
            exitcode=255
        fi
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
function virtualc64_run_exitcode
{
    if [ $verbose == "1" ]; then
        echo $VIRTUALC64 $VIRTUALC64OPTS $VIRTUALC64OPTSEXITCODE ${@:5} "-limitcycles" "$3" "$4"
        $VIRTUALC64 $VIRTUALC64OPTS $VIRTUALC64OPTSEXITCODE ${@:5} "-limitcycles" "$3" "$4" 2> /dev/null | grep "cycles elapsed" | tr '\n' ' '
        exitcode=${PIPESTATUS[0]}
    else
        $VIRTUALC64 $VIRTUALC64OPTS $VIRTUALC64OPTSEXITCODE ${@:5} "-limitcycles" "$3" "$4" 1> /dev/null 2> /dev/null
        exitcode=$?
    fi
    if [ $verbose == "1" ]; then
        echo $VIRTUALC64 "exited with: " $exitcode
    fi
}
