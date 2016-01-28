;
; Marco van den Heuvel, 27.01.2016
;
; void __fastcall__ digimax_cart_output(unsigned char sample);
;

        .export  _digimax_cart_output

_digimax_cart_output:
        sta     $9800
        sta     $9801
        sta     $9802
        sta     $9803
        rts
