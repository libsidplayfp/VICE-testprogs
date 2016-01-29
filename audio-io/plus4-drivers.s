;
; Marco van den Heuvel, 28.01.2016
;
; unsigned char __fastcall__ digiblaster_input(void);
; unsigned char __fastcall__ sampler_2bit_joy1_input(void);
; unsigned char __fastcall__ sampler_4bit_joy1_input(void);
; unsigned char __fastcall__ sampler_2bit_joy2_input(void);
; unsigned char __fastcall__ sampler_4bit_joy2_input(void);
; unsigned char __fastcall__ sampler_2bit_sidcart_input(void);
; unsigned char __fastcall__ sampler_4bit_sidcart_input(void);
; unsigned char __fastcall__ sampler_2bit_hummer_input(void);
; unsigned char __fastcall__ sampler_4bit_hummer_input(void);
; unsigned char __fastcall__ sampler_2bit_oem_input(void);
; unsigned char __fastcall__ sampler_4bit_oem_input(void);
;
; void __fastcall__ digiblaster_output(unsigned char sample);
; void __fastcall__ sid_output_init(void);
; void __fastcall__ sid_output(unsigned char sample);
; void __fastcall__ userport_dac_output(unsigned char sample);
; void __fastcall__ ted_output(void);
;

        .export  _digiblaster_input
        .export  _sampler_2bit_joy1_input
        .export  _sampler_4bit_joy1_input
        .export  _sampler_2bit_joy2_input
        .export  _sampler_4bit_joy2_input
        .export  _sampler_2bit_sidcart_input
        .export  _sampler_4bit_sidcart_input
        .export  _sampler_2bit_hummer_input
        .export  _sampler_4bit_hummer_input
        .export  _sampler_2bit_oem_input
        .export  _sampler_4bit_oem_input

        .export  _digiblaster_output
        .export  _sid_output_init, _sid_output
        .export  _userport_dac_output
        .export  _ted_output

        .importzp   tmp1, tmp2

_sampler_2bit_oem_input:
        lda     $fd10
        sta     tmp2
        and     #$40
        asl
        sta     tmp1
        lda     tmp2
        and     #$80
        lsr
        ora     tmp1
        rts

_sampler_4bit_oem_input:
        lda     $fd10
        sta     tmp2
        and     #$10
        asl
        asl
        asl
        sta     tmp1
        lda     tmp2
        and     #$20
        asl
        ora     tmp1
        sta     tmp1
        lda     tmp2
        and     #$40
        lsr
        ora     tmp1
        sta     tmp1
        lda     tmp2
        and     #$80
        lsr
        lsr
        lsr
        ora     tmp1
        rts

_sampler_2bit_hummer_input:
        lda     $fd10
        asl
        asl
        jmp     do_asl4

_sampler_4bit_hummer_input:
        lda     $fd10
        jmp     do_asl4

load_joy1:
        lda     #$fa
load_joy:
        sta     $ff08
        lda     $ff08
        rts

load_joy2:
        lda     #$fd
        jmp     load_joy

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

_sampler_2bit_joy2_input:
        jsr     load_joy2
        asl
        asl
        jmp     do_asl4

_sampler_4bit_joy2_input:
        jsr     load_joy2
        jmp     do_asl4

_sampler_2bit_sidcart_input:
        lda     $fd80
        asl
        asl
        jmp     do_asl4

_sampler_4bit_sidcart_input:
        lda     $fd80
        jmp     do_asl4

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

_ted_output:
        and     #$0f
        tax
        lda     ted_table,x
        sta     $ff11
        rts

ted_table:
        .byte   $90,$91,$92,$93,$94,$95,$96,$97,$98,$b5,$b6,$b7,$b8,$05,$05,$15
