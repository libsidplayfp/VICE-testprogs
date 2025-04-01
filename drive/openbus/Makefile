all: openbus.prg openbus2.prg

openbus.prg: main.asm
	acme -f cbm -DTEST=1 -o openbus.prg main.asm

openbus2.prg: main.asm
	acme -f cbm -DTEST=2 -o openbus2.prg main.asm

test: openbus.prg
	x64sc -default -drive8truedrive -autostartprgmode 2 openbus.prg
test2: openbus2.prg
	x64sc -default -drive8truedrive -autostartprgmode 2 openbus2.prg

clean:
	$(RM) *~
	$(RM) openbus.prg
	$(RM) openbus2.prg
