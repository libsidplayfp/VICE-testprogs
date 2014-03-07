        !convtab pet
        !cpu 6510
        !to "scanner.prg", cbm

;-------------------------------------------------------------------------------

drivecode_start = $0300
drivecode_exec = drvstart ; skip $10 bytes table

        !src "../framework.asm"

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
lp:

        jsr rcv_wait

        jsr rcv_1byte           ; get track nr
        cmp #$ff
        beq recend
        tax
        inc $0400+(40*23)-1,x

        jsr rcv_1byte           ; get sector nr
        jsr rcv_1byte           ; get result code

        sta $0400+(40*21)-1,x

        ldx #$00
-
        jsr rcv_1byte
        sta $0400,x
        inx
        bne -

        jmp lp

recend:
        lda #5
        sta $d020
        jmp *

;-------------------------------------------------------------------------------

drivecode:
!pseudopc drivecode_start {
.data1 = $0700

        !src "../framework-drive.asm"

drvstart
        sei
        lda #$7a
        sta $1802
        ldy #$00
        sty $1800

drvlp

sect    lda #0
        sta $0f         ; sector
trk     lda #1
        sta $0e         ; track
        lda #$80        ; read block
        sta $04

        ; execute jobcode
        cli
        lda $04
        bmi *-2
        sei

        pha

        jsr snd_start

        lda trk+1
        jsr snd_1byte   ; send track nr
        lda sect+1
        jsr snd_1byte   ; send sector nr
        pla
        jsr snd_1byte   ; send result code

        ldy #$00
-
        lda .data1,y
        jsr snd_1byte
        iny
        bne -

        inc trk+1
        lda trk+1
        cmp #43
        beq drvend
        jmp drvlp
drvend:
        jsr snd_start
        lda #$ff
        jsr snd_1byte
        rts
} 
drivecode_end:
