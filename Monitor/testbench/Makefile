
#EMU=x64sc
EMU=../../../trunk/vice/src/x64sc

EMUOPT=-default
EMUOPT+=-warp -silent -minimized -console
EMUOPT+=-initbreak ready
EMUOPT+=-limitcycles 10000000

#EMU=WINEDEBUG=-all wine /vice-oldversions/SDL2VICE-3.8-win64/x64sc.exe
#EMUOPT=-default -warp -silent -minimized -initbreak ready

NULLDIRECT=1> /dev/null 2> /dev/null
STDOUTNULL=1> /dev/null

CD = cd

.SILENT:

PROGS=\


RESULTS0=\
	goonbreak.log \
	goonbreak-2.log \
	radix-binary.log \
	bug942.log \
	bug2025.log \
	bug2025-2.log \
	bug2025-2b.log \
	bug2025-3.log \
	bug2025-4.log \
	bug2025-4b.log \
	bug2025-4c.log \
	bug2063.log \
	bug2126.log \
	bug2126-2.log \
	bug2178.log \
	bug2178-2.log \
	bug2220-2.log \
	bug2221.log \
	bug2221-1.log


PROGSTODO=\
	todo/bug2024.prg \
	todo/bugX.prg


RESULTS0TODO=\
	todo/bug1488.log \
	todo/bug1836.log \
	todo/bug1984.log \
	todo/bug1984-2.log \
	todo/bug2024.log \
	todo/bug2126-3.log \
	todo/bug2126-4.log \
	todo/bug2126-5.log \
	todo/bug2179.log \
	todo/bug2179-2.log \
	todo/bug2220.log \
	todo/bug2220-1.log \
	todo/bugX.log

all:
	$(RM) $(RESULTS0)
	$(RM) $(RESULTS0TODO)
	@make --no-print-dir tests

.PHONY: todo

todo:
	$(RM) $(RESULTS0TODO)
	@make --no-print-dir helper $(RESULTS0TODO)

todo/%.prg: todo/%.asm
	acme -f cbm --vicelabels todo/$*.lbl -o todo/$*.prg todo/$*.asm $(STDOUTNULL)

todo/%.log: todo/%.mon $(PROGSTODO)
#	echo "----------------------------------------"
	$(RM) todo/$*.log
#	echo "1:$*.log:"
	-$(CD) todo ; ../$(EMU) $(EMUOPT) -moncommands $*.mon $(NULLDIRECT) || echo -e "TODO: \e[91;40mError:\e[0m todo/"$*".mon exited with timeout."
#	cat $*.log
	echo -ne "TODO: "
	-./cmplogs.sh todo/$*.log todo/$*.ref

%.prg: %.asm
	acme -f cbm --vicelabels $*.lbl -o $*.prg $*.asm $(STDOUTNULL)

%.log: %.mon
#	echo "----------------------------------------"
	$(RM) $*.log
#	echo "2:$*.log:"
	$(EMU) $(EMUOPT) -moncommands $*.mon $(NULLDIRECT)
#	cat $*.log
	./cmplogs.sh $*.log $*.ref

.PHONY: helper tests

helper: $(PROGS) $(PROGSTODO)
#	echo "----------------------------------------"
#	echo "helper .prg ready."

tests: helper $(RESULTS0) $(RESULTS0TODO)
#	echo "----------------------------------------"
#	echo "tests ready."

.PHONY: clean

clean:
	$(RM) $(RESULTS0)
	$(RM) $(RESULTS0TODO)
	$(RM) $(PROGS)
	$(RM) $(PROGSTODO)
	$(RM) *.log.tmp
	$(RM) *.ref.tmp
	$(RM) *.lbl
	$(RM) todo/*.lbl
	$(RM) *.vsf
	$(RM) todo/*.vsf
	$(RM) *.log
	$(RM) todo/*.log
