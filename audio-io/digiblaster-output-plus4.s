;
; Marco van den Heuvel, 27.01.2016
;
; void __fastcall__ digiblaster_output(unsigned char sample);
;

        .export  _digiblaster_output

_digiblaster_output:
        sta     $fd5e
        rts
