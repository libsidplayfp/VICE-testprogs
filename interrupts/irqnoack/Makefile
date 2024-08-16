
all: ackcia.prg ackcia2.prg ackcia3.prg ackraster.prg

ackcia.prg: ackcia.s
	acme -f cbm -o ackcia.prg ackcia.s
ackcia2.prg: ackcia2.s
	acme -f cbm -o ackcia2.prg ackcia2.s
ackcia3.prg: ackcia3.s
	acme -f cbm -o ackcia3.prg ackcia3.s
ackraster.prg: ackraster.s
	acme -f cbm -o ackraster.prg ackraster.s

clean:
	$(RM) ackcia.prg
	$(RM) ackcia2.prg
	$(RM) ackcia3.prg
	$(RM) ackraster.prg
