
.SILENT:

# override with "make EMUDIR=foo"
EMUDIR:=../../../trunk/vice/src
#$(info $$EMUDIR is [${EMUDIR}])
#$(info using EMU: [${EMU}])

# set the pathes to a compiled copy of the VICE tree, one configured with and
# the other without CPU-history logging

VICEDIRNOHIST=~/Desktop/vice/vice-emu/cleantrunk-nohist/vice/src/
VICEDIR=~/Desktop/vice/vice-emu/cleantrunk/vice/src/

dummytest.prg: dummytest.asm
	acme --cpu 6510 -f cbm -o dummytest.prg dummytest.asm

	
test:	dummytest.prg
	rm -f x64sc-on.txt
	$(VICEDIR)/x64sc +truedrive -warp -minimized -debugcart -monlogname x64sc-on.txt -moncommands dummytest.mon > /dev/null
#	sed -i -e 's:[ 0-9]*$$::g' x64sc-on.txt
	sed -i -e 's:[0-9][0-9][0-9] [0-9][0-9][0-9]$$::g' x64sc-on.txt
	sed -i -e 's:#[0-9]:--:g' x64sc-on.txt
#	cat x64sc-on.txt
	
	rm -f x64sc-off.txt
	$(VICEDIR)/x64sc +truedrive -warp -minimized -debugcart -monlogname x64sc-off.txt -moncommands dummyofftest.mon > /dev/null
	sed -i -e 's:[0-9][0-9][0-9] [0-9][0-9][0-9]$$::g' x64sc-off.txt
	sed -i -e 's:#[0-9]:--:g' x64sc-off.txt
#	cat x64sc-off.txt
	
	rm -f x64-on.txt
	$(VICEDIR)/x64   +truedrive -warp -minimized -debugcart -monlogname x64-on.txt -moncommands dummytest.mon > /dev/null
	sed -i -e 's:[0-9][0-9][0-9] [0-9][0-9][0-9]$$::g' x64-on.txt
	sed -i -e 's:#[0-9]:--:g' x64-on.txt
#	cat x64-on.txt

	rm -f x64-off.txt
	$(VICEDIR)/x64   +truedrive -warp -minimized -debugcart -monlogname x64-off.txt -moncommands dummyofftest.mon > /dev/null
	sed -i -e 's:[0-9][0-9][0-9] [0-9][0-9][0-9]$$::g' x64-off.txt
	sed -i -e 's:#[0-9]:--:g' x64-off.txt
#	cat x64-off.txt

	
testnohist: dummytest.prg
	rm -f x64sc-on-nohist.txt
	$(VICEDIRNOHIST)/x64sc +truedrive -warp -minimized -debugcart -monlogname x64sc-on-nohist.txt -moncommands dummytest.mon > /dev/null
#	sed -i -e 's:[ 0-9]*$$::g' x64sc-on-nohist.txt
	sed -i -e 's:[0-9][0-9][0-9] [0-9][0-9][0-9]$$::g' x64sc-on-nohist.txt
	sed -i -e 's:#[0-9]:--:g' x64sc-on-nohist.txt
#	cat x64sc-on-nohist.txt
	
	rm -f x64sc-off-nohist.txt
	$(VICEDIRNOHIST)/x64sc +truedrive -warp -minimized -debugcart -monlogname x64sc-off-nohist.txt -moncommands dummyofftest.mon > /dev/null
	sed -i -e 's:[0-9][0-9][0-9] [0-9][0-9][0-9]$$::g' x64sc-off-nohist.txt
	sed -i -e 's:#[0-9]:--:g' x64sc-off-nohist.txt
#	cat x64sc-off-nohist.txt
	
	rm -f x64-on-nohist.txt
	$(VICEDIRNOHIST)/x64   +truedrive -warp -minimized -debugcart -monlogname x64-on-nohist.txt -moncommands dummytest.mon > /dev/null
	sed -i -e 's:[0-9][0-9][0-9] [0-9][0-9][0-9]$$::g' x64-on-nohist.txt
	sed -i -e 's:#[0-9]:--:g' x64-on-nohist.txt
#	cat x64-on-nohist.txt

	rm -f x64-off-nohist.txt
	$(VICEDIRNOHIST)/x64   +truedrive -warp -minimized -debugcart -monlogname x64-off-nohist.txt -moncommands dummyofftest.mon > /dev/null
	sed -i -e 's:[0-9][0-9][0-9] [0-9][0-9][0-9]$$::g' x64-off-nohist.txt
	sed -i -e 's:#[0-9]:--:g' x64-off-nohist.txt
#	cat x64-off-nohist.txt

clean:
	@$(RM) x64sc-on.txt
	@$(RM) x64sc-off.txt
	@$(RM) x64-on.txt
	@$(RM) x64-off.txt
	@$(RM) x64sc-on-nohist.txt
	@$(RM) x64sc-off-nohist.txt
	@$(RM) x64-on-nohist.txt
	@$(RM) x64-off-nohist.txt
