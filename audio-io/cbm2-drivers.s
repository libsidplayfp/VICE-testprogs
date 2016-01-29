;
; Marco van den Heuvel, 28.01.2016
;
; void __fastcall__ sampler_2bit_hummer_input_init(void);
; unsigned char __fastcall__ sampler_2bit_hummer_input(void);
; void __fastcall__ sampler_4bit_hummer_input_init(void);
; unsigned char __fastcall__ sampler_4bit_hummer_input(void);
;
; void __fastcall__ userport_dac_output_init(void);
; void __fastcall__ userport_dac_output(unsigned char sample);
; void __fastcall__ userport_digimax_output_init(void);
; void __fastcall__ userport_digimax_output(unsigned char sample);
;

        .export  _sampler_2bit_hummer_input_init, _sampler_2bit_hummer_input
        .export  _sampler_4bit_hummer_input_init, _sampler_4bit_hummer_input

        .export  _userport_dac_output_init, _userport_dac_output
        .export  _userport_digimax_output_init, _userport_digimax_output

        .importzp   sreg

setup_banking:
        ldx     $01
        ldy     #$0f
        sty     $01
        rts

load_userport:
        ldy     #$dc
        sty     sreg + 1
        ldy     #$01
        sty     sreg
        dey
        lda     (sreg),y
        rts

_sampler_2bit_hummer_input_init:
_sampler_4bit_hummer_input_init:
        jsr     setup_banking
        ldy     #$03
        sty     sreg
        ldy     #$dc
        sty     sreg + 1
        ldy     #$00
        tya
        sta     (sreg),y
        stx     $01
        rts

_sampler_2bit_hummer_input:
        jsr     setup_banking
        jsr     load_userport
        asl
        asl
do_asl4:
        asl
        asl
        asl
        asl
        stx     $01
        rts

_sampler_4bit_hummer_input:
        jsr     setup_banking
        jsr     load_userport
        jmp     do_asl4

_userport_digimax_output_init:
_userport_dac_output_init:
        jsr     setup_banking
        ldy     #$03
        sty     sreg
        ldy     #$dc
        sty     sreg + 1
        ldy     #$00
        lda     #$ff
        sta     (sreg),y
        stx     $01
        rts

_userport_digimax_output:
_userport_dac_output:
        jsr     setup_banking
        ldy     #$dc
        sty     sreg + 1
        ldy     #$01
        sty     sreg
        dey
        sta     (sreg),y
        stx     $01
        rts
