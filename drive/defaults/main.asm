        !convtab pet
        !cpu 6510

;-------------------------------------------------------------------------------

drivecode_start = $0300
drivecode_exec = drvstart

        !src "../framework.asm"

;-------------------------------------------------------------------------------
start:
        jsr clrscr

        lda #<drivecode
        ldy #>drivecode
        ldx #((drivecode_end - drivecode) + $1f) / $20 ; upload x * $20 bytes to 1541
        jsr upload_code

        lda #<drivecode_exec
        ldy #>drivecode_exec
        jsr start_code

        sei
        jsr rcv_init

        ; some arbitrary delay
        ldx #0
        dex
        bne *-1

        jsr rcv_wait

        ; recieve the result data
        lda #>$0400
        sta nadr+2
        lda #<$0400
        sta nadr+1

        lda #>$d800
        sta cadr+2
        lda #<$d800
        sta cadr+1

        ldy #$08
--
        ldx #$00
-
        jsr rcv_1byte
nadr:   sta $0400,x
        lda cols1,x
cadr:   sta $d800,x
        inx
        cpx #$10
        bne -

        clc
        lda nadr+1
        adc #40
        sta nadr+1
        lda nadr+2
        adc #0
        sta nadr+2

        clc
        lda cadr+1
        adc #40
        sta cadr+1
        lda cadr+2
        adc #0
        sta cadr+2

        dey
        bne --

        lda #>($0400+(8*40))
        sta nadr2+2
        lda #<($0400+(8*40))
        sta nadr2+1

        lda #>($d800+(8*40))
        sta cadr2+2
        lda #<($d800+(8*40))
        sta cadr2+1


        ldy #$08
--
        ldx #$00
-
        jsr rcv_1byte
nadr2:   sta $0400,x
        lda cols2,x
cadr2:   sta $d800,x
        inx
        cpx #$10
        bne -

        clc
        lda nadr2+1
        adc #40
        sta nadr2+1
        lda nadr2+2
        adc #0
        sta nadr2+2

        clc
        lda cadr2+1
        adc #40
        sta cadr2+1
        lda cadr2+2
        adc #0
        sta cadr2+2

        dey
        bne --

        ; check data
        ldy #5
        sty iserr+1

        ldx #$00
-
        lda reference,x
        cmp $0400,x
        bne +
        lda #5
        sta $d800,x
+
        lda reference+$100,x
        cmp $0500,x
        bne +
        lda #5
        sta $d900,x
+
        lda reference+$200,x
        cmp $0600,x
        bne +
        lda #5
        sta $da00,x
+
        inx
        bne -

iserr:  lda #5
        sta $d020

        ldx #$ff        ; failure
        cmp #5
        bne fail
        ldx #$00        ;success
fail:
        stx $d7ff

        cli
waitkey
        jsr $ffe4
        cmp #" "
        bne waitkey
        jmp start
;-------------------------------------------------------------------------------

cols1: !byte $0a, $0a, $0a, $0a,  $07, $07, $0a, $0a,  $07, $07, $0a, $0a,  $0a, $0a, $0a, $0a
cols2: !byte $0a, $07, $0a, $0a,  $07, $07, $0a, $0a,  $07, $07, $0a, $0a,  $0a, $0a, $0a, $07

drivecode:
!pseudopc drivecode_start {
.data1 = $0700

        !src "../framework-drive.asm"
drvstart
        sei
        jsr snd_init

        ; generate test data
        ldx #$00
-
        lda $1800,x
        sta .data1,x
        lda $1c00,x
        sta .data1+$80,x
        inx
        bpl -

        jsr snd_start

        ; send test data
        ldy #$00
-
        lda .data1,y
        jsr snd_1byte
        iny
        bne -

        ;rts
        sei
        jmp $eaa0       ; drive reset
} 
drivecode_end:

reference:
        !binary "defaults.bin",,2