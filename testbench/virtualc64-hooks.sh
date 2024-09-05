
VIRTUALC64OPTS+=" -\"c64 defaults\""
#VIRTUALC64OPTS+=" -model c64c"
#VIRTUALC64OPTS+=" -model c64 -ntsc "
# TODO set up non filtered, non scaled output with a standard palette known by cmpscreens
#VIRTUALC64OPTS+=" -VICIIfilter 0"
#VIRTUALC64OPTS+=" -VICIIextpal"
#VIRTUALC64OPTS+=" -VICIIpalette pepto-pal.vpl"
#VIRTUALC64OPTS+=" -VICIIextpal"
#VIRTUALC64OPTS+=" -VICIIsaturation 1000"
#VIRTUALC64OPTS+=" -VICIIbrightness 1000"
#VIRTUALC64OPTS+=" -VICIIcontrast 1000"
#VIRTUALC64OPTS+=" -VICIIgamma 1000"
#VIRTUALC64OPTS+=" -VICIItint 1000"
VIRTUALC64OPTS+=" -\"c64 set WARP_MODE WARP_ALWAYS\""
# also "expansion set DEBUGCART true" ?
VIRTUALC64OPTS+=" -\"regression set DEBUGCART true\""
VIRTUALC64OPTS+=" -\"screenshot set path \"\"\""
#VIRTUALC64OPTS+=" -jamaction 1"
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
# TODO: disable extending of disk images
#VIRTUALC64OPTS+=" -drive8extend 0"
# TODO: disable writing to Easyflash
#VIRTUALC64OPTS+=" +easyflashcrtwrite"

# extra options for the different ways tests can be run
#VIRTUALC64OPTSEXITCODE+=" -console"
#VIRTUALC64OPTSSCREENSHOT+=" -minimized"
#VIRTUALC64OPTSSCREENSHOT+=" -console"

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
                exitoptions="-\"c64 init PAL\""
                testprogvideotype="PAL"
            ;;
        "vicii-ntsc")
                exitoptions="-\"c64 init NTSC\" -\"power set POWER_GRID STABLE_60HZ\""
                testprogvideotype="NTSC"
            ;;
        "vicii-ntscold")
                exitoptions="-\"c64 init NTSC_OLD\" -\"power set POWER_GRID STABLE_60HZ\""
                testprogvideotype="NTSCOLD"
            ;;
        "vicii-old") 
                if [ x"$testprogvideotype"x == x"PAL"x ]; then
                    # "old" PAL
                    exitoptions="-\"vic set REVISION PAL_6569_R1\""
                    testprogvideosubtype="6569"
                fi
                if [ x"$testprogvideotype"x == x"NTSC"x ]; then
                    # "old" NTSC
                    exitoptions="-\"vic set REVISION NTSC_6567\""
                    testprogvideosubtype="6567"
                fi
            ;;
        "vicii-new") 
                if [ x"$testprogvideotype"x == x"PAL"x ]; then
                    # "new" PAL
                    exitoptions="-\"vic set REVISION PAL_8565\""
                    testprogvideosubtype="8565"
                fi
                if [ x"$testprogvideotype"x == x"NTSC"x ]; then
                    # "new" NTSC
                    exitoptions="-\"vic set REVISION NTSC_8562\""
                    testprogvideosubtype="8562"
                fi
            ;;
        "cia-old")
                exitoptions="-\"cia1 set REVISION MOS_6526\" -\"cia2 set REVISION MOS_6526\""
                new_cia_enabled=0
            ;;
        "cia-new")
                exitoptions="-\"cia1 set REVISION MOS_8521\" -\"cia2 set REVISION MOS_8521\""
                new_cia_enabled=1
            ;;
        "sid-old")
                exitoptions="-\"sid set REVISION MOS_6581\""
                new_sid_enabled=0
            ;;
        "sid-new")
                exitoptions="-\"sid set REVISION MOS_8580\""
                new_sid_enabled=1
            ;;
        "reu128k")
                exitoptions="-\"expansion attach reu 128\""
                reu_enabled=1
            ;;
        "reu256k")
                exitoptions="-\"expansion attach reu 256\""
                reu_enabled=1
            ;;
        "reu512k")
                exitoptions="-\"expansion attach reu 512\""
                reu_enabled=1
            ;;
#        "reu1m")
#                exitoptions="-\"expansion attach reu 1024\""
#                reu_enabled=1
#            ;;
        "reu2m")
                exitoptions="-\"expansion attach reu 2048\""
                reu_enabled=1
            ;;
#        "reu4m")
#                exitoptions="-\"expansion attach reu 4096\""
#                reu_enabled=1
#            ;;
#        "reu8m")
#                exitoptions="-\"expansion attach reu 8192\""
#                reu_enabled=1
#            ;;
#        "reu16m")
#                exitoptions="-\"expansion attach reu 16384\""
#                reu_enabled=1
#            ;;
        "geo512k")
                exitoptions="-\"expansion attach georam 512\""
                georam_enabled=1
            ;;
#        "plus60k")
#                exitoptions="-memoryexphack 2"
#                plus60k_enabled=1
#            ;;
#        "plus256k")
#                exitoptions="-memoryexphack 3"
#                plus256k_enabled=1
#            ;;
#        "dqbb")
#                exitoptions="-dqbb"
#                dqbb_enabled=1
#            ;;
#        "ramcart128k")
#                exitoptions="-ramcart -ramcartsize 128"
#                ramcart_enabled=1
#            ;;
#        "isepic")
#                exitoptions="-isepicswitch -isepic"
#                isepic_enabled=1
#            ;;
        *)
                exitoptions=""
                if [ "${1:0:9}" == "mountd64:" ]; then
# TODO: attach d64 to drive 8
                    exitoptions="-8 $2/${1:9}"
                    mounted_d64="${1:9}"
                    echo -ne "(disk:${1:9}) "
                fi
                if [ "${1:0:9}" == "mountd71:" ]; then
# TODO: switch drive 8 to 1571, attach d64 to drive 8
                    exitoptions="-drive8type 1571 -8 $2/${1:9}"
                    mounted_d64="${1:9}"
                    echo -ne "(disk:${1:9}) "
                fi
                if [ "${1:0:9}" == "mountg64:" ]; then
# TODO: attach g64 to drive 8
                    exitoptions="-8 $2/${1:9}"
                    mounted_g64="${1:9}"
                    echo -ne "(disk:${1:9}) "
                fi
                if [ "${1:0:9}" == "mountp64:" ]; then
# TODO: attach p64 to drive 8
                    exitoptions="-8 $2/${1:9}"
                    mounted_p64="${1:9}"
                    echo -ne "(disk:${1:9}) "
                fi
                if [ "${1:0:9}" == "mountcrt:" ]; then
# TODO: attach cartridge (.crt)
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
                exitoptions="-\"c64 init PAL\""
            ;;
        "NTSC")
                exitoptions="-\"c64 init NTSC\""
            ;;
        "NTSCOLD")
                exitoptions="-\"c64 init NTSC_OLD\""
            ;;
        "6569") # "old" PAL
                exitoptions="-\"vic set REVISION PAL_6569_R1\""
            ;;
        "8565") # "new" PAL
                exitoptions="-\"vic set REVISION PAL_8565\""
            ;;
        "6567") # "old" NTSC
                exitoptions="-\"vic set REVISION NTSC_6567\""
            ;;
        "8562") # "new" NTSC
                exitoptions="-\"vic set REVISION NTSC_8562\""
            ;;
        "6526") # "old" CIA
                exitoptions="-\"cia1 set REVISION MOS_6526\" -\"cia2 set REVISION MOS_6526\""
            ;;
        "6526A") # "new" CIA
                exitoptions="-\"cia1 set REVISION MOS_8521\" -\"cia2 set REVISION MOS_8521\""
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
        echo $VIRTUALC64 $VIRTUALC64OPTS $VIRTUALC64OPTSSCREENSHOT ${@:5} "-\"regression set WATCHDOG\"" "$3" "-\"screenshot save\"" "$1"/.testbench/"$screenshottest"-virtualc64.raw "-\"regression run\"" "$4"
        $VIRTUALC64 $VIRTUALC64OPTS $VIRTUALC64OPTSSCREENSHOT ${@:5} "-\"regression set WATCHDOG\"" "$3" "-\"screenshot save\"" "$1"/.testbench/"$screenshottest"-virtualc64.raw "-\"regression run\"" "$4"
#2> /dev/null | grep "cycles elapsed" | tr '\n' ' '
        exitcode=${PIPESTATUS[0]}
    else
        $VIRTUALC64 $VIRTUALC64OPTS $VIRTUALC64OPTSSCREENSHOT ${@:5} "-\"regression set WATCHDOG\"" "$3" "-\"screenshot save\"" "$1"/.testbench/"$screenshottest"-virtualc64.raw "-\"regression run\"" "$4"
#1> /dev/null 2> /dev/null
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
# TODO: convert raw texture to png. make sure both pal/ntsc work here!
            magick -depth 8 -size 716x285 rgb:"$1"/.testbench/"$screenshottest"-virtualc64.raw "$1"/.testbench/"$screenshottest"-virtualc64.png
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
        echo $VIRTUALC64 $VIRTUALC64OPTS $VIRTUALC64OPTSEXITCODE ${@:5} "-\"regression set WATCHDOG\"" "$3" "-\"regression run\"" "$4"
        $VIRTUALC64 $VIRTUALC64OPTS $VIRTUALC64OPTSEXITCODE ${@:5} "-\"regression set WATCHDOG\"" "$3" "-\"regression run\"" "$4"
#2> /dev/null | grep "cycles elapsed" | tr '\n' ' '
        exitcode=${PIPESTATUS[0]}
    else
        $VIRTUALC64 $VIRTUALC64OPTS $VIRTUALC64OPTSEXITCODE ${@:5} "-\"regression set WATCHDOG\"" "$3" "-\"regression run\"" "$4"
#1> /dev/null 2> /dev/null
        exitcode=$?
    fi
    if [ $verbose == "1" ]; then
        echo $VIRTUALC64 "exited with: " $exitcode
    fi
}
