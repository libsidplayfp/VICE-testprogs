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
