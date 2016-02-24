
X64=../../trunk/vice/src/x64
X64OPTS+=" -default"
X64OPTS+=" -VICIIfilter 0"
X64OPTS+=" -VICIIextpal"
X64OPTS+=" -VICIIpalette vice.vpl"
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
SXO=32
SYO=35

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
        *)
                exitoptions=""
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
#    echo $X64 $X64OPTS $X64OPTSSCREENSHOT $extraopts "-limitcycles" "$3" "-exitscreenshot" "$1"/.testbench/"$2"-x64.png "$1"/"$2"
    rm -f "$1"/.testbench/"$2"-x64.png
    $X64 $X64OPTS $X64OPTSSCREENSHOT $extraopts "-limitcycles" "$3" "-exitscreenshot" "$1"/.testbench/"$2"-x64.png "$1"/"$2" 1> /dev/null
    exitcode=$?
    if [ $exitcode -ne 0 ]
    then
        if [ $exitcode -ne 1 ]
        then
            echo -ne "\nerror: call to $X64 failed.\n"
            exit -1
        fi
    fi
    if [ -f "$1"/references/"$2".png ]
    then
        ./cmpscreens "$1"/references/"$2".png 32 35 "$1"/.testbench/"$2"-x64.png "$SXO" "$SYO"
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
#    echo $X64 "$1"/"$2"
    $X64 $X64OPTS $X64OPTSEXITCODE $extraopts "-limitcycles" "$3" "$1"/"$2" 1> /dev/null
    exitcode=$?
#    echo "exited with: " $exitcode
}
