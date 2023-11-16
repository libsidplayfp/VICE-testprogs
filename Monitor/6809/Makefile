
.SILENT:

# override with "make EMUDIR=foo"
EMUDIR:=../../../trunk/vice/src
#$(info $$EMUDIR is [${EMUDIR}])

EMU=$(EMUDIR)/xpet -default +sound -warp -model SuperPET -minimize
$(info using EMU: [${EMU}])

all: testlegal

################################################################################
	
legalopcodes.bin: legalopcodes.txt
	acme --setpc 4096 -f plain -o legalopcodes.bin legalopcodes.txt
	
legaldisasm.txt: legalopcodes.bin
	echo "logname \"legaldisasm.txt\"" > disasmcmds.txt
	echo "bl \"legalopcodes.bin\" 0 1000" >> disasmcmds.txt
	echo "log on" >> disasmcmds.txt
	echo "cpu 6809" >> disasmcmds.txt
	echo "bank 6809" >> disasmcmds.txt
	echo "d 1000 7020" >> disasmcmds.txt
	echo "log off" >> disasmcmds.txt
	echo "quit" >> disasmcmds.txt
	$(RM) legaldisasm.txt
	$(EMU) -moncommands disasmcmds.txt > vicelog
	
legalopcodes0.txt: legalopcodes.txt
	cat legalopcodes.txt | sed 's:^.*;::g' > legalopcodes0.txt

legalopcodes1.txt: legaldisasm.txt
	cat legaldisasm.txt | sed 's:^....................::g' | sed 's: /\*.*\*/::g' > legalopcodes1.txt
	
testlegal0: legalopcodes0.txt legalopcodes1.txt
	@echo "showing reference <-> disassembled"
	diff --suppress-common-lines --side-by-side legalopcodes0.txt legalopcodes1.txt

#legalopcodes2.txt: legalopcodes1.txt
#	cat legalopcodes1.txt | sed 's: A$$::g' > legalopcodes2.txt	

# we dont have an external 6809 assembler atm
#legalopcodes2.bin: legalopcodes2.txt
#	acme --setpc 4096 -f plain -o legalopcodes2.bin legalopcodes2.txt
#	
#testlegal1: legalopcodes.bin legalopcodes2.bin
#	diff -s legalopcodes.bin legalopcodes2.bin

# somehow assembling 6809 doesnt work at all
legalopcodes3.bin: legalopcodes1.txt
	echo "logname \"disasmlog.txt\"" > disasmcmds.txt
	echo "log on" >> disasmcmds.txt
	echo "cpu 6809" >> disasmcmds.txt
	echo "bank 6809" >> disasmcmds.txt
	echo "z 100000" >> disasmcmds.txt
	echo -ne "a 1000 " >> disasmcmds.txt
	cat legalopcodes1.txt >> disasmcmds.txt
	echo -ne "\n" >> disasmcmds.txt
	echo "cpu 6809" >> disasmcmds.txt
	echo "bank 6809" >> disasmcmds.txt
	echo "bs \"legalopcodes3.bin\" 0 1000 563c" >> disasmcmds.txt
	echo "log off" >> disasmcmds.txt
#	$(EMU) -moncommands disasmcmds.txt
#	$(EMU)
	echo "quit" >> disasmcmds.txt
	$(RM) disasmlog.txt
	$(EMU) -moncommands disasmcmds.txt > vicelog

testlegal2: legalopcodes.bin legalopcodes3.bin
	diff -q legalopcodes.bin legalopcodes3.bin ; \
		head -50 disasmlog.txt

testlegal: testlegal0 testlegal2

################################################################################

clean:
	@$(RM)	disasmcmds.txt
	@$(RM)	legaldisasm.txt
	@$(RM)	legaldisasm.bin
	@$(RM)	legalopcodes.bin legalopcodes2.bin legalopcodes3.bin
	@$(RM)	legalopcodes0.txt legalopcodes1.txt legalopcodes2.txt

	@$(RM)	vicelog
