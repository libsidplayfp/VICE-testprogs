TESTS=\
	scan35.d64 scan40.d64 scan42.d64 \
	scan35.g64 scan40.g64 scan42.g64 \
	scan35err.d64 scan40err.d64 scan42err.d64 

all: $(TESTS)

scanner35.prg: main.asm
	acme -f cbm -o scanner35.prg -DTRACKS=35 -DERRORS=0 main.asm
scanner40.prg: main.asm
	acme -f cbm -o scanner40.prg -DTRACKS=40 -DERRORS=0 main.asm
scanner42.prg: main.asm
	acme -f cbm -o scanner42.prg -DTRACKS=42 -DERRORS=0 main.asm

scanner35e.prg: main.asm
	acme -f cbm -o scanner35e.prg -DTRACKS=35 -DERRORS=1 main.asm
scanner40e.prg: main.asm
	acme -f cbm -o scanner40e.prg -DTRACKS=40 -DERRORS=1 main.asm
scanner42e.prg: main.asm
	acme -f cbm -o scanner42e.prg -DTRACKS=42 -DERRORS=1 main.asm

scan35.d64: scanner35.prg
	./../util/imggen tagd64 scan35.d64 35
	c1541 -attach scan35.d64 -@ n:scanner -write "scanner35.prg" "scanner35"
scan40.d64: scanner40.prg
	./../util/imggen tagd64 scan40.d64 40
	c1541 -attach scan40.d64 -@ n:scanner -write "scanner40.prg" "scanner40"
scan42.d64: scanner42.prg
	./../util/imggen tagd64 scan42.d64 42
	c1541 -attach scan42.d64 -@ n:scanner -write "scanner42.prg" "scanner42"

scan35err.d64: scanner35e.prg
	./../util/imggen tagd64err scan35err.d64 35
	c1541 -attach scan35err.d64 -@ n:scanner -write "scanner35e.prg" "scanner35e"
scan40err.d64: scanner40e.prg
	./../util/imggen tagd64err scan40err.d64 40
	c1541 -attach scan40err.d64 -@ n:scanner -write "scanner40e.prg" "scanner40e"
scan42err.d64: scanner42e.prg
	./../util/imggen tagd64err scan42err.d64 42
	c1541 -attach scan42err.d64 -@ n:scanner -write "scanner42e.prg" "scanner42e"
	
scan35.g64: scan35.d64
	./../util/imggen d64tog64 scan35.d64 scan35.g64 35
scan40.g64: scan40.d64
	./../util/imggen d64tog64 scan40.d64 scan40.g64 40
scan42.g64: scan42.d64
	./../util/imggen d64tog64 scan42.d64 scan42.g64 42
	
test:
	x64sc -truedrive scan42.d64
 
clean:
	rm -f *~
	rm -f $(TESTS)
	rm -f *.prg
