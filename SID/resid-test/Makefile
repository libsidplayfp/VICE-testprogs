
TESTS=\
	boundary.prg \
	boundary-dump.prg \
	chipmodel.prg \
	envdelay.prg \
	envrate.prg \
	envsample.prg \
	envsample-dump.prg \
	envsustain.prg \
	envtime.prg \
	extfilt.prg \
	noisetest.prg \
	oscsample0-6581.prg \
	oscsample0-8580.prg \
	oscsample1-6581.prg \
	oscsample1-8580.prg \
	oscsample0-dump.prg \
	oscsample1-dump.prg \
	sweep.prg \
	sweep-kern.prg \
	sweep-orig.prg \
	voice.prg
	
all: $(TESTS)	
	
%.prg: %.a65
	xa -M -o $@ $<

boundary.prg: boundary.a65	
	xa -M -DDUMP=0 -o $@ $<
	c1541 -format "boundary,00" d64 boundary.d64 \
	-write boundary.prg "boundary" \
	-write boundary-dec0.dat "dec0.dat"

boundary-dump.prg: boundary.a65	
	xa -M -DDUMP=1 -o $@ $<
	c1541 -format "boundary dump,00" d64 boundary-dump.d64 \
	-write boundary-dump.prg "boundary dump"
	
envsample.prg: envsample.a65	
	xa -M -DDUMP=0 -o $@ $<
	c1541 -format "envsample,00" d64 envsample.d64 \
	-write envsample.prg "envsample" \
	-write envsample-dec0.dat "dec0.dat" \
	-write envsample-dec1.dat "dec1.dat" \
	-write envsample-dec2.dat "dec2.dat" \
	-write envsample-dec3.dat "dec3.dat"

envsample-dump.prg: envsample.a65	
	xa -M -DDUMP=1 -o $@ $<
	c1541 -format "envsample dump,00" d64 envsample-dump.d64 \
	-write envsample-dump.prg "envsample dump"
	
oscsample0-6581.prg: oscsample.a65	
	xa -M -DDUMP=0 -DSID=0 -DPULSEHI=0 -o $@ $<
oscsample0-8580.prg: oscsample.a65	
	xa -M -DDUMP=0 -DSID=1 -DPULSEHI=0 -o $@ $<
	
oscsample0-dump.prg: oscsample.a65	
	xa -M -DDUMP=1 -DWAVE=0 -DPULSEHI=0 -o $@ $<
	c1541 -format "oscsample0 dump,00" d64 oscsample0-dump.d64 \
	-write oscsample0-dump.prg "oscsample0 dump"

oscsample1-6581.prg: oscsample.a65	
	xa -M -DDUMP=0 -DSID=0 -DPULSEHI=1 -o $@ $<
oscsample1-8580.prg: oscsample.a65	
	xa -M -DDUMP=0 -DSID=1 -DPULSEHI=1 -o $@ $<
	
oscsample1.prg: oscsample.a65	
	xa -M -DDUMP=0 -DWAVE=1 -DPULSEHI=1 -o $@ $<
	
oscsample1-dump.prg: oscsample.a65	
	xa -M -DDUMP=1 -DWAVE=0 -DPULSEHI=1 -o $@ $<
	c1541 -format "oscsample1 dump,00" d64 oscsample1-dump.d64 \
	-write oscsample1-dump.prg "oscsample1 dump"

clean: 
	$(RM) $(TESTS)
	$(RM) boundary.d64
	$(RM) boundary-dump.d64
	$(RM) envsample.d64
	$(RM) envsample-dump.d64
	$(RM) oscsample0-dump.d64
	$(RM) oscsample1-dump.d64
