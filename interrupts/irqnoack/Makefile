
all: ackcia.prg ackraster.prg

ackcia.prg: ackcia.s
	acme -f cbm -o ackcia.prg ackcia.s
ackraster.prg: ackraster.s
	acme -f cbm -o ackraster.prg ackraster.s

clean:
	$(RM) ackcia.prg
	$(RM) ackraster.prg
