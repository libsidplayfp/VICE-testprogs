#! /bin/bash
###############################################################################

NAME=$0

# defaults for global variables set by commandline
target=""
filter=""
verbose=0
# extra options
videotype=""
videosubtype=""
sidtype=""
ciatype=""
memoryexpansion=""
if [ "$VICEDIR" == "" ] ; then
	VICEDIR="../../trunk/vice/src"
else
	echo "using VICEDIR="$VICEDIR
fi

# globals set by utility functions that can be used in the hooks
refscreenshotname=""

source "./chameleon-hooks.sh"
source "./cham20-hooks.sh"
source "./c64rmk2-hooks.sh"
source "./x64-hooks.sh"
source "./x64sc-hooks.sh"
source "./x128-hooks.sh"
source "./xscpu64-hooks.sh"
source "./x64dtv-hooks.sh"
source "./xpet-hooks.sh"
source "./xcbm2-hooks.sh"
source "./xcbm5x0-hooks.sh"
source "./xplus4-hooks.sh"
source "./xvic-hooks.sh"
source "./vsid-hooks.sh"
source "./hoxs64-hooks.sh"
source "./micro64-hooks.sh"
source "./emu64-hooks.sh"
source "./yace-hooks.sh"

###############################################################################

function checktarget
{
    case "$1" in
    # C64 targets
        x64)
                target="$1"
            ;;
        x64sc)
                target="$1"
            ;;
        chameleon)
                target="$1"
            ;;
        c64rmk2)
                target="$1"
            ;;
        hoxs64)
                target="$1"
            ;;
        micro64)
                target="$1"
            ;;
        emu64)
                target="$1"
            ;;
        yace)
                target="$1"
            ;;
    # C128 targets
        x128)
                target="$1"
            ;;
    # SCPU targets
        xscpu64)
                target="$1"
            ;;
    # PET targets
        xpet)
                target="$1"
            ;;
    # CBM2 / CBM500 targets
        xcbm5x0)
                target="$1"
            ;;
    # CBM2 / CBM600 targets
        xcbm2)
                target="$1"
            ;;
    # VIC20 targets
        xvic)
                target="$1"
            ;;
        cham20)
                target="$1"
            ;;
    # Plus4 targets
        xplus4)
                target="$1"
            ;;
    # DTV targets
        x64dtv)
                target="$1"
            ;;
    # SID-player targets
        vsid)
                target="$1"
            ;;
        *)
            echo "error:" "$1" "is not a valid target. (--help to get help)"
            exit -1
            ;;
    esac
}

# $1  test path
# $2  test program name
function getscreenshotname
{
    refscreenshotname=""
    if [ "$videosubtype" != "" ] ; then
        if [ -f "$1"/references/"$2"-"$videosubtype".png ]
        then
            refscreenshotname="$1"/references/"$2"-"$videosubtype".png
            return 0
        fi
        # if the exact subtype could not be found, try more general one
        if [ "$videosubtype" == "8565early" ] || [ "$videosubtype" == "8565late" ]; then
            if [ -f "$1"/references/"$2"-"8565".png ]
            then
                refscreenshotname="$1"/references/"$2"-"8565".png
                return 0
            fi
        fi
    fi

    if [ "$videotype" == "NTSC" ] && [ -f "$1"/references/"$2"-ntsc.png ]
    then
        refscreenshotname="$1"/references/"$2"-ntsc.png
        return 0
    fi

    if [ "$videotype" == "NTSCOLD" ] && [ -f "$1"/references/"$2"-ntscold.png ]
    then
        refscreenshotname="$1"/references/"$2"-ntscold.png
        return 0
    fi

    if [ -f "$1"/references/"$2".png ]
    then
        refscreenshotname="$1"/references/"$2".png
        return 0
    fi
    return 255
}

###############################################################################

# read the list of tests for the given target
function gettestsfortarget
{
#    echo "reading list of tests for" "$1".
# readarray does only work on bash4 (not in mingw)
#    readarray -t testlist < "$1"-testlist.txt
    IFS=$'\n' read -d '' -r -a testlist < "$1"-testlist.txt
}

###############################################################################

# reset all flags used for options per test
function resetflags
{
    reu_enabled=0
    georam_enabled=0
    plus60k_enabled=0
    new_sid_enabled=0
    new_cia_enabled=0
}

###############################################################################

# $1 - target
# $2 - filter substring
function runprogsfortarget
{
#    checktarget "$1"
#    if [ "$2" == "" ]; then
#        echo "running tests for" "$target"":"
#    else
#        echo "running tests for" "$target" "(""$2"")"":"
#    fi

    gettestsfortarget "$target"
    rm -f "$target"_result.txt

    for e in "${testlist[@]}"
    do
#        echo "$e"
        resetflags

        if [ "${e:0:1}" != "#" ]; then
            IFS=',' read -a myarray <<< "$e"
#            echo line:${e}
#            echo 1:${myarray[0]}
#            echo 2:${myarray[1]}
#            echo 3:${myarray[2]}
#            echo 4:${myarray[3]}
#            echo 5:${myarray[4]}
            arraylength=${#myarray[@]}
            if [ "$arraylength" -lt "4" ]; then
                echo "error: unexpected end of line in input (arraylenght=${arraylength})"
                echo "line:${e}"
                exit -1
            fi

            testpath="${myarray[0]}"
            testprog="${myarray[1]}"
            testtype="${myarray[2]}"
            testtimeout="${myarray[3]}"
            progpath=${testpath}${testprog}

#            echo " path: $testpath"
#            echo " program: $testprog"
#            echo " type: $testtype"
#            echo " timeout: $testtimeout"
#            echo " options: $testoptions"

            skiptest=0
            if [ "$2" == "" ] || [ "${progpath#*$2}" != "$progpath" ]; then
                # create the commandline for the target...
                testoptions=""
                # first loop over the options given for the test
                for (( i=5; i<${arraylength}+1; i++ ));
                do
#                    echo $i " / " ${arraylength} " : " ${myarray[$i-1]}
                    "$target"_get_options "${myarray[$i-1]}" "$testpath"
#                    echo "exitoptions: $exitoptions"
                    testoptions+="${exitoptions} "
                    # skip test if videomode was given on commandline and it does not match
                    if [ "${videotype}" == "PAL" ]; then
                        if [ "${exitoptions}" == "-ntsc" ] || [ "${exitoptions}" == "-ntscold" ]; then
                            echo "$testpath" "$testprog" "- " "not" "${videotype}" "(skipped)"
                            skiptest=1
                        fi
                    fi
                    if [ "${videotype}" == "NTSC" ]; then
                        if [ "${exitoptions}" == "-pal" ] || [ "${exitoptions}" == "-ntscold" ]; then
                            echo "$testpath" "$testprog" "- " "not" "${videotype}" "(skipped)"
                            skiptest=1
                        fi
                    fi
                    if [ "${videotype}" == "NTSCOLD" ]; then
                        if [ "${exitoptions}" == "-ntsc" ] || [ "${exitoptions}" == "-pal" ]; then
                            echo "$testpath" "$testprog" "- " "not" "${videotype}" "(skipped)"
                            skiptest=1
                        fi
                    fi
                    if [ "${sidtype}" == "6581" ]; then
                        if [ x"${exitoptions}"x == x"-sidenginemodel 257"x ]; then
                            echo "$testpath" "$testprog" "- " "not" "${sidtype}" "(skipped)"
                            skiptest=1
                        fi
                    fi
                    if [ "${sidtype}" == "8580" ]; then
                        if [ x"${exitoptions}"x == x"-sidenginemodel 256"x ]; then
                            echo "$testpath" "$testprog" "- " "not" "${sidtype}" "(skipped)"
                            skiptest=1
                        fi
                    fi
                    if [ "${ciatype}" == "6526" ]; then
                        if [ x"${exitoptions}"x == x"-ciamodel 1"x ]; then
                            echo "$testpath" "$testprog" "- " "not" "${ciatype}" "(skipped)"
                            skiptest=1
                        fi
                    fi
                    if [ "${ciatype}" == "6526A" ]; then
                        if [ x"${exitoptions}"x == x"-ciamodel 0"x ]; then
                            echo "$testpath" "$testprog" "- " "not" "${ciatype}" "(skipped)"
                            skiptest=1
                        fi
                    fi
#                    echo "memoryexpansion:"  "${memoryexpansion}"
                    if [ "${memoryexpansion}" == "8K" ]; then
#                        echo "check Not 8k?"
                        if [ x"${exitoptions}"x != x"-memory 8k"x ]; then
                            echo "$testpath" "$testprog" "- " "not" "${memoryexpansion}" "(skipped)"
                            skiptest=1
                        fi
                    fi
                done
                # now setup additional options depending on commandline options given to the testbench script
                if [ "${videotype}" == "PAL" ]; then
                    "$target"_get_cmdline_options "PAL"
                    testoptions+="${exitoptions} "
                fi
                if [ "${videotype}" == "NTSC" ]; then
                    "$target"_get_cmdline_options "NTSC"
                    testoptions+="${exitoptions} "
                fi
                if [ "${videotype}" == "NTSCOLD" ]; then
                    "$target"_get_cmdline_options "NTSCOLD"
                    testoptions+="${exitoptions} "
                fi
                if [ "${ciatype}" == "6526" ]; then
                    "$target"_get_cmdline_options "6526"
                    testoptions+="${exitoptions} "
                fi
                if [ "${ciatype}" == "6526A" ]; then
                    "$target"_get_cmdline_options "6526A"
                    testoptions+="${exitoptions} "
                fi
                if [ "${videosubtype}" == "6569" ]; then
                    "$target"_get_cmdline_options "6569"
                    testoptions+="${exitoptions} "
                fi
                if [ "${videosubtype}" == "8565" ]; then
                    "$target"_get_cmdline_options "8565"
                    testoptions+="${exitoptions} "
                fi
                if [ "${videosubtype}" == "8562" ]; then
                    "$target"_get_cmdline_options "8562"
                    testoptions+="${exitoptions} "
                fi
                if [ "${memoryexpansion}" == "8K" ]; then
                    "$target"_get_cmdline_options "8K"
                    testoptions+="${exitoptions} "
                fi
            if [ "${skiptest}" == "0" ] && [ "${testtype}" == "interactive" ]; then
                echo "$testpath" "$testprog" "- " "interactive (skipped)"
                skiptest=1
            fi
            if [ "${skiptest}" == "0" ]; then
#                if [ "$2" == "" ] || [ "${testpath#*$2}" != "$testpath" ]; then
                    echo -ne "$testpath" "$testprog" "- "
                    if [ "${verbose}" == "1" ]; then
                        echo -ne ["${testtype}"]
                    fi

                    if [ "${testtype}" == "screenshot" ]
                    then
                        getscreenshotname "$testpath" "$testprog"
                        refscreenshotvideotype="PAL"
                        if [ "${refscreenshotname#*_ntsc.prg}" != "$refscreenshotname" ] || [ "${refscreenshotname#*-ntsc.png}" != "$refscreenshotname" ]
                        then
                            refscreenshotvideotype="NTSC"
                        fi
                        if [ "${refscreenshotname#*_ntscold.prg}" != "$refscreenshotname" ] || [ "${refscreenshotname#*-ntscold.png}" != "$refscreenshotname" ]
                        then
                            refscreenshotvideotype="NTSCOLD"
                        fi
                        if [ "${verbose}" == "1" ]; then
                            echo -ne ["$refscreenshotvideotype": "$refscreenshotname"]
                        fi
                    fi

                    if [ "${testtype}" == "screenshot" ] && [ "$refscreenshotname" == "" ]
                    then
                        echo "reference screenshot missing (skipped)"
                        echo "noref" "$testpath" "$testprog" >> "$target"_result.txt
                    else
#                        echo "$target"_run_"$testtype" "$testpath" "$testprog" "$testtimeout" "$testoptions"
                        "$target"_run_"$testtype" "$testpath" "$testprog" "$testtimeout" "$testoptions"
#                        echo "exited with: " $exitcode
                        GREEN='\033[1;32m'
                        RED='\033[1;31m'
                        NC='\033[0m'
                        case "$exitcode" in
                            0)
                                    echo -ne $GREEN
                                    exitstatus="ok"
                                ;;
                            1)
                                    echo -ne $RED
                                    exitstatus="timeout"
                                ;;
                            255)
                                    echo -ne $RED
                                    exitstatus="error"
                                ;;
                            *)
                                    echo -ne $RED
                                    exitstatus="error"
                                ;;
                        esac
                        echo -e "$exitstatus" $NC
                        echo "$exitstatus" "$testpath" "$testprog" >> "$target"_result.txt
                    fi
                    
#                fi
            fi
            fi
        fi
    done
}

function showfailedfortarget
{
    checktarget "$1"
    if [ -f "$target"_result.txt ]; then
        if [ `grep -v ok "$target"_result.txt | wc -l ` -eq 0 ]; then
            echo "no test(s) failed for" "$target""."
        else
            echo "failed tests for" "$target"":"
            grep "error" "$target"_result.txt
            grep "timeout" "$target"_result.txt
            grep "noref" "$target"_result.txt
        fi
    fi
}

###############################################################################
function showhelp
{
    echo $NAME" - run test programs."
    echo "usage: "$NAME" [target] <filter> <options>"
    echo "  targets: x64, x64sc, x128, xscpu64, x64dtv, xpet, xcbm2, xcbm5x0, xvic, xplus4, vsid,"
    echo "           chameleon, cham20, c64rmk2, hoxs64, micro64, emu64, yace"
    echo "  <filter> is a substring of the path of tests to restrict to"
    echo "  --help       show this help"
    echo "  --verbose    be more verbose"
    echo "  --pal        run tests in PAL, skip tests that do not work on PAL"
    echo "  --ntsc       run tests in NTSC, skip tests that do not work on NTSC"
    echo "  --ntscold    run tests in NTSC(old), skip tests that do not work on NTSC(old)"
    echo "  --ciaold     run tests on 'old' CIA, skip tests that do not work on 'new' CIA"
    echo "  --cianew     run tests on 'new' CIA, skip tests that do not work on 'old' CIA"
    echo "  --6581       run tests on 6581 (old SID), skip tests that do not work on 8580 (new SID)"
    echo "  --8580       run tests on 8580 (new SID), skip tests that do not work on 6581 (old SID)"
    echo "  --6569       target VICII type is 6569 (PAL)"
    echo "  --6567       target VICII type is 6567 (NTSC)"
    echo "  --8562       target VICII type is 8562 (NTSC, grey dot)"
    echo "  --8565       target VICII type is 8565 (PAL, grey dot)"
    echo "  --8565early  target VICII type is 8565 (PAL, new color instead of grey dot)"
    echo "  --8565late   target VICII type is 8565 (PAL, old color instead of grey dot)"
    echo "  --8k         skip tests that do not work with 8k RAM expansion"
}

function checkparams
{
    if [ "$target" == "" ]; then
        echo "error: no valid target given (--help to get help)"
        exit -1
    fi
}
###############################################################################

for thisarg in "$@"
do
#    echo "arg:" "$thisarg"
    case "$thisarg" in
        --help)
                showhelp
                exit 0
            ;;
        --verbose)
                verbose=1
            ;;
        --pal)
                videotype="PAL"
            ;;
        --ntsc)
                videotype="NTSC"
            ;;
        --ntscold)
                videotype="NTSCOLD"
            ;;
        --6581) # "old" SID
                sidtype="6581"
            ;;
        --8580) # "new" SID
                sidtype="8580"
            ;;
        --ciaold) # "old" CIA
                ciatype="6526"
            ;;
        --cianew) # "new" CIA
                ciatype="6526A"
            ;;
        --6569) # PAL VICII
                videosubtype="6569"
            ;;
        --8565) # "new" PAL VICII (grey dot)
                videosubtype="8565"
            ;;
        --8565early) # "new" PAL VICII (no grey dot, new color instead)
                videosubtype="8565early"
            ;;
        --8565late) # "new" PAL VICII (no grey dot, old color instead)
                videosubtype="8565late"
            ;;
        --6567) # NTSC VICII
                videosubtype="6567"
            ;;
        --8562) # "new" NTSC VICII (grey dot)
                videosubtype="8562"
            ;;
        --8k) # 8k RAM expansion
                memoryexpansion="8K"
            ;;
        *) # is either target or filter
            if [ "${thisarg:0:2}" == "--" ]; then
                echo "error: unknown option '"$thisarg"'."
                exit -1
            fi
            if [ "$thisarg" = "" ] ; then
                showhelp
                exit -1
            fi
            # try to set target if no target set
            if [ "$target" = "" ] ; then
                checktarget "$thisarg"
            else
            # if target is set, set filter
                filter="$thisarg"
            fi
            ;;
    esac
    
done

if [ "$verbose" = "1" ] ; then
    echo target:"$target"
    echo filter:"$filter"
    echo verbose:"$verbose"
    echo "video type:" "$videotype"
    echo "video subtype:" "$videosubtype"
    echo "SID type:" "$sidtype"
    echo "CIA type:" "$ciatype"
    echo "memory expansion:" "$memoryexpansion"
fi

checkparams

if [ "$filter" == "" ]; then
    echo "running tests for" "$target" "(all):"
else
    echo "running tests for" "$target" "(""$filter"")"":"
fi

make prereq

SECONDS=0

runprogsfortarget "$target" "$filter"

duration=$SECONDS
echo "$(($duration / 60)) minutes and $(($duration % 60)) seconds elapsed."

showfailedfortarget "$target"

exit 0;
