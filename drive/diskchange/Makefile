all: pollwp.prg disk1.d64 disk2.d64

pollwp.prg: pollwp.asm
	acme pollwp.asm

test: pollwp.prg
	x64sc -truedrive -autostartprgmode 2 pollwp.prg

disk1.d64: pollwp.prg
	c1541 -format "diskchange,00" d64 disk1.d64 -write "pollwp.prg" "pollwp"

disk2.d64: pollwp.prg
	c1541 -format "diskchange,00" d64 disk2.d64 -write "pollwp.prg" "pollwp"

clean:
	rm -f *~
	rm -f pollwp.prg
	rm -f disk1.d64 disk2.d64