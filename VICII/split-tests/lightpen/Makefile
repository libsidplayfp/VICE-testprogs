# Makefile

all:	lightpen.prg

lightpen.prg: lightpen.asm ../common/startup.asm ../common/scandump.asm \
	dump6567.bin dump8562r4.bin dump8564.bin dump8564r5.bin \
	dump6569.bin dump6569r1.bin dump8565.bin \
	dump6572.bin \
	dumpdtv3.bin
	dasm $< -o$@

dump6567.bin:	dump6567.prg makeref
	./makeref $< $@

dump8562r4.bin:	dump8562r4.prg makeref
	./makeref $< $@

dump8564.bin:	dump8564.prg makeref
	./makeref $< $@

dump8564r5.bin:	dump8564r5.prg makeref
	./makeref $< $@

dump6569.bin:	dump6569.prg makeref
	./makeref $< $@

dump6569r1.bin:	dump6569r1.prg makeref
	./makeref $< $@

dump8565.bin:	dump8565.prg makeref
	./makeref $< $@

dump6572.bin:	dump6572.prg makeref
	./makeref $< $@

dumpdtv3.bin:	dumpdtv3.prg makeref
	./makeref $< $@

makeref: makeref.c
	gcc -Wall -o $@ $<

analyse: analyse.c
	gcc -Wall -o $@ $<

clean:
	rm -f *~ \#*\#
	rm -f a.out
	rm -f *.bin
	rm -f makeref analyse
	rm -f lightpen.prg

# eof
