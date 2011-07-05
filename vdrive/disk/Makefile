
all: disk

BASFILES=\
        dircheck.prg \
        vdrive-bug_demo.prg \
        displayts.prg \
        unscratch.prg \
        viewbam.prg

%.prg:%.bas
	petcat -w2 -o $*.prg -- $*.bas

disk: $(BASFILES)
	c1541 -format "vdrive tests,00" d64 test.d64 \
		-write dircheck.prg dircheck \
		-write vdrive-bug_demo.prg vdrive-bug_demo \
		-write displayts.prg displayts \
		-write unscratch.prg unscratch \
		-write viewbam.prg viewbam

clean:
	rm -f *~
zap: clean
	rm -f *.prg
	rm -f test.d64

testdisk:
	x64 +truedrive test.d64