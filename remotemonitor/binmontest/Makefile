CFLAGS=-g -O0

all: remotetest

remotetest: CuTest.o connection.o checkpoint.o util.o main.o
	$(CC) $(CFLAGS) -o remotetest $^

test: remotetest
	x64sc -default -binarymonitor -minimized > /dev/null & \
		PID=$$! ;\
		sleep 1 ;\
		MON_QUIT=1 ./remotetest 6502

clean:
	rm *.o remotetest
