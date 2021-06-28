
all: disk

bmldr.prg: bmload.src mmu.src
	xa -o bmldr.prg -l bmldr.lbl bmload.src
ilace.prg: interlace.src interrupt.src mmu.src text-fli.src vic2e.src
	xa -o ilace.prg -l ilace.lbl interlace.src
demo21.prg: demo21.bas
	petcat -w70 -o demo21.prg -- demo21.bas
	
disk: bmldr.prg ilace.prg demo21.prg
	c1541 -format "interlace,00" d64 interlace.d64 \
		-write "demo21.prg" "demo 2.1" \
		-write "bmldr.prg" "bm loader" \
		-write "ilace.prg" "code 5" \
		-write "copying.txt" "copying.txt,s" \
		-write "files/circle0.prg" "circle0" \
		-write "files/circle1.prg" "circle1" \
		-write "files/dither0.prg" "dither0" \
		-write "files/dither1.prg" "dither1" \
		-write "files/titty0.prg" "titty0" \
		-write "files/titty1.prg" "titty1" \
		-write "files/kneel0.prg" "kneel0" \
		-write "files/kneel1.prg" "kneel1" \
		-write "files/flitext.prg" "fli text"

clean:
	$(RM) bmldr.lbl
	$(RM) ilace.lbl
	$(RM) bmldr.prg ilace.prg demo21.prg
	$(RM) interlace.d64
