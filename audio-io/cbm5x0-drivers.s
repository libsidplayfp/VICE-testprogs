;
; Marco van den Heuvel, 28.01.2016
;
; unsigned char __fastcall__ sampler_2bit_joy1_input(void);
; unsigned char __fastcall__ sampler_4bit_joy1_input(void);
; unsigned char __fastcall__ sampler_2bit_joy2_input(void);
; unsigned char __fastcall__ sampler_4bit_joy2_input(void);
;
; void __fastcall__ show_sample(unsigned char sample);
;

        .export  _sampler_2bit_joy1_input
        .export  _sampler_4bit_joy1_input
        .export  _sampler_2bit_joy2_input
        .export  _sampler_4bit_joy2_input

        .export  _show_sample

        .importzp   sreg

setup_banking:
        ldx     $01
        ldy     #$0f
        sty     $01
        rts

load_joy:
        ldy     #$dc
        sty     sreg + 1
        ldy     #$01
        sty     sreg
        dey
        lda     (sreg),y
        rts

_sampler_2bit_joy1_input:
        jsr     setup_banking
        jsr     load_joy
        asl
        asl
        jmp     do_asl4

_sampler_4bit_joy1_input:
        jsr     setup_banking
        jsr     load_joy
do_asl4:
        asl
        asl
do_asl2:
        asl
        asl
        stx     $01
        rts

_sampler_2bit_joy2_input:
        jsr     setup_banking
        jsr     load_joy
        and     #$f0
        stx     $01
        rts

_sampler_4bit_joy2_input:
        jsr     setup_banking
        jsr     load_joy
        and     #$30
        jmp     do_asl2

_show_sample:
        jsr     setup_banking
        ldy     #$d8
        sty     sreg + 1
        ldy     #$20
        sty     sreg
        ldy     #$00
        sta     (sreg),y
        rts
