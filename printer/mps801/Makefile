
VICEDIR=../../../trunk/vice/src/

FILES=\
	bitmap.prg \
	sinus.prg \
	graphmode.prg \
	businessmode.prg \
	dotstart.prg \
	doublewidth.prg \
	linespacing.prg \
	localgraph.prg \
	localbusiness.prg \
	modemix.prg \
	printstart.prg \
	repeat.prg \
	reverse.prg
	
all: $(FILES)

%.prg: %.bas
	petcat -w2 -o $*.prg < $*.bas
	
test-bitmap:
	$(VICEDIR)/x64sc -iecdevice4 -device4 1 -pr4drv mps803 -pr4output graphics bitmap.prg
test-sinus:
	$(VICEDIR)/x64sc -iecdevice4 -device4 1 -pr4drv mps803 -pr4output graphics sinus.prg
test-dotstart:
	$(VICEDIR)/x64sc -iecdevice4 -device4 1 -pr4drv mps803 -pr4output graphics dotstart.prg
