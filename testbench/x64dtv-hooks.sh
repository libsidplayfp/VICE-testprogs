
X64DTVOPTS+=" -default"
X64DTVOPTS+=" -VICIIfilter 0"
X64DTVOPTS+=" -VICIIextpal"
#X64DTVOPTS+=" -VICIIpalette pepto-pal.vpl"
X64DTVOPTS+=" -warp"
#X64DTVOPTS+=" -console"
X64DTVOPTS+=" -debugcart"
X64DTVOPTS+=" -jamaction 1"
X64DTVOPTS+=" -drive8extend 0"

# extra options for the different ways tests can be run
# FIXME: the emulators may crash when making screenshots when emu was started
#        with -console
X64DTVOPTSEXITCODE+=" -console"
#X64DTVOPTSSCREENSHOT+=" -minimized"
X64DTVOPTSSCREENSHOT+=" -console"

# X and Y offsets for saved screenshots. when saving a screenshot in the
# computers reset/startup screen, the offset gives the top left pixel of the
# top left character on screen.
X64DTVSXO=32
X64DTVSYO=35

X64DTVREFSXO=32
X64DTVREFSYO=35

function x64dtv_check_environment
{
    X64DTV="$EMUDIR"x64dtv
}

# $1  option
# $2  test path
function x64dtv_get_options
{
#    echo x64dtv_get_options "$1" "$2"
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
        *)
                exitoptions=""
                if [ "${1:0:9}" == "mountd64:" ]; then
                    exitoptions="-8 $2/${1:9}"
                    mounted_d64="${1:9}"
                    echo -ne "(disk:${1:9}) "
                fi
                if [ "${1:0:9}" == "mountg64:" ]; then
                    exitoptions="-8 $2/${1:9}"
                    mounted_g64="${1:9}"
                    echo -ne "(disk:${1:9}) "
                fi
            ;;
    esac
}

# $1  option
# $2  test path
function x64dtv_get_cmdline_options
{
#    echo x64dtv_get_cmdline_options "$1" "$2"
    exitoptions=""
    case "$1" in
        "PAL")
                exitoptions="-pal"
            ;;
        "NTSC")
                exitoptions="-ntsc"
            ;;
    esac
}

# called once before any tests run
function x64dtv_prepare
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
function x64dtv_run_screenshot
{
    if [ "$2" == "" ] ; then
        screenshottest="$mounted_crt"
    else
        screenshottest="$2"
    fi

    mkdir -p "$1"/".testbench"
    rm -f "$1"/.testbench/"$screenshottest"-x64dtv.png
    if [ $verbose == "1" ]; then
        echo $X64DTV $X64DTVOPTS $X64DTVOPTSSCREENSHOT ${@:5} "-limitcycles" "$3" "-exitscreenshot" "$1"/.testbench/"$screenshottest"-x64dtv.png "$4"
    fi
    $X64DTV $X64DTVOPTS $X64DTVOPTSSCREENSHOT ${@:5} "-limitcycles" "$3" "-exitscreenshot" "$1"/.testbench/"$screenshottest"-x64dtv.png "$4" 1> /dev/null 2> /dev/null
    exitcode=$?
    
    if [ $verbose == "1" ]; then
        echo $X64DTV "exited with: " $exitcode
    fi
    
    if [ $exitcode -ne 0 ]
    then
        if [ $exitcode -ne 1 ]
        then
            if [ $exitcode -ne 255 ]
            then
                echo -ne "\nerror: call to $X64DTV failed.\n"
                exit -1
            fi
        fi
    fi

    if [ $exitcode -eq 0 ] || [ $exitcode -eq 255 ]
    then
        if [ -f "$refscreenshotname" ]
        then
        
            # defaults for PAL
            X64DTVREFSXO=32
            X64DTVREFSYO=35
            X64DTVSXO=32
            X64DTVSYO=35
            
    #        echo [ "${refscreenshotvideotype}" "${videotype}" ]
        
            if [ "${refscreenshotvideotype}" == "NTSC" ]; then
                X64DTVREFSXO=32
                X64DTVREFSYO=23
            fi
        
            # when either the testbench was run with --ntsc, or the test is ntsc-specific,
            # then we need the offsets on the NTSC screenshot
            if [ "${videotype}" == "NTSC" ] || [ "${testprogvideotype}" == "NTSC" ]; then
                X64DTVSXO=32
                XX64DTVSYO=23
            fi
        
            ./cmpscreens "$refscreenshotname" "$X64DTVREFSXO" "$X64DTVREFSYO" "$1"/.testbench/"$screenshottest"-x64dtv.png "$X64DTVSXO" "$X64DTVSYO"
            exitcode=$?
        else
            echo -ne "reference screenshot missing - "
            exitcode=255
        fi
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
function x64dtv_run_exitcode
{
    if [ $verbose == "1" ]; then
        echo $X64DTV $X64DTVOPTS $X64DTVOPTSEXITCODE ${@:5} "-limitcycles" "$3" "$4"
        $X64DTV $X64DTVOPTS $X64DTVOPTSEXITCODE ${@:5} "-limitcycles" "$3" "$4" 2> /dev/null | grep "cycles elapsed" | tr '\n' ' '
        exitcode=${PIPESTATUS[0]}
    else
        $X64DTV $X64DTVOPTS $X64DTVOPTSEXITCODE ${@:5} "-limitcycles" "$3" "$4" 1> /dev/null 2> /dev/null
        exitcode=$?
    fi
    if [ $verbose == "1" ]; then
        echo $X64DTV "exited with: " $exitcode
    fi
}
