        !convtab pet
        !cpu 6510
        !to "openbus.prg", cbm

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

        ; recieve the indirect RAM read result data
        ldx #$01
-
        jsr rcv_1byte
        sta $0400,x
        inx
        bne -

        ; receive the high-byte read result data
        ldx #$08
-
        jsr rcv_1byte
        sta $0600,x
        inx
        cpx #$78
        bne -

        ; blank out ignored data
        lda #$20
        ldx #$0f
-
        sta $0600 + $18,x
        sta $0600 + $38,x
        sta $0600 + $58,x
        dex
        bpl -

        ; check indirect RAM read data
        ldx #$00
-
        txa
        cmp $0401,x
        bne chkerr1
        inx
        cpx #$ff
        bne -

        ; check high-byte read data 08xx-17xx
        ldx #$08
-
        txa
        cmp $0600,x
        bne chkerr2
        inx
        cpx #$18
        bne -

        ; check high-byte read data 28xx-37xx
        ldx #$28
-
        txa
        cmp $0600,x
        bne chkerr2
        inx
        cpx #$38
        bne -

        ; check high-byte read data 48xx-57xx
        ldx #$48
-
        txa
        cmp $0600,x
        bne chkerr2
        inx
        cpx #$58
        bne -

        ; check high-byte read data 68xx-77xx
        ldx #$68
-
        txa
        cmp $0600,x
        bne chkerr2
        inx
        cpx #$78
        bne -

        ; all ok
        lda #5
        sta $d020
        jmp waitkey

chkerr1:
        lda #10
        sta $d020
        sta $d801,x             ; highlight mismatch
        jmp waitkey

chkerr2:
        lda #10
        sta $d020
        sta $da00,x             ; highlight mismatch
        jmp waitkey

waitkey:

        lda $d020
        and #$0f

        ldx #$ff    ; failure
        cmp #5      ; green
        bne fail2
        ldx #0      ; success
fail2:
        stx $d7ff

        cli
        jsr $ffe4
        cmp #" "
        bne waitkey
        jmp start
;-------------------------------------------------------------------------------

drivecode:
!pseudopc drivecode_start {
.wrdata   = $0700
.readdata = $0600
.openbus  = $0800

        !src "../framework-drive.asm"
drvstart
        sei
        jsr snd_init

        ; clear target area to force failure if is actually RAM instead of open bus
        ldx #$00
        txa
-
        sta .openbus,x
        inx
        bne -
        
        ; generate test data
        ldx #$00
-
        txa
        sta .wrdata,x
        inx
        bne -

        ; copy ram content via open bus and dummy cycle on indexing wrap
        ldx #$01
-
        lda .openbus - 1,x
        sta .readdata,x
        inx
        bne -

        ; some extra probes for high-byte-still-on-bus
        ; RAM/VIA mirrors will be skipped during validation on C64 side
        ldy #$23                ; arbitrary offset, must be less than $80
        sty $14
        ldy #$08
-
        sty $15
        lda ($14),y
        sta .wrdata,y
        iny
        cpy #$78
        bne -
        
        jsr snd_start

        ; send indirect read test data
        ldy #$01
-
        lda .readdata,y
        jsr snd_1byte
        iny
        bne -

        ; send high-byte-still-on-bus test data
        ldy #$08
-
        lda .wrdata,y
        jsr snd_1byte
        iny
        cpy #$78
        bne -

        ;rts
        sei
        jmp $eaa0       ; drive reset
} 
drivecode_end:
