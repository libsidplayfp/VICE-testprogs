
all: dmatest.prg reu-check.prg dmastart.prg

dmatest.prg: dmatest.s
	cl65 -t none --start-addr 2047 $^ -o $@

reu-check.prg: reu-check.s
	acme -f cbm -o reu-check.prg reu-check.s

dmastart.prg: dmastart.s
	acme -f cbm -o dmastart.prg dmastart.s

clean:
	$(RM) dmatest.prg
	$(RM) reu-check.prg
	$(RM) dmastart.prg
