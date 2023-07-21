

all: tap204060.prg tap204060inv.prg

tap204060.prg: tap204060.s
	acme -f cbm -DINVERT=0 -o tap204060.prg tap204060.s

tap204060inv.prg: tap204060.s
	acme -f cbm -DINVERT=1 -o tap204060inv.prg tap204060.s
