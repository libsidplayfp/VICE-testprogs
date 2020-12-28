
COMMON=\
	common.inc \
	io.inc \
	reu.inc

all: spritetiming.prg reudetect.prg checkchar.prg

spritetiming.prg: spritetiming.asm $(COMMON)
	acme -f cbm -o spritetiming.prg spritetiming.asm
reudetect.prg: reudetect.asm $(COMMON)
	acme -f cbm -o reudetect.prg reudetect.asm
checkchar.prg: checkchar.asm $(COMMON)
	acme -f cbm -o checkchar.prg checkchar.asm
	
clean:
	$(RM) spritetiming.prg
	$(RM) reudetect.prg
	$(RM) checkchar.prg
