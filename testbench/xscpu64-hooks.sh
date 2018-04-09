
XSCPU64OPTS+=" -default"
XSCPU64OPTS+=" -VICIIfilter 0"
XSCPU64OPTS+=" -VICIIextpal"
XSCPU64OPTS+=" -VICIIpalette pepto-pal.vpl"
XSCPU64OPTS+=" -warp"
#XSCPU64OPTS+=" -console"
XSCPU64OPTS+=" -debugcart"

# extra options for the different ways tests can be run
# FIXME: the emulators may crash when making screenshots when emu was started
#        with -console
XSCPU64OPTSEXITCODE+=" -console"
XSCPU64OPTSSCREENSHOT+=""

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

################################################################################
# reset
# run test program
# exit when write to $d7ff occurs - the value written determines success (=$00) or fail (=$ff)
# exit after $timeout cycles (exitcode=$01)
# save a screenshot at exit - success or failure is determined by comparing screenshots

# $1  test path
# $2  test program name
# $3  timeout cycles
function xscpu64_run_screenshot
{
    extraopts=""$4" "$5" "$6""
#    echo $XSCPU64 "$1"/"$2"
    mkdir -p "$1"/".testbench"
    rm -f "$1"/.testbench/"$2"-x64sc.png
    $XSCPU64 $XSCPU64OPTS $XSCPU64OPTSSCREENSHOT $extraopts "-limitcycles" "$3" "-exitscreenshot" "$1"/.testbench/"$2"-x64sc.png "$1"/"$2" 1> /dev/null
    exitcode=$?
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
    
        ./cmpscreens "$refscreenshotname" "$XSCPU64REFSXO" "$XSCPU64REFSYO" "$1"/.testbench/"$2"-x64sc.png "$XSCPU64SXO" "$XSCPU64SYO"
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
function xscpu64_run_exitcode
{
    extraopts=""$4" "$5" "$6""
#    echo "extraopts=" $extraopts
#    echo $XSCPU64 $XSCPU64OPTS $extraopts "-limitcycles" "$3" "$1"/"$2"
    $XSCPU64 $XSCPU64OPTS $XSCPU64OPTSEXITCODE $extraopts "-limitcycles" "$3" "$1"/"$2" 1> /dev/null
#    $XSCPU64 $XSCPU64OPTS $extraopts "-limitcycles" "$3" "$1"/"$2"
    exitcode=$?
#    echo "exited with: " $exitcode
}
