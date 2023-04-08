
all: \
	testjoy_c64.prg \
	testjoy_c128.prg \
	testjoy_cbm510.prg \
	testjoy_cbm610.prg \
	testjoy_pet.prg \
	testjoy_plus4.prg \
	testjoy_vic20.prg

testjoy_c64.prg: testjoy.c
	cl65 -t c64 -o testjoy_c64.prg testjoy.c

testjoy_c128.prg: testjoy.c
	cl65 -t c128 -o testjoy_c128.prg testjoy.c

testjoy_cbm510.prg: testjoy.c
	cl65 -t cbm510 -o testjoy_cbm510.prg testjoy.c

testjoy_cbm610.prg: testjoy.c
	cl65 -t cbm610 -o testjoy_cbm610.prg testjoy.c

testjoy_pet.prg: testjoy.c
	cl65 -t pet -o testjoy_pet.prg testjoy.c

testjoy_plus4.prg: testjoy.c
	cl65 -t c16 -o testjoy_plus4.prg testjoy.c

testjoy_vic20.prg: testjoy.c
	cl65 -t vic20 -C vic20-32k.cfg -o testjoy_vic20.prg testjoy.c
