CFLAGS=-g -O0

all: remotetest

remotetest: CuTest.o main.o
	$(CC) $(CFLAGS) -o remotetest CuTest.o main.o

test: remotetest
	x64sc -default -binarymonitor -minimized > /dev/null & \
		PID=$$! ;\
		sleep 1 ;\
		MON_QUIT=1 ./remotetest 6502

clean:
	rm *.o remotetest
