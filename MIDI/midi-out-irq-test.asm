; sample C64 MIDI out IRQ test with a DATEL MIDI interface
; provided by frank buss
; see patch #90 https://sourceforge.net/p/vice-emu/patches/90/

    * = $0801
		!byte $0f, $08, $de, $07, $9e, $20, $bd, $28, $37, $2e, $36, $34, $29, $00, $00
		!byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00

midiControl = $de04
midiStatus = $de06
midiTx = $de05
midiRx = $de07

start:
		; red border
		lda #2
		sta $d020
		
		; setup interrupt vector
		sei
		lda #<midiIrq
		sta $0314
		lda #>midiIrq
		sta $0315
		
		; switch off CIA-1 interrupts
		lda #$7f
		sta $dc0d

		; reset 6850
		lda #3
		sta midiControl
		
		; setup 6850, with transmit interrupt
		lda #$b6
		sta midiControl
		
		; transmit a byte
		lda #0
		;sta midiTx

		cli
		
		rts

midiIrq:	; change border color
		lda #5
		sta $d020
		
		; mask IRQ
		lda #$16
		sta midiControl

		jmp $ea31
