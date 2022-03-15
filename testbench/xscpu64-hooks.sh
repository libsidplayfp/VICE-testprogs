
XSCPU64OPTS+=" -default"
XSCPU64OPTS+=" -VICIIfilter 0"
XSCPU64OPTS+=" -VICIIextpal"
XSCPU64OPTS+=" -VICIIpalette pepto-pal.vpl"
XSCPU64OPTS+=" -warp"
#XSCPU64OPTS+=" -console"
XSCPU64OPTS+=" -debugcart"
XSCPU64OPTS+=" -jamaction 1"
XSCPU64OPTS+=" -drive8extend 0"

# extra options for the different ways tests can be run
# FIXME: the emulators may crash when making screenshots when emu was started
#        with -console
XSCPU64OPTSEXITCODE+=" -console"
XSCPU64OPTSSCREENSHOT+=" -minimized"

# X and Y offsets for saved screenshots. when saving a screenshot in the
# computers reset/startup screen, the offset gives the top left pixel of the
# top left character on screen.
XSCPU64SXO=32
XSCPU64SYO=35

XSCPU64REFSXO=32
XSCPU64REFSYO=35

function xscpu64_check_environment
{
    XSCPU64="$EMUDIR"xscpu64

    emu_default_videosubtype="8565"
}

# $1  option
# $2  test path
function xscpu64_get_options
{
#    echo xscpu64_get_options "$1" "$2"
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
                if [ "${1:0:9}" == "mountg64:" ]; then
                    exitoptions="-8 $2/${1:9}"
                    mounted_g64="${1:9}"
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
function xscpu64_get_cmdline_options
{
#    echo xscpu64_get_cmdline_options "$1" "$2"
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
function xscpu64_prepare
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
function xscpu64_run_screenshot
{
    if [ "$2" == "" ] ; then
        screenshottest="$mounted_crt"
    else
        screenshottest="$2"
    fi

    mkdir -p "$1"/".testbench"
    rm -f "$1"/.testbench/"$screenshottest"-x64sc.png
    if [ $verbose == "1" ]; then
        echo $XSCPU64 $XSCPU64OPTS $XSCPU64OPTSSCREENSHOT ${@:5} "-limitcycles" "$3" "-exitscreenshot" "$1"/.testbench/"$screenshottest"-x64sc.png "$4"
    fi
    $XSCPU64 $XSCPU64OPTS $XSCPU64OPTSSCREENSHOT ${@:5} "-limitcycles" "$3" "-exitscreenshot" "$1"/.testbench/"$screenshottest"-x64sc.png "$4" 1> /dev/null 2> /dev/null
    exitcode=$?
    
    if [ $verbose == "1" ]; then
        echo $XSCPU64 "exited with: " $exitcode
    fi
    
    if [ $exitcode -ne 0 ]
    then
        if [ $exitcode -ne 1 ]
        then
            if [ $exitcode -ne 255 ]
            then
                echo -ne "\nerror: call to $XSCPU64 failed.\n"
                exit -1
            fi
        fi
    fi

    if [ $exitcode -eq 0 ] || [ $exitcode -eq 255 ]
    then
        if [ -f "$refscreenshotname" ]
        then
        
            # defaults for PAL
            XSCPU64REFSXO=32
            XSCPU64REFSYO=35
            XSCPU64SXO=32
            XSCPU64SYO=35
            
    #        echo [ "${refscreenshotvideotype}" "${videotype}" ]
        
            if [ "${refscreenshotvideotype}" == "NTSC" ]; then
                XSCPU64REFSXO=32
                XSCPU64REFSYO=23
            fi
        
            # when either the testbench was run with --ntsc, or the test is ntsc-specific,
            # then we need the offsets on the NTSC screenshot
            if [ "${videotype}" == "NTSC" ] || [ "${testprogvideotype}" == "NTSC" ]; then
                XSCPU64SXO=32
                XSCPU64SYO=23
            fi
        
            ./cmpscreens "$refscreenshotname" "$XSCPU64REFSXO" "$XSCPU64REFSYO" "$1"/.testbench/"$screenshottest"-x64sc.png "$XSCPU64SXO" "$XSCPU64SYO"
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
function xscpu64_run_exitcode
{
    if [ $verbose == "1" ]; then
        echo $XSCPU64 $XSCPU64OPTS $XSCPU64OPTSEXITCODE ${@:5} "-limitcycles" "$3" "$4"
    fi
    $XSCPU64 $XSCPU64OPTS $XSCPU64OPTSEXITCODE ${@:5} "-limitcycles" "$3" "$4" 1> /dev/null 2> /dev/null
    exitcode=$?
#    echo "exited with: " $exitcode
}
