
all: keybscan.prg 

keybscan.prg: keybscan.a65
	xa -o keybscan.prg keybscan.a65

test: keybscan.prg
	xpet -model 4032 +sound keybscan.prg
	
clean:
	$(RM) keybscan.prg
