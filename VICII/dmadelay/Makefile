VICEOPTS=-default -minimize -VICIIfilter 0 -VICIIextpal -VICIIpalette pepto-pal -debugcart

TESTS=test1.prg test2.prg test3.prg test4.prg \
	test1-2a-03.prg \
	test1-2a-04.prg \
	test1-2a-10.prg \
	test1-2a-11.prg \
	test1-2a-16.prg \
	test1-2a-17.prg \
	test1-2a-18.prg \
	\
	test2-28-05.prg \
	test2-28-06.prg \
	test2-28-11.prg \
	test2-28-12.prg \
	test2-28-16.prg \
	test2-28-17.prg \
	test2-28-18.prg \
	\
	test3-28-07.prg \
	test3-28-08.prg \
	test3-28-13.prg \
	test3-28-14.prg \
	test3-28-18.prg \
	test3-28-19.prg \
	test3-28-1a.prg

all: $(TESTS)
	
test1.prg: dmadelay.s test1.s
	acme -f cbm -o test1.prg -DDEBUG=0 test1.s
test1-2a-03.prg: dmadelay.s test1.s
	acme -f cbm -o test1-2a-03.prg -DDEBUG=1 -DDEFXSTART=42 -DDEFXOFFS=3 test1.s
test1-2a-04.prg: dmadelay.s test1.s
	acme -f cbm -o test1-2a-04.prg -DDEBUG=1 -DDEFXSTART=42 -DDEFXOFFS=4 test1.s
test1-2a-10.prg: dmadelay.s test1.s
	acme -f cbm -o test1-2a-10.prg -DDEBUG=1 -DDEFXSTART=42 -DDEFXOFFS=16 test1.s
test1-2a-11.prg: dmadelay.s test1.s
	acme -f cbm -o test1-2a-11.prg -DDEBUG=1 -DDEFXSTART=42 -DDEFXOFFS=17 test1.s
test1-2a-16.prg: dmadelay.s test1.s
	acme -f cbm -o test1-2a-16.prg -DDEBUG=1 -DDEFXSTART=42 -DDEFXOFFS=22 test1.s
test1-2a-17.prg: dmadelay.s test1.s
	acme -f cbm -o test1-2a-17.prg -DDEBUG=1 -DDEFXSTART=42 -DDEFXOFFS=23 test1.s
test1-2a-18.prg: dmadelay.s test1.s
	acme -f cbm -o test1-2a-18.prg -DDEBUG=1 -DDEFXSTART=42 -DDEFXOFFS=24 test1.s

test2.prg: dmadelay.s test2.s
	acme -f cbm -o test2.prg -DDEBUG=0 test2.s
test2-28-05.prg: dmadelay.s test2.s
	acme -f cbm -o test2-28-05.prg -DDEBUG=1 -DDEFXSTART=40 -DDEFXOFFS=5 test2.s
test2-28-06.prg: dmadelay.s test2.s
	acme -f cbm -o test2-28-06.prg -DDEBUG=1 -DDEFXSTART=40 -DDEFXOFFS=6 test2.s
test2-28-11.prg: dmadelay.s test2.s
	acme -f cbm -o test2-28-11.prg -DDEBUG=1 -DDEFXSTART=40 -DDEFXOFFS=17 test2.s
test2-28-12.prg: dmadelay.s test2.s
	acme -f cbm -o test2-28-12.prg -DDEBUG=1 -DDEFXSTART=40 -DDEFXOFFS=18 test2.s
test2-28-16.prg: dmadelay.s test2.s
	acme -f cbm -o test2-28-16.prg -DDEBUG=1 -DDEFXSTART=40 -DDEFXOFFS=22 test2.s
test2-28-17.prg: dmadelay.s test2.s
	acme -f cbm -o test2-28-17.prg -DDEBUG=1 -DDEFXSTART=40 -DDEFXOFFS=23 test2.s
test2-28-18.prg: dmadelay.s test2.s
	acme -f cbm -o test2-28-18.prg -DDEBUG=1 -DDEFXSTART=40 -DDEFXOFFS=24 test2.s

test3.prg: dmadelay.s test3.s
	acme -f cbm -o test3.prg -DDEBUG=0 test3.s
test3-28-07.prg: dmadelay.s test3.s
	acme -f cbm -o test3-28-07.prg -DDEBUG=1 -DDEFXSTART=40 -DDEFXOFFS=7 test3.s
test3-28-08.prg: dmadelay.s test3.s
	acme -f cbm -o test3-28-08.prg -DDEBUG=1 -DDEFXSTART=40 -DDEFXOFFS=8 test3.s
test3-28-13.prg: dmadelay.s test3.s
	acme -f cbm -o test3-28-13.prg -DDEBUG=1 -DDEFXSTART=40 -DDEFXOFFS=19 test3.s
test3-28-14.prg: dmadelay.s test3.s
	acme -f cbm -o test3-28-14.prg -DDEBUG=1 -DDEFXSTART=40 -DDEFXOFFS=20 test3.s
test3-28-18.prg: dmadelay.s test3.s
	acme -f cbm -o test3-28-18.prg -DDEBUG=1 -DDEFXSTART=40 -DDEFXOFFS=24 test3.s
test3-28-19.prg: dmadelay.s test3.s
	acme -f cbm -o test3-28-19.prg -DDEBUG=1 -DDEFXSTART=40 -DDEFXOFFS=25 test3.s
test3-28-1a.prg: dmadelay.s test3.s
	acme -f cbm -o test3-28-1a.prg -DDEBUG=1 -DDEFXSTART=40 -DDEFXOFFS=26 test3.s

test4.prg: test4.s
	acme -f cbm -o test4.prg -DDEBUG=0 test4.s

screenshots1: all
	x64sc $(VICEOPTS) -exitscreenshot references/test1-2a-03.prg.png test1-2a-03.prg
	x64sc $(VICEOPTS) -exitscreenshot references/test1-2a-04.prg.png test1-2a-04.prg
	x64sc $(VICEOPTS) -exitscreenshot references/test1-2a-10.prg.png test1-2a-10.prg
	x64sc $(VICEOPTS) -exitscreenshot references/test1-2a-11.prg.png test1-2a-11.prg
	x64sc $(VICEOPTS) -exitscreenshot references/test1-2a-16.prg.png test1-2a-16.prg
	x64sc $(VICEOPTS) -exitscreenshot references/test1-2a-17.prg.png test1-2a-17.prg
	x64sc $(VICEOPTS) -exitscreenshot references/test1-2a-18.prg.png test1-2a-18.prg
	
screenshots2: all
	x64sc $(VICEOPTS) -exitscreenshot references/test2-28-05.prg.png test2-28-05.prg
	x64sc $(VICEOPTS) -exitscreenshot references/test2-28-06.prg.png test2-28-06.prg
	x64sc $(VICEOPTS) -exitscreenshot references/test2-28-11.prg.png test2-28-11.prg
	x64sc $(VICEOPTS) -exitscreenshot references/test2-28-12.prg.png test2-28-12.prg
	x64sc $(VICEOPTS) -exitscreenshot references/test2-28-16.prg.png test2-28-16.prg
	x64sc $(VICEOPTS) -exitscreenshot references/test2-28-17.prg.png test2-28-17.prg
	x64sc $(VICEOPTS) -exitscreenshot references/test2-28-18.prg.png test2-28-18.prg

screenshots3: all
	x64sc $(VICEOPTS) -exitscreenshot references/test3-28-07.prg.png test3-28-07.prg
	x64sc $(VICEOPTS) -exitscreenshot references/test3-28-08.prg.png test3-28-08.prg
	x64sc $(VICEOPTS) -exitscreenshot references/test3-28-13.prg.png test3-28-13.prg
	x64sc $(VICEOPTS) -exitscreenshot references/test3-28-14.prg.png test3-28-14.prg
	x64sc $(VICEOPTS) -exitscreenshot references/test3-28-18.prg.png test3-28-18.prg
	x64sc $(VICEOPTS) -exitscreenshot references/test3-28-19.prg.png test3-28-19.prg
	x64sc $(VICEOPTS) -exitscreenshot references/test3-28-1a.prg.png test3-28-1a.prg
	
screenshots: screenshots1 screenshots2 screenshots3
	
clean:
	$(RM) *~
	$(RM) $(TESTS)
