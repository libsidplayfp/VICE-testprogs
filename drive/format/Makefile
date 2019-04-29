
all: format.d64

format.prg: format.bas
	petcat -w2 -o format.prg -- format.bas
	
format.d64: format.prg
	c1541 -format "format this,00" d64 format.d64 -write format.prg format
	
clean:
	rm -f format.prg
	rm -f format.d64

