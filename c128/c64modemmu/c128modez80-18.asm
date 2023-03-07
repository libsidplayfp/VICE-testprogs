; This is a c128 mode z80 test to see what we get if we access $04xx through i/o using in/out when the mmu i/o bit is on and we are in bank 1,
; do we get $04xx bios, do we get $04xx ram bank 0, do we get $04xx ram bank 1, do we get $d4xx ram bank 0, or do we get $d4xx ram bank 1.
;
; test confirmed on real hardware
;
; colors:
;   black  = was not able to switch on the z80
;   white  = got z80 switched on, but no z80 bios present
;   cyan   = z80 on, z80 bios present in c128 mode, we got $04xx BIOS
;   violet = z80 on, z80 bios present in c128 mode, we got $04xx RAM bank 0
;   blue   = z80 on, z80 bios present in c128 mode, we got $d4xx RAM bank 0
;   yellow = z80 on, z80 bios present in c128 mode, we got $04xx RAM bank 1
;   brown  = z80 on, z80 bios present in c128 mode, we got $d4xx RAM bank 1
;   red    = something went very wrong during the test
;
; Test made by Marco van den Heuvel


start=$1c40

basicHeader=1 

!ifdef basicHeader {
; 10 SYS7181
*=$1c01
	!byte  $0c,$08,$0a,$00,$9e,$37,$31,$38,$31,$00,$00,$00
*=$1c0d 
	jmp start
}
*=start
; clear the screen
	lda #$93
	jsr $ffd2

	sei

; bank in bank 0 and bank in I/O
	lda #$3e
	sta $ff00

; no shared memory
	lda #$00
	sta $d506

; bank in bank 0 and bank out I/O
	lda #$3f
	sta $ff00

; put #$11 in $048d in bank 0
	lda #$11
	sta $048d

; put #$22 in $048e in bank 0
	lda #$22
	sta $048e

; put #$33 in $048f in bank 0
	lda #$33
	sta $048f

; put #$44 in $d48d in bank 0
	lda #$44
	sta $d48d

; put #$55 in $d48e in bank 0
	lda #$55
	sta $d48e

; put #$66 in $d48f in bank 0
	lda #$66
	sta $d48f

; bank in bank 0 and bank in I/O
	lda #$3e
	sta $ff00

; $c000-$ffff shared memory
	lda #$0b
	sta $d506

; copy $048d-$048f bank 1 byte put code into $c000 in shared memory
	ldx #$00
put_loop:
	lda put_bytes,x
	sta $c000,x
	inx
	bne put_loop

; run the code that puts data in $048d-$048f in bank 1
	jsr $c000

; $0000-$1fff shared memory
	lda #$06
	sta $d506

; bank in bank 1 and bank out I/O
	lda #$7f
	sta $ff00

; put #$aa in $d48d in bank 1
	lda #$aa
	sta $d48d

; put #$bb in $d48e in bank 1
	lda #$bb
	sta $d48e

; put #$cc in $d48f in bank 1
	lda #$cc
	sta $d48f

; bank in bank 0 and bank in I/O
	lda #$3e
	sta $ff00

; copy z80 code from bank 0 into bank 1
	ldx #$00
z80copyloop:
	jsr setbank0
	lda $2000,x
	jsr setbank1
	sta $2000,x
	jsr setbank0
	lda $2100,x
	jsr setbank1
	sta $2100,x
	jsr setbank0
	lda $2200,x
	jsr setbank1
	sta $2200,x
	jsr setbank0
	lda $2300,x
	jsr setbank1
	sta $2300,x
	jsr setbank0
	lda $2400,x
	jsr setbank1
	sta $2400,x
	jsr setbank0
	lda $2500,x
	jsr setbank1
	sta $2500,x
	jsr setbank0
	lda $2600,x
	jsr setbank1
	sta $2600,x
	jsr setbank0
	lda $2700,x
	jsr setbank1
	sta $2700,x
	inx
	bne z80copyloop
	jsr setbank0

; no shared memory
	lda #$00
	sta $d506

; change the border color to black
	lda #$00
	sta $d020

; jump to $2000 in bank 0
	jmp $2000

; set bank 0
setbank0:
	ldy #$3e
	sty $ff00
	rts

; set bank 1
setbank1:
	ldy #$7e
	sty $ff00
	rts

; this part will get copied to shared memory at $c000
put_bytes:

; bank in bank 1 and bank in I/O
	lda #$7e
	sta $ff00

; put #$77 in $048d in bank 1
	lda #$77
	sta $048d

; put #$88 in $048e in bank 1
	lda #$88
	sta $048e

; put #$99 in $048f in bank 1
	lda #$99
	sta $048f

; bank in bank 0 and bank in I/O
	lda #$3e
	sta $ff00
	rts
	
*=$2000
 
!binary "c128modez80-18.bin"
