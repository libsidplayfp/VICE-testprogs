
all: test1.prg userport-dump.prg userport-miniterm.prg

test1.prg: test1.bas
	petcat -w2 -o test1.prg test1.bas

userport-dump.prg: userport-dump.bas
	petcat -w2 -o userport-dump.prg userport-dump.bas
userport-miniterm.prg: userport-miniterm.bas
	petcat -w2 -o userport-miniterm.prg userport-miniterm.bas

test-userport-dump: userport-dump.prg
	x64sc -default -rsdev3ip232 -rsdev3baud "1200" -rsuserbaud "1200" -rsuserdev "2" -userportdevice "2" userport-dump.prg
test-userport-miniterm: userport-miniterm.prg
#	x64sc -default -rsdev3ip232 -rsdev3baud "300" -rsuserbaud "300" -rsuserdev "2" -userportdevice "2" userport-miniterm.prg
	x64sc -default -rsdev3ip232 -rsdev3baud "1200" -rsuserbaud "1200" -rsuserdev "2" -userportdevice "2" userport-miniterm.prg
	
clean:
	$(RM) test1.prg
	$(RM) userport-dump.prg
