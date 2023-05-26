;
; Marco van den Heuvel, 28.01.2016
;
; void __fastcall__ set_sid_addr(unsigned addr);
;
; void __fastcall__ sid_output_init(void);
; void __fastcall__ sid_output(unsigned char sample);
; void __fastcall__ userport_dac_output_init(void);
; void __fastcall__ userport_dac_output(unsigned char sample);
;
; void __fastcall__ show_sample(unsigned char sample);
;

        .export  _sid_output_init, _sid_output
        .export  _userport_dac_output_init, _userport_dac_output

        .export  _set_sid_addr

        .export  _show_sample

        .importzp   tmp1, tmp2

_set_sid_addr:
        sta     store_sid+1
        stx     store_sid+2
        rts

store_sid:
        sta     $e900,x
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
        stx     $e843
        rts

_userport_dac_output:
        sta     $e841
        rts

_show_sample:
        sta     $8020
        rts
