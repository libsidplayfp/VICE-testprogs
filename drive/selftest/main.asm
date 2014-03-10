        !convtab pet
        !cpu 6510
        !to "selftest.prg", cbm

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
        ldx #$00
-
        jsr rcv_1byte
        sta $0400,x
        lda $dd00
        sta $0600,x
        inx
        bne -

        ; check data
        ldx #$00
-
        txa
        cmp $0400,x
        bne chkerr
        inx
        bne -

        lda #5
        sta $d020
        jmp *
chkerr:
        lda #10
        sta $d020
        jmp *

;-------------------------------------------------------------------------------

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
        txa
        sta .data1,x
        eor #$80
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
        rts
} 
drivecode_end:
