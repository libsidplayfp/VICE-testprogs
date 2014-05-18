TESTS=basicram-v1.sid basicram-v2.sid underbasic.sid underkernal.sid underio.sid

all: $(TESTS)

basicram-v1.sid: basicram.asm header.asm
	acme -Dheaderversion=1 -o basicram-v1.sid basicram.asm

basicram-v2.sid: basicram.asm header.asm
	acme -Dheaderversion=2 -o basicram-v2.sid basicram.asm

underbasic.sid: underbasic.asm header.asm
	acme -Dheaderversion=2 -o underbasic.sid underbasic.asm

underkernal.sid: underkernal.asm header.asm
	acme -Dheaderversion=2 -o underkernal.sid underkernal.asm

underio.sid: underio.asm header.asm
	acme -Dheaderversion=2 -o underio.sid underio.asm

clean:
	rm -f $(TESTS)
	