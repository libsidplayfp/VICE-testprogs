;
; Marco van den Heuvel, 28.01.2016
;
; unsigned char __fastcall__ digiblaster_input(void);
; unsigned char __fastcall__ sampler_2bit_joy1_input(void);
; unsigned char __fastcall__ sampler_4bit_joy1_input(void);
;
; void __fastcall__ digiblaster_output(unsigned char sample);
; void __fastcall__ sid_output_init(void);
; void __fastcall__ sid_output(unsigned char sample);
; void __fastcall__ userport_dac_output(unsigned char sample);
;

        .export  _digiblaster_input
        .export  _sampler_2bit_joy1_input
        .export  _sampler_4bit_joy1_input

        .export  _digiblaster_output
        .export  _sid_output_init, _sid_output
        .export  _userport_dac_output

load_joy1:
        lda     #$fa
        sta     $ff08
        lda     $ff08
        rts

_digiblaster_input:
        lda     $fd5f
        rts

_sampler_2bit_joy1_input:
        jsr     load_joy1
        asl
        asl
        jmp     do_asl4

_sampler_4bit_joy1_input:
        jsr     load_joy1
do_asl4:
        asl
        asl
        asl
        asl
        rts

_digiblaster_output:
        sta     $fd5e
        rts

_sid_output_init:
        lda     #$00
        ldx     #$00
@l:
        sta     $fd40,x
        inx
        cpx     #$20
        bne     @l
        lda     #$ff
        sta     $fd46
        sta     $fd4d
        sta     $fd54
        lda     #$49
        sta     $fd44
        sta     $fd4b
        sta     $fd52
        rts

_sid_output:
        lsr
        lsr
        lsr
        lsr
        sta     $fd58
        rts

_userport_dac_output:
        sta     $fd10
        rts
