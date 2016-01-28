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
        sta     $fd40,x
        inx
        cpx     #$20
        bne     @l
        lda     #$ff
        sta     $fd46
        sta     $fd4d
        sta     $fd54
        lda     #$49
        sta     $fd44
        sta     $fd4b
        sta     $fd52
        rts

_sid_output:
        lsr
        lsr
        lsr
        lsr
        sta     $fd58
        rts
