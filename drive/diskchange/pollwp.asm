        !convtab pet
        !cpu 6510
        !to "pollwp.prg", cbm

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

        jsr rcv_1byte
        cmp #1
        beq isoff
mlp

ison:
        lda #1
        sta $d020
        
        lda #<lineon
        ldy #>lineon
        jsr printstr

        jsr starttimer

isonlp
        jsr rcv_1byte
        cmp #0
        beq isonlp

        jsr printtimer

isoff:
        lda #0
        sta $d020

        lda #<lineoff
        ldy #>lineoff
        jsr printstr

        jsr starttimer
        
isofflp
        jsr rcv_1byte
        cmp #1
        beq isofflp

        jsr printtimer

        jmp mlp

starttimer:
        
        lda #0
        sta $dc0e
        sta $dc0f

        lda #$ff
        sta $dc04
        sta $dc05
        sta $dc06
        sta $dc07
        lda #$11
        sta $dc0e
        lda #$51
        sta $dc0f

        rts
        
printtimer:
        lda #0
        sta $dc0e
        sta $dc0f

        lda $dc07
        eor #$ff
        jsr printhex
        lda $dc06
        eor #$ff
        jsr printhex

        lda $dc05
        eor #$ff
        jsr printhex
        lda $dc04
        eor #$ff
        jsr printhex

        rts
        
printhex:
        pha
        lsr
        lsr
        lsr
        lsr
        tax
        lda hextab1,x
        jsr $ffd2
        pla
        and #$0f
        tax
        lda hextab1,x
        jsr $ffd2
        sei
        rts
hextab1:
        !pet "0123456789abcdef"
        
printstr:
        sta .ptr+1
        sty .ptr+2
        ldy #0
.prinrlp
.ptr    lda $dead,y
        beq .printend
        jsr $ffd2
        iny
        bne .prinrlp
.printend
        sei
        rts

lineoff:
        !pet 13, "write-protect is off ", 0
lineon:
        !pet 13, "write-protect is on  ", 0
        
;-------------------------------------------------------------------------------

drivecode:
!pseudopc drivecode_start {

        !src "../framework-drive.asm"
drvstart
        sei
        jsr snd_init

        jsr snd_start

drvlp:
        lda $1c00
        lsr
        lsr
        lsr
        lsr
        and #$01
        jsr snd_1byte

        jmp drvlp
} 
drivecode_end:
