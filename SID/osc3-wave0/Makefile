
all: osc3-wave0.prg osc3-wave0-new.prg

osc3-wave0.prg: osc3-wave0.asm
	acme -f cbm -DNEWSID=0 -o osc3-wave0.prg osc3-wave0.asm
osc3-wave0-new.prg: osc3-wave0.asm
	acme -f cbm -DNEWSID=1 -o osc3-wave0-new.prg osc3-wave0.asm
	
clean:
	$(RM) osc3-wave0.prg
	$(RM) osc3-wave0-new.prg

