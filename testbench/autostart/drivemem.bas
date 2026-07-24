
open 15,8,15

r=0

a = BUFFER1 * 256
#if (EXTRABUFFERS == 1)
print "{clear}{white}buffer 1 $400"
#else
print "{clear}{white}buffer 2 $500"
#endif

ad = a + 2
for l = 2 to 254
a1 = int(ad / 256):a2 = ad - (a1 * 256)

print#15, "m-r"chr$(a2)chr$(a1)
get#15, a$

g = asc(a$ + chr$(0))
if g = 42 then print "{green}";
if g <> 42 then print "{red}";:r=1
rem print g;chr$(20);
print ".";

ad = ad + 1:next

print
a = BUFFER2 * 256
#if (EXTRABUFFERS == 1)
print "{white}buffer 2 $500"
#else
print "{white}buffer 1 $400"
#endif

ad = a + 2
for l = 2 to 254
a1 = int(ad / 256):a2 = ad - (a1 * 256)

print#15, "m-r"chr$(a2)chr$(a1)
get#15, a$

g = asc(a$ + chr$(0))
if g = l then print "{green}";
if g <> l then print "{red}";:r=1
rem print g;chr$(20);
print ".";

ad = ad + 1:next


close 15

if r = 1 then 9999: rem error

poke 53280,5

print : print"{green}ok"
poke DEBUGREG, 0
end

9999 poke 53280, 2

print
print"{red}error"
poke DEBUGREG, 255
end
