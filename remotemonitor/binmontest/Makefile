CFLAGS=-g -O0

X64SC:=../../../trunk/vice/src/x64sc

all: remotetest

remotetest: CuTest.o connection.o checkpoint.o util.o main.o
	$(CC) $(CFLAGS) -o remotetest $^

test: remotetest
	$(X64SC) -default -binarymonitor -minimized > /dev/null & \
		PID=$$! ;\
		sleep 1 ;\
		MON_QUIT=1 ./remotetest 6502

clean:
	rm *.o remotetest
