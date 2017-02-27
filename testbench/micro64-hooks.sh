
#MICRO64="$VICEDIR"/micro64
MICRO64=micro64
#MICRO64OPTS+=" -default"
#MICRO64OPTS+=" -model c64c"
#MICRO64OPTS+=" -model c64 -ntsc "
#MICRO64OPTS+=" -VICIIfilter 0"
#MICRO64OPTS+=" -VICIIextpal"
#MICRO64OPTS+=" -VICIIpalette pepto-pal.vpl"
MICRO64OPTS+=" -PAL"
MICRO64OPTS+=" +VICSINGLEPIXELCLOCK"
MICRO64OPTS+=" +WARP"
MICRO64OPTS+=" +DEBUGCART +AUTOSTART"
#MICRO64OPTS+=" -raminitstartvalue 255 -raminitvalueinvert 4"

# extra options for the different ways tests can be run
MICRO64OPTSEXITCODE+=" +HIDE"
MICRO64OPTSSCREENSHOT+=" +HIDE"

# X and Y offsets for saved screenshots. when saving a screenshot in the
# computers reset/startup screen, the offset gives the top left pixel of the
# top left character on screen.
MICRO64SXO=32
MICRO64SYO=40

MICRO64REFSXO=32
MICRO64REFSYO=35

# $1  option
# $2  test path
function micro64_get_options
{
#    echo micro64_get_options "$1"
    exitoptions=""
    case "$1" in
        "default")
                exitoptions=""
            ;;
        "vicii-pal")
                exitoptions=""
            ;;
        "vicii-ntsc")
                exitoptions=""
            ;;
        "vicii-ntscold")
                exitoptions=""
            ;;
        "cia-old")
                exitoptions="-CIA6526"
            ;;
        "cia-new")
                exitoptions="-CIA6526A"
            ;;
        "sid-old")
                exitoptions="-SID6581"
            ;;
        "sid-new")
                exitoptions="-SID8580"
            ;;
        "reu512k")
                exitoptions="+REUMODE=3"
                reu_enabled=1
            ;;
        "geo256k")
                exitoptions="+NEORAMMODE=2"
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
function micro64_get_cmdline_options
{
#    echo micro64_get_cmdline_options "$1"
    exitoptions=""
    case "$1" in
        "PAL")
                exitoptions=""
            ;;
        "NTSC")
                exitoptions=""
            ;;
        "NTSCOLD")
                exitoptions=""
            ;;
        "8565") # "new" PAL
                exitoptions="-VIC8565"
            ;;
        "8562") # "new" NTSC
                exitoptions=""
            ;;
        "6526") # "old" CIA
                exitoptions="-CIA6526"
            ;;
        "6526A") # "new" CIA
                exitoptions="-CIA6526A"
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
function micro64_run_screenshot
{
    extraopts=""$4" "$5" "$6""
#    echo $MICRO64 "$1"/"$2"
    mkdir -p "$1"/".testbench"
    rm -f "$1"/.testbench/"$2"-micro64.png
    if [ $verbose == "1" ]; then
        echo $MICRO64 $MICRO64OPTS $MICRO64OPTSSCREENSHOT $extraopts "+DEBUGLIMITCYCLES=""$3" "+DEBUGEXITVICBITMAP=""$1"/.testbench/"$2"-micro64.png "$1"/"$2"
    fi
    $MICRO64 $MICRO64OPTS $MICRO64OPTSSCREENSHOT $extraopts "+DEBUGLIMITCYCLES=""$3" "+DEBUGEXITVICBITMAP=""$1"/.testbench/"$2"-micro64.png "$1"/"$2" 1> /dev/null
    exitcode=$?
    if [ $exitcode -ne 0 ]
    then
        if [ $exitcode -ne 1 ]
        then
            if [ $exitcode -ne 255 ]
            then
                echo -ne "\nerror: call to $MICRO64 failed.\n"
                exit -1
            fi
        fi
    fi
    if [ -f "$refscreenshotname" ]
    then

        # defaults for PAL
        MICRO64REFSXO=32
        MICRO64REFSYO=35
        MICRO64SXO=32
        MICRO64SYO=40
        
#        echo [ "${refscreenshotvideotype}" "${videotype}" ]
 
# micro64 cant do NTSC
#        if [ "${refscreenshotvideotype}" == "NTSC" ]; then
#            MICRO64REFSXO=32
#            MICRO64REFSYO=23
#        fi
#    
#        if [ "${videotype}" == "NTSC" ]; then
#            MICRO64SXO=32
#            MICRO64SYO=23
#        fi
    
        if [ $verbose == "1" ]; then
            echo ./cmpscreens "$refscreenshotname" "$MICRO64REFSXO" "$MICRO64REFSYO" "$1"/.testbench/"$2"-micro64.png "$MICRO64SXO" "$MICRO64SYO"
        fi
        ./cmpscreens "$refscreenshotname" "$MICRO64REFSXO" "$MICRO64REFSYO" "$1"/.testbench/"$2"-micro64.png "$MICRO64SXO" "$MICRO64SYO"
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
function micro64_run_exitcode
{
    extraopts=""$4" "$5" "$6""
#    echo "extraopts=" $extraopts
    if [ $verbose == "1" ]; then
        echo $MICRO64 $MICRO64OPTS $MICRO64OPTSEXITCODE $extraopts "+DEBUGLIMITCYCLES=""$3" "$1"/"$2"
    fi
    $MICRO64 $MICRO64OPTS $MICRO64OPTSEXITCODE $extraopts "+DEBUGLIMITCYCLES=""$3" "$1"/"$2" 1> /dev/null
#    $MICRO64 $MICRO64OPTS $extraopts "-limitcycles" "$3" "$1"/"$2"
    exitcode=$?
    if [ $verbose == "1" ]; then
        echo $MICRO64 "exited with: " $exitcode
    fi
}
