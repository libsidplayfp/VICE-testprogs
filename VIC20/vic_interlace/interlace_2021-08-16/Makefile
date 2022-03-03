
XVIC=../../../../trunk/vice/src/xvic

all: analyze test9003nolace.prg test9004nolace.prg test9003top.prg \
	test9004top.prg test9003bot.prg test9004bot.prg analyze.prg test.d64

analyze: analyze.c
	$(CC) -o analyze analyze.c
#	./analyze "dumps/9003 nolace" "dumps/9004 nolace" > nolace.txt

test9004nolace.prg: test.asm
	acme -Doption=1 -Dreg=4 -f cbm -o test9004nolace.prg test.asm
test9003nolace.prg: test.asm
	acme -Doption=1 -Dreg=3 -f cbm -o test9003nolace.prg test.asm
test9004top.prg: test.asm
	acme -Doption=2 -Dreg=4 -f cbm -o test9004top.prg test.asm
test9003top.prg: test.asm
	acme -Doption=2 -Dreg=3 -f cbm -o test9003top.prg test.asm
test9004bot.prg: test.asm
	acme -Doption=3 -Dreg=4 -f cbm -o test9004bot.prg test.asm
test9003bot.prg: test.asm
	acme -Doption=3 -Dreg=3 -f cbm -o test9003bot.prg test.asm

analyze.prg: analyze.bas
	petcat -w2 -l 1201 -o analyze.prg -- analyze.bas

test.d64: test9003nolace.prg test9004nolace.prg test9003top.prg	test9004top.prg test9003bot.prg test9004bot.prg analyze.prg
	c1541 -format "test,00" d64 test.d64 \
		-write test9003nolace.prg test9003nolace \
		-write test9004nolace.prg test9004nolace \
		-write test9003top.prg test9003top \
		-write test9004top.prg test9004top \
		-write test9003bot.prg test9003bot \
		-write test9004bot.prg test9004bot \
		-write analyze.prg analyze \
		-list
	
testnolace: test9003nolace.prg test9004nolace.prg
	@$(RM) "9003-nolace"
	@$(RM) "9004-nolace"
	-$(XVIC) -minimized -ntsc -memory all -autostartprgmode 0 -warp +drive8truedrive -virtualdev8 -debugcart -limitcycles 400000000 test9003nolace.prg
	-$(XVIC) -minimized -ntsc -memory all -autostartprgmode 0 -warp +drive8truedrive -virtualdev8 -debugcart -limitcycles 400000000 test9004nolace.prg
testbot: test9003bot.prg test9004bot.prg
	@$(RM) "9003lacebot"
	@$(RM) "9004lacebot"
	-$(XVIC) -minimized -ntsc -memory all -autostartprgmode 0 -warp +drive8truedrive -virtualdev8 -debugcart -limitcycles 750000000 test9003bot.prg
	-$(XVIC) -minimized -ntsc -memory all -autostartprgmode 0 -warp +drive8truedrive -virtualdev8 -debugcart -limitcycles 750000000 test9004bot.prg
testtop: test9003top.prg test9004top.prg
	@$(RM) "9003lacetop"
	@$(RM) "9004lacetop"
	-$(XVIC) -minimized -ntsc -memory all -autostartprgmode 0 -warp +drive8truedrive -virtualdev8 -debugcart -limitcycles 700000000 test9003top.prg
	-$(XVIC) -minimized -ntsc -memory all -autostartprgmode 0 -warp +drive8truedrive -virtualdev8 -debugcart -limitcycles 700000000 test9004top.prg
	
test: analyze testnolace testbot testtop
	@$(RM) nolace.txt
	@$(RM) lacebot.txt
	@$(RM) lacetop.txt
	-./analyze "9003-nolace" "9004-nolace" > nolace.txt
	-./analyze "9003lacebot" "9004lacebot" > lacebot.txt
	-./analyze "9003lacetop" "9004lacetop" > lacetop.txt
	-diff -q "9003-nolace" "dumps/9003-nolace"
	-diff -q "9004-nolace" "dumps/9004-nolace"
	-diff -q "9003lacebot" "dumps/9003lacebot"
	-diff -q "9004lacebot" "dumps/9004lacebot"
	-diff -q "9003lacetop" "dumps/9003lacetop"
	-diff -q "9004lacetop" "dumps/9004lacetop"
	
clean:
	$(RM) analyze
	$(RM) nolace.txt lacebot.txt lacetop.txt
	$(RM) test9003nolace.prg test9004nolace.prg test9003top.prg
	$(RM) test9004top.prg test9003bot.prg test9004bot.prg
	$(RM) analyze.prg
	$(RM) test.d64
	$(RM) "9003-nolace" "9004-nolace"
	$(RM) "9003lacebot" "9004lacebot"
	$(RM) "9003lacetop" "9004lacetop"
