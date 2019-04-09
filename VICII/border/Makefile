.PHONY: all clean

.SUFFIXES: .prg .asm .tas
%.prg: %.tas
	acme -v1 --cpu 6502 -f cbm -o $@ $<

%.prg: %.asm
	dasm $< -o$@ -DCYCLES=63
%_ntsc.prg:%.asm
	dasm $*.asm -o$*_ntsc.prg -DCYCLES=65
%_ntscold.prg:%.asm
	dasm $*.asm -o$*_ntscold.prg -DCYCLES=64

all: border-250.prg border-251.prg border-252.prg \
     border-bm-idle.prg border-bm-ysh.prg border-bm-ysh2.prg \
     border-mcbm.prg vborder.prg vborder_ntsc.prg vborder_ntscold.prg \
     vborder2.prg vborder2_ntsc.prg vborder2_ntscold.prg \
     hvborder1.prg hvborder2.prg

border-250.prg: border-250.tas
border-251.prg: border-251.tas
border-252.prg: border-252.tas
border-bm-idle.prg: border-bm-idle.tas
border-bm-ysh.prg: border-bm-ysh.tas
border-bm-ysh2.prg: border-bm-ysh2.tas
border-mcbm.prg: border-mcbm.tas
vborder.prg: vborder.asm
vborder2.prg: vborder2.asm

hvborder1.prg: hvborder.asm
	acme -f cbm -DMODE=0 -o hvborder1.prg hvborder.asm
hvborder2.prg: hvborder.asm
	acme -f cbm -DMODE=1 -o hvborder2.prg hvborder.asm

clean:
	rm *.prg
