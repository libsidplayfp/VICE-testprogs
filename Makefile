
MAKE=make --no-print-dir

all: help

help:
	@echo "available targets:"
# TODO
#	@echo "buildtest   build test programs"
	@echo "runtests    test VICE"

.PHONY: petcat c1541 cartconv

petcat:
	@$(MAKE) -C petcat

# TODO
c1541:
	@$(MAKE) -C c1541

# TODO
cartconv:
	@$(MAKE) -C cartconv

.PHONY: runtests

runtests: petcat
	@$(MAKE) -C testbench all
