
MAKE=make --no-print-dir

all: help

help:
	@echo "available targets:"
# TODO
#	@echo "buildtests               build test programs"
	@echo "petcat                   test 'petcat'"
	@echo "c1541                    test 'c1541'"
	@echo "cartconv                 test 'cartconv'"
	@echo "vice-autostart           autostart tests"
	@echo "vice-monitor             test ml-monitor"
	@echo "vice-remotemonitor       test remote monitor protocol"
	@echo "vice                     all vice- tests"
	@echo "testbench                run the emulation testbench"
	@echo "runtests                 do all of the above"
	@echo ""
	@echo "If you want to run individual (emulation-) tests, use the"
	@echo "testbench.sh script in the testbench directory."

.PHONY: buildtests
	
# TODO
buildtests:
	@echo "FIXME: implement build target that builds all target tests"
	
.PHONY: petcat c1541 cartconv

petcat:
	@$(MAKE) -C petcat clean all clean

c1541:
	@$(MAKE) -C c1541 clean test clean

cartconv:
	@$(MAKE) -C cartconv

.PHONY: vice-autostart vice-monitor vice-remotemonitor

vice: vice-autostart vice-monitor vice-remotemonitor

vice-autostart:
	cd ./testbench && ./checkautostart.sh

vice-monitor:
	@(MAKE) -C Monitor

vice-remotemonitor:
	cd ./remotemonitor/binmontest && make test

.PHONY: testbench

testbench: buildtests
	@$(MAKE) -C testbench testall
	
.PHONY: runtests

runtests: petcat c1541 cartconv vice testbench
