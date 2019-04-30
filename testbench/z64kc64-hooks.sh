
Z64KC64OPTS+=" -default"
Z64KC64OPTS+=" -VICIIfilter 0"
Z64KC64OPTS+=" -VICIIextpal"
Z64KC64OPTS+=" -VICIIpalette pepto-pal.vpl"
Z64KC64OPTS+=" -warp"
Z64KC64OPTS+=" -debugcart"
Z64KC64OPTS+=" -console"

# extra options for the different ways tests can be run
#Z64KC64OPTSEXITCODE+=" -console"
#Z64KC64OPTSSCREENSHOT+=" -console"

# X and Y offsets for saved screenshots. when saving a screenshot in the
# computers reset/startup screen, the offset gives the top left pixel of the
# top left character on screen.
#
# for PAL use  32x35
# for NTSC use 32x23
Z64KC64SXO=32
Z64KC64SYO=35

# the same for the reference screenshots
Z64KC64REFSXO=32
Z64KC64REFSYO=35

function z64kc64_check_environment
{
    Z64KC64="java -jar"
    Z64KC64+=" $EMUDIR"Z64K.jar" c64 "
#    Z64KC64+=" $EMUDIR"Z64KNewUI.jar" c64 "
#    Z64KC64+=" $EMUDIR"C64_Beta_2017_03_08b.jar
    
    if ! [ -x "$(command -v java)" ]; then
        echo 'Error: java not installed.' >&2
        exit 1
    fi
    
    # is this correct?
    emu_default_videosubtype="6569"
}

# $1  option
# $2  test path
function z64kc64_get_options
{
#    echo z64kc64_get_options "$1" "$2"
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
#                    exitoptions="-VICIImodel 6569"
                    testprogvideosubtype="6569"
                fi
                if [ x"$testprogvideotype"x == x"NTSC"x ]; then
                    # "old" NTSC
#                    exitoptions="-VICIImodel 6562"
                    testprogvideosubtype="6562"
                fi
            ;;
        "vicii-new") 
                if [ x"$testprogvideotype"x == x"PAL"x ]; then
                    # "new" PAL
#                    exitoptions="-VICIImodel 8565"
                    testprogvideosubtype="8565early"
                fi
                if [ x"$testprogvideotype"x == x"NTSC"x ]; then
                    # "new" NTSC
#                    exitoptions="-VICIImodel 8562"
                    testprogvideosubtype="8562early"
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
        "reu512k")
                exitoptions="-reu -reusize 512"
                reu_enabled=1
            ;;
#        "geo256k")
#                exitoptions="-georam -georamsize 256"
#                georam_enabled=1
#            ;;
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
function z64kc64_get_cmdline_options
{
#    echo z64kc64_get_cmdline_options "$1" "$2"
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
#        "6569") # "old" PAL
#                exitoptions="-VICIImodel 6569"
#            ;;
#        "8565") # "new" PAL
#                exitoptions="-VICIImodel 8565"
#            ;;
#        "8562") # "new" NTSC
#                exitoptions="-VICIImodel 8562"
#            ;;
    esac
}

# called once before any tests run
function z64kc64_prepare
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
function z64kc64_run_screenshot
{
    if [ "$2" == "" ] ; then
        screenshottest="$mounted_crt"
    else
        screenshottest="$2"
    fi

    mkdir -p "$1"/".testbench"
    rm -f "$1"/.testbench/"$screenshottest"-z64kc64.png
    if [ $verbose == "1" ]; then
        echo "RUN: "$Z64KC64 $Z64KC64OPTS $Z64KC64OPTSSCREENSHOT ${@:5} "-limitcycles" "$3" "-exitscreenshot" "$1"/.testbench/"$screenshottest"-z64kc64.png "$4"
    fi
    $Z64KC64 $Z64KC64OPTS $Z64KC64OPTSSCREENSHOT ${@:5} "-limitcycles" "$3" "-exitscreenshot" "$1"/.testbench/"$screenshottest"-z64kc64.png "$4" 1> /dev/null 2> /dev/null
    exitcode=$?
#    echo exitcode:$exitcode
    if [ $exitcode -ne 0 ]
    then
        if [ $exitcode -ne 1 ]
        then
            if [ $exitcode -ne 255 ]
            then
                echo -ne "\nerror: call to $Z64KC64 failed.\n"
                exit -1
            fi
        fi
    fi
    if [ -f "$refscreenshotname" ]
    then
    
        # defaults for PAL
        Z64KC64REFSXO=32
        Z64KC64REFSYO=35
        Z64KC64SXO=32
        Z64KC64SYO=35
    
        if [ "${refscreenshotvideotype}" == "NTSC" ]; then
            Z64KC64REFSXO=32
            Z64KC64REFSYO=23
        fi

        # when either the testbench was run with --ntsc, or the test is ntsc-specific,
        # then we need the offsets on the NTSC screenshot
        if [ "${videotype}" == "NTSC" ] || [ "${testprogvideotype}" == "NTSC" ]; then
            Z64KC64SXO=32
            Z64KC64SYO=23
        fi

#        echo "refscreenshotvideotype:" ${refscreenshotvideotype}
#        echo "refscreenshotname:" $refscreenshotname
#        echo "screenshotname": "$1"/.testbench/"$screenshottest"-z64kc64.png
#        echo "Z64KC64SXO:"$Z64KC64SXO
#        echo "Z64KC64SYO:"$Z64KC64SYO
#        echo "Z64KC64REFSXO:"$Z64KC64REFSXO
#        echo "Z64KC64REFSYO:"$Z64KC64REFSYO
        
        ./cmpscreens "$refscreenshotname" "$Z64KC64REFSXO" "$Z64KC64REFSYO" "$1"/.testbench/"$screenshottest"-z64kc64.png "$Z64KC64SXO" "$Z64KC64SYO"
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
function z64kc64_run_exitcode
{
    if [ $verbose == "1" ]; then
        echo "RUN: "$Z64KC64 $Z64KC64OPTS $Z64KC64OPTSEXITCODE ${@:5} "-limitcycles" "$3" "$4"
    fi
    $Z64KC64 $Z64KC64OPTS $Z64KC64OPTSEXITCODE ${@:5} "-limitcycles" "$3" "$4" 1> /dev/null 2> /dev/null
    exitcode=$?
#    echo "exited with: " $exitcode
}
