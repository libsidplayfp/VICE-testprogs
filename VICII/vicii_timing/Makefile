 
all: vicii_reg_timing.prg

vicii_reg_timing.prg: vicii_reg_timing.asm
#	cl65 -v -vm -m vicii_reg_timing.map -l -t none -C vicii_reg_timing.link vicii_reg_timing.asm -o vicii_reg_timing.prg
	cl65 -t none -C vicii_reg_timing.link vicii_reg_timing.asm -o vicii_reg_timing.prg

clean:
	rm -f vicii_reg_timing.prg
	rm -f vicii_reg_timing.lst
	rm -f vicii_reg_timing.map
	rm -f *.o