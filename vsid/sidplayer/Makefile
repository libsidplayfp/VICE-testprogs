
all: scrollmachine.prg scrollmachine.sid scrollmachine-mus.sid fallinginlove.prg fallinginlove.sid

scrollmachine.prg: scrollmachine.s main.s cgplayer.s cgplayercore.s
	cl65 --asm-define FORMAT=0 -o scrollmachine.prg scrollmachine.s

scrollmachine.sid: scrollmachine.s main.s cgplayer.s cgplayercore.s header.s
	cl65 --asm-define FORMAT=1 --start-addr 0xf82 -t none -o scrollmachine.sid scrollmachine.s

scrollmachine-mus.sid: scrollmachine.s main.s cgplayer.s cgplayercore.s header.s
	cl65 --asm-define FORMAT=2 --start-addr 0xf82 -t none -o scrollmachine-mus.sid scrollmachine.s

fallinginlove.prg: fallinginlove.s main.s cgplayer.s cgplayercore.s
	cl65 --asm-define FORMAT=0 -o fallinginlove.prg fallinginlove.s

fallinginlove.sid: fallinginlove.s main.s cgplayer.s cgplayercore.s header.s
	cl65 --asm-define FORMAT=1 --start-addr 0xf82 -t none -o fallinginlove.sid fallinginlove.s

test: scrollmachine.prg	
	x64 -ntsc scrollmachine.prg
	
teststereo: fallinginlove.prg	
	x64 -ntsc -sidstereo 1 -sidstereoaddress 0xd500 fallinginlove.prg
	
.phony: clean zap
clean:
	rm -f *~
	rm -f *.o
zap: clean
	rm -f scrollmachine.prg
	rm -f scrollmachine.sid
	rm -f scrollmachine-mus.sid
	rm -f fallinginlove.prg
	rm -f fallinginlove.sid
