VICEDIR=../../../trunk/vice/src/

all: printertest.prg

printertest.prg: printertest.bas
	petcat -w2 -o printertest.prg < printertest.bas

test:
#	$(VICEDIR)/x64sc -warp -virtualdev -basicload -iecdevice4 -device4 1 -pr4drv mps803 -pr4output graphics printertest.d64
	$(VICEDIR)/x64sc -warp +virtualdev -basicload -iecdevice4 -device4 1 -pr4drv mps803 -pr4output graphics printertest.prg
