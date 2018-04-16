#!/bin/bash

# read the list of tests
function gettests
{
#    echo "reading list of tests for" "$1".
# readarray does only work on bash4 (not in mingw)
#    readarray -t testlist < "$1"-testlist.txt
    IFS=$'\n' read -d '' -r -a testlist < "$1"
}

function getresults
{
    if [ "$2" == "" ]; then
        return
    fi
#    echo "reading list of tests for" "$2".
# readarray does only work on bash4 (not in mingw)
#    readarray -t testlist < "$2"-testlist.txt
    IFS=$'\n' read -d '' -r -a resultlist"$1" < "$2"
}

################################################################################

BLUE='\033[1;34m'
YELLOW='\033[1;33m'
GREEN='\033[1;32m'
RED='\033[1;31m'
GREY='\033[1;30m'
WHITE='\033[1;29m'
NC='\033[0m'

function outputheader
{
   case "$outmode" in
        html)
            # html
            echo "<html>"
            echo "<head>"
            echo "<title>VICE testbench results ("$target")</title>"
            echo "<style type=\"text/css\">"
            echo "body                  { background-color: #ffffff; color: #000000; font: normal 10px Verdana, Arial, sans-serif;}"
            echo "#maintable            { border-collapse: collapse; border: 1px solid black; }"
            echo "#maintable td         { border: 1px solid black; }"
            echo "#maintable td.inter   { background-color: #cccccc; color: #888888; }"
            echo "#maintable td.na      { background-color: #cccccc; color: #888888; }"
            echo "#maintable td.ok      { background-color: #ccffcc; color: #00ff00; }"
            echo "#maintable td.error   { background-color: #ffcccc; color: #ff0000; }"
            echo "#maintable td.timeout { background-color: #ccccff; color: #0000ff; }"
            echo "</style>"
            echo "</head>"
            echo "<body>"
            
            echo "<a href=\"results.html\">index</a>"
            echo "<a href=\"sid.html\">sid</a>"
            echo "<a href=\"c64.html\">c64</a>"
            echo "<a href=\"vic20.html\">vic20</a>"
            echo "<a href=\"c128.html\">c128</a>"
            echo "<a href=\"plus4.html\">plus4</a>"
            echo "<a href=\"pet.html\">pet</a>"
            echo "<a href=\"dtv.html\">dtv</a>"
            echo "<a href=\"scpu.html\">scpu</a>"
            echo "<a href=\"cbm5x0.html\">cbm5x0</a>"
            echo "<a href=\"cbm2.html\">cbm2</a>"

            echo "<hr><table style=\"width: 100%\" id=\"maintable\">"
        ;;
        *)
            # terminal
        ;;
    esac
}

function outputfooter
{
   case "$outmode" in
        html)
            # html
            echo "</table>"
            echo "</body></html>"
        ;;
        *)
            # terminal
        ;;
    esac
}

SFLINK="https://sourceforge.net/p/vice-emu/code/HEAD/tree/testprogs/testbench"

# $1 test path
# $2 test exe
# $3 test type
# $4 mountd64
# $5 mountg64
# $6 mountcrt
function outputrowstart
{
    if [ x"$1"x != x""x ]; then
        case "$outmode" in
            html)
                # html
                echo "<tr><td>"
                echo "<a href=\"$SFLINK/$1\">"$1"</a>"
                echo "<a href=\"$SFLINK/$1/$2?format=raw\">"$2"</a>"
                echo "$4" "$5" "$6""</td>"
                if [ x"$3"x != x"exitcode"x ]; then
                    echo "  <td>""$3""</td>"
                else
                    echo "  <td></td>"
                fi
            ;;
            *)
                # terminal
            ;;
        esac
    else
        case "$outmode" in
            html)
                # html
                echo "<tr><td></td><td></td>"
            ;;
            *)
                # terminal
            ;;
        esac
    fi
}

# $1 test path
# $2 test exe
# $3 mountd64
# $4 mountg64
# $5 mountcrt
function outputrowend
{
   case "$outmode" in
        html)
            # html
            echo "</tr>"
        ;;
        *)
            # terminal
            echo "$1" "$2"
        ;;
    esac
}

function outputrowheader
{
   case "$outmode" in
        html)
            # html
            echo "<th>"$1"</th>"
        ;;
        *)
            # terminal
            tmp="$1            "
            echo -ne ${WHITE}"${tmp:0:7} "${NC}
        ;;
    esac
}

# $1 test result
# $2 test type
function outputcolumn
{
   case "$outmode" in
        html)
            # html
            case "$1" in
                "n/a")
                    if [ "$2" == "interactive" ]; then
                        echo "  <td class=\"inter\">manual</td>"
                    else
                        echo "  <td class=\"na\">""$1""</td>"
                    fi
                ;;
                "ok")
                    echo "  <td class=\"ok\">""$1""</td>"
                ;;
                "error")
                    echo "  <td class=\"error\">""$1""</td>"
                ;;
                "timeout")
                    echo "  <td class=\"timeout\">""$1""</td>"
                ;;
                *)
                    echo "  <td>""$1""</td>"
                ;;
            esac
        ;;
        *)
            # terminal
            tmp="$1            "
            
            case "$1" in
                "n/a")
                    if [ "$2" == "interactive" ]; then
                        echo -ne ${GREY}"manual  "${NC}
                    else
                        echo -ne ${GREY}"${tmp:0:7} "${NC}
                    fi
                ;;
                "ok")
                    echo -ne ${GREEN}"${tmp:0:7} "${NC}
                ;;
                "error")
                    echo -ne ${RED}"${tmp:0:7} "${NC}
                ;;
                "timeout")
                    echo -ne ${BLUE}"${tmp:0:7} "${NC}
                ;;
                *)
                    echo -ne "${tmp:0:7} "
                ;;
            esac
        ;;
    esac
}


################################################################################

# $1 resultlist? FIXME
# $2 test path
# $3 test exe
# $4 test type
function findresult0
{
    for r in "${resultlist0[@]}"
    do
#        echo "check:$r"
        if [ "${r:0:1}" != "#" ]; then
            IFS=',' read -a myarray <<< "$r"
    #        echo 1: x"$2"x == x"${myarray[0]}"x x"$3"x == x"${myarray[1]}"x x"$4"x == x"${myarray[3]}"x x"$5"x == x"${myarray[4]}"x x"$6"x == x"${myarray[5]}"x x"$7"x == x"${myarray[6]}"x
            if [ x"$2"x == x"${myarray[0]}"x ] && 
            [ x"$3"x == x"${myarray[1]}"x ] && 
            [ x"$4"x == x"${myarray[3]}"x ] && 
            [ x"$5"x == x"${myarray[4]}"x ] && 
            [ x"$6"x == x"${myarray[5]}"x ] && 
            [ x"$7"x == x"${myarray[6]}"x ]; then
                outputcolumn ${myarray[2]} "$4"
                return
            fi
        fi
    done
    outputcolumn "n/a" "$4"
}

function findresult1
{
    for r in "${resultlist1[@]}"
    do
#        echo "check:$r"
        if [ "${r:0:1}" != "#" ]; then
            IFS=',' read -a myarray <<< "$r"
            if [ x"$2"x == x"${myarray[0]}"x ] && 
            [ x"$3"x == x"${myarray[1]}"x ] && 
            [ x"$4"x == x"${myarray[3]}"x ] && 
            [ x"$5"x == x"${myarray[4]}"x ] && 
            [ x"$6"x == x"${myarray[5]}"x ] && 
            [ x"$7"x == x"${myarray[6]}"x ]; then
                outputcolumn ${myarray[2]} "$4"
                return
            fi
        fi
    done
#    echo 2: x"$2"x == x"${myarray[0]}"x x"$3"x == x"${myarray[1]}"x x"$4"x == x"${myarray[3]}"x x"$5"x == x"${myarray[4]}"x x"$6"x == x"${myarray[5]}"x x"$7"x == x"${myarray[6]}"x
    outputcolumn "n/a" "$4"
}

function findresult2
{
    for r in "${resultlist2[@]}"
    do
#        echo "check:$r"
        if [ "${r:0:1}" != "#" ]; then
            IFS=',' read -a myarray <<< "$r"
            if [ x"$2"x == x"${myarray[0]}"x ] && 
            [ x"$3"x == x"${myarray[1]}"x ] && 
            [ x"$4"x == x"${myarray[3]}"x ] && 
            [ x"$5"x == x"${myarray[4]}"x ] && 
            [ x"$6"x == x"${myarray[5]}"x ] && 
            [ x"$7"x == x"${myarray[6]}"x ]; then
                outputcolumn ${myarray[2]} "$4"
                return
            fi
        fi
    done
    outputcolumn "n/a" "$4"
}

function findresult3
{
    for r in "${resultlist3[@]}"
    do
        if [ "${r:0:1}" != "#" ]; then
            IFS=',' read -a myarray <<< "$r"
            if [ x"$2"x == x"${myarray[0]}"x ] && 
            [ x"$3"x == x"${myarray[1]}"x ] && 
            [ x"$4"x == x"${myarray[3]}"x ] && 
            [ x"$5"x == x"${myarray[4]}"x ] && 
            [ x"$6"x == x"${myarray[5]}"x ] && 
            [ x"$7"x == x"${myarray[6]}"x ]; then
                outputcolumn ${myarray[2]} "$4"
                return
            fi
        fi
    done
    outputcolumn "n/a" "$4"
}

function findresult4
{
    for r in "${resultlist4[@]}"
    do
        if [ "${r:0:1}" != "#" ]; then
            IFS=',' read -a myarray <<< "$r"
            if [ x"$2"x == x"${myarray[0]}"x ] && 
            [ x"$3"x == x"${myarray[1]}"x ] && 
            [ x"$4"x == x"${myarray[3]}"x ] && 
            [ x"$5"x == x"${myarray[4]}"x ] && 
            [ x"$6"x == x"${myarray[5]}"x ] && 
            [ x"$7"x == x"${myarray[6]}"x ]; then
                outputcolumn ${myarray[2]} "$4"
                return
            fi
        fi
    done
    outputcolumn "n/a" "$4"
}

function findresult5
{
    for r in "${resultlist5[@]}"
    do
        if [ "${r:0:1}" != "#" ]; then
            IFS=',' read -a myarray <<< "$r"
            if [ x"$2"x == x"${myarray[0]}"x ] && 
            [ x"$3"x == x"${myarray[1]}"x ] && 
            [ x"$4"x == x"${myarray[3]}"x ] && 
            [ x"$5"x == x"${myarray[4]}"x ] && 
            [ x"$6"x == x"${myarray[5]}"x ] && 
            [ x"$7"x == x"${myarray[6]}"x ]; then
                outputcolumn ${myarray[2]} "$4"
                return
            fi
        fi
    done
    outputcolumn "n/a" "$4"
}

function findresult6
{
    for r in "${resultlist6[@]}"
    do
        if [ "${r:0:1}" != "#" ]; then
            IFS=',' read -a myarray <<< "$r"
            if [ x"$2"x == x"${myarray[0]}"x ] && 
            [ x"$3"x == x"${myarray[1]}"x ] && 
            [ x"$4"x == x"${myarray[3]}"x ] && 
            [ x"$5"x == x"${myarray[4]}"x ] && 
            [ x"$6"x == x"${myarray[5]}"x ] && 
            [ x"$7"x == x"${myarray[6]}"x ]; then
                outputcolumn ${myarray[2]} "$4"
                return
            fi
        fi
    done
    outputcolumn "n/a" "$4"
}

function findresult7
{
    for r in "${resultlist7[@]}"
    do
        if [ "${r:0:1}" != "#" ]; then
            IFS=',' read -a myarray <<< "$r"
            if [ x"$2"x == x"${myarray[0]}"x ] && 
            [ x"$3"x == x"${myarray[1]}"x ] && 
            [ x"$4"x == x"${myarray[3]}"x ] && 
            [ x"$5"x == x"${myarray[4]}"x ] && 
            [ x"$6"x == x"${myarray[5]}"x ] && 
            [ x"$7"x == x"${myarray[6]}"x ]; then
                outputcolumn ${myarray[2]} "$4"
                return
            fi
        fi
    done
    outputcolumn "n/a" "$4"
}

function findresult8
{
    for r in "${resultlist8[@]}"
    do
        if [ "${r:0:1}" != "#" ]; then
            IFS=',' read -a myarray <<< "$r"
            if [ x"$2"x == x"${myarray[0]}"x ] && 
            [ x"$3"x == x"${myarray[1]}"x ] && 
            [ x"$4"x == x"${myarray[3]}"x ] && 
            [ x"$5"x == x"${myarray[4]}"x ] && 
            [ x"$6"x == x"${myarray[5]}"x ] && 
            [ x"$7"x == x"${myarray[6]}"x ]; then
                outputcolumn ${myarray[2]} "$4"
                return
            fi
        fi
    done
    outputcolumn "n/a" "$4"
}

function findresult9
{
    for r in "${resultlist9[@]}"
    do
        if [ "${r:0:1}" != "#" ]; then
            IFS=',' read -a myarray <<< "$r"
            if [ x"$2"x == x"${myarray[0]}"x ] && 
            [ x"$3"x == x"${myarray[1]}"x ] && 
            [ x"$4"x == x"${myarray[3]}"x ] && 
            [ x"$5"x == x"${myarray[4]}"x ] && 
            [ x"$6"x == x"${myarray[5]}"x ] && 
            [ x"$7"x == x"${myarray[6]}"x ]; then
                outputcolumn ${myarray[2]} "$4"
                return
            fi
        fi
    done
    outputcolumn "n/a" "$4"
}

function findresult10
{
    for r in "${resultlist10[@]}"
    do
        if [ "${r:0:1}" != "#" ]; then
            IFS=',' read -a myarray <<< "$r"
            if [ x"$2"x == x"${myarray[0]}"x ] && 
            [ x"$3"x == x"${myarray[1]}"x ] && 
            [ x"$4"x == x"${myarray[3]}"x ] && 
            [ x"$5"x == x"${myarray[4]}"x ] && 
            [ x"$6"x == x"${myarray[5]}"x ] && 
            [ x"$7"x == x"${myarray[6]}"x ]; then
                outputcolumn ${myarray[2]} "$4"
                return
            fi
        fi
    done
    outputcolumn "n/a" "$4"
}

################################################################################

function reset_options
{
    exitoptions=-1
    testprogvideotype=""
    new_cia_enabled=-1
    new_sid_enabled=-1
    reu_enabled=0
    georam_enabled=0
    plus60k_enabled=0
    plus256k_enabled=0
    dqbb_enabled=0
    ramcart_enabled=0
    isepic_enabled=0
    mountd64=""
    mountg64=""
    mountcrt=""
}

function set_options
{
    case "$1" in
        "default")
                exitoptions=""
            ;;
        "vicii-pal")
                testprogvideotype="PAL"
            ;;
        "vicii-ntsc")
                testprogvideotype="NTSC"
            ;;
        "vicii-ntscold")
                testprogvideotype="NTSCOLD"
            ;;
        "cia-old")
                new_cia_enabled=0
            ;;
        "cia-new")
                new_cia_enabled=1
            ;;
        "sid-old")
                new_sid_enabled=0
            ;;
        "sid-new")
                new_sid_enabled=1
            ;;
        "reu512k")
                reu_enabled=1
            ;;
        "geo256k")
                georam_enabled=1
            ;;
        "plus60k")
                plus60k_enabled=1
            ;;
        "plus256k")
                plus256k_enabled=1
            ;;
        "dqbb")
                dqbb_enabled=1
            ;;
        "ramcart128k")
                ramcart_enabled=1
            ;;
        "isepic")
                isepic_enabled=1
            ;;
        *)
                if [ "${1:0:9}" == "mountd64:" ]; then
                    mountd64="${1:9}"
                fi
                if [ "${1:0:9}" == "mountg64:" ]; then
                    mountg64="${1:9}"
                fi
                if [ "${1:0:9}" == "mountcrt:" ]; then
                    mountcrt="${1:9}"
                fi
            ;;
    esac
}

function outputtable
{
    outputheader
    outputrowstart
    outputrowheader "${header[0]}"
    if [ "${resultcolums}" -gt "1" ]; then
        outputrowheader "${header[1]}"
        if [ "${resultcolums}" -gt "2" ]; then
            outputrowheader "${header[2]}"
            if [ "${resultcolums}" -gt "3" ]; then
                outputrowheader "${header[3]}"
                if [ "${resultcolums}" -gt "4" ]; then
                    outputrowheader "${header[4]}"
                    if [ "${resultcolums}" -gt "5" ]; then
                        outputrowheader "${header[5]}"
                        if [ "${resultcolums}" -gt "6" ]; then
                            outputrowheader "${header[6]}"
                            if [ "${resultcolums}" -gt "7" ]; then
                                outputrowheader "${header[7]}"
                                if [ "${resultcolums}" -gt "8" ]; then
                                    outputrowheader "${header[8]}"
                                    if [ "${resultcolums}" -gt "9" ]; then
                                        outputrowheader "${header[9]}"
                                        if [ "${resultcolums}" -gt "10" ]; then
                                            outputrowheader "${header[10]}"
                                        fi
                                    fi
                                fi
                            fi
                        fi
                    fi
                fi
            fi
        fi
    fi
    outputrowend
    for e in "${testlist[@]}"
    do
        if [ "${e:0:1}" != "#" ]; then
            IFS=',' read -a myarray1 <<< "$e"
#            echo -ne "$e - "
#            echo -ne "${myarray1[0]} ${myarray1[1]}\t"
#            echo -ne " "

            reset_options
            arraylength=${#myarray1[@]}
            for (( i=5; i<${arraylength}+1; i++ ));
            do
#               echo $i " / " ${arraylength} " : " ${myarray1[$i-1]}
                set_options "${myarray1[$i-1]}"
            done


            outputrowstart "${myarray1[0]}" "${myarray1[1]}" "${myarray1[2]}" "${mountd64}" "${mountg64}" "${mountcrt}"
            findresult0 resultlist0 "${myarray1[0]}" "${myarray1[1]}" "${myarray1[2]}" "${mountd64}" "${mountg64}" "${mountcrt}"
            if [ "${resultcolums}" -gt "1" ]; then
                findresult1 resultlist1 "${myarray1[0]}" "${myarray1[1]}" "${myarray1[2]}" "${mountd64}" "${mountg64}" "${mountcrt}"
                if [ "${resultcolums}" -gt "2" ]; then
                    findresult2 resultlist2 "${myarray1[0]}" "${myarray1[1]}" "${myarray1[2]}" "${mountd64}" "${mountg64}" "${mountcrt}"
                    if [ "${resultcolums}" -gt "3" ]; then
                        findresult3 resultlist3 "${myarray1[0]}" "${myarray1[1]}" "${myarray1[2]}" "${mountd64}" "${mountg64}" "${mountcrt}"
                        if [ "${resultcolums}" -gt "4" ]; then
                            findresult4 resultlist4 "${myarray1[0]}" "${myarray1[1]}" "${myarray1[2]}" "${mountd64}" "${mountg64}" "${mountcrt}"
                            if [ "${resultcolums}" -gt "5" ]; then
                                findresult5 resultlist5 "${myarray1[0]}" "${myarray1[1]}" "${myarray1[2]}" "${mountd64}" "${mountg64}" "${mountcrt}"
                                if [ "${resultcolums}" -gt "6" ]; then
                                    findresult6 resultlist6 "${myarray1[0]}" "${myarray1[1]}" "${myarray1[2]}" "${mountd64}" "${mountg64}" "${mountcrt}"
                                    if [ "${resultcolums}" -gt "7" ]; then
                                        findresult7 resultlist7 "${myarray1[0]}" "${myarray1[1]}" "${myarray1[2]}" "${mountd64}" "${mountg64}" "${mountcrt}"
                                        if [ "${resultcolums}" -gt "8" ]; then
                                            findresult8 resultlist8 "${myarray1[0]}" "${myarray1[1]}" "${myarray1[2]}" "${mountd64}" "${mountg64}" "${mountcrt}"
                                            if [ "${resultcolums}" -gt "9" ]; then
                                                findresult9 resultlist9 "${myarray1[0]}" "${myarray1[1]}" "${myarray1[2]}" "${mountd64}" "${mountg64}" "${mountcrt}"
                                                if [ "${resultcolums}" -gt "10" ]; then
                                                    findresult10 resultlist10 "${myarray1[0]}" "${myarray1[1]}" "${myarray1[2]}" "${mountd64}" "${mountg64}" "${mountcrt}"
                                                fi
                                            fi
                                        fi
                                    fi
                                fi
                            fi
                        fi
                    fi
                fi
            fi
#            echo " "
            outputrowend "${myarray1[0]}" "${myarray1[1]}" "${myarray1[2]}" "${mountd64}" "${mountg64}" "${mountcrt}"
        fi
    done
    outputfooter
}

################################################################################

function checktarget
{
    case "$1" in
    # C64 targets
        c64)
                target="$1"
                testlistfile="c64-testlist.in"
                resultsfile[0]="results/x64-result.txt"
                resultsfile[1]="results/x64sc-result.txt"
                resultsfile[2]="results/x128c64-result.txt"
                resultsfile[3]="results/z64kc64-result.txt"
                resultsfile[4]="results/z64kc128c64-result.txt"
                resultsfile[5]="results/hoxs64-result.txt"
                resultsfile[6]="results/micro64-result.txt"
                resultsfile[7]="results/emu64-result.txt"
                resultsfile[8]="results/yace-result.txt"
                resultsfile[9]="results/chameleon-result.txt"
                resultsfile[10]="results/c64rmk2-result.txt"
                header[0]="x64"
                header[1]="x64sc"
                header[2]="x128<br>(c64)"
                header[3]="z64k<br>(c64)"
                header[4]="z64k<br>(c128/c64)"
                header[5]="hoxs64"
                header[6]="micro64"
                header[7]="emu64"
                header[8]="yace"
                header[9]="chameleon"
                header[10]="c64rmk2"
                resultcolums=11
            ;;
    # C128 targets
        c128)
                target="$1"
                testlistfile="c128-testlist.in"
                resultsfile[0]="results/x128-result.txt"
                resultsfile[1]="results/z64kc128-result.txt"
                header[0]="x128"
                header[1]="z64k<br>(c128)"
                resultcolums=2
            ;;
    # SCPU targets
        scpu)
                target="$1"
                testlistfile="scpu-testlist.in"
                resultsfile[0]="results/xscpu64-result.txt"
                header[0]="xscpu64"
                resultcolums=1
            ;;
    # PET targets
        pet)
                target="$1"
                testlistfile="pet-testlist.in"
                resultsfile[0]="results/xpet-result.txt"
                header[0]="xpet"
                resultcolums=1
            ;;
    # CBM2 / CBM500 targets
        cbm5x0)
                target="$1"
                testlistfile="cbm510-testlist.in"
                resultsfile[0]="results/xcbm5x0-result.txt"
                header[0]="xcbm5x0"
                resultcolums=1
            ;;
    # CBM2 / CBM600 targets
        cbm2)
                target="$1"
                testlistfile="cbm610-testlist.in"
                resultsfile[0]="results/xcbm2-result.txt"
                header[0]="xcbm2"
                resultcolums=1
            ;;
    # VIC20 targets
        vic20)
                target="$1"
                testlistfile="vic20-testlist.in"
                resultsfile[0]="results/xvic-result.txt"
                resultsfile[1]="results/z64kvic20-result.txt"
                resultsfile[2]="results/cham20-result.txt"
                header[0]="xvic"
                header[1]="z64k<br>(vic20)"
                header[2]="cham20"
                resultcolums=3
            ;;
    # Plus4 targets
        plus4)
                target="$1"
                testlistfile="plus4-testlist.in"
                resultsfile[0]="results/xplus4-result.txt"
                header[0]="xplus4"
                resultcolums=1
            ;;
    # DTV targets
        dtv)
                target="$1"
                testlistfile="dtv-testlist.in"
                resultsfile[0]="results/x64dtv-result.txt"
                header[0]="x64dtv"
                resultcolums=1
            ;;
    # SID-player targets
        sid)
                target="$1"
                testlistfile="vsid-testlist.in"
                resultsfile[0]="results/vsid-result.txt"
                header[0]="vsid"
                resultcolums=1
            ;;
        *)
            echo "error:" "$1" "is not a valid target. (--help to get help)"
            exit -1
            ;;
    esac
}

###############################################################################
function showhelp
{
    echo $NAME" - show results from test programs."
    echo "usage: "$NAME" [target] <filter> <options>"
    echo "  targets: c64, c128, scpu, dtv, pet, cbm2, cbm5x0, vic, plus4, sid"
    echo "  <filter> is a substring of the path of tests to restrict to"
    echo "  --help       show this help"
    echo "  --verbose    be more verbose"
}

function checkparams
{
    if [ "$target" == "" ]; then
        echo "error: no valid target given (--help to get help)"
        exit -1
    fi
}
###############################################################################

verbose=
outmode=

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
        --html)
                outmode=html
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

################################################################################

checkparams

# echo "tests list:" $testlistfile

gettests $testlistfile

for ((i=0;i<${resultcolums};i++))
do
#    echo "reading" ${resultsfile[$i]}
    getresults $i ${resultsfile[$i]}
done

outputtable
