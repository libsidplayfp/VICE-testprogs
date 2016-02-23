
all: help

help:
	@echo "available targets:"
#	@echo "buildtest   build test programs"
	@echo "runtests    test VICE"

runtests:
	@make --no-print-dir -C testbench all
