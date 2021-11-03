
EMU=x64sc -default -minimize

all: testlegal testundocs

################################################################################

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

testundocs: testundocs0

################################################################################
	
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
	diff -s legalopcodes.bin legalopcodes2.bin
	
testlegal: testlegal0 testlegal1

################################################################################

clean:
	$(RM)	disasmcmds.txt
	$(RM)	legaldisasm.txt
	$(RM)	legaldisasm.bin
	$(RM)	legalopcodes.bin legalopcodes2.bin
	$(RM)	legalopcodes0.txt legalopcodes1.txt legalopcodes2.txt

	$(RM)	allundocs.bin
	$(RM)	undocsdisasm.txt
	$(RM)	allundocs0.txt allundocs1.txt
	
	$(RM)	vicelog
