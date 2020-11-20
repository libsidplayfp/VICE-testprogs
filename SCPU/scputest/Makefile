
all: scputest.prg scputest-0.prg scputest-1.prg

scputest.prg: main.c helper.s
	cl65 -Osir -o scputest.prg main.c helper.s
scputest-0.prg: main.c helper.s
	cl65 -Osir -DDOTEST=0 -o scputest-0.prg main.c helper.s
scputest-1.prg: main.c helper.s
	cl65 -Osir -DDOTEST=1 -o scputest-1.prg main.c helper.s

clean:
	$(RM) scputest.prg scputest-0.prg scputest-1.prg
	$(RM) *.o

