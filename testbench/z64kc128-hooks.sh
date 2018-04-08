
Z64KC128OPTS+=" -default"
Z64KC128OPTS+=" -VICIIfilter 0"
Z64KC128OPTS+=" -VICIIextpal"
Z64KC128OPTS+=" -VICIIpalette pepto-pal.vpl"
Z64KC128OPTS+=" -warp"
#Z64KC128OPTS+=" -console"
Z64KC128OPTS+=" -debugcart"

# extra options for the different ways tests can be run
Z64KC128OPTSEXITCODE+=" -console"
Z64KC128OPTSSCREENSHOT+=""

# X and Y offsets for saved screenshots. when saving a screenshot in the
# computers reset/startup screen, the offset gives the top left pixel of the
# top left character on screen.
Z64KC128SXO=32
Z64KC128SYO=35

Z64KC128REFSXO=32
Z64KC128REFSYO=35

function z64kc128_check_environment
{
    Z64KC128="java -jar"
#    Z64KC128+=" $EMUDIR"Z64KNewUI.jar" c128 "
    Z64KC128+=" $EMUDIR"C128_Beta_2017_03_13.jar
    
    if ! [ -x "$(command -v java)" ]; then
        echo 'Error: java not installed.' >&2
        exit 1
    fi
}

# $1  option
# $2  test path
function z64kc128_get_options
{
#    echo z64kc128_get_options "$1"
    exitoptions=""
    case "$1" in
        "default")
                exitoptions=""
            ;;
        "vicii-pal")
                exitoptions="-pal"
            ;;
        "vicii-ntsc")
                exitoptions="-ntsc"
            ;;
        "vicii-ntscold")
                exitoptions="-ntscold"
            ;;
        "cia-old")
                exitoptions="-ciamodel 0"
            ;;
        "cia-new")
                exitoptions="-ciamodel 1"
            ;;
        "sid-old")
                exitoptions="-sidenginemodel 256"
            ;;
        "sid-new")
                exitoptions="-sidenginemodel 257"
            ;;
        "reu512k")
                exitoptions="-reu -reusize 512"
                reu_enabled=1
            ;;
        "geo256k")
                exitoptions="-georam -georamsize 256"
                georam_enabled=1
            ;;
        "efnram")
                exitoptions="-extfunc 2"
                extfuncram_enabled=1
            ;;
        "ifnram")
                exitoptions="-intfunc 2"
                intfuncram_enabled=1
            ;;
        "c128fullbanks")
                exitoptions="-c128fullbanks"
                fullbanks_enabled=1
            ;;
#        "ramcart128k")
#                exitoptions="-ramcart -ramcartsize 128"
#                ramcart_enabled=1
#            ;;
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
                if [ "${1:0:9}" == "mountcrt:" ]; then
                    exitoptions="-cartcrt $2/${1:9}"
                    echo -ne "(cartridge:${1:9}) "
                fi
            ;;
    esac
}

# $1  option
# $2  test path
function z64kc128_get_cmdline_options
{
#    echo z64kc128_get_cmdline_options "$1"
    exitoptions=""
    case "$1" in
        "PAL")
                exitoptions="-pal"
            ;;
        "NTSC")
                exitoptions="-ntsc"
            ;;
        "6569") # "old" PAL
                exitoptions="-VICIImodel 6569"
            ;;
    esac
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
function z64kc128_run_screenshot
{
    extraopts=""$4" "$5" "$6""
#    echo $Z64KC128 "$1"/"$2"
    mkdir -p "$1"/".testbench"
    rm -f "$1"/.testbench/"$2"-z64kc128.png
    $Z64KC128 $Z64KC128OPTS $Z64KC128OPTSSCREENSHOT $extraopts "-limitcycles" "$3" "-exitscreenshot" "$1"/.testbench/"$2"-z64kc128.png "$1"/"$2" 1> /dev/null
    exitcode=$?
    if [ $exitcode -ne 0 ]
    then
        if [ $exitcode -ne 1 ]
        then
            if [ $exitcode -ne 255 ]
            then
                echo -ne "\nerror: call to $Z64KC128 failed.\n"
                exit -1
            fi
        fi
    fi
    if [ -f "$refscreenshotname" ]
    then
    
        # FIXME: this only works for the VICII
    
        # defaults for PAL
        Z64KC128REFSXO=32
        Z64KC128REFSYO=35
        Z64KC128SXO=32
        Z64KC128SYO=35
        
#        echo [ "${refscreenshotvideotype}" "${videotype}" ]
    
        if [ "${refscreenshotvideotype}" == "NTSC" ]; then
            Z64KC128REFSXO=32
            Z64KC128REFSYO=23
        fi
    
        if [ "${videotype}" == "NTSC" ]; then
            Z64KC128SXO=32
            Z64KC128SYO=23
        fi

        ./cmpscreens "$refscreenshotname" "$Z64KC128REFSXO" "$Z64KC128REFSYO" "$1"/.testbench/"$2"-z64kc128.png "$Z64KC128SXO" "$Z64KC128SYO"
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
function z64kc128_run_exitcode
{
    extraopts=""$4" "$5" "$6""
#    echo "extraopts=" $extraopts
#    echo $Z64KC128 $Z64KC128OPTS $extraopts "-limitcycles" "$3" "$1"/"$2"
    $Z64KC128 $Z64KC128OPTS $Z64KC128OPTSEXITCODE $extraopts "-limitcycles" "$3" "$1"/"$2" 1> /dev/null
#    $Z64KC128 $Z64KC128OPTS $extraopts "-limitcycles" "$3" "$1"/"$2"
    exitcode=$?
#    echo "exited with: " $exitcode
}
