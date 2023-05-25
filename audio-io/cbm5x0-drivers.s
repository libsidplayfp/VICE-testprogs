;
; Marco van den Heuvel, 28.01.2016
;
; unsigned char __fastcall__ sampler_2bit_joy1_input(void);
; unsigned char __fastcall__ sampler_4bit_joy1_input(void);
; unsigned char __fastcall__ sampler_2bit_joy2_input(void);
; unsigned char __fastcall__ sampler_4bit_joy2_input(void);
; unsigned char __fastcall__ sampler_2bit_inception_j1p1_input(void);
; unsigned char __fastcall__ sampler_2bit_inception_j1p2_input(void);
; unsigned char __fastcall__ sampler_2bit_inception_j1p3_input(void);
; unsigned char __fastcall__ sampler_2bit_inception_j1p4_input(void);
; unsigned char __fastcall__ sampler_2bit_inception_j1p5_input(void);
; unsigned char __fastcall__ sampler_2bit_inception_j1p6_input(void);
; unsigned char __fastcall__ sampler_2bit_inception_j1p7_input(void);
; unsigned char __fastcall__ sampler_2bit_inception_j1p8_input(void);
; unsigned char __fastcall__ sampler_4bit_inception_j1p1_input(void);
; unsigned char __fastcall__ sampler_4bit_inception_j1p2_input(void);
; unsigned char __fastcall__ sampler_4bit_inception_j1p3_input(void);
; unsigned char __fastcall__ sampler_4bit_inception_j1p4_input(void);
; unsigned char __fastcall__ sampler_4bit_inception_j1p5_input(void);
; unsigned char __fastcall__ sampler_4bit_inception_j1p6_input(void);
; unsigned char __fastcall__ sampler_4bit_inception_j1p7_input(void);
; unsigned char __fastcall__ sampler_4bit_inception_j1p8_input(void);
; unsigned char __fastcall__ sampler_2bit_inception_j2p1_input(void);
; unsigned char __fastcall__ sampler_2bit_inception_j2p2_input(void);
; unsigned char __fastcall__ sampler_2bit_inception_j2p3_input(void);
; unsigned char __fastcall__ sampler_2bit_inception_j2p4_input(void);
; unsigned char __fastcall__ sampler_2bit_inception_j2p5_input(void);
; unsigned char __fastcall__ sampler_2bit_inception_j2p6_input(void);
; unsigned char __fastcall__ sampler_2bit_inception_j2p7_input(void);
; unsigned char __fastcall__ sampler_2bit_inception_j2p8_input(void);
; unsigned char __fastcall__ sampler_4bit_inception_j2p1_input(void);
; unsigned char __fastcall__ sampler_4bit_inception_j2p2_input(void);
; unsigned char __fastcall__ sampler_4bit_inception_j2p3_input(void);
; unsigned char __fastcall__ sampler_4bit_inception_j2p4_input(void);
; unsigned char __fastcall__ sampler_4bit_inception_j2p5_input(void);
; unsigned char __fastcall__ sampler_4bit_inception_j2p6_input(void);
; unsigned char __fastcall__ sampler_4bit_inception_j2p7_input(void);
; unsigned char __fastcall__ sampler_4bit_inception_j2p8_input(void);
;
; void __fastcall__ show_sample(unsigned char sample);
;

        .export  _sampler_2bit_joy1_input
        .export  _sampler_4bit_joy1_input
        .export  _sampler_2bit_joy2_input
        .export  _sampler_4bit_joy2_input
        .export  _sampler_2bit_inception_j1p1_input
        .export  _sampler_2bit_inception_j1p2_input
        .export  _sampler_2bit_inception_j1p3_input
        .export  _sampler_2bit_inception_j1p4_input
        .export  _sampler_2bit_inception_j1p5_input
        .export  _sampler_2bit_inception_j1p6_input
        .export  _sampler_2bit_inception_j1p7_input
        .export  _sampler_2bit_inception_j1p8_input
        .export  _sampler_4bit_inception_j1p1_input
        .export  _sampler_4bit_inception_j1p2_input
        .export  _sampler_4bit_inception_j1p3_input
        .export  _sampler_4bit_inception_j1p4_input
        .export  _sampler_4bit_inception_j1p5_input
        .export  _sampler_4bit_inception_j1p6_input
        .export  _sampler_4bit_inception_j1p7_input
        .export  _sampler_4bit_inception_j1p8_input
        .export  _sampler_2bit_inception_j2p1_input
        .export  _sampler_2bit_inception_j2p2_input
        .export  _sampler_2bit_inception_j2p3_input
        .export  _sampler_2bit_inception_j2p4_input
        .export  _sampler_2bit_inception_j2p5_input
        .export  _sampler_2bit_inception_j2p6_input
        .export  _sampler_2bit_inception_j2p7_input
        .export  _sampler_2bit_inception_j2p8_input
        .export  _sampler_4bit_inception_j2p1_input
        .export  _sampler_4bit_inception_j2p2_input
        .export  _sampler_4bit_inception_j2p3_input
        .export  _sampler_4bit_inception_j2p4_input
        .export  _sampler_4bit_inception_j2p5_input
        .export  _sampler_4bit_inception_j2p6_input
        .export  _sampler_4bit_inception_j2p7_input
        .export  _sampler_4bit_inception_j2p8_input

        .export  _show_sample

        .importzp   tmp1, tmp2
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

set_joy:
        ldy     #$dc
        sty     sreg + 1
        ldy     #$01
        sty     sreg
        dey
        sta     (sreg),y
        rts

load_joy_top:
        ldy     #$dc
        sty     sreg + 1
        ldy     #$00
        sty     sreg
        lda     (sreg),y
        rts

set_joy_top:
        ldy     #$dc
        sty     sreg + 1
        ldy     #$00
        sty     sreg
        sta     (sreg),y
        rts

set_joy_ddr:
        ldy     #$dc
        sty     sreg + 1
        ldy     #$03
        sty     sreg
        ldy     #$00
        sta     (sreg),y
        rts

set_joy_top_ddr:
        ldy     #$dc
        sty     sreg + 1
        ldy     #$02
        sty     sreg
        dey
        dey
        sta     (sreg),y
        rts

inception_byte_1:
        .byte   0

inception_byte_2:
        .byte   0

inception_byte_3:
        .byte   0

inception_byte_4:
        .byte   0

inception_byte_5:
        .byte   0

inception_byte_6:
        .byte   0

inception_byte_7:
        .byte   0

inception_byte_8:
        .byte   0

inception_j1_input_bytes:
        lda     #$00
        jsr     set_joy
        jsr     set_joy_top
        lda     #$40
        jsr     set_joy_top_ddr
        lda     #$0f
        jsr     set_joy_ddr
        lda     #$40
        jsr     set_joy_top
        jsr     set_joy_top_ddr
        lda     #$00
        jsr     set_joy
        jsr     set_joy_ddr
        stx     tmp1
        ldx     #$00
inception_j1_loop:
        jsr     load_joy
        asl
        asl
        asl
        asl
        sta     tmp2
        lda     #$00
        jsr     set_joy_top
        jsr     load_joy
        pha
        lda     #$40
        jsr     set_joy_top
        pla
        and     #$0f
        ora     tmp2
        sta     inception_byte_1,x
        inx     
        cpx     #$08
        bne     inception_j1_loop
        lda     #$40
        jsr     set_joy_top
        jsr     set_joy_top_ddr
        lda     #$0f
        jsr     set_joy
        jsr     set_joy_ddr
        ldx     tmp1
        rts

inception_j2_input_bytes:
        lda     #$00
        jsr     set_joy
        jsr     set_joy_top
        lda     #$80
        jsr     set_joy_top_ddr
        lda     #$f0
        jsr     set_joy_ddr
        lda     #$80
        jsr     set_joy_top
        jsr     set_joy_top_ddr
        lda     #$00
        jsr     set_joy
        jsr     set_joy_ddr
        stx     tmp1
        ldx     #$00
inception_j2_loop:
        jsr     load_joy
        and     #$f0
        sta     tmp2
        lda     #$00
        jsr     set_joy_top
        jsr     load_joy
        pha
        lda     #$80
        jsr     set_joy_top
        pla
        lsr
        lsr
        lsr
        lsr
        ora     tmp2
        sta     inception_byte_1,x
        inx     
        cpx     #$08
        bne     inception_j2_loop
        lda     #$80
        jsr     set_joy_top
        jsr     set_joy_top_ddr
        lda     #$f0
        jsr     set_joy
        jsr     set_joy_ddr
        ldx     tmp1
        rts

_sampler_2bit_inception_j1p1_input:
        jsr     setup_banking
        jsr     inception_j1_input_bytes
        lda     inception_byte_1
        jmp     do_asl6

_sampler_2bit_inception_j1p2_input:
        jsr     setup_banking
        jsr     inception_j1_input_bytes
        lda     inception_byte_2
        jmp     do_asl6

_sampler_2bit_inception_j1p3_input:
        jsr     setup_banking
        jsr     inception_j1_input_bytes
        lda     inception_byte_3
        jmp     do_asl6

_sampler_2bit_inception_j1p4_input:
        jsr     setup_banking
        jsr     inception_j1_input_bytes
        lda     inception_byte_4
        jmp     do_asl6

_sampler_2bit_inception_j1p5_input:
        jsr     setup_banking
        jsr     inception_j1_input_bytes
        lda     inception_byte_5
        jmp     do_asl6

_sampler_2bit_inception_j1p6_input:
        jsr     setup_banking
        jsr     inception_j1_input_bytes
        lda     inception_byte_6
        jmp     do_asl6

_sampler_2bit_inception_j1p7_input:
        jsr     setup_banking
        jsr     inception_j1_input_bytes
        lda     inception_byte_7
        jmp     do_asl6

_sampler_2bit_inception_j1p8_input:
        jsr     setup_banking
        jsr     inception_j1_input_bytes
        lda     inception_byte_8
        jmp     do_asl6

_sampler_4bit_inception_j1p1_input:
        jsr     setup_banking
        jsr     inception_j1_input_bytes
        lda     inception_byte_1
        jmp     do_asl4

_sampler_4bit_inception_j1p2_input:
        jsr     setup_banking
        jsr     inception_j1_input_bytes
        lda     inception_byte_2
        jmp     do_asl4

_sampler_4bit_inception_j1p3_input:
        jsr     setup_banking
        jsr     inception_j1_input_bytes
        lda     inception_byte_3
        jmp     do_asl4

_sampler_4bit_inception_j1p4_input:
        jsr     setup_banking
        jsr     inception_j1_input_bytes
        lda     inception_byte_4
        jmp     do_asl4

_sampler_4bit_inception_j1p5_input:
        jsr     setup_banking
        jsr     inception_j1_input_bytes
        lda     inception_byte_5
        jmp     do_asl4

_sampler_4bit_inception_j1p6_input:
        jsr     setup_banking
        jsr     inception_j1_input_bytes
        lda     inception_byte_6
        jmp     do_asl4

_sampler_4bit_inception_j1p7_input:
        jsr     setup_banking
        jsr     inception_j1_input_bytes
        lda     inception_byte_7
        jmp     do_asl4

_sampler_4bit_inception_j1p8_input:
        jsr     setup_banking
        jsr     inception_j1_input_bytes
        lda     inception_byte_8
        jmp     do_asl4

_sampler_2bit_inception_j2p1_input:
        jsr     setup_banking
        jsr     inception_j2_input_bytes
        lda     inception_byte_1
        jmp     do_asl6

_sampler_2bit_inception_j2p2_input:
        jsr     setup_banking
        jsr     inception_j2_input_bytes
        lda     inception_byte_2
        jmp     do_asl6

_sampler_2bit_inception_j2p3_input:
        jsr     setup_banking
        jsr     inception_j2_input_bytes
        lda     inception_byte_3
        jmp     do_asl6

_sampler_2bit_inception_j2p4_input:
        jsr     setup_banking
        jsr     inception_j2_input_bytes
        lda     inception_byte_4
        jmp     do_asl6

_sampler_2bit_inception_j2p5_input:
        jsr     setup_banking
        jsr     inception_j2_input_bytes
        lda     inception_byte_5
        jmp     do_asl6

_sampler_2bit_inception_j2p6_input:
        jsr     setup_banking
        jsr     inception_j2_input_bytes
        lda     inception_byte_6
        jmp     do_asl6

_sampler_2bit_inception_j2p7_input:
        jsr     setup_banking
        jsr     inception_j2_input_bytes
        lda     inception_byte_7
        jmp     do_asl6

_sampler_2bit_inception_j2p8_input:
        jsr     setup_banking
        jsr     inception_j2_input_bytes
        lda     inception_byte_8
        jmp     do_asl6

_sampler_4bit_inception_j2p1_input:
        jsr     setup_banking
        jsr     inception_j2_input_bytes
        lda     inception_byte_1
        jmp     do_asl4

_sampler_4bit_inception_j2p2_input:
        jsr     setup_banking
        jsr     inception_j2_input_bytes
        lda     inception_byte_2
        jmp     do_asl4

_sampler_4bit_inception_j2p3_input:
        jsr     setup_banking
        jsr     inception_j2_input_bytes
        lda     inception_byte_3
        jmp     do_asl4

_sampler_4bit_inception_j2p4_input:
        jsr     setup_banking
        jsr     inception_j2_input_bytes
        lda     inception_byte_4
        jmp     do_asl4

_sampler_4bit_inception_j2p5_input:
        jsr     setup_banking
        jsr     inception_j2_input_bytes
        lda     inception_byte_5
        jmp     do_asl4

_sampler_4bit_inception_j2p6_input:
        jsr     setup_banking
        jsr     inception_j2_input_bytes
        lda     inception_byte_6
        jmp     do_asl4

_sampler_4bit_inception_j2p7_input:
        jsr     setup_banking
        jsr     inception_j2_input_bytes
        lda     inception_byte_7
        jmp     do_asl4

_sampler_4bit_inception_j2p8_input:
        jsr     setup_banking
        jsr     inception_j2_input_bytes
        lda     inception_byte_8
        jmp     do_asl4

_sampler_2bit_joy1_input:
        jsr     setup_banking
        jsr     load_joy
do_asl6:
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

_sampler_4bit_joy2_input:
        jsr     setup_banking
        jsr     load_joy
        and     #$f0
        stx     $01
        rts

_sampler_2bit_joy2_input:
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
