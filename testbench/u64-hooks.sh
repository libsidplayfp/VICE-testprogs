
DUMMY=.dummyfile
RDUMMY=.dummyfile2
CDUMMY=.dummyfile3

# X and Y offsets for saved screenshots. when saving a screenshot in the
# computers reset/startup screen, the offset gives the top left pixel of the
# top left character on screen.
U64SXO=32
U64SYO=35

function u64_check_environment
{
    if ! [ -x "$(command -v ucodenet)" ]; then
        echo 'Error: ucodenet is not installed.' >&2
        exit 1
    fi
    if ! [ -x "$(command -v ugrab)" ]; then
        echo 'Error: ugrab is not installed.' >&2
        exit 1
    fi

# OLD cia
# 6581 bus interface with 8580 alike sounds.
# VIC 6567 and 6569, no gray dots.    
    emu_default_videosubtype="6569"
}

function u64_clear_returncode
{
    # clear the return code
    ucodenet --writedbg 42

#    if [ "$?"<"0" ]; then exit -1; fi
#    ucodenet --readdbg
#    if [ "$?" != "0" ]; then exit -1; fi
#    RET="$?"
#    echo "clear:" "$RET"
#    echo "u64_clear_returncode done"
}

function u64_poll_returncode
{
    # poll return code
#    echo -ne "X" > $DUMMY
    RET=42
#    RET="58"
#    echo "poll1:" "$RET"
    SECONDSEND=$((SECONDS + 1 + (($1 + 999999) / 1000000)))
#    echo 1: $1
#    echo secs: $SECONDS
#    echo secsend: $SECONDSEND
    while [ "$RET" = "42" ]
    do
#        chacocmd --len 1 --addr 0x000100ff --dumpmem
#        chacocmd --len 1 --addr 0x000100ff --readmem $DUMMY > /dev/null
#        e=`chacocmd --noprogress --len 1 --addr 0x000100ff --dumpmem`
        ucodenet --readdbg
#        if [ "$?" != "0" ]; then exit -1; fi
        RET="$?"
#        echo "poll:" "$RET"
        if [ $SECONDS -gt $SECONDSEND ]
        then
#            echo "timeout when waiting for return code"
            RET=255
            return $RET
        fi
    done;

    if [ "$RET" = "ff" ]; then
        RET=255
    fi

#    echo "u64_poll_returncode done"
#    echo "poll:" "$RET"
    return $RET
}

################################################################################

# called once before any tests run
function u64_prepare
{
    echo -ne "preparing u64."
    echo -ne "."
    ucodenet --resetwait
    echo "ok"
}

# $1  option
# $2  test path
function u64_get_options
{
#    echo u64_get_options "$1" "$2"
    exitoptions=""
    case "$1" in
        "default")
                exitoptions=""
            ;;
        "vicii-pal")
#                exitoptions="-pal"
                testprogvideotype="PAL"
            ;;
        "vicii-ntsc")
#                exitoptions="-ntsc"
                testprogvideotype="NTSC"
            ;;
        "vicii-ntscold")
#                exitoptions="-ntscold"
                testprogvideotype="NTSCOLD"
            ;;
        "vicii-old") 
                if [ x"$testprogvideotype"x == x"PAL"x ]; then
                    # "old" PAL
#                    exitoptions="-VICIImodel 6569"
                    testprogvideosubtype="6569"
                fi
                if [ x"$testprogvideotype"x == x"NTSC"x ]; then
                    # "old" NTSC
#                    exitoptions="-VICIImodel 6562"
                    testprogvideosubtype="6562"
                fi
            ;;
        "vicii-new") 
                if [ x"$testprogvideotype"x == x"PAL"x ]; then
                    # "new" PAL
#                    exitoptions="-VICIImodel 8565"
                    testprogvideosubtype="8565early"
                fi
                if [ x"$testprogvideotype"x == x"NTSC"x ]; then
                    # "new" NTSC
#                    exitoptions="-VICIImodel 8562"
                    testprogvideosubtype="8562early"
                fi
            ;;
        "cia-old")
#                exitoptions="-ciamodel 0"
                new_cia_enabled=0
            ;;
        "cia-new")
#                exitoptions="-ciamodel 1"
                new_cia_enabled=1
            ;;
        "sid-old")
#                exitoptions="-sidenginemodel 256"
                new_sid_enabled=0
            ;;
        "sid-new")
#                exitoptions="-sidenginemodel 257"
                new_sid_enabled=1
            ;;
        "reu512k")
                reu_enabled=1
            ;;
        "geo256k")
                georam_enabled=1
            ;;
        *)
                exitoptions=""
                if [ "${1:0:9}" == "mountd64:" ]; then
                    echo -ne "(disk:${1:9}) "
#                    chmount -d64 "$2/${1:9}" > /dev/null
                    echo "mount image"
                    ucodenet --mountimage "$2/${1:9}"
                    if [ "$?" != "0" ]; then exit -1; fi
                    echo "mount image done"
                    sleep 1
                    mounted_d64="${1:9}"
                fi
                if [ "${1:0:9}" == "mountg64:" ]; then
                    echo -ne "(disk:${1:9}) "
#                    chmount -g64 "$2/${1:9}" > /dev/null
                    ucodenet --mountimage "$2/${1:9}"
                    if [ "$?" != "0" ]; then exit -1; fi
                    mounted_g64="${1:9}"
                fi
                if [ "${1:0:9}" == "mountcrt:" ]; then
                    echo -ne "(cartridge:${1:9}) "
                    echo TODO: mount crt "$2/${1:9}" > /dev/null
                    if [ "$?" != "0" ]; then exit -1; fi
                    dd if="$2/${1:9}" bs=1 skip=23 count=1 of=$CDUMMY 2> /dev/null > /dev/null
                    mounted_crt="${1:9}"
                fi
            ;;
    esac
}


# $1  option
# $2  test path
function u64_get_cmdline_options
{
#    echo u64_get_cmdline_options "$1"
    exitoptions=""
    case "$1" in
        # FIXME: the returned options are meaningless right now,
        #        u64_run_screenshot and u64_run_exitcode may use them
        "PAL")
                exitoptions="-pal"
            ;;
        "NTSC")
                exitoptions="-ntsc"
            ;;
        "NTSCOLD")
                exitoptions="-ntscold"
            ;;
#        "8565") # "new" PAL
#                exitoptions=""
#            ;;
#        "8562") # "new" NTSC
#                exitoptions=""
#            ;;
        "6526") # "old" CIA
                exitoptions="-ciamodel 0"
                new_cia_enabled=0
            ;;
        "6526A") # "new" CIA
                exitoptions="-ciamodel 1"
                new_cia_enabled=1
            ;;
    esac
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
function u64_run_screenshot
{
    if [ "$2" == "" ] ; then
        screenshottest="$mounted_crt"
    else
        screenshottest="$2"
    fi

    mkdir -p "$1"/".testbench"
    rm -f "$1"/.testbench/"$screenshottest"-u64.png

    # overwrite the CBM80 signature with generic "cartridge off" program
#    chacocmd --addr 0x00b00000 --writemem u64-crtoff.prg > /dev/null
#    if [ "$?" != "0" ]; then exit -1; fi
    # reset
    ucodenet --resetwait

#    u64_make_helper_options 0
#    if [ "$?" != "0" ]; then exit -1; fi

    # run the helper program (enable I/O RAM at $d7xx)
#    u64_clear_returncode
#    chcodenet -x u64-helper.prg > /dev/null
#    if [ "$?" != "0" ]; then exit -1; fi
#    u64_poll_returncode 5

    # run program
    u64_clear_returncode
    ucodenet -x "$1"/"$2" > /dev/null
    if [ "$?" != "0" ]; then exit -1; fi
#    u64_poll_returncode 5
#    exitcode=$?
#    echo "exited with: " $exitcode
#    timeoutsecs=`expr \( $3 + 999999 \) / 1000000`
#    sleep $timeoutsecs

    u64_poll_returncode $(($3 + 1))
    exitcode=$?
    
#    if [ "${videotype}" == "NTSC" ]; then
#        chshot --ntsc -o "$1"/.testbench/"$2"-u64.png
#        if [ "$?" != "0" ]; then exit -1; fi
#    else
        ucodenet --vicstream-start
        if [ "$?" != "0" ]; then exit -1; fi
        ugrab "$1"/.testbench/"$2"-u64.png
        if [ "$?" != "0" ]; then exit -1; fi
        ucodenet --vicstream-stop
        if [ "$?" != "0" ]; then exit -1; fi
#    fi

#    echo "exited with: " $exitcode

    if [ -f "$refscreenshotname" ]
    then
        # defaults for PAL
        U64REFSXO=32
        U64REFSYO=35
        U64SXO=32
        U64SYO=35

#        echo [ "${refscreenshotvideotype}" "${videotype}" ]

        if [ "${refscreenshotvideotype}" == "NTSC" ]; then
            U64REFSXO=32
            U64REFSYO=23
        fi

        # when either the testbench was run with --ntsc, or the test is ntsc-specific,
        # then we need the offsets on the NTSC screenshot
        if [ "${videotype}" == "NTSC" ] || [ "${testprogvideotype}" == "NTSC" ]; then
            U64SXO=32
            U64SYO=35
        fi

#        echo ./cmpscreens "$refscreenshotname" "$U64REFSXO" "$U64REFSYO" "$1"/.testbench/"$screenshottest"-u64.png "$U64SXO" "$U64SYO"
        ./cmpscreens "$refscreenshotname" "$U64REFSXO" "$U64REFSYO" "$1"/.testbench/"$screenshottest"-u64.png "$U64SXO" "$U64SYO"
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
# exit when write to $d7ff occurs - the value written determines success (=$00) or fail (=$ff)
# exit after $timeout cycles (exitcode=$01)

# $1  test path
# $2  test program name
# $3  timeout cycles
# $4  test full path+name (may be empty)
# $5- extra options for the emulator
function u64_run_exitcode
{
#    echo u64 X"$1"X / X"$2"X

    if [ X"$2"X = X""X ]
    then
#        echo "no program given"
        # reset
        ucodenet --resetwait

#        u64_make_helper_options 1
 #       if [ "$?" != "0" ]; then exit -1; fi

        # run helper program
#        u64_clear_returncode
#        chcodenet -x u64-helper.prg > /dev/null
#        if [ "$?" != "0" ]; then exit -1; fi
#        u64_poll_returncode 5

        u64_clear_returncode
        # trigger reset  (run cartridge)
        echo -ne "X" > $RDUMMY
#        chacocmd --addr 0x80000000 --writemem $RDUMMY > /dev/null
        if [ "$?" != "0" ]; then exit -1; fi
        u64_poll_returncode 5
        exitcode=$?

        # overwrite the CBM80 signature with generic "cartridge off" program
#        chacocmd --addr 0x00b00000 --writemem u64-crtoff.prg > /dev/null
#        if [ "$?" != "0" ]; then exit -1; fi
        # reset
        ucodenet --resetwait
    else
        # overwrite the CBM80 signature with generic "cartridge off" program
#        chacocmd --addr 0x00b00000 --writemem u64-crtoff.prg > /dev/null

#        sleep 5
#        if [ "$?" != "0" ]; then exit -1; fi
#        echo "reset"
        # reset
        ucodenet --resetwait
        if [ "$?" != "0" ]; then exit -1; fi
#        echo "reset done"

#        u64_make_helper_options 0
 #       if [ "$?" != "0" ]; then exit -1; fi

        # run the helper program (enable I/O RAM at $d7xx)
#        u64_clear_returncode
#        chcodenet -x u64-helper.prg > /dev/null
#        if [ "$?" != "0" ]; then exit -1; fi
#        u64_poll_returncode 5

        # run program
        u64_clear_returncode
        ucodenet -x "$1"/"$2" > /dev/null
        if [ "$?" != "0" ]; then exit -1; fi
        u64_poll_returncode $(($3 + 1))
        exitcode=$?
    fi
#    echo "exited with: " $exitcode
}

