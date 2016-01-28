;
; Marco van den Heuvel, 27.01.2016
;
; unsigned char __fastcall__ sampler_4bit_joy1_input(void);
;

        .export  _sampler_4bit_joy1_input

_sampler_4bit_joy1_input:
        lda     $dc01
        and     #$0f
        asl
        asl
        asl
        asl
        rts
