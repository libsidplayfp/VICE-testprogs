;
; Marco van den Heuvel, 27.01.2016
;
; void __fastcall__ userport_dac_output(unsigned char sample);
;

        .export  _userport_dac_output

_userport_dac_output:
        sta     $fd10
        rts
