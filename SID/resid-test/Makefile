
TESTS=\
	boundary.prg \
	chipmodel.prg \
	chipmodel-testbit.prg \
	envboundary.prg \
	envdelay.prg \
	envrate.prg \
	envsample.prg \
	envsustain.prg \
	envtime.prg \
	extfilt.prg \
	noisetest.prg \
	oscsample.prg \
	sweep.prg \
	sweep-kern.prg \
	sweep-orig.prg \
	test.prg \
	voice.prg
	
all: $(TESTS)	
	
%.prg: %.a65
	xa -o $@ $<
	
clean: 
	$(RM) $(TESTS)

#	hexout.prg \
