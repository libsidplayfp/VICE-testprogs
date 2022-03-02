
all: colourtest.prg lumatest.prg palengine.prg ntscengine.prg lumapal.prg lumantsc.prg colourtest.d64

colourtest.prg: colourtest.bas
	petcat -w2 -o colourtest.prg -- colourtest.bas
lumatest.prg: lumatest.bas
	petcat -w2 -o lumatest.prg -- lumatest.bas

lumapal.prg: lumaengine.asm
	acme -DNTSC=0 -f cbm -o lumapal.prg lumaengine.asm
lumantsc.prg: lumaengine.asm
	acme -DNTSC=1 -f cbm -o lumantsc.prg lumaengine.asm

palengine.prg: palengine.asm
	acme -f cbm -o palengine.prg palengine.asm
ntscengine.prg: ntscengine.asm
	acme -f cbm -o ntscengine.prg ntscengine.asm

colourtest.d64: colourtest.prg lumatest.prg palengine.prg ntscengine.prg lumapal.prg lumantsc.prg
	c1541 -format "colour test,00" d64 colourtest.d64 \
		-write "lumatest.prg" "luma test" \
		-write "colourtest.prg" "colour test" \
		-write "lumapal.prg" "luma pal" \
		-write "lumantsc.prg" "luma ntsc" \
		-write "palengine.prg" "pal engine" \
		-write "ntscengine.prg" "ntsc engine"
	
clean:
	$(RM) colourtest.prg
	$(RM) lumatest.prg
	$(RM) palengine.prg
	$(RM) ntscengine.prg
	$(RM) colourtest.d64
	$(RM) lumapal.prg
	$(RM) lumantsc.prg
