#! /bin/bash

if [ "$EMUDIR" == "" ] ; then
    EMUDIR="../../trunk/vice/src/"
fi

set -Eeuo pipefail

C1541="$EMUDIR/c1541"
TESTDIR="test"

mkdir -p "$TESTDIR"

# make a disk image of each supported format

$C1541 -format "test 1541,ab" d64 "$TESTDIR"/test.d64 8
$C1541 -format "test 1571,ab" d71 "$TESTDIR"/test.d71 8
$C1541 -format "test 1581,ab" d81 "$TESTDIR"/test.d81 8

# TODO: add many more tests here :)

echo "done."
