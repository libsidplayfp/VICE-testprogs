
X64SC=../../trunk/vice/src/x64sc
X64SCOPTS+=" -default"
X64SCOPTS+=" -VICIIfilter 0"
X64SCOPTS+=" -VICIIextpal"
X64SCOPTS+=" -VICIIpalette vice.vpl"
#X64SCOPTS+=" -warp"
X64SCOPTS+=" -debugcart"

# X and Y offsets for saved screenshots. when saving a screenshot in the
# computers reset/startup screen, the offset gives the top left pixel of the
# top left character on screen.
SXO=32
SYO=35

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
#    echo $X64SC "$1"/"$2"
    mkdir -p "$1"/".testbench"
    $X64SC $X64SCOPTS "-limitcycles" "$3" "-exitscreenshot" "$1"/.testbench/"$2"-x64sc.png "$1"/"$2" 1> /dev/null
    ./cmpscreens "$1"/references/"$2".png 32 35 "$1"/.testbench/"$2"-x64sc.png "$SXO" "$SYO"
    exitcode=$?
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
#    echo $X64SC "$1"/"$2"
    $X64SC $X64SCOPTS "-limitcycles" "$3" "$1"/"$2" 1> /dev/null
    exitcode=$?
#    echo "exited with: " $exitcode
}
