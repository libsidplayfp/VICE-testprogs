
.SILENT:

all: prereq
	echo "to run the tests use the following targets:"
	echo "testall - run all VICE tests"
	echo "testx64"
	echo "testx64sc"
	echo "testchameleon"
	echo "testx128"
	echo "testxscpu64"
	echo "testx64dtv"
	echo "testxpet"
	echo "testxplus4"

################################################################################
prereq: selftest testlist cmpscreens chameleon-helper.prg

.PHONY: testlist selftest

selftest:
	make -C selftest

cmpscreens: cmpscreens.c
	$(CC) -W -Wall -O3 -o cmpscreens cmpscreens.c -lm

################################################################################

testlist: \
	x64-testlist.txt \
	x64sc-testlist.txt \
	chameleon-testlist.txt \
	x128-testlist.txt \
	xscpu64-testlist.txt \
	x64dtv-testlist.txt \
	xplus4-testlist.txt \
	xpet-testlist.txt

x64-testlist.txt: c64-testlist.in
	echo "# this is a generated file, do not edit." >  x64-testlist.txt
	cat  c64-testlist.in >> x64-testlist.txt

x64sc-testlist.txt: c64-testlist.in
	echo "# this is a generated file, do not edit." >  x64sc-testlist.txt
	cat  c64-testlist.in >> x64sc-testlist.txt

chameleon-testlist.txt: c64-testlist.in
	echo "# this is a generated file, do not edit." >  chameleon-testlist.txt
	cat  c64-testlist.in >> chameleon-testlist.txt

x128-testlist.txt: c128-testlist.in
	echo "# this is a generated file, do not edit." >  x128-testlist.txt
	cat  c128-testlist.in >> x128-testlist.txt

xscpu64-testlist.txt: scpu-testlist.in
	echo "# this is a generated file, do not edit." >  xscpu64-testlist.txt
	cat  scpu-testlist.in >> xscpu64-testlist.txt

x64dtv-testlist.txt: dtv-testlist.in
	echo "# this is a generated file, do not edit." >  x64dtv-testlist.txt
	cat  dtv-testlist.in >> x64dtv-testlist.txt

xpet-testlist.txt: pet-testlist.in
	echo "# this is a generated file, do not edit." >  xpet-testlist.txt
	cat  pet-testlist.in >> xpet-testlist.txt

xplus4-testlist.txt: plus4-testlist.in
	echo "# this is a generated file, do not edit." >  xplus4-testlist.txt
	cat  plus4-testlist.in >> xplus4-testlist.txt

################################################################################

testall: \
	testx64 \
	testx64sc \
	testx128 \
	testxscpu64 \
	testx64dtv \
	testxplus4 \
	testxpet

testx64: prereq
	./testbench.sh x64

testx64sc: prereq
	./testbench.sh x64sc

testx128: prereq
	./testbench.sh x128

testxscpu64: prereq
	./testbench.sh xscpu64

testx64dtv: prereq
	./testbench.sh x64dtv

testxplus4: prereq
	./testbench.sh xplus4

testxpet: prereq
	./testbench.sh xpet

################################################################################

chameleon-helper.prg: chameleon-helper.asm
	acme -f cbm -o chameleon-helper.prg chameleon-helper.asm

testchameleon: chameleon-helper.prg prereq
	./testbench.sh chameleon



