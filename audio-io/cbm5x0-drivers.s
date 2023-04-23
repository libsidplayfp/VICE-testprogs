;
; Marco van den Heuvel, 28.01.2016
;
; unsigned char __fastcall__ sampler_2bit_multijoy_j1_input(void);
; unsigned char __fastcall__ sampler_4bit_multijoy_j1_input(void);
; unsigned char __fastcall__ sampler_2bit_multijoy_j2_input(void);
; unsigned char __fastcall__ sampler_4bit_multijoy_j2_input(void);
; unsigned char __fastcall__ sampler_2bit_joy1_input(void);
; unsigned char __fastcall__ sampler_4bit_joy1_input(void);
; unsigned char __fastcall__ sampler_2bit_joy2_input(void);
; unsigned char __fastcall__ sampler_4bit_joy2_input(void);
; void __fastcall__ sampler_multijoy_j1p1_input_init(void);
; void __fastcall__ sampler_multijoy_j1p2_input_init(void);
; void __fastcall__ sampler_multijoy_j1p3_input_init(void);
; void __fastcall__ sampler_multijoy_j1p4_input_init(void);
; void __fastcall__ sampler_multijoy_j1p5_input_init(void);
; void __fastcall__ sampler_multijoy_j1p6_input_init(void);
; void __fastcall__ sampler_multijoy_j1p7_input_init(void);
; void __fastcall__ sampler_multijoy_j1p8_input_init(void);
; void __fastcall__ sampler_multijoy_j2p1_input_init(void);
; void __fastcall__ sampler_multijoy_j2p2_input_init(void);
; void __fastcall__ sampler_multijoy_j2p3_input_init(void);
; void __fastcall__ sampler_multijoy_j2p4_input_init(void);
; void __fastcall__ sampler_multijoy_j2p5_input_init(void);
; void __fastcall__ sampler_multijoy_j2p6_input_init(void);
; void __fastcall__ sampler_multijoy_j2p7_input_init(void);
; void __fastcall__ sampler_multijoy_j2p8_input_init(void);
;
; void __fastcall__ show_sample(unsigned char sample);
;

        .export  _sampler_2bit_joy1_input
        .export  _sampler_4bit_joy1_input
        .export  _sampler_2bit_joy2_input
        .export  _sampler_4bit_joy2_input
        .export  _sampler_2bit_multijoy_j1_input
        .export  _sampler_4bit_multijoy_j1_input
        .export  _sampler_2bit_multijoy_j2_input
        .export  _sampler_4bit_multijoy_j2_input
        .export  _sampler_multijoy_j1p1_input_init
        .export  _sampler_multijoy_j1p2_input_init
        .export  _sampler_multijoy_j1p3_input_init
        .export  _sampler_multijoy_j1p4_input_init
        .export  _sampler_multijoy_j1p5_input_init
        .export  _sampler_multijoy_j1p6_input_init
        .export  _sampler_multijoy_j1p7_input_init
        .export  _sampler_multijoy_j1p8_input_init
        .export  _sampler_multijoy_j2p1_input_init
        .export  _sampler_multijoy_j2p2_input_init
        .export  _sampler_multijoy_j2p3_input_init
        .export  _sampler_multijoy_j2p4_input_init
        .export  _sampler_multijoy_j2p5_input_init
        .export  _sampler_multijoy_j2p6_input_init
        .export  _sampler_multijoy_j2p7_input_init
        .export  _sampler_multijoy_j2p8_input_init

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

init_multijoy_j1:
        jsr     setup_banking
        ldy     #$dc
        sty     sreg + 1
        ldy     #$03
        sty     sreg
        ldy     #$00
        pha
        lda     #$f0
        sta     (sreg),y
        ldy     #$01
        sty     sreg
        dey
        pla
        sta     (sreg),y
        stx     $01
        rts

init_multijoy_j2:
        jsr     setup_banking
        ldy     #$dc
        sty     sreg + 1
        ldy     #$01
        sty     sreg
        ldy     #$02
        pha
        lda     #$0f
        sta     (sreg),y
        ldy     #$00
        pla
        sta     (sreg),y
        stx     $01
        rts

_sampler_multijoy_j1p1_input_init:
        lda     #$00
        jmp     init_multijoy_j1

_sampler_multijoy_j1p2_input_init:
        lda     #$10
        jmp     init_multijoy_j1

_sampler_multijoy_j1p3_input_init:
        lda     #$20
        jmp     init_multijoy_j1

_sampler_multijoy_j1p4_input_init:
        lda     #$30
        jmp     init_multijoy_j1

_sampler_multijoy_j1p5_input_init:
        lda     #$40
        jmp     init_multijoy_j1

_sampler_multijoy_j1p6_input_init:
        lda     #$50
        jmp     init_multijoy_j1

_sampler_multijoy_j1p7_input_init:
        lda     #$60
        jmp     init_multijoy_j1

_sampler_multijoy_j1p8_input_init:
        lda     #$70
        jmp     init_multijoy_j1

_sampler_multijoy_j2p1_input_init:
        lda     #$00
        jmp     init_multijoy_j2

_sampler_multijoy_j2p2_input_init:
        lda     #$01
        jmp     init_multijoy_j2

_sampler_multijoy_j2p3_input_init:
        lda     #$02
        jmp     init_multijoy_j2

_sampler_multijoy_j2p4_input_init:
        lda     #$03
        jmp     init_multijoy_j2

_sampler_multijoy_j2p5_input_init:
        lda     #$04
        jmp     init_multijoy_j2

_sampler_multijoy_j2p6_input_init:
        lda     #$05
        jmp     init_multijoy_j2

_sampler_multijoy_j2p7_input_init:
        lda     #$06
        jmp     init_multijoy_j2

_sampler_multijoy_j2p8_input_init:
        lda     #$07
        jmp     init_multijoy_j2

_sampler_2bit_joy1_input:
_sampler_2bit_multijoy_j1_input:
        jsr     setup_banking
        jsr     load_joy
        asl
        asl
        jmp     do_asl4

_sampler_4bit_joy1_input:
_sampler_4bit_multijoy_j1_input:
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

_sampler_4bit_joy2_input:
_sampler_4bit_multijoy_j2_input:
        jsr     setup_banking
        jsr     load_joy
        and     #$f0
        stx     $01
        rts

_sampler_2bit_joy2_input:
_sampler_2bit_multijoy_j2_input:
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
        tax
        lsr
        lsr
        lsr
        lsr
        sta     (sreg),y
        txa
        rts
