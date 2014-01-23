
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