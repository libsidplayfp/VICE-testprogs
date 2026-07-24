#! /bin/bash
GREEN='\033[1;32m'
RED='\033[1;31m'
NC='\033[0m'

SCRIPT_DIR=$(cd $(dirname "${BASH_SOURCE[0]}") && pwd)

source $SCRIPT_DIR/../Makefile.config

VERBOSE=0

############################################################################

# $1 - emu name
# $2 - variant (none, tde, vfs, tde-disk, vdrive-disk)
# $3 - if 0, ignore test
# $4 - expected return code from c64 test (255: failed, 0: ok, 1: timeout)

function dotest
{

checkopts="$5 $6 $7 $8 $9 ${10} ${11} ${12} ${13} ${14} ${15} ${16} ${17} ${18}"

#if [ "$3" == "0" ] ; then
#    return
#fi

if [ "$VERBOSE" == "1" ] ; then
    echo "-_"
    echo $EMUDIR/$1 -default $checkopts $PROGPRE-$2.$PROGEXT "# -debugcart -limitcycles $LIMITCYCLES"
fi

echo -ne $1" "$checkopts" # ["$2"] "

$EMUDIR/$1 -default $checkopts -debugcart -console -warp -limitcycles $LIMITCYCLES $SCRIPT_DIR/$PROGPRE-$2.$PROGEXT 1> /dev/null 2> /dev/null
exitcode=$?

#echo $exitcode
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
echo -ne "$exitstatus" $NC

if [ "$4" == "$exitcode" ] ; then
    echo -ne $GREEN " [expected]" $NC
else
    echo -ne $RED " [error]" $NC
fi

if [ "$3" == "0" ] ; then
    echo -ne $GREEN " [skipped]" $NC
fi

echo -ne "\n"

}

############################################################################

# -autostartprgmode modes are:
# 0 : virtual filesystem
# 1 : inject to ram (there might be no drive)
# 2 : copy to d64

# -deviceX modes are:
# 0: None           ATTACH_DEVICE_NONE
# 1: Filesystem     ATTACH_DEVICE_FS
# 2: OpenCBM        ATTACH_DEVICE_REAL
# 4: virtual        ATTACH_DEVICE_VIRT  <- this seems to be unused/only used internally?

function alltests_prg
{
echo $EMU":"$PROGPRE-X.$PROGEXT
if [ "$EMU" = "xpet" ] || [ "$EMU" = "xcbm2" ] || [ "$EMU" = "xcbm5x0" ]; then
dotest $EMU none 1 0 -default $OPTS
else
dotest $EMU tde-disk 1 0 -default $OPTS
fi

echo "prg - autostart mode 0 (virtual filesystem, backend: none) - do not handle TDE"
## fsdevice = none
# none (should not work but does?)
dotest $EMU none        1 255 $OPTS $DRIVEON -devicebackend8 0 $BUSDEVOFF +drive8truedrive $TRAPDEVOFF -autostartprgmode 0 +autostart-handle-tde -autostart-warp
dotest $EMU none        1 255 $OPTS $DRIVEON -devicebackend8 0 $BUSDEVOFF +drive8truedrive $TRAPDEVOFF -autostartprgmode 0 +autostart-handle-tde +autostart-warp
# TDEonly
dotest $EMU none        1   1 $OPTS $DRIVEON -devicebackend8 0 $BUSDEVOFF -drive8truedrive $TRAPDEVOFF -autostartprgmode 0 +autostart-handle-tde -autostart-warp
dotest $EMU none        1   1 $OPTS $DRIVEON -devicebackend8 0 $BUSDEVOFF -drive8truedrive $TRAPDEVOFF -autostartprgmode 0 +autostart-handle-tde +autostart-warp

if [ "$TRAPDEVICE" = "yes" ]; then
# vfs only
dotest $EMU none        1   0 $OPTS $DRIVEON -devicebackend8 0 $BUSDEVOFF +drive8truedrive $TRAPDEVON -autostartprgmode 0 +autostart-handle-tde -autostart-warp
dotest $EMU none        1   0 $OPTS $DRIVEON -devicebackend8 0 $BUSDEVOFF +drive8truedrive $TRAPDEVON -autostartprgmode 0 +autostart-handle-tde +autostart-warp
# tde+vfs (can not work, TDE gets in the way)
dotest $EMU tde         0 255 $OPTS $DRIVEON -devicebackend8 0 $BUSDEVOFF -drive8truedrive $TRAPDEVON -autostartprgmode 0 +autostart-handle-tde -autostart-warp
dotest $EMU tde         0 255 $OPTS $DRIVEON -devicebackend8 0 $BUSDEVOFF -drive8truedrive $TRAPDEVON -autostartprgmode 0 +autostart-handle-tde +autostart-warp
fi

if [ "$BUSDEVICE" = "yes" ]; then
# busdev only
dotest $EMU none        1   0 $OPTS $DRIVEON -devicebackend8 0 $BUSDEVON  +drive8truedrive $TRAPDEVOFF -autostartprgmode 0 +autostart-handle-tde -autostart-warp
dotest $EMU none        1   0 $OPTS $DRIVEON -devicebackend8 0 $BUSDEVON  +drive8truedrive $TRAPDEVOFF -autostartprgmode 0 +autostart-handle-tde +autostart-warp
# tde+busdev
dotest $EMU tde         0 255 $OPTS $DRIVEON -devicebackend8 0 $BUSDEVON  -drive8truedrive $TRAPDEVOFF -autostartprgmode 0 +autostart-handle-tde -autostart-warp
dotest $EMU tde         0 255 $OPTS $DRIVEON -devicebackend8 0 $BUSDEVON  -drive8truedrive $TRAPDEVOFF -autostartprgmode 0 +autostart-handle-tde +autostart-warp
if [ "$TRAPDEVICE" = "yes" ]; then
# busdev+traps
dotest $EMU vfs         1 255 $OPTS $DRIVEON -devicebackend8 0 $BUSDEVON  +drive8truedrive $TRAPDEVON -autostartprgmode 0 +autostart-handle-tde -autostart-warp
dotest $EMU vfs         1 255 $OPTS $DRIVEON -devicebackend8 0 $BUSDEVON  +drive8truedrive $TRAPDEVON -autostartprgmode 0 +autostart-handle-tde +autostart-warp
# tde+busdev+traps
dotest $EMU tde         1 255 $OPTS $DRIVEON -devicebackend8 0 $BUSDEVON  -drive8truedrive $TRAPDEVON -autostartprgmode 0 +autostart-handle-tde -autostart-warp
dotest $EMU tde         1 255 $OPTS $DRIVEON -devicebackend8 0 $BUSDEVON  -drive8truedrive $TRAPDEVON -autostartprgmode 0 +autostart-handle-tde +autostart-warp
fi
fi

echo "prg - autostart mode 0 (virtual filesystem, backend: fsdevice) - do not handle TDE"
## fsdevice = filesystem
# TDEonly
dotest $EMU tde         1   1 $OPTS $DRIVEON -devicebackend8 1 $BUSDEVOFF -drive8truedrive $TRAPDEVOFF -autostartprgmode 0 +autostart-handle-tde -autostart-warp
dotest $EMU tde         1   1 $OPTS $DRIVEON -devicebackend8 1 $BUSDEVOFF -drive8truedrive $TRAPDEVOFF -autostartprgmode 0 +autostart-handle-tde +autostart-warp
# none
dotest $EMU none        0 255 $OPTS $DRIVEON -devicebackend8 1 $BUSDEVOFF +drive8truedrive $TRAPDEVOFF -autostartprgmode 0 +autostart-handle-tde -autostart-warp
dotest $EMU none        0 255 $OPTS $DRIVEON -devicebackend8 1 $BUSDEVOFF +drive8truedrive $TRAPDEVOFF -autostartprgmode 0 +autostart-handle-tde +autostart-warp
if [ "$TRAPDEVICE" = "yes" ]; then
# vfs only
dotest $EMU vfs         1   0 $OPTS $DRIVEON -devicebackend8 1 $BUSDEVOFF +drive8truedrive $TRAPDEVON -autostartprgmode 0 +autostart-handle-tde -autostart-warp
dotest $EMU vfs         1   0 $OPTS $DRIVEON -devicebackend8 1 $BUSDEVOFF +drive8truedrive $TRAPDEVON -autostartprgmode 0 +autostart-handle-tde +autostart-warp
# tde+traps
dotest $EMU tde         0 255 $OPTS $DRIVEON -devicebackend8 1 $BUSDEVOFF -drive8truedrive $TRAPDEVON -autostartprgmode 0 +autostart-handle-tde -autostart-warp
dotest $EMU tde         0 255 $OPTS $DRIVEON -devicebackend8 1 $BUSDEVOFF -drive8truedrive $TRAPDEVON -autostartprgmode 0 +autostart-handle-tde +autostart-warp
fi
if [ "$BUSDEVICE" = "yes" ]; then
# iecdev only
dotest $EMU vfs         1   0 $OPTS $DRIVEON -devicebackend8 1 $BUSDEVON  +drive8truedrive $TRAPDEVOFF -autostartprgmode 0 +autostart-handle-tde -autostart-warp
dotest $EMU vfs         1   0 $OPTS $DRIVEON -devicebackend8 1 $BUSDEVON  +drive8truedrive $TRAPDEVOFF -autostartprgmode 0 +autostart-handle-tde +autostart-warp
dotest $EMU tde         0 255 $OPTS $DRIVEON -devicebackend8 1 $BUSDEVON  -drive8truedrive $TRAPDEVOFF -autostartprgmode 0 +autostart-handle-tde -autostart-warp
dotest $EMU tde         0 255 $OPTS $DRIVEON -devicebackend8 1 $BUSDEVON  -drive8truedrive $TRAPDEVOFF -autostartprgmode 0 +autostart-handle-tde +autostart-warp
if [ "$TRAPDEVICE" = "yes" ]; then
dotest $EMU tde         0 255 $OPTS $DRIVEON -devicebackend8 1 $BUSDEVON  -drive8truedrive $TRAPDEVON -autostartprgmode 0 +autostart-handle-tde -autostart-warp
dotest $EMU tde         0 255 $OPTS $DRIVEON -devicebackend8 1 $BUSDEVON  -drive8truedrive $TRAPDEVON -autostartprgmode 0 +autostart-handle-tde +autostart-warp
dotest $EMU vfs         0 255 $OPTS $DRIVEON -devicebackend8 1 $BUSDEVON  +drive8truedrive $TRAPDEVON -autostartprgmode 0 +autostart-handle-tde -autostart-warp
dotest $EMU vfs         0 255 $OPTS $DRIVEON -devicebackend8 1 $BUSDEVON  +drive8truedrive $TRAPDEVON -autostartprgmode 0 +autostart-handle-tde +autostart-warp
fi
fi

echo "prg - autostart mode 1 (inject to RAM, backend: none) - do not handle TDE"
## fsdevice = none
# none
dotest $EMU none        1   0 $OPTS $DRIVEON -devicebackend8 0 $BUSDEVOFF +drive8truedrive $TRAPDEVOFF -autostartprgmode 1 +autostart-handle-tde -autostart-warp
dotest $EMU none        1   0 $OPTS $DRIVEON -devicebackend8 0 $BUSDEVOFF +drive8truedrive $TRAPDEVOFF -autostartprgmode 1 +autostart-handle-tde +autostart-warp
dotest $EMU tde         1   0 $OPTS $DRIVEON -devicebackend8 0 $BUSDEVOFF -drive8truedrive $TRAPDEVOFF -autostartprgmode 1 +autostart-handle-tde -autostart-warp
dotest $EMU tde         1   0 $OPTS $DRIVEON -devicebackend8 0 $BUSDEVOFF -drive8truedrive $TRAPDEVOFF -autostartprgmode 1 +autostart-handle-tde +autostart-warp
if [ "$TRAPDEVICE" = "yes" ]; then
# TDEonly
dotest $EMU tde         0 255 $OPTS $DRIVEON -devicebackend8 0 $BUSDEVOFF -drive8truedrive $TRAPDEVON -autostartprgmode 1 +autostart-handle-tde -autostart-warp
dotest $EMU tde         0 255 $OPTS $DRIVEON -devicebackend8 0 $BUSDEVOFF -drive8truedrive $TRAPDEVON -autostartprgmode 1 +autostart-handle-tde +autostart-warp
# vfs only
dotest $EMU none        1   0 $OPTS $DRIVEON -devicebackend8 0 $BUSDEVOFF +drive8truedrive $TRAPDEVON -autostartprgmode 1 +autostart-handle-tde -autostart-warp
dotest $EMU none        1   0 $OPTS $DRIVEON -devicebackend8 0 $BUSDEVOFF +drive8truedrive $TRAPDEVON -autostartprgmode 1 +autostart-handle-tde +autostart-warp
fi
if [ "$BUSDEVICE" = "yes" ]; then
dotest $EMU tde         0 255 $OPTS $DRIVEON -devicebackend8 0 $BUSDEVON  -drive8truedrive $TRAPDEVOFF -autostartprgmode 1 +autostart-handle-tde -autostart-warp
dotest $EMU tde         0 255 $OPTS $DRIVEON -devicebackend8 0 $BUSDEVON  -drive8truedrive $TRAPDEVOFF -autostartprgmode 1 +autostart-handle-tde +autostart-warp
# iecdev only
dotest $EMU none        1   0 $OPTS $DRIVEON -devicebackend8 0 $BUSDEVON  +drive8truedrive $TRAPDEVOFF -autostartprgmode 1 +autostart-handle-tde -autostart-warp
dotest $EMU none        1   0 $OPTS $DRIVEON -devicebackend8 0 $BUSDEVON  +drive8truedrive $TRAPDEVOFF -autostartprgmode 1 +autostart-handle-tde +autostart-warp
if [ "$TRAPDEVICE" = "yes" ]; then
dotest $EMU tde         0 255 $OPTS $DRIVEON -devicebackend8 0 $BUSDEVON  -drive8truedrive $TRAPDEVON -autostartprgmode 1 +autostart-handle-tde -autostart-warp
dotest $EMU tde         0 255 $OPTS $DRIVEON -devicebackend8 0 $BUSDEVON  -drive8truedrive $TRAPDEVON -autostartprgmode 1 +autostart-handle-tde +autostart-warp
dotest $EMU vfs         0 255 $OPTS $DRIVEON -devicebackend8 0 $BUSDEVON  +drive8truedrive $TRAPDEVON -autostartprgmode 1 +autostart-handle-tde -autostart-warp
dotest $EMU vfs         0 255 $OPTS $DRIVEON -devicebackend8 0 $BUSDEVON  +drive8truedrive $TRAPDEVON -autostartprgmode 1 +autostart-handle-tde +autostart-warp
fi
fi

echo "prg - autostart mode 1 (inject to RAM, backend: fsdevice) - do not handle TDE"
## fsdevice = filesystem
# TDEonly
dotest $EMU tde         1   0 $OPTS $DRIVEON -devicebackend8 1 $BUSDEVOFF -drive8truedrive $TRAPDEVOFF -autostartprgmode 1 +autostart-handle-tde -autostart-warp
dotest $EMU tde         1   0 $OPTS $DRIVEON -devicebackend8 1 $BUSDEVOFF -drive8truedrive $TRAPDEVOFF -autostartprgmode 1 +autostart-handle-tde +autostart-warp
# none
dotest $EMU none        1   0 $OPTS $DRIVEON -devicebackend8 1 $BUSDEVOFF +drive8truedrive $TRAPDEVOFF -autostartprgmode 1 +autostart-handle-tde -autostart-warp
dotest $EMU none        1   0 $OPTS $DRIVEON -devicebackend8 1 $BUSDEVOFF +drive8truedrive $TRAPDEVOFF -autostartprgmode 1 +autostart-handle-tde +autostart-warp
if [ "$TRAPDEVICE" = "yes" ]; then
dotest $EMU tde         0 255 $OPTS $DRIVEON -devicebackend8 1 $BUSDEVOFF -drive8truedrive $TRAPDEVON -autostartprgmode 1 +autostart-handle-tde -autostart-warp
dotest $EMU tde         0 255 $OPTS $DRIVEON -devicebackend8 1 $BUSDEVOFF -drive8truedrive $TRAPDEVON -autostartprgmode 1 +autostart-handle-tde +autostart-warp
# vfs only
dotest $EMU vfs         1   0 $OPTS $DRIVEON -devicebackend8 1 $BUSDEVOFF +drive8truedrive $TRAPDEVON -autostartprgmode 1 +autostart-handle-tde -autostart-warp
dotest $EMU vfs         1   0 $OPTS $DRIVEON -devicebackend8 1 $BUSDEVOFF +drive8truedrive $TRAPDEVON -autostartprgmode 1 +autostart-handle-tde +autostart-warp
fi
if [ "$BUSDEVICE" = "yes" ]; then
dotest $EMU tde         0 255 $OPTS $DRIVEON -devicebackend8 1 $BUSDEVON  -drive8truedrive $TRAPDEVOFF -autostartprgmode 1 +autostart-handle-tde -autostart-warp
dotest $EMU tde         0 255 $OPTS $DRIVEON -devicebackend8 1 $BUSDEVON  -drive8truedrive $TRAPDEVOFF -autostartprgmode 1 +autostart-handle-tde +autostart-warp
# iecdev only
dotest $EMU vfs         1   0 $OPTS $DRIVEON -devicebackend8 1 $BUSDEVON  +drive8truedrive $TRAPDEVOFF -autostartprgmode 1 +autostart-handle-tde -autostart-warp
dotest $EMU vfs         1   0 $OPTS $DRIVEON -devicebackend8 1 $BUSDEVON  +drive8truedrive $TRAPDEVOFF -autostartprgmode 1 +autostart-handle-tde +autostart-warp
if [ "$TRAPDEVICE" = "yes" ]; then
dotest $EMU tde         0 255 $OPTS $DRIVEON -devicebackend8 1 $BUSDEVON  -drive8truedrive $TRAPDEVON -autostartprgmode 1 +autostart-handle-tde -autostart-warp
dotest $EMU tde         0 255 $OPTS $DRIVEON -devicebackend8 1 $BUSDEVON  -drive8truedrive $TRAPDEVON -autostartprgmode 1 +autostart-handle-tde +autostart-warp
dotest $EMU vfs         0 255 $OPTS $DRIVEON -devicebackend8 1 $BUSDEVON  +drive8truedrive $TRAPDEVON -autostartprgmode 1 +autostart-handle-tde -autostart-warp
dotest $EMU vfs         0 255 $OPTS $DRIVEON -devicebackend8 1 $BUSDEVON  +drive8truedrive $TRAPDEVON -autostartprgmode 1 +autostart-handle-tde +autostart-warp
fi
fi

echo "prg - autostart mode 2 (copy to disk image, backend: none) - do not handle TDE"
## fsdevice = none
# TDEonly
dotest $EMU tde-disk    1   0 $OPTS $DRIVEON -devicebackend8 0 $BUSDEVOFF -drive8truedrive $TRAPDEVOFF -autostartprgmode 2 +autostart-handle-tde -autostart-warp
dotest $EMU tde-disk    1   0 $OPTS $DRIVEON -devicebackend8 0 $BUSDEVOFF -drive8truedrive $TRAPDEVOFF -autostartprgmode 2 +autostart-handle-tde +autostart-warp
# none
dotest $EMU none        0 255 $OPTS $DRIVEON -devicebackend8 0 $BUSDEVOFF +drive8truedrive $TRAPDEVOFF -autostartprgmode 2 +autostart-handle-tde -autostart-warp
dotest $EMU none        0 255 $OPTS $DRIVEON -devicebackend8 0 $BUSDEVOFF +drive8truedrive $TRAPDEVOFF -autostartprgmode 2 +autostart-handle-tde +autostart-warp
if [ "$TRAPDEVICE" = "yes" ]; then
dotest $EMU tde-disk    0 255 $OPTS $DRIVEON -devicebackend8 0 $BUSDEVOFF -drive8truedrive $TRAPDEVON -autostartprgmode 2 +autostart-handle-tde -autostart-warp
dotest $EMU tde-disk    0 255 $OPTS $DRIVEON -devicebackend8 0 $BUSDEVOFF -drive8truedrive $TRAPDEVON -autostartprgmode 2 +autostart-handle-tde +autostart-warp
# vfs only
dotest $EMU vdrive-disk 1   0 $OPTS $DRIVEON -devicebackend8 0 $BUSDEVOFF +drive8truedrive $TRAPDEVON -autostartprgmode 2 +autostart-handle-tde -autostart-warp
dotest $EMU vdrive-disk 1   0 $OPTS $DRIVEON -devicebackend8 0 $BUSDEVOFF +drive8truedrive $TRAPDEVON -autostartprgmode 2 +autostart-handle-tde +autostart-warp
fi
if [ "$BUSDEVICE" = "yes" ]; then
dotest $EMU tde-disk    0 255 $OPTS $DRIVEON -devicebackend8 0 $BUSDEVON  -drive8truedrive $TRAPDEVOFF -autostartprgmode 2 +autostart-handle-tde -autostart-warp
dotest $EMU tde-disk    0 255 $OPTS $DRIVEON -devicebackend8 0 $BUSDEVON  -drive8truedrive $TRAPDEVOFF -autostartprgmode 2 +autostart-handle-tde +autostart-warp
# iecdev only
dotest $EMU vdrive-disk 1   0 $OPTS $DRIVEON -devicebackend8 0 $BUSDEVON  +drive8truedrive $TRAPDEVOFF -autostartprgmode 2 +autostart-handle-tde -autostart-warp
dotest $EMU vdrive-disk 1   0 $OPTS $DRIVEON -devicebackend8 0 $BUSDEVON  +drive8truedrive $TRAPDEVOFF -autostartprgmode 2 +autostart-handle-tde +autostart-warp
if [ "$TRAPDEVICE" = "yes" ]; then
dotest $EMU tde-disk    0 255 $OPTS $DRIVEON -devicebackend8 0 $BUSDEVON  -drive8truedrive $TRAPDEVON -autostartprgmode 2 +autostart-handle-tde -autostart-warp
dotest $EMU tde-disk    0 255 $OPTS $DRIVEON -devicebackend8 0 $BUSDEVON  -drive8truedrive $TRAPDEVON -autostartprgmode 2 +autostart-handle-tde +autostart-warp
dotest $EMU vdrive-disk 0 255 $OPTS $DRIVEON -devicebackend8 0 $BUSDEVON  +drive8truedrive $TRAPDEVON -autostartprgmode 2 +autostart-handle-tde -autostart-warp
dotest $EMU vdrive-disk 0 255 $OPTS $DRIVEON -devicebackend8 0 $BUSDEVON  +drive8truedrive $TRAPDEVON -autostartprgmode 2 +autostart-handle-tde +autostart-warp
fi
fi

echo "prg - autostart mode 2 (copy to disk image, backend: fsdevice) - do not handle TDE"
## fsdevice = filesystem
# TDEonly
dotest $EMU tde-disk    1   0 $OPTS $DRIVEON -devicebackend8 1 $BUSDEVOFF -drive8truedrive $TRAPDEVOFF -autostartprgmode 2 +autostart-handle-tde -autostart-warp
dotest $EMU tde-disk    1   0 $OPTS $DRIVEON -devicebackend8 1 $BUSDEVOFF -drive8truedrive $TRAPDEVOFF -autostartprgmode 2 +autostart-handle-tde +autostart-warp
# none
dotest $EMU none        0 255 $OPTS $DRIVEON -devicebackend8 1 $BUSDEVOFF +drive8truedrive $TRAPDEVOFF -autostartprgmode 2 +autostart-handle-tde -autostart-warp
dotest $EMU none        0 255 $OPTS $DRIVEON -devicebackend8 1 $BUSDEVOFF +drive8truedrive $TRAPDEVOFF -autostartprgmode 2 +autostart-handle-tde +autostart-warp
if [ "$TRAPDEVICE" = "yes" ]; then
dotest $EMU tde-disk    0 255 $OPTS $DRIVEON -devicebackend8 1 $BUSDEVOFF -drive8truedrive $TRAPDEVON -autostartprgmode 2 +autostart-handle-tde -autostart-warp
dotest $EMU tde-disk    0 255 $OPTS $DRIVEON -devicebackend8 1 $BUSDEVOFF -drive8truedrive $TRAPDEVON -autostartprgmode 2 +autostart-handle-tde +autostart-warp
# vfs only
dotest $EMU vdrive-disk 1   0 $OPTS $DRIVEON -devicebackend8 1 $BUSDEVOFF +drive8truedrive $TRAPDEVON -autostartprgmode 2 +autostart-handle-tde -autostart-warp
dotest $EMU vdrive-disk 1   0 $OPTS $DRIVEON -devicebackend8 1 $BUSDEVOFF +drive8truedrive $TRAPDEVON -autostartprgmode 2 +autostart-handle-tde +autostart-warp
fi
if [ "$BUSDEVICE" = "yes" ]; then
dotest $EMU tde-disk    0 255 $OPTS $DRIVEON -devicebackend8 1 $BUSDEVON  -drive8truedrive $TRAPDEVOFF -autostartprgmode 2 +autostart-handle-tde -autostart-warp
dotest $EMU tde-disk    0 255 $OPTS $DRIVEON -devicebackend8 1 $BUSDEVON  -drive8truedrive $TRAPDEVOFF -autostartprgmode 2 +autostart-handle-tde +autostart-warp
# iecdev only
dotest $EMU vdrive-disk 1   0 $OPTS $DRIVEON -devicebackend8 1 $BUSDEVON  +drive8truedrive $TRAPDEVOFF -autostartprgmode 2 +autostart-handle-tde -autostart-warp
dotest $EMU vdrive-disk 1   0 $OPTS $DRIVEON -devicebackend8 1 $BUSDEVON  +drive8truedrive $TRAPDEVOFF -autostartprgmode 2 +autostart-handle-tde +autostart-warp
if [ "$TRAPDEVICE" = "yes" ]; then
dotest $EMU tde-disk    0 255 $OPTS $DRIVEON -devicebackend8 1 $BUSDEVON  -drive8truedrive $TRAPDEVON -autostartprgmode 2 +autostart-handle-tde -autostart-warp
dotest $EMU tde-disk    0 255 $OPTS $DRIVEON -devicebackend8 1 $BUSDEVON  -drive8truedrive $TRAPDEVON -autostartprgmode 2 +autostart-handle-tde +autostart-warp
dotest $EMU vdrive-disk 0 255 $OPTS $DRIVEON -devicebackend8 1 $BUSDEVON  +drive8truedrive $TRAPDEVON -autostartprgmode 2 +autostart-handle-tde -autostart-warp
dotest $EMU vdrive-disk 0 255 $OPTS $DRIVEON -devicebackend8 1 $BUSDEVON  +drive8truedrive $TRAPDEVON -autostartprgmode 2 +autostart-handle-tde +autostart-warp
fi
fi

echo "prg - autostart mode 0 (virtual filesystem, backend: none) - handle TDE"
## fsdevice = none
# TDEonly
dotest $EMU tde         1   1 $OPTS $DRIVEON -devicebackend8 0 $BUSDEVOFF -drive8truedrive $TRAPDEVOFF -autostartprgmode 0 -autostart-handle-tde -autostart-warp
dotest $EMU tde         1   1 $OPTS $DRIVEON -devicebackend8 0 $BUSDEVOFF -drive8truedrive $TRAPDEVOFF -autostartprgmode 0 -autostart-handle-tde +autostart-warp
# none
dotest $EMU none        0 255 $OPTS $DRIVEON -devicebackend8 0 $BUSDEVOFF +drive8truedrive $TRAPDEVOFF -autostartprgmode 0 -autostart-handle-tde -autostart-warp
dotest $EMU none        0 255 $OPTS $DRIVEON -devicebackend8 0 $BUSDEVOFF +drive8truedrive $TRAPDEVOFF -autostartprgmode 0 -autostart-handle-tde +autostart-warp
if [ "$TRAPDEVICE" = "yes" ]; then
dotest $EMU tde         0 255 $OPTS $DRIVEON -devicebackend8 0 $BUSDEVOFF -drive8truedrive $TRAPDEVON -autostartprgmode 0 -autostart-handle-tde -autostart-warp
dotest $EMU tde         0 255 $OPTS $DRIVEON -devicebackend8 0 $BUSDEVOFF -drive8truedrive $TRAPDEVON -autostartprgmode 0 -autostart-handle-tde +autostart-warp
# vfs only
dotest $EMU none        1   0 $OPTS $DRIVEON -devicebackend8 0 $BUSDEVOFF +drive8truedrive $TRAPDEVON -autostartprgmode 0 -autostart-handle-tde -autostart-warp
dotest $EMU none        1   0 $OPTS $DRIVEON -devicebackend8 0 $BUSDEVOFF +drive8truedrive $TRAPDEVON -autostartprgmode 0 -autostart-handle-tde +autostart-warp
fi
if [ "$BUSDEVICE" = "yes" ]; then
dotest $EMU tde         0 255 $OPTS $DRIVEON -devicebackend8 0 $BUSDEVON  -drive8truedrive $TRAPDEVOFF -autostartprgmode 0 -autostart-handle-tde -autostart-warp
dotest $EMU tde         0 255 $OPTS $DRIVEON -devicebackend8 0 $BUSDEVON  -drive8truedrive $TRAPDEVOFF -autostartprgmode 0 -autostart-handle-tde +autostart-warp
# iecdev only
dotest $EMU none        1   0 $OPTS $DRIVEON -devicebackend8 0 $BUSDEVON  +drive8truedrive $TRAPDEVOFF -autostartprgmode 0 -autostart-handle-tde -autostart-warp
dotest $EMU none        1   0 $OPTS $DRIVEON -devicebackend8 0 $BUSDEVON  +drive8truedrive $TRAPDEVOFF -autostartprgmode 0 -autostart-handle-tde +autostart-warp
if [ "$TRAPDEVICE" = "yes" ]; then
dotest $EMU tde         0 255 $OPTS $DRIVEON -devicebackend8 0 $BUSDEVON  -drive8truedrive $TRAPDEVON -autostartprgmode 0 -autostart-handle-tde -autostart-warp
dotest $EMU tde         0 255 $OPTS $DRIVEON -devicebackend8 0 $BUSDEVON  -drive8truedrive $TRAPDEVON -autostartprgmode 0 -autostart-handle-tde +autostart-warp
dotest $EMU vfs         0 255 $OPTS $DRIVEON -devicebackend8 0 $BUSDEVON  +drive8truedrive $TRAPDEVON -autostartprgmode 0 -autostart-handle-tde -autostart-warp
dotest $EMU vfs         0 255 $OPTS $DRIVEON -devicebackend8 0 $BUSDEVON  +drive8truedrive $TRAPDEVON -autostartprgmode 0 -autostart-handle-tde +autostart-warp
fi
fi

echo "prg - autostart mode 0 (virtual filesystem, backend: fsdevice) - handle TDE"
## fsdevice = filesystem
# TDEonly
dotest $EMU tde         1   1 $OPTS $DRIVEON -devicebackend8 1 $BUSDEVOFF -drive8truedrive $TRAPDEVOFF -autostartprgmode 0 -autostart-handle-tde -autostart-warp
dotest $EMU tde         1   1 $OPTS $DRIVEON -devicebackend8 1 $BUSDEVOFF -drive8truedrive $TRAPDEVOFF -autostartprgmode 0 -autostart-handle-tde +autostart-warp
# none
dotest $EMU none        0 255 $OPTS $DRIVEON -devicebackend8 1 $BUSDEVOFF +drive8truedrive $TRAPDEVOFF -autostartprgmode 0 -autostart-handle-tde -autostart-warp
dotest $EMU none        0 255 $OPTS $DRIVEON -devicebackend8 1 $BUSDEVOFF +drive8truedrive $TRAPDEVOFF -autostartprgmode 0 -autostart-handle-tde +autostart-warp
if [ "$TRAPDEVICE" = "yes" ]; then
dotest $EMU tde         0 255 $OPTS $DRIVEON -devicebackend8 1 $BUSDEVOFF -drive8truedrive $TRAPDEVON -autostartprgmode 0 -autostart-handle-tde -autostart-warp
dotest $EMU tde         0 255 $OPTS $DRIVEON -devicebackend8 1 $BUSDEVOFF -drive8truedrive $TRAPDEVON -autostartprgmode 0 -autostart-handle-tde +autostart-warp
# vfs only
dotest $EMU vfs         1   0 $OPTS $DRIVEON -devicebackend8 1 $BUSDEVOFF +drive8truedrive $TRAPDEVON -autostartprgmode 0 -autostart-handle-tde -autostart-warp
dotest $EMU vfs         1   0 $OPTS $DRIVEON -devicebackend8 1 $BUSDEVOFF +drive8truedrive $TRAPDEVON -autostartprgmode 0 -autostart-handle-tde +autostart-warp
fi
if [ "$BUSDEVICE" = "yes" ]; then
dotest $EMU tde         0 255 $OPTS $DRIVEON -devicebackend8 1 $BUSDEVON  -drive8truedrive $TRAPDEVOFF -autostartprgmode 0 -autostart-handle-tde -autostart-warp
dotest $EMU tde         0 255 $OPTS $DRIVEON -devicebackend8 1 $BUSDEVON  -drive8truedrive $TRAPDEVOFF -autostartprgmode 0 -autostart-handle-tde +autostart-warp
# iecdev only
dotest $EMU vfs         1   0 $OPTS $DRIVEON -devicebackend8 1 $BUSDEVON  +drive8truedrive $TRAPDEVOFF -autostartprgmode 0 -autostart-handle-tde -autostart-warp
dotest $EMU vfs         1   0 $OPTS $DRIVEON -devicebackend8 1 $BUSDEVON  +drive8truedrive $TRAPDEVOFF -autostartprgmode 0 -autostart-handle-tde +autostart-warp
if [ "$TRAPDEVICE" = "yes" ]; then
dotest $EMU tde         0 255 $OPTS $DRIVEON -devicebackend8 1 $BUSDEVON  -drive8truedrive $TRAPDEVON -autostartprgmode 0 -autostart-handle-tde -autostart-warp
dotest $EMU tde         0 255 $OPTS $DRIVEON -devicebackend8 1 $BUSDEVON  -drive8truedrive $TRAPDEVON -autostartprgmode 0 -autostart-handle-tde +autostart-warp
dotest $EMU vfs         0 255 $OPTS $DRIVEON -devicebackend8 1 $BUSDEVON  +drive8truedrive $TRAPDEVON -autostartprgmode 0 -autostart-handle-tde -autostart-warp
dotest $EMU vfs         0 255 $OPTS $DRIVEON -devicebackend8 1 $BUSDEVON  +drive8truedrive $TRAPDEVON -autostartprgmode 0 -autostart-handle-tde +autostart-warp
fi
fi

echo "prg - autostart mode 1 (inject to RAM, backend: none) - handle TDE"
## fsdevice = none
# TDEonly
dotest $EMU tde         1   0 $OPTS $DRIVEON -devicebackend8 0 $BUSDEVOFF -drive8truedrive $TRAPDEVOFF -autostartprgmode 1 -autostart-handle-tde -autostart-warp
dotest $EMU tde         1   0 $OPTS $DRIVEON -devicebackend8 0 $BUSDEVOFF -drive8truedrive $TRAPDEVOFF -autostartprgmode 1 -autostart-handle-tde +autostart-warp
# none
dotest $EMU none        0   0 $OPTS $DRIVEON -devicebackend8 0 $BUSDEVOFF +drive8truedrive $TRAPDEVOFF -autostartprgmode 1 -autostart-handle-tde -autostart-warp
dotest $EMU none        0   0 $OPTS $DRIVEON -devicebackend8 0 $BUSDEVOFF +drive8truedrive $TRAPDEVOFF -autostartprgmode 1 -autostart-handle-tde +autostart-warp
if [ "$TRAPDEVICE" = "yes" ]; then
dotest $EMU tde         0 255 $OPTS $DRIVEON -devicebackend8 0 $BUSDEVOFF -drive8truedrive $TRAPDEVON -autostartprgmode 1 -autostart-handle-tde -autostart-warp
dotest $EMU tde         0 255 $OPTS $DRIVEON -devicebackend8 0 $BUSDEVOFF -drive8truedrive $TRAPDEVON -autostartprgmode 1 -autostart-handle-tde +autostart-warp
# vfs only
dotest $EMU none        1   0 $OPTS $DRIVEON -devicebackend8 0 $BUSDEVOFF +drive8truedrive $TRAPDEVON -autostartprgmode 1 -autostart-handle-tde -autostart-warp
dotest $EMU none        1   0 $OPTS $DRIVEON -devicebackend8 0 $BUSDEVOFF +drive8truedrive $TRAPDEVON -autostartprgmode 1 -autostart-handle-tde +autostart-warp
fi
if [ "$BUSDEVICE" = "yes" ]; then
dotest $EMU tde         0 255 $OPTS $DRIVEON -devicebackend8 0 $BUSDEVON  -drive8truedrive $TRAPDEVOFF -autostartprgmode 1 -autostart-handle-tde -autostart-warp
dotest $EMU tde         0 255 $OPTS $DRIVEON -devicebackend8 0 $BUSDEVON  -drive8truedrive $TRAPDEVOFF -autostartprgmode 1 -autostart-handle-tde +autostart-warp
# iecdev only
dotest $EMU none        1   0 $OPTS $DRIVEON -devicebackend8 0 $BUSDEVON  +drive8truedrive $TRAPDEVOFF -autostartprgmode 1 -autostart-handle-tde -autostart-warp
dotest $EMU none        1   0 $OPTS $DRIVEON -devicebackend8 0 $BUSDEVON  +drive8truedrive $TRAPDEVOFF -autostartprgmode 1 -autostart-handle-tde +autostart-warp
if [ "$TRAPDEVICE" = "yes" ]; then
dotest $EMU tde         0 255 $OPTS $DRIVEON -devicebackend8 0 $BUSDEVON  -drive8truedrive $TRAPDEVON -autostartprgmode 1 -autostart-handle-tde -autostart-warp
dotest $EMU tde         0 255 $OPTS $DRIVEON -devicebackend8 0 $BUSDEVON  -drive8truedrive $TRAPDEVON -autostartprgmode 1 -autostart-handle-tde +autostart-warp
dotest $EMU vfs         0 255 $OPTS $DRIVEON -devicebackend8 0 $BUSDEVON  +drive8truedrive $TRAPDEVON -autostartprgmode 1 -autostart-handle-tde -autostart-warp
dotest $EMU vfs         0 255 $OPTS $DRIVEON -devicebackend8 0 $BUSDEVON  +drive8truedrive $TRAPDEVON -autostartprgmode 1 -autostart-handle-tde +autostart-warp
fi
fi

echo "prg - autostart mode 1 (inject to RAM, backend: fsdevice) - handle TDE"
## fsdevice = filesystem
# TDEonly
dotest $EMU tde         1   0 $OPTS $DRIVEON -devicebackend8 1 $BUSDEVOFF -drive8truedrive $TRAPDEVOFF -autostartprgmode 1 -autostart-handle-tde -autostart-warp
dotest $EMU tde         1   0 $OPTS $DRIVEON -devicebackend8 1 $BUSDEVOFF -drive8truedrive $TRAPDEVOFF -autostartprgmode 1 -autostart-handle-tde +autostart-warp
# none
dotest $EMU none        0   0 $OPTS $DRIVEON -devicebackend8 1 $BUSDEVOFF +drive8truedrive $TRAPDEVOFF -autostartprgmode 1 -autostart-handle-tde -autostart-warp
dotest $EMU none        0   0 $OPTS $DRIVEON -devicebackend8 1 $BUSDEVOFF +drive8truedrive $TRAPDEVOFF -autostartprgmode 1 -autostart-handle-tde +autostart-warp
if [ "$TRAPDEVICE" = "yes" ]; then
dotest $EMU tde         0 255 $OPTS $DRIVEON -devicebackend8 1 $BUSDEVOFF -drive8truedrive $TRAPDEVON -autostartprgmode 1 -autostart-handle-tde -autostart-warp
dotest $EMU tde         0 255 $OPTS $DRIVEON -devicebackend8 1 $BUSDEVOFF -drive8truedrive $TRAPDEVON -autostartprgmode 1 -autostart-handle-tde +autostart-warp
# vfs only
dotest $EMU vfs         1   0 $OPTS $DRIVEON -devicebackend8 1 $BUSDEVOFF +drive8truedrive $TRAPDEVON -autostartprgmode 1 -autostart-handle-tde -autostart-warp
dotest $EMU vfs         1   0 $OPTS $DRIVEON -devicebackend8 1 $BUSDEVOFF +drive8truedrive $TRAPDEVON -autostartprgmode 1 -autostart-handle-tde +autostart-warp
fi
if [ "$BUSDEVICE" = "yes" ]; then
dotest $EMU tde         0 255 $OPTS $DRIVEON -devicebackend8 1 $BUSDEVON  -drive8truedrive $TRAPDEVOFF -autostartprgmode 1 -autostart-handle-tde -autostart-warp
dotest $EMU tde         0 255 $OPTS $DRIVEON -devicebackend8 1 $BUSDEVON  -drive8truedrive $TRAPDEVOFF -autostartprgmode 1 -autostart-handle-tde +autostart-warp
# iecdev only
dotest $EMU vfs         1   0 $OPTS $DRIVEON -devicebackend8 1 $BUSDEVON  +drive8truedrive $TRAPDEVOFF -autostartprgmode 1 -autostart-handle-tde -autostart-warp
dotest $EMU vfs         1   0 $OPTS $DRIVEON -devicebackend8 1 $BUSDEVON  +drive8truedrive $TRAPDEVOFF -autostartprgmode 1 -autostart-handle-tde +autostart-warp
if [ "$TRAPDEVICE" = "yes" ]; then
dotest $EMU tde         0 255 $OPTS $DRIVEON -devicebackend8 1 $BUSDEVON  -drive8truedrive $TRAPDEVON -autostartprgmode 1 -autostart-handle-tde -autostart-warp
dotest $EMU tde         0 255 $OPTS $DRIVEON -devicebackend8 1 $BUSDEVON  -drive8truedrive $TRAPDEVON -autostartprgmode 1 -autostart-handle-tde +autostart-warp
dotest $EMU vfs         0 255 $OPTS $DRIVEON -devicebackend8 1 $BUSDEVON  +drive8truedrive $TRAPDEVON -autostartprgmode 1 -autostart-handle-tde -autostart-warp
dotest $EMU vfs         0 255 $OPTS $DRIVEON -devicebackend8 1 $BUSDEVON  +drive8truedrive $TRAPDEVON -autostartprgmode 1 -autostart-handle-tde +autostart-warp
fi
fi

echo "prg - autostart mode 2 (copy to disk image, backend: none) - handle TDE"
## fsdevice = none
# TDEonly
dotest $EMU tde-disk    1   0 $OPTS $DRIVEON -devicebackend8 0 $BUSDEVOFF -drive8truedrive $TRAPDEVOFF -autostartprgmode 2 -autostart-handle-tde -autostart-warp
dotest $EMU tde-disk    1   0 $OPTS $DRIVEON -devicebackend8 0 $BUSDEVOFF -drive8truedrive $TRAPDEVOFF -autostartprgmode 2 -autostart-handle-tde +autostart-warp
# none
dotest $EMU none        0 255 $OPTS $DRIVEON -devicebackend8 0 $BUSDEVOFF +drive8truedrive $TRAPDEVOFF -autostartprgmode 2 -autostart-handle-tde -autostart-warp
dotest $EMU none        0 255 $OPTS $DRIVEON -devicebackend8 0 $BUSDEVOFF +drive8truedrive $TRAPDEVOFF -autostartprgmode 2 -autostart-handle-tde +autostart-warp
if [ "$TRAPDEVICE" = "yes" ]; then
dotest $EMU tde-disk    0 255 $OPTS $DRIVEON -devicebackend8 0 $BUSDEVOFF -drive8truedrive $TRAPDEVON -autostartprgmode 2 -autostart-handle-tde -autostart-warp
dotest $EMU tde-disk    0 255 $OPTS $DRIVEON -devicebackend8 0 $BUSDEVOFF -drive8truedrive $TRAPDEVON -autostartprgmode 2 -autostart-handle-tde +autostart-warp
# vfs only
dotest $EMU vdrive-disk 1   0 $OPTS $DRIVEON -devicebackend8 0 $BUSDEVOFF +drive8truedrive $TRAPDEVON -autostartprgmode 2 -autostart-handle-tde -autostart-warp
dotest $EMU vdrive-disk 1   0 $OPTS $DRIVEON -devicebackend8 0 $BUSDEVOFF +drive8truedrive $TRAPDEVON -autostartprgmode 2 -autostart-handle-tde +autostart-warp
fi
if [ "$BUSDEVICE" = "yes" ]; then
dotest $EMU tde-disk    0 255 $OPTS $DRIVEON -devicebackend8 0 $BUSDEVON  -drive8truedrive $TRAPDEVOFF -autostartprgmode 2 -autostart-handle-tde -autostart-warp
dotest $EMU tde-disk    0 255 $OPTS $DRIVEON -devicebackend8 0 $BUSDEVON  -drive8truedrive $TRAPDEVOFF -autostartprgmode 2 -autostart-handle-tde +autostart-warp
# iecdev only
dotest $EMU vdrive-disk 1   0 $OPTS $DRIVEON -devicebackend8 0 $BUSDEVON  +drive8truedrive $TRAPDEVOFF -autostartprgmode 2 -autostart-handle-tde -autostart-warp
dotest $EMU vdrive-disk 1   0 $OPTS $DRIVEON -devicebackend8 0 $BUSDEVON  +drive8truedrive $TRAPDEVOFF -autostartprgmode 2 -autostart-handle-tde +autostart-warp
if [ "$TRAPDEVICE" = "yes" ]; then
dotest $EMU tde-disk    0 255 $OPTS $DRIVEON -devicebackend8 0 $BUSDEVON  -drive8truedrive $TRAPDEVON -autostartprgmode 2 -autostart-handle-tde -autostart-warp
dotest $EMU tde-disk    0 255 $OPTS $DRIVEON -devicebackend8 0 $BUSDEVON  -drive8truedrive $TRAPDEVON -autostartprgmode 2 -autostart-handle-tde +autostart-warp
dotest $EMU vdrive-disk 0 255 $OPTS $DRIVEON -devicebackend8 0 $BUSDEVON  +drive8truedrive $TRAPDEVON -autostartprgmode 2 -autostart-handle-tde -autostart-warp
dotest $EMU vdrive-disk 0 255 $OPTS $DRIVEON -devicebackend8 0 $BUSDEVON  +drive8truedrive $TRAPDEVON -autostartprgmode 2 -autostart-handle-tde +autostart-warp
fi
fi

echo "prg - autostart mode 2 (copy to disk image, backend: fsdevice) - handle TDE"
## fsdevice = filesystem
# TDEonly
dotest $EMU tde-disk    1   0 $OPTS $DRIVEON -devicebackend8 1 $BUSDEVOFF -drive8truedrive $TRAPDEVOFF -autostartprgmode 2 -autostart-handle-tde -autostart-warp
dotest $EMU tde-disk    1   0 $OPTS $DRIVEON -devicebackend8 1 $BUSDEVOFF -drive8truedrive $TRAPDEVOFF -autostartprgmode 2 -autostart-handle-tde +autostart-warp
# none
dotest $EMU none        0 255 $OPTS $DRIVEON -devicebackend8 1 $BUSDEVOFF +drive8truedrive $TRAPDEVOFF -autostartprgmode 2 -autostart-handle-tde -autostart-warp
dotest $EMU none        0 255 $OPTS $DRIVEON -devicebackend8 1 $BUSDEVOFF +drive8truedrive $TRAPDEVOFF -autostartprgmode 2 -autostart-handle-tde +autostart-warp
if [ "$TRAPDEVICE" = "yes" ]; then
# vfs only
dotest $EMU tde-disk    0 255 $OPTS $DRIVEON -devicebackend8 1 $BUSDEVOFF -drive8truedrive $TRAPDEVON -autostartprgmode 2 -autostart-handle-tde -autostart-warp
dotest $EMU tde-disk    0 255 $OPTS $DRIVEON -devicebackend8 1 $BUSDEVOFF -drive8truedrive $TRAPDEVON -autostartprgmode 2 -autostart-handle-tde +autostart-warp
dotest $EMU vdrive-disk 1   0 $OPTS $DRIVEON -devicebackend8 1 $BUSDEVOFF +drive8truedrive $TRAPDEVON -autostartprgmode 2 -autostart-handle-tde -autostart-warp
dotest $EMU vdrive-disk 1   0 $OPTS $DRIVEON -devicebackend8 1 $BUSDEVOFF +drive8truedrive $TRAPDEVON -autostartprgmode 2 -autostart-handle-tde +autostart-warp
fi
if [ "$BUSDEVICE" = "yes" ]; then
dotest $EMU tde-disk    0 255 $OPTS $DRIVEON -devicebackend8 1 $BUSDEVON  -drive8truedrive $TRAPDEVOFF -autostartprgmode 2 -autostart-handle-tde -autostart-warp
dotest $EMU tde-disk    0 255 $OPTS $DRIVEON -devicebackend8 1 $BUSDEVON  -drive8truedrive $TRAPDEVOFF -autostartprgmode 2 -autostart-handle-tde +autostart-warp
# iecdev only
dotest $EMU vdrive-disk 1   0 $OPTS $DRIVEON -devicebackend8 1 $BUSDEVON  +drive8truedrive $TRAPDEVOFF -autostartprgmode 2 -autostart-handle-tde -autostart-warp
dotest $EMU vdrive-disk 1   0 $OPTS $DRIVEON -devicebackend8 1 $BUSDEVON  +drive8truedrive $TRAPDEVOFF -autostartprgmode 2 -autostart-handle-tde +autostart-warp
if [ "$TRAPDEVICE" = "yes" ]; then
dotest $EMU tde-disk    0 255 $OPTS $DRIVEON -devicebackend8 1 $BUSDEVON  -drive8truedrive $TRAPDEVON -autostartprgmode 2 -autostart-handle-tde -autostart-warp
dotest $EMU tde-disk    0 255 $OPTS $DRIVEON -devicebackend8 1 $BUSDEVON  -drive8truedrive $TRAPDEVON -autostartprgmode 2 -autostart-handle-tde +autostart-warp
dotest $EMU vdrive-disk 0 255 $OPTS $DRIVEON -devicebackend8 1 $BUSDEVON  +drive8truedrive $TRAPDEVON -autostartprgmode 2 -autostart-handle-tde -autostart-warp
dotest $EMU vdrive-disk 0 255 $OPTS $DRIVEON -devicebackend8 1 $BUSDEVON  +drive8truedrive $TRAPDEVON -autostartprgmode 2 -autostart-handle-tde +autostart-warp
fi
fi

# with drive = none

echo "prg - autostart mode 0 (virtual filesystem, backend: none) - do not handle TDE"
## fsdevice = none
# TDEonly
dotest $EMU none        1   1 $OPTS $DRIVEOFF -devicebackend8 0 $BUSDEVOFF -drive8truedrive $TRAPDEVOFF -autostartprgmode 0 +autostart-handle-tde -autostart-warp
dotest $EMU none        1   1 $OPTS $DRIVEOFF -devicebackend8 0 $BUSDEVOFF -drive8truedrive $TRAPDEVOFF -autostartprgmode 0 +autostart-handle-tde +autostart-warp
# none
dotest $EMU none        0 255 $OPTS $DRIVEOFF -devicebackend8 0 $BUSDEVOFF +drive8truedrive $TRAPDEVOFF -autostartprgmode 0 +autostart-handle-tde -autostart-warp
dotest $EMU none        0 255 $OPTS $DRIVEOFF -devicebackend8 0 $BUSDEVOFF +drive8truedrive $TRAPDEVOFF -autostartprgmode 0 +autostart-handle-tde +autostart-warp
if [ "$TRAPDEVICE" = "yes" ]; then
dotest $EMU tde         0 255 $OPTS $DRIVEOFF -devicebackend8 0 $BUSDEVOFF -drive8truedrive $TRAPDEVON -autostartprgmode 0 +autostart-handle-tde -autostart-warp
dotest $EMU tde         0 255 $OPTS $DRIVEOFF -devicebackend8 0 $BUSDEVOFF -drive8truedrive $TRAPDEVON -autostartprgmode 0 +autostart-handle-tde +autostart-warp
# vfs only
dotest $EMU none        1   0 $OPTS $DRIVEOFF -devicebackend8 0 $BUSDEVOFF +drive8truedrive $TRAPDEVON -autostartprgmode 0 +autostart-handle-tde -autostart-warp
dotest $EMU none        1   0 $OPTS $DRIVEOFF -devicebackend8 0 $BUSDEVOFF +drive8truedrive $TRAPDEVON -autostartprgmode 0 +autostart-handle-tde +autostart-warp
fi
if [ "$BUSDEVICE" = "yes" ]; then
dotest $EMU tde         0 255 $OPTS $DRIVEOFF -devicebackend8 0 $BUSDEVON  -drive8truedrive $TRAPDEVOFF -autostartprgmode 0 +autostart-handle-tde -autostart-warp
dotest $EMU tde         0 255 $OPTS $DRIVEOFF -devicebackend8 0 $BUSDEVON  -drive8truedrive $TRAPDEVOFF -autostartprgmode 0 +autostart-handle-tde +autostart-warp
# iecdev only
dotest $EMU none        1   0 $OPTS $DRIVEOFF -devicebackend8 0 $BUSDEVON  +drive8truedrive $TRAPDEVOFF -autostartprgmode 0 +autostart-handle-tde -autostart-warp
dotest $EMU none        1   0 $OPTS $DRIVEOFF -devicebackend8 0 $BUSDEVON  +drive8truedrive $TRAPDEVOFF -autostartprgmode 0 +autostart-handle-tde +autostart-warp
if [ "$TRAPDEVICE" = "yes" ]; then
dotest $EMU tde         0 255 $OPTS $DRIVEOFF -devicebackend8 0 $BUSDEVON  -drive8truedrive $TRAPDEVON -autostartprgmode 0 +autostart-handle-tde -autostart-warp
dotest $EMU tde         0 255 $OPTS $DRIVEOFF -devicebackend8 0 $BUSDEVON  -drive8truedrive $TRAPDEVON -autostartprgmode 0 +autostart-handle-tde +autostart-warp
dotest $EMU vfs         0 255 $OPTS $DRIVEOFF -devicebackend8 0 $BUSDEVON  +drive8truedrive $TRAPDEVON -autostartprgmode 0 +autostart-handle-tde -autostart-warp
dotest $EMU vfs         0 255 $OPTS $DRIVEOFF -devicebackend8 0 $BUSDEVON  +drive8truedrive $TRAPDEVON -autostartprgmode 0 +autostart-handle-tde +autostart-warp
fi
fi

echo "prg - autostart mode 0 (virtual filesystem, backend: fsdevice) - do not handle TDE"
## fsdevice = filesystem
# TDEonly
dotest $EMU tde         1   1 $OPTS $DRIVEOFF -devicebackend8 1 $BUSDEVOFF -drive8truedrive $TRAPDEVOFF -autostartprgmode 0 +autostart-handle-tde -autostart-warp
dotest $EMU tde         1   1 $OPTS $DRIVEOFF -devicebackend8 1 $BUSDEVOFF -drive8truedrive $TRAPDEVOFF -autostartprgmode 0 +autostart-handle-tde +autostart-warp
# none
dotest $EMU none        0 255 $OPTS $DRIVEOFF -devicebackend8 1 $BUSDEVOFF +drive8truedrive $TRAPDEVOFF -autostartprgmode 0 +autostart-handle-tde -autostart-warp
dotest $EMU none        0 255 $OPTS $DRIVEOFF -devicebackend8 1 $BUSDEVOFF +drive8truedrive $TRAPDEVOFF -autostartprgmode 0 +autostart-handle-tde +autostart-warp
if [ "$TRAPDEVICE" = "yes" ]; then
dotest $EMU tde         0 255 $OPTS $DRIVEOFF -devicebackend8 1 $BUSDEVOFF -drive8truedrive $TRAPDEVON -autostartprgmode 0 +autostart-handle-tde -autostart-warp
dotest $EMU tde         0 255 $OPTS $DRIVEOFF -devicebackend8 1 $BUSDEVOFF -drive8truedrive $TRAPDEVON -autostartprgmode 0 +autostart-handle-tde +autostart-warp
# vfs only
dotest $EMU vfs         1   0 $OPTS $DRIVEOFF -devicebackend8 1 $BUSDEVOFF +drive8truedrive $TRAPDEVON -autostartprgmode 0 +autostart-handle-tde -autostart-warp
dotest $EMU vfs         1   0 $OPTS $DRIVEOFF -devicebackend8 1 $BUSDEVOFF +drive8truedrive $TRAPDEVON -autostartprgmode 0 +autostart-handle-tde +autostart-warp
fi
if [ "$BUSDEVICE" = "yes" ]; then
dotest $EMU tde         0 255 $OPTS $DRIVEOFF -devicebackend8 1 $BUSDEVON  -drive8truedrive $TRAPDEVOFF -autostartprgmode 0 +autostart-handle-tde -autostart-warp
dotest $EMU tde         0 255 $OPTS $DRIVEOFF -devicebackend8 1 $BUSDEVON  -drive8truedrive $TRAPDEVOFF -autostartprgmode 0 +autostart-handle-tde +autostart-warp
# iecdev only
dotest $EMU vfs         1   0 $OPTS $DRIVEOFF -devicebackend8 1 $BUSDEVON  +drive8truedrive $TRAPDEVOFF -autostartprgmode 0 +autostart-handle-tde -autostart-warp
dotest $EMU vfs         1   0 $OPTS $DRIVEOFF -devicebackend8 1 $BUSDEVON  +drive8truedrive $TRAPDEVOFF -autostartprgmode 0 +autostart-handle-tde +autostart-warp
if [ "$TRAPDEVICE" = "yes" ]; then
dotest $EMU tde         0 255 $OPTS $DRIVEOFF -devicebackend8 1 $BUSDEVON  -drive8truedrive $TRAPDEVON -autostartprgmode 0 +autostart-handle-tde -autostart-warp
dotest $EMU tde         0 255 $OPTS $DRIVEOFF -devicebackend8 1 $BUSDEVON  -drive8truedrive $TRAPDEVON -autostartprgmode 0 +autostart-handle-tde +autostart-warp
dotest $EMU vfs         0 255 $OPTS $DRIVEOFF -devicebackend8 1 $BUSDEVON  +drive8truedrive $TRAPDEVON -autostartprgmode 0 +autostart-handle-tde -autostart-warp
dotest $EMU vfs         0 255 $OPTS $DRIVEOFF -devicebackend8 1 $BUSDEVON  +drive8truedrive $TRAPDEVON -autostartprgmode 0 +autostart-handle-tde +autostart-warp
fi
fi

echo "prg - autostart mode 1 (inject to RAM, backend: none) - do not handle TDE"
## fsdevice = none
# TDEonly
dotest $EMU none        1   0 $OPTS $DRIVEOFF -devicebackend8 0 $BUSDEVOFF -drive8truedrive $TRAPDEVOFF -autostartprgmode 1 +autostart-handle-tde -autostart-warp
dotest $EMU none        1   0 $OPTS $DRIVEOFF -devicebackend8 0 $BUSDEVOFF -drive8truedrive $TRAPDEVOFF -autostartprgmode 1 +autostart-handle-tde +autostart-warp
# none
dotest $EMU none        1   0 $OPTS $DRIVEOFF -devicebackend8 0 $BUSDEVOFF +drive8truedrive $TRAPDEVOFF -autostartprgmode 1 +autostart-handle-tde -autostart-warp
dotest $EMU none        1   0 $OPTS $DRIVEOFF -devicebackend8 0 $BUSDEVOFF +drive8truedrive $TRAPDEVOFF -autostartprgmode 1 +autostart-handle-tde +autostart-warp
if [ "$TRAPDEVICE" = "yes" ]; then
dotest $EMU tde         0 255 $OPTS $DRIVEOFF -devicebackend8 0 $BUSDEVOFF -drive8truedrive $TRAPDEVON -autostartprgmode 1 +autostart-handle-tde -autostart-warp
dotest $EMU tde         0 255 $OPTS $DRIVEOFF -devicebackend8 0 $BUSDEVOFF -drive8truedrive $TRAPDEVON -autostartprgmode 1 +autostart-handle-tde +autostart-warp
# vfs only
dotest $EMU none        1   0 $OPTS $DRIVEOFF -devicebackend8 0 $BUSDEVOFF +drive8truedrive $TRAPDEVON -autostartprgmode 1 +autostart-handle-tde -autostart-warp
dotest $EMU none        1   0 $OPTS $DRIVEOFF -devicebackend8 0 $BUSDEVOFF +drive8truedrive $TRAPDEVON -autostartprgmode 1 +autostart-handle-tde +autostart-warp
fi
if [ "$BUSDEVICE" = "yes" ]; then
dotest $EMU tde         0 255 $OPTS $DRIVEOFF -devicebackend8 0 $BUSDEVON  -drive8truedrive $TRAPDEVOFF -autostartprgmode 1 +autostart-handle-tde -autostart-warp
dotest $EMU tde         0 255 $OPTS $DRIVEOFF -devicebackend8 0 $BUSDEVON  -drive8truedrive $TRAPDEVOFF -autostartprgmode 1 +autostart-handle-tde +autostart-warp
# iecdev only
dotest $EMU none        1   0 $OPTS $DRIVEOFF -devicebackend8 0 $BUSDEVON  +drive8truedrive $TRAPDEVOFF -autostartprgmode 1 +autostart-handle-tde -autostart-warp
dotest $EMU none        1   0 $OPTS $DRIVEOFF -devicebackend8 0 $BUSDEVON  +drive8truedrive $TRAPDEVOFF -autostartprgmode 1 +autostart-handle-tde +autostart-warp
if [ "$TRAPDEVICE" = "yes" ]; then
dotest $EMU tde         0 255 $OPTS $DRIVEOFF -devicebackend8 0 $BUSDEVON  -drive8truedrive $TRAPDEVON -autostartprgmode 1 +autostart-handle-tde -autostart-warp
dotest $EMU tde         0 255 $OPTS $DRIVEOFF -devicebackend8 0 $BUSDEVON  -drive8truedrive $TRAPDEVON -autostartprgmode 1 +autostart-handle-tde +autostart-warp
dotest $EMU vfs         0 255 $OPTS $DRIVEOFF -devicebackend8 0 $BUSDEVON  +drive8truedrive $TRAPDEVON -autostartprgmode 1 +autostart-handle-tde -autostart-warp
dotest $EMU vfs         0 255 $OPTS $DRIVEOFF -devicebackend8 0 $BUSDEVON  +drive8truedrive $TRAPDEVON -autostartprgmode 1 +autostart-handle-tde +autostart-warp
fi
fi

echo "prg - autostart mode 1 (inject to RAM, backend: fsdevice) - do not handle TDE"
## fsdevice = filesystem
# TDEonly
dotest $EMU none        1   0 $OPTS $DRIVEOFF -devicebackend8 1 $BUSDEVOFF -drive8truedrive $TRAPDEVOFF -autostartprgmode 1 +autostart-handle-tde -autostart-warp
dotest $EMU none        1   0 $OPTS $DRIVEOFF -devicebackend8 1 $BUSDEVOFF -drive8truedrive $TRAPDEVOFF -autostartprgmode 1 +autostart-handle-tde +autostart-warp
# none
dotest $EMU none        1   0 $OPTS $DRIVEOFF -devicebackend8 1 $BUSDEVOFF +drive8truedrive $TRAPDEVOFF -autostartprgmode 1 +autostart-handle-tde -autostart-warp
dotest $EMU none        1   0 $OPTS $DRIVEOFF -devicebackend8 1 $BUSDEVOFF +drive8truedrive $TRAPDEVOFF -autostartprgmode 1 +autostart-handle-tde +autostart-warp
if [ "$TRAPDEVICE" = "yes" ]; then
dotest $EMU tde         0 255 $OPTS $DRIVEOFF -devicebackend8 1 $BUSDEVOFF -drive8truedrive $TRAPDEVON -autostartprgmode 1 +autostart-handle-tde -autostart-warp
dotest $EMU tde         0 255 $OPTS $DRIVEOFF -devicebackend8 1 $BUSDEVOFF -drive8truedrive $TRAPDEVON -autostartprgmode 1 +autostart-handle-tde +autostart-warp
# vfs only
dotest $EMU vfs         1   0 $OPTS $DRIVEOFF -devicebackend8 1 $BUSDEVOFF +drive8truedrive $TRAPDEVON -autostartprgmode 1 +autostart-handle-tde -autostart-warp
dotest $EMU vfs         1   0 $OPTS $DRIVEOFF -devicebackend8 1 $BUSDEVOFF +drive8truedrive $TRAPDEVON -autostartprgmode 1 +autostart-handle-tde +autostart-warp
fi
if [ "$BUSDEVICE" = "yes" ]; then
dotest $EMU tde         0 255 $OPTS $DRIVEOFF -devicebackend8 1 $BUSDEVON  -drive8truedrive $TRAPDEVOFF -autostartprgmode 1 +autostart-handle-tde -autostart-warp
dotest $EMU tde         0 255 $OPTS $DRIVEOFF -devicebackend8 1 $BUSDEVON  -drive8truedrive $TRAPDEVOFF -autostartprgmode 1 +autostart-handle-tde +autostart-warp
# iecdev only
dotest $EMU vfs         1   0 $OPTS $DRIVEOFF -devicebackend8 1 $BUSDEVON  +drive8truedrive $TRAPDEVOFF -autostartprgmode 1 +autostart-handle-tde -autostart-warp
dotest $EMU vfs         1   0 $OPTS $DRIVEOFF -devicebackend8 1 $BUSDEVON  +drive8truedrive $TRAPDEVOFF -autostartprgmode 1 +autostart-handle-tde +autostart-warp
if [ "$TRAPDEVICE" = "yes" ]; then
dotest $EMU tde         0 255 $OPTS $DRIVEOFF -devicebackend8 1 $BUSDEVON  -drive8truedrive $TRAPDEVON -autostartprgmode 1 +autostart-handle-tde -autostart-warp
dotest $EMU tde         0 255 $OPTS $DRIVEOFF -devicebackend8 1 $BUSDEVON  -drive8truedrive $TRAPDEVON -autostartprgmode 1 +autostart-handle-tde +autostart-warp
dotest $EMU vfs         0 255 $OPTS $DRIVEOFF -devicebackend8 1 $BUSDEVON  +drive8truedrive $TRAPDEVON -autostartprgmode 1 +autostart-handle-tde -autostart-warp
dotest $EMU vfs         0 255 $OPTS $DRIVEOFF -devicebackend8 1 $BUSDEVON  +drive8truedrive $TRAPDEVON -autostartprgmode 1 +autostart-handle-tde +autostart-warp
fi
fi

echo "prg - autostart mode 0 (virtual filesystem, backend: none) - handle TDE"
## fsdevice = none
# TDEonly
dotest $EMU none        1   0 $OPTS $DRIVEOFF -devicebackend8 0 $BUSDEVOFF -drive8truedrive $TRAPDEVOFF -autostartprgmode 0 -autostart-handle-tde -autostart-warp
dotest $EMU none        1   0 $OPTS $DRIVEOFF -devicebackend8 0 $BUSDEVOFF -drive8truedrive $TRAPDEVOFF -autostartprgmode 0 -autostart-handle-tde +autostart-warp
# none
dotest $EMU none        0 255 $OPTS $DRIVEOFF -devicebackend8 0 $BUSDEVOFF +drive8truedrive $TRAPDEVOFF -autostartprgmode 0 -autostart-handle-tde -autostart-warp
dotest $EMU none        0 255 $OPTS $DRIVEOFF -devicebackend8 0 $BUSDEVOFF +drive8truedrive $TRAPDEVOFF -autostartprgmode 0 -autostart-handle-tde +autostart-warp
if [ "$TRAPDEVICE" = "yes" ]; then
dotest $EMU tde         0 255 $OPTS $DRIVEOFF -devicebackend8 0 $BUSDEVOFF -drive8truedrive $TRAPDEVON -autostartprgmode 0 -autostart-handle-tde -autostart-warp
dotest $EMU tde         0 255 $OPTS $DRIVEOFF -devicebackend8 0 $BUSDEVOFF -drive8truedrive $TRAPDEVON -autostartprgmode 0 -autostart-handle-tde +autostart-warp
# vfs only
dotest $EMU none        1   0 $OPTS $DRIVEOFF -devicebackend8 0 $BUSDEVOFF +drive8truedrive $TRAPDEVON -autostartprgmode 0 -autostart-handle-tde -autostart-warp
dotest $EMU none        1   0 $OPTS $DRIVEOFF -devicebackend8 0 $BUSDEVOFF +drive8truedrive $TRAPDEVON -autostartprgmode 0 -autostart-handle-tde +autostart-warp
fi
if [ "$BUSDEVICE" = "yes" ]; then
dotest $EMU tde         0 255 $OPTS $DRIVEOFF -devicebackend8 0 $BUSDEVON  -drive8truedrive $TRAPDEVOFF -autostartprgmode 0 -autostart-handle-tde -autostart-warp
dotest $EMU tde         0 255 $OPTS $DRIVEOFF -devicebackend8 0 $BUSDEVON  -drive8truedrive $TRAPDEVOFF -autostartprgmode 0 -autostart-handle-tde +autostart-warp
# iecdev only
dotest $EMU none        1   0 $OPTS $DRIVEOFF -devicebackend8 0 $BUSDEVON  +drive8truedrive $TRAPDEVOFF -autostartprgmode 0 -autostart-handle-tde -autostart-warp
dotest $EMU none        1   0 $OPTS $DRIVEOFF -devicebackend8 0 $BUSDEVON  +drive8truedrive $TRAPDEVOFF -autostartprgmode 0 -autostart-handle-tde +autostart-warp
if [ "$TRAPDEVICE" = "yes" ]; then
dotest $EMU tde         0 255 $OPTS $DRIVEOFF -devicebackend8 0 $BUSDEVON  -drive8truedrive $TRAPDEVON -autostartprgmode 0 -autostart-handle-tde -autostart-warp
dotest $EMU tde         0 255 $OPTS $DRIVEOFF -devicebackend8 0 $BUSDEVON  -drive8truedrive $TRAPDEVON -autostartprgmode 0 -autostart-handle-tde +autostart-warp
dotest $EMU vfs         0 255 $OPTS $DRIVEOFF -devicebackend8 0 $BUSDEVON  +drive8truedrive $TRAPDEVON -autostartprgmode 0 -autostart-handle-tde -autostart-warp
dotest $EMU vfs         0 255 $OPTS $DRIVEOFF -devicebackend8 0 $BUSDEVON  +drive8truedrive $TRAPDEVON -autostartprgmode 0 -autostart-handle-tde +autostart-warp
fi
fi

echo "prg - autostart mode 0 (virtual filesystem, backend: fsdevice) - handle TDE"
## fsdevice = filesystem
# TDEonly
dotest $EMU none        1   0 $OPTS $DRIVEOFF -devicebackend8 1 $BUSDEVOFF -drive8truedrive $TRAPDEVOFF -autostartprgmode 0 -autostart-handle-tde -autostart-warp
dotest $EMU none        1   0 $OPTS $DRIVEOFF -devicebackend8 1 $BUSDEVOFF -drive8truedrive $TRAPDEVOFF -autostartprgmode 0 -autostart-handle-tde +autostart-warp
# none
dotest $EMU none        0 255 $OPTS $DRIVEOFF -devicebackend8 1 $BUSDEVOFF +drive8truedrive $TRAPDEVOFF -autostartprgmode 0 -autostart-handle-tde -autostart-warp
dotest $EMU none        0 255 $OPTS $DRIVEOFF -devicebackend8 1 $BUSDEVOFF +drive8truedrive $TRAPDEVOFF -autostartprgmode 0 -autostart-handle-tde +autostart-warp
if [ "$TRAPDEVICE" = "yes" ]; then
dotest $EMU tde         0 255 $OPTS $DRIVEOFF -devicebackend8 1 $BUSDEVOFF -drive8truedrive $TRAPDEVON -autostartprgmode 0 -autostart-handle-tde -autostart-warp
dotest $EMU tde         0 255 $OPTS $DRIVEOFF -devicebackend8 1 $BUSDEVOFF -drive8truedrive $TRAPDEVON -autostartprgmode 0 -autostart-handle-tde +autostart-warp
# vfs only
dotest $EMU vfs         1   0 $OPTS $DRIVEOFF -devicebackend8 1 $BUSDEVOFF +drive8truedrive $TRAPDEVON -autostartprgmode 0 -autostart-handle-tde -autostart-warp
dotest $EMU vfs         1   0 $OPTS $DRIVEOFF -devicebackend8 1 $BUSDEVOFF +drive8truedrive $TRAPDEVON -autostartprgmode 0 -autostart-handle-tde +autostart-warp
fi
if [ "$BUSDEVICE" = "yes" ]; then
dotest $EMU tde         0 255 $OPTS $DRIVEOFF -devicebackend8 1 $BUSDEVON  -drive8truedrive $TRAPDEVOFF -autostartprgmode 0 -autostart-handle-tde -autostart-warp
dotest $EMU tde         0 255 $OPTS $DRIVEOFF -devicebackend8 1 $BUSDEVON  -drive8truedrive $TRAPDEVOFF -autostartprgmode 0 -autostart-handle-tde +autostart-warp
# iecdev only
dotest $EMU vfs         1   0 $OPTS $DRIVEOFF -devicebackend8 1 $BUSDEVON  +drive8truedrive $TRAPDEVOFF -autostartprgmode 0 -autostart-handle-tde -autostart-warp
dotest $EMU vfs         1   0 $OPTS $DRIVEOFF -devicebackend8 1 $BUSDEVON  +drive8truedrive $TRAPDEVOFF -autostartprgmode 0 -autostart-handle-tde +autostart-warp
if [ "$TRAPDEVICE" = "yes" ]; then
dotest $EMU tde         0 255 $OPTS $DRIVEOFF -devicebackend8 1 $BUSDEVON  -drive8truedrive $TRAPDEVON -autostartprgmode 0 -autostart-handle-tde -autostart-warp
dotest $EMU tde         0 255 $OPTS $DRIVEOFF -devicebackend8 1 $BUSDEVON  -drive8truedrive $TRAPDEVON -autostartprgmode 0 -autostart-handle-tde +autostart-warp
dotest $EMU vfs         0 255 $OPTS $DRIVEOFF -devicebackend8 1 $BUSDEVON  +drive8truedrive $TRAPDEVON -autostartprgmode 0 -autostart-handle-tde -autostart-warp
dotest $EMU vfs         0 255 $OPTS $DRIVEOFF -devicebackend8 1 $BUSDEVON  +drive8truedrive $TRAPDEVON -autostartprgmode 0 -autostart-handle-tde +autostart-warp
fi
fi

echo "prg - autostart mode 1 (inject to RAM, backend: none) - handle TDE"
## fsdevice = none
# TDEonly
dotest $EMU none        1   0 $OPTS $DRIVEOFF -devicebackend8 0 $BUSDEVOFF -drive8truedrive $TRAPDEVOFF -autostartprgmode 1 -autostart-handle-tde -autostart-warp
dotest $EMU none        1   0 $OPTS $DRIVEOFF -devicebackend8 0 $BUSDEVOFF -drive8truedrive $TRAPDEVOFF -autostartprgmode 1 -autostart-handle-tde +autostart-warp
# none
dotest $EMU none        0   0 $OPTS $DRIVEOFF -devicebackend8 0 $BUSDEVOFF +drive8truedrive $TRAPDEVOFF -autostartprgmode 1 -autostart-handle-tde -autostart-warp
dotest $EMU none        0   0 $OPTS $DRIVEOFF -devicebackend8 0 $BUSDEVOFF +drive8truedrive $TRAPDEVOFF -autostartprgmode 1 -autostart-handle-tde +autostart-warp
if [ "$TRAPDEVICE" = "yes" ]; then
dotest $EMU tde         0 255 $OPTS $DRIVEOFF -devicebackend8 0 $BUSDEVOFF -drive8truedrive $TRAPDEVON -autostartprgmode 1 -autostart-handle-tde -autostart-warp
dotest $EMU tde         0 255 $OPTS $DRIVEOFF -devicebackend8 0 $BUSDEVOFF -drive8truedrive $TRAPDEVON -autostartprgmode 1 -autostart-handle-tde +autostart-warp
# vfs only
dotest $EMU none        1   0 $OPTS $DRIVEOFF -devicebackend8 0 $BUSDEVOFF +drive8truedrive $TRAPDEVON -autostartprgmode 1 -autostart-handle-tde -autostart-warp
dotest $EMU none        1   0 $OPTS $DRIVEOFF -devicebackend8 0 $BUSDEVOFF +drive8truedrive $TRAPDEVON -autostartprgmode 1 -autostart-handle-tde +autostart-warp
fi
if [ "$BUSDEVICE" = "yes" ]; then
dotest $EMU tde         0 255 $OPTS $DRIVEOFF -devicebackend8 0 $BUSDEVON  -drive8truedrive $TRAPDEVOFF -autostartprgmode 1 -autostart-handle-tde -autostart-warp
dotest $EMU tde         0 255 $OPTS $DRIVEOFF -devicebackend8 0 $BUSDEVON  -drive8truedrive $TRAPDEVOFF -autostartprgmode 1 -autostart-handle-tde +autostart-warp
# iecdev only
dotest $EMU none        1   0 $OPTS $DRIVEOFF -devicebackend8 0 $BUSDEVON  +drive8truedrive $TRAPDEVOFF -autostartprgmode 1 -autostart-handle-tde -autostart-warp
dotest $EMU none        1   0 $OPTS $DRIVEOFF -devicebackend8 0 $BUSDEVON  +drive8truedrive $TRAPDEVOFF -autostartprgmode 1 -autostart-handle-tde +autostart-warp
if [ "$TRAPDEVICE" = "yes" ]; then
dotest $EMU tde         0 255 $OPTS $DRIVEOFF -devicebackend8 0 $BUSDEVON  -drive8truedrive $TRAPDEVON -autostartprgmode 1 -autostart-handle-tde -autostart-warp
dotest $EMU tde         0 255 $OPTS $DRIVEOFF -devicebackend8 0 $BUSDEVON  -drive8truedrive $TRAPDEVON -autostartprgmode 1 -autostart-handle-tde +autostart-warp
dotest $EMU vfs         0 255 $OPTS $DRIVEOFF -devicebackend8 0 $BUSDEVON  +drive8truedrive $TRAPDEVON -autostartprgmode 1 -autostart-handle-tde -autostart-warp
dotest $EMU vfs         0 255 $OPTS $DRIVEOFF -devicebackend8 0 $BUSDEVON  +drive8truedrive $TRAPDEVON -autostartprgmode 1 -autostart-handle-tde +autostart-warp
fi
fi

echo "prg - autostart mode 1 (inject to RAM, backend: fsdevice) - handle TDE"
## fsdevice = filesystem
# TDEonly
dotest $EMU none        1   0 $OPTS $DRIVEOFF -devicebackend8 1 $BUSDEVOFF -drive8truedrive $TRAPDEVOFF -autostartprgmode 1 -autostart-handle-tde -autostart-warp
dotest $EMU none        1   0 $OPTS $DRIVEOFF -devicebackend8 1 $BUSDEVOFF -drive8truedrive $TRAPDEVOFF -autostartprgmode 1 -autostart-handle-tde +autostart-warp
# none
dotest $EMU none        0   0 $OPTS $DRIVEOFF -devicebackend8 1 $BUSDEVOFF +drive8truedrive $TRAPDEVOFF -autostartprgmode 1 -autostart-handle-tde -autostart-warp
dotest $EMU none        0   0 $OPTS $DRIVEOFF -devicebackend8 1 $BUSDEVOFF +drive8truedrive $TRAPDEVOFF -autostartprgmode 1 -autostart-handle-tde +autostart-warp
if [ "$TRAPDEVICE" = "yes" ]; then
dotest $EMU tde         0 255 $OPTS $DRIVEOFF -devicebackend8 1 $BUSDEVOFF -drive8truedrive $TRAPDEVON -autostartprgmode 1 -autostart-handle-tde -autostart-warp
dotest $EMU tde         0 255 $OPTS $DRIVEOFF -devicebackend8 1 $BUSDEVOFF -drive8truedrive $TRAPDEVON -autostartprgmode 1 -autostart-handle-tde +autostart-warp
# vfs only
dotest $EMU vfs         1   0 $OPTS $DRIVEOFF -devicebackend8 1 $BUSDEVOFF +drive8truedrive $TRAPDEVON -autostartprgmode 1 -autostart-handle-tde -autostart-warp
dotest $EMU vfs         1   0 $OPTS $DRIVEOFF -devicebackend8 1 $BUSDEVOFF +drive8truedrive $TRAPDEVON -autostartprgmode 1 -autostart-handle-tde +autostart-warp
fi
if [ "$BUSDEVICE" = "yes" ]; then
dotest $EMU tde         0 255 $OPTS $DRIVEOFF -devicebackend8 1 $BUSDEVON  -drive8truedrive $TRAPDEVOFF -autostartprgmode 1 -autostart-handle-tde -autostart-warp
dotest $EMU tde         0 255 $OPTS $DRIVEOFF -devicebackend8 1 $BUSDEVON  -drive8truedrive $TRAPDEVOFF -autostartprgmode 1 -autostart-handle-tde +autostart-warp
# iecdev only
dotest $EMU vfs         1   0 $OPTS $DRIVEOFF -devicebackend8 1 $BUSDEVON  +drive8truedrive $TRAPDEVOFF -autostartprgmode 1 -autostart-handle-tde -autostart-warp
dotest $EMU vfs         1   0 $OPTS $DRIVEOFF -devicebackend8 1 $BUSDEVON  +drive8truedrive $TRAPDEVOFF -autostartprgmode 1 -autostart-handle-tde +autostart-warp
if [ "$TRAPDEVICE" = "yes" ]; then
dotest $EMU tde         0 255 $OPTS $DRIVEOFF -devicebackend8 1 $BUSDEVON  -drive8truedrive $TRAPDEVON -autostartprgmode 1 -autostart-handle-tde -autostart-warp
dotest $EMU tde         0 255 $OPTS $DRIVEOFF -devicebackend8 1 $BUSDEVON  -drive8truedrive $TRAPDEVON -autostartprgmode 1 -autostart-handle-tde +autostart-warp
dotest $EMU vfs         0 255 $OPTS $DRIVEOFF -devicebackend8 1 $BUSDEVON  +drive8truedrive $TRAPDEVON -autostartprgmode 1 -autostart-handle-tde -autostart-warp
dotest $EMU vfs         0 255 $OPTS $DRIVEOFF -devicebackend8 1 $BUSDEVON  +drive8truedrive $TRAPDEVON -autostartprgmode 1 -autostart-handle-tde +autostart-warp
fi
fi

echo "---"
}

function alltests_disk
{
echo $EMU":"$PROGPRE-X.$PROGEXT
dotest $EMU tde-image 1 0 -default $OPTS

# the prg mode should make no difference when we are starting a disk image
# -> the following block repeats 3 times

echo "disk - autostart mode 0 (virtual filesystem, backend: none) - do not handle TDE"
## fsdevice = none
# TDEonly
dotest $EMU tde-image    1   0 $OPTS $DRIVEON -devicebackend8 0 $BUSDEVOFF -drive8truedrive $TRAPDEVOFF -autostartprgmode 0 +autostart-handle-tde -autostart-warp
dotest $EMU tde-image    1   0 $OPTS $DRIVEON -devicebackend8 0 $BUSDEVOFF -drive8truedrive $TRAPDEVOFF -autostartprgmode 0 +autostart-handle-tde +autostart-warp
# none
dotest $EMU none-image   0 255 $OPTS $DRIVEON -devicebackend8 0 $BUSDEVOFF +drive8truedrive $TRAPDEVOFF -autostartprgmode 0 +autostart-handle-tde -autostart-warp
dotest $EMU none-image   0 255 $OPTS $DRIVEON -devicebackend8 0 $BUSDEVOFF +drive8truedrive $TRAPDEVOFF -autostartprgmode 0 +autostart-handle-tde +autostart-warp
if [ "$TRAPDEVICE" = "yes" ]; then
dotest $EMU tde-image    0 255 $OPTS $DRIVEON -devicebackend8 0 $BUSDEVOFF -drive8truedrive $TRAPDEVON -autostartprgmode 0 +autostart-handle-tde -autostart-warp
dotest $EMU tde-image    0 255 $OPTS $DRIVEON -devicebackend8 0 $BUSDEVOFF -drive8truedrive $TRAPDEVON -autostartprgmode 0 +autostart-handle-tde +autostart-warp
# vfs only
dotest $EMU vdrive-image 1   0 $OPTS $DRIVEON -devicebackend8 0 $BUSDEVOFF +drive8truedrive $TRAPDEVON -autostartprgmode 0 +autostart-handle-tde -autostart-warp
dotest $EMU vdrive-image 1   0 $OPTS $DRIVEON -devicebackend8 0 $BUSDEVOFF +drive8truedrive $TRAPDEVON -autostartprgmode 0 +autostart-handle-tde +autostart-warp
fi
if [ "$BUSDEVICE" = "yes" ]; then
dotest $EMU tde-image    0 255 $OPTS $DRIVEON -devicebackend8 0 $BUSDEVON  -drive8truedrive $TRAPDEVOFF -autostartprgmode 0 +autostart-handle-tde -autostart-warp
dotest $EMU tde-image    0 255 $OPTS $DRIVEON -devicebackend8 0 $BUSDEVON  -drive8truedrive $TRAPDEVOFF -autostartprgmode 0 +autostart-handle-tde +autostart-warp
# iecdev only
dotest $EMU vdrive-image 1   0 $OPTS $DRIVEON -devicebackend8 0 $BUSDEVON  +drive8truedrive $TRAPDEVOFF -autostartprgmode 0 +autostart-handle-tde -autostart-warp
dotest $EMU vdrive-image 1   0 $OPTS $DRIVEON -devicebackend8 0 $BUSDEVON  +drive8truedrive $TRAPDEVOFF -autostartprgmode 0 +autostart-handle-tde +autostart-warp
if [ "$TRAPDEVICE" = "yes" ]; then
dotest $EMU tde-image    0 255 $OPTS $DRIVEON -devicebackend8 0 $BUSDEVON  -drive8truedrive $TRAPDEVON -autostartprgmode 0 +autostart-handle-tde -autostart-warp
dotest $EMU tde-image    0 255 $OPTS $DRIVEON -devicebackend8 0 $BUSDEVON  -drive8truedrive $TRAPDEVON -autostartprgmode 0 +autostart-handle-tde +autostart-warp
dotest $EMU vdrive-image 0 255 $OPTS $DRIVEON -devicebackend8 0 $BUSDEVON  +drive8truedrive $TRAPDEVON -autostartprgmode 0 +autostart-handle-tde -autostart-warp
dotest $EMU vdrive-image 0 255 $OPTS $DRIVEON -devicebackend8 0 $BUSDEVON  +drive8truedrive $TRAPDEVON -autostartprgmode 0 +autostart-handle-tde +autostart-warp
fi
fi

echo "disk - autostart mode 0 (virtual filesystem, backend: fsdevice) - do not handle TDE"
## fsdevice = filesystem
# TDEonly
dotest $EMU tde-image    1   0 $OPTS $DRIVEON -devicebackend8 1 $BUSDEVOFF -drive8truedrive $TRAPDEVOFF -autostartprgmode 0 +autostart-handle-tde -autostart-warp
dotest $EMU tde-image    1   0 $OPTS $DRIVEON -devicebackend8 1 $BUSDEVOFF -drive8truedrive $TRAPDEVOFF -autostartprgmode 0 +autostart-handle-tde +autostart-warp
# none
dotest $EMU none-image   0 255 $OPTS $DRIVEON -devicebackend8 1 $BUSDEVOFF +drive8truedrive $TRAPDEVOFF -autostartprgmode 0 +autostart-handle-tde -autostart-warp
dotest $EMU none-image   0 255 $OPTS $DRIVEON -devicebackend8 1 $BUSDEVOFF +drive8truedrive $TRAPDEVOFF -autostartprgmode 0 +autostart-handle-tde +autostart-warp
if [ "$TRAPDEVICE" = "yes" ]; then
dotest $EMU tde-image    0 255 $OPTS $DRIVEON -devicebackend8 1 $BUSDEVOFF -drive8truedrive $TRAPDEVON -autostartprgmode 0 +autostart-handle-tde -autostart-warp
dotest $EMU tde-image    0 255 $OPTS $DRIVEON -devicebackend8 1 $BUSDEVOFF -drive8truedrive $TRAPDEVON -autostartprgmode 0 +autostart-handle-tde +autostart-warp
# vfs only
dotest $EMU vdrive-image 1   0 $OPTS $DRIVEON -devicebackend8 1 $BUSDEVOFF +drive8truedrive $TRAPDEVON -autostartprgmode 0 +autostart-handle-tde -autostart-warp
dotest $EMU vdrive-image 1   0 $OPTS $DRIVEON -devicebackend8 1 $BUSDEVOFF +drive8truedrive $TRAPDEVON -autostartprgmode 0 +autostart-handle-tde +autostart-warp
fi
if [ "$BUSDEVICE" = "yes" ]; then
dotest $EMU tde-image    0 255 $OPTS $DRIVEON -devicebackend8 1 $BUSDEVON  -drive8truedrive $TRAPDEVOFF -autostartprgmode 0 +autostart-handle-tde -autostart-warp
dotest $EMU tde-image    0 255 $OPTS $DRIVEON -devicebackend8 1 $BUSDEVON  -drive8truedrive $TRAPDEVOFF -autostartprgmode 0 +autostart-handle-tde +autostart-warp
# iecdev only
dotest $EMU vdrive-image 1   0 $OPTS $DRIVEON -devicebackend8 1 $BUSDEVON  +drive8truedrive $TRAPDEVOFF -autostartprgmode 0 +autostart-handle-tde -autostart-warp
dotest $EMU vdrive-image 1   0 $OPTS $DRIVEON -devicebackend8 1 $BUSDEVON  +drive8truedrive $TRAPDEVOFF -autostartprgmode 0 +autostart-handle-tde +autostart-warp
if [ "$TRAPDEVICE" = "yes" ]; then
dotest $EMU tde-image    0 255 $OPTS $DRIVEON -devicebackend8 1 $BUSDEVON  -drive8truedrive $TRAPDEVON -autostartprgmode 0 +autostart-handle-tde -autostart-warp
dotest $EMU tde-image    0 255 $OPTS $DRIVEON -devicebackend8 1 $BUSDEVON  -drive8truedrive $TRAPDEVON -autostartprgmode 0 +autostart-handle-tde +autostart-warp
dotest $EMU vdrive-image 0 255 $OPTS $DRIVEON -devicebackend8 1 $BUSDEVON  +drive8truedrive $TRAPDEVON -autostartprgmode 0 +autostart-handle-tde -autostart-warp
dotest $EMU vdrive-image 0 255 $OPTS $DRIVEON -devicebackend8 1 $BUSDEVON  +drive8truedrive $TRAPDEVON -autostartprgmode 0 +autostart-handle-tde +autostart-warp
fi
fi

echo "disk - autostart mode 1 (inject to RAM, backend: none) - do not handle TDE"

## fsdevice = none
# TDEonly
dotest $EMU tde-image    1   0 $OPTS $DRIVEON -devicebackend8 0 $BUSDEVOFF -drive8truedrive $TRAPDEVOFF -autostartprgmode 1 +autostart-handle-tde -autostart-warp
dotest $EMU tde-image    1   0 $OPTS $DRIVEON -devicebackend8 0 $BUSDEVOFF -drive8truedrive $TRAPDEVOFF -autostartprgmode 1 +autostart-handle-tde +autostart-warp
# none
dotest $EMU none-image   0 255 $OPTS $DRIVEON -devicebackend8 0 $BUSDEVOFF +drive8truedrive $TRAPDEVOFF -autostartprgmode 1 +autostart-handle-tde -autostart-warp
dotest $EMU none-image   0 255 $OPTS $DRIVEON -devicebackend8 0 $BUSDEVOFF +drive8truedrive $TRAPDEVOFF -autostartprgmode 1 +autostart-handle-tde +autostart-warp
if [ "$TRAPDEVICE" = "yes" ]; then
dotest $EMU tde-image    0 255 $OPTS $DRIVEON -devicebackend8 0 $BUSDEVOFF -drive8truedrive $TRAPDEVON -autostartprgmode 1 +autostart-handle-tde -autostart-warp
dotest $EMU tde-image    0 255 $OPTS $DRIVEON -devicebackend8 0 $BUSDEVOFF -drive8truedrive $TRAPDEVON -autostartprgmode 1 +autostart-handle-tde +autostart-warp
# vfs only
dotest $EMU vdrive-image 1   0 $OPTS $DRIVEON -devicebackend8 0 $BUSDEVOFF +drive8truedrive $TRAPDEVON -autostartprgmode 1 +autostart-handle-tde -autostart-warp
dotest $EMU vdrive-image 1   0 $OPTS $DRIVEON -devicebackend8 0 $BUSDEVOFF +drive8truedrive $TRAPDEVON -autostartprgmode 1 +autostart-handle-tde +autostart-warp
fi
if [ "$BUSDEVICE" = "yes" ]; then
dotest $EMU tde-image    0 255 $OPTS $DRIVEON -devicebackend8 0 $BUSDEVON  -drive8truedrive $TRAPDEVOFF -autostartprgmode 1 +autostart-handle-tde -autostart-warp
dotest $EMU tde-image    0 255 $OPTS $DRIVEON -devicebackend8 0 $BUSDEVON  -drive8truedrive $TRAPDEVOFF -autostartprgmode 1 +autostart-handle-tde +autostart-warp
# iecdev only
dotest $EMU vdrive-image 1   0 $OPTS $DRIVEON -devicebackend8 0 $BUSDEVON  +drive8truedrive $TRAPDEVOFF -autostartprgmode 1 +autostart-handle-tde -autostart-warp
dotest $EMU vdrive-image 1   0 $OPTS $DRIVEON -devicebackend8 0 $BUSDEVON  +drive8truedrive $TRAPDEVOFF -autostartprgmode 1 +autostart-handle-tde +autostart-warp
if [ "$TRAPDEVICE" = "yes" ]; then
dotest $EMU tde-image    0 255 $OPTS $DRIVEON -devicebackend8 0 $BUSDEVON  -drive8truedrive $TRAPDEVON -autostartprgmode 1 +autostart-handle-tde -autostart-warp
dotest $EMU tde-image    0 255 $OPTS $DRIVEON -devicebackend8 0 $BUSDEVON  -drive8truedrive $TRAPDEVON -autostartprgmode 1 +autostart-handle-tde +autostart-warp
dotest $EMU vdrive-image 0 255 $OPTS $DRIVEON -devicebackend8 0 $BUSDEVON  +drive8truedrive $TRAPDEVON -autostartprgmode 1 +autostart-handle-tde -autostart-warp
dotest $EMU vdrive-image 0 255 $OPTS $DRIVEON -devicebackend8 0 $BUSDEVON  +drive8truedrive $TRAPDEVON -autostartprgmode 1 +autostart-handle-tde +autostart-warp
fi
fi
echo "disk - autostart mode 1 (inject to RAM, backend: fsdevice) - do not handle TDE"

## fsdevice = filesystem
# TDEonly
dotest $EMU tde-image    1   0 $OPTS $DRIVEON -devicebackend8 1 $BUSDEVOFF -drive8truedrive $TRAPDEVOFF -autostartprgmode 1 +autostart-handle-tde -autostart-warp
dotest $EMU tde-image    1   0 $OPTS $DRIVEON -devicebackend8 1 $BUSDEVOFF -drive8truedrive $TRAPDEVOFF -autostartprgmode 1 +autostart-handle-tde +autostart-warp
# none
dotest $EMU none-image   0 255 $OPTS $DRIVEON -devicebackend8 1 $BUSDEVOFF +drive8truedrive $TRAPDEVOFF -autostartprgmode 1 +autostart-handle-tde -autostart-warp
dotest $EMU none-image   0 255 $OPTS $DRIVEON -devicebackend8 1 $BUSDEVOFF +drive8truedrive $TRAPDEVOFF -autostartprgmode 1 +autostart-handle-tde +autostart-warp
if [ "$TRAPDEVICE" = "yes" ]; then
dotest $EMU tde-image    0 255 $OPTS $DRIVEON -devicebackend8 1 $BUSDEVOFF -drive8truedrive $TRAPDEVON -autostartprgmode 1 +autostart-handle-tde -autostart-warp
dotest $EMU tde-image    0 255 $OPTS $DRIVEON -devicebackend8 1 $BUSDEVOFF -drive8truedrive $TRAPDEVON -autostartprgmode 1 +autostart-handle-tde +autostart-warp
# vfs only
dotest $EMU vdrive-image 1   0 $OPTS $DRIVEON -devicebackend8 1 $BUSDEVOFF +drive8truedrive $TRAPDEVON -autostartprgmode 1 +autostart-handle-tde -autostart-warp
dotest $EMU vdrive-image 1   0 $OPTS $DRIVEON -devicebackend8 1 $BUSDEVOFF +drive8truedrive $TRAPDEVON -autostartprgmode 1 +autostart-handle-tde +autostart-warp
fi
if [ "$BUSDEVICE" = "yes" ]; then
dotest $EMU tde-image    0 255 $OPTS $DRIVEON -devicebackend8 1 $BUSDEVON  -drive8truedrive $TRAPDEVOFF -autostartprgmode 1 +autostart-handle-tde -autostart-warp
dotest $EMU tde-image    0 255 $OPTS $DRIVEON -devicebackend8 1 $BUSDEVON  -drive8truedrive $TRAPDEVOFF -autostartprgmode 1 +autostart-handle-tde +autostart-warp
# iecdev only
dotest $EMU vdrive-image 1   0 $OPTS $DRIVEON -devicebackend8 1 $BUSDEVON  +drive8truedrive $TRAPDEVOFF -autostartprgmode 1 +autostart-handle-tde -autostart-warp
dotest $EMU vdrive-image 1   0 $OPTS $DRIVEON -devicebackend8 1 $BUSDEVON  +drive8truedrive $TRAPDEVOFF -autostartprgmode 1 +autostart-handle-tde +autostart-warp
if [ "$TRAPDEVICE" = "yes" ]; then
dotest $EMU tde-image    0 255 $OPTS $DRIVEON -devicebackend8 1 $BUSDEVON  -drive8truedrive $TRAPDEVON -autostartprgmode 1 +autostart-handle-tde -autostart-warp
dotest $EMU tde-image    0 255 $OPTS $DRIVEON -devicebackend8 1 $BUSDEVON  -drive8truedrive $TRAPDEVON -autostartprgmode 1 +autostart-handle-tde +autostart-warp
dotest $EMU vdrive-image 0 255 $OPTS $DRIVEON -devicebackend8 1 $BUSDEVON  +drive8truedrive $TRAPDEVON -autostartprgmode 1 +autostart-handle-tde -autostart-warp
dotest $EMU vdrive-image 0 255 $OPTS $DRIVEON -devicebackend8 1 $BUSDEVON  +drive8truedrive $TRAPDEVON -autostartprgmode 1 +autostart-handle-tde +autostart-warp
fi
fi

echo "disk - autostart mode 2 (copy to disk image, backend: none) - do not handle TDE"

## fsdevice = none
# TDEonly
dotest $EMU tde-image    1   0 $OPTS $DRIVEON -devicebackend8 0 $BUSDEVOFF -drive8truedrive $TRAPDEVOFF -autostartprgmode 2 +autostart-handle-tde -autostart-warp
dotest $EMU tde-image    1   0 $OPTS $DRIVEON -devicebackend8 0 $BUSDEVOFF -drive8truedrive $TRAPDEVOFF -autostartprgmode 2 +autostart-handle-tde +autostart-warp
# none
dotest $EMU none-image   0 255 $OPTS $DRIVEON -devicebackend8 0 $BUSDEVOFF +drive8truedrive $TRAPDEVOFF -autostartprgmode 2 +autostart-handle-tde -autostart-warp
dotest $EMU none-image   0 255 $OPTS $DRIVEON -devicebackend8 0 $BUSDEVOFF +drive8truedrive $TRAPDEVOFF -autostartprgmode 2 +autostart-handle-tde +autostart-warp
if [ "$TRAPDEVICE" = "yes" ]; then
dotest $EMU tde-image    0 255 $OPTS $DRIVEON -devicebackend8 0 $BUSDEVOFF -drive8truedrive $TRAPDEVON -autostartprgmode 2 +autostart-handle-tde -autostart-warp
dotest $EMU tde-image    0 255 $OPTS $DRIVEON -devicebackend8 0 $BUSDEVOFF -drive8truedrive $TRAPDEVON -autostartprgmode 2 +autostart-handle-tde +autostart-warp
# vfs only
dotest $EMU vdrive-image 1   0 $OPTS $DRIVEON -devicebackend8 0 $BUSDEVOFF +drive8truedrive $TRAPDEVON -autostartprgmode 2 +autostart-handle-tde -autostart-warp
dotest $EMU vdrive-image 1   0 $OPTS $DRIVEON -devicebackend8 0 $BUSDEVOFF +drive8truedrive $TRAPDEVON -autostartprgmode 2 +autostart-handle-tde +autostart-warp
fi
if [ "$BUSDEVICE" = "yes" ]; then
dotest $EMU tde-image    0 255 $OPTS $DRIVEON -devicebackend8 0 $BUSDEVON  -drive8truedrive $TRAPDEVOFF -autostartprgmode 2 +autostart-handle-tde -autostart-warp
dotest $EMU tde-image    0 255 $OPTS $DRIVEON -devicebackend8 0 $BUSDEVON  -drive8truedrive $TRAPDEVOFF -autostartprgmode 2 +autostart-handle-tde +autostart-warp
# iecdev only
dotest $EMU vdrive-image 1   0 $OPTS $DRIVEON -devicebackend8 0 $BUSDEVON  +drive8truedrive $TRAPDEVOFF -autostartprgmode 2 +autostart-handle-tde -autostart-warp
dotest $EMU vdrive-image 1   0 $OPTS $DRIVEON -devicebackend8 0 $BUSDEVON  +drive8truedrive $TRAPDEVOFF -autostartprgmode 2 +autostart-handle-tde +autostart-warp
if [ "$TRAPDEVICE" = "yes" ]; then
dotest $EMU tde-image    0 255 $OPTS $DRIVEON -devicebackend8 0 $BUSDEVON  -drive8truedrive $TRAPDEVON -autostartprgmode 2 +autostart-handle-tde -autostart-warp
dotest $EMU tde-image    0 255 $OPTS $DRIVEON -devicebackend8 0 $BUSDEVON  -drive8truedrive $TRAPDEVON -autostartprgmode 2 +autostart-handle-tde +autostart-warp
dotest $EMU vdrive-image 0 255 $OPTS $DRIVEON -devicebackend8 0 $BUSDEVON  +drive8truedrive $TRAPDEVON -autostartprgmode 2 +autostart-handle-tde -autostart-warp
dotest $EMU vdrive-image 0 255 $OPTS $DRIVEON -devicebackend8 0 $BUSDEVON  +drive8truedrive $TRAPDEVON -autostartprgmode 2 +autostart-handle-tde +autostart-warp
fi
fi
echo "disk - autostart mode 2 (copy to disk image, backend: fsdevice) - do not handle TDE"

## fsdevice = filesystem
# TDEonly
dotest $EMU tde-image    1   0 $OPTS $DRIVEON -devicebackend8 1 $BUSDEVOFF -drive8truedrive $TRAPDEVOFF -autostartprgmode 2 +autostart-handle-tde -autostart-warp
dotest $EMU tde-image    1   0 $OPTS $DRIVEON -devicebackend8 1 $BUSDEVOFF -drive8truedrive $TRAPDEVOFF -autostartprgmode 2 +autostart-handle-tde +autostart-warp
# none
dotest $EMU none-image   0 255 $OPTS $DRIVEON -devicebackend8 1 $BUSDEVOFF +drive8truedrive $TRAPDEVOFF -autostartprgmode 2 +autostart-handle-tde -autostart-warp
dotest $EMU none-image   0 255 $OPTS $DRIVEON -devicebackend8 1 $BUSDEVOFF +drive8truedrive $TRAPDEVOFF -autostartprgmode 2 +autostart-handle-tde +autostart-warp
if [ "$TRAPDEVICE" = "yes" ]; then
dotest $EMU tde-image    0 255 $OPTS $DRIVEON -devicebackend8 1 $BUSDEVOFF -drive8truedrive $TRAPDEVON -autostartprgmode 2 +autostart-handle-tde -autostart-warp
dotest $EMU tde-image    0 255 $OPTS $DRIVEON -devicebackend8 1 $BUSDEVOFF -drive8truedrive $TRAPDEVON -autostartprgmode 2 +autostart-handle-tde +autostart-warp
# vfs only
dotest $EMU vdrive-image 1   0 $OPTS $DRIVEON -devicebackend8 1 $BUSDEVOFF +drive8truedrive $TRAPDEVON -autostartprgmode 2 +autostart-handle-tde -autostart-warp
dotest $EMU vdrive-image 1   0 $OPTS $DRIVEON -devicebackend8 1 $BUSDEVOFF +drive8truedrive $TRAPDEVON -autostartprgmode 2 +autostart-handle-tde +autostart-warp
fi
if [ "$BUSDEVICE" = "yes" ]; then
dotest $EMU tde-image    0 255 $OPTS $DRIVEON -devicebackend8 1 $BUSDEVON  -drive8truedrive $TRAPDEVOFF -autostartprgmode 2 +autostart-handle-tde -autostart-warp
dotest $EMU tde-image    0 255 $OPTS $DRIVEON -devicebackend8 1 $BUSDEVON  -drive8truedrive $TRAPDEVOFF -autostartprgmode 2 +autostart-handle-tde +autostart-warp
# iecdev only
dotest $EMU vdrive-image 1   0 $OPTS $DRIVEON -devicebackend8 1 $BUSDEVON  +drive8truedrive $TRAPDEVOFF -autostartprgmode 2 +autostart-handle-tde -autostart-warp
dotest $EMU vdrive-image 1   0 $OPTS $DRIVEON -devicebackend8 1 $BUSDEVON  +drive8truedrive $TRAPDEVOFF -autostartprgmode 2 +autostart-handle-tde +autostart-warp
if [ "$TRAPDEVICE" = "yes" ]; then
dotest $EMU tde-image    0 255 $OPTS $DRIVEON -devicebackend8 1 $BUSDEVON  -drive8truedrive $TRAPDEVON -autostartprgmode 2 +autostart-handle-tde -autostart-warp
dotest $EMU tde-image    0 255 $OPTS $DRIVEON -devicebackend8 1 $BUSDEVON  -drive8truedrive $TRAPDEVON -autostartprgmode 2 +autostart-handle-tde +autostart-warp
dotest $EMU vdrive-image 0 255 $OPTS $DRIVEON -devicebackend8 1 $BUSDEVON  +drive8truedrive $TRAPDEVON -autostartprgmode 2 +autostart-handle-tde -autostart-warp
dotest $EMU vdrive-image 0 255 $OPTS $DRIVEON -devicebackend8 1 $BUSDEVON  +drive8truedrive $TRAPDEVON -autostartprgmode 2 +autostart-handle-tde +autostart-warp
fi
fi

# "handle tde at autostart" will let autostart disable TDE in favour if virtual devices
# however, this does not change anything in the final state, so again all of the above repeats

echo "disk - autostart mode 0 (virtual filesystem, backend: none) - handle TDE"

## fsdevice = none
# TDEonly
dotest $EMU tde-image    1   0 $OPTS $DRIVEON -devicebackend8 0 $BUSDEVOFF -drive8truedrive $TRAPDEVOFF -autostartprgmode 0 -autostart-handle-tde -autostart-warp
dotest $EMU tde-image    1   0 $OPTS $DRIVEON -devicebackend8 0 $BUSDEVOFF -drive8truedrive $TRAPDEVOFF -autostartprgmode 0 -autostart-handle-tde +autostart-warp
# none
dotest $EMU none-image   0 255 $OPTS $DRIVEON -devicebackend8 0 $BUSDEVOFF +drive8truedrive $TRAPDEVOFF -autostartprgmode 0 -autostart-handle-tde -autostart-warp
dotest $EMU none-image   0 255 $OPTS $DRIVEON -devicebackend8 0 $BUSDEVOFF +drive8truedrive $TRAPDEVOFF -autostartprgmode 0 -autostart-handle-tde +autostart-warp
if [ "$TRAPDEVICE" = "yes" ]; then
dotest $EMU tde-image    0 255 $OPTS $DRIVEON -devicebackend8 0 $BUSDEVOFF -drive8truedrive $TRAPDEVON -autostartprgmode 0 -autostart-handle-tde -autostart-warp
dotest $EMU tde-image    0 255 $OPTS $DRIVEON -devicebackend8 0 $BUSDEVOFF -drive8truedrive $TRAPDEVON -autostartprgmode 0 -autostart-handle-tde +autostart-warp
# vfs only
dotest $EMU vdrive-image 1   0 $OPTS $DRIVEON -devicebackend8 0 $BUSDEVOFF +drive8truedrive $TRAPDEVON -autostartprgmode 0 -autostart-handle-tde -autostart-warp
dotest $EMU vdrive-image 1   0 $OPTS $DRIVEON -devicebackend8 0 $BUSDEVOFF +drive8truedrive $TRAPDEVON -autostartprgmode 0 -autostart-handle-tde +autostart-warp
fi
if [ "$BUSDEVICE" = "yes" ]; then
dotest $EMU tde-image    0 255 $OPTS $DRIVEON -devicebackend8 0 $BUSDEVON  -drive8truedrive $TRAPDEVOFF -autostartprgmode 0 -autostart-handle-tde -autostart-warp
dotest $EMU tde-image    0 255 $OPTS $DRIVEON -devicebackend8 0 $BUSDEVON  -drive8truedrive $TRAPDEVOFF -autostartprgmode 0 -autostart-handle-tde +autostart-warp
# iecdev only
dotest $EMU vdrive-image 1   0 $OPTS $DRIVEON -devicebackend8 0 $BUSDEVON  +drive8truedrive $TRAPDEVOFF -autostartprgmode 0 -autostart-handle-tde -autostart-warp
dotest $EMU vdrive-image 1   0 $OPTS $DRIVEON -devicebackend8 0 $BUSDEVON  +drive8truedrive $TRAPDEVOFF -autostartprgmode 0 -autostart-handle-tde +autostart-warp
if [ "$TRAPDEVICE" = "yes" ]; then
dotest $EMU tde-image    0 255 $OPTS $DRIVEON -devicebackend8 0 $BUSDEVON  -drive8truedrive $TRAPDEVON -autostartprgmode 0 -autostart-handle-tde -autostart-warp
dotest $EMU tde-image    0 255 $OPTS $DRIVEON -devicebackend8 0 $BUSDEVON  -drive8truedrive $TRAPDEVON -autostartprgmode 0 -autostart-handle-tde +autostart-warp
dotest $EMU vdrive-image 0 255 $OPTS $DRIVEON -devicebackend8 0 $BUSDEVON  +drive8truedrive $TRAPDEVON -autostartprgmode 0 -autostart-handle-tde -autostart-warp
dotest $EMU vdrive-image 0 255 $OPTS $DRIVEON -devicebackend8 0 $BUSDEVON  +drive8truedrive $TRAPDEVON -autostartprgmode 0 -autostart-handle-tde +autostart-warp
fi
fi
echo "disk - autostart mode 0 (virtual filesystem, backend: fsdevice) - handle TDE"

## fsdevice = filesystem
# TDEonly
dotest $EMU tde-image    1   0 $OPTS $DRIVEON -devicebackend8 1 $BUSDEVOFF -drive8truedrive $TRAPDEVOFF -autostartprgmode 0 -autostart-handle-tde -autostart-warp
dotest $EMU tde-image    1   0 $OPTS $DRIVEON -devicebackend8 1 $BUSDEVOFF -drive8truedrive $TRAPDEVOFF -autostartprgmode 0 -autostart-handle-tde +autostart-warp
# none
dotest $EMU none-image   0 255 $OPTS $DRIVEON -devicebackend8 1 $BUSDEVOFF +drive8truedrive $TRAPDEVOFF -autostartprgmode 0 -autostart-handle-tde -autostart-warp
dotest $EMU none-image   0 255 $OPTS $DRIVEON -devicebackend8 1 $BUSDEVOFF +drive8truedrive $TRAPDEVOFF -autostartprgmode 0 -autostart-handle-tde +autostart-warp
if [ "$TRAPDEVICE" = "yes" ]; then
dotest $EMU tde-image    0 255 $OPTS $DRIVEON -devicebackend8 1 $BUSDEVOFF -drive8truedrive $TRAPDEVON -autostartprgmode 0 -autostart-handle-tde -autostart-warp
dotest $EMU tde-image    0 255 $OPTS $DRIVEON -devicebackend8 1 $BUSDEVOFF -drive8truedrive $TRAPDEVON -autostartprgmode 0 -autostart-handle-tde +autostart-warp
# vfs only
dotest $EMU vdrive-image 1   0 $OPTS $DRIVEON -devicebackend8 1 $BUSDEVOFF +drive8truedrive $TRAPDEVON -autostartprgmode 0 -autostart-handle-tde -autostart-warp
dotest $EMU vdrive-image 1   0 $OPTS $DRIVEON -devicebackend8 1 $BUSDEVOFF +drive8truedrive $TRAPDEVON -autostartprgmode 0 -autostart-handle-tde +autostart-warp
fi
if [ "$BUSDEVICE" = "yes" ]; then
dotest $EMU tde-image    0 255 $OPTS $DRIVEON -devicebackend8 1 $BUSDEVON  -drive8truedrive $TRAPDEVOFF -autostartprgmode 0 -autostart-handle-tde -autostart-warp
dotest $EMU tde-image    0 255 $OPTS $DRIVEON -devicebackend8 1 $BUSDEVON  -drive8truedrive $TRAPDEVOFF -autostartprgmode 0 -autostart-handle-tde +autostart-warp
# iecdev only
dotest $EMU vdrive-image 1   0 $OPTS $DRIVEON -devicebackend8 1 $BUSDEVON  +drive8truedrive $TRAPDEVOFF -autostartprgmode 0 -autostart-handle-tde -autostart-warp
dotest $EMU vdrive-image 1   0 $OPTS $DRIVEON -devicebackend8 1 $BUSDEVON  +drive8truedrive $TRAPDEVOFF -autostartprgmode 0 -autostart-handle-tde +autostart-warp
if [ "$TRAPDEVICE" = "yes" ]; then
dotest $EMU tde-image    0 255 $OPTS $DRIVEON -devicebackend8 1 $BUSDEVON  -drive8truedrive $TRAPDEVON -autostartprgmode 0 -autostart-handle-tde -autostart-warp
dotest $EMU tde-image    0 255 $OPTS $DRIVEON -devicebackend8 1 $BUSDEVON  -drive8truedrive $TRAPDEVON -autostartprgmode 0 -autostart-handle-tde +autostart-warp
dotest $EMU vdrive-image 0 255 $OPTS $DRIVEON -devicebackend8 1 $BUSDEVON  +drive8truedrive $TRAPDEVON -autostartprgmode 0 -autostart-handle-tde -autostart-warp
dotest $EMU vdrive-image 0 255 $OPTS $DRIVEON -devicebackend8 1 $BUSDEVON  +drive8truedrive $TRAPDEVON -autostartprgmode 0 -autostart-handle-tde +autostart-warp
fi
fi

echo "disk - autostart mode 1 (inject to RAM, backend: none) - handle TDE"

## fsdevice = none
# TDEonly
dotest $EMU tde-image    1   0 $OPTS $DRIVEON -devicebackend8 0 $BUSDEVOFF -drive8truedrive $TRAPDEVOFF -autostartprgmode 1 -autostart-handle-tde -autostart-warp
dotest $EMU tde-image    1   0 $OPTS $DRIVEON -devicebackend8 0 $BUSDEVOFF -drive8truedrive $TRAPDEVOFF -autostartprgmode 1 -autostart-handle-tde +autostart-warp
# none
dotest $EMU none-image   0 255 $OPTS $DRIVEON -devicebackend8 0 $BUSDEVOFF +drive8truedrive $TRAPDEVOFF -autostartprgmode 1 -autostart-handle-tde -autostart-warp
dotest $EMU none-image   0 255 $OPTS $DRIVEON -devicebackend8 0 $BUSDEVOFF +drive8truedrive $TRAPDEVOFF -autostartprgmode 1 -autostart-handle-tde +autostart-warp
if [ "$TRAPDEVICE" = "yes" ]; then
dotest $EMU tde-image    0 255 $OPTS $DRIVEON -devicebackend8 0 $BUSDEVOFF -drive8truedrive $TRAPDEVON -autostartprgmode 1 -autostart-handle-tde -autostart-warp
dotest $EMU tde-image    0 255 $OPTS $DRIVEON -devicebackend8 0 $BUSDEVOFF -drive8truedrive $TRAPDEVON -autostartprgmode 1 -autostart-handle-tde +autostart-warp
# vfs only
dotest $EMU vdrive-image 1   0 $OPTS $DRIVEON -devicebackend8 0 $BUSDEVOFF +drive8truedrive $TRAPDEVON -autostartprgmode 1 -autostart-handle-tde -autostart-warp
dotest $EMU vdrive-image 1   0 $OPTS $DRIVEON -devicebackend8 0 $BUSDEVOFF +drive8truedrive $TRAPDEVON -autostartprgmode 1 -autostart-handle-tde +autostart-warp
fi
if [ "$BUSDEVICE" = "yes" ]; then
dotest $EMU tde-image    0 255 $OPTS $DRIVEON -devicebackend8 0 $BUSDEVON  -drive8truedrive $TRAPDEVOFF -autostartprgmode 1 -autostart-handle-tde -autostart-warp
dotest $EMU tde-image    0 255 $OPTS $DRIVEON -devicebackend8 0 $BUSDEVON  -drive8truedrive $TRAPDEVOFF -autostartprgmode 1 -autostart-handle-tde +autostart-warp
# iecdev only
dotest $EMU vdrive-image 1   0 $OPTS $DRIVEON -devicebackend8 0 $BUSDEVON  +drive8truedrive $TRAPDEVOFF -autostartprgmode 1 -autostart-handle-tde -autostart-warp
dotest $EMU vdrive-image 1   0 $OPTS $DRIVEON -devicebackend8 0 $BUSDEVON  +drive8truedrive $TRAPDEVOFF -autostartprgmode 1 -autostart-handle-tde +autostart-warp
if [ "$TRAPDEVICE" = "yes" ]; then
dotest $EMU tde-image    0 255 $OPTS $DRIVEON -devicebackend8 0 $BUSDEVON  -drive8truedrive $TRAPDEVON -autostartprgmode 1 -autostart-handle-tde -autostart-warp
dotest $EMU tde-image    0 255 $OPTS $DRIVEON -devicebackend8 0 $BUSDEVON  -drive8truedrive $TRAPDEVON -autostartprgmode 1 -autostart-handle-tde +autostart-warp
dotest $EMU vdrive-image 0 255 $OPTS $DRIVEON -devicebackend8 0 $BUSDEVON  +drive8truedrive $TRAPDEVON -autostartprgmode 1 -autostart-handle-tde -autostart-warp
dotest $EMU vdrive-image 0 255 $OPTS $DRIVEON -devicebackend8 0 $BUSDEVON  +drive8truedrive $TRAPDEVON -autostartprgmode 1 -autostart-handle-tde +autostart-warp
fi
fi
echo "disk - autostart mode 1 (inject to RAM, backend: fsdevice) - handle TDE"

## fsdevice = filesystem
# TDEonly
dotest $EMU tde-image    1   0 $OPTS $DRIVEON -devicebackend8 1 $BUSDEVOFF -drive8truedrive $TRAPDEVOFF -autostartprgmode 1 -autostart-handle-tde -autostart-warp
dotest $EMU tde-image    1   0 $OPTS $DRIVEON -devicebackend8 1 $BUSDEVOFF -drive8truedrive $TRAPDEVOFF -autostartprgmode 1 -autostart-handle-tde +autostart-warp
# none
dotest $EMU none-image   0 255 $OPTS $DRIVEON -devicebackend8 1 $BUSDEVOFF +drive8truedrive $TRAPDEVOFF -autostartprgmode 1 -autostart-handle-tde -autostart-warp
dotest $EMU none-image   0 255 $OPTS $DRIVEON -devicebackend8 1 $BUSDEVOFF +drive8truedrive $TRAPDEVOFF -autostartprgmode 1 -autostart-handle-tde +autostart-warp
if [ "$TRAPDEVICE" = "yes" ]; then
dotest $EMU tde-image    0 255 $OPTS $DRIVEON -devicebackend8 1 $BUSDEVOFF -drive8truedrive $TRAPDEVON -autostartprgmode 1 -autostart-handle-tde -autostart-warp
dotest $EMU tde-image    0 255 $OPTS $DRIVEON -devicebackend8 1 $BUSDEVOFF -drive8truedrive $TRAPDEVON -autostartprgmode 1 -autostart-handle-tde +autostart-warp
# vfs only
dotest $EMU vdrive-image 1   0 $OPTS $DRIVEON -devicebackend8 1 $BUSDEVOFF +drive8truedrive $TRAPDEVON -autostartprgmode 1 -autostart-handle-tde -autostart-warp
dotest $EMU vdrive-image 1   0 $OPTS $DRIVEON -devicebackend8 1 $BUSDEVOFF +drive8truedrive $TRAPDEVON -autostartprgmode 1 -autostart-handle-tde +autostart-warp
fi
if [ "$BUSDEVICE" = "yes" ]; then
dotest $EMU tde-image    0 255 $OPTS $DRIVEON -devicebackend8 1 $BUSDEVON  -drive8truedrive $TRAPDEVOFF -autostartprgmode 1 -autostart-handle-tde -autostart-warp
dotest $EMU tde-image    0 255 $OPTS $DRIVEON -devicebackend8 1 $BUSDEVON  -drive8truedrive $TRAPDEVOFF -autostartprgmode 1 -autostart-handle-tde +autostart-warp
# iecdev only
dotest $EMU vdrive-image 1   0 $OPTS $DRIVEON -devicebackend8 1 $BUSDEVON  +drive8truedrive $TRAPDEVOFF -autostartprgmode 1 -autostart-handle-tde -autostart-warp
dotest $EMU vdrive-image 1   0 $OPTS $DRIVEON -devicebackend8 1 $BUSDEVON  +drive8truedrive $TRAPDEVOFF -autostartprgmode 1 -autostart-handle-tde +autostart-warp
if [ "$TRAPDEVICE" = "yes" ]; then
dotest $EMU tde-image    0 255 $OPTS $DRIVEON -devicebackend8 1 $BUSDEVON  -drive8truedrive $TRAPDEVON -autostartprgmode 1 -autostart-handle-tde -autostart-warp
dotest $EMU tde-image    0 255 $OPTS $DRIVEON -devicebackend8 1 $BUSDEVON  -drive8truedrive $TRAPDEVON -autostartprgmode 1 -autostart-handle-tde +autostart-warp
dotest $EMU vdrive-image 0 255 $OPTS $DRIVEON -devicebackend8 1 $BUSDEVON  +drive8truedrive $TRAPDEVON -autostartprgmode 1 -autostart-handle-tde -autostart-warp
dotest $EMU vdrive-image 0 255 $OPTS $DRIVEON -devicebackend8 1 $BUSDEVON  +drive8truedrive $TRAPDEVON -autostartprgmode 1 -autostart-handle-tde +autostart-warp
fi
fi

echo "disk - autostart mode 2 (copy to disk image, backend: none) - handle TDE"

## fsdevice = none
# TDEonly
dotest $EMU tde-image    1   0 $OPTS $DRIVEON -devicebackend8 0 $BUSDEVOFF -drive8truedrive $TRAPDEVOFF -autostartprgmode 2 -autostart-handle-tde -autostart-warp
dotest $EMU tde-image    1   0 $OPTS $DRIVEON -devicebackend8 0 $BUSDEVOFF -drive8truedrive $TRAPDEVOFF -autostartprgmode 2 -autostart-handle-tde +autostart-warp
# none
dotest $EMU none-image   0 255 $OPTS $DRIVEON -devicebackend8 0 $BUSDEVOFF +drive8truedrive $TRAPDEVOFF -autostartprgmode 2 -autostart-handle-tde -autostart-warp
dotest $EMU none-image   0 255 $OPTS $DRIVEON -devicebackend8 0 $BUSDEVOFF +drive8truedrive $TRAPDEVOFF -autostartprgmode 2 -autostart-handle-tde +autostart-warp
if [ "$TRAPDEVICE" = "yes" ]; then
dotest $EMU tde-image    0 255 $OPTS $DRIVEON -devicebackend8 0 $BUSDEVOFF -drive8truedrive $TRAPDEVON -autostartprgmode 2 -autostart-handle-tde -autostart-warp
dotest $EMU tde-image    0 255 $OPTS $DRIVEON -devicebackend8 0 $BUSDEVOFF -drive8truedrive $TRAPDEVON -autostartprgmode 2 -autostart-handle-tde +autostart-warp
# vfs only
dotest $EMU vdrive-image 1   0 $OPTS $DRIVEON -devicebackend8 0 $BUSDEVOFF +drive8truedrive $TRAPDEVON -autostartprgmode 2 -autostart-handle-tde -autostart-warp
dotest $EMU vdrive-image 1   0 $OPTS $DRIVEON -devicebackend8 0 $BUSDEVOFF +drive8truedrive $TRAPDEVON -autostartprgmode 2 -autostart-handle-tde +autostart-warp
fi
if [ "$BUSDEVICE" = "yes" ]; then
dotest $EMU tde-image    0 255 $OPTS $DRIVEON -devicebackend8 0 $BUSDEVON  -drive8truedrive $TRAPDEVOFF -autostartprgmode 2 -autostart-handle-tde -autostart-warp
dotest $EMU tde-image    0 255 $OPTS $DRIVEON -devicebackend8 0 $BUSDEVON  -drive8truedrive $TRAPDEVOFF -autostartprgmode 2 -autostart-handle-tde +autostart-warp
# iecdev only
dotest $EMU vdrive-image 1   0 $OPTS $DRIVEON -devicebackend8 0 $BUSDEVON  +drive8truedrive $TRAPDEVOFF -autostartprgmode 2 -autostart-handle-tde -autostart-warp
dotest $EMU vdrive-image 1   0 $OPTS $DRIVEON -devicebackend8 0 $BUSDEVON  +drive8truedrive $TRAPDEVOFF -autostartprgmode 2 -autostart-handle-tde +autostart-warp
if [ "$TRAPDEVICE" = "yes" ]; then
dotest $EMU tde-image    0 255 $OPTS $DRIVEON -devicebackend8 0 $BUSDEVON  -drive8truedrive $TRAPDEVON -autostartprgmode 2 -autostart-handle-tde -autostart-warp
dotest $EMU tde-image    0 255 $OPTS $DRIVEON -devicebackend8 0 $BUSDEVON  -drive8truedrive $TRAPDEVON -autostartprgmode 2 -autostart-handle-tde +autostart-warp
dotest $EMU vdrive-image 0 255 $OPTS $DRIVEON -devicebackend8 0 $BUSDEVON  +drive8truedrive $TRAPDEVON -autostartprgmode 2 -autostart-handle-tde -autostart-warp
dotest $EMU vdrive-image 0 255 $OPTS $DRIVEON -devicebackend8 0 $BUSDEVON  +drive8truedrive $TRAPDEVON -autostartprgmode 2 -autostart-handle-tde +autostart-warp
fi
fi
echo "disk - autostart mode 2 (copy to disk image, backend: fsdevice) - handle TDE"

## fsdevice = filesystem
# TDEonly
dotest $EMU tde-image    1   0 $OPTS $DRIVEON -devicebackend8 1 $BUSDEVOFF -drive8truedrive $TRAPDEVOFF -autostartprgmode 2 -autostart-handle-tde -autostart-warp
dotest $EMU tde-image    1   0 $OPTS $DRIVEON -devicebackend8 1 $BUSDEVOFF -drive8truedrive $TRAPDEVOFF -autostartprgmode 2 -autostart-handle-tde +autostart-warp
# none
dotest $EMU none-image   0 255 $OPTS $DRIVEON -devicebackend8 1 $BUSDEVOFF +drive8truedrive $TRAPDEVOFF -autostartprgmode 2 -autostart-handle-tde -autostart-warp
dotest $EMU none-image   0 255 $OPTS $DRIVEON -devicebackend8 1 $BUSDEVOFF +drive8truedrive $TRAPDEVOFF -autostartprgmode 2 -autostart-handle-tde +autostart-warp
if [ "$TRAPDEVICE" = "yes" ]; then
dotest $EMU tde-image    0 255 $OPTS $DRIVEON -devicebackend8 1 $BUSDEVOFF -drive8truedrive $TRAPDEVON -autostartprgmode 2 -autostart-handle-tde -autostart-warp
dotest $EMU tde-image    0 255 $OPTS $DRIVEON -devicebackend8 1 $BUSDEVOFF -drive8truedrive $TRAPDEVON -autostartprgmode 2 -autostart-handle-tde +autostart-warp
# vfs only
dotest $EMU vdrive-image 1   0 $OPTS $DRIVEON -devicebackend8 1 $BUSDEVOFF +drive8truedrive $TRAPDEVON -autostartprgmode 2 -autostart-handle-tde -autostart-warp
dotest $EMU vdrive-image 1   0 $OPTS $DRIVEON -devicebackend8 1 $BUSDEVOFF +drive8truedrive $TRAPDEVON -autostartprgmode 2 -autostart-handle-tde +autostart-warp
fi
if [ "$BUSDEVICE" = "yes" ]; then
dotest $EMU tde-image    0 255 $OPTS $DRIVEON -devicebackend8 1 $BUSDEVON  -drive8truedrive $TRAPDEVOFF -autostartprgmode 2 -autostart-handle-tde -autostart-warp
dotest $EMU tde-image    0 255 $OPTS $DRIVEON -devicebackend8 1 $BUSDEVON  -drive8truedrive $TRAPDEVOFF -autostartprgmode 2 -autostart-handle-tde +autostart-warp
# iecdev only
dotest $EMU vdrive-image 1   0 $OPTS $DRIVEON -devicebackend8 1 $BUSDEVON  +drive8truedrive $TRAPDEVOFF -autostartprgmode 2 -autostart-handle-tde -autostart-warp
dotest $EMU vdrive-image 1   0 $OPTS $DRIVEON -devicebackend8 1 $BUSDEVON  +drive8truedrive $TRAPDEVOFF -autostartprgmode 2 -autostart-handle-tde +autostart-warp
if [ "$TRAPDEVICE" = "yes" ]; then
dotest $EMU tde-image    0 255 $OPTS $DRIVEON -devicebackend8 1 $BUSDEVON  -drive8truedrive $TRAPDEVON -autostartprgmode 2 -autostart-handle-tde -autostart-warp
dotest $EMU tde-image    0 255 $OPTS $DRIVEON -devicebackend8 1 $BUSDEVON  -drive8truedrive $TRAPDEVON -autostartprgmode 2 -autostart-handle-tde +autostart-warp
dotest $EMU vdrive-image 0 255 $OPTS $DRIVEON -devicebackend8 1 $BUSDEVON  +drive8truedrive $TRAPDEVON -autostartprgmode 2 -autostart-handle-tde -autostart-warp
dotest $EMU vdrive-image 0 255 $OPTS $DRIVEON -devicebackend8 1 $BUSDEVON  +drive8truedrive $TRAPDEVON -autostartprgmode 2 -autostart-handle-tde +autostart-warp
fi
fi

# with drivetype = none

# the prg mode should make no difference when we are starting a disk image
# -> the following block repeats 3 times

echo "disk - autostart mode 0 (virtual filesystem, backend: none) - do not handle TDE"
## fsdevice = none
# TDEonly
dotest $EMU tde-image    1   0 $OPTS $DRIVEOFF -devicebackend8 0 $BUSDEVOFF -drive8truedrive $TRAPDEVOFF -autostartprgmode 0 +autostart-handle-tde -autostart-warp
dotest $EMU tde-image    1   0 $OPTS $DRIVEOFF -devicebackend8 0 $BUSDEVOFF -drive8truedrive $TRAPDEVOFF -autostartprgmode 0 +autostart-handle-tde +autostart-warp
# none
dotest $EMU none-image   0 255 $OPTS $DRIVEOFF -devicebackend8 0 $BUSDEVOFF +drive8truedrive $TRAPDEVOFF -autostartprgmode 0 +autostart-handle-tde -autostart-warp
dotest $EMU none-image   0 255 $OPTS $DRIVEOFF -devicebackend8 0 $BUSDEVOFF +drive8truedrive $TRAPDEVOFF -autostartprgmode 0 +autostart-handle-tde +autostart-warp
if [ "$TRAPDEVICE" = "yes" ]; then
dotest $EMU tde-image    0 255 $OPTS $DRIVEOFF -devicebackend8 0 $BUSDEVOFF -drive8truedrive $TRAPDEVON -autostartprgmode 0 +autostart-handle-tde -autostart-warp
dotest $EMU tde-image    0 255 $OPTS $DRIVEOFF -devicebackend8 0 $BUSDEVOFF -drive8truedrive $TRAPDEVON -autostartprgmode 0 +autostart-handle-tde +autostart-warp
# vfs only
dotest $EMU vdrive-image 1   0 $OPTS $DRIVEOFF -devicebackend8 0 $BUSDEVOFF +drive8truedrive $TRAPDEVON -autostartprgmode 0 +autostart-handle-tde -autostart-warp
dotest $EMU vdrive-image 1   0 $OPTS $DRIVEOFF -devicebackend8 0 $BUSDEVOFF +drive8truedrive $TRAPDEVON -autostartprgmode 0 +autostart-handle-tde +autostart-warp
fi
if [ "$BUSDEVICE" = "yes" ]; then
dotest $EMU tde-image    0 255 $OPTS $DRIVEOFF -devicebackend8 0 $BUSDEVON  -drive8truedrive $TRAPDEVOFF -autostartprgmode 0 +autostart-handle-tde -autostart-warp
dotest $EMU tde-image    0 255 $OPTS $DRIVEOFF -devicebackend8 0 $BUSDEVON  -drive8truedrive $TRAPDEVOFF -autostartprgmode 0 +autostart-handle-tde +autostart-warp
# iecdev only
dotest $EMU vdrive-image 1   0 $OPTS $DRIVEOFF -devicebackend8 0 $BUSDEVON  +drive8truedrive $TRAPDEVOFF -autostartprgmode 0 +autostart-handle-tde -autostart-warp
dotest $EMU vdrive-image 1   0 $OPTS $DRIVEOFF -devicebackend8 0 $BUSDEVON  +drive8truedrive $TRAPDEVOFF -autostartprgmode 0 +autostart-handle-tde +autostart-warp
if [ "$TRAPDEVICE" = "yes" ]; then
dotest $EMU tde-image    0 255 $OPTS $DRIVEOFF -devicebackend8 0 $BUSDEVON  -drive8truedrive $TRAPDEVON -autostartprgmode 0 +autostart-handle-tde -autostart-warp
dotest $EMU tde-image    0 255 $OPTS $DRIVEOFF -devicebackend8 0 $BUSDEVON  -drive8truedrive $TRAPDEVON -autostartprgmode 0 +autostart-handle-tde +autostart-warp
dotest $EMU vdrive-image 0 255 $OPTS $DRIVEOFF -devicebackend8 0 $BUSDEVON  +drive8truedrive $TRAPDEVON -autostartprgmode 0 +autostart-handle-tde -autostart-warp
dotest $EMU vdrive-image 0 255 $OPTS $DRIVEOFF -devicebackend8 0 $BUSDEVON  +drive8truedrive $TRAPDEVON -autostartprgmode 0 +autostart-handle-tde +autostart-warp
fi
fi
echo "disk - autostart mode 0 (virtual filesystem, backend: fsdevice) - do not handle TDE"

## fsdevice = filesystem
# TDEonly
dotest $EMU tde-image    1   0 $OPTS $DRIVEOFF -devicebackend8 1 $BUSDEVOFF -drive8truedrive $TRAPDEVOFF -autostartprgmode 0 +autostart-handle-tde -autostart-warp
dotest $EMU tde-image    1   0 $OPTS $DRIVEOFF -devicebackend8 1 $BUSDEVOFF -drive8truedrive $TRAPDEVOFF -autostartprgmode 0 +autostart-handle-tde +autostart-warp
# none
dotest $EMU none-image   0 255 $OPTS $DRIVEOFF -devicebackend8 1 $BUSDEVOFF +drive8truedrive $TRAPDEVOFF -autostartprgmode 0 +autostart-handle-tde -autostart-warp
dotest $EMU none-image   0 255 $OPTS $DRIVEOFF -devicebackend8 1 $BUSDEVOFF +drive8truedrive $TRAPDEVOFF -autostartprgmode 0 +autostart-handle-tde +autostart-warp
if [ "$TRAPDEVICE" = "yes" ]; then
dotest $EMU tde-image    0 255 $OPTS $DRIVEOFF -devicebackend8 1 $BUSDEVOFF -drive8truedrive $TRAPDEVON -autostartprgmode 0 +autostart-handle-tde -autostart-warp
dotest $EMU tde-image    0 255 $OPTS $DRIVEOFF -devicebackend8 1 $BUSDEVOFF -drive8truedrive $TRAPDEVON -autostartprgmode 0 +autostart-handle-tde +autostart-warp
# vfs only
dotest $EMU vdrive-image 1   0 $OPTS $DRIVEOFF -devicebackend8 1 $BUSDEVOFF +drive8truedrive $TRAPDEVON -autostartprgmode 0 +autostart-handle-tde -autostart-warp
dotest $EMU vdrive-image 1   0 $OPTS $DRIVEOFF -devicebackend8 1 $BUSDEVOFF +drive8truedrive $TRAPDEVON -autostartprgmode 0 +autostart-handle-tde +autostart-warp
fi
if [ "$BUSDEVICE" = "yes" ]; then
dotest $EMU tde-image    0 255 $OPTS $DRIVEOFF -devicebackend8 1 $BUSDEVON  -drive8truedrive $TRAPDEVOFF -autostartprgmode 0 +autostart-handle-tde -autostart-warp
dotest $EMU tde-image    0 255 $OPTS $DRIVEOFF -devicebackend8 1 $BUSDEVON  -drive8truedrive $TRAPDEVOFF -autostartprgmode 0 +autostart-handle-tde +autostart-warp
# iecdev only
dotest $EMU vdrive-image 1   0 $OPTS $DRIVEOFF -devicebackend8 1 $BUSDEVON  +drive8truedrive $TRAPDEVOFF -autostartprgmode 0 +autostart-handle-tde -autostart-warp
dotest $EMU vdrive-image 1   0 $OPTS $DRIVEOFF -devicebackend8 1 $BUSDEVON  +drive8truedrive $TRAPDEVOFF -autostartprgmode 0 +autostart-handle-tde +autostart-warp
if [ "$TRAPDEVICE" = "yes" ]; then
dotest $EMU vdrive-image 0 255 $OPTS $DRIVEOFF -devicebackend8 1 $BUSDEVON  +drive8truedrive $TRAPDEVON -autostartprgmode 0 +autostart-handle-tde -autostart-warp
dotest $EMU vdrive-image 0 255 $OPTS $DRIVEOFF -devicebackend8 1 $BUSDEVON  +drive8truedrive $TRAPDEVON -autostartprgmode 0 +autostart-handle-tde +autostart-warp
dotest $EMU tde-image    0 255 $OPTS $DRIVEOFF -devicebackend8 1 $BUSDEVON  -drive8truedrive $TRAPDEVON -autostartprgmode 0 +autostart-handle-tde -autostart-warp
dotest $EMU tde-image    0 255 $OPTS $DRIVEOFF -devicebackend8 1 $BUSDEVON  -drive8truedrive $TRAPDEVON -autostartprgmode 0 +autostart-handle-tde +autostart-warp
fi
fi

echo "disk - autostart mode 1 (inject to RAM, backend: none) - do not handle TDE"

## fsdevice = none
# TDEonly
dotest $EMU tde-image    1   0 $OPTS $DRIVEOFF -devicebackend8 0 $BUSDEVOFF -drive8truedrive $TRAPDEVOFF -autostartprgmode 1 +autostart-handle-tde -autostart-warp
dotest $EMU tde-image    1   0 $OPTS $DRIVEOFF -devicebackend8 0 $BUSDEVOFF -drive8truedrive $TRAPDEVOFF -autostartprgmode 1 +autostart-handle-tde +autostart-warp
# none
dotest $EMU none-image   0 255 $OPTS $DRIVEOFF -devicebackend8 0 $BUSDEVOFF +drive8truedrive $TRAPDEVOFF -autostartprgmode 1 +autostart-handle-tde -autostart-warp
dotest $EMU none-image   0 255 $OPTS $DRIVEOFF -devicebackend8 0 $BUSDEVOFF +drive8truedrive $TRAPDEVOFF -autostartprgmode 1 +autostart-handle-tde +autostart-warp
if [ "$TRAPDEVICE" = "yes" ]; then
dotest $EMU tde-image    0 255 $OPTS $DRIVEOFF -devicebackend8 0 $BUSDEVOFF -drive8truedrive $TRAPDEVON -autostartprgmode 1 +autostart-handle-tde -autostart-warp
dotest $EMU tde-image    0 255 $OPTS $DRIVEOFF -devicebackend8 0 $BUSDEVOFF -drive8truedrive $TRAPDEVON -autostartprgmode 1 +autostart-handle-tde +autostart-warp
# vfs only
dotest $EMU vdrive-image 1   0 $OPTS $DRIVEOFF -devicebackend8 0 $BUSDEVOFF +drive8truedrive $TRAPDEVON -autostartprgmode 1 +autostart-handle-tde -autostart-warp
dotest $EMU vdrive-image 1   0 $OPTS $DRIVEOFF -devicebackend8 0 $BUSDEVOFF +drive8truedrive $TRAPDEVON -autostartprgmode 1 +autostart-handle-tde +autostart-warp
fi
if [ "$BUSDEVICE" = "yes" ]; then
dotest $EMU tde-image    0 255 $OPTS $DRIVEOFF -devicebackend8 0 $BUSDEVON  -drive8truedrive $TRAPDEVOFF -autostartprgmode 1 +autostart-handle-tde -autostart-warp
dotest $EMU tde-image    0 255 $OPTS $DRIVEOFF -devicebackend8 0 $BUSDEVON  -drive8truedrive $TRAPDEVOFF -autostartprgmode 1 +autostart-handle-tde +autostart-warp
# iecdev only
dotest $EMU vdrive-image 1   0 $OPTS $DRIVEOFF -devicebackend8 0 $BUSDEVON  +drive8truedrive $TRAPDEVOFF -autostartprgmode 1 +autostart-handle-tde -autostart-warp
dotest $EMU vdrive-image 1   0 $OPTS $DRIVEOFF -devicebackend8 0 $BUSDEVON  +drive8truedrive $TRAPDEVOFF -autostartprgmode 1 +autostart-handle-tde +autostart-warp
if [ "$TRAPDEVICE" = "yes" ]; then
dotest $EMU tde-image    0 255 $OPTS $DRIVEOFF -devicebackend8 0 $BUSDEVON  -drive8truedrive $TRAPDEVON -autostartprgmode 1 +autostart-handle-tde -autostart-warp
dotest $EMU tde-image    0 255 $OPTS $DRIVEOFF -devicebackend8 0 $BUSDEVON  -drive8truedrive $TRAPDEVON -autostartprgmode 1 +autostart-handle-tde +autostart-warp
dotest $EMU vdrive-image 0 255 $OPTS $DRIVEOFF -devicebackend8 0 $BUSDEVON  +drive8truedrive $TRAPDEVON -autostartprgmode 1 +autostart-handle-tde -autostart-warp
dotest $EMU vdrive-image 0 255 $OPTS $DRIVEOFF -devicebackend8 0 $BUSDEVON  +drive8truedrive $TRAPDEVON -autostartprgmode 1 +autostart-handle-tde +autostart-warp
fi
fi
echo "disk - autostart mode 1 (inject to RAM, backend: fsdevice) - do not handle TDE"

## fsdevice = filesystem
# TDEonly
dotest $EMU tde-image    1   0 $OPTS $DRIVEOFF -devicebackend8 1 $BUSDEVOFF -drive8truedrive $TRAPDEVOFF -autostartprgmode 1 +autostart-handle-tde -autostart-warp
dotest $EMU tde-image    1   0 $OPTS $DRIVEOFF -devicebackend8 1 $BUSDEVOFF -drive8truedrive $TRAPDEVOFF -autostartprgmode 1 +autostart-handle-tde +autostart-warp
# none
dotest $EMU none-image   0 255 $OPTS $DRIVEOFF -devicebackend8 1 $BUSDEVOFF +drive8truedrive $TRAPDEVOFF -autostartprgmode 1 +autostart-handle-tde -autostart-warp
dotest $EMU none-image   0 255 $OPTS $DRIVEOFF -devicebackend8 1 $BUSDEVOFF +drive8truedrive $TRAPDEVOFF -autostartprgmode 1 +autostart-handle-tde +autostart-warp
if [ "$TRAPDEVICE" = "yes" ]; then
dotest $EMU tde-image    0 255 $OPTS $DRIVEOFF -devicebackend8 1 $BUSDEVOFF -drive8truedrive $TRAPDEVON -autostartprgmode 1 +autostart-handle-tde -autostart-warp
dotest $EMU tde-image    0 255 $OPTS $DRIVEOFF -devicebackend8 1 $BUSDEVOFF -drive8truedrive $TRAPDEVON -autostartprgmode 1 +autostart-handle-tde +autostart-warp
# vfs only
dotest $EMU vdrive-image 1   0 $OPTS $DRIVEOFF -devicebackend8 1 $BUSDEVOFF +drive8truedrive $TRAPDEVON -autostartprgmode 1 +autostart-handle-tde -autostart-warp
dotest $EMU vdrive-image 1   0 $OPTS $DRIVEOFF -devicebackend8 1 $BUSDEVOFF +drive8truedrive $TRAPDEVON -autostartprgmode 1 +autostart-handle-tde +autostart-warp
fi
if [ "$BUSDEVICE" = "yes" ]; then
dotest $EMU tde-image    0 255 $OPTS $DRIVEOFF -devicebackend8 1 $BUSDEVON  -drive8truedrive $TRAPDEVOFF -autostartprgmode 1 +autostart-handle-tde -autostart-warp
dotest $EMU tde-image    0 255 $OPTS $DRIVEOFF -devicebackend8 1 $BUSDEVON  -drive8truedrive $TRAPDEVOFF -autostartprgmode 1 +autostart-handle-tde +autostart-warp
# iecdev only
dotest $EMU vdrive-image 1   0 $OPTS $DRIVEOFF -devicebackend8 1 $BUSDEVON  +drive8truedrive $TRAPDEVOFF -autostartprgmode 1 +autostart-handle-tde -autostart-warp
dotest $EMU vdrive-image 1   0 $OPTS $DRIVEOFF -devicebackend8 1 $BUSDEVON  +drive8truedrive $TRAPDEVOFF -autostartprgmode 1 +autostart-handle-tde +autostart-warp
if [ "$TRAPDEVICE" = "yes" ]; then
dotest $EMU tde-image    0 255 $OPTS $DRIVEOFF -devicebackend8 1 $BUSDEVON  -drive8truedrive $TRAPDEVON -autostartprgmode 1 +autostart-handle-tde -autostart-warp
dotest $EMU tde-image    0 255 $OPTS $DRIVEOFF -devicebackend8 1 $BUSDEVON  -drive8truedrive $TRAPDEVON -autostartprgmode 1 +autostart-handle-tde +autostart-warp
dotest $EMU vdrive-image 0 255 $OPTS $DRIVEOFF -devicebackend8 1 $BUSDEVON  +drive8truedrive $TRAPDEVON -autostartprgmode 1 +autostart-handle-tde -autostart-warp
dotest $EMU vdrive-image 0 255 $OPTS $DRIVEOFF -devicebackend8 1 $BUSDEVON  +drive8truedrive $TRAPDEVON -autostartprgmode 1 +autostart-handle-tde +autostart-warp
fi
fi

echo "disk - autostart mode 2 (copy to disk image, backend: none) - do not handle TDE"

## fsdevice = none
# TDEonly
dotest $EMU tde-image    1   0 $OPTS $DRIVEOFF -devicebackend8 0 $BUSDEVOFF -drive8truedrive $TRAPDEVOFF -autostartprgmode 2 +autostart-handle-tde -autostart-warp
dotest $EMU tde-image    1   0 $OPTS $DRIVEOFF -devicebackend8 0 $BUSDEVOFF -drive8truedrive $TRAPDEVOFF -autostartprgmode 2 +autostart-handle-tde +autostart-warp
# none
dotest $EMU none-image   0 255 $OPTS $DRIVEOFF -devicebackend8 0 $BUSDEVOFF +drive8truedrive $TRAPDEVOFF -autostartprgmode 2 +autostart-handle-tde -autostart-warp
dotest $EMU none-image   0 255 $OPTS $DRIVEOFF -devicebackend8 0 $BUSDEVOFF +drive8truedrive $TRAPDEVOFF -autostartprgmode 2 +autostart-handle-tde +autostart-warp
if [ "$TRAPDEVICE" = "yes" ]; then
dotest $EMU tde-image    0 255 $OPTS $DRIVEOFF -devicebackend8 0 $BUSDEVOFF -drive8truedrive $TRAPDEVON -autostartprgmode 2 +autostart-handle-tde -autostart-warp
dotest $EMU tde-image    0 255 $OPTS $DRIVEOFF -devicebackend8 0 $BUSDEVOFF -drive8truedrive $TRAPDEVON -autostartprgmode 2 +autostart-handle-tde +autostart-warp
# vfs only
dotest $EMU vdrive-image 1   0 $OPTS $DRIVEOFF -devicebackend8 0 $BUSDEVOFF +drive8truedrive $TRAPDEVON -autostartprgmode 2 +autostart-handle-tde -autostart-warp
dotest $EMU vdrive-image 1   0 $OPTS $DRIVEOFF -devicebackend8 0 $BUSDEVOFF +drive8truedrive $TRAPDEVON -autostartprgmode 2 +autostart-handle-tde +autostart-warp
fi
if [ "$BUSDEVICE" = "yes" ]; then
dotest $EMU tde-image    0 255 $OPTS $DRIVEOFF -devicebackend8 0 $BUSDEVON  -drive8truedrive $TRAPDEVOFF -autostartprgmode 2 +autostart-handle-tde -autostart-warp
dotest $EMU tde-image    0 255 $OPTS $DRIVEOFF -devicebackend8 0 $BUSDEVON  -drive8truedrive $TRAPDEVOFF -autostartprgmode 2 +autostart-handle-tde +autostart-warp
# iecdev only
dotest $EMU vdrive-image 1   0 $OPTS $DRIVEOFF -devicebackend8 0 $BUSDEVON  +drive8truedrive $TRAPDEVOFF -autostartprgmode 2 +autostart-handle-tde -autostart-warp
dotest $EMU vdrive-image 1   0 $OPTS $DRIVEOFF -devicebackend8 0 $BUSDEVON  +drive8truedrive $TRAPDEVOFF -autostartprgmode 2 +autostart-handle-tde +autostart-warp
if [ "$TRAPDEVICE" = "yes" ]; then
dotest $EMU tde-image    0 255 $OPTS $DRIVEOFF -devicebackend8 0 $BUSDEVON  -drive8truedrive $TRAPDEVON -autostartprgmode 2 +autostart-handle-tde -autostart-warp
dotest $EMU tde-image    0 255 $OPTS $DRIVEOFF -devicebackend8 0 $BUSDEVON  -drive8truedrive $TRAPDEVON -autostartprgmode 2 +autostart-handle-tde +autostart-warp
dotest $EMU vdrive-image 0 255 $OPTS $DRIVEOFF -devicebackend8 0 $BUSDEVON  +drive8truedrive $TRAPDEVON -autostartprgmode 2 +autostart-handle-tde -autostart-warp
dotest $EMU vdrive-image 0 255 $OPTS $DRIVEOFF -devicebackend8 0 $BUSDEVON  +drive8truedrive $TRAPDEVON -autostartprgmode 2 +autostart-handle-tde +autostart-warp
fi
fi
echo "disk - autostart mode 2 (copy to disk image, backend: fsdevice) - do not handle TDE"

## fsdevice = filesystem
# TDEonly
dotest $EMU tde-image    1   0 $OPTS $DRIVEOFF -devicebackend8 1 $BUSDEVOFF -drive8truedrive $TRAPDEVOFF -autostartprgmode 2 +autostart-handle-tde -autostart-warp
dotest $EMU tde-image    1   0 $OPTS $DRIVEOFF -devicebackend8 1 $BUSDEVOFF -drive8truedrive $TRAPDEVOFF -autostartprgmode 2 +autostart-handle-tde +autostart-warp
# none
dotest $EMU none-image   0 255 $OPTS $DRIVEOFF -devicebackend8 1 $BUSDEVOFF +drive8truedrive $TRAPDEVOFF -autostartprgmode 2 +autostart-handle-tde -autostart-warp
dotest $EMU none-image   0 255 $OPTS $DRIVEOFF -devicebackend8 1 $BUSDEVOFF +drive8truedrive $TRAPDEVOFF -autostartprgmode 2 +autostart-handle-tde +autostart-warp
if [ "$TRAPDEVICE" = "yes" ]; then
dotest $EMU tde-image    0 255 $OPTS $DRIVEOFF -devicebackend8 1 $BUSDEVOFF -drive8truedrive $TRAPDEVON -autostartprgmode 2 +autostart-handle-tde -autostart-warp
dotest $EMU tde-image    0 255 $OPTS $DRIVEOFF -devicebackend8 1 $BUSDEVOFF -drive8truedrive $TRAPDEVON -autostartprgmode 2 +autostart-handle-tde +autostart-warp
# vfs only
dotest $EMU vdrive-image 1   0 $OPTS $DRIVEOFF -devicebackend8 1 $BUSDEVOFF +drive8truedrive $TRAPDEVON -autostartprgmode 2 +autostart-handle-tde -autostart-warp
dotest $EMU vdrive-image 1   0 $OPTS $DRIVEOFF -devicebackend8 1 $BUSDEVOFF +drive8truedrive $TRAPDEVON -autostartprgmode 2 +autostart-handle-tde +autostart-warp
fi
if [ "$BUSDEVICE" = "yes" ]; then
dotest $EMU tde-image    0 255 $OPTS $DRIVEOFF -devicebackend8 1 $BUSDEVON  -drive8truedrive $TRAPDEVOFF -autostartprgmode 2 +autostart-handle-tde -autostart-warp
dotest $EMU tde-image    0 255 $OPTS $DRIVEOFF -devicebackend8 1 $BUSDEVON  -drive8truedrive $TRAPDEVOFF -autostartprgmode 2 +autostart-handle-tde +autostart-warp
# iecdev only
dotest $EMU vdrive-image 1   0 $OPTS $DRIVEOFF -devicebackend8 1 $BUSDEVON  +drive8truedrive $TRAPDEVOFF -autostartprgmode 2 +autostart-handle-tde -autostart-warp
dotest $EMU vdrive-image 1   0 $OPTS $DRIVEOFF -devicebackend8 1 $BUSDEVON  +drive8truedrive $TRAPDEVOFF -autostartprgmode 2 +autostart-handle-tde +autostart-warp
if [ "$TRAPDEVICE" = "yes" ]; then
dotest $EMU tde-image    0 255 $OPTS $DRIVEOFF -devicebackend8 1 $BUSDEVON  -drive8truedrive $TRAPDEVON -autostartprgmode 2 +autostart-handle-tde -autostart-warp
dotest $EMU tde-image    0 255 $OPTS $DRIVEOFF -devicebackend8 1 $BUSDEVON  -drive8truedrive $TRAPDEVON -autostartprgmode 2 +autostart-handle-tde +autostart-warp
dotest $EMU vdrive-image 0 255 $OPTS $DRIVEOFF -devicebackend8 1 $BUSDEVON  +drive8truedrive $TRAPDEVON -autostartprgmode 2 +autostart-handle-tde -autostart-warp
dotest $EMU vdrive-image 0 255 $OPTS $DRIVEOFF -devicebackend8 1 $BUSDEVON  +drive8truedrive $TRAPDEVON -autostartprgmode 2 +autostart-handle-tde +autostart-warp
fi
fi

# "handle tde at autostart" will let autostart disable TDE in favour if virtual devices
# however, this does not change anything in the final state, so again all of the above repeats

echo "disk - autostart mode 0 (virtual filesystem, backend: none) - handle TDE"

## fsdevice = none
# TDEonly
dotest $EMU tde-image    1   0 $OPTS $DRIVEOFF -devicebackend8 0 $BUSDEVOFF -drive8truedrive $TRAPDEVOFF -autostartprgmode 0 -autostart-handle-tde -autostart-warp
dotest $EMU tde-image    1   0 $OPTS $DRIVEOFF -devicebackend8 0 $BUSDEVOFF -drive8truedrive $TRAPDEVOFF -autostartprgmode 0 -autostart-handle-tde +autostart-warp
# none
dotest $EMU none-image   0 255 $OPTS $DRIVEOFF -devicebackend8 0 $BUSDEVOFF +drive8truedrive $TRAPDEVOFF -autostartprgmode 0 -autostart-handle-tde -autostart-warp
dotest $EMU none-image   0 255 $OPTS $DRIVEOFF -devicebackend8 0 $BUSDEVOFF +drive8truedrive $TRAPDEVOFF -autostartprgmode 0 -autostart-handle-tde +autostart-warp
if [ "$TRAPDEVICE" = "yes" ]; then
dotest $EMU tde-image    0 255 $OPTS $DRIVEOFF -devicebackend8 0 $BUSDEVOFF -drive8truedrive $TRAPDEVON -autostartprgmode 0 -autostart-handle-tde -autostart-warp
dotest $EMU tde-image    0 255 $OPTS $DRIVEOFF -devicebackend8 0 $BUSDEVOFF -drive8truedrive $TRAPDEVON -autostartprgmode 0 -autostart-handle-tde +autostart-warp
# vfs only
dotest $EMU vdrive-image 1   0 $OPTS $DRIVEOFF -devicebackend8 0 $BUSDEVOFF +drive8truedrive $TRAPDEVON -autostartprgmode 0 -autostart-handle-tde -autostart-warp
dotest $EMU vdrive-image 1   0 $OPTS $DRIVEOFF -devicebackend8 0 $BUSDEVOFF +drive8truedrive $TRAPDEVON -autostartprgmode 0 -autostart-handle-tde +autostart-warp
fi
if [ "$BUSDEVICE" = "yes" ]; then
dotest $EMU tde-image    0 255 $OPTS $DRIVEOFF -devicebackend8 0 $BUSDEVON  -drive8truedrive $TRAPDEVOFF -autostartprgmode 0 -autostart-handle-tde -autostart-warp
dotest $EMU tde-image    0 255 $OPTS $DRIVEOFF -devicebackend8 0 $BUSDEVON  -drive8truedrive $TRAPDEVOFF -autostartprgmode 0 -autostart-handle-tde +autostart-warp
# iecdev only
dotest $EMU vdrive-image 1   0 $OPTS $DRIVEOFF -devicebackend8 0 $BUSDEVON  +drive8truedrive $TRAPDEVOFF -autostartprgmode 0 -autostart-handle-tde -autostart-warp
dotest $EMU vdrive-image 1   0 $OPTS $DRIVEOFF -devicebackend8 0 $BUSDEVON  +drive8truedrive $TRAPDEVOFF -autostartprgmode 0 -autostart-handle-tde +autostart-warp
if [ "$TRAPDEVICE" = "yes" ]; then
dotest $EMU tde-image    0 255 $OPTS $DRIVEOFF -devicebackend8 0 $BUSDEVON  -drive8truedrive $TRAPDEVON -autostartprgmode 0 -autostart-handle-tde -autostart-warp
dotest $EMU tde-image    0 255 $OPTS $DRIVEOFF -devicebackend8 0 $BUSDEVON  -drive8truedrive $TRAPDEVON -autostartprgmode 0 -autostart-handle-tde +autostart-warp
dotest $EMU vdrive-image 0 255 $OPTS $DRIVEOFF -devicebackend8 0 $BUSDEVON  +drive8truedrive $TRAPDEVON -autostartprgmode 0 -autostart-handle-tde -autostart-warp
dotest $EMU vdrive-image 0 255 $OPTS $DRIVEOFF -devicebackend8 0 $BUSDEVON  +drive8truedrive $TRAPDEVON -autostartprgmode 0 -autostart-handle-tde +autostart-warp
fi
fi
echo "disk - autostart mode 0 (virtual filesystem, backend: fsdevice) - handle TDE"

## fsdevice = filesystem
# TDEonly
dotest $EMU tde-image    1   0 $OPTS $DRIVEOFF -devicebackend8 1 $BUSDEVOFF -drive8truedrive $TRAPDEVOFF -autostartprgmode 0 -autostart-handle-tde -autostart-warp
dotest $EMU tde-image    1   0 $OPTS $DRIVEOFF -devicebackend8 1 $BUSDEVOFF -drive8truedrive $TRAPDEVOFF -autostartprgmode 0 -autostart-handle-tde +autostart-warp
# none
dotest $EMU none-image   0 255 $OPTS $DRIVEOFF -devicebackend8 1 $BUSDEVOFF +drive8truedrive $TRAPDEVOFF -autostartprgmode 0 -autostart-handle-tde -autostart-warp
dotest $EMU none-image   0 255 $OPTS $DRIVEOFF -devicebackend8 1 $BUSDEVOFF +drive8truedrive $TRAPDEVOFF -autostartprgmode 0 -autostart-handle-tde +autostart-warp
if [ "$TRAPDEVICE" = "yes" ]; then
dotest $EMU tde-image    0 255 $OPTS $DRIVEOFF -devicebackend8 1 $BUSDEVOFF -drive8truedrive $TRAPDEVON -autostartprgmode 0 -autostart-handle-tde -autostart-warp
dotest $EMU tde-image    0 255 $OPTS $DRIVEOFF -devicebackend8 1 $BUSDEVOFF -drive8truedrive $TRAPDEVON -autostartprgmode 0 -autostart-handle-tde +autostart-warp
# vfs only
dotest $EMU vdrive-image 1   0 $OPTS $DRIVEOFF -devicebackend8 1 $BUSDEVOFF +drive8truedrive $TRAPDEVON -autostartprgmode 0 -autostart-handle-tde -autostart-warp
dotest $EMU vdrive-image 1   0 $OPTS $DRIVEOFF -devicebackend8 1 $BUSDEVOFF +drive8truedrive $TRAPDEVON -autostartprgmode 0 -autostart-handle-tde +autostart-warp
fi
if [ "$BUSDEVICE" = "yes" ]; then
dotest $EMU tde-image    0 255 $OPTS $DRIVEOFF -devicebackend8 1 $BUSDEVON  -drive8truedrive $TRAPDEVOFF -autostartprgmode 0 -autostart-handle-tde -autostart-warp
dotest $EMU tde-image    0 255 $OPTS $DRIVEOFF -devicebackend8 1 $BUSDEVON  -drive8truedrive $TRAPDEVOFF -autostartprgmode 0 -autostart-handle-tde +autostart-warp
# iecdev only
dotest $EMU vdrive-image 1   0 $OPTS $DRIVEOFF -devicebackend8 1 $BUSDEVON  +drive8truedrive $TRAPDEVOFF -autostartprgmode 0 -autostart-handle-tde -autostart-warp
dotest $EMU vdrive-image 1   0 $OPTS $DRIVEOFF -devicebackend8 1 $BUSDEVON  +drive8truedrive $TRAPDEVOFF -autostartprgmode 0 -autostart-handle-tde +autostart-warp
if [ "$TRAPDEVICE" = "yes" ]; then
dotest $EMU tde-image    0 255 $OPTS $DRIVEOFF -devicebackend8 1 $BUSDEVON  -drive8truedrive $TRAPDEVON -autostartprgmode 0 -autostart-handle-tde -autostart-warp
dotest $EMU tde-image    0 255 $OPTS $DRIVEOFF -devicebackend8 1 $BUSDEVON  -drive8truedrive $TRAPDEVON -autostartprgmode 0 -autostart-handle-tde +autostart-warp
dotest $EMU vdrive-image 0 255 $OPTS $DRIVEOFF -devicebackend8 1 $BUSDEVON  +drive8truedrive $TRAPDEVON -autostartprgmode 0 -autostart-handle-tde -autostart-warp
dotest $EMU vdrive-image 0 255 $OPTS $DRIVEOFF -devicebackend8 1 $BUSDEVON  +drive8truedrive $TRAPDEVON -autostartprgmode 0 -autostart-handle-tde +autostart-warp
fi
fi

echo "disk - autostart mode 1 (inject to RAM, backend: none) - handle TDE"

## fsdevice = none
# TDEonly
dotest $EMU tde-image    1   0 $OPTS $DRIVEOFF -devicebackend8 0 $BUSDEVOFF -drive8truedrive $TRAPDEVOFF -autostartprgmode 1 -autostart-handle-tde -autostart-warp
dotest $EMU tde-image    1   0 $OPTS $DRIVEOFF -devicebackend8 0 $BUSDEVOFF -drive8truedrive $TRAPDEVOFF -autostartprgmode 1 -autostart-handle-tde +autostart-warp
# none
dotest $EMU none-image   0 255 $OPTS $DRIVEOFF -devicebackend8 0 $BUSDEVOFF +drive8truedrive $TRAPDEVOFF -autostartprgmode 1 -autostart-handle-tde -autostart-warp
dotest $EMU none-image   0 255 $OPTS $DRIVEOFF -devicebackend8 0 $BUSDEVOFF +drive8truedrive $TRAPDEVOFF -autostartprgmode 1 -autostart-handle-tde +autostart-warp
if [ "$TRAPDEVICE" = "yes" ]; then
dotest $EMU tde-image    0 255 $OPTS $DRIVEOFF -devicebackend8 0 $BUSDEVOFF -drive8truedrive $TRAPDEVON -autostartprgmode 1 -autostart-handle-tde -autostart-warp
dotest $EMU tde-image    0 255 $OPTS $DRIVEOFF -devicebackend8 0 $BUSDEVOFF -drive8truedrive $TRAPDEVON -autostartprgmode 1 -autostart-handle-tde +autostart-warp
# vfs only
dotest $EMU vdrive-image 1   0 $OPTS $DRIVEOFF -devicebackend8 0 $BUSDEVOFF +drive8truedrive $TRAPDEVON -autostartprgmode 1 -autostart-handle-tde -autostart-warp
dotest $EMU vdrive-image 1   0 $OPTS $DRIVEOFF -devicebackend8 0 $BUSDEVOFF +drive8truedrive $TRAPDEVON -autostartprgmode 1 -autostart-handle-tde +autostart-warp
fi
if [ "$BUSDEVICE" = "yes" ]; then
dotest $EMU tde-image    0 255 $OPTS $DRIVEOFF -devicebackend8 0 $BUSDEVON  -drive8truedrive $TRAPDEVOFF -autostartprgmode 1 -autostart-handle-tde -autostart-warp
dotest $EMU tde-image    0 255 $OPTS $DRIVEOFF -devicebackend8 0 $BUSDEVON  -drive8truedrive $TRAPDEVOFF -autostartprgmode 1 -autostart-handle-tde +autostart-warp
# iecdev only
dotest $EMU vdrive-image 1   0 $OPTS $DRIVEOFF -devicebackend8 0 $BUSDEVON  +drive8truedrive $TRAPDEVOFF -autostartprgmode 1 -autostart-handle-tde -autostart-warp
dotest $EMU vdrive-image 1   0 $OPTS $DRIVEOFF -devicebackend8 0 $BUSDEVON  +drive8truedrive $TRAPDEVOFF -autostartprgmode 1 -autostart-handle-tde +autostart-warp
if [ "$TRAPDEVICE" = "yes" ]; then
dotest $EMU tde-image    0 255 $OPTS $DRIVEOFF -devicebackend8 0 $BUSDEVON  -drive8truedrive $TRAPDEVON -autostartprgmode 1 -autostart-handle-tde -autostart-warp
dotest $EMU tde-image    0 255 $OPTS $DRIVEOFF -devicebackend8 0 $BUSDEVON  -drive8truedrive $TRAPDEVON -autostartprgmode 1 -autostart-handle-tde +autostart-warp
dotest $EMU vdrive-image 0 255 $OPTS $DRIVEOFF -devicebackend8 0 $BUSDEVON  +drive8truedrive $TRAPDEVON -autostartprgmode 1 -autostart-handle-tde -autostart-warp
dotest $EMU vdrive-image 0 255 $OPTS $DRIVEOFF -devicebackend8 0 $BUSDEVON  +drive8truedrive $TRAPDEVON -autostartprgmode 1 -autostart-handle-tde +autostart-warp
fi
fi
echo "disk - autostart mode 1 (inject to RAM, backend: fsdevice) - handle TDE"

## fsdevice = filesystem
# TDEonly
dotest $EMU tde-image    1   0 $OPTS $DRIVEOFF -devicebackend8 1 $BUSDEVOFF -drive8truedrive $TRAPDEVOFF -autostartprgmode 1 -autostart-handle-tde -autostart-warp
dotest $EMU tde-image    1   0 $OPTS $DRIVEOFF -devicebackend8 1 $BUSDEVOFF -drive8truedrive $TRAPDEVOFF -autostartprgmode 1 -autostart-handle-tde +autostart-warp
# none
dotest $EMU none-image   0 255 $OPTS $DRIVEOFF -devicebackend8 1 $BUSDEVOFF +drive8truedrive $TRAPDEVOFF -autostartprgmode 1 -autostart-handle-tde -autostart-warp
dotest $EMU none-image   0 255 $OPTS $DRIVEOFF -devicebackend8 1 $BUSDEVOFF +drive8truedrive $TRAPDEVOFF -autostartprgmode 1 -autostart-handle-tde +autostart-warp
if [ "$TRAPDEVICE" = "yes" ]; then
dotest $EMU tde-image    0 255 $OPTS $DRIVEOFF -devicebackend8 1 $BUSDEVOFF -drive8truedrive $TRAPDEVON -autostartprgmode 1 -autostart-handle-tde -autostart-warp
dotest $EMU tde-image    0 255 $OPTS $DRIVEOFF -devicebackend8 1 $BUSDEVOFF -drive8truedrive $TRAPDEVON -autostartprgmode 1 -autostart-handle-tde +autostart-warp
# vfs only
dotest $EMU vdrive-image 1   0 $OPTS $DRIVEOFF -devicebackend8 1 $BUSDEVOFF +drive8truedrive $TRAPDEVON -autostartprgmode 1 -autostart-handle-tde -autostart-warp
dotest $EMU vdrive-image 1   0 $OPTS $DRIVEOFF -devicebackend8 1 $BUSDEVOFF +drive8truedrive $TRAPDEVON -autostartprgmode 1 -autostart-handle-tde +autostart-warp
fi
if [ "$BUSDEVICE" = "yes" ]; then
dotest $EMU tde-image    0 255 $OPTS $DRIVEOFF -devicebackend8 1 $BUSDEVON  -drive8truedrive $TRAPDEVOFF -autostartprgmode 1 -autostart-handle-tde -autostart-warp
dotest $EMU tde-image    0 255 $OPTS $DRIVEOFF -devicebackend8 1 $BUSDEVON  -drive8truedrive $TRAPDEVOFF -autostartprgmode 1 -autostart-handle-tde +autostart-warp
# iecdev only
dotest $EMU vdrive-image 1   0 $OPTS $DRIVEOFF -devicebackend8 1 $BUSDEVON  +drive8truedrive $TRAPDEVOFF -autostartprgmode 1 -autostart-handle-tde -autostart-warp
dotest $EMU vdrive-image 1   0 $OPTS $DRIVEOFF -devicebackend8 1 $BUSDEVON  +drive8truedrive $TRAPDEVOFF -autostartprgmode 1 -autostart-handle-tde +autostart-warp
if [ "$TRAPDEVICE" = "yes" ]; then
dotest $EMU tde-image    0 255 $OPTS $DRIVEOFF -devicebackend8 1 $BUSDEVON  -drive8truedrive $TRAPDEVON -autostartprgmode 1 -autostart-handle-tde -autostart-warp
dotest $EMU tde-image    0 255 $OPTS $DRIVEOFF -devicebackend8 1 $BUSDEVON  -drive8truedrive $TRAPDEVON -autostartprgmode 1 -autostart-handle-tde +autostart-warp
dotest $EMU vdrive-image 0 255 $OPTS $DRIVEOFF -devicebackend8 1 $BUSDEVON  +drive8truedrive $TRAPDEVON -autostartprgmode 1 -autostart-handle-tde -autostart-warp
dotest $EMU vdrive-image 0 255 $OPTS $DRIVEOFF -devicebackend8 1 $BUSDEVON  +drive8truedrive $TRAPDEVON -autostartprgmode 1 -autostart-handle-tde +autostart-warp
fi
fi

echo "disk - autostart mode 2 (copy to disk image, backend: none) - handle TDE"

## fsdevice = none
# TDEonly
dotest $EMU tde-image    1   0 $OPTS $DRIVEOFF -devicebackend8 0 $BUSDEVOFF -drive8truedrive $TRAPDEVOFF -autostartprgmode 2 -autostart-handle-tde -autostart-warp
dotest $EMU tde-image    1   0 $OPTS $DRIVEOFF -devicebackend8 0 $BUSDEVOFF -drive8truedrive $TRAPDEVOFF -autostartprgmode 2 -autostart-handle-tde +autostart-warp
# none
dotest $EMU none-image   0 255 $OPTS $DRIVEOFF -devicebackend8 0 $BUSDEVOFF +drive8truedrive $TRAPDEVOFF -autostartprgmode 2 -autostart-handle-tde -autostart-warp
dotest $EMU none-image   0 255 $OPTS $DRIVEOFF -devicebackend8 0 $BUSDEVOFF +drive8truedrive $TRAPDEVOFF -autostartprgmode 2 -autostart-handle-tde +autostart-warp
if [ "$TRAPDEVICE" = "yes" ]; then
dotest $EMU tde-image    0 255 $OPTS $DRIVEOFF -devicebackend8 0 $BUSDEVOFF -drive8truedrive $TRAPDEVON -autostartprgmode 2 -autostart-handle-tde -autostart-warp
dotest $EMU tde-image    0 255 $OPTS $DRIVEOFF -devicebackend8 0 $BUSDEVOFF -drive8truedrive $TRAPDEVON -autostartprgmode 2 -autostart-handle-tde +autostart-warp
# vfs only
dotest $EMU vdrive-image 1   0 $OPTS $DRIVEOFF -devicebackend8 0 $BUSDEVOFF +drive8truedrive $TRAPDEVON -autostartprgmode 2 -autostart-handle-tde -autostart-warp
dotest $EMU vdrive-image 1   0 $OPTS $DRIVEOFF -devicebackend8 0 $BUSDEVOFF +drive8truedrive $TRAPDEVON -autostartprgmode 2 -autostart-handle-tde +autostart-warp
fi
if [ "$BUSDEVICE" = "yes" ]; then
dotest $EMU tde-image    0 255 $OPTS $DRIVEOFF -devicebackend8 0 $BUSDEVON  -drive8truedrive $TRAPDEVOFF -autostartprgmode 2 -autostart-handle-tde -autostart-warp
dotest $EMU tde-image    0 255 $OPTS $DRIVEOFF -devicebackend8 0 $BUSDEVON  -drive8truedrive $TRAPDEVOFF -autostartprgmode 2 -autostart-handle-tde +autostart-warp
# iecdev only
dotest $EMU vdrive-image 1   0 $OPTS $DRIVEOFF -devicebackend8 0 $BUSDEVON  +drive8truedrive $TRAPDEVOFF -autostartprgmode 2 -autostart-handle-tde -autostart-warp
dotest $EMU vdrive-image 1   0 $OPTS $DRIVEOFF -devicebackend8 0 $BUSDEVON  +drive8truedrive $TRAPDEVOFF -autostartprgmode 2 -autostart-handle-tde +autostart-warp
if [ "$TRAPDEVICE" = "yes" ]; then
dotest $EMU tde-image    0 255 $OPTS $DRIVEOFF -devicebackend8 0 $BUSDEVON  -drive8truedrive $TRAPDEVON -autostartprgmode 2 -autostart-handle-tde -autostart-warp
dotest $EMU tde-image    0 255 $OPTS $DRIVEOFF -devicebackend8 0 $BUSDEVON  -drive8truedrive $TRAPDEVON -autostartprgmode 2 -autostart-handle-tde +autostart-warp
dotest $EMU vdrive-image 0 255 $OPTS $DRIVEOFF -devicebackend8 0 $BUSDEVON  +drive8truedrive $TRAPDEVON -autostartprgmode 2 -autostart-handle-tde -autostart-warp
dotest $EMU vdrive-image 0 255 $OPTS $DRIVEOFF -devicebackend8 0 $BUSDEVON  +drive8truedrive $TRAPDEVON -autostartprgmode 2 -autostart-handle-tde +autostart-warp
fi
fi
echo "disk - autostart mode 2 (copy to disk image, backend: fsdevice) - handle TDE"

## fsdevice = filesystem
# TDEonly
dotest $EMU tde-image    1   0 $OPTS $DRIVEOFF -devicebackend8 1 $BUSDEVOFF -drive8truedrive $TRAPDEVOFF -autostartprgmode 2 -autostart-handle-tde -autostart-warp
dotest $EMU tde-image    1   0 $OPTS $DRIVEOFF -devicebackend8 1 $BUSDEVOFF -drive8truedrive $TRAPDEVOFF -autostartprgmode 2 -autostart-handle-tde +autostart-warp
# none
dotest $EMU none-image   0 255 $OPTS $DRIVEOFF -devicebackend8 1 $BUSDEVOFF +drive8truedrive $TRAPDEVOFF -autostartprgmode 2 -autostart-handle-tde -autostart-warp
dotest $EMU none-image   0 255 $OPTS $DRIVEOFF -devicebackend8 1 $BUSDEVOFF +drive8truedrive $TRAPDEVOFF -autostartprgmode 2 -autostart-handle-tde +autostart-warp
if [ "$TRAPDEVICE" = "yes" ]; then
dotest $EMU tde-image    0 255 $OPTS $DRIVEOFF -devicebackend8 1 $BUSDEVOFF -drive8truedrive $TRAPDEVON -autostartprgmode 2 -autostart-handle-tde -autostart-warp
dotest $EMU tde-image    0 255 $OPTS $DRIVEOFF -devicebackend8 1 $BUSDEVOFF -drive8truedrive $TRAPDEVON -autostartprgmode 2 -autostart-handle-tde +autostart-warp
# vfs only
dotest $EMU vdrive-image 1   0 $OPTS $DRIVEOFF -devicebackend8 1 $BUSDEVOFF +drive8truedrive $TRAPDEVON -autostartprgmode 2 -autostart-handle-tde -autostart-warp
dotest $EMU vdrive-image 1   0 $OPTS $DRIVEOFF -devicebackend8 1 $BUSDEVOFF +drive8truedrive $TRAPDEVON -autostartprgmode 2 -autostart-handle-tde +autostart-warp
fi
if [ "$BUSDEVICE" = "yes" ]; then
dotest $EMU tde-image    0 255 $OPTS $DRIVEOFF -devicebackend8 1 $BUSDEVON  -drive8truedrive $TRAPDEVOFF -autostartprgmode 2 -autostart-handle-tde -autostart-warp
dotest $EMU tde-image    0 255 $OPTS $DRIVEOFF -devicebackend8 1 $BUSDEVON  -drive8truedrive $TRAPDEVOFF -autostartprgmode 2 -autostart-handle-tde +autostart-warp
# iecdev only
dotest $EMU vdrive-image 1   0 $OPTS $DRIVEOFF -devicebackend8 1 $BUSDEVON  +drive8truedrive $TRAPDEVOFF -autostartprgmode 2 -autostart-handle-tde -autostart-warp
dotest $EMU vdrive-image 1   0 $OPTS $DRIVEOFF -devicebackend8 1 $BUSDEVON  +drive8truedrive $TRAPDEVOFF -autostartprgmode 2 -autostart-handle-tde +autostart-warp
if [ "$TRAPDEVICE" = "yes" ]; then
dotest $EMU tde-image    0 255 $OPTS $DRIVEOFF -devicebackend8 1 $BUSDEVON  -drive8truedrive $TRAPDEVON -autostartprgmode 2 -autostart-handle-tde -autostart-warp
dotest $EMU tde-image    0 255 $OPTS $DRIVEOFF -devicebackend8 1 $BUSDEVON  -drive8truedrive $TRAPDEVON -autostartprgmode 2 -autostart-handle-tde +autostart-warp
dotest $EMU vdrive-image 0 255 $OPTS $DRIVEOFF -devicebackend8 1 $BUSDEVON  +drive8truedrive $TRAPDEVON -autostartprgmode 2 -autostart-handle-tde -autostart-warp
dotest $EMU vdrive-image 0 255 $OPTS $DRIVEOFF -devicebackend8 1 $BUSDEVON  +drive8truedrive $TRAPDEVON -autostartprgmode 2 -autostart-handle-tde +autostart-warp
fi
fi

echo "---"
}

function alltests_t64
{
echo $EMU":"$PROGPRE-X.$PROGEXT
if [ "$EMU" = "xpet" ] || [ "$EMU" = "xcbm2" ] || [ "$EMU" = "xcbm5x0" ]; then
dotest $EMU none 1 0 -default $OPTS
else
dotest $EMU tde 1 0 -default $OPTS
fi

echo "t64 - autostart mode 0 (virtual filesystem, backend: none) - do not handle TDE"
## fsdevice = none
# TDEonly
dotest $EMU tde         1   0 $OPTS $DRIVEON -devicebackend8 0 $BUSDEVOFF -drive8truedrive +trapdevice1 -autostartprgmode 0 +autostart-handle-tde -autostart-warp
dotest $EMU tde         1   0 $OPTS $DRIVEON -devicebackend8 0 $BUSDEVOFF -drive8truedrive +trapdevice1 -autostartprgmode 0 +autostart-handle-tde +autostart-warp
dotest $EMU tde         0 255 $OPTS $DRIVEON -devicebackend8 0 $BUSDEVOFF -drive8truedrive -trapdevice1 -autostartprgmode 0 +autostart-handle-tde -autostart-warp
dotest $EMU tde         0 255 $OPTS $DRIVEON -devicebackend8 0 $BUSDEVOFF -drive8truedrive -trapdevice1 -autostartprgmode 0 +autostart-handle-tde +autostart-warp
# none
dotest $EMU none        1   0 $OPTS $DRIVEON -devicebackend8 0 $BUSDEVOFF +drive8truedrive +trapdevice1 -autostartprgmode 0 +autostart-handle-tde -autostart-warp
dotest $EMU none        1   0 $OPTS $DRIVEON -devicebackend8 0 $BUSDEVOFF +drive8truedrive +trapdevice1 -autostartprgmode 0 +autostart-handle-tde +autostart-warp
# vfs only
dotest $EMU none        1   0 $OPTS $DRIVEON -devicebackend8 0 $BUSDEVOFF +drive8truedrive -trapdevice1 -autostartprgmode 0 +autostart-handle-tde -autostart-warp
dotest $EMU none        1   0 $OPTS $DRIVEON -devicebackend8 0 $BUSDEVOFF +drive8truedrive -trapdevice1 -autostartprgmode 0 +autostart-handle-tde +autostart-warp
if [ "$BUSDEVICE" = "yes" ]; then
dotest $EMU tde         0 255 $OPTS $DRIVEON -devicebackend8 0 $BUSDEVON  -drive8truedrive +trapdevice1 -autostartprgmode 0 +autostart-handle-tde -autostart-warp
dotest $EMU tde         0 255 $OPTS $DRIVEON -devicebackend8 0 $BUSDEVON  -drive8truedrive +trapdevice1 -autostartprgmode 0 +autostart-handle-tde +autostart-warp
dotest $EMU tde         0 255 $OPTS $DRIVEON -devicebackend8 0 $BUSDEVON  -drive8truedrive -trapdevice1 -autostartprgmode 0 +autostart-handle-tde -autostart-warp
dotest $EMU tde         0 255 $OPTS $DRIVEON -devicebackend8 0 $BUSDEVON  -drive8truedrive -trapdevice1 -autostartprgmode 0 +autostart-handle-tde +autostart-warp
# iecdev only
dotest $EMU none        1   0 $OPTS $DRIVEON -devicebackend8 0 $BUSDEVON  +drive8truedrive +trapdevice1 -autostartprgmode 0 +autostart-handle-tde -autostart-warp
dotest $EMU none        1   0 $OPTS $DRIVEON -devicebackend8 0 $BUSDEVON  +drive8truedrive +trapdevice1 -autostartprgmode 0 +autostart-handle-tde +autostart-warp
dotest $EMU vfs         0 255 $OPTS $DRIVEON -devicebackend8 0 $BUSDEVON  +drive8truedrive -trapdevice1 -autostartprgmode 0 +autostart-handle-tde -autostart-warp
dotest $EMU vfs         0 255 $OPTS $DRIVEON -devicebackend8 0 $BUSDEVON  +drive8truedrive -trapdevice1 -autostartprgmode 0 +autostart-handle-tde +autostart-warp
fi

echo "t64 - autostart mode 0 (virtual filesystem, backend: fsdevice) - do not handle TDE"
## fsdevice = filesystem
# TDEonly
dotest $EMU tde         1   0 $OPTS $DRIVEON -devicebackend8 1 $BUSDEVOFF -drive8truedrive +trapdevice1 -autostartprgmode 0 +autostart-handle-tde -autostart-warp
dotest $EMU tde         1   0 $OPTS $DRIVEON -devicebackend8 1 $BUSDEVOFF -drive8truedrive +trapdevice1 -autostartprgmode 0 +autostart-handle-tde +autostart-warp
dotest $EMU tde         0 255 $OPTS $DRIVEON -devicebackend8 1 $BUSDEVOFF -drive8truedrive -trapdevice1 -autostartprgmode 0 +autostart-handle-tde -autostart-warp
dotest $EMU tde         0 255 $OPTS $DRIVEON -devicebackend8 1 $BUSDEVOFF -drive8truedrive -trapdevice1 -autostartprgmode 0 +autostart-handle-tde +autostart-warp
# none
dotest $EMU none        1   0 $OPTS $DRIVEON -devicebackend8 1 $BUSDEVOFF +drive8truedrive +trapdevice1 -autostartprgmode 0 +autostart-handle-tde -autostart-warp
dotest $EMU none        1   0 $OPTS $DRIVEON -devicebackend8 1 $BUSDEVOFF +drive8truedrive +trapdevice1 -autostartprgmode 0 +autostart-handle-tde +autostart-warp
# vfs only
dotest $EMU none        1   0 $OPTS $DRIVEON -devicebackend8 1 $BUSDEVOFF +drive8truedrive -trapdevice1 -autostartprgmode 0 +autostart-handle-tde -autostart-warp
dotest $EMU none        1   0 $OPTS $DRIVEON -devicebackend8 1 $BUSDEVOFF +drive8truedrive -trapdevice1 -autostartprgmode 0 +autostart-handle-tde +autostart-warp
if [ "$BUSDEVICE" = "yes" ]; then
dotest $EMU tde         0 255 $OPTS $DRIVEON -devicebackend8 1 $BUSDEVON  -drive8truedrive +trapdevice1 -autostartprgmode 0 +autostart-handle-tde -autostart-warp
dotest $EMU tde         0 255 $OPTS $DRIVEON -devicebackend8 1 $BUSDEVON  -drive8truedrive +trapdevice1 -autostartprgmode 0 +autostart-handle-tde +autostart-warp
dotest $EMU tde         0 255 $OPTS $DRIVEON -devicebackend8 1 $BUSDEVON  -drive8truedrive -trapdevice1 -autostartprgmode 0 +autostart-handle-tde -autostart-warp
dotest $EMU tde         0 255 $OPTS $DRIVEON -devicebackend8 1 $BUSDEVON  -drive8truedrive -trapdevice1 -autostartprgmode 0 +autostart-handle-tde +autostart-warp
# iecdev only
dotest $EMU vfs         1   0 $OPTS $DRIVEON -devicebackend8 1 $BUSDEVON  +drive8truedrive +trapdevice1 -autostartprgmode 0 +autostart-handle-tde -autostart-warp
dotest $EMU vfs         1   0 $OPTS $DRIVEON -devicebackend8 1 $BUSDEVON  +drive8truedrive +trapdevice1 -autostartprgmode 0 +autostart-handle-tde +autostart-warp
dotest $EMU vfs         0 255 $OPTS $DRIVEON -devicebackend8 1 $BUSDEVON  +drive8truedrive -trapdevice1 -autostartprgmode 0 +autostart-handle-tde -autostart-warp
dotest $EMU vfs         0 255 $OPTS $DRIVEON -devicebackend8 1 $BUSDEVON  +drive8truedrive -trapdevice1 -autostartprgmode 0 +autostart-handle-tde +autostart-warp
fi

echo "t64 - autostart mode 1 (inject to RAM, backend: none) - do not handle TDE"
## fsdevice = none
# TDEonly
dotest $EMU tde         1   0 $OPTS $DRIVEON -devicebackend8 0 $BUSDEVOFF -drive8truedrive +trapdevice1 -autostartprgmode 1 +autostart-handle-tde -autostart-warp
dotest $EMU tde         1   0 $OPTS $DRIVEON -devicebackend8 0 $BUSDEVOFF -drive8truedrive +trapdevice1 -autostartprgmode 1 +autostart-handle-tde +autostart-warp
dotest $EMU tde         0 255 $OPTS $DRIVEON -devicebackend8 0 $BUSDEVOFF -drive8truedrive -trapdevice1 -autostartprgmode 1 +autostart-handle-tde -autostart-warp
dotest $EMU tde         0 255 $OPTS $DRIVEON -devicebackend8 0 $BUSDEVOFF -drive8truedrive -trapdevice1 -autostartprgmode 1 +autostart-handle-tde +autostart-warp
# none
dotest $EMU none        1   0 $OPTS $DRIVEON -devicebackend8 0 $BUSDEVOFF +drive8truedrive +trapdevice1 -autostartprgmode 1 +autostart-handle-tde -autostart-warp
dotest $EMU none        1   0 $OPTS $DRIVEON -devicebackend8 0 $BUSDEVOFF +drive8truedrive +trapdevice1 -autostartprgmode 1 +autostart-handle-tde +autostart-warp
# vfs only
dotest $EMU none        1   0 $OPTS $DRIVEON -devicebackend8 0 $BUSDEVOFF +drive8truedrive -trapdevice1 -autostartprgmode 1 +autostart-handle-tde -autostart-warp
dotest $EMU none        1   0 $OPTS $DRIVEON -devicebackend8 0 $BUSDEVOFF +drive8truedrive -trapdevice1 -autostartprgmode 1 +autostart-handle-tde +autostart-warp
if [ "$BUSDEVICE" = "yes" ]; then
dotest $EMU tde         0 255 $OPTS $DRIVEON -devicebackend8 0 $BUSDEVON  -drive8truedrive +trapdevice1 -autostartprgmode 1 +autostart-handle-tde -autostart-warp
dotest $EMU tde         0 255 $OPTS $DRIVEON -devicebackend8 0 $BUSDEVON  -drive8truedrive +trapdevice1 -autostartprgmode 1 +autostart-handle-tde +autostart-warp
dotest $EMU tde         0 255 $OPTS $DRIVEON -devicebackend8 0 $BUSDEVON  -drive8truedrive -trapdevice1 -autostartprgmode 1 +autostart-handle-tde -autostart-warp
dotest $EMU tde         0 255 $OPTS $DRIVEON -devicebackend8 0 $BUSDEVON  -drive8truedrive -trapdevice1 -autostartprgmode 1 +autostart-handle-tde +autostart-warp
# iecdev only
dotest $EMU none        1   0 $OPTS $DRIVEON -devicebackend8 0 $BUSDEVON  +drive8truedrive +trapdevice1 -autostartprgmode 1 +autostart-handle-tde -autostart-warp
dotest $EMU none        1   0 $OPTS $DRIVEON -devicebackend8 0 $BUSDEVON  +drive8truedrive +trapdevice1 -autostartprgmode 1 +autostart-handle-tde +autostart-warp
dotest $EMU vfs         0 255 $OPTS $DRIVEON -devicebackend8 0 $BUSDEVON  +drive8truedrive -trapdevice1 -autostartprgmode 1 +autostart-handle-tde -autostart-warp
dotest $EMU vfs         0 255 $OPTS $DRIVEON -devicebackend8 0 $BUSDEVON  +drive8truedrive -trapdevice1 -autostartprgmode 1 +autostart-handle-tde +autostart-warp
fi
echo "t64 - autostart mode 1 (inject to RAM, backend: fsdevice) - do not handle TDE"
## fsdevice = filesystem
# TDEonly
dotest $EMU tde         1   0 $OPTS $DRIVEON -devicebackend8 1 $BUSDEVOFF -drive8truedrive +trapdevice1 -autostartprgmode 1 +autostart-handle-tde -autostart-warp
dotest $EMU tde         1   0 $OPTS $DRIVEON -devicebackend8 1 $BUSDEVOFF -drive8truedrive +trapdevice1 -autostartprgmode 1 +autostart-handle-tde +autostart-warp
dotest $EMU tde         0 255 $OPTS $DRIVEON -devicebackend8 1 $BUSDEVOFF -drive8truedrive -trapdevice1 -autostartprgmode 1 +autostart-handle-tde -autostart-warp
dotest $EMU tde         0 255 $OPTS $DRIVEON -devicebackend8 1 $BUSDEVOFF -drive8truedrive -trapdevice1 -autostartprgmode 1 +autostart-handle-tde +autostart-warp
# none
dotest $EMU none        1   0 $OPTS $DRIVEON -devicebackend8 1 $BUSDEVOFF +drive8truedrive +trapdevice1 -autostartprgmode 1 +autostart-handle-tde -autostart-warp
dotest $EMU none        1   0 $OPTS $DRIVEON -devicebackend8 1 $BUSDEVOFF +drive8truedrive +trapdevice1 -autostartprgmode 1 +autostart-handle-tde +autostart-warp
# vfs only
dotest $EMU none        1   0 $OPTS $DRIVEON -devicebackend8 1 $BUSDEVOFF +drive8truedrive -trapdevice1 -autostartprgmode 1 +autostart-handle-tde -autostart-warp
dotest $EMU none        1   0 $OPTS $DRIVEON -devicebackend8 1 $BUSDEVOFF +drive8truedrive -trapdevice1 -autostartprgmode 1 +autostart-handle-tde +autostart-warp
if [ "$BUSDEVICE" = "yes" ]; then
dotest $EMU tde         0 255 $OPTS $DRIVEON -devicebackend8 1 $BUSDEVON  -drive8truedrive +trapdevice1 -autostartprgmode 1 +autostart-handle-tde -autostart-warp
dotest $EMU tde         0 255 $OPTS $DRIVEON -devicebackend8 1 $BUSDEVON  -drive8truedrive +trapdevice1 -autostartprgmode 1 +autostart-handle-tde +autostart-warp
dotest $EMU tde         0 255 $OPTS $DRIVEON -devicebackend8 1 $BUSDEVON  -drive8truedrive -trapdevice1 -autostartprgmode 1 +autostart-handle-tde -autostart-warp
dotest $EMU tde         0 255 $OPTS $DRIVEON -devicebackend8 1 $BUSDEVON  -drive8truedrive -trapdevice1 -autostartprgmode 1 +autostart-handle-tde +autostart-warp
# iecdev only
dotest $EMU vfs         1   0 $OPTS $DRIVEON -devicebackend8 1 $BUSDEVON  +drive8truedrive +trapdevice1 -autostartprgmode 1 +autostart-handle-tde -autostart-warp
dotest $EMU vfs         1   0 $OPTS $DRIVEON -devicebackend8 1 $BUSDEVON  +drive8truedrive +trapdevice1 -autostartprgmode 1 +autostart-handle-tde +autostart-warp
dotest $EMU vfs         0 255 $OPTS $DRIVEON -devicebackend8 1 $BUSDEVON  +drive8truedrive -trapdevice1 -autostartprgmode 1 +autostart-handle-tde -autostart-warp
dotest $EMU vfs         0 255 $OPTS $DRIVEON -devicebackend8 1 $BUSDEVON  +drive8truedrive -trapdevice1 -autostartprgmode 1 +autostart-handle-tde +autostart-warp
fi

echo "t64 - autostart mode 0 (virtual filesystem, backend: none) - handle TDE"
## fsdevice = none
# TDEonly
dotest $EMU tde         1   0 $OPTS $DRIVEON -devicebackend8 0 $BUSDEVOFF -drive8truedrive +trapdevice1 -autostartprgmode 0 -autostart-handle-tde -autostart-warp
dotest $EMU tde         1   0 $OPTS $DRIVEON -devicebackend8 0 $BUSDEVOFF -drive8truedrive +trapdevice1 -autostartprgmode 0 -autostart-handle-tde +autostart-warp
dotest $EMU tde         0 255 $OPTS $DRIVEON -devicebackend8 0 $BUSDEVOFF -drive8truedrive -trapdevice1 -autostartprgmode 0 -autostart-handle-tde -autostart-warp
dotest $EMU tde         0 255 $OPTS $DRIVEON -devicebackend8 0 $BUSDEVOFF -drive8truedrive -trapdevice1 -autostartprgmode 0 -autostart-handle-tde +autostart-warp
# none
dotest $EMU none        1   0 $OPTS $DRIVEON -devicebackend8 0 $BUSDEVOFF +drive8truedrive +trapdevice1 -autostartprgmode 0 -autostart-handle-tde -autostart-warp
dotest $EMU none        1   0 $OPTS $DRIVEON -devicebackend8 0 $BUSDEVOFF +drive8truedrive +trapdevice1 -autostartprgmode 0 -autostart-handle-tde +autostart-warp
# vfs only
dotest $EMU none        1   0 $OPTS $DRIVEON -devicebackend8 0 $BUSDEVOFF +drive8truedrive -trapdevice1 -autostartprgmode 0 -autostart-handle-tde -autostart-warp
dotest $EMU none        1   0 $OPTS $DRIVEON -devicebackend8 0 $BUSDEVOFF +drive8truedrive -trapdevice1 -autostartprgmode 0 -autostart-handle-tde +autostart-warp
if [ "$BUSDEVICE" = "yes" ]; then
dotest $EMU tde         0 255 $OPTS $DRIVEON -devicebackend8 0 $BUSDEVON  -drive8truedrive +trapdevice1 -autostartprgmode 0 -autostart-handle-tde -autostart-warp
dotest $EMU tde         0 255 $OPTS $DRIVEON -devicebackend8 0 $BUSDEVON  -drive8truedrive +trapdevice1 -autostartprgmode 0 -autostart-handle-tde +autostart-warp
dotest $EMU tde         0 255 $OPTS $DRIVEON -devicebackend8 0 $BUSDEVON  -drive8truedrive -trapdevice1 -autostartprgmode 0 -autostart-handle-tde -autostart-warp
dotest $EMU tde         0 255 $OPTS $DRIVEON -devicebackend8 0 $BUSDEVON  -drive8truedrive -trapdevice1 -autostartprgmode 0 -autostart-handle-tde +autostart-warp
# iecdev only
dotest $EMU none        1   0 $OPTS $DRIVEON -devicebackend8 0 $BUSDEVON  +drive8truedrive +trapdevice1 -autostartprgmode 0 -autostart-handle-tde -autostart-warp
dotest $EMU none        1   0 $OPTS $DRIVEON -devicebackend8 0 $BUSDEVON  +drive8truedrive +trapdevice1 -autostartprgmode 0 -autostart-handle-tde +autostart-warp
dotest $EMU vfs         0 255 $OPTS $DRIVEON -devicebackend8 0 $BUSDEVON  +drive8truedrive -trapdevice1 -autostartprgmode 0 -autostart-handle-tde -autostart-warp
dotest $EMU vfs         0 255 $OPTS $DRIVEON -devicebackend8 0 $BUSDEVON  +drive8truedrive -trapdevice1 -autostartprgmode 0 -autostart-handle-tde +autostart-warp
fi
echo "t64 - autostart mode 0 (virtual filesystem, backend: fsdevice) - handle TDE"
## fsdevice = filesystem
# TDEonly
dotest $EMU tde         1   0 $OPTS $DRIVEON -devicebackend8 1 $BUSDEVOFF -drive8truedrive +trapdevice1 -autostartprgmode 0 -autostart-handle-tde -autostart-warp
dotest $EMU tde         1   0 $OPTS $DRIVEON -devicebackend8 1 $BUSDEVOFF -drive8truedrive +trapdevice1 -autostartprgmode 0 -autostart-handle-tde +autostart-warp
dotest $EMU tde         0 255 $OPTS $DRIVEON -devicebackend8 1 $BUSDEVOFF -drive8truedrive -trapdevice1 -autostartprgmode 0 -autostart-handle-tde -autostart-warp
dotest $EMU tde         0 255 $OPTS $DRIVEON -devicebackend8 1 $BUSDEVOFF -drive8truedrive -trapdevice1 -autostartprgmode 0 -autostart-handle-tde +autostart-warp
# none
dotest $EMU none        1   0 $OPTS $DRIVEON -devicebackend8 1 $BUSDEVOFF +drive8truedrive +trapdevice1 -autostartprgmode 0 -autostart-handle-tde -autostart-warp
dotest $EMU none        1   0 $OPTS $DRIVEON -devicebackend8 1 $BUSDEVOFF +drive8truedrive +trapdevice1 -autostartprgmode 0 -autostart-handle-tde +autostart-warp
# vfs only
dotest $EMU none        1   0 $OPTS $DRIVEON -devicebackend8 1 $BUSDEVOFF +drive8truedrive -trapdevice1 -autostartprgmode 0 -autostart-handle-tde -autostart-warp
dotest $EMU none        1   0 $OPTS $DRIVEON -devicebackend8 1 $BUSDEVOFF +drive8truedrive -trapdevice1 -autostartprgmode 0 -autostart-handle-tde +autostart-warp
if [ "$BUSDEVICE" = "yes" ]; then
dotest $EMU tde         0 255 $OPTS $DRIVEON -devicebackend8 1 $BUSDEVON  -drive8truedrive +trapdevice1 -autostartprgmode 0 -autostart-handle-tde -autostart-warp
dotest $EMU tde         0 255 $OPTS $DRIVEON -devicebackend8 1 $BUSDEVON  -drive8truedrive +trapdevice1 -autostartprgmode 0 -autostart-handle-tde +autostart-warp
dotest $EMU tde         0 255 $OPTS $DRIVEON -devicebackend8 1 $BUSDEVON  -drive8truedrive -trapdevice1 -autostartprgmode 0 -autostart-handle-tde -autostart-warp
dotest $EMU tde         0 255 $OPTS $DRIVEON -devicebackend8 1 $BUSDEVON  -drive8truedrive -trapdevice1 -autostartprgmode 0 -autostart-handle-tde +autostart-warp
# iecdev only
dotest $EMU vfs         1   0 $OPTS $DRIVEON -devicebackend8 1 $BUSDEVON  +drive8truedrive +trapdevice1 -autostartprgmode 0 -autostart-handle-tde -autostart-warp
dotest $EMU vfs         1   0 $OPTS $DRIVEON -devicebackend8 1 $BUSDEVON  +drive8truedrive +trapdevice1 -autostartprgmode 0 -autostart-handle-tde +autostart-warp
dotest $EMU vfs         0 255 $OPTS $DRIVEON -devicebackend8 1 $BUSDEVON  +drive8truedrive -trapdevice1 -autostartprgmode 0 -autostart-handle-tde -autostart-warp
dotest $EMU vfs         0 255 $OPTS $DRIVEON -devicebackend8 1 $BUSDEVON  +drive8truedrive -trapdevice1 -autostartprgmode 0 -autostart-handle-tde +autostart-warp
fi

echo "t64 - autostart mode 1 (inject to RAM, backend: none) - handle TDE"
## fsdevice = none
# TDEonly
dotest $EMU tde         1   0 $OPTS $DRIVEON -devicebackend8 0 $BUSDEVOFF -drive8truedrive +trapdevice1 -autostartprgmode 1 -autostart-handle-tde -autostart-warp
dotest $EMU tde         1   0 $OPTS $DRIVEON -devicebackend8 0 $BUSDEVOFF -drive8truedrive +trapdevice1 -autostartprgmode 1 -autostart-handle-tde +autostart-warp
dotest $EMU tde         0 255 $OPTS $DRIVEON -devicebackend8 0 $BUSDEVOFF -drive8truedrive -trapdevice1 -autostartprgmode 1 -autostart-handle-tde -autostart-warp
dotest $EMU tde         0 255 $OPTS $DRIVEON -devicebackend8 0 $BUSDEVOFF -drive8truedrive -trapdevice1 -autostartprgmode 1 -autostart-handle-tde +autostart-warp
# none
dotest $EMU none        1   0 $OPTS $DRIVEON -devicebackend8 0 $BUSDEVOFF +drive8truedrive +trapdevice1 -autostartprgmode 1 -autostart-handle-tde -autostart-warp
dotest $EMU none        1   0 $OPTS $DRIVEON -devicebackend8 0 $BUSDEVOFF +drive8truedrive +trapdevice1 -autostartprgmode 1 -autostart-handle-tde +autostart-warp
# vfs only
dotest $EMU none        1   0 $OPTS $DRIVEON -devicebackend8 0 $BUSDEVOFF +drive8truedrive -trapdevice1 -autostartprgmode 1 -autostart-handle-tde -autostart-warp
dotest $EMU none        1   0 $OPTS $DRIVEON -devicebackend8 0 $BUSDEVOFF +drive8truedrive -trapdevice1 -autostartprgmode 1 -autostart-handle-tde +autostart-warp
if [ "$BUSDEVICE" = "yes" ]; then
dotest $EMU tde         0 255 $OPTS $DRIVEON -devicebackend8 0 $BUSDEVON  -drive8truedrive +trapdevice1 -autostartprgmode 1 -autostart-handle-tde -autostart-warp
dotest $EMU tde         0 255 $OPTS $DRIVEON -devicebackend8 0 $BUSDEVON  -drive8truedrive +trapdevice1 -autostartprgmode 1 -autostart-handle-tde +autostart-warp
dotest $EMU tde         0 255 $OPTS $DRIVEON -devicebackend8 0 $BUSDEVON  -drive8truedrive -trapdevice1 -autostartprgmode 1 -autostart-handle-tde -autostart-warp
dotest $EMU tde         0 255 $OPTS $DRIVEON -devicebackend8 0 $BUSDEVON  -drive8truedrive -trapdevice1 -autostartprgmode 1 -autostart-handle-tde +autostart-warp
# iecdev only
dotest $EMU none        1   0 $OPTS $DRIVEON -devicebackend8 0 $BUSDEVON  +drive8truedrive +trapdevice1 -autostartprgmode 1 -autostart-handle-tde -autostart-warp
dotest $EMU none        1   0 $OPTS $DRIVEON -devicebackend8 0 $BUSDEVON  +drive8truedrive +trapdevice1 -autostartprgmode 1 -autostart-handle-tde +autostart-warp
dotest $EMU vfs         0 255 $OPTS $DRIVEON -devicebackend8 0 $BUSDEVON  +drive8truedrive -trapdevice1 -autostartprgmode 1 -autostart-handle-tde -autostart-warp
dotest $EMU vfs         0 255 $OPTS $DRIVEON -devicebackend8 0 $BUSDEVON  +drive8truedrive -trapdevice1 -autostartprgmode 1 -autostart-handle-tde +autostart-warp
fi
echo "t64 - autostart mode 1 (inject to RAM, backend: fsdevice) - handle TDE"
## fsdevice = filesystem
# TDEonly
dotest $EMU tde         1   0 $OPTS $DRIVEON -devicebackend8 1 $BUSDEVOFF -drive8truedrive +trapdevice1 -autostartprgmode 1 -autostart-handle-tde -autostart-warp
dotest $EMU tde         1   0 $OPTS $DRIVEON -devicebackend8 1 $BUSDEVOFF -drive8truedrive +trapdevice1 -autostartprgmode 1 -autostart-handle-tde +autostart-warp
dotest $EMU tde         0 255 $OPTS $DRIVEON -devicebackend8 1 $BUSDEVOFF -drive8truedrive -trapdevice1 -autostartprgmode 1 -autostart-handle-tde -autostart-warp
dotest $EMU tde         0 255 $OPTS $DRIVEON -devicebackend8 1 $BUSDEVOFF -drive8truedrive -trapdevice1 -autostartprgmode 1 -autostart-handle-tde +autostart-warp
# none
dotest $EMU none        1   0 $OPTS $DRIVEON -devicebackend8 1 $BUSDEVOFF +drive8truedrive +trapdevice1 -autostartprgmode 1 -autostart-handle-tde -autostart-warp
dotest $EMU none        1   0 $OPTS $DRIVEON -devicebackend8 1 $BUSDEVOFF +drive8truedrive +trapdevice1 -autostartprgmode 1 -autostart-handle-tde +autostart-warp
# vfs only
dotest $EMU none        1   0 $OPTS $DRIVEON -devicebackend8 1 $BUSDEVOFF +drive8truedrive -trapdevice1 -autostartprgmode 1 -autostart-handle-tde -autostart-warp
dotest $EMU none        1   0 $OPTS $DRIVEON -devicebackend8 1 $BUSDEVOFF +drive8truedrive -trapdevice1 -autostartprgmode 1 -autostart-handle-tde +autostart-warp
if [ "$BUSDEVICE" = "yes" ]; then
dotest $EMU tde         0 255 $OPTS $DRIVEON -devicebackend8 1 $BUSDEVON  -drive8truedrive +trapdevice1 -autostartprgmode 1 -autostart-handle-tde -autostart-warp
dotest $EMU tde         0 255 $OPTS $DRIVEON -devicebackend8 1 $BUSDEVON  -drive8truedrive +trapdevice1 -autostartprgmode 1 -autostart-handle-tde +autostart-warp
dotest $EMU tde         0 255 $OPTS $DRIVEON -devicebackend8 1 $BUSDEVON  -drive8truedrive -trapdevice1 -autostartprgmode 1 -autostart-handle-tde -autostart-warp
dotest $EMU tde         0 255 $OPTS $DRIVEON -devicebackend8 1 $BUSDEVON  -drive8truedrive -trapdevice1 -autostartprgmode 1 -autostart-handle-tde +autostart-warp
# iecdev only
dotest $EMU vfs         1   0 $OPTS $DRIVEON -devicebackend8 1 $BUSDEVON  +drive8truedrive +trapdevice1 -autostartprgmode 1 -autostart-handle-tde -autostart-warp
dotest $EMU vfs         1   0 $OPTS $DRIVEON -devicebackend8 1 $BUSDEVON  +drive8truedrive +trapdevice1 -autostartprgmode 1 -autostart-handle-tde +autostart-warp
dotest $EMU vfs         0 255 $OPTS $DRIVEON -devicebackend8 1 $BUSDEVON  +drive8truedrive -trapdevice1 -autostartprgmode 1 -autostart-handle-tde -autostart-warp
dotest $EMU vfs         0 255 $OPTS $DRIVEON -devicebackend8 1 $BUSDEVON  +drive8truedrive -trapdevice1 -autostartprgmode 1 -autostart-handle-tde +autostart-warp
fi

# with drivetype = none

echo "t64 - autostart mode 0 (virtual filesystem, backend: none) - do not handle TDE"
## fsdevice = none
# TDEonly
dotest $EMU none        1   0 $OPTS $DRIVEOFF -devicebackend8 0 $BUSDEVOFF -drive8truedrive +trapdevice1 -autostartprgmode 0 +autostart-handle-tde -autostart-warp
dotest $EMU none        1   0 $OPTS $DRIVEOFF -devicebackend8 0 $BUSDEVOFF -drive8truedrive +trapdevice1 -autostartprgmode 0 +autostart-handle-tde +autostart-warp
dotest $EMU tde         0 255 $OPTS $DRIVEOFF -devicebackend8 0 $BUSDEVOFF -drive8truedrive -trapdevice1 -autostartprgmode 0 +autostart-handle-tde -autostart-warp
dotest $EMU tde         0 255 $OPTS $DRIVEOFF -devicebackend8 0 $BUSDEVOFF -drive8truedrive -trapdevice1 -autostartprgmode 0 +autostart-handle-tde +autostart-warp
# none
dotest $EMU none        1   0 $OPTS $DRIVEOFF -devicebackend8 0 $BUSDEVOFF +drive8truedrive +trapdevice1 -autostartprgmode 0 +autostart-handle-tde -autostart-warp
dotest $EMU none        1   0 $OPTS $DRIVEOFF -devicebackend8 0 $BUSDEVOFF +drive8truedrive +trapdevice1 -autostartprgmode 0 +autostart-handle-tde +autostart-warp
# vfs only
dotest $EMU none        1   0 $OPTS $DRIVEOFF -devicebackend8 0 $BUSDEVOFF +drive8truedrive -trapdevice1 -autostartprgmode 0 +autostart-handle-tde -autostart-warp
dotest $EMU none        1   0 $OPTS $DRIVEOFF -devicebackend8 0 $BUSDEVOFF +drive8truedrive -trapdevice1 -autostartprgmode 0 +autostart-handle-tde +autostart-warp
if [ "$BUSDEVICE" = "yes" ]; then
dotest $EMU tde         0 255 $OPTS $DRIVEOFF -devicebackend8 0 $BUSDEVON  -drive8truedrive +trapdevice1 -autostartprgmode 0 +autostart-handle-tde -autostart-warp
dotest $EMU tde         0 255 $OPTS $DRIVEOFF -devicebackend8 0 $BUSDEVON  -drive8truedrive +trapdevice1 -autostartprgmode 0 +autostart-handle-tde +autostart-warp
dotest $EMU tde         0 255 $OPTS $DRIVEOFF -devicebackend8 0 $BUSDEVON  -drive8truedrive -trapdevice1 -autostartprgmode 0 +autostart-handle-tde -autostart-warp
dotest $EMU tde         0 255 $OPTS $DRIVEOFF -devicebackend8 0 $BUSDEVON  -drive8truedrive -trapdevice1 -autostartprgmode 0 +autostart-handle-tde +autostart-warp
# iecdev only
dotest $EMU none        1   0 $OPTS $DRIVEOFF -devicebackend8 0 $BUSDEVON  +drive8truedrive +trapdevice1 -autostartprgmode 0 +autostart-handle-tde -autostart-warp
dotest $EMU none        1   0 $OPTS $DRIVEOFF -devicebackend8 0 $BUSDEVON  +drive8truedrive +trapdevice1 -autostartprgmode 0 +autostart-handle-tde +autostart-warp
dotest $EMU vfs         0 255 $OPTS $DRIVEOFF -devicebackend8 0 $BUSDEVON  +drive8truedrive -trapdevice1 -autostartprgmode 0 +autostart-handle-tde -autostart-warp
dotest $EMU vfs         0 255 $OPTS $DRIVEOFF -devicebackend8 0 $BUSDEVON  +drive8truedrive -trapdevice1 -autostartprgmode 0 +autostart-handle-tde +autostart-warp
fi
echo "t64 - autostart mode 0 (virtual filesystem, backend: fsdevice) - do not handle TDE"
## fsdevice = filesystem
# TDEonly
dotest $EMU none        1   0 $OPTS $DRIVEOFF -devicebackend8 1 $BUSDEVOFF -drive8truedrive +trapdevice1 -autostartprgmode 0 +autostart-handle-tde -autostart-warp
dotest $EMU none        1   0 $OPTS $DRIVEOFF -devicebackend8 1 $BUSDEVOFF -drive8truedrive +trapdevice1 -autostartprgmode 0 +autostart-handle-tde +autostart-warp
dotest $EMU tde         0 255 $OPTS $DRIVEOFF -devicebackend8 1 $BUSDEVOFF -drive8truedrive -trapdevice1 -autostartprgmode 0 +autostart-handle-tde -autostart-warp
dotest $EMU tde         0 255 $OPTS $DRIVEOFF -devicebackend8 1 $BUSDEVOFF -drive8truedrive -trapdevice1 -autostartprgmode 0 +autostart-handle-tde +autostart-warp
# none
dotest $EMU none        1   0 $OPTS $DRIVEOFF -devicebackend8 1 $BUSDEVOFF +drive8truedrive +trapdevice1 -autostartprgmode 0 +autostart-handle-tde -autostart-warp
dotest $EMU none        1   0 $OPTS $DRIVEOFF -devicebackend8 1 $BUSDEVOFF +drive8truedrive +trapdevice1 -autostartprgmode 0 +autostart-handle-tde +autostart-warp
# vfs only
dotest $EMU none        1   0 $OPTS $DRIVEOFF -devicebackend8 1 $BUSDEVOFF +drive8truedrive -trapdevice1 -autostartprgmode 0 +autostart-handle-tde -autostart-warp
dotest $EMU none        1   0 $OPTS $DRIVEOFF -devicebackend8 1 $BUSDEVOFF +drive8truedrive -trapdevice1 -autostartprgmode 0 +autostart-handle-tde +autostart-warp
if [ "$BUSDEVICE" = "yes" ]; then
dotest $EMU tde         0 255 $OPTS $DRIVEOFF -devicebackend8 1 $BUSDEVON  -drive8truedrive +trapdevice1 -autostartprgmode 0 +autostart-handle-tde -autostart-warp
dotest $EMU tde         0 255 $OPTS $DRIVEOFF -devicebackend8 1 $BUSDEVON  -drive8truedrive +trapdevice1 -autostartprgmode 0 +autostart-handle-tde +autostart-warp
dotest $EMU tde         0 255 $OPTS $DRIVEOFF -devicebackend8 1 $BUSDEVON  -drive8truedrive -trapdevice1 -autostartprgmode 0 +autostart-handle-tde -autostart-warp
dotest $EMU tde         0 255 $OPTS $DRIVEOFF -devicebackend8 1 $BUSDEVON  -drive8truedrive -trapdevice1 -autostartprgmode 0 +autostart-handle-tde +autostart-warp
# iecdev only
dotest $EMU vfs         1   0 $OPTS $DRIVEOFF -devicebackend8 1 $BUSDEVON  +drive8truedrive +trapdevice1 -autostartprgmode 0 +autostart-handle-tde -autostart-warp
dotest $EMU vfs         1   0 $OPTS $DRIVEOFF -devicebackend8 1 $BUSDEVON  +drive8truedrive +trapdevice1 -autostartprgmode 0 +autostart-handle-tde +autostart-warp
dotest $EMU vfs         0 255 $OPTS $DRIVEOFF -devicebackend8 1 $BUSDEVON  +drive8truedrive -trapdevice1 -autostartprgmode 0 +autostart-handle-tde -autostart-warp
dotest $EMU vfs         0 255 $OPTS $DRIVEOFF -devicebackend8 1 $BUSDEVON  +drive8truedrive -trapdevice1 -autostartprgmode 0 +autostart-handle-tde +autostart-warp
fi

echo "t64 - autostart mode 1 (inject to RAM, backend: none) - do not handle TDE"
## fsdevice = none
# TDEonly
dotest $EMU none        1   0 $OPTS $DRIVEOFF -devicebackend8 0 $BUSDEVOFF -drive8truedrive +trapdevice1 -autostartprgmode 1 +autostart-handle-tde -autostart-warp
dotest $EMU none        1   0 $OPTS $DRIVEOFF -devicebackend8 0 $BUSDEVOFF -drive8truedrive +trapdevice1 -autostartprgmode 1 +autostart-handle-tde +autostart-warp
dotest $EMU tde         0 255 $OPTS $DRIVEOFF -devicebackend8 0 $BUSDEVOFF -drive8truedrive -trapdevice1 -autostartprgmode 1 +autostart-handle-tde -autostart-warp
dotest $EMU tde         0 255 $OPTS $DRIVEOFF -devicebackend8 0 $BUSDEVOFF -drive8truedrive -trapdevice1 -autostartprgmode 1 +autostart-handle-tde +autostart-warp
# none
dotest $EMU none        1   0 $OPTS $DRIVEOFF -devicebackend8 0 $BUSDEVOFF +drive8truedrive +trapdevice1 -autostartprgmode 1 +autostart-handle-tde -autostart-warp
dotest $EMU none        1   0 $OPTS $DRIVEOFF -devicebackend8 0 $BUSDEVOFF +drive8truedrive +trapdevice1 -autostartprgmode 1 +autostart-handle-tde +autostart-warp
# vfs only
dotest $EMU none        1   0 $OPTS $DRIVEOFF -devicebackend8 0 $BUSDEVOFF +drive8truedrive -trapdevice1 -autostartprgmode 1 +autostart-handle-tde -autostart-warp
dotest $EMU none        1   0 $OPTS $DRIVEOFF -devicebackend8 0 $BUSDEVOFF +drive8truedrive -trapdevice1 -autostartprgmode 1 +autostart-handle-tde +autostart-warp
if [ "$BUSDEVICE" = "yes" ]; then
dotest $EMU tde         0 255 $OPTS $DRIVEOFF -devicebackend8 0 $BUSDEVON  -drive8truedrive +trapdevice1 -autostartprgmode 1 +autostart-handle-tde -autostart-warp
dotest $EMU tde         0 255 $OPTS $DRIVEOFF -devicebackend8 0 $BUSDEVON  -drive8truedrive +trapdevice1 -autostartprgmode 1 +autostart-handle-tde +autostart-warp
dotest $EMU tde         0 255 $OPTS $DRIVEOFF -devicebackend8 0 $BUSDEVON  -drive8truedrive -trapdevice1 -autostartprgmode 1 +autostart-handle-tde -autostart-warp
dotest $EMU tde         0 255 $OPTS $DRIVEOFF -devicebackend8 0 $BUSDEVON  -drive8truedrive -trapdevice1 -autostartprgmode 1 +autostart-handle-tde +autostart-warp
# iecdev only
dotest $EMU none        1   0 $OPTS $DRIVEOFF -devicebackend8 0 $BUSDEVON  +drive8truedrive +trapdevice1 -autostartprgmode 1 +autostart-handle-tde -autostart-warp
dotest $EMU none        1   0 $OPTS $DRIVEOFF -devicebackend8 0 $BUSDEVON  +drive8truedrive +trapdevice1 -autostartprgmode 1 +autostart-handle-tde +autostart-warp
dotest $EMU vfs         0 255 $OPTS $DRIVEOFF -devicebackend8 0 $BUSDEVON  +drive8truedrive -trapdevice1 -autostartprgmode 1 +autostart-handle-tde -autostart-warp
dotest $EMU vfs         0 255 $OPTS $DRIVEOFF -devicebackend8 0 $BUSDEVON  +drive8truedrive -trapdevice1 -autostartprgmode 1 +autostart-handle-tde +autostart-warp
fi
echo "t64 - autostart mode 1 (inject to RAM, backend: fsdevice) - do not handle TDE"
## fsdevice = filesystem
# TDEonly
dotest $EMU none        1   0 $OPTS $DRIVEOFF -devicebackend8 1 $BUSDEVOFF -drive8truedrive +trapdevice1 -autostartprgmode 1 +autostart-handle-tde -autostart-warp
dotest $EMU none        1   0 $OPTS $DRIVEOFF -devicebackend8 1 $BUSDEVOFF -drive8truedrive +trapdevice1 -autostartprgmode 1 +autostart-handle-tde +autostart-warp
dotest $EMU tde         0 255 $OPTS $DRIVEOFF -devicebackend8 1 $BUSDEVOFF -drive8truedrive -trapdevice1 -autostartprgmode 1 +autostart-handle-tde -autostart-warp
dotest $EMU tde         0 255 $OPTS $DRIVEOFF -devicebackend8 1 $BUSDEVOFF -drive8truedrive -trapdevice1 -autostartprgmode 1 +autostart-handle-tde +autostart-warp
# none
dotest $EMU none        1   0 $OPTS $DRIVEOFF -devicebackend8 1 $BUSDEVOFF +drive8truedrive +trapdevice1 -autostartprgmode 1 +autostart-handle-tde -autostart-warp
dotest $EMU none        1   0 $OPTS $DRIVEOFF -devicebackend8 1 $BUSDEVOFF +drive8truedrive +trapdevice1 -autostartprgmode 1 +autostart-handle-tde +autostart-warp
# vfs only
dotest $EMU none        1   0 $OPTS $DRIVEOFF -devicebackend8 1 $BUSDEVOFF +drive8truedrive -trapdevice1 -autostartprgmode 1 +autostart-handle-tde -autostart-warp
dotest $EMU none        1   0 $OPTS $DRIVEOFF -devicebackend8 1 $BUSDEVOFF +drive8truedrive -trapdevice1 -autostartprgmode 1 +autostart-handle-tde +autostart-warp
if [ "$BUSDEVICE" = "yes" ]; then
dotest $EMU tde         0 255 $OPTS $DRIVEOFF -devicebackend8 1 $BUSDEVON  -drive8truedrive +trapdevice1 -autostartprgmode 1 +autostart-handle-tde -autostart-warp
dotest $EMU tde         0 255 $OPTS $DRIVEOFF -devicebackend8 1 $BUSDEVON  -drive8truedrive +trapdevice1 -autostartprgmode 1 +autostart-handle-tde +autostart-warp
dotest $EMU tde         0 255 $OPTS $DRIVEOFF -devicebackend8 1 $BUSDEVON  -drive8truedrive -trapdevice1 -autostartprgmode 1 +autostart-handle-tde -autostart-warp
dotest $EMU tde         0 255 $OPTS $DRIVEOFF -devicebackend8 1 $BUSDEVON  -drive8truedrive -trapdevice1 -autostartprgmode 1 +autostart-handle-tde +autostart-warp
# iecdev only
dotest $EMU vfs         1   0 $OPTS $DRIVEOFF -devicebackend8 1 $BUSDEVON  +drive8truedrive +trapdevice1 -autostartprgmode 1 +autostart-handle-tde -autostart-warp
dotest $EMU vfs         1   0 $OPTS $DRIVEOFF -devicebackend8 1 $BUSDEVON  +drive8truedrive +trapdevice1 -autostartprgmode 1 +autostart-handle-tde +autostart-warp
dotest $EMU vfs         0 255 $OPTS $DRIVEOFF -devicebackend8 1 $BUSDEVON  +drive8truedrive -trapdevice1 -autostartprgmode 1 +autostart-handle-tde -autostart-warp
dotest $EMU vfs         0 255 $OPTS $DRIVEOFF -devicebackend8 1 $BUSDEVON  +drive8truedrive -trapdevice1 -autostartprgmode 1 +autostart-handle-tde +autostart-warp
fi

echo "t64 - autostart mode 0 (virtual filesystem, backend: none) - handle TDE"
## fsdevice = none
# TDEonly
dotest $EMU none        1   0 $OPTS $DRIVEOFF -devicebackend8 0 $BUSDEVOFF -drive8truedrive +trapdevice1 -autostartprgmode 0 -autostart-handle-tde -autostart-warp
dotest $EMU none        1   0 $OPTS $DRIVEOFF -devicebackend8 0 $BUSDEVOFF -drive8truedrive +trapdevice1 -autostartprgmode 0 -autostart-handle-tde +autostart-warp
dotest $EMU tde         0 255 $OPTS $DRIVEOFF -devicebackend8 0 $BUSDEVOFF -drive8truedrive -trapdevice1 -autostartprgmode 0 -autostart-handle-tde -autostart-warp
dotest $EMU tde         0 255 $OPTS $DRIVEOFF -devicebackend8 0 $BUSDEVOFF -drive8truedrive -trapdevice1 -autostartprgmode 0 -autostart-handle-tde +autostart-warp
# none
dotest $EMU none        1   0 $OPTS $DRIVEOFF -devicebackend8 0 $BUSDEVOFF +drive8truedrive +trapdevice1 -autostartprgmode 0 -autostart-handle-tde -autostart-warp
dotest $EMU none        1   0 $OPTS $DRIVEOFF -devicebackend8 0 $BUSDEVOFF +drive8truedrive +trapdevice1 -autostartprgmode 0 -autostart-handle-tde +autostart-warp
# vfs only
dotest $EMU none        1   0 $OPTS $DRIVEOFF -devicebackend8 0 $BUSDEVOFF +drive8truedrive -trapdevice1 -autostartprgmode 0 -autostart-handle-tde -autostart-warp
dotest $EMU none        1   0 $OPTS $DRIVEOFF -devicebackend8 0 $BUSDEVOFF +drive8truedrive -trapdevice1 -autostartprgmode 0 -autostart-handle-tde +autostart-warp
if [ "$BUSDEVICE" = "yes" ]; then
dotest $EMU tde         0 255 $OPTS $DRIVEOFF -devicebackend8 0 $BUSDEVON  -drive8truedrive +trapdevice1 -autostartprgmode 0 -autostart-handle-tde -autostart-warp
dotest $EMU tde         0 255 $OPTS $DRIVEOFF -devicebackend8 0 $BUSDEVON  -drive8truedrive +trapdevice1 -autostartprgmode 0 -autostart-handle-tde +autostart-warp
dotest $EMU tde         0 255 $OPTS $DRIVEOFF -devicebackend8 0 $BUSDEVON  -drive8truedrive -trapdevice1 -autostartprgmode 0 -autostart-handle-tde -autostart-warp
dotest $EMU tde         0 255 $OPTS $DRIVEOFF -devicebackend8 0 $BUSDEVON  -drive8truedrive -trapdevice1 -autostartprgmode 0 -autostart-handle-tde +autostart-warp
# iecdev only
dotest $EMU none        1   0 $OPTS $DRIVEOFF -devicebackend8 0 $BUSDEVON  +drive8truedrive +trapdevice1 -autostartprgmode 0 -autostart-handle-tde -autostart-warp
dotest $EMU none        1   0 $OPTS $DRIVEOFF -devicebackend8 0 $BUSDEVON  +drive8truedrive +trapdevice1 -autostartprgmode 0 -autostart-handle-tde +autostart-warp
dotest $EMU vfs         0 255 $OPTS $DRIVEOFF -devicebackend8 0 $BUSDEVON  +drive8truedrive -trapdevice1 -autostartprgmode 0 -autostart-handle-tde -autostart-warp
dotest $EMU vfs         0 255 $OPTS $DRIVEOFF -devicebackend8 0 $BUSDEVON  +drive8truedrive -trapdevice1 -autostartprgmode 0 -autostart-handle-tde +autostart-warp
fi
echo "t64 - autostart mode 0 (virtual filesystem, backend: fsdevice) - handle TDE"
## fsdevice = filesystem
# TDEonly
dotest $EMU none        1   0 $OPTS $DRIVEOFF -devicebackend8 1 $BUSDEVOFF -drive8truedrive +trapdevice1 -autostartprgmode 0 -autostart-handle-tde -autostart-warp
dotest $EMU none        1   0 $OPTS $DRIVEOFF -devicebackend8 1 $BUSDEVOFF -drive8truedrive +trapdevice1 -autostartprgmode 0 -autostart-handle-tde +autostart-warp
dotest $EMU tde         0 255 $OPTS $DRIVEOFF -devicebackend8 1 $BUSDEVOFF -drive8truedrive -trapdevice1 -autostartprgmode 0 -autostart-handle-tde -autostart-warp
dotest $EMU tde         0 255 $OPTS $DRIVEOFF -devicebackend8 1 $BUSDEVOFF -drive8truedrive -trapdevice1 -autostartprgmode 0 -autostart-handle-tde +autostart-warp
# none
dotest $EMU none        1   0 $OPTS $DRIVEOFF -devicebackend8 1 $BUSDEVOFF +drive8truedrive +trapdevice1 -autostartprgmode 0 -autostart-handle-tde -autostart-warp
dotest $EMU none        1   0 $OPTS $DRIVEOFF -devicebackend8 1 $BUSDEVOFF +drive8truedrive +trapdevice1 -autostartprgmode 0 -autostart-handle-tde +autostart-warp
# vfs only
dotest $EMU none        1   0 $OPTS $DRIVEOFF -devicebackend8 1 $BUSDEVOFF +drive8truedrive -trapdevice1 -autostartprgmode 0 -autostart-handle-tde -autostart-warp
dotest $EMU none        1   0 $OPTS $DRIVEOFF -devicebackend8 1 $BUSDEVOFF +drive8truedrive -trapdevice1 -autostartprgmode 0 -autostart-handle-tde +autostart-warp
if [ "$BUSDEVICE" = "yes" ]; then
dotest $EMU tde         0 255 $OPTS $DRIVEOFF -devicebackend8 1 $BUSDEVON  -drive8truedrive +trapdevice1 -autostartprgmode 0 -autostart-handle-tde -autostart-warp
dotest $EMU tde         0 255 $OPTS $DRIVEOFF -devicebackend8 1 $BUSDEVON  -drive8truedrive +trapdevice1 -autostartprgmode 0 -autostart-handle-tde +autostart-warp
dotest $EMU tde         0 255 $OPTS $DRIVEOFF -devicebackend8 1 $BUSDEVON  -drive8truedrive -trapdevice1 -autostartprgmode 0 -autostart-handle-tde -autostart-warp
dotest $EMU tde         0 255 $OPTS $DRIVEOFF -devicebackend8 1 $BUSDEVON  -drive8truedrive -trapdevice1 -autostartprgmode 0 -autostart-handle-tde +autostart-warp
# iecdev only
dotest $EMU vfs         1   0 $OPTS $DRIVEOFF -devicebackend8 1 $BUSDEVON  +drive8truedrive +trapdevice1 -autostartprgmode 0 -autostart-handle-tde -autostart-warp
dotest $EMU vfs         1   0 $OPTS $DRIVEOFF -devicebackend8 1 $BUSDEVON  +drive8truedrive +trapdevice1 -autostartprgmode 0 -autostart-handle-tde +autostart-warp
dotest $EMU vfs         0 255 $OPTS $DRIVEOFF -devicebackend8 1 $BUSDEVON  +drive8truedrive -trapdevice1 -autostartprgmode 0 -autostart-handle-tde -autostart-warp
dotest $EMU vfs         0 255 $OPTS $DRIVEOFF -devicebackend8 1 $BUSDEVON  +drive8truedrive -trapdevice1 -autostartprgmode 0 -autostart-handle-tde +autostart-warp
fi

echo "t64 - autostart mode 1 (inject to RAM, backend: none) - handle TDE"
## fsdevice = none
# TDEonly
dotest $EMU none        1   0 $OPTS $DRIVEOFF -devicebackend8 0 $BUSDEVOFF -drive8truedrive +trapdevice1 -autostartprgmode 1 -autostart-handle-tde -autostart-warp
dotest $EMU none        1   0 $OPTS $DRIVEOFF -devicebackend8 0 $BUSDEVOFF -drive8truedrive +trapdevice1 -autostartprgmode 1 -autostart-handle-tde +autostart-warp
dotest $EMU tde         0 255 $OPTS $DRIVEOFF -devicebackend8 0 $BUSDEVOFF -drive8truedrive -trapdevice1 -autostartprgmode 1 -autostart-handle-tde -autostart-warp
dotest $EMU tde         0 255 $OPTS $DRIVEOFF -devicebackend8 0 $BUSDEVOFF -drive8truedrive -trapdevice1 -autostartprgmode 1 -autostart-handle-tde +autostart-warp
# none
dotest $EMU none        1   0 $OPTS $DRIVEOFF -devicebackend8 0 $BUSDEVOFF +drive8truedrive +trapdevice1 -autostartprgmode 1 -autostart-handle-tde -autostart-warp
dotest $EMU none        1   0 $OPTS $DRIVEOFF -devicebackend8 0 $BUSDEVOFF +drive8truedrive +trapdevice1 -autostartprgmode 1 -autostart-handle-tde +autostart-warp
# vfs only
dotest $EMU none        1   0 $OPTS $DRIVEOFF -devicebackend8 0 $BUSDEVOFF +drive8truedrive -trapdevice1 -autostartprgmode 1 -autostart-handle-tde -autostart-warp
dotest $EMU none        1   0 $OPTS $DRIVEOFF -devicebackend8 0 $BUSDEVOFF +drive8truedrive -trapdevice1 -autostartprgmode 1 -autostart-handle-tde +autostart-warp
if [ "$BUSDEVICE" = "yes" ]; then
dotest $EMU tde         0 255 $OPTS $DRIVEOFF -devicebackend8 0 $BUSDEVON  -drive8truedrive +trapdevice1 -autostartprgmode 1 -autostart-handle-tde -autostart-warp
dotest $EMU tde         0 255 $OPTS $DRIVEOFF -devicebackend8 0 $BUSDEVON  -drive8truedrive +trapdevice1 -autostartprgmode 1 -autostart-handle-tde +autostart-warp
dotest $EMU tde         0 255 $OPTS $DRIVEOFF -devicebackend8 0 $BUSDEVON  -drive8truedrive -trapdevice1 -autostartprgmode 1 -autostart-handle-tde -autostart-warp
dotest $EMU tde         0 255 $OPTS $DRIVEOFF -devicebackend8 0 $BUSDEVON  -drive8truedrive -trapdevice1 -autostartprgmode 1 -autostart-handle-tde +autostart-warp
# iecdev only
dotest $EMU none        1   0 $OPTS $DRIVEOFF -devicebackend8 0 $BUSDEVON  +drive8truedrive +trapdevice1 -autostartprgmode 1 -autostart-handle-tde -autostart-warp
dotest $EMU none        1   0 $OPTS $DRIVEOFF -devicebackend8 0 $BUSDEVON  +drive8truedrive +trapdevice1 -autostartprgmode 1 -autostart-handle-tde +autostart-warp
dotest $EMU vfs         0 255 $OPTS $DRIVEOFF -devicebackend8 0 $BUSDEVON  +drive8truedrive -trapdevice1 -autostartprgmode 1 -autostart-handle-tde -autostart-warp
dotest $EMU vfs         0 255 $OPTS $DRIVEOFF -devicebackend8 0 $BUSDEVON  +drive8truedrive -trapdevice1 -autostartprgmode 1 -autostart-handle-tde +autostart-warp
fi
echo "t64 - autostart mode 1 (inject to RAM, backend: fsdevice) - handle TDE"
## fsdevice = filesystem
# TDEonly
dotest $EMU none        1   0 $OPTS $DRIVEOFF -devicebackend8 1 $BUSDEVOFF -drive8truedrive +trapdevice1 -autostartprgmode 1 -autostart-handle-tde -autostart-warp
dotest $EMU none        1   0 $OPTS $DRIVEOFF -devicebackend8 1 $BUSDEVOFF -drive8truedrive +trapdevice1 -autostartprgmode 1 -autostart-handle-tde +autostart-warp
dotest $EMU tde         0 255 $OPTS $DRIVEOFF -devicebackend8 1 $BUSDEVOFF -drive8truedrive -trapdevice1 -autostartprgmode 1 -autostart-handle-tde -autostart-warp
dotest $EMU tde         0 255 $OPTS $DRIVEOFF -devicebackend8 1 $BUSDEVOFF -drive8truedrive -trapdevice1 -autostartprgmode 1 -autostart-handle-tde +autostart-warp
# none
dotest $EMU none        1   0 $OPTS $DRIVEOFF -devicebackend8 1 $BUSDEVOFF +drive8truedrive +trapdevice1 -autostartprgmode 1 -autostart-handle-tde -autostart-warp
dotest $EMU none        1   0 $OPTS $DRIVEOFF -devicebackend8 1 $BUSDEVOFF +drive8truedrive +trapdevice1 -autostartprgmode 1 -autostart-handle-tde +autostart-warp
# vfs only
dotest $EMU none        1   0 $OPTS $DRIVEOFF -devicebackend8 1 $BUSDEVOFF +drive8truedrive -trapdevice1 -autostartprgmode 1 -autostart-handle-tde -autostart-warp
dotest $EMU none        1   0 $OPTS $DRIVEOFF -devicebackend8 1 $BUSDEVOFF +drive8truedrive -trapdevice1 -autostartprgmode 1 -autostart-handle-tde +autostart-warp
if [ "$BUSDEVICE" = "yes" ]; then
dotest $EMU tde         0 255 $OPTS $DRIVEOFF -devicebackend8 1 $BUSDEVON  -drive8truedrive +trapdevice1 -autostartprgmode 1 -autostart-handle-tde -autostart-warp
dotest $EMU tde         0 255 $OPTS $DRIVEOFF -devicebackend8 1 $BUSDEVON  -drive8truedrive +trapdevice1 -autostartprgmode 1 -autostart-handle-tde +autostart-warp
dotest $EMU tde         0 255 $OPTS $DRIVEOFF -devicebackend8 1 $BUSDEVON  -drive8truedrive -trapdevice1 -autostartprgmode 1 -autostart-handle-tde -autostart-warp
dotest $EMU tde         0 255 $OPTS $DRIVEOFF -devicebackend8 1 $BUSDEVON  -drive8truedrive -trapdevice1 -autostartprgmode 1 -autostart-handle-tde +autostart-warp
# iecdev only
dotest $EMU vfs         1   0 $OPTS $DRIVEOFF -devicebackend8 1 $BUSDEVON  +drive8truedrive +trapdevice1 -autostartprgmode 1 -autostart-handle-tde -autostart-warp
dotest $EMU vfs         1   0 $OPTS $DRIVEOFF -devicebackend8 1 $BUSDEVON  +drive8truedrive +trapdevice1 -autostartprgmode 1 -autostart-handle-tde +autostart-warp
dotest $EMU vfs         1   0 $OPTS $DRIVEOFF -devicebackend8 1 $BUSDEVON  +drive8truedrive -trapdevice1 -autostartprgmode 1 -autostart-handle-tde -autostart-warp
dotest $EMU vfs         1   0 $OPTS $DRIVEOFF -devicebackend8 1 $BUSDEVON  +drive8truedrive -trapdevice1 -autostartprgmode 1 -autostart-handle-tde +autostart-warp
fi


echo "---"
}

function testc64_longnames
{
echo "long names with virtual fs:"
PROGEXT=prg
PROGPRE=./autostart-c64-567
dotest $EMU vfs         1   0 $OPTS -fslongnames -devicebackend8 1 $BUSDEVOFF +drive8truedrive $TRAPDEVON -autostartprgmode 0 +autostart-handle-tde -autostart-warp
PROGPRE=./autostart-c64-5678
dotest $EMU vfs         1   0 $OPTS -fslongnames -devicebackend8 1 $BUSDEVOFF +drive8truedrive $TRAPDEVON -autostartprgmode 0 +autostart-handle-tde -autostart-warp
PROGPRE=./autostart-c64-5678901
dotest $EMU vfs         1   0 $OPTS -fslongnames -devicebackend8 1 $BUSDEVOFF +drive8truedrive $TRAPDEVON -autostartprgmode 0 +autostart-handle-tde -autostart-warp
PROGPRE=./autostart-c64-56789012
dotest $EMU vfs         1   0 $OPTS -fslongnames -devicebackend8 1 $BUSDEVOFF +drive8truedrive $TRAPDEVON -autostartprgmode 0 +autostart-handle-tde -autostart-warp
PROGPRE=./autostart-c64-56789012345678901234567890123456789012345678901
dotest $EMU vfs         1   0 $OPTS -fslongnames -devicebackend8 1 $BUSDEVOFF +drive8truedrive $TRAPDEVON -autostartprgmode 0 +autostart-handle-tde -autostart-warp
echo "---"
}

############################################################################

# x64
function testx64
{
BUSDEVICE=yes
BUSDEVON=-busdevice8
BUSDEVOFF=+busdevice8
TRAPDEVICE=yes
TRAPDEVON=-trapdevice8
TRAPDEVOFF=+trapdevice8
LIMITCYCLES=30000000
EMU=x64
OPTS=
DRIVEON="-drive8type 1541"
DRIVEOFF="-drive8type 0"
testc64_longnames
PROGPRE=./autostart-c64
PROGEXT=prg
alltests_prg
PROGPRE=./autostart-c64
PROGEXT=d64
alltests_disk
PROGPRE=./autostart-c64
PROGEXT=t64
alltests_t64
}

# x64sc
function testx64sc
{
BUSDEVICE=yes
BUSDEVON=-busdevice8
BUSDEVOFF=+busdevice8
TRAPDEVICE=yes
TRAPDEVON=-trapdevice8
TRAPDEVOFF=+trapdevice8
LIMITCYCLES=30000000
EMU=x64sc
OPTS=
DRIVEON="-drive8type 1541"
DRIVEOFF="-drive8type 0"
testc64_longnames
PROGPRE=./autostart-c64
PROGEXT=prg
alltests_prg
PROGPRE=./autostart-c64
PROGEXT=d64
alltests_disk
PROGPRE=./autostart-c64
PROGEXT=t64
alltests_t64
}

# x128
function testx128
{
BUSDEVICE=yes
BUSDEVON=-busdevice8
BUSDEVOFF=+busdevice8
TRAPDEVICE=yes
TRAPDEVON=-trapdevice8
TRAPDEVOFF=+trapdevice8
LIMITCYCLES=40000000
EMU=x128
#DRIVEON="-drive8type 1541"
DRIVEON="-drive8type 1571"
DRIVEOFF="-drive8type 0"

# x128 (VIC)
EMU=x128
OPTS=-40col
#testc64_longnames
PROGPRE=./autostart-c128
PROGEXT=prg
alltests_prg
PROGPRE=./autostart-c128
PROGEXT=d64
alltests_disk
PROGPRE=./autostart-c128
PROGEXT=t64
alltests_t64

# x128 (VDC)
EMU=x128
OPTS=-80col
#testc64_longnames
PROGPRE=./autostart-c128
PROGEXT=prg
alltests_prg
PROGPRE=./autostart-c128
PROGEXT=d64
alltests_disk
PROGPRE=./autostart-c128
PROGEXT=t64
alltests_t64

# c128 (c64 mode)
OPTS=-go64
#testc64_longnames
PROGPRE=./autostart-c64
PROGEXT=prg
alltests_prg
PROGPRE=./autostart-c64
PROGEXT=d64
alltests_disk
PROGPRE=./autostart-c64
PROGEXT=t64
alltests_t64
}

# vic20
function testxvic
{
# CAUTION: "bus device" is not implemented in xvic yet
BUSDEVICE=no
BUSDEVON=
BUSDEVOFF=
TRAPDEVICE=yes
TRAPDEVON=-trapdevice8
TRAPDEVOFF=+trapdevice8
LIMITCYCLES=30000000
EMU=xvic
OPTS="-memory 8k"
DRIVEON="-drive8type 1541"
DRIVEOFF="-drive8type 0"
#testc64_longnames
PROGPRE=./autostart-vic20
PROGEXT=prg
alltests_prg
PROGPRE=./autostart-vic20
PROGEXT=d64
alltests_disk
PROGPRE=./autostart-vic20
PROGEXT=t64
alltests_t64
}

# x64dtv
function testx64dtv
{
BUSDEVICE=yes
BUSDEVON=-busdevice8
BUSDEVOFF=+busdevice8
TRAPDEVICE=yes
TRAPDEVON=-trapdevice8
TRAPDEVOFF=+trapdevice8
LIMITCYCLES=50000000
EMU=x64dtv
DRIVEON="-drive8type 1541"
DRIVEOFF="-drive8type 0"
OPTS=
PROGPRE=./autostart-c64
PROGEXT=prg
alltests_prg
PROGPRE=./autostart-c64
PROGEXT=d64
alltests_disk
}

# xplus4
function testxplus4
{
BUSDEVICE=yes
BUSDEVON=-busdevice8
BUSDEVOFF=+busdevice8
TRAPDEVICE=yes
TRAPDEVON=-trapdevice8
TRAPDEVOFF=+trapdevice8
LIMITCYCLES=30000000
EMU=xplus4
#DRIVEON="-drive8type 1541"
DRIVEON="-drive8type 1551"
DRIVEOFF="-drive8type 0"
OPTS=
PROGPRE=./autostart-plus4
PROGEXT=prg
alltests_prg
PROGPRE=./autostart-plus4
PROGEXT=d64
alltests_disk
PROGPRE=./autostart-plus4
PROGEXT=t64
alltests_t64
}

# xpet
function testxpet
{
BUSDEVICE=yes
BUSDEVON=-busdevice8
BUSDEVOFF=+busdevice8
TRAPDEVICE=no
#TRAPDEVON=-trapdevice8
#TRAPDEVOFF=+trapdevice8
TRAPDEVON=
TRAPDEVOFF=

LIMITCYCLES=20000000
EMU=xpet
OPTS=
DRIVEON="-drive8type 8250"
DRIVEOFF="-drive8type 0"
PROGPRE=./autostart-pet
PROGEXT=prg
alltests_prg
PROGPRE=./autostart-pet
PROGEXT=d82
alltests_disk
PROGPRE=./autostart-pet
PROGEXT=t64
alltests_t64
}

# xscpu64
function testxscpu64
{
BUSDEVICE=yes
BUSDEVON=-busdevice8
BUSDEVOFF=+busdevice8
TRAPDEVICE=yes
TRAPDEVON=-trapdevice8
TRAPDEVOFF=+trapdevice8
LIMITCYCLES=15000000
EMU=xscpu64
DRIVEON="-drive8type 1541"
DRIVEOFF="-drive8type 0"
OPTS=
PROGPRE=./autostart-c64
PROGEXT=prg
alltests_prg
PROGPRE=./autostart-c64
PROGEXT=d64
alltests_disk
}

# xcbm2
function testxcbm2
{
BUSDEVICE=yes
BUSDEVON=-busdevice8
BUSDEVOFF=+busdevice8
TRAPDEVICE=no
TRAPDEVON=
TRAPDEVOFF=

LIMITCYCLES=80000000
EMU=xcbm2
OPTS=
DRIVEON="-drive8type 8250"
DRIVEOFF="-drive8type 0"
PROGPRE=./autostart-cbm610
PROGEXT=prg
alltests_prg
PROGPRE=./autostart-cbm610
PROGEXT=d82
alltests_disk
# kernal traps are not implemented, and tape generally only works in the first
# kernal version
#PROGPRE=./autostart-cbm610
#PROGEXT=t64
#alltests_t64
}

# xcbm5x0
function testxcbm5x0
{
BUSDEVICE=yes
BUSDEVON=-busdevice8
BUSDEVOFF=+busdevice8
TRAPDEVICE=no
TRAPDEVON=
TRAPDEVOFF=

LIMITCYCLES=80000000
EMU=xcbm5x0
DRIVEON="-drive8type 8250"
DRIVEOFF="-drive8type 0"
OPTS=
PROGPRE=./autostart-cbm510
PROGEXT=prg
alltests_prg
PROGPRE=./autostart-cbm510
PROGEXT=d82
alltests_disk
# kernal traps are not implemented, and tape generally only works in the first
# kernal version
#PROGPRE=./autostart-cbm510
#PROGEXT=t64
#alltests_t64
}

function dohelp
{
    echo "autostart.sh <options> <emulator(s)>"
    echo "options:"
    echo " -v --verbose     verbose mode"
    echo "emulators:"
    echo " all"
    echo " x64"
    echo " x64sc"
    echo " x64dtv"
    echo " xscpu64"
    echo " x128"
    echo " xvic"
    echo " xplus4"
    echo " xpet"
    echo " xcbm2"
    echo " xcbm5x0"
}

function checkemudir
{
    if [ "$EMUDIR" == "" ] ; then
        EMUDIR=$SCRIPT_DIR/../../../trunk/vice/src/
        if [ -d "$EMUDIR" ] ; then
            echo "warning: EMUDIR not defined, using "$EMUDIR
        else
            echo "error: EMUDIR not defined and trunk not found."
            exit -1
        fi
    else
        if [ -d "$EMUDIR" ] ; then
            echo "using VICE dir:" $EMUDIR
        else
            echo "error: "$EMUDIR" does not exist."
            exit -1
        fi
    fi
}

if [ -z "${@:1:1}" ] ; then
    dohelp
    exit
else

echo "checking basic autostart functionality:"

checkemudir

for thisarg in "$@"
do
#    echo "arg:" "$thisarg"
    case "$thisarg" in
        --verbose)
                VERBOSE=1
            ;;
        -v)
                VERBOSE=1
            ;;
        xpet)
                testxpet
            ;;
        xcbm2)
                testxcbm2
            ;;
        xcbm5x0)
                testxcbm5x0
            ;;
        xplus4)
                testxplus4
            ;;
        xscpu64)
                testxscpu64
            ;;
        xvic)
                testxvic
            ;;
        x128)
                testx128
            ;;
        x64sc)
                testx64sc
            ;;
        x64)
                testx64
            ;;
        x64dtv)
                testx64dtv
            ;;
        all) # do all
                testx64sc
                testxvic
                testxpet
                testxplus4

                testx64
                testx64dtv
                testxscpu64
                testx128
                testxcbm2
                testxcbm5x0
            ;;
        *)
                echo "unknown option:" "$thisarg"
                dohelp
                exit
            ;;
    esac

done

fi
