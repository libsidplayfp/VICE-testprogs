
all: testADSRDelayBug.prg testFlip00toFF.prg testFlipFFto00.prg \
	lft-adsr-test.prg

testADSRDelayBug.prg: testADSRDelayBug.asm
	acme -f cbm -o testADSRDelayBug.prg testADSRDelayBug.asm
testFlip00toFF.prg: testFlip00toFF.asm
	acme -f cbm -o testFlip00toFF.prg testFlip00toFF.asm
testFlipFFto00.prg: testFlipFFto00.asm
	acme -f cbm -o testFlipFFto00.prg testFlipFFto00.asm
lft-adsr-test.prg: lft-adsr-test.asm
	acme -f cbm -o lft-adsr-test.prg lft-adsr-test.asm

