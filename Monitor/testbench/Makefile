
EMU=../../../trunk/vice/src/x64sc
EMUOPT=-default -warp -silent -minimized -console -initbreak ready

#EMU=WINEDEBUG=-all wine /home/groepaz/Desktop/vice/vice-oldversions/SDL2VICE-3.8-win64/x64sc.exe
#EMUOPT=-default -warp -silent -minimized -initbreak ready

NULLDIRECT=1> /dev/null 2> /dev/null

.SILENT:

PROGS=\
	 bug2024.prg

RESULTS0=\
	 goonbreak.log \
	 goonbreak-2.log \
	 radix-binary.log \
	 bug942.log \
	 bug1488.log \
	 bug1836.log \
	 bug1984.log \
	 bug1984-2.log \
	 bug2024.log \
	 bug2025.log \
	 bug2025-2.log \
	 bug2025-2b.log

all: helper tests

%.prg: %.asm
	acme -f cbm -o $*.prg $*.asm

%.log: %.mon
#	echo "----------------------------------------"
	$(RM) $*.log
	$(EMU) $(EMUOPT) -moncommands $*.mon $(NULLDIRECT)
#	echo "$*.log:"
#	cat $*.log
	-./cmplogs.sh $*.log $*.ref

helper: $(PROGS)
#	echo "----------------------------------------"
#	echo "helper .prg ready."

tests: helper $(RESULTS0)
#	echo "----------------------------------------"
#	echo "tests ready."

clean:
	$(RM) $(RESULTS0)
	$(RM) $(PROGS)
	$(RM) *.log.tmp
	$(RM) *.ref.tmp
