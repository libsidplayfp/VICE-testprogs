;
; Marco van den Heuvel, 27.01.2016
;
; void set_input_jsr(unsigned addr);
; void set_output_jsr(unsigned addr);
; void stream(void);
;

        .export		_set_input_jsr, _set_output_jsr, _stream


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
outputjsr:
        jsr     $ffff
        jmp     inputjsr
