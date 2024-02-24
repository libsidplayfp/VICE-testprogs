
EasyAPI_dest = $c800    ; 3 pages
EasyAPI_src = $b800     ; in cartridge
EAPIInit = EasyAPI_dest + $14

;-------------------------------------------------------------------------------
; bank 0 LO (8000-9fff)
    * = $c000
    !byte $ff

;-------------------------------------------------------------------------------
; bank 0 HI (e000-ffff) / (a000-bfff)
    * = $e000

reset:
    sei
    lda #$2f
    sta $00
    lda #$37
    sta $01

    lda #>$200
    sta $0319
    lda #<$200
    sta $0318
    lda #$40 ; RTI
    sta $0200

    lda #0
    sta $d015
    sta $d418
    sta $d020
    sta $d021
    lda #$1b
    sta $d011
    lda #$17
    sta $d018
    lda #$03
    sta $dd00
    lda #$c8
    sta $d016

    ldx #$ff
    txs
    
    ldx #0
clp1:
    lda copystub,x
    sta $0400,x
    inx
    bne clp1

    ldx #1
    jmp $0400

;-------------------------------------------------------------------------------
    
copystub:
        !pseudopc $0400 {
        lda #$07        ; switch to 16k game mode
        sta $de02
        stx $de00       ; bank nr.
        inx
        stx bnk2+1

        ; first 16k bank copied to $5000....$8fff
        ldy #$40
c2:
        ldx #0
c1:
c11:    lda $8000,x
c12:    sta $5000,x
        inx
        bne c1
        inc c11+2
        inc c12+2
        dey
        bne c2

bnk2:   lda #$02
        sta $de00

        ; second 16k bank copied $9000....$cfff
        ldy #$40
c3:
        ldx #0
c4:
c41:    lda $8000,x
c42:    sta $9000,x
        inx
        bne c4
        inc c41+2
        inc c42+2
        dey
        bne c3

                    ldx #0      ; first bank
                    stx $de00
                    ;lda #$07
                    ;sta $de02

                    ldx #0
copyEasyAPI         lda EasyAPI_src+$0000,x        ;copy EAPI-routines
                    sta EasyAPI_dest+$0000,x
                    lda EasyAPI_src+$0100,x
                    sta EasyAPI_dest+$0100,x
                    lda EasyAPI_src+$0200,x
                    sta EasyAPI_dest+$0200,x
                    inx
                    bne copyEasyAPI

                    jsr EAPIInit            ;$xx14. EAPIInit / modifies also EAPI_calls accordning to this
                    bcc +
                    ; if carry set, error
                    inc $d020
                    jmp * - 3
+
        lda #$04
        sta $de02
;        inc $d020
;        jmp *-3
        jmp $5000
        }

;-------------------------------------------------------------------------------
irq:
nmi:
            rti

;-------------------------------------------------------------------------------

    * = $e000 + $1800
;    !binary "eapi-am29f040-14",$0300,2
    !byte $65, $61, $70, $69 ; EAPI - whatever loads this should inject the EAPI

    * = $fffa
    !word nmi
    !word reset
    !word irq
