        !convtab pet
        !cpu 6510
        !to "pwm.prg", cbm

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

        jmp *

;-------------------------------------------------------------------------------

USEIRQ = 1

drivecode:
!pseudopc drivecode_start {

        !src "../framework-drive.asm"
drvstart
        sei
        jsr snd_init

!if (USEIRQ = 1) {
        lda #$80
        sta $1c04
        lda #$00
        sta $1c05

        lda #18         ; track nr
        sta $08  
        ldx #$00        ; sector nr
        stx $09  
        lda #$e0        ; seek and start program at $0400
        sta $01
        cli
        lda $01  
        bmi *-2
        ;sei

        rts
} else {
.drvlp
        jsr $0400
        jmp .drvlp

}
        ; irq/jobcode routine
        ;* = $0400
        !align $ff, 0, 0

pwmcnt: lda #0
        and #$0f
        tay

        lda $1c00
        and #%11110111
pwmaddr:
        ora pwmtab,y
        sta $1c00

        inc pwmcnt+1
        lda pwmcnt+1
!if (USEIRQ = 1) {
        cmp #$10
} else {
        ;cmp #$40
}
        bne .skp

pwmlvl: lda #0
        ;and #$0f
        asl
        asl
        asl
        asl
        clc
        adc #<pwmtab
        sta pwmaddr+1
        lda #0
        adc #>pwmtab
        sta pwmaddr+2

        ldx pwmlvl+1
dir:    lda #0
        bpl fadeup
        dex
        jmp .dirskp1
fadeup:
        inx
.dirskp1:
        txa
        and #$0f
        bne .dirskp2
        lda dir+1
        eor #$80
        sta dir+1
        jmp .dirskp3
.dirskp2:
        stx pwmlvl+1
.dirskp3:


.skp:
!if (USEIRQ = 1) {
        jmp $F99C       ; to job loop
} else {
        rts
}

pwmtab:
        !byte 8,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0 ;  1 / 16
        !byte 8,0,0,0, 0,0,0,0, 8,0,0,0, 0,0,0,0 ;  2 / 16
        !byte 8,0,0,0, 0,0,8,0, 0,0,0,8, 0,0,0,0 ;  3 / 16
        !byte 8,0,0,0, 8,0,0,0, 8,0,0,0, 8,0,0,0 ;  4 / 16

        !byte 8,0,0,8, 0,0,0,8, 0,0,8,0, 0,8,0,0 ;  5 / 16
        !byte 8,0,0,8, 0,8,0,8, 0,0,8,0, 0,8,0,0 ;  6 / 16
        !byte 8,0,8,0, 8,0,8,0, 0,8,0,8, 0,8,0,0 ;  7 / 16
        !byte 8,0,8,0, 8,0,8,0, 8,0,8,0, 8,0,8,0 ;  8 / 16

        !byte 8,8,8,0, 8,0,8,0, 8,0,8,0, 8,0,8,0 ;  9 / 16
        !byte 8,8,8,0, 8,0,8,0, 8,8,8,0, 8,0,8,0 ; 10 / 16
        !byte 8,8,8,0, 8,8,8,0, 8,8,8,0, 8,0,8,0 ; 11 / 16
        !byte 8,8,8,0, 8,8,8,0, 8,8,8,0, 8,8,8,0 ; 12 / 16

        !byte 8,8,8,0, 8,8,8,8, 0,8,8,8, 8,8,0,8 ; 13 / 16
        !byte 0,8,8,8, 8,8,8,8, 0,8,8,8, 8,8,8,8 ; 14 / 16
        !byte 8,8,8,8, 8,8,8,8, 0,8,8,8, 8,8,8,8 ; 15 / 16
        !byte 8,8,8,8, 8,8,8,8, 8,8,8,8, 8,8,8,8 ; 16 / 16
} 
drivecode_end:
