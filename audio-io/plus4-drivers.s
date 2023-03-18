;
; Marco van den Heuvel, 28.01.2016
;
; void __fastcall__ set_sid_addr(unsigned addr);
;
; unsigned char __fastcall__ digiblaster_fd5x_input(void);
; unsigned char __fastcall__ digiblaster_fe9x_input(void);
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
; unsigned char __fastcall__ sampler_2bit_pet1_input(void);
; unsigned char __fastcall__ sampler_4bit_pet1_input(void);
; unsigned char __fastcall__ sampler_2bit_pet2_input(void);
; unsigned char __fastcall__ sampler_4bit_pet2_input(void);
;
; void __fastcall__ digiblaster_fd5x_output(unsigned char sample);
; void __fastcall__ digiblaster_fe9x_output(unsigned char sample);
; void __fastcall__ sid_output_init(void);
; void __fastcall__ sid_output(unsigned char sample);
; void __fastcall__ userport_dac_output(unsigned char sample);
; void __fastcall__ ted_output(void);
;
; void __fastcall__ show_sample(unsigned char sample);
;

        .export  _digiblaster_fd5x_input
        .export  _digiblaster_fe9x_input
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
        .export  _sampler_2bit_pet1_input
        .export  _sampler_4bit_pet1_input
        .export  _sampler_2bit_pet2_input
        .export  _sampler_4bit_pet2_input

        .export  _digiblaster_fd5x_output
        .export  _digiblaster_fe9x_output
        .export  _sid_output_init, _sid_output
        .export  _userport_dac_output
        .export  _ted_output

        .export  _set_sid_addr

        .export  _show_sample

        .importzp   tmp1, tmp2

_sampler_2bit_pet2_input:
        lda     $fd10
        and     #$30
        asl
        asl
        rts

_sampler_4bit_pet2_input:
        lda     $fd10
        and     #$f0
        rts

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
_sampler_2bit_pet1_input:
        lda     $fd10
        asl
        asl
        jmp     do_asl4

_sampler_4bit_hummer_input:
_sampler_4bit_pet1_input:
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

_digiblaster_fd5x_input:
        lda     $fd5f
        rts

_digiblaster_fe9x_input:
        lda     $fe9f
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

_digiblaster_fd5x_output:
        sta     $fd5e
        rts

_digiblaster_fe9x_output:
        sta     $fe9e
        rts

_set_sid_addr:
        sta     store_sid+1
        stx     store_sid+2
        rts

store_sid:
        sta     $fd40,x
        rts

_sid_output_init:
        lda     #$00
        tax
@l:
        jsr     store_sid
        inx
        cpx     #$20
        bne     @l
        lda     #$ff
        ldx     #$06
        jsr     store_sid
        ldx     #$0d
        jsr     store_sid
        ldx     #$14
        jsr     store_sid
        lda     #$49
        ldx     #$04
        jsr     store_sid
        ldx     #$0b
        jsr     store_sid
        ldx     #$12
        jmp     store_sid

_sid_output:
        lsr
        lsr
        lsr
        lsr
        ldx     #$18
        jmp     store_sid

_userport_dac_output:
        sta     $fd10
        rts

_ted_output:
        and     #$0f
        tax
        lda     ted_table,x
        sta     $ff11
        rts

_show_sample:
        sta     $ff19
        rts

ted_table:
        .byte   $90,$91,$92,$93,$94,$95,$96,$97,$98,$b5,$b6,$b7,$b8,$05,$05,$15
