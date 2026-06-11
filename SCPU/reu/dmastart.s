
; related to bug #2233

		!cpu 6502
		!to "dmastart.prg",cbm

status = 0xdf00
command = 0xdf01
c64base = 0xdf02
reubase = 0xdf04
translen = 0xdf07
irqmask = 0xdf09
control = 0xdf0a

execute = 0x80
command_reserved = 0x4c
load = 0x20
ff00 = 0x10
transfer_verify = 0x03
transfer_swap = 0x02
transfer_reu_c64 = 0x01
transfer_c64_reu = 0x00

		* = $0801
		!word entry-2
		!byte $00,$00,$9e
		!text "2066"
		!byte $00,$00,$00

		* = $0812
entry
		lda #'P'
		sta $c000
		lda #'A'
		sta $c001
		lda #'S'
		sta $c002
		lda #'S'
		sta $c003
		lda #'\n'
		sta $c004

		lda #$00
		sta control
		sta c64base
		sta reubase
		sta reubase + 2
		sta translen
		lda #$01
		sta translen + 1

		ldx #$c0
		lda #$00

		stx c64base + 1
		sta reubase
		lda #execute | ff00 | load | transfer_c64_reu
		sta command
		; bit status

		lda #'F'
		sta $c000
		lda #'A'
		sta $c001
		lda #'I'
		sta $c002
		lda #'L'
		sta $c003
		lda #'\n'
		sta $c004

		ldx #$c0
		lda #$00

		stx c64base + 1
		sta reubase + 1
		lda #execute | ff00 | load | transfer_reu_c64
		sta command
		; bit status

		ldy #$00
print_loop
		lda $c000,y
		jsr $ffd2
		iny
		cpy #$05
		bne print_loop

		lda $c000
		cmp #'F'
		beq fail

		lda #5
		sta $d020
		lda #0
		sta $d7ff
		jmp *

fail:
		lda #10
		sta $d020
		lda #$ff
		sta $d7ff
		jmp *
