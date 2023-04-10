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

        ; recieve the result data
        ldx #$01
-
        jsr rcv_1byte
        sta $0400,x
        inx
        bne -

        ; check data
        ldx #$00
-
        txa
        cmp $0401,x
        bne chkerr
        inx
        cpx #$ff
        bne -

        lda #5
        sta $d020
        jmp waitkey
chkerr:
        lda #10
        sta $d020
        sta $d801,x             ; highlight mismatch
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
        
        jsr snd_start

        ; send test data
        ldy #$01
-
        lda .readdata,y
        jsr snd_1byte
        iny
        bne -

        ;rts
        sei
        jmp $eaa0       ; drive reset
} 
drivecode_end:
