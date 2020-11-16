

the old port of the testsuite (by 1570 ?) is at testprogs/DTV/tsuitDTV/ - some
programs do not work correctly in x64dtv right now. we should confirm they
actually behave the same on a real DTV:

Disk1:

txsn    - crash
phan    - crash
plan    - crash
phpn    - crash
plpn    - crash
rtin    - crash

Disk2:

shsay   - fails
trap1   - fails (ane 8b, shs 9b)
trap2   - fails (ane 8b, shs 9b)
trap3   - fails (ane 8b, shs 9b)
trap4   - fails (ane 8b, shs 9b)
trap5   - fails (ane 8b, shs 9b)
trap6   - fails (ane 8b, shs 9b)
trap7   - fails (ane 8b, shs 9b)
trap8   - fails (ane 8b)
trap9   - fails (ane 8b, shs 9b)
trap10  - fails (sty 84, sta 85, stx 86, axs 87, ane 8b, sty 94, sta 95, stx 96, axs 97, shs 9b)
trap11  - fails (ane 8b, shs 9b)
trap12  - fails (ane 8b, shs 9b)
trap13  - fails (ane 8b)
trap14  - fails (too much to list)
trap15  - fails (too much to list)
trap16  - fails (too much to list)
trap17  - fails (ora 01, aso 03, ora 05, asl 06, aso 07, hangs after that)
cpuport - fails
cputiming - fails
irq - fails
nmi - fails
cia2pb6 - fails
cia2pb7 - fails

--------------------------------------------------------------------------------

in the refactored version the following tests fail on x64dtv, we should also
confirm whether this is the case on a real DTV:

Disk1:

none

Disk2:

shsay   - fails
trap1   - fails (shs 9b)
trap2   - fails (shs 9b)
trap3   - fails (shs 9b)
trap4   - fails (shs 9b)
trap5   - fails (shs 9b)
trap6   - fails (shs 9b)
trap7   - fails (shs 9b)
trap9   - fails (shs 9b)
trap10  - fails (sty 84, sta 85, stx 86, axs 87, sty 94, sta 95, stx 96, axs 97, shs 9b)
trap11  - fails (shs 9b)
trap12  - fails (shs 9b)
trap14  - fails (too much to list)
trap15  - fails (too much to list)
trap16  - fails (too much to list)
trap17  - fails (ora 01, aso 03, ora 05, asl 06, aso 07, hangs after that)
cpuport - fails
cputiming - fails

Disk3:

irq - fails
nmi - fails
cia2pb6 - fails
cia2pb7 - fails

