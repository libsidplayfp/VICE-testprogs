
TESTS=extra-formfeed.prg extra-spacing-1.prg extra-spacing-2.prg \
	crash1.prg crash2.prg

all: $(TESTS)

extra-formfeed.prg: extra-formfeed.bas
	petcat -w2 -o extra-formfeed.prg -- extra-formfeed.bas
extra-spacing-1.prg: extra-spacing-1.bas
	petcat -w2 -o extra-spacing-1.prg -- extra-spacing-1.bas
extra-spacing-2.prg: extra-spacing-2.bas
	petcat -w2 -o extra-spacing-2.prg -- extra-spacing-2.bas
crash1.prg: crash1.bas
	petcat -w2 -o crash1.prg -- crash1.bas
crash2.prg: crash2.bas
	petcat -w2 -o crash2.prg -- crash2.bas

PRNOPT=-virtualdev4 -device4 "1" -pr4drv mps803 -pr4output graphics
	
test: test-formfeed test-spacing-1 test-spacing-2 test-crash1 test-crash2
	
test-formfeed: extra-formfeed.prg
	x64sc -default -debugcart -autostartprgmode 1 $(PRNOPT) extra-formfeed.prg
test-spacing-1: extra-spacing-1.prg
	x64sc -default -debugcart -autostartprgmode 1 $(PRNOPT) extra-spacing-1.prg
test-spacing-2: extra-spacing-2.prg
	x64sc -default -debugcart -autostartprgmode 1 $(PRNOPT) extra-spacing-2.prg
test-crash1: crash1.prg
	x64sc -default -debugcart -autostartprgmode 1 $(PRNOPT) crash1.prg
test-crash2: crash2.prg
	x64sc -default -debugcart -autostartprgmode 1 $(PRNOPT) crash2.prg
	
clean:
	$(RM) $(TESTS)
	$(RM) *.bmp
