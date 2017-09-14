
X128="$VICEDIR"/x128
X128OPTS+=" -default"
X128OPTS+=" -VICIIfilter 0"
X128OPTS+=" -VICIIextpal"
X128OPTS+=" -VICIIpalette pepto-pal.vpl"
X128OPTS+=" -warp"
#X128OPTS+=" -console"
X128OPTS+=" -debugcart"

# extra options for the different ways tests can be run
# FIXME: the emulators may crash when making screenshots when emu was started
#        with -console
X128OPTSEXITCODE+=" -console"
X128OPTSSCREENSHOT+=""

# X and Y offsets for saved screenshots. when saving a screenshot in the
# computers reset/startup screen, the offset gives the top left pixel of the
# top left character on screen.
X128SXO=32
X128SYO=35

X128REFSXO=32
X128REFSYO=35

# $1  option
# $2  test path
function x128_get_options
{
#    echo x128_get_options "$1"
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
function x128_get_cmdline_options
{
#    echo x128_get_cmdline_options "$1"
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
# exit when write to d7ff occurs (any value)
# exit after $timeout cycles
# save a screenshot at exit - success or failure is determined by comparing screenshots

# $1  test path
# $2  test program name
# $3  timeout cycles
function x128_run_screenshot
{
    extraopts=""$4" "$5" "$6""
#    echo $X128 "$1"/"$2"
    mkdir -p "$1"/".testbench"
    rm -f "$1"/.testbench/"$2"-x128.png
    $X128 $X128OPTS $X128OPTSSCREENSHOT $extraopts "-limitcycles" "$3" "-exitscreenshot" "$1"/.testbench/"$2"-x128.png "$1"/"$2" 1> /dev/null
    exitcode=$?
    if [ $exitcode -ne 0 ]
    then
        if [ $exitcode -ne 1 ]
        then
            if [ $exitcode -ne 255 ]
            then
                echo -ne "\nerror: call to $X128 failed.\n"
                exit -1
            fi
        fi
    fi
    if [ -f "$refscreenshotname" ]
    then
    
        # FIXME: this only works for the VICII
    
        # defaults for PAL
        X128REFSXO=32
        X128REFSYO=35
        X128SXO=32
        X128SYO=35
        
#        echo [ "${refscreenshotvideotype}" "${videotype}" ]
    
        if [ "${refscreenshotvideotype}" == "NTSC" ]; then
            X128REFSXO=32
            X128REFSYO=23
        fi
    
        if [ "${videotype}" == "NTSC" ]; then
            X128SXO=32
            X128SYO=23
        fi

        ./cmpscreens "$refscreenshotname" "$X128REFSXO" "$X128REFSYO" "$1"/.testbench/"$2"-x128.png "$X128SXO" "$X128SYO"
        exitcode=$?
    else
        echo -ne "reference screenshot missing - "
        exitcode=255
    fi
}

################################################################################
# reset
# run test program
# exit when write to d7ff occurs - the value written determines success (=1) or fail (other > 1)
# exit after $timeout cycles
# save a screenshot at exit (?)

# $1  test path
# $2  test program name
# $3  timeout cycles
function x128_run_exitcode
{
    extraopts=""$4" "$5" "$6""
#    echo "extraopts=" $extraopts
#    echo $X128 $X128OPTS $extraopts "-limitcycles" "$3" "$1"/"$2"
    $X128 $X128OPTS $X128OPTSEXITCODE $extraopts "-limitcycles" "$3" "$1"/"$2" 1> /dev/null
#    $X128 $X128OPTS $extraopts "-limitcycles" "$3" "$1"/"$2"
    exitcode=$?
#    echo "exited with: " $exitcode
}
