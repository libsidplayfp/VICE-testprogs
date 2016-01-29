;
; Marco van den Heuvel, 28.01.2016
;
; void __fastcall__ sampler_2bit_hummer_input_init(void);
; unsigned char __fastcall__ sampler_2bit_hummer_input(void);
; void __fastcall__ sampler_4bit_hummer_input_init(void);
; unsigned char __fastcall__ sampler_4bit_hummer_input(void);
;
; void __fastcall__ sid_output_init(void);
; void __fastcall__ sid_output(unsigned char sample);
; void __fastcall__ userport_dac_output_init(void);
; void __fastcall__ userport_dac_output(unsigned char sample);
;

        .export  _sampler_2bit_hummer_input_init, _sampler_2bit_hummer_input
        .export  _sampler_4bit_hummer_input_init, _sampler_4bit_hummer_input

        .export  _sid_output_init, _sid_output
        .export  _userport_dac_output_init, _userport_dac_output

_sampler_2bit_hummer_input_init:
_sampler_4bit_hummer_input_init:
        ldx     #$00
        stx     $e843
        rts

_sampler_2bit_hummer_input:
        lda     $e843
        asl
        asl
do_asl4:
        asl
        asl
        asl
        asl
        rts

_sampler_4bit_hummer_input:
        lda     $e843
        jmp     do_asl4

_sfx_input:
        lda     $df00
        sta     $de00
        rts

_sid_output_init:
        lda     #$00
        ldx     #$00
@l:
        sta     $e900,x
        inx
        cpx     #$20
        bne     @l
        lda     #$ff
        sta     $e906
        sta     $e90d
        sta     $e914
        lda     #$49
        sta     $e904
        sta     $e90b
        sta     $e912
        rts

_sid_output:
        lsr
        lsr
        lsr
        lsr
        sta     $e918
        rts

_userport_dac_output_init:
        ldx     #$ff
        stx     $e843
        rts

_userport_dac_output:
        sta     $e841
        rts

