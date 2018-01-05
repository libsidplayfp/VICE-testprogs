
;VERSION = 0
DEBUG = 1

firstirqline = $b
screen = $0400

            *=$0801
            !word bend
            !word 10
            !byte $9e
            !text "2061", 0
bend:       !word 0
            jmp start

;-------------------------------------------------------------------------------
start:
            ;sei
            ; disable CIA irq
            lda #$7f
            sta $dc0d
            ; if irq is pending, it will trigger on next instruction
            lda #>irq0
            sta $ffff
            lda #<irq0
            sta $fffe

            lda #firstirqline
            sta $d012
            lda #$1b
            sta $d011

            lda #$35
            sta $01

            ; enable raster irq
            lda #$01
            sta $d01a
            ;cli
            
            ldx #0
-
            txa
            sta screen,x
            lda #1
            sta $d800,x
            inx
            bne -

            ; wait for space
-
            lda $dc01
            cmp #$ef
            bne -
            inc $d020
            dec $d020
            lda $d020,x
            inx
            jmp -

;-------------------------------------------------------------------------------

            * = $0900
irq0:
            pha
            txa
            pha
            tya
            pha

            !if DEBUG = 1 {
            inc $d020
            }

fldoffs1 = * + 1
            lda #$30
            jsr dofld
            !if DEBUG = 1 {
            inc $d020
            }
fldoffs2 = * + 1
            lda #$30+(8*3)
-           
            cmp $d012
            bcs -
            !if DEBUG = 1 {
            inc $d020
            }
            lda #$30+(8*3)+16
            jsr dofld
            
            !if DEBUG = 1 {
            inc $d020
            }
            jsr dofldsinus
            !if DEBUG = 1 {
            lda #0
            sta $d020
            }
            
            pla
            tay
            pla
            tax
            pla
            inc $d019
            rti

;-------------------------------------------------------------------------------

            * = $0a00

dofld:
            sta fldstop + 1
-
            ldx $d012       ; 4
fldstop:
            cpx #0          ; 2
            beq +           ; 2
            dex             ; 2
            txa             ; 2
            and #$07        ; 2
            ora #$18        ; 2
            sta $d011       ; 4
            !if VERSION = 1 {
            stx $d020       ; 4
            sta $d020       ; 4
            stx $d020       ; 4
            sta $d020       ; 4
            stx $d020       ; 4
            sta $d020       ; 4
            stx $d020       ; 4
            sta $d020       ; 4
            stx $d020       ; 4
            sta $d020       ; 4
            } else {
            bit $eaea       ; 4
            bit $eaea       ; 4
            bit $eaea       ; 4
            bit $eaea       ; 4
            bit $eaea       ; 4
            bit $eaea       ; 4
            bit $eaea       ; 4
            bit $eaea       ; 4
            bit $eaea       ; 4
            bit $eaea       ; 4
            }
            bne -           ; 3
+
            rts

dofldsinus:
            inc fldsinuscnt + 1

fldsinuscnt:
            lda #0
            and #$1f
            tax
            lda fldsinus,x
            clc
            adc #$30
            sta fldoffs1
            clc
            adc #(8*3)-1
            sta fldoffs2
            rts

fldsinus:
    !byte $00, $00, $00, $00, $01, $01, $02, $03, $04, $05, $07, $08, $0a, $0b, $0d, $0f
    !byte $0f, $0d, $0b, $0a, $08, $07, $05, $04, $03, $02, $01, $01, $00, $00, $00, $00
