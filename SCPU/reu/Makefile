
XSCPU =  /Applications/vice-arm64-gtk3-3.9/bin/xscpu64
X64SC =  /Applications/vice-arm64-gtk3-3.9/bin/x64sc

dmatest.prg: dmatest.s
	cl65 -t none --start-addr 2047 $^ -o $@

run: dmatest.prg
	#$(XSCPU) dmatest.prg
	$(X64SC) dmatest.prg
