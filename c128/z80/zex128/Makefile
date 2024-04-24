#load address in decimal
LA = 7169

PRIPROGS = prelim.prg

ZEXPROGS = \
	adc16.prg \
	add16.prg \
	add16x.prg \
	add16y.prg \
	alu8i.prg \
	alu8r.prg \
	alu8rx.prg \
	alu8x.prg \
	bitx.prg \
	bitz80.prg \
	cpd1.prg \
	cpi1.prg \
	daaop.prg \
	inca.prg \
	incb.prg \
	incbc.prg \
	incc.prg \
	incd.prg \
	incde.prg \
	ince.prg \
	inch.prg \
	inchl.prg \
	incix.prg \
	inciy.prg \
	incl.prg \
	incm.prg \
	incsp.prg \
	incx.prg \
	incxh.prg \
	incxl.prg \
	incyh.prg \
	incyl.prg \
	ld161.prg \
	ld162.prg \
	ld163.prg \
	ld164.prg \
	ld165.prg \
	ld166.prg \
	ld167.prg \
	ld168.prg \
	ld16im.prg \
	ld16ix.prg \
	ld8bd.prg \
	ld8im.prg \
	ld8imx.prg \
	ld8ix1.prg \
	ld8ix2.prg \
	ld8ix3.prg \
	ld8ixy.prg \
	ld8rr.prg \
	ld8rrx.prg \
	lda.prg \
	ldd1.prg \
	ldd2.prg \
	ldi1.prg \
	ldi2.prg \
	negop.prg \
	rldop.prg \
	rot8080.prg \
	rotxy.prg \
	rotz80.prg \
	srz80.prg \
	srzx.prg \
	st8ix1.prg \
	st8ix2.prg \
	st8ix3.prg \
	stabd.prg \
	adc16-all.prg \
	add16-all.prg \
	add16x-all.prg \
	add16y-all.prg \
	alu8i-all.prg \
	alu8r-all.prg \
	alu8rx-all.prg \
	alu8x-all.prg \
	bitx-all.prg \
	bitz80-all.prg \
	cpd1-all.prg \
	cpi1-all.prg \
	daaop-all.prg \
	inca-all.prg \
	incb-all.prg \
	incbc-all.prg \
	incc-all.prg \
	incd-all.prg \
	incde-all.prg \
	ince-all.prg \
	inch-all.prg \
	inchl-all.prg \
	incix-all.prg \
	inciy-all.prg \
	incl-all.prg \
	incm-all.prg \
	incsp-all.prg \
	incx-all.prg \
	incxh-all.prg \
	incxl-all.prg \
	incyh-all.prg \
	incyl-all.prg \
	ld161-all.prg \
	ld162-all.prg \
	ld163-all.prg \
	ld164-all.prg \
	ld165-all.prg \
	ld166-all.prg \
	ld167-all.prg \
	ld168-all.prg \
	ld16im-all.prg \
	ld16ix-all.prg \
	ld8bd-all.prg \
	ld8im-all.prg \
	ld8imx-all.prg \
	ld8ix1-all.prg \
	ld8ix2-all.prg \
	ld8ix3-all.prg \
	ld8ixy-all.prg \
	ld8rr-all.prg \
	ld8rrx-all.prg \
	lda-all.prg \
	ldd1-all.prg \
	ldd2-all.prg \
	ldi1-all.prg \
	ldi2-all.prg \
	negop-all.prg \
	rldop-all.prg \
	rot8080-all.prg \
	rotxy-all.prg \
	rotz80-all.prg \
	srz80-all.prg \
	srzx-all.prg \
	st8ix1-all.prg \
	st8ix2-all.prg \
	st8ix3-all.prg \
	stabd-all.prg

PROGS = $(PRIPROGS) $(ZEXPROGS)

all: $(PROGS) zex128.d81

prelim.prg: prelim.z80
	xa -bt `expr $(LA) - 2` -M -O PETSCII -DNAME=\"prelim\" -DNEXT=\"`echo $(basename $(PROGS)) - | awk -v NAME=prelim '{for(i=1;i<=NF;i++) if ($$i==NAME) print $$(i+1);}'`\" -o prelim.prga start.asm
	(echo " org 0500h"; cat prelim.z80) | z80asm -i - -o prelim.prgb
	cat prelim.prga prelim.prgb > prelim.prg
	$(RM) prelim.prga prelim.prgb

%.prg: %.z80 start.asm start.z80 macro.z80 end.z80
	xa -bt `expr $(LA) - 2` -M -O PETSCII -DNAME=\"$*\" -DNEXT=\"`echo $(basename $(PROGS)) - | awk -v NAME=$* '{for(i=1;i<=NF;i++) if ($$i==NAME) print $$(i+1);}'`\" -o $*.prga start.asm
	(echo " org 0500h"; echo " include 'start.z80'" ; cat $*.z80 ; echo " include 'end.z80'") | z80asm -i - -o $*.prgb
	cat $*.prga $*.prgb > $*.prg
	$(RM) $*.prga $*.prgb

C1541OPTS = -disable-libdebug-output

zex128.d81: $(PROGS)
	c1541 -format "zex128,80" d81 zex128.d81 $(C1541OPTS) > /dev/null
	for I in $(basename $(PROGS)); do \
		c1541 zex128.d81 -write "$$I.prg" `echo "$$I" $(C1541OPTS)` > /dev/null; \
	done
#	c1541 zex128.d81 -list $(C1541OPTS)

clean:
	rm -f *.prg
	rm -f *.d81
