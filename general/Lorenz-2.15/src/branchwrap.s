; original source file: n/a (broken), this was recreated from a disassembly
; slightly updated so the test does actually fail when it behaves wrong
;-------------------------------------------------------------------------------
        * = $0801

        .byte $12, $08, $08, $00
        .byte $97, $37, $38, $30
        .byte $2c, $30, $3a, $9e
        .byte $32, $30, $37, $33
        .byte 0,0,0

        lda #$01
        sta $030c
        jmp main

irqdisable
        lda #$7f
        sta $dc0d
        lda #$e3
        sta $00
        lda #$34
        sta $01
        rts

irqenable
        lda #$2f
        sta $00
        lda #$37
        sta $01
        lda #$81
        sta $dc0d
        rts

main
        jsr print
        .byte $0d
        .text "{up}branchwrap"
        .byte 0

        jsr irqdisable
        lda #$10  ; bpl
        sta $ffbe
        lda #$42  ; $0002
        sta $ffbf
        lda #$a9  ; lda #
        sta $ffc0
        lda #$00  ; $00
        sta $ffc1
        lda #$60  ; rts
        sta $ffc2
        lda #$a9  ; lda #
        sta $02
        lda #$01  ; $01
        sta $03
        lda #$60  ; rts
        sta $04
        lda #$4c  ; jmp
        sta $ff02
        lda #<failed
        sta $ff02
        lda #>failed
        sta $ff02
lp1
        ; flag cleared, branch taken
        ;
        ; NV-BDIZC 
        ; 00110000
        lda #$30
        pha
        plp
        jsr $ffbe
        ; $ffbe bpl, bvc, bcc, bne $0002
        ; $ffc0 lda #$00
        ; $ffc2 rts
        ; $0002 lda #$01    <-
        ; $0004 rts
        bne ok1
        jmp failed
ok1:        
        ; flag set, branch not taken
        ;
        ; NV-BDIZC 
        ; 11110011
        lda #$f3
        pha
        plp
        jsr $ffbe
        ; $ffbe bmi, bvs, bcs, beq $0002
        ; $ffc0 lda #$00    <-
        ; $ffc2 rts
        ; $0002 lda #$01
        ; $0004 rts
        beq ok2
        jmp failed
ok2:        
        
        clc
        lda $ffbe
        adc #$40
        sta $ffbe
        bcc lp1

        lda #$30  ; bmi
        sta $ffbe
        
lp2
        ; flag cleared, branch not taken
        ;
        ; NV-BDIZC 
        ; 00110000
        lda #$30
        pha
        plp
        jsr $ffbe
        ; $ffbe bpl, bvc, bcc, bne $0002
        ; $ffc0 lda #$00   <-
        ; $ffc2 rts
        ; $0002 lda #$01    
        ; $0004 rts
        beq ok3
        jmp failed
ok3:        
        ; flag set, branch taken
        ;
        ; NV-BDIZC 
        ; 11110011
        lda #$f3
        pha
        plp
        jsr $ffbe
        ; $ffbe bmi, bvs, bcs, beq $0002
        ; $ffc0 lda #$00    
        ; $ffc2 rts
        ; $0002 lda #$01    <-
        ; $0004 rts
        bne ok4
        jmp failed
ok4:        
        
        clc
        lda $ffbe
        adc #$40
        sta $ffbe
        bcc lp2
        
        jsr irqenable
        jmp passed
        
failed:        
        jsr print
        .text " - error"
        .byte $0d, 0

        lda #$ff       ; failure
        sta $d7ff
        lda #10
        sta $d020
        jmp *
        
passed:
        jsr print
        .text " - ok"
        .byte $0d, 0

        lda #0         ; success
        sta $d7ff
load
        lda #$2f
        sta $00
        jsr print

name     .text "mmufetch"
namelen  = *-name
         .byte 0
         lda #0
         sta $0a
         sta $b9
         lda #namelen
         sta $b7
         lda #<name
         sta $bb
         lda #>name
         sta $bc
         pla
         pla
         jmp $e16f

print    pla
         .block
         sta print0+1
         pla
         sta print0+2
         ldx #1
print0   lda !*,x
         beq print1
         jsr $ffd2
         inx
         bne print0
print1   sec
         txa
         adc print0+1
         sta print2+1
         lda #0
         adc print0+2
         sta print2+2
print2   jmp !*
         .bend
