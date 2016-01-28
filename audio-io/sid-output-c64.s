;
; Marco van den Heuvel, 27.01.2016
;
; void __fastcall__ sid_output_init(void);
; void __fastcall__ sid_output(unsigned char sample);
;

        .export  _sid_output_init, _sid_output

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
