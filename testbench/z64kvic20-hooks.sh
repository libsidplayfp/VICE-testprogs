
Z64KVIC20OPTS+=" -default"
Z64KVIC20OPTS+=" -VICfilter 0"
#Z64KVIC20OPTS+=" -VICextpal"
Z64KVIC20OPTS+=" -VICpalette mike-pal.vpl"
Z64KVIC20OPTS+=" -warp"
Z64KVIC20OPTS+=" -debugcart"
Z64KVIC20OPTS+=" -basicload"
Z64KVIC20OPTS+=" -console"

# extra options for the different ways tests can be run
#Z64KVIC20OPTSEXITCODE+=" -console"
#Z64KVIC20OPTSSCREENSHOT+=""

# X and Y offsets for saved screenshots. when saving a screenshot in the
# computers reset/startup screen, the offset gives the top left pixel of the
# top left character on screen.
Z64KVIC20SXO=96
Z64KVIC20SYO=48

Z64KVIC20REFSXO=96
Z64KVIC20REFSYO=48

function z64kvic20_check_environment
{
    JARNAME="$EMUDIR"Z64K.jar
    Z64KVIC20="java -jar"
    Z64KVIC20+=" $JARNAME"" vic20 "

    if ! [ -f "$JARNAME" ]; then
        echo "Error: "$JARNAME" not found." >&2
        exit 1
    fi

    if ! [ -x "$(command -v java)" ]; then
        echo 'Error: java not installed.' >&2
        exit 1
    fi
}

# $1  option
# $2  test path
function z64kvic20_get_options
{
#    echo z64kvic20_get_options "$1" "$2"
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
#        "sid-old")
#                exitoptions="-sidenginemodel 256"
#                new_sid_enabled=0
#            ;;
#        "sid-new")
#                exitoptions="-sidenginemodel 257"
#                new_sid_enabled=1
#            ;;
        "vic20-8k")
                exitoptions="-memory 8k"
                memory_expansion_enabled="8K"
            ;;
        "vic20-32k")
                exitoptions="-memory all"
                memory_expansion_enabled="32K"
            ;;
        "geo512k")
                exitoptions="-georam -georamsize 512"
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
function z64kvic20_get_cmdline_options
{
#    echo z64kvic20_get_cmdline_options "$1" "$2"
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
                exitoptions="-8k"
            ;;
        "32K")
                exitoptions="-full"
            ;;
    esac
}

# called once before any tests run
function z64kvic20_prepare
{
    true
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
function z64kvic20_run_screenshot
{
    if [ "$2" == "" ] ; then
        screenshottest="$mounted_crt"
    else
        screenshottest="$2"
    fi

    mkdir -p "$1"/".testbench"
    rm -f "$1"/.testbench/"$screenshottest"-z64kvic20.png
    if [ $verbose == "1" ]; then
        echo "RUN: "$Z64KVIC20 $Z64KVIC20OPTS $Z64KVIC20OPTSSCREENSHOT ${@:5} "-limitcycles" "$3" "-exitscreenshot" "$1"/.testbench/"$screenshottest"-z64kvic20.png "$4"
    fi
    $Z64KVIC20 $Z64KVIC20OPTS $Z64KVIC20OPTSSCREENSHOT ${@:5} "-limitcycles" "$3" "-exitscreenshot" "$1"/.testbench/"$screenshottest"-z64kvic20.png "$4" 1> /dev/null
    exitcode=$?
    if [ $exitcode -ne 0 ]
    then
        if [ $exitcode -ne 1 ]
        then
            if [ $exitcode -ne 255 ]
            then
                echo -ne "\nerror: call to $Z64KVIC20 failed with exitcode:"$exitcode"\n"
                exit -1
            fi
        fi
    fi
    if [ -f "$refscreenshotname" ]
    then
        # defaults for PAL
        Z64KVIC20SXO=96
        Z64KVIC20SYO=48
        Z64KVIC20REFSXO=96
        Z64KVIC20REFSYO=48
        
#        echo [ "${refscreenshotvideotype}" "${videotype}" ]
    
        if [ "${refscreenshotvideotype}" == "NTSC" ]; then
            Z64KVIC20REFSXO=40
            Z64KVIC20REFSYO=22
        fi
    
        # when either the testbench was run with --ntsc, or the test is ntsc-specific,
        # then we need the offsets on the NTSC screenshot
        if [ "${videotype}" == "NTSC" ] || [ "${testprogvideotype}" == "NTSC" ]; then
            Z64KVIC20SXO=40
            Z64KVIC20SYO=22
        fi

#        echo ./cmpscreens "$refscreenshotname" "$Z64KVIC20REFSXO" "$Z64KVIC20REFSYO" "$1"/.testbench/"$screenshottest"-z64kvic20.png "$Z64KVIC20SXO" "$Z64KVIC20SYO"
        ./cmpscreens "$refscreenshotname" "$Z64KVIC20REFSXO" "$Z64KVIC20REFSYO" "$1"/.testbench/"$screenshottest"-z64kvic20.png "$Z64KVIC20SXO" "$Z64KVIC20SYO"
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
function z64kvic20_run_exitcode
{
    if [ $verbose == "1" ]; then
        echo "RUN: "$Z64KVIC20 $Z64KVIC20OPTS $Z64KVIC20OPTSEXITCODE ${@:5} "-limitcycles" "$3" "$4"
    fi
    $Z64KVIC20 $Z64KVIC20OPTS $Z64KVIC20OPTSEXITCODE ${@:5} "-limitcycles" "$3" "$4" 1> /dev/null
    exitcode=$?
#    echo "exited with: " $exitcode
}
