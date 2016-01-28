;
; Marco van den Heuvel, 27.01.2016
;
; unsigned char __fastcall__ sfx_input(void);
;

        .export  _sfx_input

_sfx_input:
        lda     $df00
        sta     $de00
        rts
