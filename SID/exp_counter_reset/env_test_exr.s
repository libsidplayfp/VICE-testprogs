    .macpack cbm
.macro dstatus msg
    ldx#msg-msg_base
    jsr status
.endmacro

v3_AD   = $d40e+5
v3_SR   = $d40e+6
v3_gate = $d40e+4
v3_env  = $d41c

res=$0400+40*10

    sei
    jsr wframe
    lda#0
    sta $d011
    sta $d020
    sta v3_AD
    sta v3_SR
    sta v3_gate

	lda #14
	sta $d021
	jsr $e536
    lda#$16
    sta $d018
    lda#0
    sta $d021

    jsr wframe
    jsr wframe
    lda#128
    sta noerr
    jsr test
    jsr wframe
    lda#$1b
    sta $d011

    lda noerr
    bpl :+
    jmp success
:   
    jmp fail

noerr:
    brk

wframe:
:   bit $d012
    bmi :-
:   bit $d012
    bpl :-
    rts

test:
    lda#$11  ; increase rate limit to 31
    sta v3_AD
    sta v3_SR
    lda#1
    sta v3_gate

    lda#48  ; st ecp to 8
:   cmp v3_env
    bne :-

    ldy#0
testl:

    lda gate0,y  ; 4
    sta v3_gate  ; 4
    lda gate1,y  ; 4
    sta v3_gate  ; 4

    lda v3_env   ; 4
    sta res,y    ; 5

    iny          ; 2
    cpy#40       ; 2
    bne testl    ; 3

    dey
refl:
    lda reference,y
    ora#$30
    sta res+40,y
    cmp res,y
    beq :+
    lda#2
    sta res-$0400+$d800,y
    lsr noerr
:
    dey
    bpl refl

    rts
    
gate0:
    .byt 1, 0,0,0,0,0,0,0,0, 0,1,1, 0,0,0,0,0,0,0,0, 0,0,0, 0,0,0,1,1,1,0,0, 0,0,0,0,0,0,0,0, 0
     ;                                                            ^ check brief attack with no rc reset
gate1:
    .byt 1, 0,0,0,0,0,0,0,0, 0,1,1, 0,0,0,0,0,0,0,0, 0,0,1, 0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0, 0
     ;                          ^ check attack with rc reset

reference:
    .byt 0, 1,1,1,1,1,1,1,1, 0,0,1, 2,2,2,2,2,2,2,2, 1,1,1, 2,2,2,2,2,2,2,2, 1,1,1,1,1,1,1,1, 0



success:
    dstatus msg_generic_pass
    lda #0  ; success
    beq common

fail:
    dstatus msg_generic_fail
    lda #$ff ; fail
    ;jmp common

common:
    sta $d7ff
    and #5+2
    eor #5
    pha
    jsr wframe
    pla
    sta $d020
    lda #$1b
    sta $d011
    cli
    jmp *


status:
    ldy#0
stl:
    lda msg_base,x
    cmp#160
    beq :+
    sta $0400+15*40,y
    inx
    iny
    bne stl
:
    rts

msg_base:
msg_generic_pass:
    scrcode "Test passed."
    .byte 160
msg_generic_fail:
    scrcode "Test failed."
    .byte 160
