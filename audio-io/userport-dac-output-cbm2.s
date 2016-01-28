;
; Marco van den Heuvel, 27.01.2016
;
; void __fastcall__ userport_dac_output_init(void);
; void __fastcall__ userport_dac_output(unsigned char sample);
;

        .export  _userport_dac_output_init, _userport_dac_output
        .importzp       sreg

_userport_dac_output_init:
        ldx     $01
        ldy     #$03
        sty     sreg
        ldy     #$dc
        sty     sreg + 1
        ldy     #$0f
        sty     $01
        ldy     #$00
        lda     #$ff
        sta     (sreg),y
        stx     $01
        rts

_userport_dac_output:
        ldx     $01
        ldy     #$01
        sty     sreg
        ldy     #$dc
        sty     sreg + 1
        ldy     #$0f
        sty     $01
        ldy     #$00
        sta     (sreg),y
        stx     $01
        rts
