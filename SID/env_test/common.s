    .macpack cbm

.macro assert_same_page label_
   .assert >(label_) = >(*), error, "Page crossing detected!"
.endmacro

.macro dstatus msg
    lda#<msg
    ldx#>msg
    jsr status
.endmacro


v3_AD   = $d40e+5
v3_SR   = $d40e+6
v3_gate = $d40e+4
v3_env  = $d41c

    .import main, loop
    .import msg_testname

    .export v3_AD, v3_SR, v3_gate, v3_env
    .export hard_restart_and_blank_screen
    .export wframe
    .export sync_to_rc
    .export fail, success

;    .segment "STARTUP"

    lda#$7f
    sta $dc0d
    sei

@cpl:
    lda#32
    sta $0400,x
    sta $0500,x
    sta $0600,x
    sta $0700,x
    lda#14
    sta $d800,x
    sta $d900,x
    sta $da00,x
    sta $db00,x
    dex 
    bne @cpl
    lda #$16
    sta $d018
    jsr wframe
    stx $d020
    stx $d021
    jsr title
    jmp main

sync_to_rc:
    ;stabilise timing to a known point in the rate counter cycle
    lda#1
    sta v3_gate
:   cmp v3_env ; 0   Note that the addition chain below relies on the last comparison setting carry.
    bne :-     ;     doesn't matter if this crosses a page boundary, we have some slack in the loop and it's still 2 cycles if not taken.
    lda v3_env ; 6 (SID limit counter phase relative to what it was when above CMP was executed)
    adc v3_env ; 1
    adc v3_env ; 5
    adc v3_env ; 0 (This will always be 3, but we need the 4 cycle delay so why not)
    adc v3_env ; 4
    adc v3_env ; 8
    adc v3_env ; 3
    adc v3_env ; 7
    adc v3_env ; 2

    sbc#$1b
    cmp#9
    bcc :+
    dstatus msg_syncfail
    jmp _fail ; the emu being tested can't even manage to increment ENV3 every 9 cycles during attack
:
    sta :+ +1
:   bcc :-
    assert_same_page(:+)
    .byte $80,$80,$80,$80
    .byte $80,$80,$80,$04,$ea
:
    lda#0
    sta v3_gate
:   cmp v3_env
    bne :-
    nop
    nop
    nop
    rts



hard_restart_and_blank_screen:
    lda #0
    sta v3_AD
    sta v3_SR 
    sta v3_gate
    jsr wframe
    lda#0
    sta $d011
    sta $d020
    ;jmp wframe

wframe:
    bit $d011
    bpl *-3
    bit $d011
    bmi *-3
    rts

success:
    dstatus msg_generic_pass
    jmp _success
fail:
    dstatus msg_generic_fail

_fail:
    lda #$ff ; fail
    bmi _success+2

_success:
    lda #0  ; success
    sta $d7ff
    and #5+2
    eor #5
    pha
    jsr wframe
    pla
    sta $d020
    lda #$1b
    sta $d011
    jmp *


title:
    ldx#0

@src:
    lda msg_testname,x
    cmp#160
    beq :+
    sta $0400,x
    inx
    bne @src
:
    rts
status:
    sta @src+1
    stx @src+2
    ldx#0

@src:
    lda $0400,x
    cmp#160
    beq :+
    sta $0400+15*40,x
    inx
    bne @src
:
    rts



msg_syncfail:
    scrcode "Sync failed.",160

msg_generic_pass:
    scrcode "Test passed.",160
msg_generic_fail:
    scrcode "Test failed.",160

    .segment "ZPSAVE"
