

all: tap204060.prg tap204060inv.prg tap204060once.prg tap204060invonce.prg

tap204060.prg: tap204060.s
	acme -f cbm -DLOOP=1 -DINVERT=0 -o tap204060.prg tap204060.s

tap204060inv.prg: tap204060.s
	acme -f cbm -DLOOP=1 -DINVERT=1 -o tap204060inv.prg tap204060.s

tap204060once.prg: tap204060.s
	acme -f cbm -DLOOP=0 -DINVERT=0 -o tap204060once.prg tap204060.s

tap204060invonce.prg: tap204060.s
	acme -f cbm -DLOOP=0 -DINVERT=1 -o tap204060invonce.prg tap204060.s

clean:
	$(RM) tap204060.prg tap204060inv.prg tap204060once.prg tap204060invonce.prg
