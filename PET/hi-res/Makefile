
all: hi-res.prg

hi-res.prg: hi-res.bas hi-res.asm
	acme -f plain -o hi-res.bin hi-res.asm
	petcat -w2 -l 401 -o hi-res.prg -- hi-res.bas
	cat hi-res.bin >> hi-res.prg

clean:
	$(RM) hi-res.prg
	$(RM) hi-res.bin
