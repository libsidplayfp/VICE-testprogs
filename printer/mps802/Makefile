
VICEDIR=../../../trunk/vice/src/

FILES=\
	customchar.prg
	
all: $(FILES)

%.prg: %.bas
	petcat -w2 -o $*.prg < $*.bas
	
test-char: customchar.prg
	$(VICEDIR)/x64sc -iecdevice4 -device4 1 -pr4drv mps803 -pr4output graphics customchar.prg
