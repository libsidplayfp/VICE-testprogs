;
; Marco van den Heuvel, 27.01.2016
;
; unsigned char __fastcall__ digiblaster_input(void);
;

        .export  _digiblaster_input

_digiblaster_input:
        lda     $fd5f
        rts
