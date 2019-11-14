
all: explorer.d64 tt.d64

vdc-explorer.prg: vdc-explorer.bas
	petcat -w70 -o vdc-explorer.prg -- vdc-explorer.bas

explorer.d64: vdc-explorer.prg vdc-explorer.o
	c1541 -format "vdc-explorer,00" d64 explorer.d64 \
		-write "vdc-explorer.prg" "vdc-explorer" \
		-write "vdc-explorer.o" "vdc-explorer.o"

tt.prg: tt.bas
	petcat -w70 -o tt.prg -- tt.bas

tt.d64: tt.prg tt.o
	c1541 -format "tt,00" d64 tt.d64 \
		-write "tt.prg" "tt" \
		-write "tt.o" "tt.o"

clean:
	$(RM) explorer.d64 vdc-explorer.prg
	$(RM) tt.d64 tt.prg
