TESTS=\
	scan35.d64 scan40.d64 scan42.d64 \
	scan35.g64 scan40.g64 scan42.g64 \
	scan35err.d64 scan40err.d64 scan42err.d64 \
	scan35.d71 \
	scan35.g71 \
	scan35err.d71
	
#	scan40.d71 scan42.d71 
#	scan40.g71 scan42.g71 
#	scan40err.d71 scan42err.d71 

all: $(TESTS)

scanner35.prg: main.asm
	acme -f cbm -o scanner35.prg -DC64=1 -DVC1541=1 -DTRACKS=35 -DERRORS=0 -DHEADS=1 main.asm
scanner40.prg: main.asm
	acme -f cbm -o scanner40.prg -DC64=1 -DVC1541=1 -DTRACKS=40 -DERRORS=0 -DHEADS=1 main.asm
scanner42.prg: main.asm
	acme -f cbm -o scanner42.prg -DC64=1 -DVC1541=1 -DTRACKS=42 -DERRORS=0 -DHEADS=1 main.asm

scanner35e.prg: main.asm
	acme -f cbm -o scanner35e.prg -DC64=1 -DVC1541=1 -DTRACKS=35 -DERRORS=1 -DHEADS=1 main.asm
scanner40e.prg: main.asm
	acme -f cbm -o scanner40e.prg -DC64=1 -DVC1541=1 -DTRACKS=40 -DERRORS=1 -DHEADS=1 main.asm
scanner42e.prg: main.asm
	acme -f cbm -o scanner42e.prg -DC64=1 -DVC1541=1 -DTRACKS=42 -DERRORS=1 -DHEADS=1 main.asm

scanner1571-35.prg: main.asm
	acme -f cbm -o scanner1571-35.prg -DC128=1 -DVC1571=1 -DTRACKS=35 -DERRORS=0 -DHEADS=1 main.asm
scanner1571-40.prg: main.asm
	acme -f cbm -o scanner1571-40.prg -DC128=1 -DVC1571=1 -DTRACKS=40 -DERRORS=0 -DHEADS=1 main.asm
scanner1571-42.prg: main.asm
	acme -f cbm -o scanner1571-42.prg -DC128=1 -DVC1571=1 -DTRACKS=42 -DERRORS=0 -DHEADS=1 main.asm

scanner1571-35e.prg: main.asm
	acme -f cbm -o scanner1571-35e.prg -DC128=1 -DVC1571=1 -DTRACKS=35 -DERRORS=1 -DHEADS=1 main.asm
scanner1571-40e.prg: main.asm
	acme -f cbm -o scanner1571-40e.prg -DC128=1 -DVC1571=1 -DTRACKS=40 -DERRORS=1 -DHEADS=1 main.asm
scanner1571-42e.prg: main.asm
	acme -f cbm -o scanner1571-42e.prg -DC128=1 -DVC1571=1 -DTRACKS=42 -DERRORS=1 -DHEADS=1 main.asm

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
	
scan35.d71: scanner1571-35.prg
	./../util/imggen tagd71 scan35.d71 35
	c1541 -attach scan35.d71 -@ n:scanner -write "scanner1571-35.prg" "scanner1571-35"
#scan40.d71: scanner1571-40.prg
#	./../util/imggen tagd71 scan40.d71 40
#	c1541 -attach scan40.d71 -@ n:scanner -write "scanner1571-40.prg" "scanner1571-40"
#scan42.d71: scanner1571-42.prg
#	./../util/imggen tagd71 scan42.d71 42
#	c1541 -attach scan42.d71 -@ n:scanner -write "scanner1571-42.prg" "scanner1571-42"

scan35err.d71: scanner1571-35e.prg
	./../util/imggen tagd71err scan35err.d71 35
	c1541 -attach scan35err.d71 -@ n:scanner -write "scanner1571-35e.prg" "scanner1571-35e"
#scan40err.d71: scanner1571-40e.prg
#	./../util/imggen tagd71err scan40err.d71 40
#	c1541 -attach scan40err.d71 -@ n:scanner -write "scanner1571-40e.prg" "scanner1571-40e"
#scan42err.d71: scanner1571-42e.prg
#	./../util/imggen tagd71err scan42err.d71 42
#	c1541 -attach scan42err.d71 -@ n:scanner -write "scanner1571-42e.prg" "scanner1571-42e"
	
scan35.g64: scan35.d64
	./../util/imggen d64tog64 scan35.d64 scan35.g64 35
scan40.g64: scan40.d64
	./../util/imggen d64tog64 scan40.d64 scan40.g64 40
scan42.g64: scan42.d64
	./../util/imggen d64tog64 scan42.d64 scan42.g64 42
	
scan35.g71: scan35.d71
	./../util/imggen d71tog71 scan35.d71 scan35.g71 35
#scan40.g71: scan40.d71
#	./../util/imggen d71tog71 scan40.d71 scan40.g71 40
#scan42.g71: scan42.d71
#	./../util/imggen d71tog71 scan42.d71 scan42.g71 42
	
test: scan42.d64 scanner42.prg
	x64sc -default -drive8truedrive -8 scan42.d64 scanner42.prg
test128: scan35.d71 scanner1571-35.prg
	x128 -default -drive8truedrive -8 scan35.d71 scanner1571-35.prg
 
clean:
	rm -f *~
	rm -f $(TESTS)
	rm -f *.prg
