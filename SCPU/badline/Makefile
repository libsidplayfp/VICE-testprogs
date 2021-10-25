
all: test_badline.prg

test_badline.prg: test_badline.s
	64tass --m65816 -o test_badline.prg test_badline.s
	
clean:
	$(RM) test_badline.prg
