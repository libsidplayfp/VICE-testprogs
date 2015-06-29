

all: dadc.prg  dincsbc-deccmp.prg  dincsbc.prg  droradc.prg  dsbc-cmp-flags.prg  dsbc.prg  sbx-c100.prg  sbx.prg  vsbx.prg

dadc.prg: dadc.asm
	acme --cpu 6510 -f cbm -o dadc.prg dadc.asm
dincsbc-deccmp.prg: dincsbc-deccmp.asm
	acme --cpu 6510 -f cbm -o dincsbc-deccmp.prg dincsbc-deccmp.asm
dincsbc.prg: dincsbc.asm
	acme --cpu 6510 -f cbm -o dincsbc.prg dincsbc.asm
droradc.prg: droradc.asm
	acme --cpu 6510 -f cbm -o droradc.prg droradc.asm
dsbc-cmp-flags.prg: dsbc-cmp-flags.asm
	acme --cpu 6510 -f cbm -o dsbc-cmp-flags.prg dsbc-cmp-flags.asm
dsbc.prg: dsbc.asm
	acme --cpu 6510 -f cbm -o dsbc.prg dsbc.asm
sbx-c100.prg: sbx-c100.asm
	acme --cpu 6510 -f cbm -o sbx-c100.prg sbx-c100.asm
sbx.prg: sbx.asm
	acme --cpu 6510 -f cbm -o sbx.prg sbx.asm
vsbx.prg: vsbx.asm
	acme --cpu 6510 -f cbm -o vsbx.prg vsbx.asm

clean:
	rm -f *.prg
