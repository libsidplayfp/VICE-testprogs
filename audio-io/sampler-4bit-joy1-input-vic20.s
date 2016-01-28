;
; Marco van den Heuvel, 27.01.2016
;
; unsigned char __fastcall__ sampler_4bit_joy1_input(void);
;

        .export         _sampler_4bit_joy1_input
        .importzp       tmp1

_sampler_4bit_joy1_input:
        lda     $9111
        and     #$1c
        asl
        asl
        sta     tmp1
        lda     $9120
        and     #$80
        clc
        adc     tmp1
        rts
