;
; Marco van den Heuvel, 28.01.2016
;
; unsigned char __fastcall__ sampler_2bit_joy1_input(void);
; unsigned char __fastcall__ sampler_4bit_joy1_input(void);
; unsigned char __fastcall__ sfx_input(void);
; void __fastcall__ sampler_2bit_hummer_input_init(void);
; unsigned char __fastcall__ sampler_2bit_hummer_input(void);
; void __fastcall__ sampler_4bit_hummer_input_init(void);
; unsigned char __fastcall__ sampler_4bit_hummer_input(void);
; void __fastcall__ sampler_2bit_oem_input_init(void);
; unsigned char __fastcall__ sampler_2bit_oem_input(void);
; void __fastcall__ sampler_4bit_oem_input_init(void);
; unsigned char __fastcall__ sampler_4bit_oem_input(void);
;
; void __fastcall__ digimax_cart_output(unsigned char sample);
; void __fastcall__ sfx_output(unsigned char sample);
; void __fastcall__ sid_output_init(void);
; void __fastcall__ sid_output(unsigned char sample);
; void __fastcall__ userport_dac_output_init(void);
; void __fastcall__ userport_dac_output(unsigned char sample);
; void __fastcall__ vic_output(unsigned char sample);
;

        .export  _sampler_2bit_joy1_input
        .export  _sampler_4bit_joy1_input
        .export  _sfx_input
        .export  _sampler_2bit_hummer_input_init, _sampler_2bit_hummer_input
        .export  _sampler_4bit_hummer_input_init, _sampler_4bit_hummer_input
        .export  _sampler_2bit_oem_input_init, _sampler_2bit_oem_input
        .export  _sampler_4bit_oem_input_init, _sampler_4bit_oem_input

        .export  _digimax_cart_output
        .export  _sfx_output
        .export  _sid_output_init, _sid_output
        .export  _userport_dac_output_init, _userport_dac_output
        .export  _vic_output

        .importzp       tmp1, tmp2

_sampler_2bit_hummer_input_init:
_sampler_4bit_hummer_input_init:
_sampler_2bit_oem_input_init:
_sampler_4bit_oem_input_init:
        ldx     #$00
        stx     $9112
        rts

_sampler_2bit_oem_input:
        lda     $9110
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
        lda     $9110
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
        lda     $9110
        asl
        asl
        jmp     do_asl4

_sampler_4bit_hummer_input:
        lda     $9110
        jmp     do_asl4

_sampler_2bit_joy1_input:
        lda     $9111
        and     #$0c
do_asl4:
        asl
        asl
        asl
        asl
        rts

_sampler_4bit_joy1_input:
        lda     $9111
        and     #$1c
        asl
        asl
        sta     tmp1
        lda     $9120
        and     #$80
        clc
        adc     tmp1
        rts

_sfx_input:
        lda     $9800
        sta     $9c00
        rts

_digimax_cart_output:
        sta     $9800
        sta     $9801
        sta     $9802
        sta     $9803
        rts

_sfx_output:
        sta     $9800
        rts

_sid_output_init:
        lda     #$00
        ldx     #$00
@l:
        sta     $9800,x
        inx
        cpx     #$20
        bne     @l
        lda     #$ff
        sta     $9806
        sta     $980d
        sta     $9814
        lda     #$49
        sta     $9804
        sta     $980b
        sta     $9812
        rts

_sid_output:
        lsr
        lsr
        lsr
        lsr
        sta     $9818
        rts

_userport_dac_output_init:
        ldx     #$ff
        stx     $9112
        rts

_userport_dac_output:
        sta     $9110
        rts

_vic_output:
        lsr
        lsr
        lsr
        lsr
        sta     $900e
        rts
