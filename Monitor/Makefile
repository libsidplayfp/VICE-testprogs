
.SILENT:

MAKE=make --no-print-dir

all: testbench test6502 test6809 test65816 testR65C02 testz80

.PHONY: testbench test6502 test6809 test65816 testR65C02 testz80

testbench:
	@$(MAKE) -C testbench

test6502:
	@$(MAKE) -C 6502
# FIXME: make this one automatic
#	@$(MAKE) -C dummytest

test6809:
	-$(MAKE) -C 6809
	@echo "FIXME: 6809 tests fail due to monitor bugs"

test65816:
	@$(MAKE) -C 65816

testR65C02:
	@$(MAKE) -C R65C02

testz80:
	-@$(MAKE) -C z80
	@echo "FIXME: z80 tests fail due to monitor bugs"

	
clean:
	@$(MAKE) -C testbench clean
	@$(MAKE) -C 6502 clean
	@$(MAKE) -C dummytest clean
	@$(MAKE) -C 6809 clean
	@$(MAKE) -C 65816 clean
	@$(MAKE) -C R65C02 clean
	@$(MAKE) -C z80 clean
