
X64SC=../../trunk/vice/src/x64sc
X64SCOPTS+=" -default"
X64SCOPTS+=" -VICIIfilter 0"
X64SCOPTS+=" -VICIIextpal"
X64SCOPTS+=" -VICIIpalette vice.vpl"
X64SCOPTS+=" -warp"
#X64SCOPTS+=" -console"
X64SCOPTS+=" -debugcart"

# extra options for the different ways tests can be run
# FIXME: the emulators may crash when making screenshots when emu was started
#        with -console
X64SCOPTSEXITCODE+=" -console"
X64SCOPTSSCREENSHOT+=""

# X and Y offsets for saved screenshots. when saving a screenshot in the
# computers reset/startup screen, the offset gives the top left pixel of the
# top left character on screen.
X64SCSXO=32
X64SCSYO=35

function x64sc_get_options
{
#    echo x64sc_get_options "$1"
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
function x64sc_run_screenshot
{
    extraopts=""$4" "$5" "$6""
#    echo $X64SC "$1"/"$2"
    mkdir -p "$1"/".testbench"
    rm -f "$1"/.testbench/"$2"-x64sc.png
    $X64SC $X64SCOPTS $X64SCOPTSSCREENSHOT $extraopts "-limitcycles" "$3" "-exitscreenshot" "$1"/.testbench/"$2"-x64sc.png "$1"/"$2" 1> /dev/null
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
    if [ -f "$1"/references/"$2".png ]
    then
        ./cmpscreens "$1"/references/"$2".png 32 35 "$1"/.testbench/"$2"-x64sc.png "$X64SCSXO" "$X64SCSYO"
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
function x64sc_run_exitcode
{
    extraopts=""$4" "$5" "$6""
#    echo "extraopts=" $extraopts
#    echo $X64SC $X64SCOPTS $extraopts "-limitcycles" "$3" "$1"/"$2"
    $X64SC $X64SCOPTS $X64SCOPTSEXITCODE $extraopts "-limitcycles" "$3" "$1"/"$2" 1> /dev/null
#    $X64SC $X64SCOPTS $extraopts "-limitcycles" "$3" "$1"/"$2"
    exitcode=$?
#    echo "exited with: " $exitcode
}
