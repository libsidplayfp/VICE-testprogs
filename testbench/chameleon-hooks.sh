
DUMMY=.dummyfile
RDUMMY=.dummyfile2

function chameleon_reset
{
    # clear the "ready"
    echo -ne "XXXXXX" > $RDUMMY
    chacocmd --addr 1224 --writemem $RDUMMY > /dev/null

    # trigger reset
    echo -ne "X" > $RDUMMY
    chacocmd --addr 0x80000000 --writemem $RDUMMY > /dev/null
#    sleep 3

    # check for "ready."
    RET="XXXXXX"
#    echo "poll1:" "$RET"
    while [ "$RET" != "12050104192e" ]
    do
#        chacocmd --len 1 --addr 0x000100ff --dumpmem
        chacocmd --len 6 --addr 1224 --readmem $DUMMY > /dev/null
        RET=`cat $DUMMY |  hexdump -ve '/1 "%02x"'`
 #      echo "poll:" "$RET"
    done;

#    echo "chameleon_reset done"
}

function chameleon_clear_returncode
{
    # clear the return code
    echo -ne "X" > $DUMMY
    chacocmd --addr 0x000100ff --writemem $DUMMY > /dev/null
#    echo "chameleon_clear_returncode done"
}

function chameleon_poll_returncode
{
    # poll return code
    RET=`cat $DUMMY |  hexdump -ve '/1 "%02x"'`
#    echo "poll1:" "$RET"
    while [ "$RET" = "58" ]
    do
#        chacocmd --len 1 --addr 0x000100ff --dumpmem
        chacocmd --len 1 --addr 0x000100ff --readmem $DUMMY > /dev/null
        RET=`cat $DUMMY |  hexdump -ve '/1 "%02x"'`
#        echo "poll:" "$RET"
    done;

    if [ "$RET" = "ff" ]; then
        RET=255
    fi

#    echo "chameleon_poll_returncode done"
#    echo "poll:" "$RET"
    return $RET
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
function chameleon_run_screenshot
{
#    echo chameleon "$1"/"$2"
    # reset
    chacocmd --addr 0x80000000 --writemem $DUMMY > /dev/null
    sleep 3
    # run program
    chcodenet -x "$1"/"$2"
    sleep 10
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
function chameleon_run_exitcode
{
#    echo chameleon "$1"/"$2"
    # reset
    chameleon_reset

    # run the helper program (enable I/O RAM at $d7xx)
    chameleon_clear_returncode
    chcodenet -x chameleon-helper.prg > /dev/null
    chameleon_poll_returncode

    # run program
    chameleon_clear_returncode
    chcodenet -x "$1"/"$2" > /dev/null
    chameleon_poll_returncode
    exitcode=$?
#    echo "exited with: " $exitcode
}

