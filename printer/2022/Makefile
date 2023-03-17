
VICEDIR=../../../trunk/vice/src/

FILES=\
	printerdemo.prg
	
all: $(FILES)

%.prg: %.bas
	petcat -w2 -o $*.prg < $*.bas
	
test-demo: printerdemo.prg
	$(VICEDIR)/x64sc -iecdevice4 -device4 1 -pr4drv mps803 -pr4output graphics printerdemo.prg
