;
; Marco van den Heuvel, 28.01.2016
;
; void __fastcall__ set_sid_addr(unsigned addr);
; void __fastcall__ set_digimax_addr(unsigned addr);
;
; unsigned char __fastcall__ sampler_2bit_joy1_input(void);
; unsigned char __fastcall__ sampler_4bit_joy1_input(void);
; unsigned char __fastcall__ sfx_input(void);
; unsigned char __fastcall__ sfx_io_swapped_input(void);
; void __fastcall__ sampler_2bit_hummer_input_init(void);
; unsigned char __fastcall__ sampler_2bit_hummer_input(void);
; void __fastcall__ sampler_4bit_hummer_input_init(void);
; unsigned char __fastcall__ sampler_4bit_hummer_input(void);
; void __fastcall__ sampler_2bit_spt_input_init(void);
; unsigned char __fastcall__ sampler_2bit_spt_input(void);
; void __fastcall__ sampler_4bit_spt_input_init(void);
; unsigned char __fastcall__ sampler_4bit_spt_input(void);
; void __fastcall__ sampler_2bit_oem_input_init(void);
; unsigned char __fastcall__ sampler_2bit_oem_input(void);
; void __fastcall__ sampler_4bit_oem_input_init(void);
; unsigned char __fastcall__ sampler_4bit_oem_input(void);
; void __fastcall__ sampler_2bit_pet1_input_init(void);
; unsigned char __fastcall__ sampler_2bit_pet1_input(void);
; void __fastcall__ sampler_4bit_pet1_input_init(void);
; unsigned char __fastcall__ sampler_4bit_pet1_input(void);
; void __fastcall__ sampler_2bit_syn1_input_init(void);
; unsigned char __fastcall__ sampler_2bit_syn1_input(void);
; void __fastcall__ sampler_4bit_syn1_input_init(void);
; unsigned char __fastcall__ sampler_4bit_syn1_input(void);
; void __fastcall__ sampler_2bit_syn2_input_init(void);
; unsigned char __fastcall__ sampler_2bit_syn2_input(void);
; void __fastcall__ sampler_4bit_syn2_input_init(void);
; unsigned char __fastcall__ sampler_4bit_syn2_input(void);
; void __fastcall__ sampler_2bit_syn3_input_init(void);
; unsigned char __fastcall__ sampler_2bit_syn3_input(void);
; void __fastcall__ sampler_4bit_syn3_input_init(void);
; unsigned char __fastcall__ sampler_4bit_syn3_input(void);
; void __fastcall__ sampler_2bit_woj1_input_init(void);
; unsigned char __fastcall__ sampler_2bit_woj1_input(void);
; void __fastcall__ sampler_4bit_woj1_input_init(void);
; unsigned char __fastcall__ sampler_4bit_woj1_input(void);
; void __fastcall__ sampler_2bit_woj2_input_init(void);
; unsigned char __fastcall__ sampler_2bit_woj2_input(void);
; void __fastcall__ sampler_4bit_woj2_input_init(void);
; unsigned char __fastcall__ sampler_4bit_woj2_input(void);
; void __fastcall__ sampler_2bit_woj3_input_init(void);
; unsigned char __fastcall__ sampler_2bit_woj3_input(void);
; void __fastcall__ sampler_4bit_woj3_input_init(void);
; unsigned char __fastcall__ sampler_4bit_woj3_input(void);
; void __fastcall__ sampler_2bit_woj4_input_init(void);
; unsigned char __fastcall__ sampler_2bit_woj4_input(void);
; void __fastcall__ sampler_4bit_woj4_input_init(void);
; unsigned char __fastcall__ sampler_4bit_woj4_input(void);
; void __fastcall__ sampler_2bit_woj5_input_init(void);
; unsigned char __fastcall__ sampler_2bit_woj5_input(void);
; void __fastcall__ sampler_4bit_woj5_input_init(void);
; unsigned char __fastcall__ sampler_4bit_woj5_input(void);
; void __fastcall__ sampler_2bit_woj6_input_init(void);
; unsigned char __fastcall__ sampler_2bit_woj6_input(void);
; void __fastcall__ sampler_4bit_woj6_input_init(void);
; unsigned char __fastcall__ sampler_4bit_woj6_input(void);
; void __fastcall__ sampler_2bit_woj7_input_init(void);
; unsigned char __fastcall__ sampler_2bit_woj7_input(void);
; void __fastcall__ sampler_4bit_woj7_input_init(void);
; unsigned char __fastcall__ sampler_4bit_woj7_input(void);
; void __fastcall__ sampler_2bit_woj8_input_init(void);
; unsigned char __fastcall__ sampler_2bit_woj8_input(void);
; void __fastcall__ sampler_4bit_woj8_input_init(void);
; unsigned char __fastcall__ sampler_4bit_woj8_input(void);
; void __fastcall__ sampler_2bit_pet2_input_init(void);
; unsigned char __fastcall__ sampler_2bit_pet2_input(void);
; void __fastcall__ sampler_4bit_pet2_input_init(void);
; unsigned char __fastcall__ sampler_4bit_pet2_input(void);
; void __fastcall__ sampler_2bit_cga1_input_init(void);
; unsigned char __fastcall__ sampler_2bit_cga1_input(void);
; void __fastcall__ sampler_4bit_cga1_input_init(void);
; unsigned char __fastcall__ sampler_4bit_cga1_input(void);
; void __fastcall__ sampler_2bit_cga2_input_init(void);
; unsigned char __fastcall__ sampler_2bit_cga2_input(void);
; void __fastcall__ sampler_4bit_cga2_input_init(void);
; unsigned char __fastcall__ sampler_4bit_cga2_input(void);
;
; void __fastcall__ digimax_cart_output(unsigned char sample);
; void __fastcall__ sfx_output(unsigned char sample);
; void __fastcall__ sfx_io_swapped_output(unsigned char sample);
; void __fastcall__ sid_output_init(void);
; void __fastcall__ sid_output(unsigned char sample);
; void __fastcall__ userport_dac_output_init(void);
; void __fastcall__ userport_dac_output(unsigned char sample);
; void __fastcall__ vic_output(unsigned char sample);
; void __fastcall__ sfx_sound_expander_output_init(void);
; void __fastcall__ sfx_sound_expander_output(unsigned char sample);
; void __fastcall__ sfx_sound_expander_io_swapped_output_init(void);
;
; void __fastcall__ show_sample(unsigned char sample);
;

        .export  _sampler_2bit_joy1_input
        .export  _sampler_4bit_joy1_input
        .export  _sfx_input
        .export  _sfx_io_swapped_input
        .export  _sampler_2bit_hummer_input_init, _sampler_2bit_hummer_input
        .export  _sampler_4bit_hummer_input_init, _sampler_4bit_hummer_input
        .export  _sampler_2bit_spt_input_init, _sampler_2bit_spt_input
        .export  _sampler_4bit_spt_input_init, _sampler_4bit_spt_input
        .export  _sampler_2bit_oem_input_init, _sampler_2bit_oem_input
        .export  _sampler_4bit_oem_input_init, _sampler_4bit_oem_input
        .export  _sampler_2bit_pet1_input_init, _sampler_2bit_pet1_input
        .export  _sampler_4bit_pet1_input_init, _sampler_4bit_pet1_input
        .export  _sampler_2bit_syn1_input_init, _sampler_2bit_syn1_input
        .export  _sampler_4bit_syn1_input_init, _sampler_4bit_syn1_input
        .export  _sampler_2bit_syn2_input_init, _sampler_2bit_syn2_input
        .export  _sampler_4bit_syn2_input_init, _sampler_4bit_syn2_input
        .export  _sampler_2bit_syn3_input_init, _sampler_2bit_syn3_input
        .export  _sampler_4bit_syn3_input_init, _sampler_4bit_syn3_input
        .export  _sampler_2bit_woj1_input_init, _sampler_2bit_woj1_input
        .export  _sampler_4bit_woj1_input_init, _sampler_4bit_woj1_input
        .export  _sampler_2bit_woj2_input_init, _sampler_2bit_woj2_input
        .export  _sampler_4bit_woj2_input_init, _sampler_4bit_woj2_input
        .export  _sampler_2bit_woj3_input_init, _sampler_2bit_woj3_input
        .export  _sampler_4bit_woj3_input_init, _sampler_4bit_woj3_input
        .export  _sampler_2bit_woj4_input_init, _sampler_2bit_woj4_input
        .export  _sampler_4bit_woj4_input_init, _sampler_4bit_woj4_input
        .export  _sampler_2bit_woj5_input_init, _sampler_2bit_woj5_input
        .export  _sampler_4bit_woj5_input_init, _sampler_4bit_woj5_input
        .export  _sampler_2bit_woj6_input_init, _sampler_2bit_woj6_input
        .export  _sampler_4bit_woj6_input_init, _sampler_4bit_woj6_input
        .export  _sampler_2bit_woj7_input_init, _sampler_2bit_woj7_input
        .export  _sampler_4bit_woj7_input_init, _sampler_4bit_woj7_input
        .export  _sampler_2bit_woj8_input_init, _sampler_2bit_woj8_input
        .export  _sampler_4bit_woj8_input_init, _sampler_4bit_woj8_input
        .export  _sampler_2bit_pet2_input_init, _sampler_2bit_pet2_input
        .export  _sampler_4bit_pet2_input_init, _sampler_4bit_pet2_input
        .export  _sampler_2bit_cga1_input_init, _sampler_2bit_cga1_input
        .export  _sampler_4bit_cga1_input_init, _sampler_4bit_cga1_input
        .export  _sampler_2bit_cga2_input_init, _sampler_2bit_cga2_input
        .export  _sampler_4bit_cga2_input_init, _sampler_4bit_cga2_input

        .export  _digimax_cart_output
        .export  _sfx_output
        .export  _sfx_io_swapped_output
        .export  _sid_output_init, _sid_output
        .export  _userport_dac_output_init, _userport_dac_output
        .export  _vic_output
        .export  _sfx_sound_expander_output_init, _sfx_sound_expander_output
        .export  _sfx_sound_expander_io_swapped_output_init

        .export  _set_sid_addr
        .export  _set_digimax_addr

        .export  _show_sample

        .importzp       tmp1, tmp2

_sampler_2bit_hummer_input_init:
_sampler_4bit_hummer_input_init:
_sampler_2bit_spt_input_init:
_sampler_4bit_spt_input_init:
_sampler_2bit_oem_input_init:
_sampler_4bit_oem_input_init:
_sampler_2bit_pet1_input_init:
_sampler_4bit_pet1_input_init:
_sampler_2bit_pet2_input_init:
_sampler_4bit_pet2_input_init:
        ldx     #$00
        stx     $9112
        rts

e0_9112:
        ldx     #$E0
        stx     $9112
        rts

_sampler_2bit_woj1_input_init:
_sampler_4bit_woj1_input_init:
        jsr     e0_9112
        ldx     #$00
        stx     $9110
        rts

_sampler_2bit_woj2_input_init:
_sampler_4bit_woj2_input_init:
        jsr     e0_9112
        ldx     #$20
        stx     $9110
        rts

_sampler_2bit_woj3_input_init:
_sampler_4bit_woj3_input_init:
        jsr     e0_9112
        ldx     #$40
        stx     $9110
        rts

_sampler_2bit_syn3_input_init:
_sampler_4bit_syn3_input_init:
_sampler_2bit_woj4_input_init:
_sampler_4bit_woj4_input_init:
        jsr     e0_9112
        ldx     #$60
        stx     $9110
        rts

_sampler_2bit_woj5_input_init:
_sampler_4bit_woj5_input_init:
        jsr     e0_9112
        ldx     #$80
        stx     $9110
        rts

_sampler_2bit_syn2_input_init:
_sampler_4bit_syn2_input_init:
_sampler_2bit_woj6_input_init:
_sampler_4bit_woj6_input_init:
        jsr     e0_9112
        ldx     #$A0
        stx     $9110
        rts

_sampler_2bit_syn1_input_init:
_sampler_4bit_syn1_input_init:
_sampler_2bit_woj7_input_init:
_sampler_4bit_woj7_input_init:
        jsr     e0_9112
        ldx     #$C0
        stx     $9110
        rts

_sampler_2bit_woj8_input_init:
_sampler_4bit_woj8_input_init:
        jsr     e0_9112
        ldx     #$E0
        stx     $9110
        rts

_sampler_2bit_cga1_input_init:
_sampler_4bit_cga1_input_init:
        ldx     #$80
        stx     $9112
storex_9110:
        stx     $9110
        rts

_sampler_2bit_cga2_input_init:
_sampler_4bit_cga2_input_init:
        ldx     #$80
        stx     $9112
        ldx     #$00
        jmp     storex_9110

_sampler_2bit_pet2_input:
        lda     $9110
        and     #$30
        asl
        asl
        rts

_sampler_4bit_pet2_input:
        lda     $9110
        and     #$f0
        rts

_sampler_2bit_oem_input:
        lda     $9110
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
        lda     $9110
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
_sampler_2bit_cga1_input:
_sampler_2bit_cga2_input:
_sampler_2bit_syn1_input:
_sampler_2bit_syn2_input:
_sampler_2bit_syn3_input:
_sampler_2bit_woj1_input:
_sampler_2bit_woj2_input:
_sampler_2bit_woj3_input:
_sampler_2bit_woj4_input:
_sampler_2bit_woj5_input:
_sampler_2bit_woj6_input:
_sampler_2bit_woj7_input:
_sampler_2bit_woj8_input:
        lda     $9110
        asl
        asl
        jmp     do_asl4

_sampler_2bit_spt_input:
        lda     $9110
        and     #$0C
        jmp     do_asl4

_sampler_4bit_hummer_input:
_sampler_4bit_pet1_input:
_sampler_4bit_cga1_input:
_sampler_4bit_cga2_input:
_sampler_4bit_syn1_input:
_sampler_4bit_syn2_input:
_sampler_4bit_syn3_input:
_sampler_4bit_woj1_input:
_sampler_4bit_woj2_input:
_sampler_4bit_woj3_input:
_sampler_4bit_woj4_input:
_sampler_4bit_woj5_input:
_sampler_4bit_woj6_input:
_sampler_4bit_woj7_input:
_sampler_4bit_woj8_input:
        lda     $9110
        jmp     do_asl4

_sampler_4bit_spt_input:
        lda     $9110
        sta     tmp1
        and     #$0C
        lsr
        lsr
        sta     tmp2
        lda     tmp1
        and     #$03
        asl
        asl
        ora     tmp2
        jmp     do_asl4

_sampler_2bit_joy1_input:
        lda     $9111
        and     #$0c
do_asl4:
        asl
        asl
        asl
        asl
        rts

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

_sfx_input:
        lda     $9800
        sta     $9c00
        rts

_sfx_io_swapped_input:
        lda     $9c00
        sta     $9800
        rts

_set_digimax_addr:
        sta     store_digimax+1
        stx     store_digimax+2
        rts

store_digimax:
        sta     $9800,x
        rts

_digimax_cart_output:
        ldx     #$00
        jsr     store_digimax
        inx
        jsr     store_digimax
        inx
        jsr     store_digimax
        inx
        jmp     store_digimax

_sfx_output:
        sta     $9800
        rts

_sfx_io_swapped_output:
        sta     $9c00
        rts

_set_sid_addr:
        sta     store_sid+1
        stx     store_sid+2
        rts

store_sid:
        sta     $9800,x
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

_userport_dac_output_init:
        ldx     #$ff
        stx     $9112
        rts

_userport_dac_output:
        sta     $9110
        rts

_vic_output:
        lsr
        lsr
        lsr
        lsr
        sta     $900e
        rts

sfx_se_write:
        stx     $9c40               ; select ym3526 register
        nop
        nop
        nop
        nop                         ; wait 12 cycles for register select
sfx_se_write2:
        sta     $9c50               ; write to it
        ldx     #$04
loop:
        dex
        nop
        bne loop                    ; wait 36 cycles to do the next write
        rts

_sfx_sound_expander_io_swapped_output_init:
        lda     #$98
        sta     sfx_se_write+2
        sta     sfx_se_write2+2
        jmp     sfx_se_real_init

_sfx_sound_expander_output_init:
        lda     #$9c
        sta     sfx_se_write+2
        sta     sfx_se_write2+2
        jmp     sfx_se_real_init

sfx_se_real_init:
        lda     #$21
        ldx     #$20
        jsr     sfx_se_write        ; Sets MULTI=1,AM=0,VIB=0,KSR=0,EG=1 for operator 1
        lda     #$f0
        ldx     #$60
        jsr     sfx_se_write        ; Sets attack rate to 15 and decay rate to 0 for operator 1
        ldx     #$80
        jsr     sfx_se_write        ; Sets the sustain level to 15 and the release rate to 0 for operator 1
        lda     #$01
        ldx     #$c0
        jsr     sfx_se_write        ; Feedback=0 and Additive Synthesis is on  for voice 1 [which is operator 1 and operator 4]
        lda     #$00
        ldx     #$e0
        jsr     sfx_se_write        ; Waveform=regular sine wave for operator 1
        lda     #$3f
        ldx     #$43
        jsr     sfx_se_write        ; sets total level=63 and attenuation for operator 4
        lda     #$01
        ldx     #$b0
        jsr     sfx_se_write
        lda     #$8f
        ldx     #$a0
        jsr     sfx_se_write
        lda     #$2e
        ldx     #$b0
        jsr     sfx_se_write
        lda     $d012

; FIXME: need correct way of waiting for top of sine wave

        ldy     #$0a
loop1:
        ldx     #$de
loop2:
        dex
        nop
        bne     loop2
        dey
        bne     loop1
        lda     #$20
        ldx     #$b0
        jsr     sfx_se_write
        lda     #$00
        ldx     #$b0
        jmp     sfx_se_write

_sfx_sound_expander_output:
        lsr
        lsr
        ldx     #$40
        jmp     sfx_se_write

_show_sample:
        tax
        lsr
        lsr
        lsr
        lsr
        lsr
        tay
        lda     $900f
        and     #$f8
        sta     $900f
        tya
        ora     $900f
        sta     $900f
        txa
        rts
