        !convtab pet
        !cpu 6510
        !to "watchdog.prg", cbm

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

        lda #5
        sta $d020

        sei
        jsr rcv_init

        ldx #0
-
        dex
        bne -

        jsr rcv_wait
waitlp:
        jsr rcv_1byte
        sta $0400
        jsr rcv_1byte
        sta $0401
        inc $0500

        lda $0400
        cmp #$23
        beq waitlp

testerr:
        lda #10
        sta $d020

        jsr rcv_1byte
        sta $0403
        jsr rcv_1byte
        sta $0404

        jmp *

;-------------------------------------------------------------------------------

drivecode:
!pseudopc drivecode_start {
.data1 = $0600
.data2 = $0700

        !src "../framework-drive.asm"
drvstart
        sei
        jsr snd_init

        lda #17         ; track nr
        sta $08
        ldx #$00        ; sector nr
        stx $09
        lda #$e0        ; seek and start program at $0400
        sta $01

        cli
        lda .drvwait+1
        cmp .drvwait+1
        beq *-3
        sei

        lda #%01100000
        sta $1c0b

        ; krill-loader uses $80xx
        lda #$00
        sta $1c04
        lda #$80
        sta $1c05

        ; disable IRQs
        lda #$7f
        sta $1c0e

        lda $1c0d
        sta $1c0d

        ; enable timer A irq
        lda #%11000000
        sta $1c0e


        sei
        jsr snd_start

.drvwaitlp:

        ; retrigger
        lda #$80
        sta $1c05
        sta .drvresetflg+1
.drvwait:
        lda #$23 - 1
        jsr snd_1byte

        ; waste some time to allow the irq to trigger
        cli
        ldx #$80
-
        dex
        bne -
        sei

        ; retrigger
        lda #$80
        sta $1c05
        sta .drvresetflg+1
.drvcnt:
        lda #$ae
        jsr snd_1byte

        ; waste some time to allow the irq to trigger
        cli
        ldx #$80
-
        dex
        bne -
        sei

        inc .drvcnt+1
        jmp .drvwaitlp

        ; irq/jobcode routine
        * = $0400

.drvresetflg:
        lda #$00
        bne .dodrvreset

; the system irq handler has already cleared the flag by reading $1c04
;        lda $1c04

        inc .drvwait+1

        jmp $F99C       ; to job loop

.dodrvreset:
        sei
        jmp $eaa0       ; drive reset
} 
drivecode_end:
