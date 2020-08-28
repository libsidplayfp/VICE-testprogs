
all: disk

filelen.prg: filelen.s
	acme filelen.s

BASFILES=\
        drivemem.prg \
        checkdisk.prg \
        diskaddrchange.prg \
        headerchange.prg \
        performancetest.prg \
        relfiledemo.prg \
        seqfiledemo.prg \
        memread0.prg

%.prg:%.bas
	petcat -w2 -o $*.prg -- $*.bas

files:
	echo "test" > SOMEFILE

disk: $(BASFILES) filelen.prg files
	c1541 -format "vdrive tests,00" d64 test.d64 \
		-write drivemem.prg drivemem \
		-write seqfiledemo.prg seqfiledemo \
		-write relfiledemo.prg relfiledemo \
		-write filelen.prg filelen \
		-write performancetest.prg performancetest \
                -write checkdisk.prg checkdisk \
		-write diskaddrchange.prg diskaddrchange \
		-write headerchange.prg headerchange \
		-write memread0.prg memread0 \
		-write SOMEFILE somefile

clean:
	rm -f *~
zap: clean
	rm -f *.prg
	rm -f test.d64
	rm -f SOMEFILE
