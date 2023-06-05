
.SILENT:

# override with "make EMUDIR=foo"
EMUDIR:=../../../trunk/vice/src
#$(info $$EMUDIR is [${EMUDIR}])

EMU=$(EMUDIR)/x64sc -default -minimize
$(info using EMU: [${EMU}])

all: testlegal testundocs

################################################################################
# check all undocs. we can only check the disassembler, as the assembler will
# not know the difference between various types of JAMs and NOOPs

allundocs.bin: allundocs.txt
	acme --setpc 4096 -f plain -o allundocs.bin allundocs.txt

undocsdisasm.txt: allundocs.bin
	echo "logname \"undocsdisasm.txt\"" > disasmcmds.txt
	echo "bl \"allundocs.bin\" 0 1000" >> disasmcmds.txt
	echo "log on" >> disasmcmds.txt
	echo "d 1000 10e2" >> disasmcmds.txt
	echo "log off" >> disasmcmds.txt
	echo "quit" >> disasmcmds.txt
	$(RM) undocsdisasm.txt
	$(EMU) -moncommands disasmcmds.txt > vicelog

allundocs0.txt: allundocs.txt
	cat allundocs.txt | sed 's:^.*;::g' > allundocs0.txt

allundocs1.txt: undocsdisasm.txt
	cat undocsdisasm.txt | sed 's:^...................::g' > allundocs1.txt

testundocs0: allundocs0.txt allundocs1.txt
	diff --suppress-common-lines --side-by-side allundocs0.txt allundocs1.txt

################################################################################
# check all undocs that the assembler will assemble back into what we expect

supportedundocs.bin: supportedundocs.txt
	acme --setpc 4096 -f plain -o supportedundocs.bin supportedundocs.txt

supporteddisasm.txt: supportedundocs.bin
	echo "logname \"supporteddisasm.txt\"" > disasmcmds.txt
	echo "bl \"supportedundocs.bin\" 0 1000" >> disasmcmds.txt
	echo "log on" >> disasmcmds.txt
	echo "d 1000 10ab" >> disasmcmds.txt
	echo "log off" >> disasmcmds.txt
	echo "quit" >> disasmcmds.txt
	$(RM) supporteddisasm.txt
	$(EMU) -moncommands disasmcmds.txt > vicelog

supportedundocs0.txt: supportedundocs.txt
	cat supportedundocs.txt | sed 's:^.*;::g' > supportedundocs0.txt

supportedundocs1.txt: supporteddisasm.txt
	cat supporteddisasm.txt | sed 's:^...................::g' > supportedundocs1.txt

testundocs1: supportedundocs0.txt supportedundocs1.txt
	diff --suppress-common-lines --side-by-side supportedundocs0.txt supportedundocs1.txt

supportedundocs2.bin: supportedundocs1.txt
	echo -ne "a 1000 " > disasmcmds.txt
	cat supportedundocs1.txt >> disasmcmds.txt
	echo -ne "\n" >> disasmcmds.txt
	echo "bs \"supportedundocs2.bin\" 0 1000 10ab" >> disasmcmds.txt
	echo "quit" >> disasmcmds.txt
	$(EMU) -moncommands disasmcmds.txt > vicelog
	
testundocs2: supportedundocs.bin supportedundocs2.bin
	diff -q supportedundocs.bin supportedundocs2.bin

testundocs: testundocs0 testundocs1 testundocs2

################################################################################
# check all legal opcodes
	
legalopcodes.bin: legalopcodes.txt
	acme --setpc 4096 -f plain -o legalopcodes.bin legalopcodes.txt
	
legaldisasm.txt: legalopcodes.bin
	echo "logname \"legaldisasm.txt\"" > disasmcmds.txt
	echo "bl \"legalopcodes.bin\" 0 1000" >> disasmcmds.txt
	echo "log on" >> disasmcmds.txt
	echo "d 1000 1140" >> disasmcmds.txt
	echo "log off" >> disasmcmds.txt
	echo "quit" >> disasmcmds.txt
	$(RM) legaldisasm.txt
	$(EMU) -moncommands disasmcmds.txt > vicelog
	
legalopcodes0.txt: legalopcodes.txt
	cat legalopcodes.txt | sed 's:^.*;::g' > legalopcodes0.txt

legalopcodes1.txt: legaldisasm.txt
	cat legaldisasm.txt | sed 's:^...................::g' > legalopcodes1.txt
	
testlegal0: legalopcodes0.txt legalopcodes1.txt
	diff --suppress-common-lines --side-by-side legalopcodes0.txt legalopcodes1.txt

legalopcodes2.txt: legalopcodes1.txt
	cat legalopcodes1.txt | sed 's: A$$::g' > legalopcodes2.txt	

legalopcodes2.bin: legalopcodes2.txt
	acme --setpc 4096 -f plain -o legalopcodes2.bin legalopcodes2.txt
	
testlegal1: legalopcodes.bin legalopcodes2.bin
	diff -q legalopcodes.bin legalopcodes2.bin
	
# strange: we dissemble "ASL A" but the assembler expects "ASL"
legalopcodes3.bin: legalopcodes2.txt
	echo -ne "a 1000 " > disasmcmds.txt
	cat legalopcodes2.txt >> disasmcmds.txt
	echo -ne "\n" >> disasmcmds.txt
	echo "bs \"legalopcodes3.bin\" 0 1000 1140" >> disasmcmds.txt
	echo "quit" >> disasmcmds.txt
	$(EMU) -moncommands disasmcmds.txt > vicelog

testlegal2: legalopcodes.bin legalopcodes3.bin
	diff -q legalopcodes.bin legalopcodes3.bin
	
testlegal: testlegal0 testlegal1 testlegal2

################################################################################

clean:
	@$(RM)	disasmcmds.txt
	@$(RM)	legaldisasm.txt
	@$(RM)	legaldisasm.bin
	@$(RM)	legalopcodes.bin legalopcodes2.bin legalopcodes3.bin
	@$(RM)	legalopcodes0.txt legalopcodes1.txt legalopcodes2.txt

	@$(RM)	allundocs.bin
	@$(RM)	undocsdisasm.txt
	@$(RM)	allundocs0.txt allundocs1.txt

	@$(RM)	supportedundocs.bin supportedundocs2.bin
	@$(RM)	supporteddisasm.txt
	@$(RM)	supportedundocs0.txt supportedundocs1.txt supportedundocs2.txt

	@$(RM)	vicelog
