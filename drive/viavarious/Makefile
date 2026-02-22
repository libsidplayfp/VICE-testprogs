
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
	via13.prg \
	via14.prg \
	via20.prg \
	via21.prg \
	\
	via10-2.prg \
	via11-2.prg \
	via12-2.prg \
	via13-2.prg \
	via14-2.prg

all: $(PROGS) disk

%-2.prg:%.asm $(COMMON) %ref.bin
	acme -f cbm -DUSEVIA=2 -o $*-2.prg $*.asm

%.prg:%.asm $(COMMON) %ref.bin
	acme -f cbm -DUSEVIA=1 -o $*.prg $*.asm

test: all
	x64sc -drive8truedrive -autostartprgmode 2 via20.prg

disk: $(PROGS)
	c1541 -format "viavarious,00" d64 viavarious.d64 \
		-write via1.prg via1 \
		-write via2.prg via2 \
		-write via3.prg via3 \
		-write via3a.prg via3a \
		-write via4.prg via4 \
		-write via5.prg via5 \
		-write via9.prg via9 \
		-write via10.prg via10 \
		-write via11.prg via11 \
		-write via12.prg via12 \
		-write via13.prg via13 \
		-write via14.prg via14 \
		-write via20.prg via20 \
		-write via21.prg via21

	c1541 -format "viavarious2,00" d64 viavarious2.d64 \
		-write via10-2.prg via10-2 \
		-write via11-2.prg via11-2 \
		-write via12-2.prg via12-2 \
		-write via13-2.prg via13-2 \
		-write via14-2.prg via14-2

clean:
	rm -f *~
	rm -f $(PROGS)
	rm -f viavarious.d64
	rm -f viavarious2.d64
