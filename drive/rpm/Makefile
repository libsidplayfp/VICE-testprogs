all: rpm1.prg rpm.d64 rpm.g64 rpm.p64

rpm1.prg: rpm1.asm
	acme rpm1.asm

rpm.d64: rpm1.prg
	c1541 -format "rpm,00" d64 rpm.d64 -write "rpm1.prg" "rpm1"

rpm.g64: rpm.d64
	./../util/imggen d64tog64 rpm.d64 rpm.g64 35

rpm.p64: rpm.g64
	micro64disktool -g642p64 rpm.g64 rpm.p64

test: rpm1.prg rpm.d64
#	x64sc -truedrive -autostartprgmode 2 rpm1.prg
	x64sc -truedrive rpm.d64

clean:
	rm -f *~
	rm -f rpm1.prg
	rm -f rpm.d64
	rm -f rpm.g64
	rm -f rpm.p64
