

# FIXME: set default config, old c64, pepto palette
HOXS64OPTS+=" -defaultsettings"
HOXS64OPTS+=" -runfast"
HOXS64OPTS+=" -debugcart"

# extra options for the different ways tests can be run
HOXS64OPTSEXITCODE+=" -nomessagebox -window-hide"
HOXS64OPTSSCREENSHOT+=" -nomessagebox -window-hide"

# X and Y offsets for saved screenshots. when saving a screenshot in the
# computers reset/startup screen, the offset gives the top left pixel of the
# top left character on screen.
HOXS64SXO=32
HOXS64SYO=35

HOXS64REFSXO=32
HOXS64REFSYO=35

function hoxs64_check_environment
{
    if [ `uname` == "Linux" ]
    then
        if ! [ -x "$(command -v wine)" ]; then
            echo 'Error: wine not installed.' >&2
            exit 1
        fi
        export WINEDEBUG=-all
        HOXS64="wine"
        HOXS64+=" $EMUDIR"hoxs64.exe
    else
        HOXS64="$EMUDIR"hoxs64.exe
        #HOXS64=hoxs64
    fi

    if [ ! -f "$EMUDIR"hoxs64.exe ]; then
        echo "Error:" $EMUDIR"hoxs64.exe does not exist."
        exit 1;
    fi

    emu_default_videosubtype="8565early"
}

# $1  option
# $2  test path
function hoxs64_get_options
{
#    echo hoxs64_get_options "$1" "$2"
    exitoptions=""
    case "$1" in
        "default")
                exitoptions=""
            ;;
        "vicii-pal")
#                exitoptions=""
                testprogvideotype="PAL"
            ;;
        "vicii-ntsc")
#                exitoptions=""
                testprogvideotype="NTSC"
            ;;
        "vicii-ntscold")
#                exitoptions=""
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
#                exitoptions="-cia-old"
                new_cia_enabled=0
            ;;
        "cia-new")
#                exitoptions="-cia-new"
                new_cia_enabled=1
            ;;
       "sid-old")
#               exitoptions="-SID6581"
                new_sid_enabled=0
           ;;
       "sid-new")
#               exitoptions="-SID8580"
                new_sid_enabled=1
           ;;
       "reu512k")
               exitoptions="-reu512k"
               reu_enabled=1
           ;;
#       "geo512k")
#               exitoptions="+NEORAMMODE=3"
#               georam_enabled=1
#           ;;
        *)
                exitoptions=""
                if [ "${1:0:9}" == "mountd64:" ]; then
                    exitoptions="-mountdisk $2/${1:9}"
                    mounted_d64="${1:9}"
                    echo -ne "(disk:${1:9}) "
                fi
                if [ "${1:0:9}" == "mountg64:" ]; then
                    exitoptions="-mountdisk $2/${1:9}"
                    mounted_g64="${1:9}"
                    echo -ne "(disk:${1:9}) "
                fi
                if [ "${1:0:9}" == "mountcrt:" ]; then
                    exitoptions="-autoload $2/${1:9}"
                    mounted_crt="${1:9}"
                    echo -ne "(cartridge:${1:9}) "
                fi
            ;;
    esac
#    echo "exitoptions:" "$exitoptions"
}

# $1  option
# $2  test path
function hoxs64_get_cmdline_options
{
#    echo hoxs64_get_cmdline_options "$1" "$2"
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
                exitoptions=""
            ;;
#        "8562") # "new" NTSC
#                exitoptions=""
#            ;;
        "6526") # "old" CIA
                exitoptions="-cia-old"
            ;;
        "6526A") # "new" CIA
                exitoptions="-cia-new"
            ;;
    esac
}

# called once before any tests run
function hoxs64_prepare
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

# exit: 0   ok
#       1   timeout
#       255 error
function hoxs64_run_screenshot
{
    if [ "$2" == "" ] ; then
        screenshottest="$mounted_crt"
    else
        screenshottest="$2"
    fi

    mkdir -p "$1"/".testbench"
    rm -f "$1"/.testbench/"$screenshottest"-hoxs64.png
    if [ $verbose == "1" ]; then
        echo $HOXS64 $HOXS64OPTS $HOXS64OPTSSCREENSHOT ${@:5} "-limitcycles" "$3" "-exitscreenshot" "$1"/.testbench/"$screenshottest"-hoxs64.png "-autoload" "$4"
    fi
    $HOXS64 $HOXS64OPTS $HOXS64OPTSSCREENSHOT ${@:5} "-limitcycles" "$3" "-exitscreenshot" "$1"/.testbench/"$screenshottest"-hoxs64.png "-autoload" "$4" 2> /dev/null
    exitcode=$?
    if [ $exitcode -ne 0 ]
    then
        if [ $exitcode -ne 1 ]
        then
            if [ $exitcode -ne 255 ]
            then
                echo -ne "\nerror: call to $HOXS64 failed. (exitcode:"$exitcode")\n"
                exit -1
            fi
        fi
    fi
    if [ $exitcode -eq 100 ]
    then
        exitcode=1;
    fi
    if [ -f "$refscreenshotname" ]
    then

        # defaults for PAL
        HOXS64REFSXO=32
        HOXS64REFSYO=35
        HOXS64SXO=32
        HOXS64SYO=35
        
#        echo [ "${refscreenshotvideotype}" "${videotype}" ]
 
# hoxs64 cant do NTSC
    
        if [ $verbose == "1" ]; then
            echo ./cmpscreens "$refscreenshotname" "$HOXS64REFSXO" "$HOXS64REFSYO" "$1"/.testbench/"$screenshottest"-hoxs64.png "$HOXS64SXO" "$HOXS64SYO"
        fi
        ./cmpscreens "$refscreenshotname" "$HOXS64REFSXO" "$HOXS64REFSYO" "$1"/.testbench/"$screenshottest"-hoxs64.png "$HOXS64SXO" "$HOXS64SYO"
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

# exit: 0   ok
#       1   timeout
#       255 error
function hoxs64_run_exitcode
{
    if [ x"$2"x == xx ]; then
        # for launching cartridges
        if [ $verbose == "1" ]; then
            echo $HOXS64 $HOXS64OPTS $HOXS64OPTSEXITCODE ${@:5} "-limitcycles" "$3"
        fi
        $HOXS64 $HOXS64OPTS $HOXS64OPTSEXITCODE ${@:5} "-limitcycles" "$3" 2> /dev/null
    else
        if [ $verbose == "1" ]; then
            echo $HOXS64 $HOXS64OPTS $HOXS64OPTSEXITCODE ${@:5} "-limitcycles" "$3" "-autoload" "$4"
        fi
        $HOXS64 $HOXS64OPTS $HOXS64OPTSEXITCODE ${@:5} "-limitcycles" "$3" "-autoload" "$4" 2> /dev/null
    fi
    exitcode=$?
    if [ $verbose == "1" ]; then
        echo $HOXS64 "exited with: " $exitcode
    fi
    if [ $exitcode -eq 100 ]
    then
        exitcode=1;
    fi
}
