

all: newtest.prg newtest-auto.prg georamtest.prg georamtest-auto.prg \
	georam64.prg georam20.prg georam128.prg

newtest.prg: newtest.asm
	acme -DTESTBENCH=0 -f cbm -o newtest.prg newtest.asm
newtest-auto.prg: newtest.asm
	acme -DTESTBENCH=1 -f cbm -o newtest-auto.prg newtest.asm

georamtest.prg: georamtest.asm
	acme -DTESTBENCH=0 -f cbm -o georamtest.prg georamtest.asm
georamtest-auto.prg: georamtest.asm
	acme -DTESTBENCH=1 -f cbm -o georamtest-auto.prg georamtest.asm

georam64.prg: georam.asm georam.bas
	petcat -w2 -o georam.prg -- georam.bas
	acme -DTARGET=0 -DTESTBENCH=1 -f cbm -o georam64.prg georam.asm
	rm -f georam.prg

georam128.prg: georam.asm georam128.bas
	petcat -w2 -l 1c01 -o georam.prg -- georam128.bas
	acme -DTARGET=1 -DTESTBENCH=1 -f cbm -o georam128.prg georam.asm
	rm -f georam.prg

georam20.prg: georam.asm georam.bas
	petcat -w2 -l 1201 -o georam.prg -- georam.bas
	acme -DTARGET=2 -DTESTBENCH=1 -f cbm -o georam20.prg georam.asm
	rm -f georam.prg

clean:
	rm -f newtest.prg newtest-auto.prg georamtest.prg georamtest-auto.prg
	rm -f georam64.prg georam20.prg georam128.prg
	rm -f georam.prg
