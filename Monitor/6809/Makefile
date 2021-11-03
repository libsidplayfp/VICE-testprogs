
all: testlegal

################################################################################

# remove the address/hexdump from monitor disassembly
disasm0.txt: disasm.txt
	cat disasm.txt | sed 's:^.....................::g' > disasm0.txt

# make a file with monitor commands to reassemble the file
asmcmds.txt: disasm0.txt
	echo -ne "a 1000 " > asmcmds.txt
	cat disasm0.txt >> asmcmds.txt
	echo -n "\n" >> asmcmds.txt
	echo "s \"assembled.prg\" 0 1000 15ff" >> asmcmds.txt
	echo "quit" >> asmcmds.txt

assembled.prg: asmcmds.txt
	xpet -moncommands asmcmds.txt

################################################################################
	
legalopcodes.bin: legalopcodes.txt
	acme --setpc 4096 -f plain -o legalopcodes.bin legalopcodes.txt
	
legaldisasm.txt: legalopcodes.bin
	echo "logname \"legaldisasm.txt\"" > disasmcmds.txt
	echo "bl \"legalopcodes.bin\" 0 1000" >> disasmcmds.txt
	echo "log on" >> disasmcmds.txt
	echo "cpu 6809" >> disasmcmds.txt
	echo "d 1000 563c" >> disasmcmds.txt
	echo "log off" >> disasmcmds.txt
	echo "quit" >> disasmcmds.txt
	$(RM) legaldisasm.txt
	xpet -moncommands disasmcmds.txt
	
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
