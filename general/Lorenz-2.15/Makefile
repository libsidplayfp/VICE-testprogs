# this file is part of the C64 Emulator Test Suite. public domain, no copyright

#.SILENT:

all: c64 dtv plus4

c64:
	make -C src
	cp src/Disk1.d64 .
	cp src/Disk2.d64 .
	cp src/Disk2c128.d64 .
	cp src/Disk3.d64 .
	cp src/Disk3new.d64 .
	cp src/Disk4.d64 .
	cp src/Lorenz.d81 .
	cp src/Lorenznew.d81 .
	
dtv:
	make -C src -f Makefile.dtv
	cp src/Disk1DTV.d64 .
	cp src/Disk2DTV.d64 .
	cp src/Disk3DTV.d64 .
	cp src/Disk4DTV.d64 .
	cp src/LorenzDTV.d81 .
	
plus4:
	make -C src -f Makefile.plus4
	cp src/Disk1plus4.d64 .
	cp src/Disk2plus4.d64 .
	cp src/Disk3plus4.d64 .
	cp src/Disk4plus4.d64 .
	cp src/LorenzPlus4.d81 .
	
disk3:	
	make -C src Disk3.d64
	make -C src Disk3new.d64
	cp src/Disk3.d64 .
	cp src/Disk3new.d64 .
	
clean:
	make -C src clean
	make -C src -f Makefile.dtv clean
	make -C src -f Makefile.plus4 clean
	$(RM) *~

zap:
	make -C src zap
	make -C src -f Makefile.dtv zap
	make -C src -f Makefile.plus4 zap
	$(RM) Disk1.d64
	$(RM) Disk2.d64
	$(RM) Disk2c128.d64
	$(RM) Disk3.d64
	$(RM) Disk3new.d64
	$(RM) Disk4.d64
	$(RM) Lorenz.d81
	$(RM) Lorenznew.d81
	$(RM) Disk1DTV.d64
	$(RM) Disk2DTV.d64
	$(RM) Disk3DTV.d64
	$(RM) Disk4DTV.d64
	$(RM) LorenzDTV.d81
	$(RM) Disk1plus4.d64
	$(RM) Disk2plus4.d64
	$(RM) Disk3plus4.d64
	$(RM) Disk4plus4.d64
	$(RM) LorenzPlus4.d81
	$(RM) *~

