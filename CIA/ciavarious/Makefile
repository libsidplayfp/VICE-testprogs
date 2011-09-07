
all: pack disk

.PHONY: pack disk

pack:
	exomizer sfx basic -o cia1.prg cia1 cia1data
	exomizer sfx basic -o cia2.prg cia2 cia2data
	exomizer sfx basic -o cia3.prg cia3 cia3data
	exomizer sfx basic -o cia3a.prg cia3a cia3adata
	exomizer sfx basic -o cia4.prg cia4 cia4data
	exomizer sfx basic -o cia5.prg cia5 cia5data
	exomizer sfx basic -o cia6.prg cia6 cia6data
	exomizer sfx basic -o cia7.prg cia7 cia7data
	exomizer sfx basic -o cia8.prg cia8 cia8data
	exomizer sfx basic -o cia9.prg cia9 cia9data
	exomizer sfx basic -o cia10.prg cia10 cia10data
	exomizer sfx basic -o cia11.prg cia11 cia11data
	exomizer sfx basic -o cia12.prg cia12 cia12data
	exomizer sfx basic -o cia13.prg cia13 cia13data
	exomizer sfx basic -o cia14.prg cia14 cia14data
	exomizer sfx basic -o cia15.prg cia15 cia15data

disk: pack
	c1541 -format "ciavarious,00" d64 cia.d64 \
		-write cia1.prg cia1 \
		-write cia2.prg cia2 \
		-write cia3.prg cia3 \
		-write cia3a.prg cia3a \
		-write cia4.prg cia4 \
		-write cia5.prg cia5 \
		-write cia6.prg cia6 \
		-write cia7.prg cia7 \
		-write cia8.prg cia8 \
		-write cia9.prg cia9 \
		-write cia10.prg cia10 \
		-write cia11.prg cia11 \
		-write cia12.prg cia12 \
		-write cia13.prg cia13 \
		-write cia14.prg cia14 \
		-write cia15.prg cia15
