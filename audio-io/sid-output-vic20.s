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
