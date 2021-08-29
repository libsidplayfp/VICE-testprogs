
0 rem * main

#if 0

print "{clr}"
poke 646,peek(BGCOLOR)
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


print "{clr}vice autostart test":print

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

if f = 0 then poke DEBUGREG , 0: poke BORDERCOLOR, 5: print "all ok"
if f <> 0 then poke DEBUGREG , 255: poke BORDERCOLOR, 2: print "failed"

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


rem $90/144:   kernal i/o status word st
rem
rem   +-------+---------------------------------+
rem   | bit 7 |   1 = device not present (s)    |
rem   |       |   1 = end of tape (t)           |
rem   | bit 6 |   1 = end of file (s+t)         |
rem   | bit 5 |   1 = checksum error (t)        |
rem   | bit 4 |   1 = different error (t)       |
rem   | bit 3 |   1 = too many bytes (t)        |
rem   | bit 2 |   1 = too few bytes (t)         |
rem   | bit 1 |   1 = timeout read (s)          |
rem   | bit 0 |   1 = timeout write (s)         |
rem   +-------+---------------------------------+
rem
rem   (s) = serial bus, (t) = tape
