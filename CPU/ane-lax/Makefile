# Makefile

all:	ane-lax.prg

ane-lax.prg: ane-lax.asm
	dasm $< -o$@

analyze:	analyze.c
	gcc -Wall $^ -o$@

test: analyze
	./analyze dumps/dump6510_3184.prg

	./analyze dumps/dump6510_4782-coldstart/alresult1.prg
	./analyze dumps/dump6510_4782-coldstart/alresult2.prg
	./analyze dumps/dump6510_4782-coldstart/alresult3.prg
	./analyze dumps/dump6510_4782-coldstart/alresult4.prg
	./analyze dumps/dump6510_4782-coldstart/alresult5.prg

	./analyze dumps/dump8500_0787-coldstart/alresult1.prg
	./analyze dumps/dump8500_0787-coldstart/alresult2.prg
	./analyze dumps/dump8500_0787-coldstart/alresult3.prg
	./analyze dumps/dump8500_0787-coldstart/alresult4.prg
	./analyze dumps/dump8500_0787-coldstart/alresult5.prg
	
	./analyze dumps/dump8500_1588-coldstart/alresult1.prg
	./analyze dumps/dump8500_1588-coldstart/alresult2.prg
	./analyze dumps/dump8500_1588-coldstart/alresult3.prg
	./analyze dumps/dump8500_1588-coldstart/alresult4.prg
	./analyze dumps/dump8500_1588-coldstart/alresult5.prg
	
	./analyze dumps/dump8500_1588-cooling/cpuafter1.prg
	./analyze dumps/dump8500_1588-cooling/cpuafter2.prg
	./analyze dumps/dump8500_1588-cooling/cpuafter3.prg
	./analyze dumps/dump8500_1588-cooling/cpubefore.prg
	./analyze dumps/dump8500_1588-cooling/cpucool.prg
	./analyze dumps/dump8500_1588-cooling/vicafter1.prg
	./analyze dumps/dump8500_1588-cooling/vicafter2.prg
	./analyze dumps/dump8500_1588-cooling/vicafter3.prg
	./analyze dumps/dump8500_1588-cooling/vicbefore.prg
	./analyze dumps/dump8500_1588-cooling/viccool.prg
	
	./analyze dumps/dump8500_1588-power/1764brick-1.prg
	./analyze dumps/dump8500_1588-power/1764brick-2.prg
	./analyze dumps/dump8500_1588-power/c64cbrick-1.prg
	./analyze dumps/dump8500_1588-power/c64cbrick-2.prg

clean:
	rm -f *~ \#*\#
	rm -f a.out
	rm -f ane-lax.prg

