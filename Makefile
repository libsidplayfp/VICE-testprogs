
MAKE=make --no-print-dir

all: help

help:
	@echo "available targets:"
# TODO
#	@echo "buildtests  build test programs"
	@echo "petcat      test 'petcat'"
#	@echo "c1541       test 'c1541'"
	@echo "cartconv    test 'cartconv'"
	@echo "vice        test the emulators (not the emulation)"
	@echo "testbench   run the emulation testbench"
	@echo "runtests    do all of the above"

.PHONY: buildtests
	
# TODO
buildtests:
	
.PHONY: petcat c1541 cartconv vice testbench

petcat:
	@$(MAKE) -C petcat clean all clean

# TODO
c1541:
	@$(MAKE) -C c1541

cartconv:
	@$(MAKE) -C cartconv

vice:
	cd ./testbench && ./checkautostart.sh
	cd ./remotemonitor/binmontest && make test

testbench:
	@$(MAKE) -C testbench testall
	
.PHONY: runtests

runtests: petcat cartconv vice testbench
