
DUMMY=.dummyfile
RDUMMY=.dummyfile2
CDUMMY=.dummyfile3

# X and Y offsets for saved screenshots. when saving a screenshot in the
# computers reset/startup screen, the offset gives the top left pixel of the
# top left character on screen.
CHAM20SXO=70
CHAM20SYO=66

function cham20_check_environment
{
    if ! [ -x "$(command -v chacocmd)" ]; then
        echo 'Error: chacocmd is not installed.' >&2
        exit 1
    fi
    if ! [ -x "$(command -v chshot)" ]; then
        echo 'Error: chshot is not installed.' >&2
        exit 1
    fi
    if ! [ -x "$(command -v chcodenet)" ]; then
        echo 'Error: chcodenet is not installed.' >&2
        exit 1
    fi
    if ! [ -x "$(command -v chmount)" ]; then
        echo 'Error: chmount is not installed.' >&2
        exit 1
    fi
}

function cham20_reset
{
    # clear the "ready"
    echo -ne "XXXXXX" > $RDUMMY
    chacocmd --addr 4184 --writemem $RDUMMY > /dev/null
    if [ "$?" != "0" ]; then exit -1; fi

    # trigger reset
    echo -ne "X" > $RDUMMY
    chacocmd --addr 0x80000000 --writemem $RDUMMY > /dev/null
    if [ "$?" != "0" ]; then exit -1; fi
#    sleep 3

    # check for "ready."
    RET="XXXXXX"
#    echo "poll1:" "$RET"
    SECONDSEND=$((SECONDS + 5))
    while [ "$RET" != "12 05 01 04 19 2e" ]
    do
#        chacocmd --len 1 --addr 0x910f --dumpmem
#        chacocmd --len 6 --addr 4184 --readmem $DUMMY > /dev/null
        e=`chacocmd --noprogress --len 6 --addr 4184 --dumpmem`
        if [ "$?" != "0" ]; then exit -1; fi
        RET=${e:10:17}
 #      echo "poll:" "$RET"
        if [ $SECONDS -gt $SECONDSEND ]
        then
            echo "timeout when waiting for reset"
            return
        fi
    done;

#    echo "cham20_reset done"
}

function cham20_clear_returncode
{
    # clear the return code
    echo -ne "X" > $DUMMY
    chacocmd --addr 0x910f --writemem $DUMMY > /dev/null
    if [ "$?" != "0" ]; then exit -1; fi
#    echo "cham20_clear_returncode done"
}

function cham20_poll_returncode
{
    # poll return code
    echo -ne "X" > $DUMMY
    RET="58"
#    RET="58"
#    echo "poll1:" "$RET"
    SECONDSEND=$((SECONDS + 1 + ($1 / 10000000)))
    while [ "$RET" = "58" ]
    do
#        chacocmd --len 1 --addr 0x910f --dumpmem
#        chacocmd --len 1 --addr 0x910f --readmem $DUMMY > /dev/null
        e=`chacocmd --noprogress --len 1 --addr 0x910f --dumpmem`
        if [ "$?" != "0" ]; then exit -1; fi
        RET=${e:10:2}
#        echo "poll:" "$RET"
        if [ $SECONDS -gt $SECONDSEND ]
        then
            echo "timeout when waiting for return code"
            RET=255
            return $RET
        fi
    done;

    if [ "$RET" = "ff" ]; then
        RET=255
    fi

#    echo "cham20_poll_returncode done"
#    echo "poll:" "$RET"
    return $RET
}

################################################################################

# $1  option
# $2  test path
function cham20_get_options
{
#    echo cham20_get_options "$1" "$2"
    exitoptions=""
    case "$1" in
        "default")
                exitoptions=""
            ;;
        "vic-pal")
#                exitoptions="-pal"
                testprogvideotype="PAL"
            ;;
        "vic-ntsc")
#                exitoptions="-ntsc"
                testprogvideotype="NTSC"
            ;;
        "vic-ntscold")
#                exitoptions="-ntscold"
                testprogvideotype="NTSCOLD"
            ;;
#        "sid-old")
#                exitoptions=""
#                new_sid_enabled=0
#            ;;
#        "sid-new")
#                exitoptions=""
#                new_sid_enabled=0
#            ;;
        "vic20-8k")
#                exitoptions="-memory 8k"
                memory_expansion_enabled="8K"
            ;;
        "vic20-32k")
#                exitoptions="-memory all"
                memory_expansion_enabled="32K"
            ;;
        *)
                exitoptions=""
                if [ "${1:0:9}" == "mountd64:" ]; then
                    echo -ne "(disk:${1:9}) "
                    chmount -d64 "$2/${1:9}" > /dev/null
                    if [ "$?" != "0" ]; then exit -1; fi
                    mounted_d64="${1:9}"
                fi
                if [ "${1:0:9}" == "mountg64:" ]; then
                    echo -ne "(disk:${1:9}) "
                    chmount -g64 "$2/${1:9}" > /dev/null
                    if [ "$?" != "0" ]; then exit -1; fi
                    mounted_g64="${1:9}"
                fi
            ;;
    esac
}


# $1  option
# $2  test path
function cham20_get_cmdline_options
{
#    echo cham20_get_cmdline_options "$1"
    exitoptions=""
    case "$1" in
        # FIXME: the returned options are meaningless right now,
        #        cham20_run_screenshot and cham20_run_exitcode may use them
        "PAL")
                exitoptions="-pal"
            ;;
        "NTSC")
                exitoptions="-ntsc"
            ;;
        "NTSCOLD")
                exitoptions="-ntscold"
            ;;
        "8K")
                exitoptions="-memory 8k"
            ;;
        "32K")
                exitoptions="-memory all"
            ;;
    esac
}

# called once before any tests run
function cham20_prepare
{
}

################################################################################
# reset
# run test program
# exit when write to $910f occurs - the value written determines success (=$00) or fail (=$ff)
# exit after $timeout cycles (exitcode=$01)
# save a screenshot at exit - success or failure is determined by comparing screenshots

# $1  test path
# $2  test program name
# $3  timeout cycles
# $4  test full path+name (may be empty)
# $5- extra options for the emulator
function cham20_run_screenshot
{
    mkdir -p "$1"/".testbench"
    rm -f "$1"/.testbench/"$2"-cham20.png

    # reset
    cham20_reset

    # run program
    cham20_clear_returncode
    chcodenet -x "$1"/"$2" > /dev/null
    if [ "$?" != "0" ]; then exit -1; fi
#    cham20_poll_returncode 5
#    exitcode=$?
#    echo "exited with: " $exitcode
    timeoutsecs=`expr \( $3 + 5000000 \) / 10000000`
    sleep $timeoutsecs
    if [ "${videotype}" == "NTSC" ]; then
        chshot --vic20 --ntsc -o "$1"/.testbench/"$2"-cham20.png
        if [ "$?" != "0" ]; then exit -1; fi
    else
        chshot --vic20 -o "$1"/.testbench/"$2"-cham20.png
        if [ "$?" != "0" ]; then exit -1; fi
    fi
#    echo "exited with: " $exitcode
    if [ -f "$refscreenshotname" ]
    then
        # defaults for PAL
        CHAM20REFSXO=96
        CHAM20REFSYO=48
        CHAM20SXO=70
        CHAM20SYO=66

#        echo [ "${refscreenshotvideotype}" "${videotype}" ]

#       if [ "${refscreenshotvideotype}" == "NTSC" ]; then
#           CHAM20REFSXO=32
#           CHAM20REFSYO=23
#       fi

#       if [ "${videotype}" == "NTSC" ]; then
#           CHAM20SXO=61
#           CHAM20SYO=38
#       fi

#        echo ./cmpscreens "$refscreenshotname" "$CHAM20REFSXO" "$CHAM20REFSYO" "$1"/.testbench/"$2"-cham20.png "$CHAM20SXO" "$CHAM20SYO"
        ./cmpscreens "$refscreenshotname" "$CHAM20REFSXO" "$CHAM20REFSYO" "$1"/.testbench/"$2"-cham20.png "$CHAM20SXO" "$CHAM20SYO"
        exitcode=$?
    else
        echo -ne "reference screenshot missing ("$refscreenshotname") - "
        exitcode=255
    fi
#    echo -ne "exitcode:" $exitcode
}

################################################################################
# reset
# run test program
# exit when write to $910f occurs - the value written determines success (=$00) or fail (=$ff)
# exit after $timeout cycles (exitcode=$01)

# $1  test path
# $2  test program name
# $3  timeout cycles
# $4  test full path+name (may be empty)
# $5- extra options for the emulator
function cham20_run_exitcode
{
#    echo cham20 X"$1"X / X"$2"X

    # reset
    cham20_reset
    # run the helper program
#    cham20_clear_returncode
#    chcodenet -x cham20-helper.prg > /dev/null
#    if [ "$?" != "0" ]; then exit -1; fi
#    cham20_poll_returncode 5

    # run program
    cham20_clear_returncode
    chcodenet -x "$1"/"$2" > /dev/null
    if [ "$?" != "0" ]; then exit -1; fi
    cham20_poll_returncode $(($3 + 1))
    exitcode=$?
#    echo "exited with: " $exitcode
}

