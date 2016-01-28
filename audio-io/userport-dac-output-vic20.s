;
; Marco van den Heuvel, 27.01.2016
;
; void __fastcall__ userport_dac_output_init(void);
; void __fastcall__ userport_dac_output(unsigned char sample);
;

        .export  _userport_dac_output_init, _userport_dac_output

_userport_dac_output_init:
        ldx     #$ff
        stx     $9112
        rts

_userport_dac_output:
        sta     $9110
        rts
