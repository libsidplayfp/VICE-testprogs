; --- Code

*=$0801
basic:
; BASIC stub: "1 SYS 2061"
!by $0b,$08,$01,$00,$9e,$32,$30,$36,$31,$00,$00,$00

start:
    jmp entrypoint

* = $0900
entrypoint:
    sei
    lda #$7f
    sta $dc0d
    sta $dd0d
    lda #$00
    sta $dc0e
    sta $dc0f
    lda $dc0d
    lda $dd0d
    lda #$35
    sta $01
    lda #<irq_handler_1
    sta $fffe
    lda #>irq_handler_1
    sta $ffff
    lda #$1b
    sta $d011
    lda #$46
    sta $d012
    lda #$01
    sta $d01a
    sta $d019
    lda #$64
    sta $d000
    sta $d002
    sta $d004
    sta $d006
    sta $d008
    sta $d00a
    sta $d00c
    sta $d00e
    lda #$4a
    sta $d001
    sta $d003
    sta $d005
    sta $d007
    sta $d009
    sta $d00b
    sta $d00d
    sta $d00f
    lda #$00
    sta $d010
    lda #$40
    sta $f7
    lda #$04
    sta $f8
    lda #$30
    sta $f9
    lda #<reference_data
    sta $fa
    lda #>reference_data
    sta $fb
    cli
-   jmp -

irq_handler_1:
    lda #<irq_handler_2
    sta $fffe
    lda #>irq_handler_2
    sta $ffff
    lda #$01
    sta $d019
    ldx $d012
    inx
    stx $d012
    cli
    ror $02
    ror $02
    ror $02
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    rti

irq_handler_2:
    lda #$01
    sta $d019
    ldx #$07
-   dex
    bne -
    nop
    nop
    lda $d012
    cmp $d012
    beq +
+   ldx #$06
-   dex
    bne -
    inc $d021
    dec $d021
    lda #<irq_handler_3
    sta $fffe
    lda #>irq_handler_3
    sta $ffff
    lda #$46
    sta $d012
    cli
    lda $f8
    sta $d015
    lda #$ff
    sta $dd04
    lda #$00
    sta $dd05
    lda #$ff
    sta $dd06
    lda #$00
    sta $dd07
    lda $f9
    sta $dc04
    lda #$00
    sta $dc05
    lda #$81
    sta $dc0d
    lda #$19
    sta $dd0e
    sta $dd0f
    sta $dc0e
    lda $f7
    jsr delay
    ldx #$00
    jsr lc1aa
    jsr lc1aa
    jsr lc1aa
    jsr lc1aa
    jsr lc1aa
    jsr lc1aa
    jsr lc1aa
    jsr lc1aa
    jsr lc1aa
    jsr lc1aa
    jsr lc1aa
    lda $dd06
    pha
    tya
    pha
    ldy #$00
    lda #$01
    cmp #$01
    beq lc14a
lc140:
    pla
    sta ($fa),y
    iny
    pla
    sta ($fa),y
    jmp lc15f
lc14a:
    pla
    cmp ($fa),y
    bne lc158
lc14f:
    iny
    pla
    cmp ($fa),y
    bne lc158
lc155:
    jmp lc15f
lc158:
    sei
    inc $d020
    jmp lc158
lc15f:
    lda $fa
    clc
    adc #$02
    sta $fa
    lda $fb
    adc #$00
    sta $fb
    dec $f7
    lda $f7
    cmp #$38
    bne lc186
lcf7:
    lda #$40
    sta $f7
    inc $f9
    lda $f9
    cmp #$b0
    bne lc186
lc174:
    lda #$30
    sta $f9
    inc $f8
    lda $f8
    cmp #$14
    bne lc186

    inc $d020
-   jmp -

lc186:
    lda #$00
    sta $dc0e
    lda #$7f
    sta $dc0d
    lda $dc0d
    lda #<irq_handler_1
    sta $fffe
    lda #>irq_handler_1
    sta $ffff
    rti

irq_handler_3:
    bit $dc0d
    ldy $dd04
    lda #$19
    sta $dd0f
    rti

lc1aa:
    rts

delay:            ;delay 80-accu cycles, 0<=accu<=64
  lsr             ;2 cycles akku=akku/2 carry=1 if accu was odd, 0 otherwise
  bcc waste1cycle ;2/3 cycles, depending on lowest bit, same operation for both
waste1cycle:
  sta smod+1      ;4 cycles selfmodifies the argument of branch
  clc             ;2 cycles 
;now we have burned 10/11 cycles.. and jumping into a nopfield 
smod:
  bcc *+10
!by $EA,$EA,$EA,$EA,$EA,$EA,$EA,$EA
!by $EA,$EA,$EA,$EA,$EA,$EA,$EA,$EA
!by $EA,$EA,$EA,$EA,$EA,$EA,$EA,$EA
!by $EA,$EA,$EA,$EA,$EA,$EA,$EA,$EA
  rts             ;6 cycles
; --- Data

* = $2000
reference_data:

!bin "irq4b.dump",,2
