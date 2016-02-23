#! /bin/bash
###############################################################################

source "./chameleon-hooks.sh"
source "./x64-hooks.sh"
source "./x64sc-hooks.sh"

function checktarget
{
    case "$1" in
        x64)
                target="$1"
            ;;
        x64sc)
                target="$1"
            ;;
        chameleon)
                target="$1"
            ;;
        *)
            echo "error:" "$1" "is not a valid target."
            exit -1
            ;;
    esac
}

# read the list of tests for the given target
function gettestsfortarget
{
#    echo "reading list of tests for" "$1".
    readarray -t testlist < "$1"-testlist.txt
}

function runprogsfortarget
{
    checktarget "$1"
    echo "running tests for" "$target"":"

    gettestsfortarget "$target"
    rm -f "$target"_result.txt

    for e in "${testlist[@]}"
    do
#        echo "$e"
        if [ "${e:0:1}" != "#" ]; then
            IFS=',' read -a myarray <<< "$e"

            arraylength=${#myarray[@]}
            if [ "$arraylength" -lt "4" ]; then
                echo "error: unexpected end of line in input"
                exit -1
            fi

            testpath="${myarray[0]}"
            testprog="${myarray[1]}"
            testtype="${myarray[2]}"
            testtimeout="${myarray[3]}"

            testoptions=""
            for (( i=5; i<${arraylength}+1; i++ ));
            do
#                echo $i " / " ${arraylength} " : " ${myarray[$i-1]}
                "$target"_get_options "${myarray[$i-1]}"
#                echo "exitoptions: $exitoptions"
                testoptions+="$exitoptions"
            done

#            echo " path: $testpath"
#            echo " program: $testprog"
#            echo " type: $testtype"
#            echo " timeout: $testtimeout"
#            echo " options: $testoptions"
            if [ "${testtype}" == "interactive" ]; then
                echo "$testpath" "$testprog" "- " "interactive (skipped)"
            else
                echo -ne "$testpath" "$testprog" "- "
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
        fi
    done
}

function showfailedfortarget
{
    checktarget "$1"
    echo "failed tests for" "$target"":"
    grep "error" "$target"_result.txt
    grep "timeout" "$target"_result.txt
}

###############################################################################

case "$1" in
     -help)
            echo $NAME" - run test programs."
            echo "usage: "$NAME" [target]"
            echo "  targets: x64, x64sc, chameleon"
            echo "  -help       show this help"
            exit
           ;;
     *)
        if [ "$1" = "" ] ; then
            $0 -help
            exit
        fi
        SECONDS=0
        runprogsfortarget "$1"
        duration=$SECONDS
        echo "$(($duration / 60)) minutes and $(($duration % 60)) seconds elapsed."
        showfailedfortarget "$1"
           ;;
esac

exit 0;
