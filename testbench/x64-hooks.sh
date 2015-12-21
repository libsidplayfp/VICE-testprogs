
X64=../../trunk/vice/src/x64
X64OPTS+=" -default"
X64OPTS+=" -VICIIfilter 0"
X64OPTS+=" -VICIIextpal"
X64OPTS+=" -VICIIpalette vice.vpl"
#X64OPTS+=" -warp"
X64OPTS+=" -debugcart"

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
function x64_run_screenshot
{
#    echo $X64 "$1"/"$2"
    mkdir -p "$1"/".testbench"
#   $X64 $X64OPTS "-limitcycles" "$3" "-exitscreenshot" "$1"/.testbench/"$2"-x64.png "$1"/"$2"
    $X64 $X64OPTS "-limitcycles" "$3" "-exitscreenshot" "$1"/.testbench/"$2"-x64.png "$1"/"$2" 1> /dev/null
    ./cmpscreens "$1"/references/"$2".png 32 35 "$1"/.testbench/"$2"-x64.png "$SXO" "$SYO"
    exitcode=$?
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
#    echo $X64 "$1"/"$2"
    $X64 $X64OPTS "-limitcycles" "$3" "$1"/"$2" 1> /dev/null
    exitcode=$?
#    echo "exited with: " $exitcode
}
