.PHONY: all clean

.SUFFIXES: .prg .asm .tas
%.prg: %.tas
	acme -v1 --cpu 6502 -f cbm -o $@ $<

%.prg: %.asm
	dasm $< -o$@

all: border-250.prg border-251.prg border-252.prg \
     border-bm-idle.prg border-bm-ysh.prg border-bm-ysh2.prg \
     border-mcbm.prg vborder.prg

border-250.prg: border-250.tas
border-251.prg: border-251.tas
border-252.prg: border-252.tas
border-bm-idle.prg: border-bm-idle.tas
border-bm-ysh.prg: border-bm-ysh.tas
border-bm-ysh2.prg: border-bm-ysh2.tas
border-mcbm.prg: border-mcbm.tas
vborder.prg: vborder.asm

clean:
	rm *.prg
