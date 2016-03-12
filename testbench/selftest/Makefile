
all: c64-pass.prg c64-fail.prg \
	plus4-pass.prg plus4-fail.prg \
	scpu-pass.prg scpu-fail.prg \
	dtv-pass.prg dtv-fail.prg \
	c128-pass.prg c128-fail.prg \
	vic20-pass.prg vic20-fail.prg \
	pet-pass.prg pet-fail.prg \
	cbm610-pass.prg cbm610-fail.prg \
	cbm510-pass.prg cbm510-fail.prg \
	vsid-pass.prg vsid-fail.prg

c64-pass.prg: c64.asm
	acme -DFAIL=0 -f cbm -o c64-pass.prg c64.asm
c64-fail.prg: c64.asm
	acme -DFAIL=1 -f cbm -o c64-fail.prg c64.asm
plus4-pass.prg: plus4.asm
	acme -DFAIL=0 -f cbm -o plus4-pass.prg plus4.asm
plus4-fail.prg: plus4.asm
	acme -DFAIL=1 -f cbm -o plus4-fail.prg plus4.asm
scpu-pass.prg: scpu.asm
	acme -DFAIL=0 -f cbm -o scpu-pass.prg scpu.asm
scpu-fail.prg: scpu.asm
	acme -DFAIL=1 -f cbm -o scpu-fail.prg scpu.asm
dtv-pass.prg: dtv.asm
	acme -DFAIL=0 -f cbm -o dtv-pass.prg dtv.asm
dtv-fail.prg: dtv.asm
	acme -DFAIL=1 -f cbm -o dtv-fail.prg dtv.asm
vic20-pass.prg: vic20.asm
	acme -DFAIL=0 -f cbm -o vic20-pass.prg vic20.asm
vic20-fail.prg: vic20.asm
	acme -DFAIL=1 -f cbm -o vic20-fail.prg vic20.asm
c128-pass.prg: c128.asm
	acme -DFAIL=0 -f cbm -o c128-pass.prg c128.asm
c128-fail.prg: c128.asm
	acme -DFAIL=1 -f cbm -o c128-fail.prg c128.asm
pet-pass.prg: pet.asm
	acme -DFAIL=0 -f cbm -o pet-pass.prg pet.asm
pet-fail.prg: pet.asm
	acme -DFAIL=1 -f cbm -o pet-fail.prg pet.asm
vsid-pass.prg: vsid.asm
	acme -DFAIL=0 -f plain -o vsid-pass.sid vsid.asm
vsid-fail.prg: vsid.asm
	acme -DFAIL=1 -f plain -o vsid-fail.sid vsid.asm
cbm610-pass.prg: cbm610.asm
	acme -DFAIL=0 -f cbm -o cbm610-pass.prg cbm610.asm
cbm610-fail.prg: cbm610.asm
	acme -DFAIL=1 -f cbm -o cbm610-fail.prg cbm610.asm
cbm510-pass.prg: cbm510.asm
	acme -DFAIL=0 -f cbm -o cbm510-pass.prg cbm510.asm
cbm510-fail.prg: cbm510.asm
	acme -DFAIL=1 -f cbm -o cbm510-fail.prg cbm510.asm
