
#.SILENT:

all:
	make -C src
	cp src/Disk1.d64 .
	cp src/Disk2.d64 .
	cp src/Disk2c128.d64 .
	cp src/Disk3.d64 .
	cp src/Disk3new.d64 .
	cp src/Lorenz.d81 .
	cp src/Lorenznew.d81 .
	
disk3:	
	make -C src Disk3.d64
	make -C src Disk3new.d64
	cp src/Disk3.d64 .
	cp src/Disk3new.d64 .
	
clean:
	make -C src clean
	rm -f *~

zap:
	make -C src zap
	rm -f Disk1.d64
	rm -f Disk2.d64
	rm -f Disk2c128.d64
	rm -f Disk3.d64
	rm -f Disk3new.d64
	rm -f Lorenz.d81
	rm -f Lorenznew.d81
	rm -f *~

