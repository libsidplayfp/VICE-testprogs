
DUMMY=.dummyfile
RDUMMY=.dummyfile2
CDUMMY=.dummyfile3

# X and Y offsets for saved screenshots. when saving a screenshot in the
# computers reset/startup screen, the offset gives the top left pixel of the
# top left character on screen.
CHAMSXO=53
CHAMSYO=62

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
    SECONDSEND=$((SECONDS + 5))
    while [ "$RET" != "12050104192e" ]
    do
#        chacocmd --len 1 --addr 0x000100ff --dumpmem
        chacocmd --len 6 --addr 1224 --readmem $DUMMY > /dev/null
        RET=`cat $DUMMY |  hexdump -ve '/1 "%02x"'`
 #      echo "poll:" "$RET"
        if [ $SECONDS -gt $SECONDSEND ]
        then
            echo "timeout when waiting for reset"
            return
        fi
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
    echo -ne "X" > $DUMMY
    RET=`cat $DUMMY |  hexdump -ve '/1 "%02x"'`
#    RET="58"
#    echo "poll1:" "$RET"
    SECONDSEND=$((SECONDS + $1))
    while [ "$RET" = "58" ]
    do
#        chacocmd --len 1 --addr 0x000100ff --dumpmem
        chacocmd --len 1 --addr 0x000100ff --readmem $DUMMY > /dev/null
        RET=`cat $DUMMY |  hexdump -ve '/1 "%02x"'`
#        echo "poll:" "$RET"
        if [ $SECONDS -gt $SECONDSEND ]
        then
            echo "timeout when waiting for return code"
            return
        fi
    done;

    if [ "$RET" = "ff" ]; then
        RET=255
    fi

#    echo "chameleon_poll_returncode done"
#    echo "poll:" "$RET"
    return $RET
}

function chameleon_make_crtid
{
    crtid=`hex $CDUMMY`
    crtid="${crtid:6:2}"
#    echo X"$crtid"X
    case "$crtid" in
        "00")
                # generic
                crtid="\xfc"
            ;;
        "20")
                # easyflash
                crtid="\x20"
            ;;
        "24")
                # retro replay
                crtid="\x01"
            ;;
        "35")
                # pagefox
                crtid="\x35"
            ;;
        *)
                echo " unsupported crt id: 0x"$crtid
                crtid="\x00"
            ;;
    esac
#    echo "crtid:" "$crtid"
}

################################################################################

# $1  option
# $2  test path
function chameleon_get_options
{
#    echo chameleon_get_options "$1"
    exitoptions=""
    case "$1" in
        "default")
                exitoptions=""
            ;;
        "vicii-pal")
                exitoptions=""
            ;;
        "vicii-ntsc")
                exitoptions=""
            ;;
        "vicii-ntscold")
                exitoptions=""
            ;;
        "cia-old")
                exitoptions=""
            ;;
        "cia-new")
                exitoptions=""
            ;;
        "reu512k")
                reu_enabled=1
            ;;
        *)
                exitoptions=""
                if [ "${1:0:9}" == "mountd64:" ]; then
                    echo -ne "(disk:${1:9}) "
                    chmount -d64 "$2/${1:9}" > /dev/null
                fi
                if [ "${1:0:9}" == "mountg64:" ]; then
                    echo -ne "(disk:${1:9}) "
                    chmount -g64 "$2/${1:9}" > /dev/null
                fi
                if [ "${1:0:9}" == "mountcrt:" ]; then
                    echo -ne "(cartridge:${1:9}) "
                    chmount -crt "$2/${1:9}" > /dev/null
                    dd if="$2/${1:9}" bs=1 skip=23 count=1 of=$CDUMMY 2> /dev/null > /dev/null
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
function chameleon_run_screenshot
{
#    echo chameleon "$1"/"$2"
    extraopts=""$4" "$5" "$6""
    mkdir -p "$1"/".testbench"
    rm -f "$1"/.testbench/"$2"-chameleon.png

    # overwrite the CBM80 signature with generic "cartridge off" program
    chacocmd --addr 0x00b00000 --writemem chameleon-crtoff.prg > /dev/null
    # reset
    chameleon_reset

    # run the helper program (enable I/O RAM at $d7xx)
    chameleon_clear_returncode
    chcodenet -x chameleon-helper.prg > /dev/null
    chameleon_poll_returncode 5

    # run program
    chameleon_clear_returncode
    chcodenet -x "$1"/"$2" > /dev/null
#    chameleon_poll_returncode 5
#    exitcode=$?
#    echo "exited with: " $exitcode
    timeoutsecs=`expr \( $3 + 5000000 \) / 10000000`
    sleep $timeoutsecs
    chshot -o "$1"/.testbench/"$2"-chameleon.png
#    echo "exited with: " $exitcode
    if [ -f "$1"/references/"$2".png ]
    then
#        echo ./cmpscreens "$1"/references/"$2".png 32 35 "$1"/.testbench/"$2"-chameleon.png "$CHAMSXO" "$CHAMSYO"
        ./cmpscreens "$1"/references/"$2".png 32 35 "$1"/.testbench/"$2"-chameleon.png "$CHAMSXO" "$CHAMSYO"
        exitcode=$?
    else
        echo -ne "reference screenshot missing - "
        exitcode=255
    fi
#    echo -ne "exitcode:" $exitcode
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
function chameleon_run_exitcode
{
#    echo chameleon X"$1"X / X"$2"X

    if [ X"$2"X = X""X ]
    then
#        echo "no program given"
        # reset
        chameleon_reset
        # set cartridge type
        chameleon_make_crtid
        echo -ne "\x00" > $RDUMMY
        echo -ne "$crtid" >> $RDUMMY
        # set reu type
        if [ $reu_enabled = 1 ]
        then
            echo -ne "\x01" >> $RDUMMY
        else
            echo -ne "\x00" >> $RDUMMY
        fi
        chacocmd --addr 0x400 --writemem $RDUMMY > /dev/null
        # run helper program
        chameleon_clear_returncode
        chcodenet -x chameleon-helper.prg > /dev/null
        chameleon_poll_returncode 5

        chameleon_clear_returncode
        # trigger reset  (run cartridge)
        echo -ne "X" > $RDUMMY
        chacocmd --addr 0x80000000 --writemem $RDUMMY > /dev/null
        chameleon_poll_returncode 5
        exitcode=$?

        # overwrite the CBM80 signature with generic "cartridge off" program
        chacocmd --addr 0x00b00000 --writemem chameleon-crtoff.prg > /dev/null
        # reset
        chameleon_reset
    else
        # overwrite the CBM80 signature with generic "cartridge off" program
        chacocmd --addr 0x00b00000 --writemem chameleon-crtoff.prg > /dev/null
        # reset
        chameleon_reset
        # run the helper program (enable I/O RAM at $d7xx)
        chameleon_clear_returncode
        chcodenet -x chameleon-helper.prg > /dev/null
        chameleon_poll_returncode 5

        # run program
        chameleon_clear_returncode
        chcodenet -x "$1"/"$2" > /dev/null
        chameleon_poll_returncode $(($3 + 1))
        exitcode=$?
    fi
#    echo "exited with: " $exitcode
}

