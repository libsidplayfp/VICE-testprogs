
#X64SCHEAD=r42725
#X64HEAD=r42725
#X64DTVHEAD=r42725
#VSIDHEAD=r42725
#X128HEAD=r42725
#X128C64HEAD=r42725
#XPETHEAD=r42725
#XSCPU64HEAD=r42725
#XVICHEAD=r42725
#XPLUS4HEAD=r42725
#XCBM2HEAD=r42725
#XCBM5X0HEAD=r42725

X64SCHEAD := $(shell ls results/x64sc-r*-result.txt | sed 's/\(.*\)-\(r[0-9]*\)-result.txt/\2/g' | sort | tail -1)
X64HEAD := $(shell ls results/x64-r*-result.txt | sed 's/\(.*\)-\(r[0-9]*\)-result.txt/\2/g' | sort | tail -1)
X64DTVHEAD := $(shell ls results/x64dtv-r*-result.txt | sed 's/\(.*\)-\(r[0-9]*\)-result.txt/\2/g' | sort | tail -1)
VSIDHEAD := $(shell ls results/vsid-r*-result.txt | sed 's/\(.*\)-\(r[0-9]*\)-result.txt/\2/g' | sort | tail -1)
X128HEAD := $(shell ls results/x128-r*-result.txt | sed 's/\(.*\)-\(r[0-9]*\)-result.txt/\2/g' | sort | tail -1)
X128C64HEAD := $(shell ls results/x128c64-r*-result.txt | sed 's/\(.*\)-\(r[0-9]*\)-result.txt/\2/g' | sort | tail -1)
XPETHEAD := $(shell ls results/xpet-r*-result.txt | sed 's/\(.*\)-\(r[0-9]*\)-result.txt/\2/g' | sort | tail -1)
XSCPU64HEAD := $(shell ls results/xscpu64-r*-result.txt | sed 's/\(.*\)-\(r[0-9]*\)-result.txt/\2/g' | sort | tail -1)
XVICHEAD := $(shell ls results/xvic-r*-result.txt | sed 's/\(.*\)-\(r[0-9]*\)-result.txt/\2/g' | sort | tail -1)
XPLUS4HEAD := $(shell ls results/xplus4-r*-result.txt | sed 's/\(.*\)-\(r[0-9]*\)-result.txt/\2/g' | sort | tail -1)
XCBM2HEAD := $(shell ls results/xcbm2-r*-result.txt | sed 's/\(.*\)-\(r[0-9]*\)-result.txt/\2/g' | sort | tail -1)
XCBM5X0HEAD := $(shell ls results/xcbm5x0-r*-result.txt | sed 's/\(.*\)-\(r[0-9]*\)-result.txt/\2/g' | sort | tail -1)
# checked 19/11/2023
DENISELAST=20231119
DENISELASTSTRING="git 19.11.2023"
# checked 19/11/2023
HOXS64LAST=1-1-2-3
HOXS64LASTSTRING=1.1.2.3
# checked 20/11/2023
Z64KC64LAST=20230522
Z64KC64LASTSTRING="22 May 2023"
Z64KC128C64LAST=20230522
Z64KC128C64LASTSTRING="22 May 2023"
Z64KC128LAST=20230522
Z64KC128LASTSTRING="22 May 2023"
Z64KVIC20LAST=20230522
Z64KVIC20LASTSTRING="22 May 2023"
# checked 20/11/2023
KERNAL64C64LAST=1-8-4_b1
KERNAL64C64LASTSTRING=1.8.4_b1
KERNAL64C128C64LAST=1-8-4_b1
KERNAL64C128C64LASTSTRING=1.8.4_b1
KERNAL64C128C128LAST=1-8-4_b1
KERNAL64C128C128LASTSTRING=1.8.4_b1
KERNAL64SCPU64LAST=1-8-4_b1
KERNAL64SCPU64LASTSTRING=1.8.4_b1
KERNAL64CBM2LAST=1-8-4_b1
KERNAL64CBM2LASTSTRING=1.8.4_b1
#KERNAL64CBM5X0LAST=1-8-4_b1
#KERNAL64CBM5X0LASTSTRING=1.8.4_b1

U64LAST=141
U64LASTSTRING="1.41"

# checked 20/11/2023
MICRO64LAST=20180316
MICRO64LASTSTRING="1.00.2018.03.16 (build 719)"

# checked 20/11/2023
EMU64HEAD=20231120

YACEHEAD=2-2-0-47

CHAMSTANDALONELAST=9q
CHAMCARTRIDGELAST=9q

CHAM20LAST=20201130

include Makefile.config

.SILENT:

all: prereq
#	12345678901234567890123456789012345678901234567890123456789012345678901234567890
	echo "to run the tests use the following targets:"
	echo ""
	echo "testall           - run all VICE tests"
	echo ""
	echo "to run individual tests:"
	echo ""
	echo "testx64, testx64sc, testx128c64, testx128, testxscpu64, testx64dtv,"
	echo "testxpet, testxcbm2, testxcbm5x0, testxvic, testxplus4, testvsid"
	echo ""
	echo "to check for differences in last results against latest results in the"
	echo "repository, use:"
	echo ""
	echo "checkx64, checkx64sc, checkx128c64, checkx128, checkxscpu64, checkx64dtv,"
	echo "checkxpet, checkxcbm2, checkxcbm5x0, checkxvic, checkxplus4, checkvsid"
	echo "or checkall"
	echo ""
	echo "allresults - update all result tables (html)"
	echo ""
	echo "for wiki table use something like: make resultswiki | xclip -selection clipboard"
	echo ""
	echo "to run chameleon tests:"
	echo "testchameleon, testcham20"
	echo ""
#	echo "testhoxs64"
#	echo "testmicro64"
#	echo "testemu64"
#	echo "testyace"

################################################################################
prereq: revertfiles selftest testlist cmpscreens maketable prereq-chameleon

.PHONY: testlist selftest prereq revertfiles

revertfiles:
	-svn revert ../drive/format/format.d64
	-make -C ../drive/format/ clean all --no-print-dir --silent > /dev/null
	-svn revert ../C64/carts/tamtest/tamtest.crt
	-make -C ../C64/carts/tamtest/ clean all --no-print-dir --silent > /dev/null
	-svn revert ../drive/rpm/rpm.g64
	-svn revert ../drive/rpm/rpm.p64
	-svn revert ../drive/rpm/rpm.d64
	-make -C ../drive/rpm/ clean all --no-print-dir --silent > /dev/null

selftest:
	make -s -C selftest --no-print-dir --silent

cmpscreens: cmpscreens.c
	$(CC) -W -Wall -O3 -o cmpscreens cmpscreens.c -lm

maketable: maketable.c
	$(CC) -W -Wall -O3 -o maketable maketable.c -lm

################################################################################

TESTLISTS=\
	x64-testlist.txt \
	x64sc-testlist.txt \
	x128c64-testlist.txt \
	chameleon-testlist.txt \
	u64-testlist.txt \
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
	vsid-testlist.txt \
	z64kc64-testlist.txt \
	z64kc128-testlist.txt \
	z64kc128c64-testlist.txt \
	z64kvic20-testlist.txt \
	denise-testlist.txt \
	kernal64c64-testlist.txt \
	kernal64c128c64-testlist.txt \
	kernal64c128c128-testlist.txt \
	kernal64scpu64-testlist.txt \
	kernal64cbm2-testlist.txt \
	kernal64vic20-testlist.txt

testlist: $(TESTLISTS)

x64-testlist.txt: c64-testlist.in Makefile
	echo "# this is a generated file, do not edit." >  x64-testlist.txt
	cat  c64-testlist.in >> x64-testlist.txt

x64sc-testlist.txt: c64-testlist.in Makefile
	echo "# this is a generated file, do not edit." >  x64sc-testlist.txt
	cat  c64-testlist.in >> x64sc-testlist.txt

x128c64-testlist.txt: c64-testlist.in Makefile
	echo "# this is a generated file, do not edit." >  x128c64-testlist.txt
	cat  c64-testlist.in \
		| sed -e 's/cpuport.prg/cpuport128.prg/g' \
		| grep -v ",vicii-ntscold" \
		| grep -v ",vicii-drean" \
		| grep -v ",plus60k" \
		| grep -v ",plus256k" \
		>> x128c64-testlist.txt

chameleon-testlist.txt: c64-testlist.in Makefile
	echo "# this is a generated file, do not edit." >  chameleon-testlist.txt
	cat  c64-testlist.in \
		| grep -v "4485 only" \
		| grep -v 'nordicpower.*mountcrt:ar.*crt' \
		| grep -v 'nordicpower.*mountcrt:rr.*crt' \
		| grep -v 'nordicpower.*mountcrt:np.*crt' \
		| grep -v 'aracidtest.*mountcrt:ar.*crt' \
		| grep -v 'aracidtest.*mountcrt:rr.*crt' \
		| grep -v 'aracidtest.*mountcrt:np.*crt' \
		| grep -v ",vicii-ntscold" \
		| grep -v ",vicii-drean" \
		| grep -v ",mountp64" \
		| grep -v ",plus60k" \
		| grep -v ",plus256k" \
		| grep -v ",isepic" \
		| grep -v ",dqbb" \
		| grep -v ",ramcart128k" \
		>> chameleon-testlist.txt

# FIXME
u64-testlist.txt: c64-testlist.in Makefile
	echo "# this is a generated file, do not edit." >  u64-testlist.txt
	cat  c64-testlist.in \
		| grep -v ",cia-new" \
		| grep -v ",vicii-ntsc" \
		| grep -v ",vicii-ntscold" \
		| grep -v ",vicii-drean" \
		| grep -v ",plus60k" \
		| grep -v ",plus256k" \
		| grep -v ",isepic" \
		| grep -v ",dqbb" \
		| grep -v ",ramcart128k" \
		| grep -v ",mountp64" \
		>> u64-testlist.txt

#		| grep -v ",mountd64" \
#		| grep -v ",mountg64" \
		
c64rmk2-testlist.txt: c64-testlist.in Makefile
	echo "# this is a generated file, do not edit." >  c64rmk2-testlist.txt
	cat  c64-testlist.in \
		| grep -v ",screenshot" \
		| grep -v ",vicii-drean" \
		| grep -v ",geo512k" \
		| grep -v ",reu512k" \
		| grep -v ",plus60k" \
		| grep -v ",plus256k" \
		| grep -v ",isepic" \
		| grep -v ",dqbb" \
		| grep -v ",ramcart128k" \
		| grep -v ".d64" \
		| grep -v ".d81" \
		| grep -v ".g64" \
		| grep -v ".crt" \
		>> c64rmk2-testlist.txt

micro64-testlist.txt: c64-testlist.in Makefile
	echo "# this is a generated file, do not edit." >  micro64-testlist.txt
	cat  c64-testlist.in \
		| grep -v ",vicii-ntsc" \
		| grep -v ",vicii-ntscold" \
		| grep -v ",vicii-drean" \
		| grep -v ",plus60k" \
		| grep -v ",plus256k" \
		| grep -v ",isepic" \
		| grep -v ",dqbb" \
		| grep -v ",ramcart128k" \
		>> micro64-testlist.txt

# The official cartridge file support list is:
#
# Action Replay
# Retro Replay
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
#
# REU 512k only!

# FIXME: apparently mounting a cartridge and then running a prg file does not
#        work right in hoxs64

hoxs64-testlist.txt: c64-testlist.in Makefile
	echo "# this is a generated file, do not edit." >  hoxs64-testlist.txt
	cat  c64-testlist.in \
		| grep -v ",vicii-ntsc" \
		| grep -v ",vicii-ntscold" \
		| grep -v ",vicii-drean" \
		| grep -v ",sid-old" \
		| grep -v ",reu128k" \
		| grep -v ",reu256k" \
		| grep -v ",reu1m" \
		| grep -v ",reu2m" \
		| grep -v ",reu4m" \
		| grep -v ",reu8m" \
		| grep -v ",reu16m" \
		| grep -v ",geo512k" \
		| grep -v ",plus60k" \
		| grep -v ",plus256k" \
		| grep -v ",isepic" \
		| grep -v ",dqbb" \
		| grep -v ",ramcart128k" \
		| grep -v "C64/carts/nordicpower" \
		| grep -v "C64/carts/pagefox" \
		| grep -v "mountcrt:nrdummy.crt" \
		| grep -v "mountcrt:npdummy.crt" \
		>> hoxs64-testlist.txt

emu64-testlist.txt: c64-testlist.in Makefile
	echo "# this is a generated file, do not edit." >  emu64-testlist.txt
	cat  c64-testlist.in \
		| grep -v ",vicii-ntsc" \
		| grep -v ",vicii-ntscold" \
		| grep -v ",vicii-drean" \
		| grep -v ",cia-new" \
		| grep -v ",plus60k" \
		| grep -v ",plus256k" \
		| grep -v ",isepic" \
		| grep -v ",dqbb" \
		| grep -v ",ramcart128k" \
		| grep -v ",mountp64:" \
		>> emu64-testlist.txt

		
denise-testlist.txt: c64-testlist.in Makefile
	echo "# this is a generated file, do not edit." >  denise-testlist.txt
	cat  c64-testlist.in \
		| grep -v ",plus60k" \
		| grep -v ",plus256k" \
		| grep -v ",isepic" \
		| grep -v ",dqbb" \
		| grep -v ",ramcart128k" \
		>> denise-testlist.txt

#		| grep -v ",screenshot" \
		
yace-testlist.txt: c64-testlist.in Makefile
	echo "# this is a generated file, do not edit." >  yace-testlist.txt
	cat  c64-testlist.in \
		| grep -v ",vicii-ntscold" \
		| grep -v ",vicii-drean" \
		| grep -v ",cia-new" \
		| grep -v ",sid-new" \
		| grep -v ",plus60k" \
		| grep -v ",plus256k" \
		| grep -v ",isepic" \
		| grep -v ",dqbb" \
		| grep -v ",ramcart128k" \
		>> yace-testlist.txt
		
#Cartridge support for the following crt types:
# - Action Replay
# - KCS Power Cartridge
# - Final Cartridge III
# - Simons' Basic
# - Ocean Type 1
# - Expert cartridge
# - Super Games
# - Epyx Fastload
# - Final Cartridge I
# - Game System
# - Dinamic
# - Zaxxon
# - Magic Desk
# - Super Snapshot V5
# - Comal80
# - EasyFlash
# - GMod2
#Digimax
#REU - 512KB and 16MB
#GEORAM
#CPM cartridge
#Swiftlink cartridge
#Userport RS232 - UP9600

z64kc64-testlist.txt: c64-testlist.in Makefile
	echo "# this is a generated file, do not edit." >  z64kc64-testlist.txt
	cat  c64-testlist.in \
		| grep -v ",vicii-ntscold" \
		| grep -v ",vicii-drean" \
		| grep -v ",reu128k" \
		| grep -v ",reu256k" \
		| grep -v ",reu1m" \
		| grep -v ",reu2m" \
		| grep -v ",reu4m" \
		| grep -v ",reu8m" \
		| grep -v ",plus60k" \
		| grep -v ",plus256k" \
		| grep -v ",isepic" \
		| grep -v ",dqbb" \
		| grep -v ",ramcart128k" \
		| grep -v "C64/carts/nordicpower" \
		| grep -v "mountcrt:nrdummy.crt" \
		| grep -v "mountcrt:npdummy.crt" \
		>> z64kc64-testlist.txt
		
z64kc128c64-testlist.txt: c64-testlist.in Makefile
	echo "# this is a generated file, do not edit." >  z64kc128c64-testlist.txt
	cat  c64-testlist.in \
		| sed -e 's/cpuport.prg/cpuport128.prg/g' \
		| grep -v ",vicii-ntscold" \
		| grep -v ",vicii-drean" \
		| grep -v ",reu128k" \
		| grep -v ",reu256k" \
		| grep -v ",reu1m" \
		| grep -v ",reu2m" \
		| grep -v ",reu4m" \
		| grep -v ",reu8m" \
		| grep -v ",plus60k" \
		| grep -v ",plus256k" \
		| grep -v ",isepic" \
		| grep -v ",dqbb" \
		| grep -v ",ramcart128k" \
		| grep -v "C64/carts/nordicpower" \
		| grep -v "mountcrt:nrdummy.crt" \
		| grep -v "mountcrt:npdummy.crt" \
		>> z64kc128c64-testlist.txt
		
x128-testlist.txt: c128-testlist.in Makefile
	echo "# this is a generated file, do not edit." >  x128-testlist.txt
	cat  c128-testlist.in >> x128-testlist.txt

z64kc128-testlist.txt: c128-testlist.in Makefile
	echo "# this is a generated file, do not edit." >  z64kc128-testlist.txt
	cat  c128-testlist.in \
		| grep -v ",vicii-ntscold" \
		| grep -v ",vicii-drean" \
		| grep -v ",mountg71" \
		| grep -v ",efnram" \
		| grep -v ",ifnram" \
		| grep -v ",reu128k" \
		| grep -v ",reu256k" \
		| grep -v ",reu1m" \
		| grep -v ",reu2m" \
		| grep -v ",reu4m" \
		| grep -v ",reu8m" \
		| grep -v ",plus60k" \
		| grep -v ",plus256k" \
		| grep -v ",isepic" \
		| grep -v ",dqbb" \
		| grep -v ",ramcart128k" \
		| grep -v "C64/carts/nordicpower" \
		| grep -v "mountcrt:nrdummy.crt" \
		| grep -v "mountcrt:npdummy.crt" \
		>> z64kc128-testlist.txt

# official list of supported cartridges for kernal64 is this:
# see https://github.com/abbruzze/kernal64/tree/master/Kernal64/src/ucesoft/cbm/formats/cart
#
# ActionReplay
# KCS Power Cartridge
# Final Cartridge III
# Simon's Basic
# Comal 80
# Magic Desk
# Dynamic
# Game System
# Warp Speed
# Easy Flash
# Ocean Type 1
# Fun Play
# Super Games
# Epyx Fastload
# Final Cartridge I
# Super Snapshot V5
# GMOD 2
# GMOD 3
# Zaxxon
# Mach 5
# Page Fox
# CP/M
# BeamRacer
# DigiMax
# SwiftLink
# REU
# GeoRAM
kernal64c64-testlist.txt: c64-testlist.in Makefile
	echo "# this is a generated file, do not edit." >  kernal64c64-testlist.txt
	cat  c64-testlist.in \
		| grep -v ",vicii-ntscold" \
		| grep -v ",vicii-drean" \
		| grep -v ",plus60k" \
		| grep -v ",plus256k" \
		| grep -v ",isepic" \
		| grep -v ",dqbb" \
		| grep -v ",ramcart128k" \
		| grep -v "cia1-sdr-icr-4485" \
		| grep -v "nordicpower" \
		| grep -v "mountcrt:npdummy.crt" \
		| grep -v "mountcrt:nrdummy.crt" \
		| grep -v "mountcrt:rrdummy.crt" \
		| grep -v "mountcrt:rr-reu.crt" \
		| grep -v "mountcrt:rr-freeze.crt" \
		| grep -v "mountcrt:8k-vic-rr.crt" \
		| grep -v "mountcrt:16k-vic-rr.crt" \
		| grep -v "mountcrt:ultimax-vic-rr.crt" \
		>> kernal64c64-testlist.txt

kernal64c128c64-testlist.txt: c64-testlist.in Makefile
	echo "# this is a generated file, do not edit." >  kernal64c128c64-testlist.txt
	cat  c64-testlist.in \
		| grep -v ",vicii-ntscold" \
		| grep -v ",vicii-drean" \
		| grep -v ",plus60k" \
		| grep -v ",plus256k" \
		| grep -v ",isepic" \
		| grep -v ",dqbb" \
		| grep -v ",ramcart128k" \
		| grep -v "cia1-sdr-icr-4485" \
		| grep -v "nordicpower" \
		| grep -v "mountcrt:npdummy.crt" \
		| grep -v "mountcrt:nrdummy.crt" \
		| grep -v "mountcrt:rrdummy.crt" \
		| grep -v "mountcrt:rr-reu.crt" \
		| grep -v "mountcrt:rr-freeze.crt" \
		| grep -v "mountcrt:8k-vic-rr.crt" \
		| grep -v "mountcrt:16k-vic-rr.crt" \
		| grep -v "mountcrt:ultimax-vic-rr.crt" \
		>> kernal64c128c64-testlist.txt

kernal64c128c128-testlist.txt: c128-testlist.in Makefile
	echo "# this is a generated file, do not edit." >  kernal64c128c128-testlist.txt
	cat  c128-testlist.in \
		| grep -v ",vicii-ntscold" \
		| grep -v ",vicii-drean" \
		| grep -v ",efnram" \
		| grep -v ",ifnram" \
		| grep -v ",plus60k" \
		| grep -v ",plus256k" \
		| grep -v ",isepic" \
		| grep -v ",dqbb" \
		| grep -v ",ramcart128k" \
		| grep -v ",mountg71:" \
		>> kernal64c128c128-testlist.txt

kernal64scpu64-testlist.txt: scpu-testlist.in Makefile
	echo "# this is a generated file, do not edit." >  kernal64scpu64-testlist.txt
	cat  scpu-testlist.in \
		| grep -v ",vicii-ntscold" \
		| grep -v ",vicii-drean" \
		| grep -v ",plus60k" \
		| grep -v ",plus256k" \
		| grep -v ",isepic" \
		| grep -v ",dqbb" \
		| grep -v ",ramcart128k" \
		| grep -v "cia1-sdr-icr-4485" \
		| grep -v "nordicpower" \
		| grep -v "mountcrt:npdummy.crt" \
		| grep -v "mountcrt:nrdummy.crt" \
		| grep -v "mountcrt:rrdummy.crt" \
		| grep -v "mountcrt:rr-reu.crt" \
		| grep -v "mountcrt:rr-freeze.crt" \
		| grep -v "mountcrt:8k-vic-rr.crt" \
		| grep -v "mountcrt:16k-vic-rr.crt" \
		| grep -v "mountcrt:ultimax-vic-rr.crt" \
		>> kernal64scpu64-testlist.txt

kernal64cbm2-testlist.txt: cbm610-testlist.in Makefile
	echo "# this is a generated file, do not edit." >  kernal64cbm2-testlist.txt
	cat  cbm610-testlist.in >> kernal64cbm2-testlist.txt

kernal64vic20-testlist.txt: vic20-testlist.in Makefile
	echo "# this is a generated file, do not edit." >  kernal64vic20-testlist.txt
	cat  vic20-testlist.in >> kernal64vic20-testlist.txt

xscpu64-testlist.txt: scpu-testlist.in Makefile
	echo "# this is a generated file, do not edit." >  xscpu64-testlist.txt
	cat  scpu-testlist.in >> xscpu64-testlist.txt

x64dtv-testlist.txt: dtv-testlist.in Makefile
	echo "# this is a generated file, do not edit." >  x64dtv-testlist.txt
	cat  dtv-testlist.in >> x64dtv-testlist.txt

xpet-testlist.txt: pet-testlist.in Makefile
	echo "# this is a generated file, do not edit." >  xpet-testlist.txt
	cat  pet-testlist.in >> xpet-testlist.txt

xcbm2-testlist.txt: cbm610-testlist.in Makefile
	echo "# this is a generated file, do not edit." >  xcbm2-testlist.txt
	cat  cbm610-testlist.in >> xcbm2-testlist.txt

xcbm5x0-testlist.txt: cbm510-testlist.in Makefile
	echo "# this is a generated file, do not edit." >  xcbm5x0-testlist.txt
	cat  cbm510-testlist.in >> xcbm5x0-testlist.txt

xvic-testlist.txt: vic20-testlist.in Makefile
	echo "# this is a generated file, do not edit." >  xvic-testlist.txt
	cat  vic20-testlist.in >> xvic-testlist.txt

z64kvic20-testlist.txt: vic20-testlist.in Makefile
	echo "# this is a generated file, do not edit." >  z64kvic20-testlist.txt
	cat  vic20-testlist.in \
		| grep -v ",geo512k" \
		>> z64kvic20-testlist.txt

cham20-testlist.txt: vic20-testlist.in Makefile
	echo "# this is a generated file, do not edit." >  cham20-testlist.txt
	cat  vic20-testlist.in \
		| grep -v ",geo512k" \
		>> cham20-testlist.txt

xplus4-testlist.txt: plus4-testlist.in Makefile
	echo "# this is a generated file, do not edit." >  xplus4-testlist.txt
	cat  plus4-testlist.in >> xplus4-testlist.txt

vsid-testlist.txt: vsid-testlist.in Makefile
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
	
	make checkall

testx64: prereq
	EMUDIR="$(VICEDIR)" ./testbench.sh x64

testx64sc: prereq
	EMUDIR="$(VICEDIR)" ./testbench.sh x64sc

testx128c64: prereq
	EMUDIR="$(VICEDIR)" ./testbench.sh x128c64

testx128: prereq
	EMUDIR="$(VICEDIR)" ./testbench.sh x128

testxscpu64: prereq
	EMUDIR="$(VICEDIR)" ./testbench.sh xscpu64

testx64dtv: prereq
	EMUDIR="$(VICEDIR)" ./testbench.sh x64dtv

testxplus4: prereq
	EMUDIR="$(VICEDIR)" ./testbench.sh xplus4

testxvic: prereq
	EMUDIR="$(VICEDIR)" ./testbench.sh xvic

testxpet: prereq
	EMUDIR="$(VICEDIR)" ./testbench.sh xpet

testxcbm2: prereq
	EMUDIR="$(VICEDIR)" ./testbench.sh xcbm2

testxcbm5x0: prereq
	EMUDIR="$(VICEDIR)" ./testbench.sh xcbm5x0

testvsid: prereq
	EMUDIR="$(VICEDIR)" ./testbench.sh vsid

##############################################################################
	
testhoxs64: prereq	
	EMUDIR="$(HOXS64DIR)" ./testbench.sh hoxs64 --pal --cianew --8580 --8565early
testmicro64: prereq
	EMUDIR="$(MICRO64DIR)" ./testbench.sh micro64

testz64k: testz64kc64 testz64kc128c64 testz64kc128 testz64kvic20
testz64kc64: prereq
	EMUDIR="$(Z64KDIR)" ./testbench.sh z64kc64
testz64kc128c64: prereq	
	EMUDIR="$(Z64KDIR)" ./testbench.sh z64kc128c64
testz64kc128: prereq
	EMUDIR="$(Z64KDIR)" ./testbench.sh z64kc128
testz64kvic20: prereq
	EMUDIR="$(Z64KDIR)" ./testbench.sh z64kvic20

testyace: prereq
#	EMUDIR="$(YACEDIR)" ./testbench.sh yace --verbose
	EMUDIR="$(YACEDIR)" ./testbench.sh yace
testdenise: prereq
#	EMUDIR="$(DENISEDIR)" ./testbench.sh denise --resume
	EMUDIR="$(DENISEDIR)" ./testbench.sh denise
testemu64: prereq
#	EMUDIR="$(EMU64DIR)" ./testbench.sh emu64 --verbose --resume
	EMUDIR="$(EMU64DIR)" ./testbench.sh emu64 --resume

testkernal64: testkernal64c64 testkernal64c128c64 testkernal64c128c128 testkernal64scpu64 testkernal64cbm2
testkernal64c64: prereq
#	EMUDIR="$(KERNAL64DIR)" ./testbench.sh kernal64c64 --verbose
	EMUDIR="$(KERNAL64DIR)" ./testbench.sh kernal64c64 --resume
testkernal64c128c64: prereq
#	EMUDIR="$(KERNAL64DIR)" ./testbench.sh kernal64c128c64 --verbose
	EMUDIR="$(KERNAL64DIR)" ./testbench.sh kernal64c128c64 --resume
testkernal64c128c128: prereq
#	EMUDIR="$(KERNAL64DIR)" ./testbench.sh kernal64c128c128 --verbose
	EMUDIR="$(KERNAL64DIR)" ./testbench.sh kernal64c128c128 --resume
testkernal64scpu64: prereq
#	EMUDIR="$(KERNAL64DIR)" ./testbench.sh kernal64scpu64 --verbose
	EMUDIR="$(KERNAL64DIR)" ./testbench.sh kernal64scpu64 --resume
testkernal64cbm2: prereq
#	EMUDIR="$(KERNAL64DIR)" ./testbench.sh kernal64cbm2 --verbose
	EMUDIR="$(KERNAL64DIR)" ./testbench.sh kernal64cbm2 --resume

##############################################################################

prereq-chameleon: chameleon-helper.prg chameleon-crtoff.prg chameleon-videomode.prg \
			chameleon-driveinit.prg

chameleon-helper.prg: chameleon-helper.asm
	acme -f cbm -o chameleon-helper.prg chameleon-helper.asm

chameleon-videomode.prg: chameleon-videomode.asm
	acme -f cbm -o chameleon-videomode.prg chameleon-videomode.asm

chameleon-crtoff.prg: chameleon-crtoff.asm
	acme -f plain -o chameleon-crtoff.prg chameleon-crtoff.asm

chameleon-driveinit.prg: chameleon-driveinit.bas
	petcat -w2 -o chameleon-driveinit.prg -- chameleon-driveinit.bas
	
testchameleon: chameleon-helper.prg prereq
	./testbench.sh chameleon --8565early
# for testing in cartridge mode on "new" c64 / PAL
testchameleoncart: chameleon-helper.prg prereq
	./testbench.sh chameleon --pal --8565early --cianew --8580

testcham20: chameleon-helper.prg prereq
	./testbench.sh cham20 --8k

##############################################################################
# OLD cia
# 6581 bus interface with 8580 alike sounds.
# VIC 6567 and 6569, no gray dots.	
testu64: prereq
	./testbench.sh u64 --resume --ciaold --6581 --pal

################################################################################
# the following must be manually updated to use the right files
################################################################################

.PHONY: checkx64 checkx64sc checkx128c64 checkx128 checkxscpu64 checkx64dtv \
	checkxpet checkxcbm2 checkxcbm5x0 checkxvic checkxplus4 checkvsid

checkall: checkx64 checkx64sc checkx128c64 checkx128 checkxscpu64 checkx64dtv \
	checkxpet checkxcbm2 checkxcbm5x0 checkxvic checkxplus4 checkvsid
	
checkx64: maketable
	echo "checking x64:"
	./maketable --list c64-testlist.in \
		--results x64-result.txt "new" \
		--results results/x64-$(X64HEAD)-result.txt "$(X64HEAD)" \
		--diff
checkx64sc: maketable
	echo "checking x64sc:"
	./maketable --list c64-testlist.in \
		--results x64sc-result.txt "new" \
		--results results/x64sc-$(X64SCHEAD)-result.txt "$(X64SCHEAD)" \
		--diff
checkx128c64: maketable
	echo "checking x128(c64):"
	./maketable --list c64-testlist.in \
		--results x128c64-result.txt "new" \
		--results results/x128c64-$(X128C64HEAD)-result.txt "$(X128C64HEAD)" \
		--diff
checkx128: maketable
	echo "checking x128:"
	./maketable --list c128-testlist.in \
		--results x128-result.txt "new" \
		--results results/x128-$(X128HEAD)-result.txt "$(X128HEAD)" \
		--diff
checkxscpu64: maketable
	echo "checking xscpu64:"
	./maketable --list scpu-testlist.in \
		--results xscpu64-result.txt "new" \
		--results results/xscpu64-$(XSCPU64HEAD)-result.txt "$(XSCPU64HEAD)" \
		--diff
checkx64dtv: maketable
	echo "checking x64dtv:"
	./maketable --list dtv-testlist.in \
		--results x64dtv-result.txt "new" \
		--results results/x64dtv-$(X64DTVHEAD)-result.txt "$(X64DTVHEAD)" \
		--diff
checkxpet: maketable
	echo "checking xpet:"
	./maketable --list pet-testlist.in \
		--results xpet-result.txt "new" \
		--results results/xpet-$(XPETHEAD)-result.txt "$(XPETHEAD)" \
		--diff
checkxcbm2: maketable
	echo "checking xcbm2:"
	./maketable --list cbm610-testlist.in \
		--results xcbm2-result.txt "new" \
		--results results/xcbm2-$(XCBM2HEAD)-result.txt "$(XCBM2HEAD)" \
		--diff
checkxcbm5x0: maketable
	echo "checking xcbm5x0:"
	./maketable --list cbm510-testlist.in \
		--results xcbm5x0-result.txt "new" \
		--results results/xcbm5x0-$(XCBM5X0HEAD)-result.txt "$(XCBM5X0HEAD)" \
		--diff
checkxvic: maketable
	echo "checking xvic:"
	./maketable --list vic20-testlist.in \
		--results xvic-result.txt "new" \
		--results results/xvic-$(XVICHEAD)-result.txt "$(XVICHEAD)" \
		--diff
checkxplus4: maketable
	echo "checking xplus4:"
	./maketable --list plus4-testlist.in \
		--results xplus4-result.txt "new" \
		--results results/xplus4-$(XPLUS4HEAD)-result.txt "$(XPLUS4HEAD)" \
		--diff
checkvsid: maketable
	echo "checking vsid:"
	./maketable --list vsid-testlist.in \
		--results vsid-result.txt "new" \
		--results results/vsid-$(VSIDHEAD)-result.txt "$(VSIDHEAD)" \
		--diff

.PHONY: results0 results resultswiki

results0: maketable
	./maketable --list c64-testlist.in \
		--results results/x64sc-$(X64SCHEAD)-result.txt "x64sc "$(X64SCHEAD)"" \
		--results results/x64-$(X64HEAD)-result.txt "x64 "$(X64HEAD)"" \
		--results results/x128c64-$(X128C64HEAD)-result.txt "x128 (c64) "$(X128C64HEAD)"" \
		--results results/hoxs64-$(HOXS64LAST)-result.txt "hoxs64 "$(HOXS64LASTSTRING)"" \
		--results results/z64kc64-$(Z64KC64LAST)-result.txt "z64k (c64) "$(Z64KC64LASTSTRING)"" \
		--results results/z64kc128c64-$(Z64KC128C64LAST)-result.txt "z64k (c128/c64) "$(Z64KC128C64LASTSTRING)"" \
		--results results/micro64-$(MICRO64LAST)-result.txt "micro64 "$(MICRO64STRING)"" \
		--results results/denise-$(DENISELAST)-result.txt "denise "$(DENISELASTSTRING)"" \
		--results results/kernal64c64-$(KERNAL64C64LAST)-result.txt "kernal64 (c64) "$(KERNAL64C64LASTSTRING)"" \
		--results results/kernal64c128c64-$(KERNAL64C128C64LAST)-result.txt "kernal64 (c128/c64) "$(KERNAL64C128C64LASTSTRING)"" \
		--results results/emu64-$(EMU64HEAD)-result.txt "emu64 "$(EMU64HEAD)"" \
		--results results/yace-$(YACEHEAD)-result.txt "yace "$(YACEHEAD)"" \
		--results results/chameleon-$(CHAMCARTRIDGELAST)-cartridge-result.txt "TC64 "$(CHAMCARTRIDGELAST)" (cartridge)" \
		--results results/chameleon-$(CHAMSTANDALONELAST)-standalone-result.txt "TC64 "$(CHAMSTANDALONELAST)" (standalone)" \
		--results results/u64-$(U64LAST)-result.txt "U64 "$(U64LASTSTRING)" (PAL)"

	./maketable --list vic20-testlist.in \
		--results results/xvic-$(XVICHEAD)-result.txt "xvic "$(XVICHEAD)"" \
		--results results/z64kvic20-$(Z64KVIC20LAST)-result.txt "z64k (vic20) "$(Z64KVIC20LASTSTRING)"" \
		--results results/cham20-$(CHAM20LAST)-result.txt "cham20 "$(CHAM20LAST)""

	./maketable --list c128-testlist.in \
		--results results/x128-$(X128HEAD)-result.txt "x128 "$(X128HEAD)"" \
		--results results/z64kc128-$(Z64KC128LAST)-result.txt "z64k (c128) "$(Z64KC128LASTSTRING)"" \
		--results results/kernal64c128c128-$(KERNAL64C128C128LAST)-result.txt "kernal64 (c128) "$(KERNAL64C128C128LASTSTRING)""

	./maketable --list plus4-testlist.in \
		--results results/xplus4-$(XPLUS4HEAD)-result.txt "xplus4 "$(XPLUS4HEAD)""

	./maketable --list pet-testlist.in \
		--results results/xpet-$(XPETHEAD)-result.txt "xpet "$(XPETHEAD)""

	./maketable --list dtv-testlist.in \
		--results results/x64dtv-$(X64DTVHEAD)-result.txt "x64dtv "$(X64DTVHEAD)""

	./maketable --list scpu-testlist.in \
		--results results/xscpu64-$(XSCPU64HEAD)-result.txt "xscpu64 "$(XSCPU64HEAD)"" \
		--results results/kernal64scpu64-$(KERNAL64SCPU64LAST)-result.txt "kernal64 (scpu64) "$(KERNAL64SCPU64LASTSTRING)""
		
	./maketable --list cbm510-testlist.in \
		--results results/xcbm5x0-$(XCBM5X0HEAD)-result.txt "xcbm5x0 "$(XCBM5X0HEAD)""
		
	./maketable --list cbm610-testlist.in \
		--results results/xcbm2-$(XCBM2HEAD)-result.txt "xcbm2 "$(XCBM2HEAD)""

	./maketable  --list vsid-testlist.in \
		--results results/vsid-$(VSIDHEAD)-result.txt "vsid "$(VSIDHEAD)""

results: maketable
	./maketable --omit-clean --html --list c64-testlist.in \
		--ranking "<small><hr>%d%%<br>%d of %d<small>" \
		--results results/denise-$(DENISELAST)-result.txt "denise "$(DENISELASTSTRING)"" \
		--results results/x64sc-$(X64SCHEAD)-result.txt "x64sc "$(X64SCHEAD)"" \
		--results results/z64kc64-$(Z64KC64LAST)-result.txt "z64k (c64) "$(Z64KC64LASTSTRING)"" \
		--results results/chameleon-$(CHAMCARTRIDGELAST)-cartridge-result.txt "TC64 "$(CHAMCARTRIDGELAST)" (cartridge)" \
		--results results/hoxs64-$(HOXS64LAST)-result.txt "hoxs64 "$(HOXS64LASTSTRING)"" \
		--results results/z64kc128c64-$(Z64KC128C64LAST)-result.txt "z64k (c128/c64) "$(Z64KC128C64LASTSTRING)"" \
		--results results/x128c64-$(X128C64HEAD)-result.txt "x128 (c64) "$(X128C64HEAD)"" \
		--results results/x64-$(X64HEAD)-result.txt "x64 "$(X64HEAD)"" \
		--results results/u64-$(U64LAST)-result.txt "U64 "$(U64LASTSTRING)" (PAL)" \
		--results results/micro64-$(MICRO64LAST)-result.txt "micro64 "$(MICRO64LASTSTRING)"" \
		--results results/chameleon-$(CHAMSTANDALONELAST)-standalone-result.txt "TC64 "$(CHAMSTANDALONELAST)" (standalone)" \
		--results results/kernal64c128c64-$(KERNAL64C128C64LAST)-result.txt "kernal64 (c128/c64) "$(KERNAL64C128C64LASTSTRING)"" \
		--results results/kernal64c64-$(KERNAL64C64LAST)-result.txt "kernal64 (c64) "$(KERNAL64C64LASTSTRING)"" \
		--results results/yace-$(YACEHEAD)-result.txt "yace "$(YACEHEAD)"" \
		--results results/emu64-$(EMU64HEAD)-result.txt "emu64 "$(EMU64HEAD)"" \
		\
		> results/c64.html
		
	./maketable  --omit-clean --html --list vic20-testlist.in \
		--ranking "<small><hr>%d%%<br>%d of %d<small>" \
		--results results/xvic-$(XVICHEAD)-result.txt "xvic "$(XVICHEAD)"" \
		--results results/z64kvic20-$(Z64KVIC20LAST)-result.txt "z64k (vic20) "$(Z64KVIC20LASTSTRING)"" \
		--results results/cham20-$(CHAM20LAST)-result.txt "cham20 "$(CHAM20LAST)"" \
		\
		> results/vic20.html
		
	./maketable  --omit-clean --html --list c128-testlist.in \
		--ranking "<small><hr>%d%%<br>%d of %d<small>" \
		--results results/z64kc128-$(Z64KC128LAST)-result.txt "z64k (c128) "$(Z64KC128LASTSTRING)"" \
		--results results/x128-$(X128HEAD)-result.txt "x128 "$(X128HEAD)"" \
		--results results/kernal64c128c128-$(KERNAL64C128C128LAST)-result.txt "kernal64 (c128) "$(KERNAL64C128C128LASTSTRING)"" \
		\
		> results/c128.html

	./maketable  --omit-clean --html --list plus4-testlist.in \
		--ranking "<small><hr>%d%%<br>%d of %d<small>" \
		--results results/xplus4-$(XPLUS4HEAD)-result.txt "xplus4 "$(XPLUS4HEAD)"" \
		\
		> results/plus4.html

	./maketable  --omit-clean --html --list pet-testlist.in \
		--ranking "<small><hr>%d%%<br>%d of %d<small>" \
		--results results/xpet-$(XPETHEAD)-result.txt "xpet "$(XPETHEAD)"" \
		\
		> results/pet.html

	./maketable  --omit-clean --html --list dtv-testlist.in \
		--ranking "<small><hr>%d%%<br>%d of %d<small>" \
		--results results/x64dtv-$(X64DTVHEAD)-result.txt "x64dtv "$(X64DTVHEAD)"" \
		\
		> results/dtv.html

	./maketable  --omit-clean --html --list scpu-testlist.in \
		--ranking "<small><hr>%d%%<br>%d of %d<small>" \
		--results results/kernal64scpu64-$(KERNAL64SCPU64LAST)-result.txt "kernal64 (scpu64) "$(KERNAL64SCPU64LASTSTRING)"" \
		--results results/xscpu64-$(XSCPU64HEAD)-result.txt "xscpu64 "$(XSCPU64HEAD)"" \
		\
		> results/scpu.html
		
	./maketable  --omit-clean --html --list cbm510-testlist.in \
		--ranking "<small><hr>%d%%<br>%d of %d<small>" \
		--results results/xcbm5x0-$(XCBM5X0HEAD)-result.txt "xcbm5x0 "$(XCBM5X0HEAD)"" \
		\
		> results/cbm5x0.html
		
	./maketable  --omit-clean --html --list cbm610-testlist.in \
		--ranking "<small><hr>%d%%<br>%d of %d<small>" \
		--results results/xcbm2-$(XCBM2HEAD)-result.txt "xcbm2 "$(XCBM2HEAD)"" \
		--results results/kernal64cbm2-$(KERNAL64CBM2LAST)-result.txt "kernal64 (cbm2) "$(KERNAL64CBM2LASTSTRING)"" \
		\
		> results/cbm2.html
		
	./maketable  --omit-clean --html --list vsid-testlist.in \
		--ranking "<small><hr>%d%%<br>%d of %d<small>" \
		--results results/vsid-$(VSIDHEAD)-result.txt "vsid "$(VSIDHEAD)"" \
		\
		> results/sid.html
		
# use with something like "make resultswiki | xclip -selection clipboard"
		
resultswiki: maketable
	@echo "== Results =="
	@echo "=== C64 ==="
	./maketable --omit-clean --wiki --list c64-testlist.in \
		--ranking "{{Progress|%d|%d|%d|}}" \
		--results results/denise-$(DENISELAST)-result.txt "denise "$(DENISELASTSTRING)"" \
		--results results/x64sc-$(X64SCHEAD)-result.txt "x64sc "$(X64SCHEAD)"" \
		--results results/z64kc64-$(Z64KC64LAST)-result.txt "z64k (c64) "$(Z64KC64LASTSTRING)"" \
		--results results/chameleon-$(CHAMCARTRIDGELAST)-cartridge-result.txt "TC64 "$(CHAMCARTRIDGELAST)" (cartridge)" \
		--results results/hoxs64-$(HOXS64LAST)-result.txt "hoxs64 "$(HOXS64LASTSTRING)"" \
		--results results/z64kc128c64-$(Z64KC128C64LAST)-result.txt "z64k (c128/c64) "$(Z64KC128C64LASTSTRING)"" \
		--results results/x128c64-$(X128C64HEAD)-result.txt "x128 (c64) "$(X128C64HEAD)"" \
		--results results/x64-$(X64HEAD)-result.txt "x64 "$(X64HEAD)"" \
		--results results/u64-$(U64LAST)-result.txt "U64 "$(U64LASTSTRING)" (PAL)" \
		--results results/micro64-$(MICRO64LAST)-result.txt "micro64 "$(MICRO64LASTSTRING)"" \
		--results results/chameleon-$(CHAMSTANDALONELAST)-standalone-result.txt "TC64 "$(CHAMSTANDALONELAST)" (standalone)" \
		--results results/kernal64c128c64-$(KERNAL64C128C64LAST)-result.txt "kernal64 (c128/c64) "$(KERNAL64C128C64LASTSTRING)"" \
		--results results/kernal64c64-$(KERNAL64C64LAST)-result.txt "kernal64 (c64) "$(KERNAL64C64LASTSTRING)"" \
		--results results/yace-$(YACEHEAD)-result.txt "yace "$(YACEHEAD)"" \
		--results results/emu64-$(EMU64HEAD)-result.txt "emu64 "$(EMU64HEAD)""
	@echo "=== VIC20 ==="
	./maketable --omit-clean --wiki --list vic20-testlist.in \
		--ranking "{{Progress|%d|%d|%d|}}" \
		--results results/xvic-$(XVICHEAD)-result.txt "xvic "$(XVICHEAD)"" \
		--results results/z64kvic20-$(Z64KVIC20LAST)-result.txt "z64k (vic20) "$(Z64KVIC20LASTSTRING)"" \
		--results results/cham20-$(CHAM20LAST)-result.txt "cham20 "$(CHAM20LAST)""
	@echo "=== C128 ==="
	./maketable --omit-clean --wiki --list c128-testlist.in \
		--ranking "{{Progress|%d|%d|%d|}}" \
		--results results/z64kc128-$(Z64KC128LAST)-result.txt "z64k (c128) "$(Z64KC128LASTSTRING)"" \
		--results results/x128-$(X128HEAD)-result.txt "x128 "$(X128HEAD)"" \
		--results results/kernal64c128c128-$(KERNAL64C128C128LAST)-result.txt "kernal64 (c128) "$(KERNAL64C128C128LASTSTRING)""
	@echo "=== PLUS4 ==="
	./maketable --omit-clean --wiki --list plus4-testlist.in \
		--ranking "{{Progress|%d|%d|%d|}}" \
		--results results/xplus4-$(XPLUS4HEAD)-result.txt "xplus4 "$(XPLUS4HEAD)""
	@echo "=== PET ==="
	./maketable --omit-clean --wiki --list pet-testlist.in \
		--ranking "{{Progress|%d|%d|%d|}}" \
		--results results/xpet-$(XPETHEAD)-result.txt "xpet "$(XPETHEAD)""
	@echo "=== DTV ==="
	./maketable --omit-clean --wiki --list dtv-testlist.in \
		--ranking "{{Progress|%d|%d|%d|}}" \
		--results results/x64dtv-$(X64DTVHEAD)-result.txt "x64dtv "$(X64DTVHEAD)""
	@echo "=== SCPU ==="
	./maketable --omit-clean --wiki --list scpu-testlist.in \
		--ranking "{{Progress|%d|%d|%d|}}" \
		--results results/kernal64scpu64-$(KERNAL64SCPU64LAST)-result.txt "kernal64 (scpu64) "$(KERNAL64SCPU64LASTSTRING)"" \
		--results results/xscpu64-$(XSCPU64HEAD)-result.txt "xscpu64 "$(XSCPU64HEAD)""
	@echo "=== CBM5x0 ==="
	./maketable --omit-clean --wiki --list cbm510-testlist.in \
		--ranking "{{Progress|%d|%d|%d|}}" \
		--results results/xcbm5x0-$(XCBM5X0HEAD)-result.txt "xcbm5x0 "$(XCBM5X0HEAD)""
	@echo "=== CBM2 ==="
	./maketable --omit-clean --wiki --list cbm610-testlist.in \
		--ranking "{{Progress|%d|%d|%d|}}" \
		--results results/xcbm2-$(XCBM2HEAD)-result.txt "xcbm2 "$(XCBM2HEAD)""
	@echo "=== SID ==="
	./maketable --omit-clean --wiki --list vsid-testlist.in \
		--ranking "{{Progress|%d|%d|%d|}}" \
		--results results/vsid-$(VSIDHEAD)-result.txt "vsid "$(VSIDHEAD)""

################################################################################

.PHONY: resultsx64
resultsx64: maketable
	OPTS=`ls -r results/x64-r*-result.txt | sed 's/\(.*\)-\(r[0-9]*\)-result.txt/--results \1-\2-result.txt x64-\2/g'` ; \
	./maketable --omit-two-ok --omit-clean --html --list c64-testlist.in \
		--percentages "<small><hr>%d%%<br>%d of %d<small>" \
		$$OPTS \
		> results/x64.html

.PHONY: resultsx64sc
resultsx64sc: maketable
	OPTS=`ls -r results/x64sc-r*-result.txt | sed 's/\(.*\)-\(r[0-9]*\)-result.txt/--results \1-\2-result.txt x64sc-\2/g'` ; \
	./maketable --omit-two-ok --omit-clean --html --list c64-testlist.in \
		--percentages "<small><hr>%d%%<br>%d of %d<small>" \
		$$OPTS \
		> results/x64sc.html

.PHONY: resultsx128
resultsx128: maketable
	OPTS=`ls -r results/x128-r*-result.txt | sed 's/\(.*\)-\(r[0-9]*\)-result.txt/--results \1-\2-result.txt x128-\2/g'` ; \
	./maketable --omit-two-ok --omit-clean --html --list c128-testlist.in \
		--percentages "<small><hr>%d%%<br>%d of %d<small>" \
		$$OPTS \
		> results/x128.html

.PHONY: resultsx128c64
resultsx128c64: maketable
	OPTS=`ls -r results/x128c64-r*-result.txt | sed 's/\(.*\)-\(r[0-9]*\)-result.txt/--results \1-\2-result.txt x128c64-\2/g'` ; \
	./maketable --omit-two-ok --omit-clean --html --list c64-testlist.in \
		--percentages "<small><hr>%d%%<br>%d of %d<small>" \
		$$OPTS \
		> results/x128c64.html

.PHONY: resultsxcbm2
resultsxcbm2: maketable
	OPTS=`ls -r results/xcbm2-r*-result.txt | sed 's/\(.*\)-\(r[0-9]*\)-result.txt/--results \1-\2-result.txt xcbm2-\2/g'` ; \
	./maketable --omit-two-ok --omit-clean --html --list cbm610-testlist.in \
		--percentages "<small><hr>%d%%<br>%d of %d<small>" \
		$$OPTS \
		> results/xcbm2.html

.PHONY: resultsxcbm5x0
resultsxcbm5x0: maketable
	OPTS=`ls -r results/xcbm5x0-r*-result.txt | sed 's/\(.*\)-\(r[0-9]*\)-result.txt/--results \1-\2-result.txt xcbm5x0-\2/g'` ; \
	./maketable --omit-two-ok --omit-clean --html --list cbm510-testlist.in \
		--percentages "<small><hr>%d%%<br>%d of %d<small>" \
		$$OPTS \
		> results/xcbm5x0.html

.PHONY: resultsx64dtv
resultsx64dtv: maketable
	OPTS=`ls -r results/x64dtv-r*-result.txt | sed 's/\(.*\)-\(r[0-9]*\)-result.txt/--results \1-\2-result.txt x64dtv-\2/g'` ; \
	./maketable --omit-two-ok --omit-clean --html --list dtv-testlist.in \
		--percentages "<small><hr>%d%%<br>%d of %d<small>" \
		$$OPTS \
		> results/x64dtv.html

.PHONY: resultsxpet
resultsxpet: maketable
	OPTS=`ls -r results/xpet-r*-result.txt | sed 's/\(.*\)-\(r[0-9]*\)-result.txt/--results \1-\2-result.txt xpet-\2/g'` ; \
	./maketable --omit-two-ok --omit-clean --html --list pet-testlist.in \
		--percentages "<small><hr>%d%%<br>%d of %d<small>" \
		$$OPTS \
		> results/xpet.html

.PHONY: resultsxplus4
resultsxplus4: maketable
	OPTS=`ls -r results/xplus4-r*-result.txt | sed 's/\(.*\)-\(r[0-9]*\)-result.txt/--results \1-\2-result.txt xplus4-\2/g'` ; \
	./maketable --omit-two-ok --omit-clean --html --list plus4-testlist.in \
		--percentages "<small><hr>%d%%<br>%d of %d<small>" \
		$$OPTS \
		> results/xplus4.html

.PHONY: resultsxscpu64
resultsxscpu64: maketable
	OPTS=`ls -r results/xscpu64-r*-result.txt | sed 's/\(.*\)-\(r[0-9]*\)-result.txt/--results \1-\2-result.txt xscpu64-\2/g'` ; \
	./maketable --omit-two-ok --omit-clean --html --list scpu-testlist.in \
		--percentages "<small><hr>%d%%<br>%d of %d<small>" \
		$$OPTS \
		> results/xscpu64.html

.PHONY: resultsxvic
resultsxvic: maketable
	OPTS=`ls -r results/xvic-r*-result.txt | sed 's/\(.*\)-\(r[0-9]*\)-result.txt/--results \1-\2-result.txt xvic-\2/g'` ; \
	./maketable --omit-two-ok --omit-clean --html --list vic20-testlist.in \
		--percentages "<small><hr>%d%%<br>%d of %d<small>" \
		$$OPTS \
		> results/xvic.html

.PHONY: resultsvsid
resultsvsid: maketable
	OPTS=`ls -r results/vsid-r*-result.txt | sed 's/\(.*\)-\(r[0-9]*\)-result.txt/--results \1-\2-result.txt vsid-\2/g'` ; \
	./maketable --omit-two-ok --omit-clean --html --list vsid-testlist.in \
		--percentages "<small><hr>%d%%<br>%d of %d<small>" \
		$$OPTS \
		> results/vsid.html

################################################################################

#results/emu64-result.txt

.PHONY: resultsz64kc64
resultsz64kc64: maketable z64kc64-testlist.txt
	./maketable --omit-two-ok --omit-clean --html --list z64kc64-testlist.txt \
		--percentages "<small><hr>%d%%<br>%d of %d<small>" \
		--results results/x64sc-$(X64SCHEAD)-result.txt "x64sc "$(X64SCHEAD)"" \
		--firstcolisref "<small><b>fails on VICE</b></small>" \
		--results results/z64kc64-$(Z64KC64LAST)-result.txt "z64kc64 "$(Z64KC64LASTSTRING)"" \
		--results results/z64kc64-20220130-result.txt "z64kc64 30 January 2022" \
		--results results/z64kc64-20201230-result.txt "z64kc64 30 December 2020" \
		--results results/z64kc64-20201224-result.txt "z64kc64 24 December 2020" \
		--results results/z64kc64-1_2-result.txt "z64kc64 1.2" \
		--results results/z64kc64-20181202-result.txt "z64kc64 2nd December 2018" \
		\
		> results/z64kc64.html

.PHONY: resultsz64kc128
resultsz64kc128: maketable z64kc128-testlist.txt
	./maketable --omit-two-ok --omit-clean --html --list z64kc128-testlist.txt \
		--percentages "<small><hr>%d%%<br>%d of %d<small>" \
		--results results/x128-$(X128HEAD)-result.txt "x128 "$(X128HEAD)"" \
		--firstcolisref "<small><b>fails on VICE</b></small>" \
		--results results/z64kc128-$(Z64KC128LAST)-result.txt "z64kc128 "$(Z64KC128LASTSTRING)"" \
		--results results/z64kc128-20220130-result.txt "z64kc128 30 January 2022" \
		--results results/z64kc128-20201230-result.txt "z64kc128 30 December 2020" \
		--results results/z64kc128-20201217-result.txt "z64kc128 17 December 2020" \
		--results results/z64kc128-1_2-result.txt "z64kc128 1.2" \
		--results results/z64kc128-20181202-result.txt "z64kc128 20181202" \
		\
		> results/z64kc128.html

.PHONY: resultsz64kc128c64
resultsz64kc128c64: maketable z64kc128c64-testlist.txt
	./maketable --omit-two-ok --omit-clean --html --list z64kc128c64-testlist.txt \
		--percentages "<small><hr>%d%%<br>%d of %d<small>" \
		--results results/x64sc-$(X64SCHEAD)-result.txt "x64sc "$(X64SCHEAD)"" \
		--firstcolisref "<small><b>fails on VICE</b></small>" \
		--results results/z64kc128c64-$(Z64KC128C64LAST)-result.txt "z64kc128c64 "$(Z64KC128C64LASTSTRING)"" \
		--results results/z64kc128c64-20220130-result.txt "z64kc128c64 30 January 2022" \
		--results results/z64kc128c64-20201230-result.txt "z64kc128c64 30 December 2020" \
		--results results/z64kc128c64-20201217-result.txt "z64kc128c64 17 December 2020" \
		--results results/z64kc128c64-1_2-result.txt "z64kc128c64 1.2" \
		--results results/z64kc128c64-20181202-result.txt "z64kc128c64 20181202" \
		\
		> results/z64kc128c64.html

.PHONY: resultsz64kvic20
resultsz64kvic20: maketable z64kvic20-testlist.txt
	./maketable --omit-two-ok --omit-clean --html --list z64kvic20-testlist.txt \
		--percentages "<small><hr>%d%%<br>%d of %d<small>" \
		--results results/xvic-$(XVICHEAD)-result.txt "xvic "$(XVICHEAD)"" \
		--firstcolisref "<small><b>fails on VICE</b></small>" \
		--results results/z64kvic20-$(Z64KVIC20LAST)-result.txt "z64kvic20 "$(Z64KVIC20LASTSTRING)"" \
		--results results/z64kvic20-20220130-result.txt "z64kvic20 30 January 2022" \
		--results results/z64kvic20-20201217-result.txt "z64kvic20 17 December 2020" \
		--results results/z64kvic20-1_2-result.txt "z64kvic20 1.2" \
		--results results/z64kvic20-20181202-result.txt "z64kvic20 20181202" \
		\
		> results/z64kvic20.html
		
.PHONY: resultshoxs64
resultshoxs64: maketable hoxs64-testlist.txt
	./maketable --omit-two-ok --omit-clean --html --list hoxs64-testlist.txt \
		--percentages "<small><hr>%d%%<br>%d of %d<small>" \
		--results results/x64sc-$(X64SCHEAD)-result.txt "x64sc "$(X64SCHEAD)"" \
		--firstcolisref "<small><b>fails on VICE</b></small>" \
		--results results/hoxs64-$(HOXS64LAST)-result.txt "hoxs64 "$(HOXS64LASTSTRING)"" \
		--results results/hoxs64-1-1-0-5-result.txt "hoxs64 1.1.0.5" \
		--results results/hoxs64-1-1-0-3-result.txt "hoxs64 1.1.0.32" \
		--results results/hoxs64-1-0-21-2-result.txt "hoxs64 1.0.21.2" \
		--results results/hoxs64-1-0-21-0-result.txt "hoxs64 1.0.21.0" \
		--results results/hoxs64-1-0-16-0-result.txt "hoxs64 1.0.16.0" \
		\
		> results/hoxs64.html

.PHONY: resultsdenise
resultsdenise: maketable denise-testlist.txt
	./maketable --omit-two-ok  --omit-clean --html --list denise-testlist.txt \
		--percentages "<small><hr>%d%%<br>%d of %d<small>" \
		--results results/x64sc-$(X64SCHEAD)-result.txt "x64sc "$(X64SCHEAD)"" \
		--firstcolisref "<small><b>fails on VICE</b></small>" \
		--results results/denise-$(DENISELAST)-result.txt "denise "$(DENISELASTSTRING)"" \
		--results results/denise-20220316-result.txt "git 16.03.2022" \
		--results results/denise-20201223-result.txt "git 23.12.2020" \
		--results results/denise-1-0-8-result.txt "denise 1.0.8" \
		--results results/denise-20200110-result.txt "denise 20200110" \
		--results results/denise-20191012-result.txt "denise 20191012" \
		--results results/denise-1-0-5-result.txt "denise 1.0.5" \
		\
		> results/denise.html

.PHONY: resultsmicro64
resultsmicro64: maketable micro64-testlist.txt
	./maketable --omit-two-ok --omit-clean --html --list micro64-testlist.txt \
		--percentages "<small><hr>%d%%<br>%d of %d<small>" \
		--results results/x64sc-$(X64SCHEAD)-result.txt "x64sc "$(X64SCHEAD)"" \
		--firstcolisref "<small><b>fails on VICE</b></small>" \
		--results results/micro64-$(MICRO64LAST)-result.txt "micro64 "$(MICRO64LASTSTRING)"" \
		--results results/micro64-20180314-result.txt "micro64 20180314" \
		\
		> results/micro64.html
		
.PHONY: resultsyace
resultsyace: maketable yace-testlist.txt
	./maketable --omit-two-ok --omit-clean --html --list yace-testlist.txt \
		--percentages "<small><hr>%d%%<br>%d of %d<small>" \
		--results results/x64sc-$(X64SCHEAD)-result.txt "x64sc "$(X64SCHEAD)"" \
		--firstcolisref "<small><b>fails on VICE</b></small>" \
		--results results/yace-$(YACEHEAD)-result.txt "yace "$(YACEHEAD)"" \
		\
		> results/yace.html
		
.PHONY: resultsemu64
resultsemu64: maketable emu64-testlist.txt
	./maketable --omit-two-ok --omit-clean --html --list emu64-testlist.txt \
		--percentages "<small><hr>%d%%<br>%d of %d<small>" \
		--results results/x64sc-$(X64SCHEAD)-result.txt "x64sc "$(X64SCHEAD)"" \
		--firstcolisref "<small><b>fails on VICE</b></small>" \
		--results results/emu64-$(EMU64HEAD)-result.txt "emu64 "$(EMU64HEAD)"" \
		--results results/emu64-20220320-result.txt "emu64 20220320" \
		--results results/emu64-20191025-result.txt "emu64 20191025" \
		\
		> results/emu64.html
		
.PHONY: resultskernal64c64
resultskernal64c64: maketable kernal64c64-testlist.txt
	./maketable --omit-two-ok --omit-clean --html --list kernal64c64-testlist.txt \
		--percentages "<small><hr>%d%%<br>%d of %d<small>" \
		--results results/x64sc-$(X64SCHEAD)-result.txt "x64sc "$(X64SCHEAD)"" \
		--firstcolisref "<small><b>fails on VICE</b></small>" \
		--results results/kernal64c64-$(KERNAL64C64LAST)-result.txt "kernal64 (c64) "$(KERNAL64C64LASTSTRING)"" \
		--results results/kernal64c64-1-7-3_b13-result.txt "kernal64 (c64) 1.7.3_b13" \
		--results results/kernal64c64-1-7-0_b15-result.txt "kernal64 (c64) 1.7.0_b15" \
		--results results/kernal64c64-1-6-2_b8-result.txt "kernal64 (c64) 1.6.2_b8" \
		\
		> results/kernal64c64.html
		
.PHONY: resultskernal64c128c64
resultskernal64c128c64: maketable kernal64c128c64-testlist.txt
	./maketable --omit-two-ok --omit-clean --html --list kernal64c128c64-testlist.txt \
		--percentages "<small><hr>%d%%<br>%d of %d<small>" \
		--results results/x64sc-$(X64SCHEAD)-result.txt "x64sc "$(X64SCHEAD)"" \
		--firstcolisref "<small><b>fails on VICE</b></small>" \
		--results results/kernal64c128c64-$(KERNAL64C128C64LAST)-result.txt "Kernal64 (c128/64) "$(KERNAL64C128C64LASTSTRING)"" \
		--results results/kernal64c128c64-1-7-3_b13-result.txt "Kernal64 (c128/64) 1.7.3_b13" \
		--results results/kernal64c128c64-1-7-0_b15-result.txt "Kernal64 (c128/64) 1.7.0_b15" \
		--results results/kernal64c128c64-1-6-2_b8-result.txt "Kernal64 (c128/64) 1.6.2_b8" \
		\
		> results/kernal64c128c64.html

.PHONY: resultskernal64c128c128
resultskernal64c128c128: maketable kernal64c128c128-testlist.txt
	./maketable --omit-two-ok --omit-clean --html --list kernal64c128c128-testlist.txt \
		--percentages "<small><hr>%d%%<br>%d of %d<small>" \
		--results results/kernal64c128c128-$(KERNAL64C128C128LAST)-result.txt "Kernal64 (c128) "$(KERNAL64C128C128LASTSTRING)"" \
		--results results/kernal64c128c128-1-7-3_b13-result.txt "Kernal64 (c128) 1.7.3_b13" \
		--results results/kernal64c128c128-1-7-0_b15-result.txt "Kernal64 (c128) 1.7.0_b15" \
		--results results/kernal64c128c128-1-6-2_b8-result.txt "Kernal64 (c128) 1.6.2_b8" \
		\
		> results/kernal64c128c128.html

.PHONY: resultskernal64scpu64
resultskernal64scpu64: maketable kernal64scpu64-testlist.txt
	./maketable --omit-two-ok --omit-clean --html --list kernal64scpu64-testlist.txt \
		--percentages "<small><hr>%d%%<br>%d of %d<small>" \
		--results results/kernal64scpu64-$(KERNAL64SCPU64LAST)-result.txt "kernal64 (scpu) "$(KERNAL64SCPU64LASTSTRING)"" \
		--results results/kernal64scpu64-1-7-3_b13-result.txt "kernal64 (scpu) 1.7.3_b13" \
		--results results/kernal64scpu64-1-7-0_b15-result.txt "kernal64 (scpu) 1.7.0_b15" \
		--results results/kernal64scpu64-1-6-2_b8-result.txt "kernal64 (scpu) 1.6.2_b8" \
		\
		> results/kernal64scpu64.html

################################################################################
		
.PHONY: resultscham
resultscham: maketable chameleon-testlist.txt 
	./maketable --omit-two-ok --omit-clean --filter-ntscold --html --list chameleon-testlist.txt \
		--percentages "<small><hr>%d%%<br>%d of %d<small>" \
		--results results/x64sc-$(X64SCHEAD)-result.txt "x64sc "$(X64SCHEAD)"" \
		--firstcolisref "<small><b>fails on VICE</b></small>" \
		--warnvicefail "<small><b>fails on VICE</b></small>" \
		--warnvicfetch "<small><b>VIC may be wrong!</b></small>" \
		--results results/chameleon-$(CHAMSTANDALONELAST)-standalone-result.txt "TC64 "$(CHAMSTANDALONELAST) \
		--results results/chameleon-9l-standalone-result.txt "TC64 9l" \
		--results results/chameleon-9k-standalone-result.txt "TC64 9k" \
		--results results/chameleon-9j-standalone-result.txt "TC64 9j" \
		--results results/chameleon-9i-standalone-result.txt "TC64 9i" \
		--results results/chameleon-9h-result.txt "TC64 9h" \
		\
		> results/chameleon.html

	./maketable --omit-two-ok --omit-clean --filter-ntscold --html --list chameleon-testlist.txt \
		--percentages "<small><hr>%d%%<br>%d of %d<small>" \
		--results results/x64sc-$(X64SCHEAD)-result.txt "x64sc "$(X64SCHEAD)"" \
		--firstcolisref "<small><b>fails on VICE</b></small>" \
		--warnvicefail "<small><b>fails on VICE</b></small>" \
		--warnvicfetch "<small><b>VIC may be wrong!</b></small>" \
		--results results/chameleon-$(CHAMCARTRIDGELAST)-cartridge-result.txt "TC64 "$(CHAMCARTRIDGELAST) \
		--results results/chameleon-9j-cartridge-result.txt "TC64 9j" \
		--results results/chameleon-9i-cartridge-result.txt "TC64 9i" \
		\
		> results/chameleon-cartridge.html

# use with something like "make resultschamwiki | xclip -selection clipboard"

.PHONY: resultschamwiki
resultschamwiki: maketable chameleon-testlist.txt
	@echo "=== Results ==="
	./maketable --omit-two-ok --omit-clean --filter-ntscold --wiki --list chameleon-testlist.txt \
		--percentages "{{Progress|%d|%d|%d|}}" \
		--results results/x64sc-$(X64SCHEAD)-result.txt "x64sc "$(X64SCHEAD)"" \
		--firstcolisref "{{BREAKSEMU}}" \
		--warnvicefail "{{BREAKSEMU}}" \
		--warnvicfetch "{{BREAKSVIC}}" \
		--results results/chameleon-$(CHAMSTANDALONELAST)-standalone-result.txt "TC64 "$(CHAMSTANDALONELAST)" (standalone)" \
		--results results/chameleon-9l-standalone-result.txt "TC64 9l (standalone)" \
		--results results/chameleon-9k-standalone-result.txt "TC64 9k (standalone)" \
		--results results/chameleon-9j-standalone-result.txt "TC64 9j (standalone)" \
		--results results/chameleon-9i-standalone-result.txt "TC64 9i (standalone)" \
		--results results/chameleon-9h-result.txt "TC64 9h (standalone)"

	./maketable --omit-two-ok --omit-clean --filter-ntscold --wiki --list chameleon-testlist.txt \
		--percentages "{{Progress|%d|%d|%d|}}" \
		--results results/x64sc-$(X64SCHEAD)-result.txt "x64sc "$(X64SCHEAD)"" \
		--firstcolisref "{{BREAKSEMU}}" \
		--warnvicefail "{{BREAKSEMU}}" \
		--warnvicfetch "{{BREAKSVIC}}" \
		--results results/chameleon-$(CHAMCARTRIDGELAST)-cartridge-result.txt "TC64 "$(CHAMCARTRIDGELAST)" (cartridge)" \
		--results results/chameleon-9j-cartridge-result.txt "TC64 9j (cartridge)" \
		--results results/chameleon-9i-cartridge-result.txt "TC64 9i (cartridge)"

.PHONY: resultscham20
resultscham20: maketable cham20-testlist.txt 
	./maketable --omit-two-ok --omit-clean --filter-ntscold --html --list cham20-testlist.txt \
		--percentages "<small><hr>%d%%<br>%d of %d<small>" \
		--results results/xvic-$(XVICHEAD)-result.txt "xvic "$(XVICHEAD)"" \
		--firstcolisref "<small><b>fails on VICE</b></small>" \
		--warnvicefail "<small><b>fails on VICE</b></small>" \
		--warnvicfetch "<small><b>VIC may be wrong!</b></small>" \
		--results results/cham20-$(CHAM20LAST)-result.txt "cham20 "$(CHAM20LAST)"" \
		--results results/cham20-20150818-result.txt "cham20 20150818" \
		\
		> results/cham20.html

# use with something like "make resultscham20wiki | xclip -selection clipboard"
		
.PHONY: resultscham20wiki
resultscham20wiki: maketable cham20-testlist.txt 
	./maketable --filter-ntscold --wiki --list cham20-testlist.txt \
		--percentages "{{Progress|%d|%d|%d|}}" \
		--results results/xvic-$(XVICHEAD)-result.txt "xvic "$(XVICHEAD)"" \
		--firstcolisref "{{BREAKSEMU}}" \
		--warnvicefail "{{BREAKSEMU}}" \
		--warnvicfetch "{{BREAKSVIC}}" \
		--results results/cham20-$(CHAM20LAST)-result.txt "cham20 "$(CHAM20LAST)"" \
		--results results/cham20-20150818-result.txt "cham20 20150818"
		
################################################################################
		
.PHONY: resultsu64
resultsu64: maketable u64-testlist.txt 
	./maketable --omit-two-ok --omit-clean --filter-ntscold --html --list u64-testlist.txt \
		--percentages "<small><hr>%d%%<br>%d of %d<small>" \
		--results results/x64sc-$(X64SCHEAD)-result.txt "x64sc "$(X64SCHEAD)"" \
		--firstcolisref "<small><b>fails on VICE</b></small>" \
		--warnvicefail "<small><b>fails on VICE</b></small>" \
		--results results/u64-10c-result.txt "U64 (1.0c)" \
		--results results/u64-118-pal-result.txt "U64 PAL (1.18)" \
		--results results/u64-118-ntsc-result.txt "U64 NTSC (1.18)" \
		--results results/u64-118-result.txt "U64 (1.18)" \
		--results results/u64-121-pal-result.txt "U64 PAL (1.21)" \
		--results results/u64-124-pal-result.txt "U64 PAL (1.24)" \
		--results results/u64-128-result.txt "U64 PAL (1.28)" \
		--results results/u64-133-result.txt "U64 PAL (1.33)" \
		--results results/u64-137-result.txt "U64 PAL (1.37)" \
		--results results/u64-$(U64LAST)-result.txt "U64 "$(U64LASTSTRING)" (PAL)" \
		\
		> results/u64.html
		
################################################################################
.PHONY: allresults
allresults: results resultsx64 resultsx64sc resultsx128 resultsx128c64 resultsxcbm2 resultsxcbm5x0 resultsx64dtv \
		resultsxpet resultsxplus4 resultsxscpu64 resultsxvic resultsvsid \
		resultsz64kc64 resultsz64kc128 resultsz64kc128c64 resultsz64kvic20 \
		resultshoxs64 resultsdenise resultsmicro64 resultsyace resultsemu64 \
		resultskernal64c64 resultskernal64c128c64 resultskernal64c128c128 resultskernal64scpu64 \
		resultscham resultscham20 resultsu64 

.PHONY: clean zap
clean:
	$(RM) maketable
	$(RM) cmpscreens

zap: clean
	$(RM) *-result.txt
	$(RM) $(TESTLISTS)

