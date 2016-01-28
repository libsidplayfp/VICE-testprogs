;
; Marco van den Heuvel, 27.01.2016
;
; void __fastcall__ digimax_cart_output(unsigned char sample);
;

        .export  _digimax_cart_output

_digimax_cart_output:
        sta     $de00
        sta     $de01
        sta     $de02
        sta     $de03
        rts
