
X64DTV=../../trunk/vice/src/x64dtv
X64DTVOPTS+=" -default"
X64DTVOPTS+=" -VICIIfilter 0"
X64DTVOPTS+=" -VICIIextpal"
#X64DTVOPTS+=" -VICIIpalette vice.vpl"
X64DTVOPTS+=" -warp"
#X64DTVOPTS+=" -console"
X64DTVOPTS+=" -debugcart"

# extra options for the different ways tests can be run
# FIXME: the emulators may crash when making screenshots when emu was started
#        with -console
X64DTVOPTSEXITCODE+=" -console"
X64DTVOPTSSCREENSHOT+=""

# X and Y offsets for saved screenshots. when saving a screenshot in the
# computers reset/startup screen, the offset gives the top left pixel of the
# top left character on screen.
X64DTVSXO=32
X64DTVSYO=35

# $1  option
# $2  test path
function x64dtv_get_options
{
#    echo x64dtv_get_options "$1"
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
function x64dtv_run_screenshot
{
    extraopts=""$4" "$5" "$6""
#    echo $X64DTV "$1"/"$2"
    mkdir -p "$1"/".testbench"
    rm -f "$1"/.testbench/"$2"-x64sc.png
    $X64DTV $X64DTVOPTS $X64DTVOPTSSCREENSHOT $extraopts "-limitcycles" "$3" "-exitscreenshot" "$1"/.testbench/"$2"-x64sc.png "$1"/"$2" 1> /dev/null
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
        ./cmpscreens "$1"/references/"$2".png 32 35 "$1"/.testbench/"$2"-x64sc.png "$X64DTVSXO" "$X64DTVSYO"
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
function x64dtv_run_exitcode
{
    extraopts=""$4" "$5" "$6""
#    echo "extraopts=" $extraopts
#    echo $X64DTV $X64DTVOPTS $extraopts "-limitcycles" "$3" "$1"/"$2"
    $X64DTV $X64DTVOPTS $X64DTVOPTSEXITCODE $extraopts "-limitcycles" "$3" "$1"/"$2" 1> /dev/null
#    $X64DTV $X64DTVOPTS $extraopts "-limitcycles" "$3" "$1"/"$2"
    exitcode=$?
#    echo "exited with: " $exitcode
}
