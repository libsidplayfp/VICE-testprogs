;
; Marco van den Heuvel, 28.01.2016
;
; void __fastcall__ userport_dac_output_init(void);
; void __fastcall__ userport_dac_output(unsigned char sample);
; void __fastcall__ userport_digimax_output_init(void);
; void __fastcall__ userport_digimax_output(unsigned char sample);
;

        .export  _userport_dac_output_init, _userport_dac_output
        .export  _userport_digimax_output_init, _userport_digimax_output

        .importzp   sreg

setup_banking:
        ldx     $01
        ldy     #$0f
        sty     $01
        rts

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
