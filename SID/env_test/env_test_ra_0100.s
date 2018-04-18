    .macpack cbm
    .include  "common.inc"

output_base    = $0450+ 2
reference_base = $0450+22
output_colour = (output_base & $3ff)+$d800

;
;  Tests startup timing for a waveform with ADSR=0000
;
;  Each column of the display contains readings from env3 4-15 cycles after attack is set to one.
;  each successive column attack is set one cycle later than the previous.
;

    .segment "CODE"
main:
    jsr copyref
    lda#15
    sta tv
    lda#1
    sta noErrs
loop:

    jsr hard_restart_and_blank_screen
    jsr sync_to_rc
    lda#$01
    sta v3_AD
    lda 3
    jsr wait_tv
    ldy#0
    lda#1
    sta v3_gate
    lda v3_env
    ldx v3_env
    ldy v3_env
    pha
    tya
    ldy tv
    sta output_base + 40* 8,y
    pla
    sta output_base + 40* 0,y
    txa
    sta output_base + 40* 4,y

    jsr rezero
    jsr sync_to_rc
    lda#$01
    sta v3_AD
    lda 3
    jsr wait_tv
    ldy#255
    lda#1
    sta v3_gate
    lda v3_env-255,y
    ldx v3_env
    ldy v3_env
    pha
    tya
    ldy tv
    sta output_base + 40* 9,y
    pla                
    sta output_base + 40* 1,y
    txa
    sta output_base + 40* 5,y

    jsr rezero
    jsr sync_to_rc
    lda#$01
    sta v3_AD
    lda 3
    jsr wait_tv
    ldy#0
    lda#1
    sta v3_gate
    nop
    lda v3_env
    ldx v3_env
    ldy v3_env
    pha
    tya
    ldy tv
    sta output_base + 40*10,y
    pla                
    sta output_base + 40* 2,y
    txa
    sta output_base + 40* 6,y

    jsr rezero
    jsr sync_to_rc
    lda#$01
    sta v3_AD
    lda 3
    jsr wait_tv
    ldy#0
    lda#1
    sta v3_gate
    lda 3
    lda v3_env
    ldx v3_env
    ldy v3_env
    pha
    tya
    ldy tv
    sta output_base + 40*11,y
    pla                
    sta output_base + 40* 3,y
    txa
    sta output_base + 40* 7,y

    lda#$00
    sta v3_AD


    ldx tv
    ldy#4
checkl:
    lda output_base    + 0,x
    cmp reference_base + 0,x
    jsr check
    sta output_colour  + 0,x

    lda output_base    + 160,x
    cmp reference_base + 160,x
    jsr check
    sta output_colour  + 160,x

    lda output_base    + 320,x
    cmp reference_base + 320,x
    jsr check
    sta output_colour  + 320,x
    txa
    axs#<-40
    dey
    bne checkl

    jsr wframe
    lda#$1b
    sta $d011
    dec tv
    bmi :+
    jmp loop
:
    lda noErrs
    beq :+
    jmp success
:   jmp fail


check:
    beq @ok
    lda#2
    lsr noErrs 
    rts
@ok:
    lda#5
    rts

noErrs:
    brk

wait_tv:
    sec
    lda#15
    sbc tv
    and#15
    sta :+ +1
:   bpl :-
    .byte $80,$80,$80,$80
    .byte $80,$80,$80,$80
    .byte $80,$80,$80,$80
    .byte $80,$80,$04,$ea
    rts

rezero:
    lda #0
    sta v3_AD
    sta v3_SR
    sta v3_gate
    cmp v3_env
    bne rezero
    rts

tv:
    brk

copyref:
    lda #<reference
    sta @s+1
    lda #>reference
    sta @s+2
    lda #<reference_base
    sta @d+1
    lda #>reference_base
    sta @d+2
    ldy#11
@r: ldx#15
@s: lda reference,x
@d: sta reference_base,x
    dex
    bpl @s
    clc
    lda @s+1
    adc#16
    sta @s+1
    bcc :+
    inc @s+2
    clc
:
    lda @d+1
    adc#40
    sta @d+1
    bcc :+
    inc @d+2
:
    dey
    bpl @r
    rts


msg_testname:
    scrcode "Note start, ADSR=0100",160

reference:
    .byte 0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0
    .byte 0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0
    .byte 0,0,0,0,0,0,1,0,1,0,0,0,0,0,0,1
    .byte 0,0,0,0,0,1,1,0,1,0,0,0,0,0,1,1
    .byte 0,0,0,0,1,1,1,0,1,0,0,0,0,1,1,1
    .byte 0,0,0,1,1,1,1,0,1,0,0,0,1,1,1,1
    .byte 0,0,1,1,1,1,1,0,1,0,0,1,1,1,1,1
    .byte 0,1,1,1,1,1,1,0,1,0,1,1,1,1,1,1
    .byte 1,1,1,1,1,1,1,0,1,1,1,1,1,1,1,1
    .byte 1,1,1,1,1,1,1,0,2,1,1,1,1,1,1,1
    .byte 1,1,1,1,1,1,1,0,2,1,1,1,1,1,1,1
    .byte 1,1,1,1,1,1,2,0,2,1,1,1,1,1,1,2
