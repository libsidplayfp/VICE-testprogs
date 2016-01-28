;
; Marco van den Heuvel, 27.01.2016
;
; void __fastcall__ sfx_output(unsigned char sample);
;

        .export  _sfx_output

_sfx_output:
        sta     $9800
        rts
