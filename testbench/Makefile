
.SILENT:

all: testx64 testx64sc

cmpscreens: cmpscreens.c
	$(CC) -W -Wall -O3 -o cmpscreens cmpscreens.c -lm

################################################################################

x64-testlist.txt: c64-testlist.in
	echo "# this is a generated file, do not edit." >  x64-testlist.txt
	cat  c64-testlist.in >> x64-testlist.txt

testx64: x64-testlist.txt cmpscreens
	./testbench.sh x64

################################################################################

x64sc-testlist.txt: c64-testlist.in
	echo "# this is a generated file, do not edit." >  x64sc-testlist.txt
	cat  c64-testlist.in >> x64sc-testlist.txt

testx64sc: x64sc-testlist.txt cmpscreens
	./testbench.sh x64sc

################################################################################

chameleon-helper.prg: chameleon-helper.asm
	acme -f cbm -o chameleon-helper.prg chameleon-helper.asm

chameleon-testlist.txt: c64-testlist.in
	echo "# this is a generated file, do not edit." >  chameleon-testlist.txt
	cat  c64-testlist.in >> chameleon-testlist.txt

testchameleon: chameleon-testlist.txt chameleon-helper.prg cmpscreens
	./testbench.sh chameleon
