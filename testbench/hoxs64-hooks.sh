

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
}

# $1  option
# $2  test path
function hoxs64_get_options
{
#    echo hoxs64_get_options "$1"
    exitoptions=""
    case "$1" in
        "default")
                exitoptions=""
            ;;
        # FIXME: the returned options must be the same as for VICE to make the
        #        selective test-runs work
        "vicii-pal")
                exitoptions=""
            ;;
#        "vicii-ntsc")
#                exitoptions=""
#            ;;
#        "vicii-ntscold")
#                exitoptions=""
#            ;;
        "cia-old")
                exitoptions="-cia-old"
            ;;
        "cia-new")
                exitoptions="-cia-new"
            ;;
#       "sid-old")
#               exitoptions="-SID6581"
#           ;;
#       "sid-new")
#               exitoptions="-SID8580"
#           ;;
#       "reu512k")
#               exitoptions="+REUMODE=3"
#               reu_enabled=1
#           ;;
#       "geo256k")
#               exitoptions="+NEORAMMODE=2"
#               georam_enabled=1
#           ;;
        *)
                exitoptions=""
                if [ "${1:0:9}" == "mountd64:" ]; then
                    exitoptions="-mountdisk $2/${1:9}"
                    echo -ne "(disk:${1:9}) "
                fi
                if [ "${1:0:9}" == "mountg64:" ]; then
                    exitoptions="-mountdisk $2/${1:9}"
                    echo -ne "(disk:${1:9}) "
                fi
                if [ "${1:0:9}" == "mountcrt:" ]; then
                    exitoptions="-autoload $2/${1:9}"
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
#    echo hoxs64_get_cmdline_options "$1"
    exitoptions=""
    case "$1" in
        # FIXME: the returned options must be the same as for VICE to make the
        #        selective test-runs work
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


################################################################################
# reset
# run test program
# exit when write to d7ff occurs (any value)
# exit after $timeout cycles
# save a screenshot at exit - success or failure is determined by comparing screenshots

# $1  test path
# $2  test program name
# $3  timeout cycles

# exit: 0   ok
#       1   timeout
#       255 error
function hoxs64_run_screenshot
{
    extraopts=""$4" "$5" "$6""
#    echo $HOXS64 "$1"/"$2"
    mkdir -p "$1"/".testbench"
    rm -f "$1"/.testbench/"$2"-hoxs64.png
    if [ $verbose == "1" ]; then
        echo $HOXS64 $HOXS64OPTS $HOXS64OPTSSCREENSHOT $extraopts "-limitcycles" "$3" "-exitscreenshot" "$1"/.testbench/"$2"-hoxs64.png "-autoload" "$1"/"$2"
    fi
    $HOXS64 $HOXS64OPTS $HOXS64OPTSSCREENSHOT $extraopts "-limitcycles" "$3" "-exitscreenshot" "$1"/.testbench/"$2"-hoxs64.png "-autoload" "$1"/"$2" 1> /dev/null
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
            echo ./cmpscreens "$refscreenshotname" "$HOXS64REFSXO" "$HOXS64REFSYO" "$1"/.testbench/"$2"-hoxs64.png "$HOXS64SXO" "$HOXS64SYO"
        fi
        ./cmpscreens "$refscreenshotname" "$HOXS64REFSXO" "$HOXS64REFSYO" "$1"/.testbench/"$2"-hoxs64.png "$HOXS64SXO" "$HOXS64SYO"
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

# exit: 0   ok
#       1   timeout
#       255 error
function hoxs64_run_exitcode
{
    extraopts=""$4" "$5" "$6""
#    echo "extraopts=" $extraopts
    if [ x"$2"x == xx ]; then
        # for launching cartridges
        if [ $verbose == "1" ]; then
            echo $HOXS64 $HOXS64OPTS $HOXS64OPTSEXITCODE $extraopts "-limitcycles" "$3"
        fi
        $HOXS64 $HOXS64OPTS $HOXS64OPTSEXITCODE $extraopts "-limitcycles" "$3" 1> /dev/null
#        $HOXS64 $HOXS64OPTS $extraopts "-limitcycles" "$3" "$1"/"$2"
    else
        if [ $verbose == "1" ]; then
            echo $HOXS64 $HOXS64OPTS $HOXS64OPTSEXITCODE $extraopts "-limitcycles" "$3" "-autoload" "$1"/"$2"
        fi
        $HOXS64 $HOXS64OPTS $HOXS64OPTSEXITCODE $extraopts "-limitcycles" "$3" "-autoload" "$1"/"$2" 1> /dev/null
#        $HOXS64 $HOXS64OPTS $extraopts "-limitcycles" "$3" "$1"/"$2"
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
