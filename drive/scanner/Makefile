all: scanner.prg scan35.d64 scan40.d64 scan42.d64

scanner.prg: main.asm
	acme main.asm

scan35.d64: scanner.prg
	./../util/imggen scan35.d64 35
	c1541 -attach scan35.d64 -@ n:scanner -write "scanner.prg" "scanner"
scan40.d64: scanner.prg
	./../util/imggen scan40.d64 40
	c1541 -attach scan40.d64 -@ n:scanner -write "scanner.prg" "scanner"
scan42.d64: scanner.prg
	./../util/imggen scan42.d64 42
	c1541 -attach scan42.d64 -@ n:scanner -write "scanner.prg" "scanner"
	
test: scanner.prg
#	x64sc -truedrive -autostartprgmode 2 scanner.prg
	x64sc -truedrive scan42.d64
 
clean:
	rm -f *~
	rm -f scanner.prg
	rm -f scan35.d64
	rm -f scan40.d64
	rm -f scan42.d64
	