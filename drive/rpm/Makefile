all: rpm1.prg rpm2.prg rpm3.prg rpm.d64 rpm.g64 rpm.p64 \
	rpm1plot.prg rpm2plot.prg rpm3plot.prg

imggen:
	make -C ./../util/ imggen

rpm1.prg: rpm1.asm mflpt.inc
	acme -f cbm -DDOPLOT=0 -o rpm1.prg rpm1.asm

rpm1plot.prg: rpm1.asm mflpt.inc plotter.asm
	acme -f cbm -DDOPLOT=1 -o rpm1plot.prg rpm1.asm

rpm2.prg: rpm2.asm mflpt.inc
	acme -f cbm -DDOPLOT=0 -o rpm2.prg rpm2.asm

rpm2plot.prg: rpm2.asm mflpt.inc plotter.asm
	acme -f cbm -DDOPLOT=1 -o rpm2plot.prg rpm2.asm

rpm3.prg: rpm3.asm mflpt.inc
	acme -f cbm -DDOPLOT=0 -o rpm3.prg rpm3.asm

rpm3plot.prg: rpm3.asm mflpt.inc plotter.asm
	acme -f cbm -DDOPLOT=1 -o rpm3plot.prg rpm3.asm

rpm.d64: rpm1.prg rpm2.prg rpm3.prg rpm1plot.prg rpm2plot.prg rpm3plot.prg
	c1541 -format "rpm,00" d64 rpm.d64 \
		-write "rpm1.prg" "rpm1" \
		-write "rpm2.prg" "rpm2" \
		-write "rpm3.prg" "rpm3" \
		-write "rpm1plot.prg" "rpm1plot" \
		-write "rpm2plot.prg" "rpm2plot" \
		-write "rpm3plot.prg" "rpm3plot"

rpm.g64: rpm.d64 imggen
	./../util/imggen d64tog64 rpm.d64 rpm.g64 35

rpm.p64: rpm.g64
	micro64disktool -g642p64 rpm.g64 rpm.p64

test: rpm1.prg rpm.d64
#	x64sc -truedrive -autostartprgmode 2 rpm1.prg
	x64sc -truedrive rpm.d64
	
clean:
	rm -f *~
	rm -f rpm1.prg
	rm -f rpm2.prg
	rm -f rpm3.prg
	rm -f rpm1plot.prg
	rm -f rpm2plot.prg
	rm -f rpm3plot.prg
	rm -f rpm.d64
	rm -f rpm.g64
	rm -f rpm.p64
