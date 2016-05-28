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

# globals set by utility functions that can be used in the hooks
refscreenshotname=""

source "./chameleon-hooks.sh"
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
    readarray -t testlist < "$1"-testlist.txt
}

###############################################################################

# reset all flags used for options per test
function resetflags
{
    reu_enabled=0
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
                testoptions=""
                for (( i=5; i<${arraylength}+1; i++ ));
                do
    #                echo $i " / " ${arraylength} " : " ${myarray[$i-1]}
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
                done
            if [ "${testtype}" == "interactive" ]; then
                echo "$testpath" "$testprog" "- " "interactive (skipped)"
                skiptest=1
            fi
            if [ "${skiptest}" == "0" ]; then
#                if [ "$2" == "" ] || [ "${testpath#*$2}" != "$testpath" ]; then
                    echo -ne "$testpath" "$testprog" "- "

                    if [ "${testtype}" == "screenshot" ]
                    then
                        getscreenshotname "$testpath" "$testprog"
                        if [ "${verbose}" == "1" ]; then
                            echo -ne ["$refscreenshotname"]
                        fi
                    fi

                    if [ "${testtype}" == "screenshot" ] && [ "$refscreenshotname" == "" ]
                    then
                        echo "reference screenshot missing (skipped)"
                    else
                        "$target"_run_"$testtype" "$testpath" "$testprog" "$testtimeout" "$testoptions"
        #                echo "exited with: " $exitcode
                        case "$exitcode" in
                            0)
                                    exitstatus="ok"
                                ;;
                            1)
                                    exitstatus="timeout"
                                ;;
                            255)
                                    exitstatus="error"
                                ;;
                            *)
                                    exitstatus="error"
                                ;;
                        esac
                        echo "$exitstatus"
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
        fi
    fi
}

###############################################################################
function showhelp
{
    echo $NAME" - run test programs."
    echo "usage: "$NAME" [target] <filter> <options>"
    echo "  targets: x64, x64sc, x128, xscpu64, x64dtv, xpet, xcbm2, xcbm5x0, xvic, xplus4, vsid, chameleon"
    echo "  <filter> is a substring of the path of tests to restrict to"
    echo "  --help       show this help"
    echo "  --verbose    be more verbose"
    echo "  --pal        skip tests that do not work on PAL"
    echo "  --ntsc       skip tests that do not work on NTSC"
    echo "  --ntscold    skip tests that do not work on NTSC(old)"
    echo "  --8565       target VICII type is 8565 (grey dot)"
    echo "  --8565early  target VICII type is 8565 (new color instead of grey dot)"
    echo "  --8565late   target VICII type is 8565 (old color instead of grey dot)"
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
        --8565) # "new" VICII (grey dot)
                videosubtype="8565"
            ;;
        --8565early) # "new" VICII (no grey dot, new color instead)
                videosubtype="8565early"
            ;;
        --8565late) # "new" VICII (no grey dot, old color instead)
                videosubtype="8565late"
            ;;
        *) # is either target or filter
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
    echo "video subtype:" "$videosubtype"
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
