;
; Marco van den Heuvel, 28.01.2016
;
; unsigned char __fastcall__ sfx_input(void);
; unsigned char __fastcall__ sampler_2bit_joy1_input(void);
; unsigned char __fastcall__ sampler_4bit_joy1_input(void);
; unsigned char __fastcall__ sampler_2bit_joy2_input(void);
; unsigned char __fastcall__ sampler_4bit_joy2_input(void);
; void __fastcall__ sampler_2bit_hummer_input_init(void);
; unsigned char __fastcall__ sampler_2bit_hummer_input(void);
; void __fastcall__ sampler_4bit_hummer_input_init(void);
; unsigned char __fastcall__ sampler_4bit_hummer_input(void);
; void __fastcall__ sampler_2bit_oem_input_init(void);
; unsigned char __fastcall__ sampler_2bit_oem_input(void);
; void __fastcall__ sampler_4bit_oem_input_init(void);
; unsigned char __fastcall__ sampler_4bit_oem_input(void);
; void __fastcall__ sampler_2bit_pet1_input_init(void);
; unsigned char __fastcall__ sampler_2bit_pet1_input(void);
; void __fastcall__ sampler_4bit_pet1_input_init(void);
; unsigned char __fastcall__ sampler_4bit_pet1_input(void);
; void __fastcall__ sampler_2bit_pet2_input_init(void);
; unsigned char __fastcall__ sampler_2bit_pet2_input(void);
; void __fastcall__ sampler_4bit_pet2_input_init(void);
; unsigned char __fastcall__ sampler_4bit_pet2_input(void);
; void __fastcall__ sampler_2bit_cga1_input_init(void);
; unsigned char __fastcall__ sampler_2bit_cga1_input(void);
; void __fastcall__ sampler_4bit_cga1_input_init(void);
; unsigned char __fastcall__ sampler_4bit_cga1_input(void);
; void __fastcall__ sampler_2bit_cga2_input_init(void);
; unsigned char __fastcall__ sampler_2bit_cga2_input(void);
; void __fastcall__ sampler_4bit_cga2_input_init(void);
; unsigned char __fastcall__ sampler_4bit_cga2_input(void);
; void __fastcall__ sampler_2bit_hit1_input_init(void);
; unsigned char __fastcall__ sampler_2bit_hit1_input(void);
; void __fastcall__ sampler_4bit_hit1_input_init(void);
; unsigned char __fastcall__ sampler_4bit_hit1_input(void);
; void __fastcall__ sampler_2bit_hit2_input_init(void);
; unsigned char __fastcall__ sampler_2bit_hit2_input(void);
; void __fastcall__ sampler_4bit_hit2_input_init(void);
; unsigned char __fastcall__ sampler_4bit_hit2_input(void);
; void __fastcall__ sampler_2bit_kingsoft1_input_init(void);
; unsigned char __fastcall__ sampler_2bit_kingsoft1_input(void);
; void __fastcall__ sampler_4bit_kingsoft1_input_init(void);
; unsigned char __fastcall__ sampler_4bit_kingsoft1_input(void);
; void __fastcall__ sampler_2bit_kingsoft2_input_init(void);
; unsigned char __fastcall__ sampler_2bit_kingsoft2_input(void);
; void __fastcall__ sampler_4bit_kingsoft2_input_init(void);
; unsigned char __fastcall__ sampler_4bit_kingsoft2_input(void);
; void __fastcall__ sampler_2bit_starbyte1_input_init(void);
; unsigned char __fastcall__ sampler_2bit_starbyte1_input(void);
; void __fastcall__ sampler_4bit_starbyte1_input_init(void);
; unsigned char __fastcall__ sampler_4bit_starbyte1_input(void);
; void __fastcall__ sampler_2bit_starbyte2_input_init(void);
; unsigned char __fastcall__ sampler_2bit_starbyte2_input(void);
; void __fastcall__ sampler_4bit_starbyte2_input_init(void);
; unsigned char __fastcall__ sampler_4bit_starbyte2_input(void);
;
; void __fastcall__ digimax_cart_output(unsigned char sample);
; void __fastcall__ sfx_output(unsigned char sample);
; void __fastcall__ sid_output_init(void);
; void __fastcall__ sid_output(unsigned char sample);
; void __fastcall__ siddtv_output_init(void);
; void __fastcall__ siddtv_output(unsigned char sample);
; void __fastcall__ userport_dac_output_init(void);
; void __fastcall__ userport_dac_output(unsigned char sample);
; void __fastcall__ userport_digimax_output_init(void);
; void __fastcall__ userport_digimax_output(unsigned char sample);
;

        .export  _sfx_input
        .export  _sampler_2bit_joy1_input
        .export  _sampler_4bit_joy1_input
        .export  _sampler_2bit_joy2_input
        .export  _sampler_4bit_joy2_input
        .export  _sampler_2bit_hummer_input_init, _sampler_2bit_hummer_input
        .export  _sampler_4bit_hummer_input_init, _sampler_4bit_hummer_input
        .export  _sampler_2bit_oem_input_init, _sampler_2bit_oem_input
        .export  _sampler_4bit_oem_input_init, _sampler_4bit_oem_input
        .export  _sampler_2bit_pet1_input_init, _sampler_2bit_pet1_input
        .export  _sampler_4bit_pet1_input_init, _sampler_4bit_pet1_input
        .export  _sampler_2bit_pet2_input_init, _sampler_2bit_pet2_input
        .export  _sampler_4bit_pet2_input_init, _sampler_4bit_pet2_input
        .export  _sampler_2bit_cga1_input_init, _sampler_2bit_cga1_input
        .export  _sampler_4bit_cga1_input_init, _sampler_4bit_cga1_input
        .export  _sampler_2bit_cga2_input_init, _sampler_2bit_cga2_input
        .export  _sampler_4bit_cga2_input_init, _sampler_4bit_cga2_input
        .export  _sampler_2bit_hit1_input_init, _sampler_2bit_hit1_input
        .export  _sampler_4bit_hit1_input_init, _sampler_4bit_hit1_input
        .export  _sampler_2bit_hit2_input_init, _sampler_2bit_hit2_input
        .export  _sampler_4bit_hit2_input_init, _sampler_4bit_hit2_input
        .export  _sampler_2bit_kingsoft1_input_init, _sampler_2bit_kingsoft1_input
        .export  _sampler_4bit_kingsoft1_input_init, _sampler_4bit_kingsoft1_input
        .export  _sampler_2bit_kingsoft2_input_init, _sampler_2bit_kingsoft2_input
        .export  _sampler_4bit_kingsoft2_input_init, _sampler_4bit_kingsoft2_input
        .export  _sampler_2bit_starbyte1_input_init, _sampler_2bit_starbyte1_input
        .export  _sampler_4bit_starbyte1_input_init, _sampler_4bit_starbyte1_input
        .export  _sampler_2bit_starbyte2_input_init, _sampler_2bit_starbyte2_input
        .export  _sampler_4bit_starbyte2_input_init, _sampler_4bit_starbyte2_input

        .export  _digimax_cart_output
        .export  _sfx_output
        .export  _sid_output_init, _sid_output
        .export  _siddtv_output_init, _siddtv_output
        .export  _userport_dac_output_init, _userport_dac_output
        .export  _userport_digimax_output_init, _userport_digimax_output

        .importzp   tmp1, tmp2

_sampler_2bit_kingsoft1_input_init:
_sampler_4bit_kingsoft1_input_init:
_sampler_2bit_starbyte2_input_init:
_sampler_4bit_starbyte2_input_init:
        lda     $dd02
        and     #$fb
        sta     $dd02

; run into pbx read init

_sampler_2bit_hummer_input_init:
_sampler_4bit_hummer_input_init:
_sampler_2bit_oem_input_init:
_sampler_4bit_oem_input_init:
_sampler_2bit_pet1_input_init:
_sampler_4bit_pet1_input_init:
_sampler_2bit_pet2_input_init:
_sampler_4bit_pet2_input_init:
_sampler_2bit_hit1_input_init:
_sampler_4bit_hit1_input_init:
_sampler_2bit_hit2_input_init:
_sampler_4bit_hit2_input_init:
_sampler_2bit_kingsoft2_input_init:
_sampler_4bit_kingsoft2_input_init:
_sampler_2bit_starbyte1_input_init:
_sampler_4bit_starbyte1_input_init:
        ldx     #$00
        stx     $dd03
        rts

_sampler_2bit_cga1_input_init:
_sampler_4bit_cga1_input_init:
        ldx     #$80
        stx     $dd03
storex_dd01:
        stx     $dd01
        rts

_sampler_2bit_cga2_input_init:
_sampler_4bit_cga2_input_init:
        ldx     #$80
        stx     $dd03
        ldx     #$00
        jmp     storex_dd01

_sampler_2bit_starbyte2_input:
        lda     $dd00
        and     #$04
        asl
        asl
        asl
        asl
        sta     tmp1
        lda     $dd01
        and     #$20
        asl
        asl
        ora     tmp1
        rts

_sampler_4bit_starbyte2_input:
        lda     $dd00
        and     #$04
        asl
        asl
        sta     tmp1
        lda     $dd01
        sta     tmp2
        and     #$20
        ora     tmp1
        sta     tmp1
        lda     tmp2
        and     #$40
        asl
        ora     tmp1
        sta     tmp1
        lda     tmp2
        and     #$80
        lsr
        ora     tmp1
        rts

_sampler_2bit_starbyte1_input:
        lda     $dd01
        sta     tmp2
        and     #$01
        clc
        ror
        ror
        sta     tmp1
        lda     tmp2
        and     #$08
        asl
        asl
        asl
        ora     tmp1
        rts

_sampler_4bit_starbyte1_input:
        lda     $dd01
        sta     tmp2
        and     #$01
        asl
        asl
        asl
        asl
        asl
        sta     tmp1
        lda     tmp2
        and     #$02
        clc
        ror
        ror
        ror
        ora     tmp1
        sta     tmp1
        lda     tmp2
        and     #$04
        asl
        asl
        asl
        asl
        ora     tmp1
        sta     tmp1
        lda     tmp2
        and     #$08
        asl
        ora     tmp1
        rts

_sampler_2bit_kingsoft2_input:
        lda     $dd01
        sta     tmp2
        and     #$04
        asl
        asl
        asl
        asl
        asl
        sta     tmp1
        lda     tmp2
        and     #$08
        asl
        asl
        asl
        ora     tmp1
        rts

_sampler_4bit_kingsoft2_input:
        lda     $dd01
        sta     tmp2
        and     #$01
        clc
        ror
        ror
        sta     tmp1
        lda     tmp2
        and     #$02
        asl
        asl
        asl
        asl
        asl
        ora    tmp1
        sta    tmp1
        lda    tmp2
        and    #$04
        asl
        asl
        asl
        ora    tmp1
        sta    tmp1
        lda    tmp2
        and    #$08
        asl
        ora    tmp1
        rts

_sampler_2bit_kingsoft1_input:
        lda     $dd00
        and     #$04
        asl
        asl
        asl
        asl
        sta     tmp1
        lda     $dd01
        and     #$80
        ora     tmp1
        rts

_sampler_4bit_kingsoft1_input:
        lda     $dd00
        and     #$04
        asl
        asl
        sta     tmp1
        lda     $dd01
        sta     tmp2
        and     #$20
        asl
        asl
        ora     tmp1
        sta     tmp1
        lda     tmp2
        and     #$40
        ora     tmp1
        sta     tmp1
        lda     tmp2
        and     #$80
        lsr
        lsr
        ora     tmp1
        rts

_sampler_2bit_pet2_input:
_sampler_2bit_hit2_input:
        lda     $dd01
        and     #$30
        asl
        asl
        rts

_sampler_4bit_pet2_input:
_sampler_4bit_hit2_input:
        lda     $dd01
        and     #$f0
        rts

_sampler_2bit_oem_input:
        lda     $dd01
        sta     tmp2
        and     #$40
        asl
        sta     tmp1
        lda     tmp2
        and     #$80
        lsr
        ora     tmp1
        rts

_sampler_4bit_oem_input:
        lda     $dd01
        sta     tmp2
        and     #$10
        asl
        asl
        asl
        sta     tmp1
        lda     tmp2
        and     #$20
        asl
        ora     tmp1
        sta     tmp1
        lda     tmp2
        and     #$40
        lsr
        ora     tmp1
        sta     tmp1
        lda     tmp2
        and     #$80
        lsr
        lsr
        lsr
        ora     tmp1
        rts

_sampler_2bit_hummer_input:
_sampler_2bit_pet1_input:
_sampler_2bit_cga1_input:
_sampler_2bit_cga2_input:
_sampler_2bit_hit1_input:
        lda     $dd01
        asl
        asl
        jmp     do_asl4

_sampler_4bit_hummer_input:
_sampler_4bit_pet1_input:
_sampler_4bit_cga1_input:
_sampler_4bit_cga2_input:
_sampler_4bit_hit1_input:
        lda     $dd01
        jmp     do_asl4

_sfx_input:
        lda     $df00
        sta     $de00
        rts

_sampler_2bit_joy1_input:
        lda     $dc01
        asl
        asl
        jmp     do_asl4

_sampler_4bit_joy1_input:
        lda     $dc01
do_asl4:
        asl
        asl
        asl
        asl
        rts

_sampler_2bit_joy2_input:
        lda     $dc00
        asl
        asl
        jmp     do_asl4

_sampler_4bit_joy2_input:
        lda     $dc00
        jmp     do_asl4

_digimax_cart_output:
        sta     $de00
        sta     $de01
        sta     $de02
        sta     $de03
        rts

_sfx_output:
        sta     $df00
        rts

_siddtv_output_init:
        jsr     setup_sid
        lda     #$10
        sta     $d404
        lda     #$0f
        sta     $d418
        rts

_siddtv_output:
        sta     $d41e
        rts

setup_sid:
        lda     #$00
        ldx     #$00
@l:
        sta     $d400,x
        inx
        cpx     #$20
        bne     @l
        rts

_sid_output_init:
        jsr     setup_sid
        lda     #$ff
        sta     $d406
        sta     $d40d
        sta     $d414
        lda     #$49
        sta     $d404
        sta     $d40b
        sta     $d412
        rts

_sid_output:
        lsr
        lsr
        lsr
        lsr
        sta     $d418
        rts

_userport_digimax_output_init:
_userport_dac_output_init:
        ldx     #$ff
        stx     $dd03
        rts

_userport_digimax_output:
_userport_dac_output:
        sta     $dd01
        rts
