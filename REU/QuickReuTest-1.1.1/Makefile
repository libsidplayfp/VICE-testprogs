
# path to cc65 toolchain, leave empty if installed systemwide
#CCPATH = ~/Desktop/cc65/github/cc65/bin/

CC =        $(CCPATH)cl65
ASM =       $(CCPATH)ca65

D64CREAT =  c1541
PETCAT =    petcat
VICE =      x64sc

EXOMIZER = exomizer

INCLUDES =  includes
#OBJS =		LogPrint.o ReuExec.o ReuExAsm.o QuickReu.o
OBJS =		LogPrint.o ReuExec.o ReuExAsm.o
LIBS =
TARGET =	quickreu

# Messages are logged to disk if not disabled
# CFLAGS +=   -DDISABLELOGFILE

all: $(TARGET).d64 \
	quickreu-test1.prg \
	quickreu-test2.prg \
	quickreu-test3.prg \
	quickreu-test4.prg \
	quickreu-test5.prg \
	quickreu-test6.prg \
	quickreu-test7.prg \
	quickreu-test8.prg

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
	$(CC) -DDOALL -o $(TARGET) -I$(INCLUDES) QuickReu.c $(OBJS) $(LIBS)

quickreu-test1.prg : $(OBJS)
	$(CC) -DDISABLELOGFILE -DDOTEST1 -o quickreu-test1.prg -I$(INCLUDES) QuickReu.c $(OBJS) $(LIBS)
quickreu-test2.prg : $(OBJS)
	$(CC) -DDISABLELOGFILE -DDOTEST2 -o quickreu-test2.prg -I$(INCLUDES) QuickReu.c $(OBJS) $(LIBS)
quickreu-test3.prg : $(OBJS)
	$(CC) -DDISABLELOGFILE -DDOTEST3 -o quickreu-test3.prg -I$(INCLUDES) QuickReu.c $(OBJS) $(LIBS)
quickreu-test4.prg : $(OBJS)
	$(CC) -DDISABLELOGFILE -DDOTEST4 -o quickreu-test4.prg -I$(INCLUDES) QuickReu.c $(OBJS) $(LIBS)
quickreu-test5.prg : $(OBJS)
	$(CC) -DDISABLELOGFILE -DDOTEST5 -o quickreu-test5.prg -I$(INCLUDES) QuickReu.c $(OBJS) $(LIBS)
quickreu-test6.prg : $(OBJS)
	$(CC) -DDISABLELOGFILE -DDOTEST6 -o quickreu-test6.prg -I$(INCLUDES) QuickReu.c $(OBJS) $(LIBS)
quickreu-test7.prg : $(OBJS)
	$(CC) -DDISABLELOGFILE -DDOTEST7 -o quickreu-test7.prg -I$(INCLUDES) QuickReu.c $(OBJS) $(LIBS)
quickreu-test8.prg : $(OBJS)
	$(CC) -DDISABLELOGFILE -DDOTEST8 -o quickreu-test8.prg -I$(INCLUDES) QuickReu.c $(OBJS) $(LIBS)


.c.o :
	$(CC) $(CFLAGS) -c -I$(INCLUDES) $<

.s.o :
	$(ASM) $(CFLAGS) $<

clean:
	$(RM) $(OBJS) $(TARGET) $(TARGET).exo.prg $(TARGET).d64
	$(RM) quickreutest_log.txt quickreutest.log
	$(RM) quickreu-test1.prg
	$(RM) quickreu-test2.prg
	$(RM) quickreu-test3.prg
	$(RM) quickreu-test4.prg
	$(RM) quickreu-test5.prg
	$(RM) quickreu-test6.prg
	$(RM) quickreu-test7.prg
	$(RM) quickreu-test8.prg
