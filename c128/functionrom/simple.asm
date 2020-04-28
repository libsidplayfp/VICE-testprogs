;-------------------------------------------------------------------------------        
; minimal function ROM example, 16K ROM that starts at $8000
;-------------------------------------------------------------------------------        

        *= $8000
        jsr startfuncrom    ; yes, really JSR
        !byte 0,0,0         ; unused
        
        !byte 2             ; 0 = off, 1 = run early, >0 = run later
        !byte $43,$42,$4d   ; CBM

;-------------------------------------------------------------------------------        
    
startfuncrom:

; first we remove and check the return address: kernal checks for module id
; both at $8000 and at $c000. chips smaller than 32 K are visible multiple
; times, so the module could be entered twice. as we don't want that, we only
; act if called via $8000:

        pla             ; get low byte of "return address minus 1"
        pla             ; get high byte of "return address minus 1"
        cmp #$80
        beq +
        rts             ; if we were called via $c000, ignore
+
        ; bank in the kernal
        lda $ff00
        and #$ce
        sta $ff00

        ; put welcome message
        jsr $ff7d
        !pet "hello world",0 
        
        rts ; back to BASIC

;-------------------------------------------------------------------------------        
        
        ; this code must match c128 kernal for interrupts to work across banks:
        * = $bf05
!pseudopc $ff05 {
nmi_handler ; handler for NMI (at $ff05)
        sei
        pha
        txa
        pha
        tya
        pha
        lda $ff00
        pha
        lda #$00
        sta $ff00
        jmp ($0318)
irq_handler ; handler for IRQ and BRK (at $ff17)
        pha
        txa
        pha
        tya
        pha
        lda $ff00
        pha
        lda #$00
        sta $ff00
        tsx
        lda $0105,x
        and #$10
        beq +
        jmp ($0316)
+     
        jmp ($0314)
; general end-of-interrupt function (at $ff33)
        pla
        sta $ff00
        pla
        tay
        pla
        tax
        pla
        rti
reset_handler ; handler for RESET (at $ff3d)
        lda #$00
        sta $ff00
        jmp $e000
}

;-------------------------------------------------------------------------------        
; hardware vectors

        *= $bffa
        !word nmi_handler
        !word reset_handler
        !word irq_handler
