;
; Marco van den Heuvel, 27.01.2016
;
; void __fastcall__ vic_output(unsigned char sample);
;

        .export  _vic_output

_vic_output:
        lsr
        lsr
        lsr
        lsr
        sta     $900e
        rts
