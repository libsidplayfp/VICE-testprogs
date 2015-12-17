
X64=../../trunk/vice/src/x64
X64OPTS+=" -default"
#X64OPTS+=" -warp"
X64OPTS+=" -debugcart"

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
    echo $X64 "$1"/"$2"
    $X64 $X64OPTS "-limitcycles" "$3" "$1"/"$2"
}

################################################################################
# reset
# run test program
# exit when write to d7ff occurs - the value written determines success (=1) or fail (other > 1)
# exit after $timeout cycles
# save a screenshot at exit

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
