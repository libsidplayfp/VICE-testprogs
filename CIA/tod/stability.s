            *=$07ff
            !word $0801
            !word bend
            !word 10
            !byte $9e
            !text "2061", 0
bend:       !word 0
            jmp start
;-------------------------------------------------------------------------------

timebuf = $0800

            * = $0c00

; ~1.000.000 cycles per second
; ~  100.000 cycles per 10th sec

alarmirq:
            pha
            txa
            pha
            tya
            pha

            ldx atime1+1
            stx $d020

curroff:    ldx #1
oldoff:     ldy #0

            ; stop timer
            lda #%10000000
            sta $dc0e

            lda $dc04
            eor #$ff
            sta timebuf,x
            lda $dc05
            eor #$ff
            sta timebuf+$0100,x
            lda $dc06
            eor #$ff
            sta timebuf+$0200,x
            lda $dc07
            eor #$ff
            sta timebuf+$0300,x

            ; start timer
            lda #%10000001
            sta $dc0e

            sec
            lda timebuf,x
            sbc timebuf,y
            sta $0400,x
            lda timebuf+$0100,x
            sbc timebuf+$0100,y
            sta $0500,x
            ;lda timebuf+$0200,x
            ;sbc timebuf+$0200,y
            ;sta $0600,x
            inc curroff+1
            inc oldoff+1

            ; increment BCD counter
            inc atime1+1
            ldx atime1+1
            cpx #10
            bne sk1
            ldx #0
            stx atime1+1

            inc atime2+1
            lda atime2+1
            cmp #10
            bne sk2
            lda #$10
            sta atime2+1
sk2:
            cmp #$1a
            bne sk3
            lda #$20
            sta atime2+1
sk3:

            cmp #$2a
            bne sk4
            lda #$a9
            sta cont
sk4:

sk1:

            ; set new alarm time
            lda #%11000001      ; set alarm
            sta $dc0f

            lda #$00
            sta $dc0b
            ;lda #$00
            sta $dc0a
atime2:     ldx #$00
            stx $dc09
atime1:     lda #$01
            sta $dc08

            stx $d020

            lda $dc0d

            pla
            tay
            pla
            tax
            pla
            rti

;-------------------------------------------------------------------------------
start:
            lda #$20
            ldx #0
lp:
            sta $0400,x
            sta $0500,x
            sta $0600,x
            sta $0700,x
            inx
            bne lp

            sei
            lda #$35
            sta $01
            lda #>alarmirq
            sta $ffff
            lda #<alarmirq
            sta $fffe
            lda #$7f
            sta $dc0d

            ; stop timer
            lda #%10000000
            sta $dc0e
            lda #%01000000
            sta $dc0f

            lda #$ff
            sta $dc04
            sta $dc05
            sta $dc06
            sta $dc07

            ; start timer
            lda #%10010001
            sta $dc0e
            lda #%01010001      ; set clock
            sta $dc0f


            lda #$00
            sta $dc0b
            ;lda #$00
            sta $dc0a
            ;lda #$00
            sta $dc09
            ;lda #$00
            sta $dc08

            lda #%11000001      ; set alarm
            sta $dc0f

            lda #$00
            sta $dc0b
            ;lda #$00
            sta $dc0a
            ;lda #$00
            sta $dc09
            lda #$01
            sta $dc08

            ; enable alarm irq
            lda #$84
            sta $dc0d

            lda #$0b
            sta $d011

            lda $dc0d
            cli

            clc
cont:       bcc *       ; wait, 3 cycles latency

            lda #$7f
            sta $dc0d

            lda #$1b
            sta $d011

            ldx #0
lp1:
            lda $0400,x
            tay
            lda #'*'
            sta $0600,y

            inx
            bne lp1

            jmp *