
.SILENT:

# override with "make EMUDIR=foo"
EMUDIR:=../../../trunk/vice/src
#$(info $$EMUDIR is [${EMUDIR}])

EMU=$(EMUDIR)/x128 -default -minimize
$(info using EMU: [${EMU}])

all: disasm

z80cx-disasm.txt: z80cx.prg
	echo "logname \"z80cx-disasm.txt\"" > disasmcmds.txt
	echo "l \"z80cx.prg\" 0" >> disasmcmds.txt
	echo "cpu z80" >> disasmcmds.txt
	echo "log on" >> disasmcmds.txt
	echo "d 1c10 2cdc" >> disasmcmds.txt
	echo "log off" >> disasmcmds.txt
	echo "quit" >> disasmcmds.txt
	$(RM) z80cx-disasm.txt
	$(EMU) -moncommands disasmcmds.txt > vicelog

z80cx-displain.txt: z80cx-disasm.txt
	cat z80cx-disasm.txt | sed 's:^.....................::g' > z80cx-displain.txt

z80cx-plain.txt: z80cx-expected.txt
	cat z80cx-expected.txt | \
		sed -e 's/;.*//g' | \
		sed -e 's/ *$$//g' \
		> z80cx-plain.txt
	
disasm: z80cx-displain.txt z80cx-plain.txt
	diff --suppress-common-lines --side-by-side --ignore-all-space z80cx-displain.txt z80cx-plain.txt

################################################################################

clean:
	@$(RM)	z80cx-displain.txt z80cx-plain.txt z80cx-disasm.txt
	@$(RM)	vicelog disasmcmds.txt
