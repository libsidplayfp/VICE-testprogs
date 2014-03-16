
COMMON=common.asm ../framework.asm ../framework-drive.asm

PROGS = \
	via1.prg \
	via2.prg \
	via3.prg \
	via3a.prg \
	via4.prg \
	via5.prg \
	via9.prg \
	via10.prg \
	via11.prg \
	via12.prg \
	via13.prg

all: $(PROGS)

%.prg:%.asm $(COMMON)
	acme $*.asm

test: all
	x64sc -truedrive -autostartprgmode 2 via3.prg
 
clean:
	rm -f *~
	rm -f $(PROGS)
