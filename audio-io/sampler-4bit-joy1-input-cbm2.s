;
; Marco van den Heuvel, 27.01.2016
;
; unsigned char __fastcall__ sampler_4bit_joy1_input(void);
;

        .export     _sampler_4bit_joy1_input
        .importzp   sreg

_sampler_4bit_joy1_input:
        ldx     $01
        ldy     #$01
        sty     sreg
        ldy     #$dc
        sty     sreg + 1
        ldy     #$0f
        sty     $01
        ldy     #$00
        lda     (sreg),y
        asl
        asl
        asl
        asl
        stx     $01
        rts
