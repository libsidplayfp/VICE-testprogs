
all: skew.d64 skew.g64

skew1.prg: skew1.asm
	acme $^

skew.d64: skew1.prg
	c1541 -format "skew,+h" d64 $@ -write "$^" "skew1"

skew.g64: skew1.prg
	c1541 -format "skew,+h" g64 $@ -write "$^" "skew1"

test: skew.d64
	x64sc -truedrive $^

test-g64: skew.g64
	x64sc -truedrive $^

test-old: skew.d64
	x64sc-2.3 -truedrive $^

clean:
	rm -f skew1.prg skew.d64 skew.g64
