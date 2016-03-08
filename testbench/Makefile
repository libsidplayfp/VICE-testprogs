
.SILENT:

all: prereq
	echo "to run the tests use the following targets:"
	echo "testall - run all VICE tests"
	echo "testx64"
	echo "testx64sc"
	echo "testchameleon"

################################################################################
prereq: selftest testlist cmpscreens chameleon-helper.prg

.PHONY: testlist selftest

selftest:
	make -C selftest

testlist: x64-testlist.txt x64sc-testlist.txt chameleon-testlist.txt

cmpscreens: cmpscreens.c
	$(CC) -W -Wall -O3 -o cmpscreens cmpscreens.c -lm

################################################################################

testall: testx64 testx64sc

################################################################################

x64-testlist.txt: c64-testlist.in
	echo "# this is a generated file, do not edit." >  x64-testlist.txt
	cat  c64-testlist.in >> x64-testlist.txt

testx64: prereq
	./testbench.sh x64

################################################################################

x64sc-testlist.txt: c64-testlist.in
	echo "# this is a generated file, do not edit." >  x64sc-testlist.txt
	cat  c64-testlist.in >> x64sc-testlist.txt

testx64sc: prereq
	./testbench.sh x64sc

################################################################################

chameleon-helper.prg: chameleon-helper.asm
	acme -f cbm -o chameleon-helper.prg chameleon-helper.asm

chameleon-testlist.txt: c64-testlist.in
	echo "# this is a generated file, do not edit." >  chameleon-testlist.txt
	cat  c64-testlist.in >> chameleon-testlist.txt

testchameleon: prereq
	./testbench.sh chameleon
