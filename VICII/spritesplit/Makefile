# Makefile

all:	ss-hires-mc.prg ss-hires-mc-exp.prg ss-hires-color.prg ss-xpos.prg \
	ss-unexp-exp-hires.prg ss-unexp-exp-mc.prg \
	ss-pri.prg ss-pri-exp.prg ss-pri-mc.prg ss-pri-mc-exp.prg


ss-hires-mc.prg: spritesplit.asm
	dasm $< -o$@ -DSPLIT_HIRES_TO_MC

ss-hires-mc-exp.prg: spritesplit.asm
	dasm $< -o$@ -DSPLIT_HIRES_TO_MC_EXPANDED

ss-hires-color.prg: spritesplit.asm
	dasm $< -o$@ -DSPLIT_HIRES_COLOR

ss-xpos.prg: spritesplit.asm
	dasm $< -o$@ -DSPLIT_XPOS

ss-unexp-exp-hires.prg: spritesplit.asm
	dasm $< -o$@ -DSPLIT_UNEXP_EXP_HIRES

ss-unexp-exp-mc.prg: spritesplit.asm
	dasm $< -o$@ -DSPLIT_UNEXP_EXP_MC

ss-pri.prg: spritesplit.asm
	dasm $< -o$@ -DSPLIT_PRI

ss-pri-exp.prg: spritesplit.asm
	dasm $< -o$@ -DSPLIT_PRI_EXP

ss-pri-mc.prg: spritesplit.asm
	dasm $< -o$@ -DSPLIT_PRI_MC

ss-pri-mc-exp.prg: spritesplit.asm
	dasm $< -o$@ -DSPLIT_PRI_MC_EXP

clean:
	rm -f *~ \#*\#
	rm -f a.out
	rm -f ss-hires-mc.prg
	rm -f ss-hires-mc-exp.prg
	rm -f ss-hires-color.prg
	rm -f ss-xpos.prg
	rm -f ss-unexp-exp-hires.prg
	rm -f ss-unexp-exp-mc.prg
	rm -f ss-pri.prg
	rm -f ss-pri-exp.prg
	rm -f ss-pri-mc.prg
	rm -f ss-pri-mc-exp.prg
# eof
