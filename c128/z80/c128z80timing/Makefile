# Makefile for c128 z80 timing tester
# 2024-04-29 Roberto Muscedere (rmusced@uwindsor.ca)

#load address in decimal
LA = 7169

#dependent files for all
DEPS = startup.asm macros.z80

#stops c1541 from generating debugging output
C1541OPTS = -disable-libdebug-output

#basename for diskimages
bname := c128z80timing

#file type for diskimages
ftype := d64
#ftype := d81

#max files per diskimage
fmax := 144
#fmax := 296

#needed as we cannot escape a $ inside a function
dollar := $$

#calculate number of files
files := $(shell cat prglist | wc -l)

#disk to be created
#disks := $(shell echo $(files) | awk '{a=int($(dollar)1-1)/$(fmax)+1; for(i=1;i<=a;i=i+1) printf "%02d ",i; printf "\n";}')
disks := $(shell echo $(files) | awk '{a=int($$1-1)/$(fmax)+1; for(i=1;i<=a;i=i+1) printf "%02d ",i; printf "\n";}')

#define a list of program names (without suffix) for each disk: ie. names1, names2, ...
#put the maximum number of files on each disk
$(foreach disk,$(disks),$(eval names$(disk) = $(shell cat prglist | awk -F , -v D=$(disk) 'BEGIN {i=$(fmax);} {if(int(i/$(fmax))==D) print $(dollar)1;i=i+1;}')))

#define a list of program names (with .prg suffix) for each disk: ie. prgs1, prgs2, ...
$(foreach disk,$(disks),$(eval prgs$(disk) = $(foreach item,$(names$(disk)),$(item).prg)))

#define a list of program names (with .z80 suffix) for each disk: ie. z80s1, z80s2, ...
$(foreach disk,$(disks),$(eval z80s$(disk) = $(foreach item,$(names$(disk)),$(item).z80)))

#define build rule function for each prg
define prg_template =
$(1).prg: $(z80s$(2)) $(DEPS)
	xa -bt `expr $(LA) - 2` -M -O PETSCII -DEXPECTED=`grep "^$(1)," prglist | cut -f2 -d,` -DNAME=\"$(1)\" -DNEXT=\"`echo $(names$(2)) - | awk -v NAME=$(1) '{for(i=1;i<=NF;i++) if ($(dollar)$(dollar)i==NAME) print $(dollar)$(dollar)(i+1);}'`\" -o $(1).prga startup.asm
	(echo `wc -c $(1).prga | awk '{print " org "$(dollar)$(dollar)1+$(LA)-2;}'` ; echo " include 'macros.z80'"; cat $(1).z80) | z80asm -i - -o $(1).prgb
	cat $(1).prga $(1).prgb > $(1).prg
	$(RM) $(1).prga $(1).prgb
endef

#generate build rule for each prg
$(foreach disk,$(disks),$(foreach file,$(names$(disk)),$(eval $(call prg_template,$(file),$(disk)))))

#define build rule function for each diskimage
define disk_template =
$(1).$(ftype): $(prgs$(2))
	c1541 -format "$(1),80" $(ftype) $(1).$(ftype) $(C1541OPTS) > /dev/null
	for I in $(names$(2)); do \
		c1541 $(1).$(ftype) -write "$(dollar)$(dollar)I.prg" `echo "$(dollar)$(dollar)I" $(C1541OPTS)` > /dev/null; \
	done
	c1541 $(1).$(ftype) -list
endef

#generate build rule for each diskimage
$(foreach disk,$(disks),$(eval $(call disk_template,$(bname)-$(disk),$(disk))))

#generate a list of all disk images
alldisks = $(foreach disk,$(disks),$(bname)-$(disk).$(ftype))

#generate a list of all prg files
allprgs = $(foreach disk,$(disks),$(prgs$(disk)))

#set the default action to "make all"
.DEFAULT_GOAL := all

all: $(alldisks)

clean:
	rm -f $(allprgs)
	rm -f $(alldisks)
	rm -f *.prga *.prgb
