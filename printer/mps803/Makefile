VICEDIR=../../../trunk/vice/src/

all: mps-803-demo.prg

mps-803-demo.prg: mps-803-demo.bas
	petcat -w2 -o mps-803-demo.prg < mps-803-demo.bas

test:
#	$(VICEDIR)/x64sc -warp -virtualdev -basicload -iecdevice4 -device4 1 -pr4drv mps803 -pr4output graphics mps-803-demo.d64
	$(VICEDIR)/x64sc -warp +virtualdev -basicload -iecdevice4 -device4 1 -pr4drv mps803 -pr4output graphics mps-803-demo.prg
