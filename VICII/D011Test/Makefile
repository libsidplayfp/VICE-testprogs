
TESTS=disable-bad.prg disable-bad_ntsc.prg disable-bad_ntscold.prg

all: $(TESTS)
	
disable-bad.prg: disable-bad.tas
	acme -f cbm -DCYCLES=63 -o $@ $<
disable-bad_ntsc.prg: disable-bad.tas
	acme -f cbm -DCYCLES=65 -o $@ $<
disable-bad_ntscold.prg: disable-bad.tas
	acme -f cbm -DCYCLES=64 -o $@ $<

clean:
	$(RM) $(TESTS)	
