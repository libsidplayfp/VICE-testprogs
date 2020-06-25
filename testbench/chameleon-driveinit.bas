

10 poke 53502,42:rem enable config regs
11 poke 53498,2:rem enable mmu regs
48 poke 53500,64: rem pull IEC reset
49 rem poke 53500,0: rem release IEC reset
50 poke 53496,0: rem stop drive cpu drive 0
51 poke 53497,0: rem stop drive cpu drive 1
52 poke 53494,0: rem clean write bits
53 poke 53495,0: poke 53495,5: poke 53495,0: rem 1 image per drive, select first image
54 poke 53496,32+64: rem start drive cpu drive 0, keep door open
55 rem poke 53500,64: rem pull IEC reset
56 poke 53500,0: rem release IEC reset
59 for i=0to2000:next:rem wait a bit
60 rem open1,8,15:input#1,a,b$,c,d:close1:print a;b$;c;d:rem drive status
61 rem open1,8,15,"i":close1:rem init disk
62 rem open1,8,15:input#1,a,b$,c,d:close1:print a;b$;c;d:rem drive status
63 poke 53496,64: rem close drive 0 door
64 rem open1,8,15:input#1,a,b$,c,d:close1:print a;b$;c;d:rem drive status
65 open1,8,15,"i":close1:rem init disk
66 rem open1,8,15:input#1,a,b$,c,d:close1:print a;b$;c;d:rem drive status
