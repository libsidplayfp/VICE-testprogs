
all: ciaflag.prg ciaflag.d81

ciaflag.prg: ciaflag.s
	64tass -o ciaflag.prg ciaflag.s

ciaflag.d81: ciaflag.prg
	c1541 -format "ciaflag,00" d81 ciaflag.d81 \
		-write ciaflag.prg ciaflag

clean:
	$(RM) ciaflag.prg
	$(RM) ciaflag.d81
