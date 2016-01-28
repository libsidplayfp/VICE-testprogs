;
; Marco van den Heuvel, 27.01.2016
;
; void __fastcall__ sid_output_init(void);
; void __fastcall__ sid_output(unsigned char sample);
;

        .export         _sid_output_init, _sid_output
        .importzp       sreg

_sid_output_init:
        ldx     $01
        ldy     #$00
        sty     sreg
        ldy     #$da
        sty     sreg + 1
        ldy     #$0f
        sty     $01
        ldy     #$00
        tya
@l:
        sta     (sreg),y
        iny
        cpy     #$20
        bne     @l
        lda     #$ff
        ldy     #$06
        sta     (sreg),y
        ldy     #$0d
        sta     (sreg),y
        ldy     #$14
        sta     (sreg),y
        lda     #$49
        ldy     #$04
        sta     (sreg),y
        ldy     #$0b
        sta     (sreg),y
        ldy     #$12
        sta     (sreg),y

        stx     $01
        rts

_sid_output:
        ldx     $01
        ldy     #$18
        sty     sreg
        ldy     #$da
        sty     sreg + 1
        ldy     #$0f
        sty     $01
        ldy     #$00
        lsr
        lsr
        lsr
        lsr
        sta     (sreg),y
        stx     $01
        rts
