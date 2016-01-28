;
; Marco van den Heuvel, 28.01.2016
;
; unsigned char __fastcall__ sfx_input(void);
; unsigned char __fastcall__ sampler_4bit_joy1_input(void);
; void __fastcall__ digimax_cart_output(unsigned char sample);
; void __fastcall__ sfx_output(unsigned char sample);
; void __fastcall__ sid_output_init(void);
; void __fastcall__ sid_output(unsigned char sample);
; void __fastcall__ userport_dac_output_init(void);
; void __fastcall__ userport_dac_output(unsigned char sample);
;

        .export  _sfx_input
        .export  _sampler_4bit_joy1_input

        .export  _digimax_cart_output
        .export  _sfx_output
        .export  _sid_output_init, _sid_output
        .export  _userport_dac_output_init, _userport_dac_output

_sfx_input:
        lda     $df00
        sta     $de00
        rts

_sampler_4bit_joy1_input:
        lda     $dc01
        and     #$0f
        asl
        asl
        asl
        asl
        rts

_digimax_cart_output:
        sta     $de00
        sta     $de01
        sta     $de02
        sta     $de03
        rts

_sfx_output:
        sta     $df00
        rts

_sid_output_init:
        lda     #$00
        ldx     #$00
@l:
        sta     $d400,x
        inx
        cpx     #$20
        bne     @l
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

_userport_dac_output_init:
        ldx     #$ff
        stx     $dd03
        rts

_userport_dac_output:
        sta     $dd01
        rts
