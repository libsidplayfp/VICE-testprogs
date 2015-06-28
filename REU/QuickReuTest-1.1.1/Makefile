
# path to cc65 toolchain, leave empty if installed systemwide
#CCPATH = ~/Desktop/cc65/github/cc65/bin/

CC =        $(CCPATH)cl65
ASM =       $(CCPATH)ca65

D64CREAT =  c1541
PETCAT =    petcat
VICE =      x64sc

EXOMIZER = exomizer

INCLUDES =  includes
OBJS =		LogPrint.o ReuExec.o ReuExAsm.o QuickReu.o
LIBS =
TARGET =	quickreu

# Messages are logged to disk if not disabled
# CFLAGS +=   -DDISABLELOGFILE

all: $(TARGET).d64

test: $(TARGET).d64
	$(VICE) -default -reu -reusize 512 $(TARGET).d64

getlog :
	$(D64CREAT) -attach $(TARGET).d64 -read quickreutest.log
	$(PETCAT) -text -o quickreutest_log.txt quickreutest.log
 
$(TARGET).d64 : $(TARGET).exo.prg
	$(D64CREAT) -format reu-rec-check,rr d64  $(TARGET).d64 -write $(TARGET).exo.prg $(TARGET)

$(TARGET).exo.prg : $(TARGET)
	$(EXOMIZER) sfx basic -o$(TARGET).exo.prg $(TARGET)

$(TARGET) : $(OBJS)
	$(CC) -o $(TARGET) $(OBJS) $(LIBS)

# ReuProg.o: ReuProg.c includes/ReuProg.h ReuIrqs.s

.c.o :
	$(CC) $(CFLAGS) -c -I$(INCLUDES) $<

.s.o :
	$(ASM) $(CFLAGS) $<

clean:
	rm -f $(OBJS) $(TARGET) $(TARGET).exo.prg $(TARGET).d64
	rm -f quickreutest_log.txt quickreutest.log
