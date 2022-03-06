
all: burstcheck.d64 burstcheck.d71

burstcheck0.prg: burstcheck.asm
	acme -DBURST=0 -f cbm -o burstcheck0.prg burstcheck.asm
burstcheck1.prg: burstcheck.asm
	acme -DBURST=1 -f cbm -o burstcheck1.prg burstcheck.asm

burstcheck.d64: burstcheck0.prg
	c1541 -format "burstcheck,00" d64 burstcheck.d64 -write "burstcheck0.prg" burstcheck0
burstcheck.d71: burstcheck1.prg
	c1541 -format "burstcheck,00" d71 burstcheck.d71 -write "burstcheck1.prg" burstcheck1
	
clean:
	$(RM) burstcheck0.prg
	$(RM) burstcheck1.prg
	$(RM) burstcheck.d64
	$(RM) burstcheck.d71
