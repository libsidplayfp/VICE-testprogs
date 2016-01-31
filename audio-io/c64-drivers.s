;
; Marco van den Heuvel, 28.01.2016
;
; unsigned char __fastcall__ sfx_input(void);
; unsigned char __fastcall__ sampler_2bit_joy1_input(void);
; unsigned char __fastcall__ sampler_4bit_joy1_input(void);
; unsigned char __fastcall__ sampler_2bit_joy2_input(void);
; unsigned char __fastcall__ sampler_4bit_joy2_input(void);
; void __fastcall__ sampler_2bit_hummer_input_init(void);
; unsigned char __fastcall__ sampler_2bit_hummer_input(void);
; void __fastcall__ sampler_4bit_hummer_input_init(void);
; unsigned char __fastcall__ sampler_4bit_hummer_input(void);
; void __fastcall__ sampler_2bit_oem_input_init(void);
; unsigned char __fastcall__ sampler_2bit_oem_input(void);
; void __fastcall__ sampler_4bit_oem_input_init(void);
; unsigned char __fastcall__ sampler_4bit_oem_input(void);
; void __fastcall__ sampler_2bit_pet1_input_init(void);
; unsigned char __fastcall__ sampler_2bit_pet1_input(void);
; void __fastcall__ sampler_4bit_pet1_input_init(void);
; unsigned char __fastcall__ sampler_4bit_pet1_input(void);
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
; void __fastcall__ sampler_2bit_hit1_input_init(void);
; unsigned char __fastcall__ sampler_2bit_hit1_input(void);
; void __fastcall__ sampler_4bit_hit1_input_init(void);
; unsigned char __fastcall__ sampler_4bit_hit1_input(void);
; void __fastcall__ sampler_2bit_hit2_input_init(void);
; unsigned char __fastcall__ sampler_2bit_hit2_input(void);
; void __fastcall__ sampler_4bit_hit2_input_init(void);
; unsigned char __fastcall__ sampler_4bit_hit2_input(void);
; void __fastcall__ sampler_2bit_kingsoft1_input_init(void);
; unsigned char __fastcall__ sampler_2bit_kingsoft1_input(void);
; void __fastcall__ sampler_4bit_kingsoft1_input_init(void);
; unsigned char __fastcall__ sampler_4bit_kingsoft1_input(void);
; void __fastcall__ sampler_2bit_kingsoft2_input_init(void);
; unsigned char __fastcall__ sampler_2bit_kingsoft2_input(void);
; void __fastcall__ sampler_4bit_kingsoft2_input_init(void);
; unsigned char __fastcall__ sampler_4bit_kingsoft2_input(void);
; void __fastcall__ sampler_2bit_starbyte1_input_init(void);
; unsigned char __fastcall__ sampler_2bit_starbyte1_input(void);
; void __fastcall__ sampler_4bit_starbyte1_input_init(void);
; unsigned char __fastcall__ sampler_4bit_starbyte1_input(void);
; void __fastcall__ sampler_2bit_starbyte2_input_init(void);
; unsigned char __fastcall__ sampler_2bit_starbyte2_input(void);
; void __fastcall__ sampler_4bit_starbyte2_input_init(void);
; unsigned char __fastcall__ sampler_4bit_starbyte2_input(void);
; void __fastcall__ sampler_4bit_userport_input_init(void);
; unsigned char __fastcall__ sampler_4bit_userport_input(void);
;
; void __fastcall__ digimax_cart_output(unsigned char sample);
; void __fastcall__ sfx_output(unsigned char sample);
; void __fastcall__ sid_output_init(void);
; void __fastcall__ sid_output(unsigned char sample);
; void __fastcall__ siddtv_output_init(void);
; void __fastcall__ siddtv_output(unsigned char sample);
; void __fastcall__ userport_dac_output_init(void);
; void __fastcall__ userport_dac_output(unsigned char sample);
; void __fastcall__ userport_digimax_output_init(void);
; void __fastcall__ userport_digimax_output(unsigned char sample);
; void __fastcall__ sfx_sound_expander_output_init(void);
; void __fastcall__ sfx_sound_expander_output(unsigned char sample);
;

        .export  _sfx_input
        .export  _sampler_2bit_joy1_input
        .export  _sampler_4bit_joy1_input
        .export  _sampler_2bit_joy2_input
        .export  _sampler_4bit_joy2_input
        .export  _sampler_2bit_hummer_input_init, _sampler_2bit_hummer_input
        .export  _sampler_4bit_hummer_input_init, _sampler_4bit_hummer_input
        .export  _sampler_2bit_oem_input_init, _sampler_2bit_oem_input
        .export  _sampler_4bit_oem_input_init, _sampler_4bit_oem_input
        .export  _sampler_2bit_pet1_input_init, _sampler_2bit_pet1_input
        .export  _sampler_4bit_pet1_input_init, _sampler_4bit_pet1_input
        .export  _sampler_2bit_pet2_input_init, _sampler_2bit_pet2_input
        .export  _sampler_4bit_pet2_input_init, _sampler_4bit_pet2_input
        .export  _sampler_2bit_cga1_input_init, _sampler_2bit_cga1_input
        .export  _sampler_4bit_cga1_input_init, _sampler_4bit_cga1_input
        .export  _sampler_2bit_cga2_input_init, _sampler_2bit_cga2_input
        .export  _sampler_4bit_cga2_input_init, _sampler_4bit_cga2_input
        .export  _sampler_2bit_hit1_input_init, _sampler_2bit_hit1_input
        .export  _sampler_4bit_hit1_input_init, _sampler_4bit_hit1_input
        .export  _sampler_2bit_hit2_input_init, _sampler_2bit_hit2_input
        .export  _sampler_4bit_hit2_input_init, _sampler_4bit_hit2_input
        .export  _sampler_2bit_kingsoft1_input_init, _sampler_2bit_kingsoft1_input
        .export  _sampler_4bit_kingsoft1_input_init, _sampler_4bit_kingsoft1_input
        .export  _sampler_2bit_kingsoft2_input_init, _sampler_2bit_kingsoft2_input
        .export  _sampler_4bit_kingsoft2_input_init, _sampler_4bit_kingsoft2_input
        .export  _sampler_2bit_starbyte1_input_init, _sampler_2bit_starbyte1_input
        .export  _sampler_4bit_starbyte1_input_init, _sampler_4bit_starbyte1_input
        .export  _sampler_2bit_starbyte2_input_init, _sampler_2bit_starbyte2_input
        .export  _sampler_4bit_starbyte2_input_init, _sampler_4bit_starbyte2_input
        .export  _sampler_4bit_userport_input_init, _sampler_4bit_userport_input

        .export  _digimax_cart_output
        .export  _sfx_output
        .export  _sid_output_init, _sid_output
        .export  _siddtv_output_init, _siddtv_output
        .export  _userport_dac_output_init, _userport_dac_output
        .export  _userport_digimax_output_init, _userport_digimax_output
        .export  _sfx_sound_expander_output_init, _sfx_sound_expander_output

        .importzp   tmp1, tmp2

_sampler_4bit_userport_input_init:
        lda     $dd02
        ora     #$04
        sta     $dd02
        lda     $dd00
        and     #$fb
        sta     $dd00
        jmp     _sampler_2bit_hummer_input_init


_sampler_2bit_kingsoft1_input_init:
_sampler_4bit_kingsoft1_input_init:
_sampler_2bit_starbyte2_input_init:
_sampler_4bit_starbyte2_input_init:
        lda     $dd02
        and     #$fb
        sta     $dd02

; run into pbx read init

_sampler_2bit_hummer_input_init:
_sampler_4bit_hummer_input_init:
_sampler_2bit_oem_input_init:
_sampler_4bit_oem_input_init:
_sampler_2bit_pet1_input_init:
_sampler_4bit_pet1_input_init:
_sampler_2bit_pet2_input_init:
_sampler_4bit_pet2_input_init:
_sampler_2bit_hit1_input_init:
_sampler_4bit_hit1_input_init:
_sampler_2bit_hit2_input_init:
_sampler_4bit_hit2_input_init:
_sampler_2bit_kingsoft2_input_init:
_sampler_4bit_kingsoft2_input_init:
_sampler_2bit_starbyte1_input_init:
_sampler_4bit_starbyte1_input_init:
        ldx     #$00
        stx     $dd03
        rts

_sampler_2bit_cga1_input_init:
_sampler_4bit_cga1_input_init:
        ldx     #$80
        stx     $dd03
storex_dd01:
        stx     $dd01
        rts

_sampler_2bit_cga2_input_init:
_sampler_4bit_cga2_input_init:
        ldx     #$80
        stx     $dd03
        ldx     #$00
        jmp     storex_dd01

_sampler_2bit_starbyte2_input:
        lda     $dd00
        and     #$04
        asl
        asl
        asl
        asl
        sta     tmp1
        lda     $dd01
        and     #$20
        asl
        asl
        ora     tmp1
        rts

_sampler_4bit_starbyte2_input:
        lda     $dd00
        and     #$04
        asl
        asl
        sta     tmp1
        lda     $dd01
        sta     tmp2
        and     #$20
        ora     tmp1
        sta     tmp1
        lda     tmp2
        and     #$40
        asl
        ora     tmp1
        sta     tmp1
        lda     tmp2
        and     #$80
        lsr
        ora     tmp1
        rts

_sampler_2bit_starbyte1_input:
        lda     $dd01
        sta     tmp2
        and     #$01
        clc
        ror
        ror
        sta     tmp1
        lda     tmp2
        and     #$08
        asl
        asl
        asl
        ora     tmp1
        rts

_sampler_4bit_starbyte1_input:
        lda     $dd01
        sta     tmp2
        and     #$01
        asl
        asl
        asl
        asl
        asl
        sta     tmp1
        lda     tmp2
        and     #$02
        clc
        ror
        ror
        ror
        ora     tmp1
        sta     tmp1
        lda     tmp2
        and     #$04
        asl
        asl
        asl
        asl
        ora     tmp1
        sta     tmp1
        lda     tmp2
        and     #$08
        asl
        ora     tmp1
        rts

_sampler_2bit_kingsoft2_input:
        lda     $dd01
        sta     tmp2
        and     #$04
        asl
        asl
        asl
        asl
        asl
        sta     tmp1
        lda     tmp2
        and     #$08
        asl
        asl
        asl
        ora     tmp1
        rts

_sampler_4bit_kingsoft2_input:
        lda     $dd01
        sta     tmp2
        and     #$01
        clc
        ror
        ror
        sta     tmp1
        lda     tmp2
        and     #$02
        asl
        asl
        asl
        asl
        asl
        ora    tmp1
        sta    tmp1
        lda    tmp2
        and    #$04
        asl
        asl
        asl
        ora    tmp1
        sta    tmp1
        lda    tmp2
        and    #$08
        asl
        ora    tmp1
        rts

_sampler_2bit_kingsoft1_input:
        lda     $dd00
        and     #$04
        asl
        asl
        asl
        asl
        sta     tmp1
        lda     $dd01
        and     #$80
        ora     tmp1
        rts

_sampler_4bit_kingsoft1_input:
        lda     $dd00
        and     #$04
        asl
        asl
        sta     tmp1
        lda     $dd01
        sta     tmp2
        and     #$20
        asl
        asl
        ora     tmp1
        sta     tmp1
        lda     tmp2
        and     #$40
        ora     tmp1
        sta     tmp1
        lda     tmp2
        and     #$80
        lsr
        lsr
        ora     tmp1
        rts

_sampler_2bit_pet2_input:
_sampler_2bit_hit2_input:
        lda     $dd01
        and     #$30
        asl
        asl
        rts

_sampler_4bit_pet2_input:
_sampler_4bit_hit2_input:
_sampler_4bit_userport_input:
        lda     $dd01
        and     #$f0
        rts

_sampler_2bit_oem_input:
        lda     $dd01
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
        lda     $dd01
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
_sampler_2bit_hit1_input:
        lda     $dd01
        asl
        asl
        jmp     do_asl4

_sampler_4bit_hummer_input:
_sampler_4bit_pet1_input:
_sampler_4bit_cga1_input:
_sampler_4bit_cga2_input:
_sampler_4bit_hit1_input:
        lda     $dd01
        jmp     do_asl4

_sfx_input:
        lda     $df00
        sta     $de00
        rts

_sampler_2bit_joy1_input:
        lda     $dc01
        asl
        asl
        jmp     do_asl4

_sampler_4bit_joy1_input:
        lda     $dc01
do_asl4:
        asl
        asl
        asl
        asl
        rts

_sampler_2bit_joy2_input:
        lda     $dc00
        asl
        asl
        jmp     do_asl4

_sampler_4bit_joy2_input:
        lda     $dc00
        jmp     do_asl4

_digimax_cart_output:
        sta     $de00
        sta     $de01
        sta     $de02
        sta     $de03
        rts

_sfx_output:
        sta     $df00
        rts

_siddtv_output_init:
        jsr     setup_sid
        lda     #$00
        sta     $d41f
        sta     $d407           ; V2 FreqL = 0
        sta     $d408           ; V2 FreqH = 0
        sta     $d40c           ; V2 A=0, D=0
        sta     $d40d           ; V2 S=0, R=0
        sta     $d409           ; V2 PwL = 0
        sta     $d40a           ; V2 PwH = 0
        lda     #$41
        sta     $d40b           ; V2 Wave = Pulse + gate
        lda     #$0f
        sta     $d418
        rts

_siddtv_output:
        sta     $d41f
        rts

setup_sid:
        lda     #$00
        ldx     #$00
@l:
        sta     $d400,x
        inx
        cpx     #$20
        bne     @l
        rts

_sid_output_init:
        jsr     setup_sid
        lda     #$ff
        sta     $d406
        sta     $d40d
        sta     $d414
        lda     #$49
        sta     $d404
        sta     $d40b
        sta     $d412
        rts

_sid_output:
        lsr
        lsr
        lsr
        lsr
        sta     $d418
        rts

_userport_digimax_output_init:
_userport_dac_output_init:
        ldx     #$ff
        stx     $dd03
        rts

_userport_digimax_output:
_userport_dac_output:
        sta     $dd01
        rts

sfx_se_write:
        stx     $df40               ; select ym3526 register
        nop
        nop
        nop
        nop                         ; wait 12 cycles for register select
        sta     $df50               ; write to it
        ldx     #$04
lup:
        dex
        nop
        bne lup                     ; wait 36 cycles to do the next write
        rts

_sfx_sound_expander_output_init:
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

wait1:
        cmp     $d012
        beq     wait1
wait2:
        cmp     $d012
        bne     wait2
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
