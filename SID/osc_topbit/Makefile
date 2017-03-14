TARGETS = \
osc_topbit_test_triangle_old.prg \
osc_topbit_test_triangle_new.prg \
osc_topbit_test_pulse_old.prg \
osc_topbit_test_pulse_new.prg \
osc_topbit_test_noise_old.prg \
osc_topbit_test_noise_new.prg

all: $(TARGETS)

osc_topbit_test_triangle_old.prg: osc_topbit_test.asm
	acme -DWAVEFORM=0 -DNEWSID=0 -f cbm -o $@ $<

osc_topbit_test_triangle_new.prg: osc_topbit_test.asm
	acme -DWAVEFORM=0 -DNEWSID=1 -f cbm -o $@ $<

osc_topbit_test_pulse_old.prg: osc_topbit_test.asm
	acme -DWAVEFORM=1 -DNEWSID=0 -f cbm -o $@ $<

osc_topbit_test_pulse_new.prg: osc_topbit_test.asm
	acme -DWAVEFORM=1 -DNEWSID=1 -f cbm -o $@ $<

osc_topbit_test_noise_old.prg: osc_topbit_test.asm
	acme -DWAVEFORM=2 -DNEWSID=0 -f cbm -o $@ $<

osc_topbit_test_noise_new.prg: osc_topbit_test.asm
	acme -DWAVEFORM=2 -DNEWSID=1 -f cbm -o $@ $<

clean:
	rm -f $(TARGETS)
