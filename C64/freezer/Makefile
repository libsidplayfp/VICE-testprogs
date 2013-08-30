

INCLUDE=-I ../include

all: freeze-test.prg freeze-raster.prg freeze-cia1.prg freeze-cia2.prg freeze-combined.prg
	rm -f *.o

freeze-test.prg: freeze-test.s
	cl65 $(INCLUDE) -t c64 -o freeze-test.prg freeze-test.s

freeze-raster.prg: freeze-test-raster.s
	cl65 $(INCLUDE) -t c64 -o freeze-raster.prg freeze-test-raster.s

freeze-cia1.prg: freeze-test-cia1.s
	cl65 $(INCLUDE) -t c64 -o freeze-cia1.prg freeze-test-cia1.s

freeze-cia2.prg: freeze-test-cia2.s
	cl65 $(INCLUDE) -t c64 -o freeze-cia2.prg freeze-test-cia2.s

freeze-combined.prg: freeze-test-combined.s
	cl65 $(INCLUDE) -t c64 -o freeze-combined.prg freeze-test-combined.s

clean:
	rm -f *~
	rm -f *.o
	rm -f *.prg
