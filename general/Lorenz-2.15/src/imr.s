;---------------------------------------
;imr.asm - this file is part
;of the C64 Emulator Test Suite
;public domain, no copyright

         *= $0801
         .byte $4c,$14,$08,$00,$97
turboass = 780
         .text "780"
         .byte $2c,$30,$3a,$9e,$32,$30
         .byte $37,$33,$00,$00,$00

         .block
         lda #1
         sta turboass
         ldx #0
         stx $d3
         lda thisname
printthis
         jsr $ffd2
         inx
         lda thisname,x
         bne printthis
         sec
         jsr vector
         jsr main
         lda #$37
         sta 1
         lda #$2f
         sta 0
         clc
         jsr vector
         jsr $fda3
         jsr print
         .text " - ok"
         .byte 13,0
         lda #$00 ; success
         sta $d7ff
         .bend
loadnext
         .block
         ldx #$f8
         txs
         lda nextname
         cmp #"-"
         bne notempty
         jmp $a474
notempty
         ldx #0
printnext
         jsr $ffd2
         inx
         lda nextname,x
         bne printnext
         lda #0
         sta $0a
         sta $b9
         stx $b7
         lda #<nextname
         sta $bb
         lda #>nextname
         sta $bc
         jmp $e16f
         .bend

;---------------------------------------
;print text which immediately follows
;the JSR and return to address after 0

print
         .block
         pla
         sta next+1
         pla
         sta next+2
         ldx #1
next
         lda $1111,x
         beq end
         jsr $ffd2
         inx
         bne next
end
         sec
         txa
         adc next+1
         sta return+1
         lda #0
         adc next+2
         sta return+2
return
         jmp $1111
         .bend

;---------------------------------------
;print hex byte

printhb
         .block
         pha
         lsr a
         lsr a
         lsr a
         lsr a
         jsr printhn
         pla
         and #$0f
printhn
         ora #$30
         cmp #$3a
         bcc noletter
         adc #6
noletter
         jmp $ffd2
         .bend

;---------------------------------------
;wait until raster line is in border
;to prevent getting disturbed by DMAs

waitborder
         .block
         lda $d011
         bmi ok
wait
         lda $d012
         cmp #30
         bcs wait
ok
         rts
         .bend

;---------------------------------------
;wait for a key and check for STOP

waitkey
         lda #$ff ; failure
         sta $d7ff

         .block
         clc
         jsr vector
         jsr $fda3
         cli
wait
         jsr $ffe4
         beq wait
         cmp #3
         beq stop
         rts
stop
         lda turboass
         beq load
         jmp $8000
load
         jsr print
         .byte 13
         .text "break"
         .byte 13,0
         jmp loadnext
         .bend

;---------------------------------------
; vector save/restore

vector     ldx #<$334
           ldy #>$334
           jmp $ff8d

;---------------------------------------

thisname .null "imr"
nextname .null "flipos"

;---------------------------------------

irqwait   .byte 0

onirq
         lda #1
         sta irqwait

         lda $dc0d      ; ACK CIA1 IRQs
         pla
         tay
         pla
         tax
         pla
         rti

;---------------------------------------

main
         sei
         lda #<onirq
         sta $0314
         lda #>onirq
         sta $0315

;---------------------------------------
;set imr clock 2

         .block
         sei            ; disable IRQs
         jsr waitborder
         lda #0
         sta irqwait
         sta $dc0e      ; CIA1 TimerA stop
         sta $dc05      ; CIA1 TimerA Hi
.ifeq NEWCIA - 1
         lda #7
.endif
         sta $dc04      ; CIA1 TimerA Lo
         lda #$7f
         sta $dc0d      ; disable all CIA1 IRQs
         bit $dc0d      ; ACK pending CIA1 IRQs
         lda #%00011001
         sta $dc0e      ; CIA1 TimerA start, oneshot, force load
         cli            ; 2 cycles enable IRQs
         lda #$81       ; 2 cycles
         sta $dc0d      ; 4 cycles enable CIA1 TimerA IRQ
         sei            ; 2 cycles disable IRQs
         lda irqwait
         beq ok
         jsr print
         .byte 13
         .text "imr=$81 irq in clock 2"
         .byte 0
         jsr waitkey
ok
         cli
         .bend

;---------------------------------------
;set imr clock 3

         .block
         sei            ; disable IRQs
         jsr waitborder
         lda #0
         sta irqwait
         sta $dc0e      ; CIA1 TimerA stop
         sta $dc04      ; CIA1 TimerA Lo
         sta $dc05      ; CIA1 TimerA Hi
         lda #$7f
         sta $dc0d      ; disable all CIA1 IRQs
         bit $dc0d      ; ACK pending CIA1 IRQs
         lda #%00011001
         sta $dc0e      ; CIA1 TimerA start, oneshot, force load
         cli            ; 2 cycles enable CIA1 TimerA IRQ
         lda #$81       ; 2 cycles
         sta $dc0d      ; 4 cycles enable CIA1 TimerA IRQ
.ifeq NEWCIA - 1
         lda #2 ; 2 cycles
.else
         lda 2 ; 3 cycles
.endif
         lda irqwait
         bne ok
         jsr print
         .byte 13
         .text "imr=$81 no irq in clock 3"
         .byte 0
         jsr waitkey
ok
         .bend

;---------------------------------------
;clear imr

         .block
         sei            ; disable IRQs
         jsr waitborder
         lda #0
         sta irqwait
         sta $dc0e      ; CIA1 TimerA stop
         sta $dc04      ; CIA1 TimerA Lo
         sta $dc05      ; CIA1 TimerA Hi
         ; TimerA value = 0000
         lda #$7f
         sta $dc0d      ; disable all CIA1 IRQs
         bit $dc0d      ; ACK pending CIA1 IRQs
         lda #%00011001
         sta $dc0e      ; (4) CIA1 TimerA start, oneshot, force load
         lda #$81       ; (2)
         sta $dc0d      ; (4) enable CIA1 TimerA IRQ
         ; IRQs should happen now. if we would read from $dc0d, we would read $81
         lda #$7f       ; (2)
         sta $dc0d      ; (4)disable all CIA1 IRQs
         ; although IMR was cleared (and no more IRQs can occur), the value that
         ; will get read from $dc0d still has the respective bits set, it must
         ; be read once to ACK pending IRQs
         lda $dc0d      ; read IRQ mask and ACK IRQs

         ; we expect to read $81 here, indicate failure if not so
         cmp #$81
         beq ok
         jsr print
         .byte 13
         .text "imr=$7f may not clear int"
         .byte 0
         jsr waitkey
ok
         .bend

;---------------------------------------
end
         lda #<$ea31
         sta $0314
         lda #>$ea31
         sta $0315
         cli
         rts
