
all: progs disk

progs: 	xfertiming-toc64.prg xfertiming-toreu.prg xfertiming-swap.prg xfertiming-swap2.prg xfertiming-cmp.prg

xfertiming-toc64.prg: xfertiming.asm
	acme -DTYPE=1 -f cbm -o xfertiming-toc64.prg xfertiming.asm
xfertiming-toreu.prg: xfertiming2.asm
	acme -DTYPE=1 -f cbm -o xfertiming-toreu.prg xfertiming2.asm
xfertiming-swap.prg: xfertiming.asm
	acme -DTYPE=2 -f cbm -o xfertiming-swap.prg xfertiming.asm
xfertiming-swap2.prg: xfertiming3.asm
	acme -f cbm -o xfertiming-swap2.prg xfertiming3.asm
xfertiming-cmp.prg: xfertiming2.asm
	acme -DTYPE=2 -f cbm -o xfertiming-cmp.prg xfertiming2.asm

disk: progs
	c1541 -format "reu test,00" d64 xfertiming.d64 \
		-write xfertiming-toc64.prg xfertiming-toc64 \
		-write xfertiming-toreu.prg xfertiming-toreu \
		-write xfertiming-swap.prg xfertiming-swap \
		-write xfertiming-swap2.prg xfertiming-swap2 \
		-write xfertiming-cmp.prg xfertiming-cmp

clean:
	rm -f xfertiming-toc64.prg xfertiming-toreu.prg xfertiming-swap.prg xfertiming-swap2.prg xfertiming-cmp.prg
	rm -f xfertiming.d64
