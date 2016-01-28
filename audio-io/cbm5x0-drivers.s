;
; Marco van den Heuvel, 28.01.2016
;
; unsigned char __fastcall__ sampler_2bit_joy1_input(void);
; unsigned char __fastcall__ sampler_4bit_joy1_input(void);
;

        .export  _sampler_2bit_joy1_input
        .export  _sampler_4bit_joy1_input

        .importzp   sreg

setup_banking:
        ldx     $01
        ldy     #$0f
        sty     $01
        rts

load_joy1:
        ldy     #$dc
        sty     sreg + 1
        ldy     #$01
        sty     sreg
        dey
        lda     (sreg),y
        rts

_sampler_2bit_joy1_input:
        jsr     setup_banking
        jsr     load_joy1
        asl
        asl
        jmp     do_asl4

_sampler_4bit_joy1_input:
        jsr     setup_banking
        jsr     load_joy1
do_asl4:
        asl
        asl
        asl
        asl
        stx     $01
        rts
