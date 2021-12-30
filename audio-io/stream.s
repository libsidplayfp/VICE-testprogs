;
; Marco van den Heuvel, 27.01.2016
;
; void __fastcall__ set_input_jsr(unsigned addr);
; void __fastcall__ set_output_jsr(unsigned addr);
; void __fastcall__ stream(void);
;
; unsigned char __fastcall__ software_input(void);
;
;

        .export		_set_input_jsr, _set_output_jsr, _stream
        .export      _software_input

        .import      _show_sample


software_byte:
	   .byte   $00

_software_input:
        inc     software_byte
        lda     software_byte
        rts

; Set the input jsr
_set_input_jsr:
        sta     inputjsr+1
        stx     inputjsr+2
        rts

; Set the output jsr
_set_output_jsr:
        sta     outputjsr+1
        stx     outputjsr+2
        rts

; stream
_stream:
inputjsr:
        jsr     $ffff
        jsr     _show_sample
outputjsr:
        jsr     $ffff
        jmp     inputjsr
