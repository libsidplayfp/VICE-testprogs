
NEWRESET=1

all: wf12nsr.prg wf12nsr-8580.prg quicktest.prg

wf12nsr.prg: wf12nsr.asm data.bin
	acme -DNEWSID=0 -DNEWRESET=$(NEWRESET) -f cbm -o wf12nsr.prg wf12nsr.asm
wf12nsr-8580.prg: wf12nsr.asm data8580.bin
	acme -DNEWSID=1 -DNEWRESET=$(NEWRESET) -f cbm -o wf12nsr-8580.prg wf12nsr.asm

quicktest.prg: quicktest.bas
	petcat -w2 -o quicktest.prg -- quicktest.bas

clean:
	rm -f wf12nsr.prg
	rm -f wf12nsr-8580.prg
	rm -f quicktest.prg
