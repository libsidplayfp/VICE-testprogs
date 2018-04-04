
.SILENT:

all: prereq
	echo "to run the tests use the following targets:"
	echo "testall           - run all VICE tests"
	echo "testx64"
	echo "testx64sc"
	echo "testx128c64"
	echo "testx128"
	echo "testxscpu64"
	echo "testx64dtv"
	echo "testxpet"
	echo "testxcbm2"
	echo "testxcbm5x0"
	echo "testxvic"
	echo "testxplus4"
	echo "testvsid"
	echo "testchameleon"
	echo "testcham20"
#	echo "testhoxs64"
#	echo "testmicro64"
#	echo "testemu64"
#	echo "testyace"

################################################################################
prereq: selftest testlist cmpscreens prereq-chameleon

.PHONY: testlist selftest

selftest:
	make -C selftest

cmpscreens: cmpscreens.c
	$(CC) -W -Wall -O3 -o cmpscreens cmpscreens.c -lm

################################################################################

testlist: \
	x64-testlist.txt \
	x64sc-testlist.txt \
	x128c64-testlist.txt \
	chameleon-testlist.txt \
	c64rmk2-testlist.txt \
	hoxs64-testlist.txt \
	micro64-testlist.txt \
	emu64-testlist.txt \
	yace-testlist.txt \
	x128-testlist.txt \
	xscpu64-testlist.txt \
	x64dtv-testlist.txt \
	xvic-testlist.txt \
	cham20-testlist.txt \
	xplus4-testlist.txt \
	xpet-testlist.txt \
	xcbm2-testlist.txt \
	xcbm5x0-testlist.txt \
	vsid-testlist.txt

x64-testlist.txt: c64-testlist.in
	echo "# this is a generated file, do not edit." >  x64-testlist.txt
	cat  c64-testlist.in >> x64-testlist.txt

x64sc-testlist.txt: c64-testlist.in
	echo "# this is a generated file, do not edit." >  x64sc-testlist.txt
	cat  c64-testlist.in >> x64sc-testlist.txt

x128c64-testlist.txt: c64-testlist.in
	echo "# this is a generated file, do not edit." >  x128c64-testlist.txt
	cat  c64-testlist.in \
		| grep -v ",vicii-ntscold" \
		| grep -v ",vicii-drean" \
		>> x128c64-testlist.txt

chameleon-testlist.txt: c64-testlist.in
	echo "# this is a generated file, do not edit." >  chameleon-testlist.txt
	cat  c64-testlist.in \
		| grep -v ",vicii-ntscold" \
		| grep -v ",vicii-drean" \
		>> chameleon-testlist.txt

c64rmk2-testlist.txt: c64-testlist.in
	echo "# this is a generated file, do not edit." >  c64rmk2-testlist.txt
	cat  c64-testlist.in \
		| sed -e "s:,screenshot:,interactive:g" \
		| grep -v ",vicii-drean" \
		| grep -v ",geo256k" \
		| grep -v ",reu512k" \
		| grep -v ",plus60k" \
		| grep -v ".d64" \
		| grep -v ".d81" \
		| grep -v ".g64" \
		| grep -v ".crt" \
		>> c64rmk2-testlist.txt

micro64-testlist.txt: c64-testlist.in
	echo "# this is a generated file, do not edit." >  micro64-testlist.txt
	cat  c64-testlist.in \
		| grep -v ",vicii-ntsc" \
		| grep -v ",vicii-ntscold" \
		| grep -v ",vicii-drean" \
		>> micro64-testlist.txt

# The official cartridge file support list is:
# Action Reply
# Retro Reply
# Easy Flash (1MB)
# Ocean
# System 3
# Dinamic
# Magic Desk
# Super Games
# Zaxxon
# Fun Play
# Simons Basic
# 
# Simple 8K/16K and Ultimax cartridges should work also.
hoxs64-testlist.txt: c64-testlist.in
	echo "# this is a generated file, do not edit." >  hoxs64-testlist.txt
	cat  c64-testlist.in \
		| grep -v ",vicii-ntsc" \
		| grep -v ",vicii-ntscold" \
		| grep -v ",vicii-drean" \
		| grep -v ",sid-old" \
		| grep -v ",reu512k" \
		| grep -v ",geo256k" \
		| grep -v ",plus60k" \
		>> hoxs64-testlist.txt

emu64-testlist.txt: c64-testlist.in
	echo "# this is a generated file, do not edit." >  emu64-testlist.txt
	cat  c64-testlist.in \
		| grep -v ",vicii-ntsc" \
		| grep -v ",vicii-ntscold" \
		| grep -v ",vicii-drean" \
		| grep -v ",cia-new" \
		| grep -v ",sid-new" \
		| grep -v ",reu512k" \
		| grep -v ",geo256k" \
		| grep -v ",plus60k" \
		>> emu64-testlist.txt

yace-testlist.txt: c64-testlist.in
	echo "# this is a generated file, do not edit." >  yace-testlist.txt
	cat  c64-testlist.in \
		| grep -v ",vicii-ntsc" \
		| grep -v ",vicii-ntscold" \
		| grep -v ",vicii-drean" \
		>> yace-testlist.txt
		
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

xcbm2-testlist.txt: cbm610-testlist.in
	echo "# this is a generated file, do not edit." >  xcbm2-testlist.txt
	cat  cbm610-testlist.in >> xcbm2-testlist.txt

xcbm5x0-testlist.txt: cbm510-testlist.in
	echo "# this is a generated file, do not edit." >  xcbm5x0-testlist.txt
	cat  cbm510-testlist.in >> xcbm5x0-testlist.txt

xvic-testlist.txt: vic20-testlist.in
	echo "# this is a generated file, do not edit." >  xvic-testlist.txt
	cat  vic20-testlist.in >> xvic-testlist.txt

cham20-testlist.txt: vic20-testlist.in
	echo "# this is a generated file, do not edit." >  cham20-testlist.txt
	cat  vic20-testlist.in \
		| grep -v ",geo256k" \
		>> cham20-testlist.txt

xplus4-testlist.txt: plus4-testlist.in
	echo "# this is a generated file, do not edit." >  xplus4-testlist.txt
	cat  plus4-testlist.in >> xplus4-testlist.txt

vsid-testlist.txt: vsid-testlist.in
	echo "# this is a generated file, do not edit." >  vsid-testlist.txt
	cat  vsid-testlist.in >> vsid-testlist.txt

################################################################################

testall: \
	testx64 \
	testx64sc \
	testx128c64 \
	testx128 \
	testxscpu64 \
	testx64dtv \
	testxplus4 \
	testxvic \
	testxpet \
	testxcbm2 \
	testxcbm5x0 \
	testvsid

testx64: prereq
	./testbench.sh x64

testx64sc: prereq
	./testbench.sh x64sc

testx128c64: prereq
	./testbench.sh x128c64

testx128: prereq
	./testbench.sh x128

testxscpu64: prereq
	./testbench.sh xscpu64

testx64dtv: prereq
	./testbench.sh x64dtv

testxplus4: prereq
	./testbench.sh xplus4

testxvic: prereq
	./testbench.sh xvic

testxpet: prereq
	./testbench.sh xpet

testxcbm2: prereq
	./testbench.sh xcbm2

testxcbm5x0: prereq
	./testbench.sh xcbm5x0

testvsid: prereq
	./testbench.sh vsid

################################################################################

prereq-chameleon: chameleon-helper.prg chameleon-crtoff.prg

chameleon-helper.prg: chameleon-helper.asm
	acme -f cbm -o chameleon-helper.prg chameleon-helper.asm

chameleon-crtoff.prg: chameleon-crtoff.asm
	acme -f plain -o chameleon-crtoff.prg chameleon-crtoff.asm

testchameleon: chameleon-helper.prg prereq
	./testbench.sh chameleon --pal --8565early --6581 --oldcia

testcham20: chameleon-helper.prg prereq
	./testbench.sh cham20




