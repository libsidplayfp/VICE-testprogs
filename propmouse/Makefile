
all:	prop_c64_amiga.prg prop_c64_st.prg prop_c64_cx22.prg

prop_c64_amiga.prg:	c64.o prop_amiga.o
	cl65 -t c64 -C c64-asm.cfg -u __EXEHDR__ -o prop_c64_amiga.prg c64.o prop_amiga.o

prop_c64_st.prg:	c64.o prop_st.o
	cl65 -t c64 -C c64-asm.cfg -u __EXEHDR__ -o prop_c64_st.prg c64.o prop_st.o

prop_c64_cx22.prg:	c64.o prop_cx22.o
	cl65 -t c64 -C c64-asm.cfg -u __EXEHDR__ -o prop_c64_cx22.prg c64.o prop_cx22.o

c64.o:	c64.s
	ca65 -t c64 -o c64.o c64.s

prop_amiga.o:	prop.s
	ca65 -t c64 -DPROP_AMIGA -o prop_amiga.o prop.s

prop_st.o:	prop.s
	ca65 -t c64 -DPROP_ST -o prop_st.o prop.s

prop_cx22.o:	prop.s
	ca65 -t c64 -DPROP_CX22 -o prop_cx22.o prop.s

clean:
	rm -f -r *.o *.prg
