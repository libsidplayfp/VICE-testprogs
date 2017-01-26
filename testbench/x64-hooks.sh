
X64="$VICEDIR"/x64
X64OPTS+=" -default"
X64OPTS+=" -VICIIfilter 0"
X64OPTS+=" -VICIIextpal"
X64OPTS+=" -VICIIpalette pepto-pal.vpl"
X64OPTS+=" -warp"
X64OPTS+=" -debugcart"
#X64OPTS+=" -console"

# extra options for the different ways tests can be run
# FIXME: the emulators may crash when making screenshots when emu was started
#        with -console
X64OPTSEXITCODE+=" -console"
X64OPTSSCREENSHOT+=""

# X and Y offsets for saved screenshots. when saving a screenshot in the
# computers reset/startup screen, the offset gives the top left pixel of the
# top left character on screen.
#
# for PAL use  32x35
# for NTSC use 32x23
X64SXO=32
X64SYO=35

# the same for the reference screenshots
X64REFSXO=32
X64REFSYO=35

# $1  option
# $2  test path
function x64_get_options
{
#    echo x64_get_options "$1"
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
function x64_get_cmdline_options
{
#    echo x64_get_cmdline_options "$1"
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
        "8565") # "new" PAL
                exitoptions="-VICIImodel 8565"
            ;;
        "8562") # "new" NTSC
                exitoptions="-VICIImodel 8562"
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
function x64_run_screenshot
{
    extraopts=""$4" "$5" "$6""
#    echo $X64 "$1"/"$2"
    mkdir -p "$1"/".testbench"
    rm -f "$1"/.testbench/"$2"-x64.png
#    echo $X64 $X64OPTS $X64OPTSSCREENSHOT $extraopts "-limitcycles" "$3" "-exitscreenshot" "$1"/.testbench/"$2"-x64.png "$1"/"$2"
    $X64 $X64OPTS $X64OPTSSCREENSHOT $extraopts "-limitcycles" "$3" "-exitscreenshot" "$1"/.testbench/"$2"-x64.png "$1"/"$2" 1> /dev/null
    exitcode=$?
    if [ $exitcode -ne 0 ]
    then
        if [ $exitcode -ne 1 ]
        then
            if [ $exitcode -ne 255 ]
            then
                echo -ne "\nerror: call to $X64 failed.\n"
                exit -1
            fi
        fi
    fi
    if [ -f "$refscreenshotname" ]
    then
    
        # defaults for PAL
        X64REFSXO=32
        X64REFSYO=35
        X64SXO=32
        X64SYO=35
    
        if [ "${refscreenshotvideotype}" == "NTSC" ]; then
            X64REFSXO=32
            X64REFSYO=23
        fi

        if [ "${videotype}" == "NTSC" ]; then
            X64SXO=32
            X64SYO=23
        fi

        ./cmpscreens "$refscreenshotname" "$X64REFSXO" "$X64REFSYO" "$1"/.testbench/"$2"-x64.png "$X64SXO" "$X64SYO"
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
# exit when write to d7ff occurs - the value written determines success (=1) or fail (other > 1)
# exit after $timeout cycles
# save a screenshot at exit (?)

# $1  test path
# $2  test program name
# $3  timeout cycles
function x64_run_exitcode
{
    extraopts=""$4" "$5" "$6""
#    echo $X64 $X64OPTS $X64OPTSEXITCODE $extraopts "-limitcycles" "$3" "$1"/"$2"
    $X64 $X64OPTS $X64OPTSEXITCODE $extraopts "-limitcycles" "$3" "$1"/"$2" 1> /dev/null
    exitcode=$?
#    echo "exited with: " $exitcode
}
