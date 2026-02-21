# Makefile

all:	via_wrap2.prg via_wrap2a.prg \
	via_T2wrap2.prg via_T2wrap2a.prg \
	via_wrap_pal.prg # via_wrap_ntsc.prg

via_wrap_pal.prg: via_wrap.asm macros.i
	dasm $< -o$@ -DIS_PAL=1

#via_wrap_ntsc.prg: via_wrap.asm macros.i
#	dasm $< -o$@ -DIS_PAL=0

via_wrap2.prg: via_wrap2.asm macros.i
	dasm $< -o$@ -DEXPANDED=1 -DTIMERHI=0 -DTIMER=1
via_wrap2a.prg: via_wrap2.asm macros.i
	dasm $< -o$@ -DEXPANDED=1 -DTIMERHI=1 -DTIMER=1

via_T2wrap2.prg: via_wrap2.asm macros.i
	dasm $< -o$@ -DEXPANDED=1 -DTIMERHI=0 -DTIMER=2
via_T2wrap2a.prg: via_wrap2.asm macros.i
	dasm $< -o$@ -DEXPANDED=1 -DTIMERHI=1 -DTIMER=2

clean:
	rm -f *~ \#*\#
	rm -f a.out
	rm -f via_wrap_pal.prg
	rm -f via_wrap_ntsc.prg
	rm -f via_wrap2.prg
	rm -f via_wrap2a.prg
	rm -f via_T2wrap2.prg
	rm -f via_T2wrap2a.prg
# eof
