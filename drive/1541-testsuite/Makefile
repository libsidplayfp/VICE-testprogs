
DREAMASS = dreamass

test_files := $(patsubst %.asm,%.prg,$(wildcard tests/*.asm))
vhdl_sim_files := $(patsubst %.prg,%.sim,$(test_files))
disk_files := $(patsubst %.lst,%.d64,$(wildcard disks/*.lst))


.PHONY: disks tests vhdl-simulation-tests framework clean all

all: disks

framework: 1541-testsuite.prg

tests: $(test_files)
vhdl-simulation-tests: $(vhdl_sim_files)

disks: $(disk_files)

1541-testsuite.prg: 1541-testsuite.asm
	$(DREAMASS) -o $@ $<

tests/%.prg: tests/%.asm tests/1541-tests.inc
	$(DREAMASS) -Itests/ -o $@ $<

tests/%.sim: tests/%.asm tests/1541-tests.inc
	$(DREAMASS) -Itests/ -DVHDL_SIMULATION -o $@ $<

prg2ul: prg2ul.c
	$(CC) -O2 -Wall -o $@ $<

disks/%.d64: disks/%.lst prg2ul make_testdisk $(test_files) 1541-testsuite.prg
	./make_testdisk $<

clean:
	rm -rf 1541-testsuite.prg
	rm -rf $(test_files)
	rm -rf $(vhdl_sim_files)
	rm -rf prg2ul
	rm -rf $(disk_files)
