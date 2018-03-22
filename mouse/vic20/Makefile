
all: neos0k.prg neos8k.prg 13510k.prg 13518k.prg \
	13510kstrip.prg 13510kntscstrip.prg \
	13518kstrip.prg 13518kntscstrip.prg \
	prop_vic20_amiga.prg \
	prop_vic20_cx22.prg \
	prop_vic20_st.prg
	
prop_vic20_amiga.prg: Makefile main_vic20.s prop.s
	cl65 -t vic20 --asm-define PROP_AMIGA main_vic20.s prop.s -o $@
	
prop_vic20_cx22.prg: Makefile main_vic20.s prop.s
	cl65 -t vic20 --asm-define PROP_CX22 main_vic20.s prop.s -o $@
	
prop_vic20_st.prg: Makefile main_vic20.s prop.s
	cl65 -t vic20 --asm-define PROP_ST main_vic20.s prop.s -o $@
	
neos0k.prg: neos-vic20.asm
	acme -Dexpanded=0 -f cbm -o neos0k.prg neos-vic20.asm
	
neos8k.prg: neos-vic20.asm
	acme -Dexpanded=1 -f cbm -o neos8k.prg neos-vic20.asm
	
13510k.prg: 1351-vic20.asm
	acme -Dexpanded=0 -f cbm -o 13510k.prg 1351-vic20.asm
	
13518k.prg: 1351-vic20.asm
	acme -Dexpanded=1 -f cbm -o 13518k.prg 1351-vic20.asm
	
13510kstrip.prg: 1351-stripped.asm
	acme -Dexpanded=0 -DNTSCTIMING=0 -f cbm -o 13510kstrip.prg 1351-stripped.asm
13510kntscstrip.prg: 1351-stripped.asm
	acme -Dexpanded=0 -DNTSCTIMING=1 -f cbm -o 13510kntscstrip.prg 1351-stripped.asm
13518kstrip.prg: 1351-stripped.asm
	acme -Dexpanded=1 -DNTSCTIMING=0 -f cbm -o 13518kstrip.prg 1351-stripped.asm
13518kntscstrip.prg: 1351-stripped.asm
	acme -Dexpanded=1 -DNTSCTIMING=1 -f cbm -o 13518kntscstrip.prg 1351-stripped.asm
	
clean:
	$(RM) prop_vic20_amiga.prg
	$(RM) prop_vic20_cx22.prg
	$(RM) prop_vic20_st.prg
	$(RM) neos0k.prg 13510k.prg
	$(RM) neos8k.prg 13518k.prg
