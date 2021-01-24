
0 rem * main

#if 0

print "{clr}"
poke 646,peek(53281)
rem * goto50 into keyboard buffer, so we start from 50 on error
poke 631,64+7
poke 632,64+15
poke 633,64+20
poke 634,64+15
poke 635,48+3
poke 636,48
poke 637,13
poke 198,7

open15,8,15,"ui":close15:poke198,0:goto31
30 e = 1
31 rem drive was there, no error

#else

rem check if drive is present
open 1,8,0:close 1: if (st and 128) = 128 then e = 1

#endif


print "{white}{clr}vice autostart test":print

print "expecting:"
print "tde:"; EXPECT_TDE ;
print "vdrive:"; EXPECT_VDRIVE ;
print "vfs:"; EXPECT_VFS
print "autostart disk:"; EXPECT_AUTOSTART_DISK
print "disk image:"; EXPECT_DISKIMAGE

print

if e = 1 then goto 90
gosub 1000
print "msg:";pu$
gosub 2000
print "dir:";di$
print "diskid:";id$

90 print "no drive:";e
gosub 3000

print
gosub 4000

if f = 0 then poke DEBUGREG , 0: poke 53280, 5: print "all ok"
if f <> 0 then poke DEBUGREG , 255: poke 53280, 2: print "failed"

end

1000 rem * get powerup message from drive
open 15,8,15,"ui"
input#15,a,pu$,c,d
close 15
return

2000 rem * get header from directory
open 1,8,0,"$":di$="": id$="": if st <> 0 then return
for i = 0 to 7: get#1, a$:
if st <> 0 then return
next
for i = 0 to 15: get#1, a$: di$=di$+a$: next
get #1,a$:get #1,a$
for i = 0 to 5: get#1, a$: id$=id$+a$: next
close 1
return

3000 rem * check what is what
if left$(pu$, 7)  = "cbm dos" then td = 1 : rem tde enabled
if left$(pu$, 13) = "virtual drive" then vd = 1 : rem virtual drive
if left$(pu$, 7)  = "vice fs" then fs = 1 : rem filesystem

if left$(di$, 9)  = "autostart" and id$ <> " #8:0" then ad = 1 : rem using autostart disk image
if left$(di$, 8)  = "testdisk" then d = 1 : rem using regular disk image

print
print "tde:"; td ;
print "vdrive:"; vd ;
print "vfs:"; fs
print "autostart disk:"; ad
print "disk image:"; d

return

4000 rem * check for errors
f = 0
if td <> EXPECT_TDE then f = f + 1
if vd <> EXPECT_VDRIVE then f = f + 1
if fs <> EXPECT_VFS then f = f + 1
if ad <> EXPECT_AUTOSTART_DISK then f = f + 1
if d <> EXPECT_DISKIMAGE then f = f + 1
print "errors: "; f

return

rem prg autostart modes are:
rem 0 : virtual filesystem
rem 1 : inject to ram (there might be no drive)
rem 2 : copy to d64


rem $90/144:   Kernal I/O Status Word ST
rem
rem   +-------+---------------------------------+
rem   | Bit 7 |   1 = Device not present (S)    |
rem   |       |   1 = End of Tape (T)           |
rem   | Bit 6 |   1 = End of File (S+T)         |
rem   | Bit 5 |   1 = Checksum error (T)        |
rem   | Bit 4 |   1 = Different error (T)       |
rem   | Bit 3 |   1 = Too many bytes (T)        |
rem   | Bit 2 |   1 = Too few bytes (T)         |
rem   | Bit 1 |   1 = Timeout Read (S)          |
rem   | Bit 0 |   1 = Timeout Write (S)         |
rem   +-------+---------------------------------+
rem
rem   (S) = Serial bus, (T) = Tape
