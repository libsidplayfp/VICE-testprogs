;
; Marco van den Heuvel, 28.01.2016
;
; unsigned char __fastcall__ sampler_4bit_joy1_input(void);
;

        .export  _sampler_4bit_joy1_input

        .importzp   sreg

setup_banking:
        ldx     $01
        ldy     #$0f
        sty     $01
        rts

_sampler_4bit_joy1_input:
        jsr     setup_banking
        ldy     #$dc
        sty     sreg + 1
        ldy     #$01
        sty     sreg
        dey
        lda     (sreg),y
        asl
        asl
        asl
        asl
        stx     $01
        rts
