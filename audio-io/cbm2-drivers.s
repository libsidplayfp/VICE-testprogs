;
; Marco van den Heuvel, 28.01.2016
;
; void __fastcall__ sampler_2bit_pet1_input_init(void);
; unsigned char __fastcall__ sampler_2bit_pet1_input(void);
; void __fastcall__ sampler_4bit_pet1_input_init(void);
; unsigned char __fastcall__ sampler_4bit_pet1_input(void);
; void __fastcall__ sampler_2bit_pet2_input_init(void);
; unsigned char __fastcall__ sampler_2bit_pet2_input(void);
; void __fastcall__ sampler_4bit_pet2_input_init(void);
; unsigned char __fastcall__ sampler_4bit_pet2_input(void);
; void __fastcall__ sampler_4bit_userport_input_init(void);
; unsigned char __fastcall__ sampler_4bit_userport_input(void);
;
; void __fastcall__ userport_dac_output_init(void);
; void __fastcall__ userport_dac_output(unsigned char sample);
; void __fastcall__ userport_digimax_output_init(void);
; void __fastcall__ userport_digimax_output(unsigned char sample);
;
; void __fastcall__ _show_sample(unsigned char sample);
;

        .export  _sampler_2bit_pet1_input_init, _sampler_2bit_pet1_input
        .export  _sampler_4bit_pet1_input_init, _sampler_4bit_pet1_input
        .export  _sampler_2bit_pet2_input_init, _sampler_2bit_pet2_input
        .export  _sampler_4bit_pet2_input_init, _sampler_4bit_pet2_input
        .export  _sampler_4bit_userport_input_init, _sampler_4bit_userport_input

        .export  _userport_dac_output_init, _userport_dac_output
        .export  _userport_digimax_output_init, _userport_digimax_output

        .export  _show_sample

        .importzp   sreg, tmp1, tmp2

setup_banking:
        ldx     $01
        ldy     #$0f
        sty     $01
        rts

load_pa2:
        ldy     #$dc
        sty     sreg + 1
        ldy     #$00
        sty     sreg
        lda     (sreg),y
        rts

load_userport:
        ldy     #$dc
        sty     sreg + 1
        ldy     #$01
        sty     sreg
        dey
        lda     (sreg),y
        rts

setup_userport_dc01:
        jsr     setup_banking
        ldy     #$dc
        sty     sreg + 1
        ldy     #$01
        sty     sreg
        iny
        lda     #$80
        sta     (sreg),y
        dey
        dey
        rts

_sampler_4bit_userport_input_init:
        jsr     setup_banking
        ldy     #$dc
        sty     sreg + 1
        ldy     #$00
        sty     sreg
        ldy     #$02
        lda     (sreg),y
        ora     #$04
        sta     (sreg),y
        ldy     #$00
        lda     (sreg),y
        and     #$fb
        sta     (sreg),y
        tya
        ldy     #$03
        sta     (sreg),y
        stx     $01
        rts

_sampler_2bit_pet1_input_init:
_sampler_4bit_pet1_input_init:
_sampler_2bit_pet2_input_init:
_sampler_4bit_pet2_input_init:
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

dc03_e0:
        jsr     setup_banking
        ldy     #$00
        sty     sreg
        ldy     #$dc
        sty     sreg + 1
        ldy     #$03
        lda     #$E0
        sta     (sreg),y
        ldy     #$01
        rts

sta_sreg_y:
        sta     (sreg),y
        stx     $01
        rts

_sampler_2bit_pet2_input:
        jsr     setup_banking
        jsr     load_userport
        and     #$30
        asl
        asl
        stx     $01
        rts

_sampler_4bit_pet2_input:
_sampler_4bit_userport_input:
        jsr     setup_banking
        jsr     load_userport
        and     #$f0
        stx     $01
        rts

_sampler_2bit_pet1_input:
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

_sampler_4bit_pet1_input:
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

_show_sample:
        jsr     setup_banking
        ldy     #$d0
        sty     sreg + 1
        ldy     #$20
        sty     sreg
        ldy     #$00
        sta     (sreg),y
        rts
