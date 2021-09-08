#! /bin/bash

source ../Makefile.config

VERBOSE=0

function dotest
{

checkopts="$5 $6 $7 $8 $9 ${10} ${11} ${12} ${13} ${14} ${15} ${16} ${17} ${18}"

if [ "$3" == "0" ] ; then
    return
fi

if [ "$VERBOSE" == "1" ] ; then
    echo "-_"
    echo ../$VICEDIR/$1 -default $checkopts $PROGPRE-$2.$PROGEXT "# -debugcart -limitcycles $LIMITCYCLES"
fi

echo -ne $1" "$checkopts" # ["$2"] "

../$VICEDIR/$1 -default $checkopts -debugcart -console -warp -limitcycles $LIMITCYCLES $PROGPRE-$2.$PROGEXT 1> /dev/null 2> /dev/null
exitcode=$?

#echo $exitcode
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
echo -ne "$exitstatus" $NC

if [ "$4" == "$exitcode" ] ; then
    echo -ne $GREEN " [expected]" $NC
else
    echo -ne $RED " [error]" $NC
fi

echo -ne "\n"

}

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

echo "autostart mode 0 (virtual filesystem) - do not handle TDE"
## fsdevice = none
# TDEonly
dotest $EMU none        1   1 $OPTS $DRIVEON -device8 0 $IECDEVOFF -drive8truedrive +virtualdev -autostartprgmode 0 +autostart-handle-tde -autostart-warp
dotest $EMU none        1   1 $OPTS $DRIVEON -device8 0 $IECDEVOFF -drive8truedrive +virtualdev -autostartprgmode 0 +autostart-handle-tde +autostart-warp
dotest $EMU tde         0 255 $OPTS $DRIVEON -device8 0 $IECDEVOFF -drive8truedrive -virtualdev -autostartprgmode 0 +autostart-handle-tde -autostart-warp
dotest $EMU tde         0 255 $OPTS $DRIVEON -device8 0 $IECDEVOFF -drive8truedrive -virtualdev -autostartprgmode 0 +autostart-handle-tde +autostart-warp
# none
dotest $EMU none        0 255 $OPTS $DRIVEON -device8 0 $IECDEVOFF +drive8truedrive +virtualdev -autostartprgmode 0 +autostart-handle-tde -autostart-warp
dotest $EMU none        0 255 $OPTS $DRIVEON -device8 0 $IECDEVOFF +drive8truedrive +virtualdev -autostartprgmode 0 +autostart-handle-tde +autostart-warp
# vfs only
dotest $EMU none        1   0 $OPTS $DRIVEON -device8 0 $IECDEVOFF +drive8truedrive -virtualdev -autostartprgmode 0 +autostart-handle-tde -autostart-warp
dotest $EMU none        1   0 $OPTS $DRIVEON -device8 0 $IECDEVOFF +drive8truedrive -virtualdev -autostartprgmode 0 +autostart-handle-tde +autostart-warp
if [ "$IECDEVICE" = "yes" ]; then
dotest $EMU tde         0 255 $OPTS $DRIVEON -device8 0 $IECDEVON  -drive8truedrive +virtualdev -autostartprgmode 0 +autostart-handle-tde -autostart-warp
dotest $EMU tde         0 255 $OPTS $DRIVEON -device8 0 $IECDEVON  -drive8truedrive +virtualdev -autostartprgmode 0 +autostart-handle-tde +autostart-warp
dotest $EMU tde         0 255 $OPTS $DRIVEON -device8 0 $IECDEVON  -drive8truedrive -virtualdev -autostartprgmode 0 +autostart-handle-tde -autostart-warp
dotest $EMU tde         0 255 $OPTS $DRIVEON -device8 0 $IECDEVON  -drive8truedrive -virtualdev -autostartprgmode 0 +autostart-handle-tde +autostart-warp
# iecdev only
dotest $EMU none        1   0 $OPTS $DRIVEON -device8 0 $IECDEVON  +drive8truedrive +virtualdev -autostartprgmode 0 +autostart-handle-tde -autostart-warp
dotest $EMU none        1   0 $OPTS $DRIVEON -device8 0 $IECDEVON  +drive8truedrive +virtualdev -autostartprgmode 0 +autostart-handle-tde +autostart-warp
dotest $EMU vfs         0 255 $OPTS $DRIVEON -device8 0 $IECDEVON  +drive8truedrive -virtualdev -autostartprgmode 0 +autostart-handle-tde -autostart-warp
dotest $EMU vfs         0 255 $OPTS $DRIVEON -device8 0 $IECDEVON  +drive8truedrive -virtualdev -autostartprgmode 0 +autostart-handle-tde +autostart-warp
fi

## fsdevice = filesystem
# TDEonly
dotest $EMU tde         1   1 $OPTS $DRIVEON -device8 1 $IECDEVOFF -drive8truedrive +virtualdev -autostartprgmode 0 +autostart-handle-tde -autostart-warp
dotest $EMU tde         1   1 $OPTS $DRIVEON -device8 1 $IECDEVOFF -drive8truedrive +virtualdev -autostartprgmode 0 +autostart-handle-tde +autostart-warp
dotest $EMU tde         0 255 $OPTS $DRIVEON -device8 1 $IECDEVOFF -drive8truedrive -virtualdev -autostartprgmode 0 +autostart-handle-tde -autostart-warp
dotest $EMU tde         0 255 $OPTS $DRIVEON -device8 1 $IECDEVOFF -drive8truedrive -virtualdev -autostartprgmode 0 +autostart-handle-tde +autostart-warp
# none
dotest $EMU none        0 255 $OPTS $DRIVEON -device8 1 $IECDEVOFF +drive8truedrive +virtualdev -autostartprgmode 0 +autostart-handle-tde -autostart-warp
dotest $EMU none        0 255 $OPTS $DRIVEON -device8 1 $IECDEVOFF +drive8truedrive +virtualdev -autostartprgmode 0 +autostart-handle-tde +autostart-warp
# vfs only
dotest $EMU vfs         1   0 $OPTS $DRIVEON -device8 1 $IECDEVOFF +drive8truedrive -virtualdev -autostartprgmode 0 +autostart-handle-tde -autostart-warp
dotest $EMU vfs         1   0 $OPTS $DRIVEON -device8 1 $IECDEVOFF +drive8truedrive -virtualdev -autostartprgmode 0 +autostart-handle-tde +autostart-warp
if [ "$IECDEVICE" = "yes" ]; then
dotest $EMU tde         0 255 $OPTS $DRIVEON -device8 1 $IECDEVON  -drive8truedrive +virtualdev -autostartprgmode 0 +autostart-handle-tde -autostart-warp
dotest $EMU tde         0 255 $OPTS $DRIVEON -device8 1 $IECDEVON  -drive8truedrive +virtualdev -autostartprgmode 0 +autostart-handle-tde +autostart-warp
dotest $EMU tde         0 255 $OPTS $DRIVEON -device8 1 $IECDEVON  -drive8truedrive -virtualdev -autostartprgmode 0 +autostart-handle-tde -autostart-warp
dotest $EMU tde         0 255 $OPTS $DRIVEON -device8 1 $IECDEVON  -drive8truedrive -virtualdev -autostartprgmode 0 +autostart-handle-tde +autostart-warp
# iecdev only
dotest $EMU vfs         1   0 $OPTS $DRIVEON -device8 1 $IECDEVON  +drive8truedrive +virtualdev -autostartprgmode 0 +autostart-handle-tde -autostart-warp
dotest $EMU vfs         1   0 $OPTS $DRIVEON -device8 1 $IECDEVON  +drive8truedrive +virtualdev -autostartprgmode 0 +autostart-handle-tde +autostart-warp
dotest $EMU vfs         0 255 $OPTS $DRIVEON -device8 1 $IECDEVON  +drive8truedrive -virtualdev -autostartprgmode 0 +autostart-handle-tde -autostart-warp
dotest $EMU vfs         0 255 $OPTS $DRIVEON -device8 1 $IECDEVON  +drive8truedrive -virtualdev -autostartprgmode 0 +autostart-handle-tde +autostart-warp
fi

echo "autostart mode 1 (inject to RAM) - do not handle TDE"
## fsdevice = none
# TDEonly
dotest $EMU tde         1   0 $OPTS $DRIVEON -device8 0 $IECDEVOFF -drive8truedrive +virtualdev -autostartprgmode 1 +autostart-handle-tde -autostart-warp
dotest $EMU tde         1   0 $OPTS $DRIVEON -device8 0 $IECDEVOFF -drive8truedrive +virtualdev -autostartprgmode 1 +autostart-handle-tde +autostart-warp
dotest $EMU tde         0 255 $OPTS $DRIVEON -device8 0 $IECDEVOFF -drive8truedrive -virtualdev -autostartprgmode 1 +autostart-handle-tde -autostart-warp
dotest $EMU tde         0 255 $OPTS $DRIVEON -device8 0 $IECDEVOFF -drive8truedrive -virtualdev -autostartprgmode 1 +autostart-handle-tde +autostart-warp
# none
dotest $EMU none        1   0 $OPTS $DRIVEON -device8 0 $IECDEVOFF +drive8truedrive +virtualdev -autostartprgmode 1 +autostart-handle-tde -autostart-warp
dotest $EMU none        1   0 $OPTS $DRIVEON -device8 0 $IECDEVOFF +drive8truedrive +virtualdev -autostartprgmode 1 +autostart-handle-tde +autostart-warp
# vfs only
dotest $EMU none        1   0 $OPTS $DRIVEON -device8 0 $IECDEVOFF +drive8truedrive -virtualdev -autostartprgmode 1 +autostart-handle-tde -autostart-warp
dotest $EMU none        1   0 $OPTS $DRIVEON -device8 0 $IECDEVOFF +drive8truedrive -virtualdev -autostartprgmode 1 +autostart-handle-tde +autostart-warp
if [ "$IECDEVICE" = "yes" ]; then
dotest $EMU tde         0 255 $OPTS $DRIVEON -device8 0 $IECDEVON  -drive8truedrive +virtualdev -autostartprgmode 1 +autostart-handle-tde -autostart-warp
dotest $EMU tde         0 255 $OPTS $DRIVEON -device8 0 $IECDEVON  -drive8truedrive +virtualdev -autostartprgmode 1 +autostart-handle-tde +autostart-warp
dotest $EMU tde         0 255 $OPTS $DRIVEON -device8 0 $IECDEVON  -drive8truedrive -virtualdev -autostartprgmode 1 +autostart-handle-tde -autostart-warp
dotest $EMU tde         0 255 $OPTS $DRIVEON -device8 0 $IECDEVON  -drive8truedrive -virtualdev -autostartprgmode 1 +autostart-handle-tde +autostart-warp
# iecdev only
dotest $EMU none        1   0 $OPTS $DRIVEON -device8 0 $IECDEVON  +drive8truedrive +virtualdev -autostartprgmode 1 +autostart-handle-tde -autostart-warp
dotest $EMU none        1   0 $OPTS $DRIVEON -device8 0 $IECDEVON  +drive8truedrive +virtualdev -autostartprgmode 1 +autostart-handle-tde +autostart-warp
dotest $EMU vfs         0 255 $OPTS $DRIVEON -device8 0 $IECDEVON  +drive8truedrive -virtualdev -autostartprgmode 1 +autostart-handle-tde -autostart-warp
dotest $EMU vfs         0 255 $OPTS $DRIVEON -device8 0 $IECDEVON  +drive8truedrive -virtualdev -autostartprgmode 1 +autostart-handle-tde +autostart-warp
fi

## fsdevice = filesystem
# TDEonly
dotest $EMU tde         1   0 $OPTS $DRIVEON -device8 1 $IECDEVOFF -drive8truedrive +virtualdev -autostartprgmode 1 +autostart-handle-tde -autostart-warp
dotest $EMU tde         1   0 $OPTS $DRIVEON -device8 1 $IECDEVOFF -drive8truedrive +virtualdev -autostartprgmode 1 +autostart-handle-tde +autostart-warp
dotest $EMU tde         0 255 $OPTS $DRIVEON -device8 1 $IECDEVOFF -drive8truedrive -virtualdev -autostartprgmode 1 +autostart-handle-tde -autostart-warp
dotest $EMU tde         0 255 $OPTS $DRIVEON -device8 1 $IECDEVOFF -drive8truedrive -virtualdev -autostartprgmode 1 +autostart-handle-tde +autostart-warp
# none
dotest $EMU none        1   0 $OPTS $DRIVEON -device8 1 $IECDEVOFF +drive8truedrive +virtualdev -autostartprgmode 1 +autostart-handle-tde -autostart-warp
dotest $EMU none        1   0 $OPTS $DRIVEON -device8 1 $IECDEVOFF +drive8truedrive +virtualdev -autostartprgmode 1 +autostart-handle-tde +autostart-warp
# vfs only
dotest $EMU vfs         1   0 $OPTS $DRIVEON -device8 1 $IECDEVOFF +drive8truedrive -virtualdev -autostartprgmode 1 +autostart-handle-tde -autostart-warp
dotest $EMU vfs         1   0 $OPTS $DRIVEON -device8 1 $IECDEVOFF +drive8truedrive -virtualdev -autostartprgmode 1 +autostart-handle-tde +autostart-warp
if [ "$IECDEVICE" = "yes" ]; then
dotest $EMU tde         0 255 $OPTS $DRIVEON -device8 1 $IECDEVON  -drive8truedrive +virtualdev -autostartprgmode 1 +autostart-handle-tde -autostart-warp
dotest $EMU tde         0 255 $OPTS $DRIVEON -device8 1 $IECDEVON  -drive8truedrive +virtualdev -autostartprgmode 1 +autostart-handle-tde +autostart-warp
dotest $EMU tde         0 255 $OPTS $DRIVEON -device8 1 $IECDEVON  -drive8truedrive -virtualdev -autostartprgmode 1 +autostart-handle-tde -autostart-warp
dotest $EMU tde         0 255 $OPTS $DRIVEON -device8 1 $IECDEVON  -drive8truedrive -virtualdev -autostartprgmode 1 +autostart-handle-tde +autostart-warp
# iecdev only
dotest $EMU vfs         1   0 $OPTS $DRIVEON -device8 1 $IECDEVON  +drive8truedrive +virtualdev -autostartprgmode 1 +autostart-handle-tde -autostart-warp
dotest $EMU vfs         1   0 $OPTS $DRIVEON -device8 1 $IECDEVON  +drive8truedrive +virtualdev -autostartprgmode 1 +autostart-handle-tde +autostart-warp
dotest $EMU vfs         0 255 $OPTS $DRIVEON -device8 1 $IECDEVON  +drive8truedrive -virtualdev -autostartprgmode 1 +autostart-handle-tde -autostart-warp
dotest $EMU vfs         0 255 $OPTS $DRIVEON -device8 1 $IECDEVON  +drive8truedrive -virtualdev -autostartprgmode 1 +autostart-handle-tde +autostart-warp
fi

echo "autostart mode 2 (copy to disk image) - do not handle TDE"
## fsdevice = none
# TDEonly
dotest $EMU tde-disk    1   0 $OPTS $DRIVEON -device8 0 $IECDEVOFF -drive8truedrive +virtualdev -autostartprgmode 2 +autostart-handle-tde -autostart-warp
dotest $EMU tde-disk    1   0 $OPTS $DRIVEON -device8 0 $IECDEVOFF -drive8truedrive +virtualdev -autostartprgmode 2 +autostart-handle-tde +autostart-warp
dotest $EMU tde-disk    0 255 $OPTS $DRIVEON -device8 0 $IECDEVOFF -drive8truedrive -virtualdev -autostartprgmode 2 +autostart-handle-tde -autostart-warp
dotest $EMU tde-disk    0 255 $OPTS $DRIVEON -device8 0 $IECDEVOFF -drive8truedrive -virtualdev -autostartprgmode 2 +autostart-handle-tde +autostart-warp
# none
dotest $EMU none        0 255 $OPTS $DRIVEON -device8 0 $IECDEVOFF +drive8truedrive +virtualdev -autostartprgmode 2 +autostart-handle-tde -autostart-warp
dotest $EMU none        0 255 $OPTS $DRIVEON -device8 0 $IECDEVOFF +drive8truedrive +virtualdev -autostartprgmode 2 +autostart-handle-tde +autostart-warp
# vfs only
dotest $EMU vdrive-disk 1   0 $OPTS $DRIVEON -device8 0 $IECDEVOFF +drive8truedrive -virtualdev -autostartprgmode 2 +autostart-handle-tde -autostart-warp
dotest $EMU vdrive-disk 1   0 $OPTS $DRIVEON -device8 0 $IECDEVOFF +drive8truedrive -virtualdev -autostartprgmode 2 +autostart-handle-tde +autostart-warp
if [ "$IECDEVICE" = "yes" ]; then
dotest $EMU tde-disk    0 255 $OPTS $DRIVEON -device8 0 $IECDEVON  -drive8truedrive +virtualdev -autostartprgmode 2 +autostart-handle-tde -autostart-warp
dotest $EMU tde-disk    0 255 $OPTS $DRIVEON -device8 0 $IECDEVON  -drive8truedrive +virtualdev -autostartprgmode 2 +autostart-handle-tde +autostart-warp
dotest $EMU tde-disk    0 255 $OPTS $DRIVEON -device8 0 $IECDEVON  -drive8truedrive -virtualdev -autostartprgmode 2 +autostart-handle-tde -autostart-warp
dotest $EMU tde-disk    0 255 $OPTS $DRIVEON -device8 0 $IECDEVON  -drive8truedrive -virtualdev -autostartprgmode 2 +autostart-handle-tde +autostart-warp
# iecdev only
dotest $EMU vdrive-disk 1   0 $OPTS $DRIVEON -device8 0 $IECDEVON  +drive8truedrive +virtualdev -autostartprgmode 2 +autostart-handle-tde -autostart-warp
dotest $EMU vdrive-disk 1   0 $OPTS $DRIVEON -device8 0 $IECDEVON  +drive8truedrive +virtualdev -autostartprgmode 2 +autostart-handle-tde +autostart-warp
dotest $EMU vdrive-disk 0 255 $OPTS $DRIVEON -device8 0 $IECDEVON  +drive8truedrive -virtualdev -autostartprgmode 2 +autostart-handle-tde -autostart-warp
dotest $EMU vdrive-disk 0 255 $OPTS $DRIVEON -device8 0 $IECDEVON  +drive8truedrive -virtualdev -autostartprgmode 2 +autostart-handle-tde +autostart-warp
fi

## fsdevice = filesystem
# TDEonly
dotest $EMU tde-disk    1   0 $OPTS $DRIVEON -device8 1 $IECDEVOFF -drive8truedrive +virtualdev -autostartprgmode 2 +autostart-handle-tde -autostart-warp
dotest $EMU tde-disk    1   0 $OPTS $DRIVEON -device8 1 $IECDEVOFF -drive8truedrive +virtualdev -autostartprgmode 2 +autostart-handle-tde +autostart-warp
dotest $EMU tde-disk    0 255 $OPTS $DRIVEON -device8 1 $IECDEVOFF -drive8truedrive -virtualdev -autostartprgmode 2 +autostart-handle-tde -autostart-warp
dotest $EMU tde-disk    0 255 $OPTS $DRIVEON -device8 1 $IECDEVOFF -drive8truedrive -virtualdev -autostartprgmode 2 +autostart-handle-tde +autostart-warp
# none
dotest $EMU none        0 255 $OPTS $DRIVEON -device8 1 $IECDEVOFF +drive8truedrive +virtualdev -autostartprgmode 2 +autostart-handle-tde -autostart-warp
dotest $EMU none        0 255 $OPTS $DRIVEON -device8 1 $IECDEVOFF +drive8truedrive +virtualdev -autostartprgmode 2 +autostart-handle-tde +autostart-warp
# vfs only
dotest $EMU vdrive-disk 1   0 $OPTS $DRIVEON -device8 1 $IECDEVOFF +drive8truedrive -virtualdev -autostartprgmode 2 +autostart-handle-tde -autostart-warp
dotest $EMU vdrive-disk 1   0 $OPTS $DRIVEON -device8 1 $IECDEVOFF +drive8truedrive -virtualdev -autostartprgmode 2 +autostart-handle-tde +autostart-warp
if [ "$IECDEVICE" = "yes" ]; then
dotest $EMU tde-disk    0 255 $OPTS $DRIVEON -device8 1 $IECDEVON  -drive8truedrive +virtualdev -autostartprgmode 2 +autostart-handle-tde -autostart-warp
dotest $EMU tde-disk    0 255 $OPTS $DRIVEON -device8 1 $IECDEVON  -drive8truedrive +virtualdev -autostartprgmode 2 +autostart-handle-tde +autostart-warp
dotest $EMU tde-disk    0 255 $OPTS $DRIVEON -device8 1 $IECDEVON  -drive8truedrive -virtualdev -autostartprgmode 2 +autostart-handle-tde -autostart-warp
dotest $EMU tde-disk    0 255 $OPTS $DRIVEON -device8 1 $IECDEVON  -drive8truedrive -virtualdev -autostartprgmode 2 +autostart-handle-tde +autostart-warp
# iecdev only
dotest $EMU vdrive-disk 1   0 $OPTS $DRIVEON -device8 1 $IECDEVON  +drive8truedrive +virtualdev -autostartprgmode 2 +autostart-handle-tde -autostart-warp
dotest $EMU vdrive-disk 1   0 $OPTS $DRIVEON -device8 1 $IECDEVON  +drive8truedrive +virtualdev -autostartprgmode 2 +autostart-handle-tde +autostart-warp
dotest $EMU vdrive-disk 0 255 $OPTS $DRIVEON -device8 1 $IECDEVON  +drive8truedrive -virtualdev -autostartprgmode 2 +autostart-handle-tde -autostart-warp
dotest $EMU vdrive-disk 0 255 $OPTS $DRIVEON -device8 1 $IECDEVON  +drive8truedrive -virtualdev -autostartprgmode 2 +autostart-handle-tde +autostart-warp
fi

echo "autostart mode 0 (virtual filesystem) - handle TDE"
## fsdevice = none
# TDEonly
dotest $EMU tde         1   1 $OPTS $DRIVEON -device8 0 $IECDEVOFF -drive8truedrive +virtualdev -autostartprgmode 0 -autostart-handle-tde -autostart-warp
dotest $EMU tde         1   1 $OPTS $DRIVEON -device8 0 $IECDEVOFF -drive8truedrive +virtualdev -autostartprgmode 0 -autostart-handle-tde +autostart-warp
dotest $EMU tde         0 255 $OPTS $DRIVEON -device8 0 $IECDEVOFF -drive8truedrive -virtualdev -autostartprgmode 0 -autostart-handle-tde -autostart-warp
dotest $EMU tde         0 255 $OPTS $DRIVEON -device8 0 $IECDEVOFF -drive8truedrive -virtualdev -autostartprgmode 0 -autostart-handle-tde +autostart-warp
# none
dotest $EMU none        0 255 $OPTS $DRIVEON -device8 0 $IECDEVOFF +drive8truedrive +virtualdev -autostartprgmode 0 -autostart-handle-tde -autostart-warp
dotest $EMU none        0 255 $OPTS $DRIVEON -device8 0 $IECDEVOFF +drive8truedrive +virtualdev -autostartprgmode 0 -autostart-handle-tde +autostart-warp
# vfs only
dotest $EMU none        1   0 $OPTS $DRIVEON -device8 0 $IECDEVOFF +drive8truedrive -virtualdev -autostartprgmode 0 -autostart-handle-tde -autostart-warp
dotest $EMU none        1   0 $OPTS $DRIVEON -device8 0 $IECDEVOFF +drive8truedrive -virtualdev -autostartprgmode 0 -autostart-handle-tde +autostart-warp
if [ "$IECDEVICE" = "yes" ]; then
dotest $EMU tde         0 255 $OPTS $DRIVEON -device8 0 $IECDEVON  -drive8truedrive +virtualdev -autostartprgmode 0 -autostart-handle-tde -autostart-warp
dotest $EMU tde         0 255 $OPTS $DRIVEON -device8 0 $IECDEVON  -drive8truedrive +virtualdev -autostartprgmode 0 -autostart-handle-tde +autostart-warp
dotest $EMU tde         0 255 $OPTS $DRIVEON -device8 0 $IECDEVON  -drive8truedrive -virtualdev -autostartprgmode 0 -autostart-handle-tde -autostart-warp
dotest $EMU tde         0 255 $OPTS $DRIVEON -device8 0 $IECDEVON  -drive8truedrive -virtualdev -autostartprgmode 0 -autostart-handle-tde +autostart-warp
# iecdev only
dotest $EMU none        1   0 $OPTS $DRIVEON -device8 0 $IECDEVON  +drive8truedrive +virtualdev -autostartprgmode 0 -autostart-handle-tde -autostart-warp
dotest $EMU none        1   0 $OPTS $DRIVEON -device8 0 $IECDEVON  +drive8truedrive +virtualdev -autostartprgmode 0 -autostart-handle-tde +autostart-warp
dotest $EMU vfs         0 255 $OPTS $DRIVEON -device8 0 $IECDEVON  +drive8truedrive -virtualdev -autostartprgmode 0 -autostart-handle-tde -autostart-warp
dotest $EMU vfs         0 255 $OPTS $DRIVEON -device8 0 $IECDEVON  +drive8truedrive -virtualdev -autostartprgmode 0 -autostart-handle-tde +autostart-warp
fi

## fsdevice = filesystem
# TDEonly
dotest $EMU tde         1   1 $OPTS $DRIVEON -device8 1 $IECDEVOFF -drive8truedrive +virtualdev -autostartprgmode 0 -autostart-handle-tde -autostart-warp
dotest $EMU tde         1   1 $OPTS $DRIVEON -device8 1 $IECDEVOFF -drive8truedrive +virtualdev -autostartprgmode 0 -autostart-handle-tde +autostart-warp
dotest $EMU tde         0 255 $OPTS $DRIVEON -device8 1 $IECDEVOFF -drive8truedrive -virtualdev -autostartprgmode 0 -autostart-handle-tde -autostart-warp
dotest $EMU tde         0 255 $OPTS $DRIVEON -device8 1 $IECDEVOFF -drive8truedrive -virtualdev -autostartprgmode 0 -autostart-handle-tde +autostart-warp
# none
dotest $EMU none        0 255 $OPTS $DRIVEON -device8 1 $IECDEVOFF +drive8truedrive +virtualdev -autostartprgmode 0 -autostart-handle-tde -autostart-warp
dotest $EMU none        0 255 $OPTS $DRIVEON -device8 1 $IECDEVOFF +drive8truedrive +virtualdev -autostartprgmode 0 -autostart-handle-tde +autostart-warp
# vfs only
dotest $EMU vfs         1   0 $OPTS $DRIVEON -device8 1 $IECDEVOFF +drive8truedrive -virtualdev -autostartprgmode 0 -autostart-handle-tde -autostart-warp
dotest $EMU vfs         1   0 $OPTS $DRIVEON -device8 1 $IECDEVOFF +drive8truedrive -virtualdev -autostartprgmode 0 -autostart-handle-tde +autostart-warp
if [ "$IECDEVICE" = "yes" ]; then
dotest $EMU tde         0 255 $OPTS $DRIVEON -device8 1 $IECDEVON  -drive8truedrive +virtualdev -autostartprgmode 0 -autostart-handle-tde -autostart-warp
dotest $EMU tde         0 255 $OPTS $DRIVEON -device8 1 $IECDEVON  -drive8truedrive +virtualdev -autostartprgmode 0 -autostart-handle-tde +autostart-warp
dotest $EMU tde         0 255 $OPTS $DRIVEON -device8 1 $IECDEVON  -drive8truedrive -virtualdev -autostartprgmode 0 -autostart-handle-tde -autostart-warp
dotest $EMU tde         0 255 $OPTS $DRIVEON -device8 1 $IECDEVON  -drive8truedrive -virtualdev -autostartprgmode 0 -autostart-handle-tde +autostart-warp
# iecdev only
dotest $EMU vfs         1   0 $OPTS $DRIVEON -device8 1 $IECDEVON  +drive8truedrive +virtualdev -autostartprgmode 0 -autostart-handle-tde -autostart-warp
dotest $EMU vfs         1   0 $OPTS $DRIVEON -device8 1 $IECDEVON  +drive8truedrive +virtualdev -autostartprgmode 0 -autostart-handle-tde +autostart-warp
dotest $EMU vfs         0 255 $OPTS $DRIVEON -device8 1 $IECDEVON  +drive8truedrive -virtualdev -autostartprgmode 0 -autostart-handle-tde -autostart-warp
dotest $EMU vfs         0 255 $OPTS $DRIVEON -device8 1 $IECDEVON  +drive8truedrive -virtualdev -autostartprgmode 0 -autostart-handle-tde +autostart-warp
fi

echo "autostart mode 1 (inject to RAM) - handle TDE"
## fsdevice = none
# TDEonly
dotest $EMU tde         1   0 $OPTS $DRIVEON -device8 0 $IECDEVOFF -drive8truedrive +virtualdev -autostartprgmode 1 -autostart-handle-tde -autostart-warp
dotest $EMU tde         1   0 $OPTS $DRIVEON -device8 0 $IECDEVOFF -drive8truedrive +virtualdev -autostartprgmode 1 -autostart-handle-tde +autostart-warp
dotest $EMU tde         0 255 $OPTS $DRIVEON -device8 0 $IECDEVOFF -drive8truedrive -virtualdev -autostartprgmode 1 -autostart-handle-tde -autostart-warp
dotest $EMU tde         0 255 $OPTS $DRIVEON -device8 0 $IECDEVOFF -drive8truedrive -virtualdev -autostartprgmode 1 -autostart-handle-tde +autostart-warp
# none
dotest $EMU none        0   0 $OPTS $DRIVEON -device8 0 $IECDEVOFF +drive8truedrive +virtualdev -autostartprgmode 1 -autostart-handle-tde -autostart-warp
dotest $EMU none        0   0 $OPTS $DRIVEON -device8 0 $IECDEVOFF +drive8truedrive +virtualdev -autostartprgmode 1 -autostart-handle-tde +autostart-warp
# vfs only
dotest $EMU none        1   0 $OPTS $DRIVEON -device8 0 $IECDEVOFF +drive8truedrive -virtualdev -autostartprgmode 1 -autostart-handle-tde -autostart-warp
dotest $EMU none        1   0 $OPTS $DRIVEON -device8 0 $IECDEVOFF +drive8truedrive -virtualdev -autostartprgmode 1 -autostart-handle-tde +autostart-warp
if [ "$IECDEVICE" = "yes" ]; then
dotest $EMU tde         0 255 $OPTS $DRIVEON -device8 0 $IECDEVON  -drive8truedrive +virtualdev -autostartprgmode 1 -autostart-handle-tde -autostart-warp
dotest $EMU tde         0 255 $OPTS $DRIVEON -device8 0 $IECDEVON  -drive8truedrive +virtualdev -autostartprgmode 1 -autostart-handle-tde +autostart-warp
dotest $EMU tde         0 255 $OPTS $DRIVEON -device8 0 $IECDEVON  -drive8truedrive -virtualdev -autostartprgmode 1 -autostart-handle-tde -autostart-warp
dotest $EMU tde         0 255 $OPTS $DRIVEON -device8 0 $IECDEVON  -drive8truedrive -virtualdev -autostartprgmode 1 -autostart-handle-tde +autostart-warp
# iecdev only
dotest $EMU none        1   0 $OPTS $DRIVEON -device8 0 $IECDEVON  +drive8truedrive +virtualdev -autostartprgmode 1 -autostart-handle-tde -autostart-warp
dotest $EMU none        1   0 $OPTS $DRIVEON -device8 0 $IECDEVON  +drive8truedrive +virtualdev -autostartprgmode 1 -autostart-handle-tde +autostart-warp
dotest $EMU vfs         0 255 $OPTS $DRIVEON -device8 0 $IECDEVON  +drive8truedrive -virtualdev -autostartprgmode 1 -autostart-handle-tde -autostart-warp
dotest $EMU vfs         0 255 $OPTS $DRIVEON -device8 0 $IECDEVON  +drive8truedrive -virtualdev -autostartprgmode 1 -autostart-handle-tde +autostart-warp
fi

## fsdevice = filesystem
# TDEonly
dotest $EMU tde         1   0 $OPTS $DRIVEON -device8 1 $IECDEVOFF -drive8truedrive +virtualdev -autostartprgmode 1 -autostart-handle-tde -autostart-warp
dotest $EMU tde         1   0 $OPTS $DRIVEON -device8 1 $IECDEVOFF -drive8truedrive +virtualdev -autostartprgmode 1 -autostart-handle-tde +autostart-warp
dotest $EMU tde         0 255 $OPTS $DRIVEON -device8 1 $IECDEVOFF -drive8truedrive -virtualdev -autostartprgmode 1 -autostart-handle-tde -autostart-warp
dotest $EMU tde         0 255 $OPTS $DRIVEON -device8 1 $IECDEVOFF -drive8truedrive -virtualdev -autostartprgmode 1 -autostart-handle-tde +autostart-warp
# none
dotest $EMU none        0   0 $OPTS $DRIVEON -device8 1 $IECDEVOFF +drive8truedrive +virtualdev -autostartprgmode 1 -autostart-handle-tde -autostart-warp
dotest $EMU none        0   0 $OPTS $DRIVEON -device8 1 $IECDEVOFF +drive8truedrive +virtualdev -autostartprgmode 1 -autostart-handle-tde +autostart-warp
# vfs only
dotest $EMU vfs         1   0 $OPTS $DRIVEON -device8 1 $IECDEVOFF +drive8truedrive -virtualdev -autostartprgmode 1 -autostart-handle-tde -autostart-warp
dotest $EMU vfs         1   0 $OPTS $DRIVEON -device8 1 $IECDEVOFF +drive8truedrive -virtualdev -autostartprgmode 1 -autostart-handle-tde +autostart-warp
if [ "$IECDEVICE" = "yes" ]; then
dotest $EMU tde         0 255 $OPTS $DRIVEON -device8 1 $IECDEVON  -drive8truedrive +virtualdev -autostartprgmode 1 -autostart-handle-tde -autostart-warp
dotest $EMU tde         0 255 $OPTS $DRIVEON -device8 1 $IECDEVON  -drive8truedrive +virtualdev -autostartprgmode 1 -autostart-handle-tde +autostart-warp
dotest $EMU tde         0 255 $OPTS $DRIVEON -device8 1 $IECDEVON  -drive8truedrive -virtualdev -autostartprgmode 1 -autostart-handle-tde -autostart-warp
dotest $EMU tde         0 255 $OPTS $DRIVEON -device8 1 $IECDEVON  -drive8truedrive -virtualdev -autostartprgmode 1 -autostart-handle-tde +autostart-warp
# iecdev only
dotest $EMU vfs         1   0 $OPTS $DRIVEON -device8 1 $IECDEVON  +drive8truedrive +virtualdev -autostartprgmode 1 -autostart-handle-tde -autostart-warp
dotest $EMU vfs         1   0 $OPTS $DRIVEON -device8 1 $IECDEVON  +drive8truedrive +virtualdev -autostartprgmode 1 -autostart-handle-tde +autostart-warp
dotest $EMU vfs         0 255 $OPTS $DRIVEON -device8 1 $IECDEVON  +drive8truedrive -virtualdev -autostartprgmode 1 -autostart-handle-tde -autostart-warp
dotest $EMU vfs         0 255 $OPTS $DRIVEON -device8 1 $IECDEVON  +drive8truedrive -virtualdev -autostartprgmode 1 -autostart-handle-tde +autostart-warp
fi

echo "autostart mode 2 (copy to disk image) - handle TDE"
## fsdevice = none
# TDEonly
dotest $EMU tde-disk    1   0 $OPTS $DRIVEON -device8 0 $IECDEVOFF -drive8truedrive +virtualdev -autostartprgmode 2 -autostart-handle-tde -autostart-warp
dotest $EMU tde-disk    1   0 $OPTS $DRIVEON -device8 0 $IECDEVOFF -drive8truedrive +virtualdev -autostartprgmode 2 -autostart-handle-tde +autostart-warp
dotest $EMU tde-disk    0 255 $OPTS $DRIVEON -device8 0 $IECDEVOFF -drive8truedrive -virtualdev -autostartprgmode 2 -autostart-handle-tde -autostart-warp
dotest $EMU tde-disk    0 255 $OPTS $DRIVEON -device8 0 $IECDEVOFF -drive8truedrive -virtualdev -autostartprgmode 2 -autostart-handle-tde +autostart-warp
# none
dotest $EMU none        0 255 $OPTS $DRIVEON -device8 0 $IECDEVOFF +drive8truedrive +virtualdev -autostartprgmode 2 -autostart-handle-tde -autostart-warp
dotest $EMU none        0 255 $OPTS $DRIVEON -device8 0 $IECDEVOFF +drive8truedrive +virtualdev -autostartprgmode 2 -autostart-handle-tde +autostart-warp
# vfs only
dotest $EMU vdrive-disk 1   0 $OPTS $DRIVEON -device8 0 $IECDEVOFF +drive8truedrive -virtualdev -autostartprgmode 2 -autostart-handle-tde -autostart-warp
dotest $EMU vdrive-disk 1   0 $OPTS $DRIVEON -device8 0 $IECDEVOFF +drive8truedrive -virtualdev -autostartprgmode 2 -autostart-handle-tde +autostart-warp
if [ "$IECDEVICE" = "yes" ]; then
dotest $EMU tde-disk    0 255 $OPTS $DRIVEON -device8 0 $IECDEVON  -drive8truedrive +virtualdev -autostartprgmode 2 -autostart-handle-tde -autostart-warp
dotest $EMU tde-disk    0 255 $OPTS $DRIVEON -device8 0 $IECDEVON  -drive8truedrive +virtualdev -autostartprgmode 2 -autostart-handle-tde +autostart-warp
dotest $EMU tde-disk    0 255 $OPTS $DRIVEON -device8 0 $IECDEVON  -drive8truedrive -virtualdev -autostartprgmode 2 -autostart-handle-tde -autostart-warp
dotest $EMU tde-disk    0 255 $OPTS $DRIVEON -device8 0 $IECDEVON  -drive8truedrive -virtualdev -autostartprgmode 2 -autostart-handle-tde +autostart-warp
# iecdev only
dotest $EMU vdrive-disk 1   0 $OPTS $DRIVEON -device8 0 $IECDEVON  +drive8truedrive +virtualdev -autostartprgmode 2 -autostart-handle-tde -autostart-warp
dotest $EMU vdrive-disk 1   0 $OPTS $DRIVEON -device8 0 $IECDEVON  +drive8truedrive +virtualdev -autostartprgmode 2 -autostart-handle-tde +autostart-warp
dotest $EMU vdrive-disk 0 255 $OPTS $DRIVEON -device8 0 $IECDEVON  +drive8truedrive -virtualdev -autostartprgmode 2 -autostart-handle-tde -autostart-warp
dotest $EMU vdrive-disk 0 255 $OPTS $DRIVEON -device8 0 $IECDEVON  +drive8truedrive -virtualdev -autostartprgmode 2 -autostart-handle-tde +autostart-warp
fi

## fsdevice = filesystem
# TDEonly
dotest $EMU tde-disk    1   0 $OPTS $DRIVEON -device8 1 $IECDEVOFF -drive8truedrive +virtualdev -autostartprgmode 2 -autostart-handle-tde -autostart-warp
dotest $EMU tde-disk    1   0 $OPTS $DRIVEON -device8 1 $IECDEVOFF -drive8truedrive +virtualdev -autostartprgmode 2 -autostart-handle-tde +autostart-warp
dotest $EMU tde-disk    0 255 $OPTS $DRIVEON -device8 1 $IECDEVOFF -drive8truedrive -virtualdev -autostartprgmode 2 -autostart-handle-tde -autostart-warp
dotest $EMU tde-disk    0 255 $OPTS $DRIVEON -device8 1 $IECDEVOFF -drive8truedrive -virtualdev -autostartprgmode 2 -autostart-handle-tde +autostart-warp
# none
dotest $EMU none        0 255 $OPTS $DRIVEON -device8 1 $IECDEVOFF +drive8truedrive +virtualdev -autostartprgmode 2 -autostart-handle-tde -autostart-warp
dotest $EMU none        0 255 $OPTS $DRIVEON -device8 1 $IECDEVOFF +drive8truedrive +virtualdev -autostartprgmode 2 -autostart-handle-tde +autostart-warp
# vfs only
dotest $EMU vdrive-disk 1   0 $OPTS $DRIVEON -device8 1 $IECDEVOFF +drive8truedrive -virtualdev -autostartprgmode 2 -autostart-handle-tde -autostart-warp
dotest $EMU vdrive-disk 1   0 $OPTS $DRIVEON -device8 1 $IECDEVOFF +drive8truedrive -virtualdev -autostartprgmode 2 -autostart-handle-tde +autostart-warp
if [ "$IECDEVICE" = "yes" ]; then
dotest $EMU tde-disk    0 255 $OPTS $DRIVEON -device8 1 $IECDEVON  -drive8truedrive +virtualdev -autostartprgmode 2 -autostart-handle-tde -autostart-warp
dotest $EMU tde-disk    0 255 $OPTS $DRIVEON -device8 1 $IECDEVON  -drive8truedrive +virtualdev -autostartprgmode 2 -autostart-handle-tde +autostart-warp
dotest $EMU tde-disk    0 255 $OPTS $DRIVEON -device8 1 $IECDEVON  -drive8truedrive -virtualdev -autostartprgmode 2 -autostart-handle-tde -autostart-warp
dotest $EMU tde-disk    0 255 $OPTS $DRIVEON -device8 1 $IECDEVON  -drive8truedrive -virtualdev -autostartprgmode 2 -autostart-handle-tde +autostart-warp
# iecdev only
dotest $EMU vdrive-disk 1   0 $OPTS $DRIVEON -device8 1 $IECDEVON  +drive8truedrive +virtualdev -autostartprgmode 2 -autostart-handle-tde -autostart-warp
dotest $EMU vdrive-disk 1   0 $OPTS $DRIVEON -device8 1 $IECDEVON  +drive8truedrive +virtualdev -autostartprgmode 2 -autostart-handle-tde +autostart-warp
dotest $EMU vdrive-disk 0 255 $OPTS $DRIVEON -device8 1 $IECDEVON  +drive8truedrive -virtualdev -autostartprgmode 2 -autostart-handle-tde -autostart-warp
dotest $EMU vdrive-disk 0 255 $OPTS $DRIVEON -device8 1 $IECDEVON  +drive8truedrive -virtualdev -autostartprgmode 2 -autostart-handle-tde +autostart-warp
fi

# with drive = none

echo "autostart mode 0 (virtual filesystem) - do not handle TDE"
## fsdevice = none
# TDEonly
dotest $EMU none        1   1 $OPTS $DRIVEOFF -device8 0 $IECDEVOFF -drive8truedrive +virtualdev -autostartprgmode 0 +autostart-handle-tde -autostart-warp
dotest $EMU none        1   1 $OPTS $DRIVEOFF -device8 0 $IECDEVOFF -drive8truedrive +virtualdev -autostartprgmode 0 +autostart-handle-tde +autostart-warp
dotest $EMU tde         0 255 $OPTS $DRIVEOFF -device8 0 $IECDEVOFF -drive8truedrive -virtualdev -autostartprgmode 0 +autostart-handle-tde -autostart-warp
dotest $EMU tde         0 255 $OPTS $DRIVEOFF -device8 0 $IECDEVOFF -drive8truedrive -virtualdev -autostartprgmode 0 +autostart-handle-tde +autostart-warp
# none
dotest $EMU none        0 255 $OPTS $DRIVEOFF -device8 0 $IECDEVOFF +drive8truedrive +virtualdev -autostartprgmode 0 +autostart-handle-tde -autostart-warp
dotest $EMU none        0 255 $OPTS $DRIVEOFF -device8 0 $IECDEVOFF +drive8truedrive +virtualdev -autostartprgmode 0 +autostart-handle-tde +autostart-warp
# vfs only
dotest $EMU none        1   0 $OPTS $DRIVEOFF -device8 0 $IECDEVOFF +drive8truedrive -virtualdev -autostartprgmode 0 +autostart-handle-tde -autostart-warp
dotest $EMU none        1   0 $OPTS $DRIVEOFF -device8 0 $IECDEVOFF +drive8truedrive -virtualdev -autostartprgmode 0 +autostart-handle-tde +autostart-warp
if [ "$IECDEVICE" = "yes" ]; then
dotest $EMU tde         0 255 $OPTS $DRIVEOFF -device8 0 $IECDEVON  -drive8truedrive +virtualdev -autostartprgmode 0 +autostart-handle-tde -autostart-warp
dotest $EMU tde         0 255 $OPTS $DRIVEOFF -device8 0 $IECDEVON  -drive8truedrive +virtualdev -autostartprgmode 0 +autostart-handle-tde +autostart-warp
dotest $EMU tde         0 255 $OPTS $DRIVEOFF -device8 0 $IECDEVON  -drive8truedrive -virtualdev -autostartprgmode 0 +autostart-handle-tde -autostart-warp
dotest $EMU tde         0 255 $OPTS $DRIVEOFF -device8 0 $IECDEVON  -drive8truedrive -virtualdev -autostartprgmode 0 +autostart-handle-tde +autostart-warp
# iecdev only
dotest $EMU none        1   0 $OPTS $DRIVEOFF -device8 0 $IECDEVON  +drive8truedrive +virtualdev -autostartprgmode 0 +autostart-handle-tde -autostart-warp
dotest $EMU none        1   0 $OPTS $DRIVEOFF -device8 0 $IECDEVON  +drive8truedrive +virtualdev -autostartprgmode 0 +autostart-handle-tde +autostart-warp
dotest $EMU vfs         0 255 $OPTS $DRIVEOFF -device8 0 $IECDEVON  +drive8truedrive -virtualdev -autostartprgmode 0 +autostart-handle-tde -autostart-warp
dotest $EMU vfs         0 255 $OPTS $DRIVEOFF -device8 0 $IECDEVON  +drive8truedrive -virtualdev -autostartprgmode 0 +autostart-handle-tde +autostart-warp
fi

## fsdevice = filesystem
# TDEonly
dotest $EMU tde         1   1 $OPTS $DRIVEOFF -device8 1 $IECDEVOFF -drive8truedrive +virtualdev -autostartprgmode 0 +autostart-handle-tde -autostart-warp
dotest $EMU tde         1   1 $OPTS $DRIVEOFF -device8 1 $IECDEVOFF -drive8truedrive +virtualdev -autostartprgmode 0 +autostart-handle-tde +autostart-warp
dotest $EMU tde         0 255 $OPTS $DRIVEOFF -device8 1 $IECDEVOFF -drive8truedrive -virtualdev -autostartprgmode 0 +autostart-handle-tde -autostart-warp
dotest $EMU tde         0 255 $OPTS $DRIVEOFF -device8 1 $IECDEVOFF -drive8truedrive -virtualdev -autostartprgmode 0 +autostart-handle-tde +autostart-warp
# none
dotest $EMU none        0 255 $OPTS $DRIVEOFF -device8 1 $IECDEVOFF +drive8truedrive +virtualdev -autostartprgmode 0 +autostart-handle-tde -autostart-warp
dotest $EMU none        0 255 $OPTS $DRIVEOFF -device8 1 $IECDEVOFF +drive8truedrive +virtualdev -autostartprgmode 0 +autostart-handle-tde +autostart-warp
# vfs only
dotest $EMU vfs         1   0 $OPTS $DRIVEOFF -device8 1 $IECDEVOFF +drive8truedrive -virtualdev -autostartprgmode 0 +autostart-handle-tde -autostart-warp
dotest $EMU vfs         1   0 $OPTS $DRIVEOFF -device8 1 $IECDEVOFF +drive8truedrive -virtualdev -autostartprgmode 0 +autostart-handle-tde +autostart-warp
if [ "$IECDEVICE" = "yes" ]; then
dotest $EMU tde         0 255 $OPTS $DRIVEOFF -device8 1 $IECDEVON  -drive8truedrive +virtualdev -autostartprgmode 0 +autostart-handle-tde -autostart-warp
dotest $EMU tde         0 255 $OPTS $DRIVEOFF -device8 1 $IECDEVON  -drive8truedrive +virtualdev -autostartprgmode 0 +autostart-handle-tde +autostart-warp
dotest $EMU tde         0 255 $OPTS $DRIVEOFF -device8 1 $IECDEVON  -drive8truedrive -virtualdev -autostartprgmode 0 +autostart-handle-tde -autostart-warp
dotest $EMU tde         0 255 $OPTS $DRIVEOFF -device8 1 $IECDEVON  -drive8truedrive -virtualdev -autostartprgmode 0 +autostart-handle-tde +autostart-warp
# iecdev only
dotest $EMU vfs         1   0 $OPTS $DRIVEOFF -device8 1 $IECDEVON  +drive8truedrive +virtualdev -autostartprgmode 0 +autostart-handle-tde -autostart-warp
dotest $EMU vfs         1   0 $OPTS $DRIVEOFF -device8 1 $IECDEVON  +drive8truedrive +virtualdev -autostartprgmode 0 +autostart-handle-tde +autostart-warp
dotest $EMU vfs         0 255 $OPTS $DRIVEOFF -device8 1 $IECDEVON  +drive8truedrive -virtualdev -autostartprgmode 0 +autostart-handle-tde -autostart-warp
dotest $EMU vfs         0 255 $OPTS $DRIVEOFF -device8 1 $IECDEVON  +drive8truedrive -virtualdev -autostartprgmode 0 +autostart-handle-tde +autostart-warp
fi

echo "autostart mode 1 (inject to RAM) - do not handle TDE"
## fsdevice = none
# TDEonly
dotest $EMU none        1   0 $OPTS $DRIVEOFF -device8 0 $IECDEVOFF -drive8truedrive +virtualdev -autostartprgmode 1 +autostart-handle-tde -autostart-warp
dotest $EMU none        1   0 $OPTS $DRIVEOFF -device8 0 $IECDEVOFF -drive8truedrive +virtualdev -autostartprgmode 1 +autostart-handle-tde +autostart-warp
dotest $EMU tde         0 255 $OPTS $DRIVEOFF -device8 0 $IECDEVOFF -drive8truedrive -virtualdev -autostartprgmode 1 +autostart-handle-tde -autostart-warp
dotest $EMU tde         0 255 $OPTS $DRIVEOFF -device8 0 $IECDEVOFF -drive8truedrive -virtualdev -autostartprgmode 1 +autostart-handle-tde +autostart-warp
# none
dotest $EMU none        1   0 $OPTS $DRIVEOFF -device8 0 $IECDEVOFF +drive8truedrive +virtualdev -autostartprgmode 1 +autostart-handle-tde -autostart-warp
dotest $EMU none        1   0 $OPTS $DRIVEOFF -device8 0 $IECDEVOFF +drive8truedrive +virtualdev -autostartprgmode 1 +autostart-handle-tde +autostart-warp
# vfs only
dotest $EMU none        1   0 $OPTS $DRIVEOFF -device8 0 $IECDEVOFF +drive8truedrive -virtualdev -autostartprgmode 1 +autostart-handle-tde -autostart-warp
dotest $EMU none        1   0 $OPTS $DRIVEOFF -device8 0 $IECDEVOFF +drive8truedrive -virtualdev -autostartprgmode 1 +autostart-handle-tde +autostart-warp
if [ "$IECDEVICE" = "yes" ]; then
dotest $EMU tde         0 255 $OPTS $DRIVEOFF -device8 0 $IECDEVON  -drive8truedrive +virtualdev -autostartprgmode 1 +autostart-handle-tde -autostart-warp
dotest $EMU tde         0 255 $OPTS $DRIVEOFF -device8 0 $IECDEVON  -drive8truedrive +virtualdev -autostartprgmode 1 +autostart-handle-tde +autostart-warp
dotest $EMU tde         0 255 $OPTS $DRIVEOFF -device8 0 $IECDEVON  -drive8truedrive -virtualdev -autostartprgmode 1 +autostart-handle-tde -autostart-warp
dotest $EMU tde         0 255 $OPTS $DRIVEOFF -device8 0 $IECDEVON  -drive8truedrive -virtualdev -autostartprgmode 1 +autostart-handle-tde +autostart-warp
# iecdev only
dotest $EMU none        1   0 $OPTS $DRIVEOFF -device8 0 $IECDEVON  +drive8truedrive +virtualdev -autostartprgmode 1 +autostart-handle-tde -autostart-warp
dotest $EMU none        1   0 $OPTS $DRIVEOFF -device8 0 $IECDEVON  +drive8truedrive +virtualdev -autostartprgmode 1 +autostart-handle-tde +autostart-warp
dotest $EMU vfs         0 255 $OPTS $DRIVEOFF -device8 0 $IECDEVON  +drive8truedrive -virtualdev -autostartprgmode 1 +autostart-handle-tde -autostart-warp
dotest $EMU vfs         0 255 $OPTS $DRIVEOFF -device8 0 $IECDEVON  +drive8truedrive -virtualdev -autostartprgmode 1 +autostart-handle-tde +autostart-warp
fi

## fsdevice = filesystem
# TDEonly
dotest $EMU none        1   0 $OPTS $DRIVEOFF -device8 1 $IECDEVOFF -drive8truedrive +virtualdev -autostartprgmode 1 +autostart-handle-tde -autostart-warp
dotest $EMU none        1   0 $OPTS $DRIVEOFF -device8 1 $IECDEVOFF -drive8truedrive +virtualdev -autostartprgmode 1 +autostart-handle-tde +autostart-warp
dotest $EMU tde         0 255 $OPTS $DRIVEOFF -device8 1 $IECDEVOFF -drive8truedrive -virtualdev -autostartprgmode 1 +autostart-handle-tde -autostart-warp
dotest $EMU tde         0 255 $OPTS $DRIVEOFF -device8 1 $IECDEVOFF -drive8truedrive -virtualdev -autostartprgmode 1 +autostart-handle-tde +autostart-warp
# none
dotest $EMU none        1   0 $OPTS $DRIVEOFF -device8 1 $IECDEVOFF +drive8truedrive +virtualdev -autostartprgmode 1 +autostart-handle-tde -autostart-warp
dotest $EMU none        1   0 $OPTS $DRIVEOFF -device8 1 $IECDEVOFF +drive8truedrive +virtualdev -autostartprgmode 1 +autostart-handle-tde +autostart-warp
# vfs only
dotest $EMU vfs         1   0 $OPTS $DRIVEOFF -device8 1 $IECDEVOFF +drive8truedrive -virtualdev -autostartprgmode 1 +autostart-handle-tde -autostart-warp
dotest $EMU vfs         1   0 $OPTS $DRIVEOFF -device8 1 $IECDEVOFF +drive8truedrive -virtualdev -autostartprgmode 1 +autostart-handle-tde +autostart-warp
if [ "$IECDEVICE" = "yes" ]; then
dotest $EMU tde         0 255 $OPTS $DRIVEOFF -device8 1 $IECDEVON  -drive8truedrive +virtualdev -autostartprgmode 1 +autostart-handle-tde -autostart-warp
dotest $EMU tde         0 255 $OPTS $DRIVEOFF -device8 1 $IECDEVON  -drive8truedrive +virtualdev -autostartprgmode 1 +autostart-handle-tde +autostart-warp
dotest $EMU tde         0 255 $OPTS $DRIVEOFF -device8 1 $IECDEVON  -drive8truedrive -virtualdev -autostartprgmode 1 +autostart-handle-tde -autostart-warp
dotest $EMU tde         0 255 $OPTS $DRIVEOFF -device8 1 $IECDEVON  -drive8truedrive -virtualdev -autostartprgmode 1 +autostart-handle-tde +autostart-warp
# iecdev only
dotest $EMU vfs         1   0 $OPTS $DRIVEOFF -device8 1 $IECDEVON  +drive8truedrive +virtualdev -autostartprgmode 1 +autostart-handle-tde -autostart-warp
dotest $EMU vfs         1   0 $OPTS $DRIVEOFF -device8 1 $IECDEVON  +drive8truedrive +virtualdev -autostartprgmode 1 +autostart-handle-tde +autostart-warp
dotest $EMU vfs         0 255 $OPTS $DRIVEOFF -device8 1 $IECDEVON  +drive8truedrive -virtualdev -autostartprgmode 1 +autostart-handle-tde -autostart-warp
dotest $EMU vfs         0 255 $OPTS $DRIVEOFF -device8 1 $IECDEVON  +drive8truedrive -virtualdev -autostartprgmode 1 +autostart-handle-tde +autostart-warp
fi

echo "autostart mode 0 (virtual filesystem) - handle TDE"
## fsdevice = none
# TDEonly
dotest $EMU none        1   0 $OPTS $DRIVEOFF -device8 0 $IECDEVOFF -drive8truedrive +virtualdev -autostartprgmode 0 -autostart-handle-tde -autostart-warp
dotest $EMU none        1   0 $OPTS $DRIVEOFF -device8 0 $IECDEVOFF -drive8truedrive +virtualdev -autostartprgmode 0 -autostart-handle-tde +autostart-warp
dotest $EMU tde         0 255 $OPTS $DRIVEOFF -device8 0 $IECDEVOFF -drive8truedrive -virtualdev -autostartprgmode 0 -autostart-handle-tde -autostart-warp
dotest $EMU tde         0 255 $OPTS $DRIVEOFF -device8 0 $IECDEVOFF -drive8truedrive -virtualdev -autostartprgmode 0 -autostart-handle-tde +autostart-warp
# none
dotest $EMU none        0 255 $OPTS $DRIVEOFF -device8 0 $IECDEVOFF +drive8truedrive +virtualdev -autostartprgmode 0 -autostart-handle-tde -autostart-warp
dotest $EMU none        0 255 $OPTS $DRIVEOFF -device8 0 $IECDEVOFF +drive8truedrive +virtualdev -autostartprgmode 0 -autostart-handle-tde +autostart-warp
# vfs only
dotest $EMU none        1   0 $OPTS $DRIVEOFF -device8 0 $IECDEVOFF +drive8truedrive -virtualdev -autostartprgmode 0 -autostart-handle-tde -autostart-warp
dotest $EMU none        1   0 $OPTS $DRIVEOFF -device8 0 $IECDEVOFF +drive8truedrive -virtualdev -autostartprgmode 0 -autostart-handle-tde +autostart-warp
if [ "$IECDEVICE" = "yes" ]; then
dotest $EMU tde         0 255 $OPTS $DRIVEOFF -device8 0 $IECDEVON  -drive8truedrive +virtualdev -autostartprgmode 0 -autostart-handle-tde -autostart-warp
dotest $EMU tde         0 255 $OPTS $DRIVEOFF -device8 0 $IECDEVON  -drive8truedrive +virtualdev -autostartprgmode 0 -autostart-handle-tde +autostart-warp
dotest $EMU tde         0 255 $OPTS $DRIVEOFF -device8 0 $IECDEVON  -drive8truedrive -virtualdev -autostartprgmode 0 -autostart-handle-tde -autostart-warp
dotest $EMU tde         0 255 $OPTS $DRIVEOFF -device8 0 $IECDEVON  -drive8truedrive -virtualdev -autostartprgmode 0 -autostart-handle-tde +autostart-warp
# iecdev only
dotest $EMU none        1   0 $OPTS $DRIVEOFF -device8 0 $IECDEVON  +drive8truedrive +virtualdev -autostartprgmode 0 -autostart-handle-tde -autostart-warp
dotest $EMU none        1   0 $OPTS $DRIVEOFF -device8 0 $IECDEVON  +drive8truedrive +virtualdev -autostartprgmode 0 -autostart-handle-tde +autostart-warp
dotest $EMU vfs         0 255 $OPTS $DRIVEOFF -device8 0 $IECDEVON  +drive8truedrive -virtualdev -autostartprgmode 0 -autostart-handle-tde -autostart-warp
dotest $EMU vfs         0 255 $OPTS $DRIVEOFF -device8 0 $IECDEVON  +drive8truedrive -virtualdev -autostartprgmode 0 -autostart-handle-tde +autostart-warp
fi

## fsdevice = filesystem
# TDEonly
dotest $EMU none        1   0 $OPTS $DRIVEOFF -device8 1 $IECDEVOFF -drive8truedrive +virtualdev -autostartprgmode 0 -autostart-handle-tde -autostart-warp
dotest $EMU none        1   0 $OPTS $DRIVEOFF -device8 1 $IECDEVOFF -drive8truedrive +virtualdev -autostartprgmode 0 -autostart-handle-tde +autostart-warp
dotest $EMU tde         0 255 $OPTS $DRIVEOFF -device8 1 $IECDEVOFF -drive8truedrive -virtualdev -autostartprgmode 0 -autostart-handle-tde -autostart-warp
dotest $EMU tde         0 255 $OPTS $DRIVEOFF -device8 1 $IECDEVOFF -drive8truedrive -virtualdev -autostartprgmode 0 -autostart-handle-tde +autostart-warp
# none
dotest $EMU none        0 255 $OPTS $DRIVEOFF -device8 1 $IECDEVOFF +drive8truedrive +virtualdev -autostartprgmode 0 -autostart-handle-tde -autostart-warp
dotest $EMU none        0 255 $OPTS $DRIVEOFF -device8 1 $IECDEVOFF +drive8truedrive +virtualdev -autostartprgmode 0 -autostart-handle-tde +autostart-warp
# vfs only
dotest $EMU vfs         1   0 $OPTS $DRIVEOFF -device8 1 $IECDEVOFF +drive8truedrive -virtualdev -autostartprgmode 0 -autostart-handle-tde -autostart-warp
dotest $EMU vfs         1   0 $OPTS $DRIVEOFF -device8 1 $IECDEVOFF +drive8truedrive -virtualdev -autostartprgmode 0 -autostart-handle-tde +autostart-warp
if [ "$IECDEVICE" = "yes" ]; then
dotest $EMU tde         0 255 $OPTS $DRIVEOFF -device8 1 $IECDEVON  -drive8truedrive +virtualdev -autostartprgmode 0 -autostart-handle-tde -autostart-warp
dotest $EMU tde         0 255 $OPTS $DRIVEOFF -device8 1 $IECDEVON  -drive8truedrive +virtualdev -autostartprgmode 0 -autostart-handle-tde +autostart-warp
dotest $EMU tde         0 255 $OPTS $DRIVEOFF -device8 1 $IECDEVON  -drive8truedrive -virtualdev -autostartprgmode 0 -autostart-handle-tde -autostart-warp
dotest $EMU tde         0 255 $OPTS $DRIVEOFF -device8 1 $IECDEVON  -drive8truedrive -virtualdev -autostartprgmode 0 -autostart-handle-tde +autostart-warp
# iecdev only
dotest $EMU vfs         1   0 $OPTS $DRIVEOFF -device8 1 $IECDEVON  +drive8truedrive +virtualdev -autostartprgmode 0 -autostart-handle-tde -autostart-warp
dotest $EMU vfs         1   0 $OPTS $DRIVEOFF -device8 1 $IECDEVON  +drive8truedrive +virtualdev -autostartprgmode 0 -autostart-handle-tde +autostart-warp
dotest $EMU vfs         0 255 $OPTS $DRIVEOFF -device8 1 $IECDEVON  +drive8truedrive -virtualdev -autostartprgmode 0 -autostart-handle-tde -autostart-warp
dotest $EMU vfs         0 255 $OPTS $DRIVEOFF -device8 1 $IECDEVON  +drive8truedrive -virtualdev -autostartprgmode 0 -autostart-handle-tde +autostart-warp
fi

echo "autostart mode 1 (inject to RAM) - handle TDE"
## fsdevice = none
# TDEonly
dotest $EMU none        1   0 $OPTS $DRIVEOFF -device8 0 $IECDEVOFF -drive8truedrive +virtualdev -autostartprgmode 1 -autostart-handle-tde -autostart-warp
dotest $EMU none        1   0 $OPTS $DRIVEOFF -device8 0 $IECDEVOFF -drive8truedrive +virtualdev -autostartprgmode 1 -autostart-handle-tde +autostart-warp
dotest $EMU tde         0 255 $OPTS $DRIVEOFF -device8 0 $IECDEVOFF -drive8truedrive -virtualdev -autostartprgmode 1 -autostart-handle-tde -autostart-warp
dotest $EMU tde         0 255 $OPTS $DRIVEOFF -device8 0 $IECDEVOFF -drive8truedrive -virtualdev -autostartprgmode 1 -autostart-handle-tde +autostart-warp
# none
dotest $EMU none        0   0 $OPTS $DRIVEOFF -device8 0 $IECDEVOFF +drive8truedrive +virtualdev -autostartprgmode 1 -autostart-handle-tde -autostart-warp
dotest $EMU none        0   0 $OPTS $DRIVEOFF -device8 0 $IECDEVOFF +drive8truedrive +virtualdev -autostartprgmode 1 -autostart-handle-tde +autostart-warp
# vfs only
dotest $EMU none        1   0 $OPTS $DRIVEOFF -device8 0 $IECDEVOFF +drive8truedrive -virtualdev -autostartprgmode 1 -autostart-handle-tde -autostart-warp
dotest $EMU none        1   0 $OPTS $DRIVEOFF -device8 0 $IECDEVOFF +drive8truedrive -virtualdev -autostartprgmode 1 -autostart-handle-tde +autostart-warp
if [ "$IECDEVICE" = "yes" ]; then
dotest $EMU tde         0 255 $OPTS $DRIVEOFF -device8 0 $IECDEVON  -drive8truedrive +virtualdev -autostartprgmode 1 -autostart-handle-tde -autostart-warp
dotest $EMU tde         0 255 $OPTS $DRIVEOFF -device8 0 $IECDEVON  -drive8truedrive +virtualdev -autostartprgmode 1 -autostart-handle-tde +autostart-warp
dotest $EMU tde         0 255 $OPTS $DRIVEOFF -device8 0 $IECDEVON  -drive8truedrive -virtualdev -autostartprgmode 1 -autostart-handle-tde -autostart-warp
dotest $EMU tde         0 255 $OPTS $DRIVEOFF -device8 0 $IECDEVON  -drive8truedrive -virtualdev -autostartprgmode 1 -autostart-handle-tde +autostart-warp
# iecdev only
dotest $EMU none        1   0 $OPTS $DRIVEOFF -device8 0 $IECDEVON  +drive8truedrive +virtualdev -autostartprgmode 1 -autostart-handle-tde -autostart-warp
dotest $EMU none        1   0 $OPTS $DRIVEOFF -device8 0 $IECDEVON  +drive8truedrive +virtualdev -autostartprgmode 1 -autostart-handle-tde +autostart-warp
dotest $EMU vfs         0 255 $OPTS $DRIVEOFF -device8 0 $IECDEVON  +drive8truedrive -virtualdev -autostartprgmode 1 -autostart-handle-tde -autostart-warp
dotest $EMU vfs         0 255 $OPTS $DRIVEOFF -device8 0 $IECDEVON  +drive8truedrive -virtualdev -autostartprgmode 1 -autostart-handle-tde +autostart-warp
fi

## fsdevice = filesystem
# TDEonly
dotest $EMU none        1   0 $OPTS $DRIVEOFF -device8 1 $IECDEVOFF -drive8truedrive +virtualdev -autostartprgmode 1 -autostart-handle-tde -autostart-warp
dotest $EMU none        1   0 $OPTS $DRIVEOFF -device8 1 $IECDEVOFF -drive8truedrive +virtualdev -autostartprgmode 1 -autostart-handle-tde +autostart-warp
dotest $EMU tde         0 255 $OPTS $DRIVEOFF -device8 1 $IECDEVOFF -drive8truedrive -virtualdev -autostartprgmode 1 -autostart-handle-tde -autostart-warp
dotest $EMU tde         0 255 $OPTS $DRIVEOFF -device8 1 $IECDEVOFF -drive8truedrive -virtualdev -autostartprgmode 1 -autostart-handle-tde +autostart-warp
# none
dotest $EMU none        0   0 $OPTS $DRIVEOFF -device8 1 $IECDEVOFF +drive8truedrive +virtualdev -autostartprgmode 1 -autostart-handle-tde -autostart-warp
dotest $EMU none        0   0 $OPTS $DRIVEOFF -device8 1 $IECDEVOFF +drive8truedrive +virtualdev -autostartprgmode 1 -autostart-handle-tde +autostart-warp
# vfs only
dotest $EMU vfs         1   0 $OPTS $DRIVEOFF -device8 1 $IECDEVOFF +drive8truedrive -virtualdev -autostartprgmode 1 -autostart-handle-tde -autostart-warp
dotest $EMU vfs         1   0 $OPTS $DRIVEOFF -device8 1 $IECDEVOFF +drive8truedrive -virtualdev -autostartprgmode 1 -autostart-handle-tde +autostart-warp
if [ "$IECDEVICE" = "yes" ]; then
dotest $EMU tde         0 255 $OPTS $DRIVEOFF -device8 1 $IECDEVON  -drive8truedrive +virtualdev -autostartprgmode 1 -autostart-handle-tde -autostart-warp
dotest $EMU tde         0 255 $OPTS $DRIVEOFF -device8 1 $IECDEVON  -drive8truedrive +virtualdev -autostartprgmode 1 -autostart-handle-tde +autostart-warp
dotest $EMU tde         0 255 $OPTS $DRIVEOFF -device8 1 $IECDEVON  -drive8truedrive -virtualdev -autostartprgmode 1 -autostart-handle-tde -autostart-warp
dotest $EMU tde         0 255 $OPTS $DRIVEOFF -device8 1 $IECDEVON  -drive8truedrive -virtualdev -autostartprgmode 1 -autostart-handle-tde +autostart-warp
# iecdev only
dotest $EMU vfs         1   0 $OPTS $DRIVEOFF -device8 1 $IECDEVON  +drive8truedrive +virtualdev -autostartprgmode 1 -autostart-handle-tde -autostart-warp
dotest $EMU vfs         1   0 $OPTS $DRIVEOFF -device8 1 $IECDEVON  +drive8truedrive +virtualdev -autostartprgmode 1 -autostart-handle-tde +autostart-warp
dotest $EMU vfs         0 255 $OPTS $DRIVEOFF -device8 1 $IECDEVON  +drive8truedrive -virtualdev -autostartprgmode 1 -autostart-handle-tde -autostart-warp
dotest $EMU vfs         0 255 $OPTS $DRIVEOFF -device8 1 $IECDEVON  +drive8truedrive -virtualdev -autostartprgmode 1 -autostart-handle-tde +autostart-warp
fi

echo "---"
}

function alltests_disk
{
echo $EMU":"$PROGPRE-X.$PROGEXT
dotest $EMU tde-image 1 0 -default $OPTS

# the prg mode should make no difference when we are starting a disk image
# -> the following block repeats 3 times

echo "autostart mode 0 (virtual filesystem) - do not handle TDE"
## fsdevice = none
# TDEonly
dotest $EMU tde-image    1   0 $OPTS $DRIVEON -device8 0 $IECDEVOFF -drive8truedrive +virtualdev -autostartprgmode 0 +autostart-handle-tde -autostart-warp
dotest $EMU tde-image    1   0 $OPTS $DRIVEON -device8 0 $IECDEVOFF -drive8truedrive +virtualdev -autostartprgmode 0 +autostart-handle-tde +autostart-warp
dotest $EMU tde-image    0 255 $OPTS $DRIVEON -device8 0 $IECDEVOFF -drive8truedrive -virtualdev -autostartprgmode 0 +autostart-handle-tde -autostart-warp
dotest $EMU tde-image    0 255 $OPTS $DRIVEON -device8 0 $IECDEVOFF -drive8truedrive -virtualdev -autostartprgmode 0 +autostart-handle-tde +autostart-warp
# none
dotest $EMU none-image   0 255 $OPTS $DRIVEON -device8 0 $IECDEVOFF +drive8truedrive +virtualdev -autostartprgmode 0 +autostart-handle-tde -autostart-warp
dotest $EMU none-image   0 255 $OPTS $DRIVEON -device8 0 $IECDEVOFF +drive8truedrive +virtualdev -autostartprgmode 0 +autostart-handle-tde +autostart-warp
# vfs only
dotest $EMU vdrive-image 1   0 $OPTS $DRIVEON -device8 0 $IECDEVOFF +drive8truedrive -virtualdev -autostartprgmode 0 +autostart-handle-tde -autostart-warp
dotest $EMU vdrive-image 1   0 $OPTS $DRIVEON -device8 0 $IECDEVOFF +drive8truedrive -virtualdev -autostartprgmode 0 +autostart-handle-tde +autostart-warp
if [ "$IECDEVICE" = "yes" ]; then
dotest $EMU tde-image    0 255 $OPTS $DRIVEON -device8 0 $IECDEVON  -drive8truedrive +virtualdev -autostartprgmode 0 +autostart-handle-tde -autostart-warp
dotest $EMU tde-image    0 255 $OPTS $DRIVEON -device8 0 $IECDEVON  -drive8truedrive +virtualdev -autostartprgmode 0 +autostart-handle-tde +autostart-warp
dotest $EMU tde-image    0 255 $OPTS $DRIVEON -device8 0 $IECDEVON  -drive8truedrive -virtualdev -autostartprgmode 0 +autostart-handle-tde -autostart-warp
dotest $EMU tde-image    0 255 $OPTS $DRIVEON -device8 0 $IECDEVON  -drive8truedrive -virtualdev -autostartprgmode 0 +autostart-handle-tde +autostart-warp
# iecdev only
dotest $EMU vdrive-image 1   0 $OPTS $DRIVEON -device8 0 $IECDEVON  +drive8truedrive +virtualdev -autostartprgmode 0 +autostart-handle-tde -autostart-warp
dotest $EMU vdrive-image 1   0 $OPTS $DRIVEON -device8 0 $IECDEVON  +drive8truedrive +virtualdev -autostartprgmode 0 +autostart-handle-tde +autostart-warp
dotest $EMU vdrive-image 0 255 $OPTS $DRIVEON -device8 0 $IECDEVON  +drive8truedrive -virtualdev -autostartprgmode 0 +autostart-handle-tde -autostart-warp
dotest $EMU vdrive-image 0 255 $OPTS $DRIVEON -device8 0 $IECDEVON  +drive8truedrive -virtualdev -autostartprgmode 0 +autostart-handle-tde +autostart-warp
fi

## fsdevice = filesystem
# TDEonly
dotest $EMU tde-image    1   0 $OPTS $DRIVEON -device8 1 $IECDEVOFF -drive8truedrive +virtualdev -autostartprgmode 0 +autostart-handle-tde -autostart-warp
dotest $EMU tde-image    1   0 $OPTS $DRIVEON -device8 1 $IECDEVOFF -drive8truedrive +virtualdev -autostartprgmode 0 +autostart-handle-tde +autostart-warp
dotest $EMU tde-image    0 255 $OPTS $DRIVEON -device8 1 $IECDEVOFF -drive8truedrive -virtualdev -autostartprgmode 0 +autostart-handle-tde -autostart-warp
dotest $EMU tde-image    0 255 $OPTS $DRIVEON -device8 1 $IECDEVOFF -drive8truedrive -virtualdev -autostartprgmode 0 +autostart-handle-tde +autostart-warp
# none
dotest $EMU none-image   0 255 $OPTS $DRIVEON -device8 1 $IECDEVOFF +drive8truedrive +virtualdev -autostartprgmode 0 +autostart-handle-tde -autostart-warp
dotest $EMU none-image   0 255 $OPTS $DRIVEON -device8 1 $IECDEVOFF +drive8truedrive +virtualdev -autostartprgmode 0 +autostart-handle-tde +autostart-warp
# vfs only
dotest $EMU vdrive-image 1   0 $OPTS $DRIVEON -device8 1 $IECDEVOFF +drive8truedrive -virtualdev -autostartprgmode 0 +autostart-handle-tde -autostart-warp
dotest $EMU vdrive-image 1   0 $OPTS $DRIVEON -device8 1 $IECDEVOFF +drive8truedrive -virtualdev -autostartprgmode 0 +autostart-handle-tde +autostart-warp
if [ "$IECDEVICE" = "yes" ]; then
dotest $EMU tde-image    0 255 $OPTS $DRIVEON -device8 1 $IECDEVON  -drive8truedrive +virtualdev -autostartprgmode 0 +autostart-handle-tde -autostart-warp
dotest $EMU tde-image    0 255 $OPTS $DRIVEON -device8 1 $IECDEVON  -drive8truedrive +virtualdev -autostartprgmode 0 +autostart-handle-tde +autostart-warp
dotest $EMU tde-image    0 255 $OPTS $DRIVEON -device8 1 $IECDEVON  -drive8truedrive -virtualdev -autostartprgmode 0 +autostart-handle-tde -autostart-warp
dotest $EMU tde-image    0 255 $OPTS $DRIVEON -device8 1 $IECDEVON  -drive8truedrive -virtualdev -autostartprgmode 0 +autostart-handle-tde +autostart-warp
# iecdev only
dotest $EMU vdrive-image 1   0 $OPTS $DRIVEON -device8 1 $IECDEVON  +drive8truedrive +virtualdev -autostartprgmode 0 +autostart-handle-tde -autostart-warp
dotest $EMU vdrive-image 1   0 $OPTS $DRIVEON -device8 1 $IECDEVON  +drive8truedrive +virtualdev -autostartprgmode 0 +autostart-handle-tde +autostart-warp
dotest $EMU vdrive-image 0 255 $OPTS $DRIVEON -device8 1 $IECDEVON  +drive8truedrive -virtualdev -autostartprgmode 0 +autostart-handle-tde -autostart-warp
dotest $EMU vdrive-image 0 255 $OPTS $DRIVEON -device8 1 $IECDEVON  +drive8truedrive -virtualdev -autostartprgmode 0 +autostart-handle-tde +autostart-warp
fi

echo "autostart mode 1 (inject to RAM) - do not handle TDE"

## fsdevice = none
# TDEonly
dotest $EMU tde-image    1   0 $OPTS $DRIVEON -device8 0 $IECDEVOFF -drive8truedrive +virtualdev -autostartprgmode 1 +autostart-handle-tde -autostart-warp
dotest $EMU tde-image    1   0 $OPTS $DRIVEON -device8 0 $IECDEVOFF -drive8truedrive +virtualdev -autostartprgmode 1 +autostart-handle-tde +autostart-warp
dotest $EMU tde-image    0 255 $OPTS $DRIVEON -device8 0 $IECDEVOFF -drive8truedrive -virtualdev -autostartprgmode 1 +autostart-handle-tde -autostart-warp
dotest $EMU tde-image    0 255 $OPTS $DRIVEON -device8 0 $IECDEVOFF -drive8truedrive -virtualdev -autostartprgmode 1 +autostart-handle-tde +autostart-warp
# none
dotest $EMU none-image   0 255 $OPTS $DRIVEON -device8 0 $IECDEVOFF +drive8truedrive +virtualdev -autostartprgmode 1 +autostart-handle-tde -autostart-warp
dotest $EMU none-image   0 255 $OPTS $DRIVEON -device8 0 $IECDEVOFF +drive8truedrive +virtualdev -autostartprgmode 1 +autostart-handle-tde +autostart-warp
# vfs only
dotest $EMU vdrive-image 1   0 $OPTS $DRIVEON -device8 0 $IECDEVOFF +drive8truedrive -virtualdev -autostartprgmode 1 +autostart-handle-tde -autostart-warp
dotest $EMU vdrive-image 1   0 $OPTS $DRIVEON -device8 0 $IECDEVOFF +drive8truedrive -virtualdev -autostartprgmode 1 +autostart-handle-tde +autostart-warp
if [ "$IECDEVICE" = "yes" ]; then
dotest $EMU tde-image    0 255 $OPTS $DRIVEON -device8 0 $IECDEVON  -drive8truedrive +virtualdev -autostartprgmode 1 +autostart-handle-tde -autostart-warp
dotest $EMU tde-image    0 255 $OPTS $DRIVEON -device8 0 $IECDEVON  -drive8truedrive +virtualdev -autostartprgmode 1 +autostart-handle-tde +autostart-warp
dotest $EMU tde-image    0 255 $OPTS $DRIVEON -device8 0 $IECDEVON  -drive8truedrive -virtualdev -autostartprgmode 1 +autostart-handle-tde -autostart-warp
dotest $EMU tde-image    0 255 $OPTS $DRIVEON -device8 0 $IECDEVON  -drive8truedrive -virtualdev -autostartprgmode 1 +autostart-handle-tde +autostart-warp
# iecdev only
dotest $EMU vdrive-image 1   0 $OPTS $DRIVEON -device8 0 $IECDEVON  +drive8truedrive +virtualdev -autostartprgmode 1 +autostart-handle-tde -autostart-warp
dotest $EMU vdrive-image 1   0 $OPTS $DRIVEON -device8 0 $IECDEVON  +drive8truedrive +virtualdev -autostartprgmode 1 +autostart-handle-tde +autostart-warp
dotest $EMU vdrive-image 0 255 $OPTS $DRIVEON -device8 0 $IECDEVON  +drive8truedrive -virtualdev -autostartprgmode 1 +autostart-handle-tde -autostart-warp
dotest $EMU vdrive-image 0 255 $OPTS $DRIVEON -device8 0 $IECDEVON  +drive8truedrive -virtualdev -autostartprgmode 1 +autostart-handle-tde +autostart-warp
fi

## fsdevice = filesystem
# TDEonly
dotest $EMU tde-image    1   0 $OPTS $DRIVEON -device8 1 $IECDEVOFF -drive8truedrive +virtualdev -autostartprgmode 1 +autostart-handle-tde -autostart-warp
dotest $EMU tde-image    1   0 $OPTS $DRIVEON -device8 1 $IECDEVOFF -drive8truedrive +virtualdev -autostartprgmode 1 +autostart-handle-tde +autostart-warp
dotest $EMU tde-image    0 255 $OPTS $DRIVEON -device8 1 $IECDEVOFF -drive8truedrive -virtualdev -autostartprgmode 1 +autostart-handle-tde -autostart-warp
dotest $EMU tde-image    0 255 $OPTS $DRIVEON -device8 1 $IECDEVOFF -drive8truedrive -virtualdev -autostartprgmode 1 +autostart-handle-tde +autostart-warp
# none
dotest $EMU none-image   0 255 $OPTS $DRIVEON -device8 1 $IECDEVOFF +drive8truedrive +virtualdev -autostartprgmode 1 +autostart-handle-tde -autostart-warp
dotest $EMU none-image   0 255 $OPTS $DRIVEON -device8 1 $IECDEVOFF +drive8truedrive +virtualdev -autostartprgmode 1 +autostart-handle-tde +autostart-warp
# vfs only
dotest $EMU vdrive-image 1   0 $OPTS $DRIVEON -device8 1 $IECDEVOFF +drive8truedrive -virtualdev -autostartprgmode 1 +autostart-handle-tde -autostart-warp
dotest $EMU vdrive-image 1   0 $OPTS $DRIVEON -device8 1 $IECDEVOFF +drive8truedrive -virtualdev -autostartprgmode 1 +autostart-handle-tde +autostart-warp
if [ "$IECDEVICE" = "yes" ]; then
dotest $EMU tde-image    0 255 $OPTS $DRIVEON -device8 1 $IECDEVON  -drive8truedrive +virtualdev -autostartprgmode 1 +autostart-handle-tde -autostart-warp
dotest $EMU tde-image    0 255 $OPTS $DRIVEON -device8 1 $IECDEVON  -drive8truedrive +virtualdev -autostartprgmode 1 +autostart-handle-tde +autostart-warp
dotest $EMU tde-image    0 255 $OPTS $DRIVEON -device8 1 $IECDEVON  -drive8truedrive -virtualdev -autostartprgmode 1 +autostart-handle-tde -autostart-warp
dotest $EMU tde-image    0 255 $OPTS $DRIVEON -device8 1 $IECDEVON  -drive8truedrive -virtualdev -autostartprgmode 1 +autostart-handle-tde +autostart-warp
# iecdev only
dotest $EMU vdrive-image 1   0 $OPTS $DRIVEON -device8 1 $IECDEVON  +drive8truedrive +virtualdev -autostartprgmode 1 +autostart-handle-tde -autostart-warp
dotest $EMU vdrive-image 1   0 $OPTS $DRIVEON -device8 1 $IECDEVON  +drive8truedrive +virtualdev -autostartprgmode 1 +autostart-handle-tde +autostart-warp
dotest $EMU vdrive-image 0 255 $OPTS $DRIVEON -device8 1 $IECDEVON  +drive8truedrive -virtualdev -autostartprgmode 1 +autostart-handle-tde -autostart-warp
dotest $EMU vdrive-image 0 255 $OPTS $DRIVEON -device8 1 $IECDEVON  +drive8truedrive -virtualdev -autostartprgmode 1 +autostart-handle-tde +autostart-warp
fi

echo "autostart mode 2 (copy to disk image) - do not handle TDE"

## fsdevice = none
# TDEonly
dotest $EMU tde-image    1   0 $OPTS $DRIVEON -device8 0 $IECDEVOFF -drive8truedrive +virtualdev -autostartprgmode 2 +autostart-handle-tde -autostart-warp
dotest $EMU tde-image    1   0 $OPTS $DRIVEON -device8 0 $IECDEVOFF -drive8truedrive +virtualdev -autostartprgmode 2 +autostart-handle-tde +autostart-warp
dotest $EMU tde-image    0 255 $OPTS $DRIVEON -device8 0 $IECDEVOFF -drive8truedrive -virtualdev -autostartprgmode 2 +autostart-handle-tde -autostart-warp
dotest $EMU tde-image    0 255 $OPTS $DRIVEON -device8 0 $IECDEVOFF -drive8truedrive -virtualdev -autostartprgmode 2 +autostart-handle-tde +autostart-warp
# none
dotest $EMU none-image   0 255 $OPTS $DRIVEON -device8 0 $IECDEVOFF +drive8truedrive +virtualdev -autostartprgmode 2 +autostart-handle-tde -autostart-warp
dotest $EMU none-image   0 255 $OPTS $DRIVEON -device8 0 $IECDEVOFF +drive8truedrive +virtualdev -autostartprgmode 2 +autostart-handle-tde +autostart-warp
# vfs only
dotest $EMU vdrive-image 1   0 $OPTS $DRIVEON -device8 0 $IECDEVOFF +drive8truedrive -virtualdev -autostartprgmode 2 +autostart-handle-tde -autostart-warp
dotest $EMU vdrive-image 1   0 $OPTS $DRIVEON -device8 0 $IECDEVOFF +drive8truedrive -virtualdev -autostartprgmode 2 +autostart-handle-tde +autostart-warp
if [ "$IECDEVICE" = "yes" ]; then
dotest $EMU tde-image    0 255 $OPTS $DRIVEON -device8 0 $IECDEVON  -drive8truedrive +virtualdev -autostartprgmode 2 +autostart-handle-tde -autostart-warp
dotest $EMU tde-image    0 255 $OPTS $DRIVEON -device8 0 $IECDEVON  -drive8truedrive +virtualdev -autostartprgmode 2 +autostart-handle-tde +autostart-warp
dotest $EMU tde-image    0 255 $OPTS $DRIVEON -device8 0 $IECDEVON  -drive8truedrive -virtualdev -autostartprgmode 2 +autostart-handle-tde -autostart-warp
dotest $EMU tde-image    0 255 $OPTS $DRIVEON -device8 0 $IECDEVON  -drive8truedrive -virtualdev -autostartprgmode 2 +autostart-handle-tde +autostart-warp
# iecdev only
dotest $EMU vdrive-image 1   0 $OPTS $DRIVEON -device8 0 $IECDEVON  +drive8truedrive +virtualdev -autostartprgmode 2 +autostart-handle-tde -autostart-warp
dotest $EMU vdrive-image 1   0 $OPTS $DRIVEON -device8 0 $IECDEVON  +drive8truedrive +virtualdev -autostartprgmode 2 +autostart-handle-tde +autostart-warp
dotest $EMU vdrive-image 0 255 $OPTS $DRIVEON -device8 0 $IECDEVON  +drive8truedrive -virtualdev -autostartprgmode 2 +autostart-handle-tde -autostart-warp
dotest $EMU vdrive-image 0 255 $OPTS $DRIVEON -device8 0 $IECDEVON  +drive8truedrive -virtualdev -autostartprgmode 2 +autostart-handle-tde +autostart-warp
fi

## fsdevice = filesystem
# TDEonly
dotest $EMU tde-image    1   0 $OPTS $DRIVEON -device8 1 $IECDEVOFF -drive8truedrive +virtualdev -autostartprgmode 2 +autostart-handle-tde -autostart-warp
dotest $EMU tde-image    1   0 $OPTS $DRIVEON -device8 1 $IECDEVOFF -drive8truedrive +virtualdev -autostartprgmode 2 +autostart-handle-tde +autostart-warp
dotest $EMU tde-image    0 255 $OPTS $DRIVEON -device8 1 $IECDEVOFF -drive8truedrive -virtualdev -autostartprgmode 2 +autostart-handle-tde -autostart-warp
dotest $EMU tde-image    0 255 $OPTS $DRIVEON -device8 1 $IECDEVOFF -drive8truedrive -virtualdev -autostartprgmode 2 +autostart-handle-tde +autostart-warp
# none
dotest $EMU none-image   0 255 $OPTS $DRIVEON -device8 1 $IECDEVOFF +drive8truedrive +virtualdev -autostartprgmode 2 +autostart-handle-tde -autostart-warp
dotest $EMU none-image   0 255 $OPTS $DRIVEON -device8 1 $IECDEVOFF +drive8truedrive +virtualdev -autostartprgmode 2 +autostart-handle-tde +autostart-warp
# vfs only
dotest $EMU vdrive-image 1   0 $OPTS $DRIVEON -device8 1 $IECDEVOFF +drive8truedrive -virtualdev -autostartprgmode 2 +autostart-handle-tde -autostart-warp
dotest $EMU vdrive-image 1   0 $OPTS $DRIVEON -device8 1 $IECDEVOFF +drive8truedrive -virtualdev -autostartprgmode 2 +autostart-handle-tde +autostart-warp
if [ "$IECDEVICE" = "yes" ]; then
dotest $EMU tde-image    0 255 $OPTS $DRIVEON -device8 1 $IECDEVON  -drive8truedrive +virtualdev -autostartprgmode 2 +autostart-handle-tde -autostart-warp
dotest $EMU tde-image    0 255 $OPTS $DRIVEON -device8 1 $IECDEVON  -drive8truedrive +virtualdev -autostartprgmode 2 +autostart-handle-tde +autostart-warp
dotest $EMU tde-image    0 255 $OPTS $DRIVEON -device8 1 $IECDEVON  -drive8truedrive -virtualdev -autostartprgmode 2 +autostart-handle-tde -autostart-warp
dotest $EMU tde-image    0 255 $OPTS $DRIVEON -device8 1 $IECDEVON  -drive8truedrive -virtualdev -autostartprgmode 2 +autostart-handle-tde +autostart-warp
# iecdev only
dotest $EMU vdrive-image 1   0 $OPTS $DRIVEON -device8 1 $IECDEVON  +drive8truedrive +virtualdev -autostartprgmode 2 +autostart-handle-tde -autostart-warp
dotest $EMU vdrive-image 1   0 $OPTS $DRIVEON -device8 1 $IECDEVON  +drive8truedrive +virtualdev -autostartprgmode 2 +autostart-handle-tde +autostart-warp
dotest $EMU vdrive-image 0 255 $OPTS $DRIVEON -device8 1 $IECDEVON  +drive8truedrive -virtualdev -autostartprgmode 2 +autostart-handle-tde -autostart-warp
dotest $EMU vdrive-image 0 255 $OPTS $DRIVEON -device8 1 $IECDEVON  +drive8truedrive -virtualdev -autostartprgmode 2 +autostart-handle-tde +autostart-warp
fi

# "handle tde at autostart" will let autostart disable TDE in favour if virtual devices
# however, this does not change anything in the final state, so again all of the above repeats

echo "autostart mode 0 (virtual filesystem) - handle TDE"

## fsdevice = none
# TDEonly
dotest $EMU tde-image    1   0 $OPTS $DRIVEON -device8 0 $IECDEVOFF -drive8truedrive +virtualdev -autostartprgmode 0 -autostart-handle-tde -autostart-warp
dotest $EMU tde-image    1   0 $OPTS $DRIVEON -device8 0 $IECDEVOFF -drive8truedrive +virtualdev -autostartprgmode 0 -autostart-handle-tde +autostart-warp
dotest $EMU tde-image    0 255 $OPTS $DRIVEON -device8 0 $IECDEVOFF -drive8truedrive -virtualdev -autostartprgmode 0 -autostart-handle-tde -autostart-warp
dotest $EMU tde-image    0 255 $OPTS $DRIVEON -device8 0 $IECDEVOFF -drive8truedrive -virtualdev -autostartprgmode 0 -autostart-handle-tde +autostart-warp
# none
dotest $EMU none-image   0 255 $OPTS $DRIVEON -device8 0 $IECDEVOFF +drive8truedrive +virtualdev -autostartprgmode 0 -autostart-handle-tde -autostart-warp
dotest $EMU none-image   0 255 $OPTS $DRIVEON -device8 0 $IECDEVOFF +drive8truedrive +virtualdev -autostartprgmode 0 -autostart-handle-tde +autostart-warp
# vfs only
dotest $EMU vdrive-image 1   0 $OPTS $DRIVEON -device8 0 $IECDEVOFF +drive8truedrive -virtualdev -autostartprgmode 0 -autostart-handle-tde -autostart-warp
dotest $EMU vdrive-image 1   0 $OPTS $DRIVEON -device8 0 $IECDEVOFF +drive8truedrive -virtualdev -autostartprgmode 0 -autostart-handle-tde +autostart-warp
if [ "$IECDEVICE" = "yes" ]; then
dotest $EMU tde-image    0 255 $OPTS $DRIVEON -device8 0 $IECDEVON  -drive8truedrive +virtualdev -autostartprgmode 0 -autostart-handle-tde -autostart-warp
dotest $EMU tde-image    0 255 $OPTS $DRIVEON -device8 0 $IECDEVON  -drive8truedrive +virtualdev -autostartprgmode 0 -autostart-handle-tde +autostart-warp
dotest $EMU tde-image    0 255 $OPTS $DRIVEON -device8 0 $IECDEVON  -drive8truedrive -virtualdev -autostartprgmode 0 -autostart-handle-tde -autostart-warp
dotest $EMU tde-image    0 255 $OPTS $DRIVEON -device8 0 $IECDEVON  -drive8truedrive -virtualdev -autostartprgmode 0 -autostart-handle-tde +autostart-warp
# iecdev only
dotest $EMU vdrive-image 1   0 $OPTS $DRIVEON -device8 0 $IECDEVON  +drive8truedrive +virtualdev -autostartprgmode 0 -autostart-handle-tde -autostart-warp
dotest $EMU vdrive-image 1   0 $OPTS $DRIVEON -device8 0 $IECDEVON  +drive8truedrive +virtualdev -autostartprgmode 0 -autostart-handle-tde +autostart-warp
dotest $EMU vdrive-image 0 255 $OPTS $DRIVEON -device8 0 $IECDEVON  +drive8truedrive -virtualdev -autostartprgmode 0 -autostart-handle-tde -autostart-warp
dotest $EMU vdrive-image 0 255 $OPTS $DRIVEON -device8 0 $IECDEVON  +drive8truedrive -virtualdev -autostartprgmode 0 -autostart-handle-tde +autostart-warp
fi

## fsdevice = filesystem
# TDEonly
dotest $EMU tde-image    1   0 $OPTS $DRIVEON -device8 1 $IECDEVOFF -drive8truedrive +virtualdev -autostartprgmode 0 -autostart-handle-tde -autostart-warp
dotest $EMU tde-image    1   0 $OPTS $DRIVEON -device8 1 $IECDEVOFF -drive8truedrive +virtualdev -autostartprgmode 0 -autostart-handle-tde +autostart-warp
dotest $EMU tde-image    0 255 $OPTS $DRIVEON -device8 1 $IECDEVOFF -drive8truedrive -virtualdev -autostartprgmode 0 -autostart-handle-tde -autostart-warp
dotest $EMU tde-image    0 255 $OPTS $DRIVEON -device8 1 $IECDEVOFF -drive8truedrive -virtualdev -autostartprgmode 0 -autostart-handle-tde +autostart-warp
# none
dotest $EMU none-image   0 255 $OPTS $DRIVEON -device8 1 $IECDEVOFF +drive8truedrive +virtualdev -autostartprgmode 0 -autostart-handle-tde -autostart-warp
dotest $EMU none-image   0 255 $OPTS $DRIVEON -device8 1 $IECDEVOFF +drive8truedrive +virtualdev -autostartprgmode 0 -autostart-handle-tde +autostart-warp
# vfs only
dotest $EMU vdrive-image 1   0 $OPTS $DRIVEON -device8 1 $IECDEVOFF +drive8truedrive -virtualdev -autostartprgmode 0 -autostart-handle-tde -autostart-warp
dotest $EMU vdrive-image 1   0 $OPTS $DRIVEON -device8 1 $IECDEVOFF +drive8truedrive -virtualdev -autostartprgmode 0 -autostart-handle-tde +autostart-warp
if [ "$IECDEVICE" = "yes" ]; then
dotest $EMU tde-image    0 255 $OPTS $DRIVEON -device8 1 $IECDEVON  -drive8truedrive +virtualdev -autostartprgmode 0 -autostart-handle-tde -autostart-warp
dotest $EMU tde-image    0 255 $OPTS $DRIVEON -device8 1 $IECDEVON  -drive8truedrive +virtualdev -autostartprgmode 0 -autostart-handle-tde +autostart-warp
dotest $EMU tde-image    0 255 $OPTS $DRIVEON -device8 1 $IECDEVON  -drive8truedrive -virtualdev -autostartprgmode 0 -autostart-handle-tde -autostart-warp
dotest $EMU tde-image    0 255 $OPTS $DRIVEON -device8 1 $IECDEVON  -drive8truedrive -virtualdev -autostartprgmode 0 -autostart-handle-tde +autostart-warp
# iecdev only
dotest $EMU vdrive-image 1   0 $OPTS $DRIVEON -device8 1 $IECDEVON  +drive8truedrive +virtualdev -autostartprgmode 0 -autostart-handle-tde -autostart-warp
dotest $EMU vdrive-image 1   0 $OPTS $DRIVEON -device8 1 $IECDEVON  +drive8truedrive +virtualdev -autostartprgmode 0 -autostart-handle-tde +autostart-warp
dotest $EMU vdrive-image 0 255 $OPTS $DRIVEON -device8 1 $IECDEVON  +drive8truedrive -virtualdev -autostartprgmode 0 -autostart-handle-tde -autostart-warp
dotest $EMU vdrive-image 0 255 $OPTS $DRIVEON -device8 1 $IECDEVON  +drive8truedrive -virtualdev -autostartprgmode 0 -autostart-handle-tde +autostart-warp
fi

echo "autostart mode 1 (inject to RAM) - handle TDE"

## fsdevice = none
# TDEonly
dotest $EMU tde-image    1   0 $OPTS $DRIVEON -device8 0 $IECDEVOFF -drive8truedrive +virtualdev -autostartprgmode 1 -autostart-handle-tde -autostart-warp
dotest $EMU tde-image    1   0 $OPTS $DRIVEON -device8 0 $IECDEVOFF -drive8truedrive +virtualdev -autostartprgmode 1 -autostart-handle-tde +autostart-warp
dotest $EMU tde-image    0 255 $OPTS $DRIVEON -device8 0 $IECDEVOFF -drive8truedrive -virtualdev -autostartprgmode 1 -autostart-handle-tde -autostart-warp
dotest $EMU tde-image    0 255 $OPTS $DRIVEON -device8 0 $IECDEVOFF -drive8truedrive -virtualdev -autostartprgmode 1 -autostart-handle-tde +autostart-warp
# none
dotest $EMU none-image   0 255 $OPTS $DRIVEON -device8 0 $IECDEVOFF +drive8truedrive +virtualdev -autostartprgmode 1 -autostart-handle-tde -autostart-warp
dotest $EMU none-image   0 255 $OPTS $DRIVEON -device8 0 $IECDEVOFF +drive8truedrive +virtualdev -autostartprgmode 1 -autostart-handle-tde +autostart-warp
# vfs only
dotest $EMU vdrive-image 1   0 $OPTS $DRIVEON -device8 0 $IECDEVOFF +drive8truedrive -virtualdev -autostartprgmode 1 -autostart-handle-tde -autostart-warp
dotest $EMU vdrive-image 1   0 $OPTS $DRIVEON -device8 0 $IECDEVOFF +drive8truedrive -virtualdev -autostartprgmode 1 -autostart-handle-tde +autostart-warp
if [ "$IECDEVICE" = "yes" ]; then
dotest $EMU tde-image    0 255 $OPTS $DRIVEON -device8 0 $IECDEVON  -drive8truedrive +virtualdev -autostartprgmode 1 -autostart-handle-tde -autostart-warp
dotest $EMU tde-image    0 255 $OPTS $DRIVEON -device8 0 $IECDEVON  -drive8truedrive +virtualdev -autostartprgmode 1 -autostart-handle-tde +autostart-warp
dotest $EMU tde-image    0 255 $OPTS $DRIVEON -device8 0 $IECDEVON  -drive8truedrive -virtualdev -autostartprgmode 1 -autostart-handle-tde -autostart-warp
dotest $EMU tde-image    0 255 $OPTS $DRIVEON -device8 0 $IECDEVON  -drive8truedrive -virtualdev -autostartprgmode 1 -autostart-handle-tde +autostart-warp
# iecdev only
dotest $EMU vdrive-image 1   0 $OPTS $DRIVEON -device8 0 $IECDEVON  +drive8truedrive +virtualdev -autostartprgmode 1 -autostart-handle-tde -autostart-warp
dotest $EMU vdrive-image 1   0 $OPTS $DRIVEON -device8 0 $IECDEVON  +drive8truedrive +virtualdev -autostartprgmode 1 -autostart-handle-tde +autostart-warp
dotest $EMU vdrive-image 0 255 $OPTS $DRIVEON -device8 0 $IECDEVON  +drive8truedrive -virtualdev -autostartprgmode 1 -autostart-handle-tde -autostart-warp
dotest $EMU vdrive-image 0 255 $OPTS $DRIVEON -device8 0 $IECDEVON  +drive8truedrive -virtualdev -autostartprgmode 1 -autostart-handle-tde +autostart-warp
fi

## fsdevice = filesystem
# TDEonly
dotest $EMU tde-image    1   0 $OPTS $DRIVEON -device8 1 $IECDEVOFF -drive8truedrive +virtualdev -autostartprgmode 1 -autostart-handle-tde -autostart-warp
dotest $EMU tde-image    1   0 $OPTS $DRIVEON -device8 1 $IECDEVOFF -drive8truedrive +virtualdev -autostartprgmode 1 -autostart-handle-tde +autostart-warp
dotest $EMU tde-image    0 255 $OPTS $DRIVEON -device8 1 $IECDEVOFF -drive8truedrive -virtualdev -autostartprgmode 1 -autostart-handle-tde -autostart-warp
dotest $EMU tde-image    0 255 $OPTS $DRIVEON -device8 1 $IECDEVOFF -drive8truedrive -virtualdev -autostartprgmode 1 -autostart-handle-tde +autostart-warp
# none
dotest $EMU none-image   0 255 $OPTS $DRIVEON -device8 1 $IECDEVOFF +drive8truedrive +virtualdev -autostartprgmode 1 -autostart-handle-tde -autostart-warp
dotest $EMU none-image   0 255 $OPTS $DRIVEON -device8 1 $IECDEVOFF +drive8truedrive +virtualdev -autostartprgmode 1 -autostart-handle-tde +autostart-warp
# vfs only
dotest $EMU vdrive-image 1   0 $OPTS $DRIVEON -device8 1 $IECDEVOFF +drive8truedrive -virtualdev -autostartprgmode 1 -autostart-handle-tde -autostart-warp
dotest $EMU vdrive-image 1   0 $OPTS $DRIVEON -device8 1 $IECDEVOFF +drive8truedrive -virtualdev -autostartprgmode 1 -autostart-handle-tde +autostart-warp
if [ "$IECDEVICE" = "yes" ]; then
dotest $EMU tde-image    0 255 $OPTS $DRIVEON -device8 1 $IECDEVON  -drive8truedrive +virtualdev -autostartprgmode 1 -autostart-handle-tde -autostart-warp
dotest $EMU tde-image    0 255 $OPTS $DRIVEON -device8 1 $IECDEVON  -drive8truedrive +virtualdev -autostartprgmode 1 -autostart-handle-tde +autostart-warp
dotest $EMU tde-image    0 255 $OPTS $DRIVEON -device8 1 $IECDEVON  -drive8truedrive -virtualdev -autostartprgmode 1 -autostart-handle-tde -autostart-warp
dotest $EMU tde-image    0 255 $OPTS $DRIVEON -device8 1 $IECDEVON  -drive8truedrive -virtualdev -autostartprgmode 1 -autostart-handle-tde +autostart-warp
# iecdev only
dotest $EMU vdrive-image 1   0 $OPTS $DRIVEON -device8 1 $IECDEVON  +drive8truedrive +virtualdev -autostartprgmode 1 -autostart-handle-tde -autostart-warp
dotest $EMU vdrive-image 1   0 $OPTS $DRIVEON -device8 1 $IECDEVON  +drive8truedrive +virtualdev -autostartprgmode 1 -autostart-handle-tde +autostart-warp
dotest $EMU vdrive-image 0 255 $OPTS $DRIVEON -device8 1 $IECDEVON  +drive8truedrive -virtualdev -autostartprgmode 1 -autostart-handle-tde -autostart-warp
dotest $EMU vdrive-image 0 255 $OPTS $DRIVEON -device8 1 $IECDEVON  +drive8truedrive -virtualdev -autostartprgmode 1 -autostart-handle-tde +autostart-warp
fi

echo "autostart mode 2 (copy to disk image) - handle TDE"

## fsdevice = none
# TDEonly
dotest $EMU tde-image    1   0 $OPTS $DRIVEON -device8 0 $IECDEVOFF -drive8truedrive +virtualdev -autostartprgmode 2 -autostart-handle-tde -autostart-warp
dotest $EMU tde-image    1   0 $OPTS $DRIVEON -device8 0 $IECDEVOFF -drive8truedrive +virtualdev -autostartprgmode 2 -autostart-handle-tde +autostart-warp
dotest $EMU tde-image    0 255 $OPTS $DRIVEON -device8 0 $IECDEVOFF -drive8truedrive -virtualdev -autostartprgmode 2 -autostart-handle-tde -autostart-warp
dotest $EMU tde-image    0 255 $OPTS $DRIVEON -device8 0 $IECDEVOFF -drive8truedrive -virtualdev -autostartprgmode 2 -autostart-handle-tde +autostart-warp
# none
dotest $EMU none-image   0 255 $OPTS $DRIVEON -device8 0 $IECDEVOFF +drive8truedrive +virtualdev -autostartprgmode 2 -autostart-handle-tde -autostart-warp
dotest $EMU none-image   0 255 $OPTS $DRIVEON -device8 0 $IECDEVOFF +drive8truedrive +virtualdev -autostartprgmode 2 -autostart-handle-tde +autostart-warp
# vfs only
dotest $EMU vdrive-image 1   0 $OPTS $DRIVEON -device8 0 $IECDEVOFF +drive8truedrive -virtualdev -autostartprgmode 2 -autostart-handle-tde -autostart-warp
dotest $EMU vdrive-image 1   0 $OPTS $DRIVEON -device8 0 $IECDEVOFF +drive8truedrive -virtualdev -autostartprgmode 2 -autostart-handle-tde +autostart-warp
if [ "$IECDEVICE" = "yes" ]; then
dotest $EMU tde-image    0 255 $OPTS $DRIVEON -device8 0 $IECDEVON  -drive8truedrive +virtualdev -autostartprgmode 2 -autostart-handle-tde -autostart-warp
dotest $EMU tde-image    0 255 $OPTS $DRIVEON -device8 0 $IECDEVON  -drive8truedrive +virtualdev -autostartprgmode 2 -autostart-handle-tde +autostart-warp
dotest $EMU tde-image    0 255 $OPTS $DRIVEON -device8 0 $IECDEVON  -drive8truedrive -virtualdev -autostartprgmode 2 -autostart-handle-tde -autostart-warp
dotest $EMU tde-image    0 255 $OPTS $DRIVEON -device8 0 $IECDEVON  -drive8truedrive -virtualdev -autostartprgmode 2 -autostart-handle-tde +autostart-warp
# iecdev only
dotest $EMU vdrive-image 1   0 $OPTS $DRIVEON -device8 0 $IECDEVON  +drive8truedrive +virtualdev -autostartprgmode 2 -autostart-handle-tde -autostart-warp
dotest $EMU vdrive-image 1   0 $OPTS $DRIVEON -device8 0 $IECDEVON  +drive8truedrive +virtualdev -autostartprgmode 2 -autostart-handle-tde +autostart-warp
dotest $EMU vdrive-image 0 255 $OPTS $DRIVEON -device8 0 $IECDEVON  +drive8truedrive -virtualdev -autostartprgmode 2 -autostart-handle-tde -autostart-warp
dotest $EMU vdrive-image 0 255 $OPTS $DRIVEON -device8 0 $IECDEVON  +drive8truedrive -virtualdev -autostartprgmode 2 -autostart-handle-tde +autostart-warp
fi

## fsdevice = filesystem
# TDEonly
dotest $EMU tde-image    1   0 $OPTS $DRIVEON -device8 1 $IECDEVOFF -drive8truedrive +virtualdev -autostartprgmode 2 -autostart-handle-tde -autostart-warp
dotest $EMU tde-image    1   0 $OPTS $DRIVEON -device8 1 $IECDEVOFF -drive8truedrive +virtualdev -autostartprgmode 2 -autostart-handle-tde +autostart-warp
dotest $EMU tde-image    0 255 $OPTS $DRIVEON -device8 1 $IECDEVOFF -drive8truedrive -virtualdev -autostartprgmode 2 -autostart-handle-tde -autostart-warp
dotest $EMU tde-image    0 255 $OPTS $DRIVEON -device8 1 $IECDEVOFF -drive8truedrive -virtualdev -autostartprgmode 2 -autostart-handle-tde +autostart-warp
# none
dotest $EMU none-image   0 255 $OPTS $DRIVEON -device8 1 $IECDEVOFF +drive8truedrive +virtualdev -autostartprgmode 2 -autostart-handle-tde -autostart-warp
dotest $EMU none-image   0 255 $OPTS $DRIVEON -device8 1 $IECDEVOFF +drive8truedrive +virtualdev -autostartprgmode 2 -autostart-handle-tde +autostart-warp
# vfs only
dotest $EMU vdrive-image 1   0 $OPTS $DRIVEON -device8 1 $IECDEVOFF +drive8truedrive -virtualdev -autostartprgmode 2 -autostart-handle-tde -autostart-warp
dotest $EMU vdrive-image 1   0 $OPTS $DRIVEON -device8 1 $IECDEVOFF +drive8truedrive -virtualdev -autostartprgmode 2 -autostart-handle-tde +autostart-warp
if [ "$IECDEVICE" = "yes" ]; then
dotest $EMU tde-image    0 255 $OPTS $DRIVEON -device8 1 $IECDEVON  -drive8truedrive +virtualdev -autostartprgmode 2 -autostart-handle-tde -autostart-warp
dotest $EMU tde-image    0 255 $OPTS $DRIVEON -device8 1 $IECDEVON  -drive8truedrive +virtualdev -autostartprgmode 2 -autostart-handle-tde +autostart-warp
dotest $EMU tde-image    0 255 $OPTS $DRIVEON -device8 1 $IECDEVON  -drive8truedrive -virtualdev -autostartprgmode 2 -autostart-handle-tde -autostart-warp
dotest $EMU tde-image    0 255 $OPTS $DRIVEON -device8 1 $IECDEVON  -drive8truedrive -virtualdev -autostartprgmode 2 -autostart-handle-tde +autostart-warp
# iecdev only
dotest $EMU vdrive-image 1   0 $OPTS $DRIVEON -device8 1 $IECDEVON  +drive8truedrive +virtualdev -autostartprgmode 2 -autostart-handle-tde -autostart-warp
dotest $EMU vdrive-image 1   0 $OPTS $DRIVEON -device8 1 $IECDEVON  +drive8truedrive +virtualdev -autostartprgmode 2 -autostart-handle-tde +autostart-warp
dotest $EMU vdrive-image 0 255 $OPTS $DRIVEON -device8 1 $IECDEVON  +drive8truedrive -virtualdev -autostartprgmode 2 -autostart-handle-tde -autostart-warp
dotest $EMU vdrive-image 0 255 $OPTS $DRIVEON -device8 1 $IECDEVON  +drive8truedrive -virtualdev -autostartprgmode 2 -autostart-handle-tde +autostart-warp
fi

# with drivetype = none

# the prg mode should make no difference when we are starting a disk image
# -> the following block repeats 3 times

echo "autostart mode 0 (virtual filesystem) - do not handle TDE"
## fsdevice = none
# TDEonly
dotest $EMU tde-image    1   0 $OPTS $DRIVEOFF -device8 0 $IECDEVOFF -drive8truedrive +virtualdev -autostartprgmode 0 +autostart-handle-tde -autostart-warp
dotest $EMU tde-image    1   0 $OPTS $DRIVEOFF -device8 0 $IECDEVOFF -drive8truedrive +virtualdev -autostartprgmode 0 +autostart-handle-tde +autostart-warp
dotest $EMU tde-image    0 255 $OPTS $DRIVEOFF -device8 0 $IECDEVOFF -drive8truedrive -virtualdev -autostartprgmode 0 +autostart-handle-tde -autostart-warp
dotest $EMU tde-image    0 255 $OPTS $DRIVEOFF -device8 0 $IECDEVOFF -drive8truedrive -virtualdev -autostartprgmode 0 +autostart-handle-tde +autostart-warp
# none
dotest $EMU none-image   0 255 $OPTS $DRIVEOFF -device8 0 $IECDEVOFF +drive8truedrive +virtualdev -autostartprgmode 0 +autostart-handle-tde -autostart-warp
dotest $EMU none-image   0 255 $OPTS $DRIVEOFF -device8 0 $IECDEVOFF +drive8truedrive +virtualdev -autostartprgmode 0 +autostart-handle-tde +autostart-warp
# vfs only
dotest $EMU vdrive-image 1   0 $OPTS $DRIVEOFF -device8 0 $IECDEVOFF +drive8truedrive -virtualdev -autostartprgmode 0 +autostart-handle-tde -autostart-warp
dotest $EMU vdrive-image 1   0 $OPTS $DRIVEOFF -device8 0 $IECDEVOFF +drive8truedrive -virtualdev -autostartprgmode 0 +autostart-handle-tde +autostart-warp
if [ "$IECDEVICE" = "yes" ]; then
dotest $EMU tde-image    0 255 $OPTS $DRIVEOFF -device8 0 $IECDEVON  -drive8truedrive +virtualdev -autostartprgmode 0 +autostart-handle-tde -autostart-warp
dotest $EMU tde-image    0 255 $OPTS $DRIVEOFF -device8 0 $IECDEVON  -drive8truedrive +virtualdev -autostartprgmode 0 +autostart-handle-tde +autostart-warp
dotest $EMU tde-image    0 255 $OPTS $DRIVEOFF -device8 0 $IECDEVON  -drive8truedrive -virtualdev -autostartprgmode 0 +autostart-handle-tde -autostart-warp
dotest $EMU tde-image    0 255 $OPTS $DRIVEOFF -device8 0 $IECDEVON  -drive8truedrive -virtualdev -autostartprgmode 0 +autostart-handle-tde +autostart-warp
# iecdev only
dotest $EMU vdrive-image 1   0 $OPTS $DRIVEOFF -device8 0 $IECDEVON  +drive8truedrive +virtualdev -autostartprgmode 0 +autostart-handle-tde -autostart-warp
dotest $EMU vdrive-image 1   0 $OPTS $DRIVEOFF -device8 0 $IECDEVON  +drive8truedrive +virtualdev -autostartprgmode 0 +autostart-handle-tde +autostart-warp
dotest $EMU vdrive-image 0 255 $OPTS $DRIVEOFF -device8 0 $IECDEVON  +drive8truedrive -virtualdev -autostartprgmode 0 +autostart-handle-tde -autostart-warp
dotest $EMU vdrive-image 0 255 $OPTS $DRIVEOFF -device8 0 $IECDEVON  +drive8truedrive -virtualdev -autostartprgmode 0 +autostart-handle-tde +autostart-warp
fi

## fsdevice = filesystem
# TDEonly
dotest $EMU tde-image    1   0 $OPTS $DRIVEOFF -device8 1 $IECDEVOFF -drive8truedrive +virtualdev -autostartprgmode 0 +autostart-handle-tde -autostart-warp
dotest $EMU tde-image    1   0 $OPTS $DRIVEOFF -device8 1 $IECDEVOFF -drive8truedrive +virtualdev -autostartprgmode 0 +autostart-handle-tde +autostart-warp
dotest $EMU tde-image    0 255 $OPTS $DRIVEOFF -device8 1 $IECDEVOFF -drive8truedrive -virtualdev -autostartprgmode 0 +autostart-handle-tde -autostart-warp
dotest $EMU tde-image    0 255 $OPTS $DRIVEOFF -device8 1 $IECDEVOFF -drive8truedrive -virtualdev -autostartprgmode 0 +autostart-handle-tde +autostart-warp
# none
dotest $EMU none-image   0 255 $OPTS $DRIVEOFF -device8 1 $IECDEVOFF +drive8truedrive +virtualdev -autostartprgmode 0 +autostart-handle-tde -autostart-warp
dotest $EMU none-image   0 255 $OPTS $DRIVEOFF -device8 1 $IECDEVOFF +drive8truedrive +virtualdev -autostartprgmode 0 +autostart-handle-tde +autostart-warp
# vfs only
dotest $EMU vdrive-image 1   0 $OPTS $DRIVEOFF -device8 1 $IECDEVOFF +drive8truedrive -virtualdev -autostartprgmode 0 +autostart-handle-tde -autostart-warp
dotest $EMU vdrive-image 1   0 $OPTS $DRIVEOFF -device8 1 $IECDEVOFF +drive8truedrive -virtualdev -autostartprgmode 0 +autostart-handle-tde +autostart-warp
if [ "$IECDEVICE" = "yes" ]; then
dotest $EMU tde-image    0 255 $OPTS $DRIVEOFF -device8 1 $IECDEVON  -drive8truedrive +virtualdev -autostartprgmode 0 +autostart-handle-tde -autostart-warp
dotest $EMU tde-image    0 255 $OPTS $DRIVEOFF -device8 1 $IECDEVON  -drive8truedrive +virtualdev -autostartprgmode 0 +autostart-handle-tde +autostart-warp
dotest $EMU tde-image    0 255 $OPTS $DRIVEOFF -device8 1 $IECDEVON  -drive8truedrive -virtualdev -autostartprgmode 0 +autostart-handle-tde -autostart-warp
dotest $EMU tde-image    0 255 $OPTS $DRIVEOFF -device8 1 $IECDEVON  -drive8truedrive -virtualdev -autostartprgmode 0 +autostart-handle-tde +autostart-warp
# iecdev only
dotest $EMU vdrive-image 1   0 $OPTS $DRIVEOFF -device8 1 $IECDEVON  +drive8truedrive +virtualdev -autostartprgmode 0 +autostart-handle-tde -autostart-warp
dotest $EMU vdrive-image 1   0 $OPTS $DRIVEOFF -device8 1 $IECDEVON  +drive8truedrive +virtualdev -autostartprgmode 0 +autostart-handle-tde +autostart-warp
dotest $EMU vdrive-image 0 255 $OPTS $DRIVEOFF -device8 1 $IECDEVON  +drive8truedrive -virtualdev -autostartprgmode 0 +autostart-handle-tde -autostart-warp
dotest $EMU vdrive-image 0 255 $OPTS $DRIVEOFF -device8 1 $IECDEVON  +drive8truedrive -virtualdev -autostartprgmode 0 +autostart-handle-tde +autostart-warp
fi

echo "autostart mode 1 (inject to RAM) - do not handle TDE"

## fsdevice = none
# TDEonly
dotest $EMU tde-image    1   0 $OPTS $DRIVEOFF -device8 0 $IECDEVOFF -drive8truedrive +virtualdev -autostartprgmode 1 +autostart-handle-tde -autostart-warp
dotest $EMU tde-image    1   0 $OPTS $DRIVEOFF -device8 0 $IECDEVOFF -drive8truedrive +virtualdev -autostartprgmode 1 +autostart-handle-tde +autostart-warp
dotest $EMU tde-image    0 255 $OPTS $DRIVEOFF -device8 0 $IECDEVOFF -drive8truedrive -virtualdev -autostartprgmode 1 +autostart-handle-tde -autostart-warp
dotest $EMU tde-image    0 255 $OPTS $DRIVEOFF -device8 0 $IECDEVOFF -drive8truedrive -virtualdev -autostartprgmode 1 +autostart-handle-tde +autostart-warp
# none
dotest $EMU none-image   0 255 $OPTS $DRIVEOFF -device8 0 $IECDEVOFF +drive8truedrive +virtualdev -autostartprgmode 1 +autostart-handle-tde -autostart-warp
dotest $EMU none-image   0 255 $OPTS $DRIVEOFF -device8 0 $IECDEVOFF +drive8truedrive +virtualdev -autostartprgmode 1 +autostart-handle-tde +autostart-warp
# vfs only
dotest $EMU vdrive-image 1   0 $OPTS $DRIVEOFF -device8 0 $IECDEVOFF +drive8truedrive -virtualdev -autostartprgmode 1 +autostart-handle-tde -autostart-warp
dotest $EMU vdrive-image 1   0 $OPTS $DRIVEOFF -device8 0 $IECDEVOFF +drive8truedrive -virtualdev -autostartprgmode 1 +autostart-handle-tde +autostart-warp
if [ "$IECDEVICE" = "yes" ]; then
dotest $EMU tde-image    0 255 $OPTS $DRIVEOFF -device8 0 $IECDEVON  -drive8truedrive +virtualdev -autostartprgmode 1 +autostart-handle-tde -autostart-warp
dotest $EMU tde-image    0 255 $OPTS $DRIVEOFF -device8 0 $IECDEVON  -drive8truedrive +virtualdev -autostartprgmode 1 +autostart-handle-tde +autostart-warp
dotest $EMU tde-image    0 255 $OPTS $DRIVEOFF -device8 0 $IECDEVON  -drive8truedrive -virtualdev -autostartprgmode 1 +autostart-handle-tde -autostart-warp
dotest $EMU tde-image    0 255 $OPTS $DRIVEOFF -device8 0 $IECDEVON  -drive8truedrive -virtualdev -autostartprgmode 1 +autostart-handle-tde +autostart-warp
# iecdev only
dotest $EMU vdrive-image 1   0 $OPTS $DRIVEOFF -device8 0 $IECDEVON  +drive8truedrive +virtualdev -autostartprgmode 1 +autostart-handle-tde -autostart-warp
dotest $EMU vdrive-image 1   0 $OPTS $DRIVEOFF -device8 0 $IECDEVON  +drive8truedrive +virtualdev -autostartprgmode 1 +autostart-handle-tde +autostart-warp
dotest $EMU vdrive-image 0 255 $OPTS $DRIVEOFF -device8 0 $IECDEVON  +drive8truedrive -virtualdev -autostartprgmode 1 +autostart-handle-tde -autostart-warp
dotest $EMU vdrive-image 0 255 $OPTS $DRIVEOFF -device8 0 $IECDEVON  +drive8truedrive -virtualdev -autostartprgmode 1 +autostart-handle-tde +autostart-warp
fi

## fsdevice = filesystem
# TDEonly
dotest $EMU tde-image    1   0 $OPTS $DRIVEOFF -device8 1 $IECDEVOFF -drive8truedrive +virtualdev -autostartprgmode 1 +autostart-handle-tde -autostart-warp
dotest $EMU tde-image    1   0 $OPTS $DRIVEOFF -device8 1 $IECDEVOFF -drive8truedrive +virtualdev -autostartprgmode 1 +autostart-handle-tde +autostart-warp
dotest $EMU tde-image    0 255 $OPTS $DRIVEOFF -device8 1 $IECDEVOFF -drive8truedrive -virtualdev -autostartprgmode 1 +autostart-handle-tde -autostart-warp
dotest $EMU tde-image    0 255 $OPTS $DRIVEOFF -device8 1 $IECDEVOFF -drive8truedrive -virtualdev -autostartprgmode 1 +autostart-handle-tde +autostart-warp
# none
dotest $EMU none-image   0 255 $OPTS $DRIVEOFF -device8 1 $IECDEVOFF +drive8truedrive +virtualdev -autostartprgmode 1 +autostart-handle-tde -autostart-warp
dotest $EMU none-image   0 255 $OPTS $DRIVEOFF -device8 1 $IECDEVOFF +drive8truedrive +virtualdev -autostartprgmode 1 +autostart-handle-tde +autostart-warp
# vfs only
dotest $EMU vdrive-image 1   0 $OPTS $DRIVEOFF -device8 1 $IECDEVOFF +drive8truedrive -virtualdev -autostartprgmode 1 +autostart-handle-tde -autostart-warp
dotest $EMU vdrive-image 1   0 $OPTS $DRIVEOFF -device8 1 $IECDEVOFF +drive8truedrive -virtualdev -autostartprgmode 1 +autostart-handle-tde +autostart-warp
if [ "$IECDEVICE" = "yes" ]; then
dotest $EMU tde-image    0 255 $OPTS $DRIVEOFF -device8 1 $IECDEVON  -drive8truedrive +virtualdev -autostartprgmode 1 +autostart-handle-tde -autostart-warp
dotest $EMU tde-image    0 255 $OPTS $DRIVEOFF -device8 1 $IECDEVON  -drive8truedrive +virtualdev -autostartprgmode 1 +autostart-handle-tde +autostart-warp
dotest $EMU tde-image    0 255 $OPTS $DRIVEOFF -device8 1 $IECDEVON  -drive8truedrive -virtualdev -autostartprgmode 1 +autostart-handle-tde -autostart-warp
dotest $EMU tde-image    0 255 $OPTS $DRIVEOFF -device8 1 $IECDEVON  -drive8truedrive -virtualdev -autostartprgmode 1 +autostart-handle-tde +autostart-warp
# iecdev only
dotest $EMU vdrive-image 1   0 $OPTS $DRIVEOFF -device8 1 $IECDEVON  +drive8truedrive +virtualdev -autostartprgmode 1 +autostart-handle-tde -autostart-warp
dotest $EMU vdrive-image 1   0 $OPTS $DRIVEOFF -device8 1 $IECDEVON  +drive8truedrive +virtualdev -autostartprgmode 1 +autostart-handle-tde +autostart-warp
dotest $EMU vdrive-image 0 255 $OPTS $DRIVEOFF -device8 1 $IECDEVON  +drive8truedrive -virtualdev -autostartprgmode 1 +autostart-handle-tde -autostart-warp
dotest $EMU vdrive-image 0 255 $OPTS $DRIVEOFF -device8 1 $IECDEVON  +drive8truedrive -virtualdev -autostartprgmode 1 +autostart-handle-tde +autostart-warp
fi

echo "autostart mode 2 (copy to disk image) - do not handle TDE"

## fsdevice = none
# TDEonly
dotest $EMU tde-image    1   0 $OPTS $DRIVEOFF -device8 0 $IECDEVOFF -drive8truedrive +virtualdev -autostartprgmode 2 +autostart-handle-tde -autostart-warp
dotest $EMU tde-image    1   0 $OPTS $DRIVEOFF -device8 0 $IECDEVOFF -drive8truedrive +virtualdev -autostartprgmode 2 +autostart-handle-tde +autostart-warp
dotest $EMU tde-image    0 255 $OPTS $DRIVEOFF -device8 0 $IECDEVOFF -drive8truedrive -virtualdev -autostartprgmode 2 +autostart-handle-tde -autostart-warp
dotest $EMU tde-image    0 255 $OPTS $DRIVEOFF -device8 0 $IECDEVOFF -drive8truedrive -virtualdev -autostartprgmode 2 +autostart-handle-tde +autostart-warp
# none
dotest $EMU none-image   0 255 $OPTS $DRIVEOFF -device8 0 $IECDEVOFF +drive8truedrive +virtualdev -autostartprgmode 2 +autostart-handle-tde -autostart-warp
dotest $EMU none-image   0 255 $OPTS $DRIVEOFF -device8 0 $IECDEVOFF +drive8truedrive +virtualdev -autostartprgmode 2 +autostart-handle-tde +autostart-warp
# vfs only
dotest $EMU vdrive-image 1   0 $OPTS $DRIVEOFF -device8 0 $IECDEVOFF +drive8truedrive -virtualdev -autostartprgmode 2 +autostart-handle-tde -autostart-warp
dotest $EMU vdrive-image 1   0 $OPTS $DRIVEOFF -device8 0 $IECDEVOFF +drive8truedrive -virtualdev -autostartprgmode 2 +autostart-handle-tde +autostart-warp
if [ "$IECDEVICE" = "yes" ]; then
dotest $EMU tde-image    0 255 $OPTS $DRIVEOFF -device8 0 $IECDEVON  -drive8truedrive +virtualdev -autostartprgmode 2 +autostart-handle-tde -autostart-warp
dotest $EMU tde-image    0 255 $OPTS $DRIVEOFF -device8 0 $IECDEVON  -drive8truedrive +virtualdev -autostartprgmode 2 +autostart-handle-tde +autostart-warp
dotest $EMU tde-image    0 255 $OPTS $DRIVEOFF -device8 0 $IECDEVON  -drive8truedrive -virtualdev -autostartprgmode 2 +autostart-handle-tde -autostart-warp
dotest $EMU tde-image    0 255 $OPTS $DRIVEOFF -device8 0 $IECDEVON  -drive8truedrive -virtualdev -autostartprgmode 2 +autostart-handle-tde +autostart-warp
# iecdev only
dotest $EMU vdrive-image 1   0 $OPTS $DRIVEOFF -device8 0 $IECDEVON  +drive8truedrive +virtualdev -autostartprgmode 2 +autostart-handle-tde -autostart-warp
dotest $EMU vdrive-image 1   0 $OPTS $DRIVEOFF -device8 0 $IECDEVON  +drive8truedrive +virtualdev -autostartprgmode 2 +autostart-handle-tde +autostart-warp
dotest $EMU vdrive-image 0 255 $OPTS $DRIVEOFF -device8 0 $IECDEVON  +drive8truedrive -virtualdev -autostartprgmode 2 +autostart-handle-tde -autostart-warp
dotest $EMU vdrive-image 0 255 $OPTS $DRIVEOFF -device8 0 $IECDEVON  +drive8truedrive -virtualdev -autostartprgmode 2 +autostart-handle-tde +autostart-warp
fi

## fsdevice = filesystem
# TDEonly
dotest $EMU tde-image    1   0 $OPTS $DRIVEOFF -device8 1 $IECDEVOFF -drive8truedrive +virtualdev -autostartprgmode 2 +autostart-handle-tde -autostart-warp
dotest $EMU tde-image    1   0 $OPTS $DRIVEOFF -device8 1 $IECDEVOFF -drive8truedrive +virtualdev -autostartprgmode 2 +autostart-handle-tde +autostart-warp
dotest $EMU tde-image    0 255 $OPTS $DRIVEOFF -device8 1 $IECDEVOFF -drive8truedrive -virtualdev -autostartprgmode 2 +autostart-handle-tde -autostart-warp
dotest $EMU tde-image    0 255 $OPTS $DRIVEOFF -device8 1 $IECDEVOFF -drive8truedrive -virtualdev -autostartprgmode 2 +autostart-handle-tde +autostart-warp
# none
dotest $EMU none-image   0 255 $OPTS $DRIVEOFF -device8 1 $IECDEVOFF +drive8truedrive +virtualdev -autostartprgmode 2 +autostart-handle-tde -autostart-warp
dotest $EMU none-image   0 255 $OPTS $DRIVEOFF -device8 1 $IECDEVOFF +drive8truedrive +virtualdev -autostartprgmode 2 +autostart-handle-tde +autostart-warp
# vfs only
dotest $EMU vdrive-image 1   0 $OPTS $DRIVEOFF -device8 1 $IECDEVOFF +drive8truedrive -virtualdev -autostartprgmode 2 +autostart-handle-tde -autostart-warp
dotest $EMU vdrive-image 1   0 $OPTS $DRIVEOFF -device8 1 $IECDEVOFF +drive8truedrive -virtualdev -autostartprgmode 2 +autostart-handle-tde +autostart-warp
if [ "$IECDEVICE" = "yes" ]; then
dotest $EMU tde-image    0 255 $OPTS $DRIVEOFF -device8 1 $IECDEVON  -drive8truedrive +virtualdev -autostartprgmode 2 +autostart-handle-tde -autostart-warp
dotest $EMU tde-image    0 255 $OPTS $DRIVEOFF -device8 1 $IECDEVON  -drive8truedrive +virtualdev -autostartprgmode 2 +autostart-handle-tde +autostart-warp
dotest $EMU tde-image    0 255 $OPTS $DRIVEOFF -device8 1 $IECDEVON  -drive8truedrive -virtualdev -autostartprgmode 2 +autostart-handle-tde -autostart-warp
dotest $EMU tde-image    0 255 $OPTS $DRIVEOFF -device8 1 $IECDEVON  -drive8truedrive -virtualdev -autostartprgmode 2 +autostart-handle-tde +autostart-warp
# iecdev only
dotest $EMU vdrive-image 1   0 $OPTS $DRIVEOFF -device8 1 $IECDEVON  +drive8truedrive +virtualdev -autostartprgmode 2 +autostart-handle-tde -autostart-warp
dotest $EMU vdrive-image 1   0 $OPTS $DRIVEOFF -device8 1 $IECDEVON  +drive8truedrive +virtualdev -autostartprgmode 2 +autostart-handle-tde +autostart-warp
dotest $EMU vdrive-image 0 255 $OPTS $DRIVEOFF -device8 1 $IECDEVON  +drive8truedrive -virtualdev -autostartprgmode 2 +autostart-handle-tde -autostart-warp
dotest $EMU vdrive-image 0 255 $OPTS $DRIVEOFF -device8 1 $IECDEVON  +drive8truedrive -virtualdev -autostartprgmode 2 +autostart-handle-tde +autostart-warp
fi

# "handle tde at autostart" will let autostart disable TDE in favour if virtual devices
# however, this does not change anything in the final state, so again all of the above repeats

echo "autostart mode 0 (virtual filesystem) - handle TDE"

## fsdevice = none
# TDEonly
dotest $EMU tde-image    1   0 $OPTS $DRIVEOFF -device8 0 $IECDEVOFF -drive8truedrive +virtualdev -autostartprgmode 0 -autostart-handle-tde -autostart-warp
dotest $EMU tde-image    1   0 $OPTS $DRIVEOFF -device8 0 $IECDEVOFF -drive8truedrive +virtualdev -autostartprgmode 0 -autostart-handle-tde +autostart-warp
dotest $EMU tde-image    0 255 $OPTS $DRIVEOFF -device8 0 $IECDEVOFF -drive8truedrive -virtualdev -autostartprgmode 0 -autostart-handle-tde -autostart-warp
dotest $EMU tde-image    0 255 $OPTS $DRIVEOFF -device8 0 $IECDEVOFF -drive8truedrive -virtualdev -autostartprgmode 0 -autostart-handle-tde +autostart-warp
# none
dotest $EMU none-image   0 255 $OPTS $DRIVEOFF -device8 0 $IECDEVOFF +drive8truedrive +virtualdev -autostartprgmode 0 -autostart-handle-tde -autostart-warp
dotest $EMU none-image   0 255 $OPTS $DRIVEOFF -device8 0 $IECDEVOFF +drive8truedrive +virtualdev -autostartprgmode 0 -autostart-handle-tde +autostart-warp
# vfs only
dotest $EMU vdrive-image 1   0 $OPTS $DRIVEOFF -device8 0 $IECDEVOFF +drive8truedrive -virtualdev -autostartprgmode 0 -autostart-handle-tde -autostart-warp
dotest $EMU vdrive-image 1   0 $OPTS $DRIVEOFF -device8 0 $IECDEVOFF +drive8truedrive -virtualdev -autostartprgmode 0 -autostart-handle-tde +autostart-warp
if [ "$IECDEVICE" = "yes" ]; then
dotest $EMU tde-image    0 255 $OPTS $DRIVEOFF -device8 0 $IECDEVON  -drive8truedrive +virtualdev -autostartprgmode 0 -autostart-handle-tde -autostart-warp
dotest $EMU tde-image    0 255 $OPTS $DRIVEOFF -device8 0 $IECDEVON  -drive8truedrive +virtualdev -autostartprgmode 0 -autostart-handle-tde +autostart-warp
dotest $EMU tde-image    0 255 $OPTS $DRIVEOFF -device8 0 $IECDEVON  -drive8truedrive -virtualdev -autostartprgmode 0 -autostart-handle-tde -autostart-warp
dotest $EMU tde-image    0 255 $OPTS $DRIVEOFF -device8 0 $IECDEVON  -drive8truedrive -virtualdev -autostartprgmode 0 -autostart-handle-tde +autostart-warp
# iecdev only
dotest $EMU vdrive-image 1   0 $OPTS $DRIVEOFF -device8 0 $IECDEVON  +drive8truedrive +virtualdev -autostartprgmode 0 -autostart-handle-tde -autostart-warp
dotest $EMU vdrive-image 1   0 $OPTS $DRIVEOFF -device8 0 $IECDEVON  +drive8truedrive +virtualdev -autostartprgmode 0 -autostart-handle-tde +autostart-warp
dotest $EMU vdrive-image 0 255 $OPTS $DRIVEOFF -device8 0 $IECDEVON  +drive8truedrive -virtualdev -autostartprgmode 0 -autostart-handle-tde -autostart-warp
dotest $EMU vdrive-image 0 255 $OPTS $DRIVEOFF -device8 0 $IECDEVON  +drive8truedrive -virtualdev -autostartprgmode 0 -autostart-handle-tde +autostart-warp
fi

## fsdevice = filesystem
# TDEonly
dotest $EMU tde-image    1   0 $OPTS $DRIVEOFF -device8 1 $IECDEVOFF -drive8truedrive +virtualdev -autostartprgmode 0 -autostart-handle-tde -autostart-warp
dotest $EMU tde-image    1   0 $OPTS $DRIVEOFF -device8 1 $IECDEVOFF -drive8truedrive +virtualdev -autostartprgmode 0 -autostart-handle-tde +autostart-warp
dotest $EMU tde-image    0 255 $OPTS $DRIVEOFF -device8 1 $IECDEVOFF -drive8truedrive -virtualdev -autostartprgmode 0 -autostart-handle-tde -autostart-warp
dotest $EMU tde-image    0 255 $OPTS $DRIVEOFF -device8 1 $IECDEVOFF -drive8truedrive -virtualdev -autostartprgmode 0 -autostart-handle-tde +autostart-warp
# none
dotest $EMU none-image   0 255 $OPTS $DRIVEOFF -device8 1 $IECDEVOFF +drive8truedrive +virtualdev -autostartprgmode 0 -autostart-handle-tde -autostart-warp
dotest $EMU none-image   0 255 $OPTS $DRIVEOFF -device8 1 $IECDEVOFF +drive8truedrive +virtualdev -autostartprgmode 0 -autostart-handle-tde +autostart-warp
# vfs only
dotest $EMU vdrive-image 1   0 $OPTS $DRIVEOFF -device8 1 $IECDEVOFF +drive8truedrive -virtualdev -autostartprgmode 0 -autostart-handle-tde -autostart-warp
dotest $EMU vdrive-image 1   0 $OPTS $DRIVEOFF -device8 1 $IECDEVOFF +drive8truedrive -virtualdev -autostartprgmode 0 -autostart-handle-tde +autostart-warp
if [ "$IECDEVICE" = "yes" ]; then
dotest $EMU tde-image    0 255 $OPTS $DRIVEOFF -device8 1 $IECDEVON  -drive8truedrive +virtualdev -autostartprgmode 0 -autostart-handle-tde -autostart-warp
dotest $EMU tde-image    0 255 $OPTS $DRIVEOFF -device8 1 $IECDEVON  -drive8truedrive +virtualdev -autostartprgmode 0 -autostart-handle-tde +autostart-warp
dotest $EMU tde-image    0 255 $OPTS $DRIVEOFF -device8 1 $IECDEVON  -drive8truedrive -virtualdev -autostartprgmode 0 -autostart-handle-tde -autostart-warp
dotest $EMU tde-image    0 255 $OPTS $DRIVEOFF -device8 1 $IECDEVON  -drive8truedrive -virtualdev -autostartprgmode 0 -autostart-handle-tde +autostart-warp
# iecdev only
dotest $EMU vdrive-image 1   0 $OPTS $DRIVEOFF -device8 1 $IECDEVON  +drive8truedrive +virtualdev -autostartprgmode 0 -autostart-handle-tde -autostart-warp
dotest $EMU vdrive-image 1   0 $OPTS $DRIVEOFF -device8 1 $IECDEVON  +drive8truedrive +virtualdev -autostartprgmode 0 -autostart-handle-tde +autostart-warp
dotest $EMU vdrive-image 0 255 $OPTS $DRIVEOFF -device8 1 $IECDEVON  +drive8truedrive -virtualdev -autostartprgmode 0 -autostart-handle-tde -autostart-warp
dotest $EMU vdrive-image 0 255 $OPTS $DRIVEOFF -device8 1 $IECDEVON  +drive8truedrive -virtualdev -autostartprgmode 0 -autostart-handle-tde +autostart-warp
fi

echo "autostart mode 1 (inject to RAM) - handle TDE"

## fsdevice = none
# TDEonly
dotest $EMU tde-image    1   0 $OPTS $DRIVEOFF -device8 0 $IECDEVOFF -drive8truedrive +virtualdev -autostartprgmode 1 -autostart-handle-tde -autostart-warp
dotest $EMU tde-image    1   0 $OPTS $DRIVEOFF -device8 0 $IECDEVOFF -drive8truedrive +virtualdev -autostartprgmode 1 -autostart-handle-tde +autostart-warp
dotest $EMU tde-image    0 255 $OPTS $DRIVEOFF -device8 0 $IECDEVOFF -drive8truedrive -virtualdev -autostartprgmode 1 -autostart-handle-tde -autostart-warp
dotest $EMU tde-image    0 255 $OPTS $DRIVEOFF -device8 0 $IECDEVOFF -drive8truedrive -virtualdev -autostartprgmode 1 -autostart-handle-tde +autostart-warp
# none
dotest $EMU none-image   0 255 $OPTS $DRIVEOFF -device8 0 $IECDEVOFF +drive8truedrive +virtualdev -autostartprgmode 1 -autostart-handle-tde -autostart-warp
dotest $EMU none-image   0 255 $OPTS $DRIVEOFF -device8 0 $IECDEVOFF +drive8truedrive +virtualdev -autostartprgmode 1 -autostart-handle-tde +autostart-warp
# vfs only
dotest $EMU vdrive-image 1   0 $OPTS $DRIVEOFF -device8 0 $IECDEVOFF +drive8truedrive -virtualdev -autostartprgmode 1 -autostart-handle-tde -autostart-warp
dotest $EMU vdrive-image 1   0 $OPTS $DRIVEOFF -device8 0 $IECDEVOFF +drive8truedrive -virtualdev -autostartprgmode 1 -autostart-handle-tde +autostart-warp
if [ "$IECDEVICE" = "yes" ]; then
dotest $EMU tde-image    0 255 $OPTS $DRIVEOFF -device8 0 $IECDEVON  -drive8truedrive +virtualdev -autostartprgmode 1 -autostart-handle-tde -autostart-warp
dotest $EMU tde-image    0 255 $OPTS $DRIVEOFF -device8 0 $IECDEVON  -drive8truedrive +virtualdev -autostartprgmode 1 -autostart-handle-tde +autostart-warp
dotest $EMU tde-image    0 255 $OPTS $DRIVEOFF -device8 0 $IECDEVON  -drive8truedrive -virtualdev -autostartprgmode 1 -autostart-handle-tde -autostart-warp
dotest $EMU tde-image    0 255 $OPTS $DRIVEOFF -device8 0 $IECDEVON  -drive8truedrive -virtualdev -autostartprgmode 1 -autostart-handle-tde +autostart-warp
# iecdev only
dotest $EMU vdrive-image 1   0 $OPTS $DRIVEOFF -device8 0 $IECDEVON  +drive8truedrive +virtualdev -autostartprgmode 1 -autostart-handle-tde -autostart-warp
dotest $EMU vdrive-image 1   0 $OPTS $DRIVEOFF -device8 0 $IECDEVON  +drive8truedrive +virtualdev -autostartprgmode 1 -autostart-handle-tde +autostart-warp
dotest $EMU vdrive-image 0 255 $OPTS $DRIVEOFF -device8 0 $IECDEVON  +drive8truedrive -virtualdev -autostartprgmode 1 -autostart-handle-tde -autostart-warp
dotest $EMU vdrive-image 0 255 $OPTS $DRIVEOFF -device8 0 $IECDEVON  +drive8truedrive -virtualdev -autostartprgmode 1 -autostart-handle-tde +autostart-warp
fi

## fsdevice = filesystem
# TDEonly
dotest $EMU tde-image    1   0 $OPTS $DRIVEOFF -device8 1 $IECDEVOFF -drive8truedrive +virtualdev -autostartprgmode 1 -autostart-handle-tde -autostart-warp
dotest $EMU tde-image    1   0 $OPTS $DRIVEOFF -device8 1 $IECDEVOFF -drive8truedrive +virtualdev -autostartprgmode 1 -autostart-handle-tde +autostart-warp
dotest $EMU tde-image    0 255 $OPTS $DRIVEOFF -device8 1 $IECDEVOFF -drive8truedrive -virtualdev -autostartprgmode 1 -autostart-handle-tde -autostart-warp
dotest $EMU tde-image    0 255 $OPTS $DRIVEOFF -device8 1 $IECDEVOFF -drive8truedrive -virtualdev -autostartprgmode 1 -autostart-handle-tde +autostart-warp
# none
dotest $EMU none-image   0 255 $OPTS $DRIVEOFF -device8 1 $IECDEVOFF +drive8truedrive +virtualdev -autostartprgmode 1 -autostart-handle-tde -autostart-warp
dotest $EMU none-image   0 255 $OPTS $DRIVEOFF -device8 1 $IECDEVOFF +drive8truedrive +virtualdev -autostartprgmode 1 -autostart-handle-tde +autostart-warp
# vfs only
dotest $EMU vdrive-image 1   0 $OPTS $DRIVEOFF -device8 1 $IECDEVOFF +drive8truedrive -virtualdev -autostartprgmode 1 -autostart-handle-tde -autostart-warp
dotest $EMU vdrive-image 1   0 $OPTS $DRIVEOFF -device8 1 $IECDEVOFF +drive8truedrive -virtualdev -autostartprgmode 1 -autostart-handle-tde +autostart-warp
if [ "$IECDEVICE" = "yes" ]; then
dotest $EMU tde-image    0 255 $OPTS $DRIVEOFF -device8 1 $IECDEVON  -drive8truedrive +virtualdev -autostartprgmode 1 -autostart-handle-tde -autostart-warp
dotest $EMU tde-image    0 255 $OPTS $DRIVEOFF -device8 1 $IECDEVON  -drive8truedrive +virtualdev -autostartprgmode 1 -autostart-handle-tde +autostart-warp
dotest $EMU tde-image    0 255 $OPTS $DRIVEOFF -device8 1 $IECDEVON  -drive8truedrive -virtualdev -autostartprgmode 1 -autostart-handle-tde -autostart-warp
dotest $EMU tde-image    0 255 $OPTS $DRIVEOFF -device8 1 $IECDEVON  -drive8truedrive -virtualdev -autostartprgmode 1 -autostart-handle-tde +autostart-warp
# iecdev only
dotest $EMU vdrive-image 1   0 $OPTS $DRIVEOFF -device8 1 $IECDEVON  +drive8truedrive +virtualdev -autostartprgmode 1 -autostart-handle-tde -autostart-warp
dotest $EMU vdrive-image 1   0 $OPTS $DRIVEOFF -device8 1 $IECDEVON  +drive8truedrive +virtualdev -autostartprgmode 1 -autostart-handle-tde +autostart-warp
dotest $EMU vdrive-image 0 255 $OPTS $DRIVEOFF -device8 1 $IECDEVON  +drive8truedrive -virtualdev -autostartprgmode 1 -autostart-handle-tde -autostart-warp
dotest $EMU vdrive-image 0 255 $OPTS $DRIVEOFF -device8 1 $IECDEVON  +drive8truedrive -virtualdev -autostartprgmode 1 -autostart-handle-tde +autostart-warp
fi

echo "autostart mode 2 (copy to disk image) - handle TDE"

## fsdevice = none
# TDEonly
dotest $EMU tde-image    1   0 $OPTS $DRIVEOFF -device8 0 $IECDEVOFF -drive8truedrive +virtualdev -autostartprgmode 2 -autostart-handle-tde -autostart-warp
dotest $EMU tde-image    1   0 $OPTS $DRIVEOFF -device8 0 $IECDEVOFF -drive8truedrive +virtualdev -autostartprgmode 2 -autostart-handle-tde +autostart-warp
dotest $EMU tde-image    0 255 $OPTS $DRIVEOFF -device8 0 $IECDEVOFF -drive8truedrive -virtualdev -autostartprgmode 2 -autostart-handle-tde -autostart-warp
dotest $EMU tde-image    0 255 $OPTS $DRIVEOFF -device8 0 $IECDEVOFF -drive8truedrive -virtualdev -autostartprgmode 2 -autostart-handle-tde +autostart-warp
# none
dotest $EMU none-image   0 255 $OPTS $DRIVEOFF -device8 0 $IECDEVOFF +drive8truedrive +virtualdev -autostartprgmode 2 -autostart-handle-tde -autostart-warp
dotest $EMU none-image   0 255 $OPTS $DRIVEOFF -device8 0 $IECDEVOFF +drive8truedrive +virtualdev -autostartprgmode 2 -autostart-handle-tde +autostart-warp
# vfs only
dotest $EMU vdrive-image 1   0 $OPTS $DRIVEOFF -device8 0 $IECDEVOFF +drive8truedrive -virtualdev -autostartprgmode 2 -autostart-handle-tde -autostart-warp
dotest $EMU vdrive-image 1   0 $OPTS $DRIVEOFF -device8 0 $IECDEVOFF +drive8truedrive -virtualdev -autostartprgmode 2 -autostart-handle-tde +autostart-warp
if [ "$IECDEVICE" = "yes" ]; then
dotest $EMU tde-image    0 255 $OPTS $DRIVEOFF -device8 0 $IECDEVON  -drive8truedrive +virtualdev -autostartprgmode 2 -autostart-handle-tde -autostart-warp
dotest $EMU tde-image    0 255 $OPTS $DRIVEOFF -device8 0 $IECDEVON  -drive8truedrive +virtualdev -autostartprgmode 2 -autostart-handle-tde +autostart-warp
dotest $EMU tde-image    0 255 $OPTS $DRIVEOFF -device8 0 $IECDEVON  -drive8truedrive -virtualdev -autostartprgmode 2 -autostart-handle-tde -autostart-warp
dotest $EMU tde-image    0 255 $OPTS $DRIVEOFF -device8 0 $IECDEVON  -drive8truedrive -virtualdev -autostartprgmode 2 -autostart-handle-tde +autostart-warp
# iecdev only
dotest $EMU vdrive-image 1   0 $OPTS $DRIVEOFF -device8 0 $IECDEVON  +drive8truedrive +virtualdev -autostartprgmode 2 -autostart-handle-tde -autostart-warp
dotest $EMU vdrive-image 1   0 $OPTS $DRIVEOFF -device8 0 $IECDEVON  +drive8truedrive +virtualdev -autostartprgmode 2 -autostart-handle-tde +autostart-warp
dotest $EMU vdrive-image 0 255 $OPTS $DRIVEOFF -device8 0 $IECDEVON  +drive8truedrive -virtualdev -autostartprgmode 2 -autostart-handle-tde -autostart-warp
dotest $EMU vdrive-image 0 255 $OPTS $DRIVEOFF -device8 0 $IECDEVON  +drive8truedrive -virtualdev -autostartprgmode 2 -autostart-handle-tde +autostart-warp
fi

## fsdevice = filesystem
# TDEonly
dotest $EMU tde-image    1   0 $OPTS $DRIVEOFF -device8 1 $IECDEVOFF -drive8truedrive +virtualdev -autostartprgmode 2 -autostart-handle-tde -autostart-warp
dotest $EMU tde-image    1   0 $OPTS $DRIVEOFF -device8 1 $IECDEVOFF -drive8truedrive +virtualdev -autostartprgmode 2 -autostart-handle-tde +autostart-warp
dotest $EMU tde-image    0 255 $OPTS $DRIVEOFF -device8 1 $IECDEVOFF -drive8truedrive -virtualdev -autostartprgmode 2 -autostart-handle-tde -autostart-warp
dotest $EMU tde-image    0 255 $OPTS $DRIVEOFF -device8 1 $IECDEVOFF -drive8truedrive -virtualdev -autostartprgmode 2 -autostart-handle-tde +autostart-warp
# none
dotest $EMU none-image   0 255 $OPTS $DRIVEOFF -device8 1 $IECDEVOFF +drive8truedrive +virtualdev -autostartprgmode 2 -autostart-handle-tde -autostart-warp
dotest $EMU none-image   0 255 $OPTS $DRIVEOFF -device8 1 $IECDEVOFF +drive8truedrive +virtualdev -autostartprgmode 2 -autostart-handle-tde +autostart-warp
# vfs only
dotest $EMU vdrive-image 1   0 $OPTS $DRIVEOFF -device8 1 $IECDEVOFF +drive8truedrive -virtualdev -autostartprgmode 2 -autostart-handle-tde -autostart-warp
dotest $EMU vdrive-image 1   0 $OPTS $DRIVEOFF -device8 1 $IECDEVOFF +drive8truedrive -virtualdev -autostartprgmode 2 -autostart-handle-tde +autostart-warp
if [ "$IECDEVICE" = "yes" ]; then
dotest $EMU tde-image    0 255 $OPTS $DRIVEOFF -device8 1 $IECDEVON  -drive8truedrive +virtualdev -autostartprgmode 2 -autostart-handle-tde -autostart-warp
dotest $EMU tde-image    0 255 $OPTS $DRIVEOFF -device8 1 $IECDEVON  -drive8truedrive +virtualdev -autostartprgmode 2 -autostart-handle-tde +autostart-warp
dotest $EMU tde-image    0 255 $OPTS $DRIVEOFF -device8 1 $IECDEVON  -drive8truedrive -virtualdev -autostartprgmode 2 -autostart-handle-tde -autostart-warp
dotest $EMU tde-image    0 255 $OPTS $DRIVEOFF -device8 1 $IECDEVON  -drive8truedrive -virtualdev -autostartprgmode 2 -autostart-handle-tde +autostart-warp
# iecdev only
dotest $EMU vdrive-image 1   0 $OPTS $DRIVEOFF -device8 1 $IECDEVON  +drive8truedrive +virtualdev -autostartprgmode 2 -autostart-handle-tde -autostart-warp
dotest $EMU vdrive-image 1   0 $OPTS $DRIVEOFF -device8 1 $IECDEVON  +drive8truedrive +virtualdev -autostartprgmode 2 -autostart-handle-tde +autostart-warp
dotest $EMU vdrive-image 0 255 $OPTS $DRIVEOFF -device8 1 $IECDEVON  +drive8truedrive -virtualdev -autostartprgmode 2 -autostart-handle-tde -autostart-warp
dotest $EMU vdrive-image 0 255 $OPTS $DRIVEOFF -device8 1 $IECDEVON  +drive8truedrive -virtualdev -autostartprgmode 2 -autostart-handle-tde +autostart-warp
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

echo "autostart mode 0 (virtual filesystem) - do not handle TDE"
## fsdevice = none
# TDEonly
dotest $EMU tde         1   0 $OPTS $DRIVEON -device8 0 $IECDEVOFF -drive8truedrive +virtualdev -autostartprgmode 0 +autostart-handle-tde -autostart-warp
dotest $EMU tde         1   0 $OPTS $DRIVEON -device8 0 $IECDEVOFF -drive8truedrive +virtualdev -autostartprgmode 0 +autostart-handle-tde +autostart-warp
dotest $EMU tde         0 255 $OPTS $DRIVEON -device8 0 $IECDEVOFF -drive8truedrive -virtualdev -autostartprgmode 0 +autostart-handle-tde -autostart-warp
dotest $EMU tde         0 255 $OPTS $DRIVEON -device8 0 $IECDEVOFF -drive8truedrive -virtualdev -autostartprgmode 0 +autostart-handle-tde +autostart-warp
# none
dotest $EMU none        1   0 $OPTS $DRIVEON -device8 0 $IECDEVOFF +drive8truedrive +virtualdev -autostartprgmode 0 +autostart-handle-tde -autostart-warp
dotest $EMU none        1   0 $OPTS $DRIVEON -device8 0 $IECDEVOFF +drive8truedrive +virtualdev -autostartprgmode 0 +autostart-handle-tde +autostart-warp
# vfs only
dotest $EMU none        1   0 $OPTS $DRIVEON -device8 0 $IECDEVOFF +drive8truedrive -virtualdev -autostartprgmode 0 +autostart-handle-tde -autostart-warp
dotest $EMU none        1   0 $OPTS $DRIVEON -device8 0 $IECDEVOFF +drive8truedrive -virtualdev -autostartprgmode 0 +autostart-handle-tde +autostart-warp
if [ "$IECDEVICE" = "yes" ]; then
dotest $EMU tde         0 255 $OPTS $DRIVEON -device8 0 $IECDEVON  -drive8truedrive +virtualdev -autostartprgmode 0 +autostart-handle-tde -autostart-warp
dotest $EMU tde         0 255 $OPTS $DRIVEON -device8 0 $IECDEVON  -drive8truedrive +virtualdev -autostartprgmode 0 +autostart-handle-tde +autostart-warp
dotest $EMU tde         0 255 $OPTS $DRIVEON -device8 0 $IECDEVON  -drive8truedrive -virtualdev -autostartprgmode 0 +autostart-handle-tde -autostart-warp
dotest $EMU tde         0 255 $OPTS $DRIVEON -device8 0 $IECDEVON  -drive8truedrive -virtualdev -autostartprgmode 0 +autostart-handle-tde +autostart-warp
# iecdev only
dotest $EMU none        1   0 $OPTS $DRIVEON -device8 0 $IECDEVON  +drive8truedrive +virtualdev -autostartprgmode 0 +autostart-handle-tde -autostart-warp
dotest $EMU none        1   0 $OPTS $DRIVEON -device8 0 $IECDEVON  +drive8truedrive +virtualdev -autostartprgmode 0 +autostart-handle-tde +autostart-warp
dotest $EMU vfs         0 255 $OPTS $DRIVEON -device8 0 $IECDEVON  +drive8truedrive -virtualdev -autostartprgmode 0 +autostart-handle-tde -autostart-warp
dotest $EMU vfs         0 255 $OPTS $DRIVEON -device8 0 $IECDEVON  +drive8truedrive -virtualdev -autostartprgmode 0 +autostart-handle-tde +autostart-warp
fi

## fsdevice = filesystem
# TDEonly
dotest $EMU tde         1   0 $OPTS $DRIVEON -device8 1 $IECDEVOFF -drive8truedrive +virtualdev -autostartprgmode 0 +autostart-handle-tde -autostart-warp
dotest $EMU tde         1   0 $OPTS $DRIVEON -device8 1 $IECDEVOFF -drive8truedrive +virtualdev -autostartprgmode 0 +autostart-handle-tde +autostart-warp
dotest $EMU tde         0 255 $OPTS $DRIVEON -device8 1 $IECDEVOFF -drive8truedrive -virtualdev -autostartprgmode 0 +autostart-handle-tde -autostart-warp
dotest $EMU tde         0 255 $OPTS $DRIVEON -device8 1 $IECDEVOFF -drive8truedrive -virtualdev -autostartprgmode 0 +autostart-handle-tde +autostart-warp
# none
dotest $EMU none        1   0 $OPTS $DRIVEON -device8 1 $IECDEVOFF +drive8truedrive +virtualdev -autostartprgmode 0 +autostart-handle-tde -autostart-warp
dotest $EMU none        1   0 $OPTS $DRIVEON -device8 1 $IECDEVOFF +drive8truedrive +virtualdev -autostartprgmode 0 +autostart-handle-tde +autostart-warp
# vfs only
dotest $EMU vfs         1   0 $OPTS $DRIVEON -device8 1 $IECDEVOFF +drive8truedrive -virtualdev -autostartprgmode 0 +autostart-handle-tde -autostart-warp
dotest $EMU vfs         1   0 $OPTS $DRIVEON -device8 1 $IECDEVOFF +drive8truedrive -virtualdev -autostartprgmode 0 +autostart-handle-tde +autostart-warp
if [ "$IECDEVICE" = "yes" ]; then
dotest $EMU tde         0 255 $OPTS $DRIVEON -device8 1 $IECDEVON  -drive8truedrive +virtualdev -autostartprgmode 0 +autostart-handle-tde -autostart-warp
dotest $EMU tde         0 255 $OPTS $DRIVEON -device8 1 $IECDEVON  -drive8truedrive +virtualdev -autostartprgmode 0 +autostart-handle-tde +autostart-warp
dotest $EMU tde         0 255 $OPTS $DRIVEON -device8 1 $IECDEVON  -drive8truedrive -virtualdev -autostartprgmode 0 +autostart-handle-tde -autostart-warp
dotest $EMU tde         0 255 $OPTS $DRIVEON -device8 1 $IECDEVON  -drive8truedrive -virtualdev -autostartprgmode 0 +autostart-handle-tde +autostart-warp
# iecdev only
dotest $EMU vfs         1   0 $OPTS $DRIVEON -device8 1 $IECDEVON  +drive8truedrive +virtualdev -autostartprgmode 0 +autostart-handle-tde -autostart-warp
dotest $EMU vfs         1   0 $OPTS $DRIVEON -device8 1 $IECDEVON  +drive8truedrive +virtualdev -autostartprgmode 0 +autostart-handle-tde +autostart-warp
dotest $EMU vfs         0 255 $OPTS $DRIVEON -device8 1 $IECDEVON  +drive8truedrive -virtualdev -autostartprgmode 0 +autostart-handle-tde -autostart-warp
dotest $EMU vfs         0 255 $OPTS $DRIVEON -device8 1 $IECDEVON  +drive8truedrive -virtualdev -autostartprgmode 0 +autostart-handle-tde +autostart-warp
fi

echo "autostart mode 1 (inject to RAM) - do not handle TDE"
## fsdevice = none
# TDEonly
dotest $EMU tde         1   0 $OPTS $DRIVEON -device8 0 $IECDEVOFF -drive8truedrive +virtualdev -autostartprgmode 1 +autostart-handle-tde -autostart-warp
dotest $EMU tde         1   0 $OPTS $DRIVEON -device8 0 $IECDEVOFF -drive8truedrive +virtualdev -autostartprgmode 1 +autostart-handle-tde +autostart-warp
dotest $EMU tde         0 255 $OPTS $DRIVEON -device8 0 $IECDEVOFF -drive8truedrive -virtualdev -autostartprgmode 1 +autostart-handle-tde -autostart-warp
dotest $EMU tde         0 255 $OPTS $DRIVEON -device8 0 $IECDEVOFF -drive8truedrive -virtualdev -autostartprgmode 1 +autostart-handle-tde +autostart-warp
# none
dotest $EMU none        1   0 $OPTS $DRIVEON -device8 0 $IECDEVOFF +drive8truedrive +virtualdev -autostartprgmode 1 +autostart-handle-tde -autostart-warp
dotest $EMU none        1   0 $OPTS $DRIVEON -device8 0 $IECDEVOFF +drive8truedrive +virtualdev -autostartprgmode 1 +autostart-handle-tde +autostart-warp
# vfs only
dotest $EMU none        1   0 $OPTS $DRIVEON -device8 0 $IECDEVOFF +drive8truedrive -virtualdev -autostartprgmode 1 +autostart-handle-tde -autostart-warp
dotest $EMU none        1   0 $OPTS $DRIVEON -device8 0 $IECDEVOFF +drive8truedrive -virtualdev -autostartprgmode 1 +autostart-handle-tde +autostart-warp
if [ "$IECDEVICE" = "yes" ]; then
dotest $EMU tde         0 255 $OPTS $DRIVEON -device8 0 $IECDEVON  -drive8truedrive +virtualdev -autostartprgmode 1 +autostart-handle-tde -autostart-warp
dotest $EMU tde         0 255 $OPTS $DRIVEON -device8 0 $IECDEVON  -drive8truedrive +virtualdev -autostartprgmode 1 +autostart-handle-tde +autostart-warp
dotest $EMU tde         0 255 $OPTS $DRIVEON -device8 0 $IECDEVON  -drive8truedrive -virtualdev -autostartprgmode 1 +autostart-handle-tde -autostart-warp
dotest $EMU tde         0 255 $OPTS $DRIVEON -device8 0 $IECDEVON  -drive8truedrive -virtualdev -autostartprgmode 1 +autostart-handle-tde +autostart-warp
# iecdev only
dotest $EMU none        1   0 $OPTS $DRIVEON -device8 0 $IECDEVON  +drive8truedrive +virtualdev -autostartprgmode 1 +autostart-handle-tde -autostart-warp
dotest $EMU none        1   0 $OPTS $DRIVEON -device8 0 $IECDEVON  +drive8truedrive +virtualdev -autostartprgmode 1 +autostart-handle-tde +autostart-warp
dotest $EMU vfs         0 255 $OPTS $DRIVEON -device8 0 $IECDEVON  +drive8truedrive -virtualdev -autostartprgmode 1 +autostart-handle-tde -autostart-warp
dotest $EMU vfs         0 255 $OPTS $DRIVEON -device8 0 $IECDEVON  +drive8truedrive -virtualdev -autostartprgmode 1 +autostart-handle-tde +autostart-warp
fi

## fsdevice = filesystem
# TDEonly
dotest $EMU tde         1   0 $OPTS $DRIVEON -device8 1 $IECDEVOFF -drive8truedrive +virtualdev -autostartprgmode 1 +autostart-handle-tde -autostart-warp
dotest $EMU tde         1   0 $OPTS $DRIVEON -device8 1 $IECDEVOFF -drive8truedrive +virtualdev -autostartprgmode 1 +autostart-handle-tde +autostart-warp
dotest $EMU tde         0 255 $OPTS $DRIVEON -device8 1 $IECDEVOFF -drive8truedrive -virtualdev -autostartprgmode 1 +autostart-handle-tde -autostart-warp
dotest $EMU tde         0 255 $OPTS $DRIVEON -device8 1 $IECDEVOFF -drive8truedrive -virtualdev -autostartprgmode 1 +autostart-handle-tde +autostart-warp
# none
dotest $EMU none        1   0 $OPTS $DRIVEON -device8 1 $IECDEVOFF +drive8truedrive +virtualdev -autostartprgmode 1 +autostart-handle-tde -autostart-warp
dotest $EMU none        1   0 $OPTS $DRIVEON -device8 1 $IECDEVOFF +drive8truedrive +virtualdev -autostartprgmode 1 +autostart-handle-tde +autostart-warp
# vfs only
dotest $EMU vfs         1   0 $OPTS $DRIVEON -device8 1 $IECDEVOFF +drive8truedrive -virtualdev -autostartprgmode 1 +autostart-handle-tde -autostart-warp
dotest $EMU vfs         1   0 $OPTS $DRIVEON -device8 1 $IECDEVOFF +drive8truedrive -virtualdev -autostartprgmode 1 +autostart-handle-tde +autostart-warp
if [ "$IECDEVICE" = "yes" ]; then
dotest $EMU tde         0 255 $OPTS $DRIVEON -device8 1 $IECDEVON  -drive8truedrive +virtualdev -autostartprgmode 1 +autostart-handle-tde -autostart-warp
dotest $EMU tde         0 255 $OPTS $DRIVEON -device8 1 $IECDEVON  -drive8truedrive +virtualdev -autostartprgmode 1 +autostart-handle-tde +autostart-warp
dotest $EMU tde         0 255 $OPTS $DRIVEON -device8 1 $IECDEVON  -drive8truedrive -virtualdev -autostartprgmode 1 +autostart-handle-tde -autostart-warp
dotest $EMU tde         0 255 $OPTS $DRIVEON -device8 1 $IECDEVON  -drive8truedrive -virtualdev -autostartprgmode 1 +autostart-handle-tde +autostart-warp
# iecdev only
dotest $EMU vfs         1   0 $OPTS $DRIVEON -device8 1 $IECDEVON  +drive8truedrive +virtualdev -autostartprgmode 1 +autostart-handle-tde -autostart-warp
dotest $EMU vfs         1   0 $OPTS $DRIVEON -device8 1 $IECDEVON  +drive8truedrive +virtualdev -autostartprgmode 1 +autostart-handle-tde +autostart-warp
dotest $EMU vfs         0 255 $OPTS $DRIVEON -device8 1 $IECDEVON  +drive8truedrive -virtualdev -autostartprgmode 1 +autostart-handle-tde -autostart-warp
dotest $EMU vfs         0 255 $OPTS $DRIVEON -device8 1 $IECDEVON  +drive8truedrive -virtualdev -autostartprgmode 1 +autostart-handle-tde +autostart-warp
fi

echo "autostart mode 0 (virtual filesystem) - handle TDE"
## fsdevice = none
# TDEonly
dotest $EMU tde         1   0 $OPTS $DRIVEON -device8 0 $IECDEVOFF -drive8truedrive +virtualdev -autostartprgmode 0 -autostart-handle-tde -autostart-warp
dotest $EMU tde         1   0 $OPTS $DRIVEON -device8 0 $IECDEVOFF -drive8truedrive +virtualdev -autostartprgmode 0 -autostart-handle-tde +autostart-warp
dotest $EMU tde         0 255 $OPTS $DRIVEON -device8 0 $IECDEVOFF -drive8truedrive -virtualdev -autostartprgmode 0 -autostart-handle-tde -autostart-warp
dotest $EMU tde         0 255 $OPTS $DRIVEON -device8 0 $IECDEVOFF -drive8truedrive -virtualdev -autostartprgmode 0 -autostart-handle-tde +autostart-warp
# none
dotest $EMU none        1   0 $OPTS $DRIVEON -device8 0 $IECDEVOFF +drive8truedrive +virtualdev -autostartprgmode 0 -autostart-handle-tde -autostart-warp
dotest $EMU none        1   0 $OPTS $DRIVEON -device8 0 $IECDEVOFF +drive8truedrive +virtualdev -autostartprgmode 0 -autostart-handle-tde +autostart-warp
# vfs only
dotest $EMU none        1   0 $OPTS $DRIVEON -device8 0 $IECDEVOFF +drive8truedrive -virtualdev -autostartprgmode 0 -autostart-handle-tde -autostart-warp
dotest $EMU none        1   0 $OPTS $DRIVEON -device8 0 $IECDEVOFF +drive8truedrive -virtualdev -autostartprgmode 0 -autostart-handle-tde +autostart-warp
if [ "$IECDEVICE" = "yes" ]; then
dotest $EMU tde         0 255 $OPTS $DRIVEON -device8 0 $IECDEVON  -drive8truedrive +virtualdev -autostartprgmode 0 -autostart-handle-tde -autostart-warp
dotest $EMU tde         0 255 $OPTS $DRIVEON -device8 0 $IECDEVON  -drive8truedrive +virtualdev -autostartprgmode 0 -autostart-handle-tde +autostart-warp
dotest $EMU tde         0 255 $OPTS $DRIVEON -device8 0 $IECDEVON  -drive8truedrive -virtualdev -autostartprgmode 0 -autostart-handle-tde -autostart-warp
dotest $EMU tde         0 255 $OPTS $DRIVEON -device8 0 $IECDEVON  -drive8truedrive -virtualdev -autostartprgmode 0 -autostart-handle-tde +autostart-warp
# iecdev only
dotest $EMU none        1   0 $OPTS $DRIVEON -device8 0 $IECDEVON  +drive8truedrive +virtualdev -autostartprgmode 0 -autostart-handle-tde -autostart-warp
dotest $EMU none        1   0 $OPTS $DRIVEON -device8 0 $IECDEVON  +drive8truedrive +virtualdev -autostartprgmode 0 -autostart-handle-tde +autostart-warp
dotest $EMU vfs         0 255 $OPTS $DRIVEON -device8 0 $IECDEVON  +drive8truedrive -virtualdev -autostartprgmode 0 -autostart-handle-tde -autostart-warp
dotest $EMU vfs         0 255 $OPTS $DRIVEON -device8 0 $IECDEVON  +drive8truedrive -virtualdev -autostartprgmode 0 -autostart-handle-tde +autostart-warp
fi

## fsdevice = filesystem
# TDEonly
dotest $EMU tde         1   0 $OPTS $DRIVEON -device8 1 $IECDEVOFF -drive8truedrive +virtualdev -autostartprgmode 0 -autostart-handle-tde -autostart-warp
dotest $EMU tde         1   0 $OPTS $DRIVEON -device8 1 $IECDEVOFF -drive8truedrive +virtualdev -autostartprgmode 0 -autostart-handle-tde +autostart-warp
dotest $EMU tde         0 255 $OPTS $DRIVEON -device8 1 $IECDEVOFF -drive8truedrive -virtualdev -autostartprgmode 0 -autostart-handle-tde -autostart-warp
dotest $EMU tde         0 255 $OPTS $DRIVEON -device8 1 $IECDEVOFF -drive8truedrive -virtualdev -autostartprgmode 0 -autostart-handle-tde +autostart-warp
# none
dotest $EMU none        1   0 $OPTS $DRIVEON -device8 1 $IECDEVOFF +drive8truedrive +virtualdev -autostartprgmode 0 -autostart-handle-tde -autostart-warp
dotest $EMU none        1   0 $OPTS $DRIVEON -device8 1 $IECDEVOFF +drive8truedrive +virtualdev -autostartprgmode 0 -autostart-handle-tde +autostart-warp
# vfs only
dotest $EMU vfs         1   0 $OPTS $DRIVEON -device8 1 $IECDEVOFF +drive8truedrive -virtualdev -autostartprgmode 0 -autostart-handle-tde -autostart-warp
dotest $EMU vfs         1   0 $OPTS $DRIVEON -device8 1 $IECDEVOFF +drive8truedrive -virtualdev -autostartprgmode 0 -autostart-handle-tde +autostart-warp
if [ "$IECDEVICE" = "yes" ]; then
dotest $EMU tde         0 255 $OPTS $DRIVEON -device8 1 $IECDEVON  -drive8truedrive +virtualdev -autostartprgmode 0 -autostart-handle-tde -autostart-warp
dotest $EMU tde         0 255 $OPTS $DRIVEON -device8 1 $IECDEVON  -drive8truedrive +virtualdev -autostartprgmode 0 -autostart-handle-tde +autostart-warp
dotest $EMU tde         0 255 $OPTS $DRIVEON -device8 1 $IECDEVON  -drive8truedrive -virtualdev -autostartprgmode 0 -autostart-handle-tde -autostart-warp
dotest $EMU tde         0 255 $OPTS $DRIVEON -device8 1 $IECDEVON  -drive8truedrive -virtualdev -autostartprgmode 0 -autostart-handle-tde +autostart-warp
# iecdev only
dotest $EMU vfs         1   0 $OPTS $DRIVEON -device8 1 $IECDEVON  +drive8truedrive +virtualdev -autostartprgmode 0 -autostart-handle-tde -autostart-warp
dotest $EMU vfs         1   0 $OPTS $DRIVEON -device8 1 $IECDEVON  +drive8truedrive +virtualdev -autostartprgmode 0 -autostart-handle-tde +autostart-warp
dotest $EMU vfs         0 255 $OPTS $DRIVEON -device8 1 $IECDEVON  +drive8truedrive -virtualdev -autostartprgmode 0 -autostart-handle-tde -autostart-warp
dotest $EMU vfs         0 255 $OPTS $DRIVEON -device8 1 $IECDEVON  +drive8truedrive -virtualdev -autostartprgmode 0 -autostart-handle-tde +autostart-warp
fi

echo "autostart mode 1 (inject to RAM) - handle TDE"
## fsdevice = none
# TDEonly
dotest $EMU tde         1   0 $OPTS $DRIVEON -device8 0 $IECDEVOFF -drive8truedrive +virtualdev -autostartprgmode 1 -autostart-handle-tde -autostart-warp
dotest $EMU tde         1   0 $OPTS $DRIVEON -device8 0 $IECDEVOFF -drive8truedrive +virtualdev -autostartprgmode 1 -autostart-handle-tde +autostart-warp
dotest $EMU tde         0 255 $OPTS $DRIVEON -device8 0 $IECDEVOFF -drive8truedrive -virtualdev -autostartprgmode 1 -autostart-handle-tde -autostart-warp
dotest $EMU tde         0 255 $OPTS $DRIVEON -device8 0 $IECDEVOFF -drive8truedrive -virtualdev -autostartprgmode 1 -autostart-handle-tde +autostart-warp
# none
dotest $EMU none        1   0 $OPTS $DRIVEON -device8 0 $IECDEVOFF +drive8truedrive +virtualdev -autostartprgmode 1 -autostart-handle-tde -autostart-warp
dotest $EMU none        1   0 $OPTS $DRIVEON -device8 0 $IECDEVOFF +drive8truedrive +virtualdev -autostartprgmode 1 -autostart-handle-tde +autostart-warp
# vfs only
dotest $EMU none        1   0 $OPTS $DRIVEON -device8 0 $IECDEVOFF +drive8truedrive -virtualdev -autostartprgmode 1 -autostart-handle-tde -autostart-warp
dotest $EMU none        1   0 $OPTS $DRIVEON -device8 0 $IECDEVOFF +drive8truedrive -virtualdev -autostartprgmode 1 -autostart-handle-tde +autostart-warp
if [ "$IECDEVICE" = "yes" ]; then
dotest $EMU tde         0 255 $OPTS $DRIVEON -device8 0 $IECDEVON  -drive8truedrive +virtualdev -autostartprgmode 1 -autostart-handle-tde -autostart-warp
dotest $EMU tde         0 255 $OPTS $DRIVEON -device8 0 $IECDEVON  -drive8truedrive +virtualdev -autostartprgmode 1 -autostart-handle-tde +autostart-warp
dotest $EMU tde         0 255 $OPTS $DRIVEON -device8 0 $IECDEVON  -drive8truedrive -virtualdev -autostartprgmode 1 -autostart-handle-tde -autostart-warp
dotest $EMU tde         0 255 $OPTS $DRIVEON -device8 0 $IECDEVON  -drive8truedrive -virtualdev -autostartprgmode 1 -autostart-handle-tde +autostart-warp
# iecdev only
dotest $EMU none        1   0 $OPTS $DRIVEON -device8 0 $IECDEVON  +drive8truedrive +virtualdev -autostartprgmode 1 -autostart-handle-tde -autostart-warp
dotest $EMU none        1   0 $OPTS $DRIVEON -device8 0 $IECDEVON  +drive8truedrive +virtualdev -autostartprgmode 1 -autostart-handle-tde +autostart-warp
dotest $EMU vfs         0 255 $OPTS $DRIVEON -device8 0 $IECDEVON  +drive8truedrive -virtualdev -autostartprgmode 1 -autostart-handle-tde -autostart-warp
dotest $EMU vfs         0 255 $OPTS $DRIVEON -device8 0 $IECDEVON  +drive8truedrive -virtualdev -autostartprgmode 1 -autostart-handle-tde +autostart-warp
fi

## fsdevice = filesystem
# TDEonly
dotest $EMU tde         1   0 $OPTS $DRIVEON -device8 1 $IECDEVOFF -drive8truedrive +virtualdev -autostartprgmode 1 -autostart-handle-tde -autostart-warp
dotest $EMU tde         1   0 $OPTS $DRIVEON -device8 1 $IECDEVOFF -drive8truedrive +virtualdev -autostartprgmode 1 -autostart-handle-tde +autostart-warp
dotest $EMU tde         0 255 $OPTS $DRIVEON -device8 1 $IECDEVOFF -drive8truedrive -virtualdev -autostartprgmode 1 -autostart-handle-tde -autostart-warp
dotest $EMU tde         0 255 $OPTS $DRIVEON -device8 1 $IECDEVOFF -drive8truedrive -virtualdev -autostartprgmode 1 -autostart-handle-tde +autostart-warp
# none
dotest $EMU none        1   0 $OPTS $DRIVEON -device8 1 $IECDEVOFF +drive8truedrive +virtualdev -autostartprgmode 1 -autostart-handle-tde -autostart-warp
dotest $EMU none        1   0 $OPTS $DRIVEON -device8 1 $IECDEVOFF +drive8truedrive +virtualdev -autostartprgmode 1 -autostart-handle-tde +autostart-warp
# vfs only
dotest $EMU vfs         1   0 $OPTS $DRIVEON -device8 1 $IECDEVOFF +drive8truedrive -virtualdev -autostartprgmode 1 -autostart-handle-tde -autostart-warp
dotest $EMU vfs         1   0 $OPTS $DRIVEON -device8 1 $IECDEVOFF +drive8truedrive -virtualdev -autostartprgmode 1 -autostart-handle-tde +autostart-warp
if [ "$IECDEVICE" = "yes" ]; then
dotest $EMU tde         0 255 $OPTS $DRIVEON -device8 1 $IECDEVON  -drive8truedrive +virtualdev -autostartprgmode 1 -autostart-handle-tde -autostart-warp
dotest $EMU tde         0 255 $OPTS $DRIVEON -device8 1 $IECDEVON  -drive8truedrive +virtualdev -autostartprgmode 1 -autostart-handle-tde +autostart-warp
dotest $EMU tde         0 255 $OPTS $DRIVEON -device8 1 $IECDEVON  -drive8truedrive -virtualdev -autostartprgmode 1 -autostart-handle-tde -autostart-warp
dotest $EMU tde         0 255 $OPTS $DRIVEON -device8 1 $IECDEVON  -drive8truedrive -virtualdev -autostartprgmode 1 -autostart-handle-tde +autostart-warp
# iecdev only
dotest $EMU vfs         1   0 $OPTS $DRIVEON -device8 1 $IECDEVON  +drive8truedrive +virtualdev -autostartprgmode 1 -autostart-handle-tde -autostart-warp
dotest $EMU vfs         1   0 $OPTS $DRIVEON -device8 1 $IECDEVON  +drive8truedrive +virtualdev -autostartprgmode 1 -autostart-handle-tde +autostart-warp
dotest $EMU vfs         0 255 $OPTS $DRIVEON -device8 1 $IECDEVON  +drive8truedrive -virtualdev -autostartprgmode 1 -autostart-handle-tde -autostart-warp
dotest $EMU vfs         0 255 $OPTS $DRIVEON -device8 1 $IECDEVON  +drive8truedrive -virtualdev -autostartprgmode 1 -autostart-handle-tde +autostart-warp
fi

# with drivetype = none

echo "autostart mode 0 (virtual filesystem) - do not handle TDE"
## fsdevice = none
# TDEonly
dotest $EMU none        1   0 $OPTS $DRIVEOFF -device8 0 $IECDEVOFF -drive8truedrive +virtualdev -autostartprgmode 0 +autostart-handle-tde -autostart-warp
dotest $EMU none        1   0 $OPTS $DRIVEOFF -device8 0 $IECDEVOFF -drive8truedrive +virtualdev -autostartprgmode 0 +autostart-handle-tde +autostart-warp
dotest $EMU tde         0 255 $OPTS $DRIVEOFF -device8 0 $IECDEVOFF -drive8truedrive -virtualdev -autostartprgmode 0 +autostart-handle-tde -autostart-warp
dotest $EMU tde         0 255 $OPTS $DRIVEOFF -device8 0 $IECDEVOFF -drive8truedrive -virtualdev -autostartprgmode 0 +autostart-handle-tde +autostart-warp
# none
dotest $EMU none        1   0 $OPTS $DRIVEOFF -device8 0 $IECDEVOFF +drive8truedrive +virtualdev -autostartprgmode 0 +autostart-handle-tde -autostart-warp
dotest $EMU none        1   0 $OPTS $DRIVEOFF -device8 0 $IECDEVOFF +drive8truedrive +virtualdev -autostartprgmode 0 +autostart-handle-tde +autostart-warp
# vfs only
dotest $EMU none        1   0 $OPTS $DRIVEOFF -device8 0 $IECDEVOFF +drive8truedrive -virtualdev -autostartprgmode 0 +autostart-handle-tde -autostart-warp
dotest $EMU none        1   0 $OPTS $DRIVEOFF -device8 0 $IECDEVOFF +drive8truedrive -virtualdev -autostartprgmode 0 +autostart-handle-tde +autostart-warp
if [ "$IECDEVICE" = "yes" ]; then
dotest $EMU tde         0 255 $OPTS $DRIVEOFF -device8 0 $IECDEVON  -drive8truedrive +virtualdev -autostartprgmode 0 +autostart-handle-tde -autostart-warp
dotest $EMU tde         0 255 $OPTS $DRIVEOFF -device8 0 $IECDEVON  -drive8truedrive +virtualdev -autostartprgmode 0 +autostart-handle-tde +autostart-warp
dotest $EMU tde         0 255 $OPTS $DRIVEOFF -device8 0 $IECDEVON  -drive8truedrive -virtualdev -autostartprgmode 0 +autostart-handle-tde -autostart-warp
dotest $EMU tde         0 255 $OPTS $DRIVEOFF -device8 0 $IECDEVON  -drive8truedrive -virtualdev -autostartprgmode 0 +autostart-handle-tde +autostart-warp
# iecdev only
dotest $EMU none        1   0 $OPTS $DRIVEOFF -device8 0 $IECDEVON  +drive8truedrive +virtualdev -autostartprgmode 0 +autostart-handle-tde -autostart-warp
dotest $EMU none        1   0 $OPTS $DRIVEOFF -device8 0 $IECDEVON  +drive8truedrive +virtualdev -autostartprgmode 0 +autostart-handle-tde +autostart-warp
dotest $EMU vfs         0 255 $OPTS $DRIVEOFF -device8 0 $IECDEVON  +drive8truedrive -virtualdev -autostartprgmode 0 +autostart-handle-tde -autostart-warp
dotest $EMU vfs         0 255 $OPTS $DRIVEOFF -device8 0 $IECDEVON  +drive8truedrive -virtualdev -autostartprgmode 0 +autostart-handle-tde +autostart-warp
fi

## fsdevice = filesystem
# TDEonly
dotest $EMU none        1   0 $OPTS $DRIVEOFF -device8 1 $IECDEVOFF -drive8truedrive +virtualdev -autostartprgmode 0 +autostart-handle-tde -autostart-warp
dotest $EMU none        1   0 $OPTS $DRIVEOFF -device8 1 $IECDEVOFF -drive8truedrive +virtualdev -autostartprgmode 0 +autostart-handle-tde +autostart-warp
dotest $EMU tde         0 255 $OPTS $DRIVEOFF -device8 1 $IECDEVOFF -drive8truedrive -virtualdev -autostartprgmode 0 +autostart-handle-tde -autostart-warp
dotest $EMU tde         0 255 $OPTS $DRIVEOFF -device8 1 $IECDEVOFF -drive8truedrive -virtualdev -autostartprgmode 0 +autostart-handle-tde +autostart-warp
# none
dotest $EMU none        1   0 $OPTS $DRIVEOFF -device8 1 $IECDEVOFF +drive8truedrive +virtualdev -autostartprgmode 0 +autostart-handle-tde -autostart-warp
dotest $EMU none        1   0 $OPTS $DRIVEOFF -device8 1 $IECDEVOFF +drive8truedrive +virtualdev -autostartprgmode 0 +autostart-handle-tde +autostart-warp
# vfs only
dotest $EMU vfs         1   0 $OPTS $DRIVEOFF -device8 1 $IECDEVOFF +drive8truedrive -virtualdev -autostartprgmode 0 +autostart-handle-tde -autostart-warp
dotest $EMU vfs         1   0 $OPTS $DRIVEOFF -device8 1 $IECDEVOFF +drive8truedrive -virtualdev -autostartprgmode 0 +autostart-handle-tde +autostart-warp
if [ "$IECDEVICE" = "yes" ]; then
dotest $EMU tde         0 255 $OPTS $DRIVEOFF -device8 1 $IECDEVON  -drive8truedrive +virtualdev -autostartprgmode 0 +autostart-handle-tde -autostart-warp
dotest $EMU tde         0 255 $OPTS $DRIVEOFF -device8 1 $IECDEVON  -drive8truedrive +virtualdev -autostartprgmode 0 +autostart-handle-tde +autostart-warp
dotest $EMU tde         0 255 $OPTS $DRIVEOFF -device8 1 $IECDEVON  -drive8truedrive -virtualdev -autostartprgmode 0 +autostart-handle-tde -autostart-warp
dotest $EMU tde         0 255 $OPTS $DRIVEOFF -device8 1 $IECDEVON  -drive8truedrive -virtualdev -autostartprgmode 0 +autostart-handle-tde +autostart-warp
# iecdev only
dotest $EMU vfs         1   0 $OPTS $DRIVEOFF -device8 1 $IECDEVON  +drive8truedrive +virtualdev -autostartprgmode 0 +autostart-handle-tde -autostart-warp
dotest $EMU vfs         1   0 $OPTS $DRIVEOFF -device8 1 $IECDEVON  +drive8truedrive +virtualdev -autostartprgmode 0 +autostart-handle-tde +autostart-warp
dotest $EMU vfs         0 255 $OPTS $DRIVEOFF -device8 1 $IECDEVON  +drive8truedrive -virtualdev -autostartprgmode 0 +autostart-handle-tde -autostart-warp
dotest $EMU vfs         0 255 $OPTS $DRIVEOFF -device8 1 $IECDEVON  +drive8truedrive -virtualdev -autostartprgmode 0 +autostart-handle-tde +autostart-warp
fi

echo "autostart mode 1 (inject to RAM) - do not handle TDE"
## fsdevice = none
# TDEonly
dotest $EMU none        1   0 $OPTS $DRIVEOFF -device8 0 $IECDEVOFF -drive8truedrive +virtualdev -autostartprgmode 1 +autostart-handle-tde -autostart-warp
dotest $EMU none        1   0 $OPTS $DRIVEOFF -device8 0 $IECDEVOFF -drive8truedrive +virtualdev -autostartprgmode 1 +autostart-handle-tde +autostart-warp
dotest $EMU tde         0 255 $OPTS $DRIVEOFF -device8 0 $IECDEVOFF -drive8truedrive -virtualdev -autostartprgmode 1 +autostart-handle-tde -autostart-warp
dotest $EMU tde         0 255 $OPTS $DRIVEOFF -device8 0 $IECDEVOFF -drive8truedrive -virtualdev -autostartprgmode 1 +autostart-handle-tde +autostart-warp
# none
dotest $EMU none        1   0 $OPTS $DRIVEOFF -device8 0 $IECDEVOFF +drive8truedrive +virtualdev -autostartprgmode 1 +autostart-handle-tde -autostart-warp
dotest $EMU none        1   0 $OPTS $DRIVEOFF -device8 0 $IECDEVOFF +drive8truedrive +virtualdev -autostartprgmode 1 +autostart-handle-tde +autostart-warp
# vfs only
dotest $EMU none        1   0 $OPTS $DRIVEOFF -device8 0 $IECDEVOFF +drive8truedrive -virtualdev -autostartprgmode 1 +autostart-handle-tde -autostart-warp
dotest $EMU none        1   0 $OPTS $DRIVEOFF -device8 0 $IECDEVOFF +drive8truedrive -virtualdev -autostartprgmode 1 +autostart-handle-tde +autostart-warp
if [ "$IECDEVICE" = "yes" ]; then
dotest $EMU tde         0 255 $OPTS $DRIVEOFF -device8 0 $IECDEVON  -drive8truedrive +virtualdev -autostartprgmode 1 +autostart-handle-tde -autostart-warp
dotest $EMU tde         0 255 $OPTS $DRIVEOFF -device8 0 $IECDEVON  -drive8truedrive +virtualdev -autostartprgmode 1 +autostart-handle-tde +autostart-warp
dotest $EMU tde         0 255 $OPTS $DRIVEOFF -device8 0 $IECDEVON  -drive8truedrive -virtualdev -autostartprgmode 1 +autostart-handle-tde -autostart-warp
dotest $EMU tde         0 255 $OPTS $DRIVEOFF -device8 0 $IECDEVON  -drive8truedrive -virtualdev -autostartprgmode 1 +autostart-handle-tde +autostart-warp
# iecdev only
dotest $EMU none        1   0 $OPTS $DRIVEOFF -device8 0 $IECDEVON  +drive8truedrive +virtualdev -autostartprgmode 1 +autostart-handle-tde -autostart-warp
dotest $EMU none        1   0 $OPTS $DRIVEOFF -device8 0 $IECDEVON  +drive8truedrive +virtualdev -autostartprgmode 1 +autostart-handle-tde +autostart-warp
dotest $EMU vfs         0 255 $OPTS $DRIVEOFF -device8 0 $IECDEVON  +drive8truedrive -virtualdev -autostartprgmode 1 +autostart-handle-tde -autostart-warp
dotest $EMU vfs         0 255 $OPTS $DRIVEOFF -device8 0 $IECDEVON  +drive8truedrive -virtualdev -autostartprgmode 1 +autostart-handle-tde +autostart-warp
fi

## fsdevice = filesystem
# TDEonly
dotest $EMU none        1   0 $OPTS $DRIVEOFF -device8 1 $IECDEVOFF -drive8truedrive +virtualdev -autostartprgmode 1 +autostart-handle-tde -autostart-warp
dotest $EMU none        1   0 $OPTS $DRIVEOFF -device8 1 $IECDEVOFF -drive8truedrive +virtualdev -autostartprgmode 1 +autostart-handle-tde +autostart-warp
dotest $EMU tde         0 255 $OPTS $DRIVEOFF -device8 1 $IECDEVOFF -drive8truedrive -virtualdev -autostartprgmode 1 +autostart-handle-tde -autostart-warp
dotest $EMU tde         0 255 $OPTS $DRIVEOFF -device8 1 $IECDEVOFF -drive8truedrive -virtualdev -autostartprgmode 1 +autostart-handle-tde +autostart-warp
# none
dotest $EMU none        1   0 $OPTS $DRIVEOFF -device8 1 $IECDEVOFF +drive8truedrive +virtualdev -autostartprgmode 1 +autostart-handle-tde -autostart-warp
dotest $EMU none        1   0 $OPTS $DRIVEOFF -device8 1 $IECDEVOFF +drive8truedrive +virtualdev -autostartprgmode 1 +autostart-handle-tde +autostart-warp
# vfs only
dotest $EMU vfs         1   0 $OPTS $DRIVEOFF -device8 1 $IECDEVOFF +drive8truedrive -virtualdev -autostartprgmode 1 +autostart-handle-tde -autostart-warp
dotest $EMU vfs         1   0 $OPTS $DRIVEOFF -device8 1 $IECDEVOFF +drive8truedrive -virtualdev -autostartprgmode 1 +autostart-handle-tde +autostart-warp
if [ "$IECDEVICE" = "yes" ]; then
dotest $EMU tde         0 255 $OPTS $DRIVEOFF -device8 1 $IECDEVON  -drive8truedrive +virtualdev -autostartprgmode 1 +autostart-handle-tde -autostart-warp
dotest $EMU tde         0 255 $OPTS $DRIVEOFF -device8 1 $IECDEVON  -drive8truedrive +virtualdev -autostartprgmode 1 +autostart-handle-tde +autostart-warp
dotest $EMU tde         0 255 $OPTS $DRIVEOFF -device8 1 $IECDEVON  -drive8truedrive -virtualdev -autostartprgmode 1 +autostart-handle-tde -autostart-warp
dotest $EMU tde         0 255 $OPTS $DRIVEOFF -device8 1 $IECDEVON  -drive8truedrive -virtualdev -autostartprgmode 1 +autostart-handle-tde +autostart-warp
# iecdev only
dotest $EMU vfs         1   0 $OPTS $DRIVEOFF -device8 1 $IECDEVON  +drive8truedrive +virtualdev -autostartprgmode 1 +autostart-handle-tde -autostart-warp
dotest $EMU vfs         1   0 $OPTS $DRIVEOFF -device8 1 $IECDEVON  +drive8truedrive +virtualdev -autostartprgmode 1 +autostart-handle-tde +autostart-warp
dotest $EMU vfs         0 255 $OPTS $DRIVEOFF -device8 1 $IECDEVON  +drive8truedrive -virtualdev -autostartprgmode 1 +autostart-handle-tde -autostart-warp
dotest $EMU vfs         0 255 $OPTS $DRIVEOFF -device8 1 $IECDEVON  +drive8truedrive -virtualdev -autostartprgmode 1 +autostart-handle-tde +autostart-warp
fi

echo "autostart mode 0 (virtual filesystem) - handle TDE"
## fsdevice = none
# TDEonly
dotest $EMU none        1   0 $OPTS $DRIVEOFF -device8 0 $IECDEVOFF -drive8truedrive +virtualdev -autostartprgmode 0 -autostart-handle-tde -autostart-warp
dotest $EMU none        1   0 $OPTS $DRIVEOFF -device8 0 $IECDEVOFF -drive8truedrive +virtualdev -autostartprgmode 0 -autostart-handle-tde +autostart-warp
dotest $EMU tde         0 255 $OPTS $DRIVEOFF -device8 0 $IECDEVOFF -drive8truedrive -virtualdev -autostartprgmode 0 -autostart-handle-tde -autostart-warp
dotest $EMU tde         0 255 $OPTS $DRIVEOFF -device8 0 $IECDEVOFF -drive8truedrive -virtualdev -autostartprgmode 0 -autostart-handle-tde +autostart-warp
# none
dotest $EMU none        1   0 $OPTS $DRIVEOFF -device8 0 $IECDEVOFF +drive8truedrive +virtualdev -autostartprgmode 0 -autostart-handle-tde -autostart-warp
dotest $EMU none        1   0 $OPTS $DRIVEOFF -device8 0 $IECDEVOFF +drive8truedrive +virtualdev -autostartprgmode 0 -autostart-handle-tde +autostart-warp
# vfs only
dotest $EMU none        1   0 $OPTS $DRIVEOFF -device8 0 $IECDEVOFF +drive8truedrive -virtualdev -autostartprgmode 0 -autostart-handle-tde -autostart-warp
dotest $EMU none        1   0 $OPTS $DRIVEOFF -device8 0 $IECDEVOFF +drive8truedrive -virtualdev -autostartprgmode 0 -autostart-handle-tde +autostart-warp
if [ "$IECDEVICE" = "yes" ]; then
dotest $EMU tde         0 255 $OPTS $DRIVEOFF -device8 0 $IECDEVON  -drive8truedrive +virtualdev -autostartprgmode 0 -autostart-handle-tde -autostart-warp
dotest $EMU tde         0 255 $OPTS $DRIVEOFF -device8 0 $IECDEVON  -drive8truedrive +virtualdev -autostartprgmode 0 -autostart-handle-tde +autostart-warp
dotest $EMU tde         0 255 $OPTS $DRIVEOFF -device8 0 $IECDEVON  -drive8truedrive -virtualdev -autostartprgmode 0 -autostart-handle-tde -autostart-warp
dotest $EMU tde         0 255 $OPTS $DRIVEOFF -device8 0 $IECDEVON  -drive8truedrive -virtualdev -autostartprgmode 0 -autostart-handle-tde +autostart-warp
# iecdev only
dotest $EMU none        1   0 $OPTS $DRIVEOFF -device8 0 $IECDEVON  +drive8truedrive +virtualdev -autostartprgmode 0 -autostart-handle-tde -autostart-warp
dotest $EMU none        1   0 $OPTS $DRIVEOFF -device8 0 $IECDEVON  +drive8truedrive +virtualdev -autostartprgmode 0 -autostart-handle-tde +autostart-warp
dotest $EMU vfs         0 255 $OPTS $DRIVEOFF -device8 0 $IECDEVON  +drive8truedrive -virtualdev -autostartprgmode 0 -autostart-handle-tde -autostart-warp
dotest $EMU vfs         0 255 $OPTS $DRIVEOFF -device8 0 $IECDEVON  +drive8truedrive -virtualdev -autostartprgmode 0 -autostart-handle-tde +autostart-warp
fi

## fsdevice = filesystem
# TDEonly
dotest $EMU none        1   0 $OPTS $DRIVEOFF -device8 1 $IECDEVOFF -drive8truedrive +virtualdev -autostartprgmode 0 -autostart-handle-tde -autostart-warp
dotest $EMU none        1   0 $OPTS $DRIVEOFF -device8 1 $IECDEVOFF -drive8truedrive +virtualdev -autostartprgmode 0 -autostart-handle-tde +autostart-warp
dotest $EMU tde         0 255 $OPTS $DRIVEOFF -device8 1 $IECDEVOFF -drive8truedrive -virtualdev -autostartprgmode 0 -autostart-handle-tde -autostart-warp
dotest $EMU tde         0 255 $OPTS $DRIVEOFF -device8 1 $IECDEVOFF -drive8truedrive -virtualdev -autostartprgmode 0 -autostart-handle-tde +autostart-warp
# none
dotest $EMU none        1   0 $OPTS $DRIVEOFF -device8 1 $IECDEVOFF +drive8truedrive +virtualdev -autostartprgmode 0 -autostart-handle-tde -autostart-warp
dotest $EMU none        1   0 $OPTS $DRIVEOFF -device8 1 $IECDEVOFF +drive8truedrive +virtualdev -autostartprgmode 0 -autostart-handle-tde +autostart-warp
# vfs only
dotest $EMU vfs         1   0 $OPTS $DRIVEOFF -device8 1 $IECDEVOFF +drive8truedrive -virtualdev -autostartprgmode 0 -autostart-handle-tde -autostart-warp
dotest $EMU vfs         1   0 $OPTS $DRIVEOFF -device8 1 $IECDEVOFF +drive8truedrive -virtualdev -autostartprgmode 0 -autostart-handle-tde +autostart-warp
if [ "$IECDEVICE" = "yes" ]; then
dotest $EMU tde         0 255 $OPTS $DRIVEOFF -device8 1 $IECDEVON  -drive8truedrive +virtualdev -autostartprgmode 0 -autostart-handle-tde -autostart-warp
dotest $EMU tde         0 255 $OPTS $DRIVEOFF -device8 1 $IECDEVON  -drive8truedrive +virtualdev -autostartprgmode 0 -autostart-handle-tde +autostart-warp
dotest $EMU tde         0 255 $OPTS $DRIVEOFF -device8 1 $IECDEVON  -drive8truedrive -virtualdev -autostartprgmode 0 -autostart-handle-tde -autostart-warp
dotest $EMU tde         0 255 $OPTS $DRIVEOFF -device8 1 $IECDEVON  -drive8truedrive -virtualdev -autostartprgmode 0 -autostart-handle-tde +autostart-warp
# iecdev only
dotest $EMU vfs         1   0 $OPTS $DRIVEOFF -device8 1 $IECDEVON  +drive8truedrive +virtualdev -autostartprgmode 0 -autostart-handle-tde -autostart-warp
dotest $EMU vfs         1   0 $OPTS $DRIVEOFF -device8 1 $IECDEVON  +drive8truedrive +virtualdev -autostartprgmode 0 -autostart-handle-tde +autostart-warp
dotest $EMU vfs         0 255 $OPTS $DRIVEOFF -device8 1 $IECDEVON  +drive8truedrive -virtualdev -autostartprgmode 0 -autostart-handle-tde -autostart-warp
dotest $EMU vfs         0 255 $OPTS $DRIVEOFF -device8 1 $IECDEVON  +drive8truedrive -virtualdev -autostartprgmode 0 -autostart-handle-tde +autostart-warp
fi

echo "autostart mode 1 (inject to RAM) - handle TDE"
## fsdevice = none
# TDEonly
dotest $EMU none        1   0 $OPTS $DRIVEOFF -device8 0 $IECDEVOFF -drive8truedrive +virtualdev -autostartprgmode 1 -autostart-handle-tde -autostart-warp
dotest $EMU none        1   0 $OPTS $DRIVEOFF -device8 0 $IECDEVOFF -drive8truedrive +virtualdev -autostartprgmode 1 -autostart-handle-tde +autostart-warp
dotest $EMU tde         0 255 $OPTS $DRIVEOFF -device8 0 $IECDEVOFF -drive8truedrive -virtualdev -autostartprgmode 1 -autostart-handle-tde -autostart-warp
dotest $EMU tde         0 255 $OPTS $DRIVEOFF -device8 0 $IECDEVOFF -drive8truedrive -virtualdev -autostartprgmode 1 -autostart-handle-tde +autostart-warp
# none
dotest $EMU none        1   0 $OPTS $DRIVEOFF -device8 0 $IECDEVOFF +drive8truedrive +virtualdev -autostartprgmode 1 -autostart-handle-tde -autostart-warp
dotest $EMU none        1   0 $OPTS $DRIVEOFF -device8 0 $IECDEVOFF +drive8truedrive +virtualdev -autostartprgmode 1 -autostart-handle-tde +autostart-warp
# vfs only
dotest $EMU none        1   0 $OPTS $DRIVEOFF -device8 0 $IECDEVOFF +drive8truedrive -virtualdev -autostartprgmode 1 -autostart-handle-tde -autostart-warp
dotest $EMU none        1   0 $OPTS $DRIVEOFF -device8 0 $IECDEVOFF +drive8truedrive -virtualdev -autostartprgmode 1 -autostart-handle-tde +autostart-warp
if [ "$IECDEVICE" = "yes" ]; then
dotest $EMU tde         0 255 $OPTS $DRIVEOFF -device8 0 $IECDEVON  -drive8truedrive +virtualdev -autostartprgmode 1 -autostart-handle-tde -autostart-warp
dotest $EMU tde         0 255 $OPTS $DRIVEOFF -device8 0 $IECDEVON  -drive8truedrive +virtualdev -autostartprgmode 1 -autostart-handle-tde +autostart-warp
dotest $EMU tde         0 255 $OPTS $DRIVEOFF -device8 0 $IECDEVON  -drive8truedrive -virtualdev -autostartprgmode 1 -autostart-handle-tde -autostart-warp
dotest $EMU tde         0 255 $OPTS $DRIVEOFF -device8 0 $IECDEVON  -drive8truedrive -virtualdev -autostartprgmode 1 -autostart-handle-tde +autostart-warp
# iecdev only
dotest $EMU none        1   0 $OPTS $DRIVEOFF -device8 0 $IECDEVON  +drive8truedrive +virtualdev -autostartprgmode 1 -autostart-handle-tde -autostart-warp
dotest $EMU none        1   0 $OPTS $DRIVEOFF -device8 0 $IECDEVON  +drive8truedrive +virtualdev -autostartprgmode 1 -autostart-handle-tde +autostart-warp
dotest $EMU vfs         0 255 $OPTS $DRIVEOFF -device8 0 $IECDEVON  +drive8truedrive -virtualdev -autostartprgmode 1 -autostart-handle-tde -autostart-warp
dotest $EMU vfs         0 255 $OPTS $DRIVEOFF -device8 0 $IECDEVON  +drive8truedrive -virtualdev -autostartprgmode 1 -autostart-handle-tde +autostart-warp
fi

## fsdevice = filesystem
# TDEonly
dotest $EMU none        1   0 $OPTS $DRIVEOFF -device8 1 $IECDEVOFF -drive8truedrive +virtualdev -autostartprgmode 1 -autostart-handle-tde -autostart-warp
dotest $EMU none        1   0 $OPTS $DRIVEOFF -device8 1 $IECDEVOFF -drive8truedrive +virtualdev -autostartprgmode 1 -autostart-handle-tde +autostart-warp
dotest $EMU tde         0 255 $OPTS $DRIVEOFF -device8 1 $IECDEVOFF -drive8truedrive -virtualdev -autostartprgmode 1 -autostart-handle-tde -autostart-warp
dotest $EMU tde         0 255 $OPTS $DRIVEOFF -device8 1 $IECDEVOFF -drive8truedrive -virtualdev -autostartprgmode 1 -autostart-handle-tde +autostart-warp
# none
dotest $EMU none        1   0 $OPTS $DRIVEOFF -device8 1 $IECDEVOFF +drive8truedrive +virtualdev -autostartprgmode 1 -autostart-handle-tde -autostart-warp
dotest $EMU none        1   0 $OPTS $DRIVEOFF -device8 1 $IECDEVOFF +drive8truedrive +virtualdev -autostartprgmode 1 -autostart-handle-tde +autostart-warp
# vfs only
dotest $EMU vfs         1   0 $OPTS $DRIVEOFF -device8 1 $IECDEVOFF +drive8truedrive -virtualdev -autostartprgmode 1 -autostart-handle-tde -autostart-warp
dotest $EMU vfs         1   0 $OPTS $DRIVEOFF -device8 1 $IECDEVOFF +drive8truedrive -virtualdev -autostartprgmode 1 -autostart-handle-tde +autostart-warp
if [ "$IECDEVICE" = "yes" ]; then
dotest $EMU tde         0 255 $OPTS $DRIVEOFF -device8 1 $IECDEVON  -drive8truedrive +virtualdev -autostartprgmode 1 -autostart-handle-tde -autostart-warp
dotest $EMU tde         0 255 $OPTS $DRIVEOFF -device8 1 $IECDEVON  -drive8truedrive +virtualdev -autostartprgmode 1 -autostart-handle-tde +autostart-warp
dotest $EMU tde         0 255 $OPTS $DRIVEOFF -device8 1 $IECDEVON  -drive8truedrive -virtualdev -autostartprgmode 1 -autostart-handle-tde -autostart-warp
dotest $EMU tde         0 255 $OPTS $DRIVEOFF -device8 1 $IECDEVON  -drive8truedrive -virtualdev -autostartprgmode 1 -autostart-handle-tde +autostart-warp
# iecdev only
dotest $EMU vfs         1   0 $OPTS $DRIVEOFF -device8 1 $IECDEVON  +drive8truedrive +virtualdev -autostartprgmode 1 -autostart-handle-tde -autostart-warp
dotest $EMU vfs         1   0 $OPTS $DRIVEOFF -device8 1 $IECDEVON  +drive8truedrive +virtualdev -autostartprgmode 1 -autostart-handle-tde +autostart-warp
dotest $EMU vfs         0 255 $OPTS $DRIVEOFF -device8 1 $IECDEVON  +drive8truedrive -virtualdev -autostartprgmode 1 -autostart-handle-tde -autostart-warp
dotest $EMU vfs         0 255 $OPTS $DRIVEOFF -device8 1 $IECDEVON  +drive8truedrive -virtualdev -autostartprgmode 1 -autostart-handle-tde +autostart-warp
fi


echo "---"
}

function testc64_longnames
{
echo "long names with virtual fs:"
PROGEXT=prg
PROGPRE=./autostart-c64-567
dotest $EMU vfs         1   0 $OPTS -fslongnames -device8 1 $IECDEVOFF +drive8truedrive -virtualdev -autostartprgmode 0 +autostart-handle-tde -autostart-warp
PROGPRE=./autostart-c64-5678
dotest $EMU vfs         1   0 $OPTS -fslongnames -device8 1 $IECDEVOFF +drive8truedrive -virtualdev -autostartprgmode 0 +autostart-handle-tde -autostart-warp
PROGPRE=./autostart-c64-5678901
dotest $EMU vfs         1   0 $OPTS -fslongnames -device8 1 $IECDEVOFF +drive8truedrive -virtualdev -autostartprgmode 0 +autostart-handle-tde -autostart-warp
PROGPRE=./autostart-c64-56789012
dotest $EMU vfs         1   0 $OPTS -fslongnames -device8 1 $IECDEVOFF +drive8truedrive -virtualdev -autostartprgmode 0 +autostart-handle-tde -autostart-warp
PROGPRE=./autostart-c64-56789012345678901234567890123456789012345678901
dotest $EMU vfs         1   0 $OPTS -fslongnames -device8 1 $IECDEVOFF +drive8truedrive -virtualdev -autostartprgmode 0 +autostart-handle-tde -autostart-warp
echo "---"
}

# x64
function testx64
{
IECDEVICE=yes
IECDEVON=-iecdevice8
IECDEVOFF=+iecdevice8
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
IECDEVICE=yes
IECDEVON=-iecdevice8
IECDEVOFF=+iecdevice8
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
IECDEVICE=yes
IECDEVON=-iecdevice8
IECDEVOFF=+iecdevice8
LIMITCYCLES=40000000
EMU=x128
DRIVEON="-drive8type 1541"
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
IECDEVICE=no
IECDEVON=
IECDEVOFF=
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
IECDEVICE=yes
IECDEVON=-iecdevice8
IECDEVOFF=+iecdevice8
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
IECDEVICE=yes
IECDEVON=-iecdevice8
IECDEVOFF=+iecdevice8
LIMITCYCLES=30000000
EMU=xplus4
DRIVEON="-drive8type 1541"
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
IECDEVICE=no
IECDEVON=
IECDEVOFF=
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
IECDEVICE=yes
IECDEVON=-iecdevice8
IECDEVOFF=+iecdevice8
LIMITCYCLES=12000000
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
IECDEVICE=no
IECDEVON=
IECDEVOFF=
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
IECDEVICE=no
IECDEVON=
IECDEVOFF=
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
    echo "checkautostart.sh <options> <emulator(s)>"
    echo "options:"
    echo " -v --verbose     verbose mode"
    echo "emulators:"
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

if [ -z "${@:1:1}" ] ; then
    dohelp
    exit
else

if [ "$VICEDIR" == "" ] ; then
    VICEDIR="../../trunk/vice/src/"
fi
echo "using VICE dir:" $VICEDIR

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
                testx64
                testx64dtv
                testxscpu64
                testx128
                testxvic
                testxplus4
                testxpet
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
