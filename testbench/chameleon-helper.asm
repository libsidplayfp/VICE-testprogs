; $0400 if != $20 then configure a cartridge
; $0401 CRT ID
; $0402 if = 0 no ram expansion, = 1 REU (512k), = 2 GEORAM (256k)
; $0403 0=6581 1=8580 SID
; $0404 0=6526 2=8521 CIA

        *=$0801

        !word link
        !word 42        ; 42
        !byte $9e       ; SYS
        !text "2061"    ; 2061
        !byte 0
link:   !word 0

        sei
        inc $d020
        lda #42
        sta $d0fe       ; enable config mode
        lda #$22        ; MMU and I/O RAM
        sta $d0fa       ; enable config registers

        lda #$00
        sta $d0f6       ; clear "image modified" bits
        sta $d0f7       ; select 1 disk per drive, select image slot 1
        lda #$40
        sta $d0f8       ; enable disk drive 1 at id 8

        lda #0
        ldx $0400
        cpx #$20
        beq nocart
        lda $0401
nocart:
        sta $d0f0       ; dis/enable cartridge

        cmp #$20        ; easyflash
        bne noef
        ldx #0
        stx $de00       ; ef bank 0
        ldx #$04
        stx $de02       ; ef off
;        ldx #$1f
;        stx $dc0d
;        stx $dd0d
;        inc $0428
;        dec $d020
;        jmp *-3
noef:

        lda #$13        ; MMU Slot for Cartridge ROM
        sta $d0af
        lda #0
        ldx #$b0
        ; there is free memory at 0x00b00000
        sta $d0a0
        sta $d0a1
        stx $d0a2
        sta $d0a3

        lda #$12        ; MMU Slot for Cartridge RAM
        sta $d0af
        lda #0
        ldx #$27
        ; there is free memory at 0x00270000
        sta $d0a0
        sta $d0a1
        stx $d0a2
        sta $d0a3

        ldx #0
        lda $0402
        beq noramexp
        ldx #$82        ; reu on, 512k
        lda $0402
        cmp #$01
        beq isreu
        ldx #$50        ; georam on, 512k
isreu:
noramexp:
        stx $d0f5       ; dis/enable REU

        lda #$00
        ldx $0403
        cpx #$00
        beq oldsid
        lda #$c0 
oldsid:
        sta $d0f4       ; set SID type

        lda #%00101000 ; old cia, disable IR, disable ps2 mouse
        ldx $0404       ; set CIA type
        beq oldcia
        lda #%00101010 ; new cia, disable IR, disable ps2 mouse
oldcia:
        sta $d0fc
        
        lda #$27        ; MMU Slot for I/O RAM
        sta $d0af
        lda #0
        ldx #1
        ; there is free memory at 0x00010000
        sta $d0a0
        sta $d0a1
        stx $d0a2
        sta $d0a3

        ; try to somewhat reset the TOD
        ldx #0
        ; cia 1 tod
        stx $dc08 ; 0 starts TOD clock
        stx $dc09 ; 0
        stx $dc0a ; 0

        ; cia 2 tod
        stx $dd08 ; 0 starts TOD clock
        stx $dd09 ; 0
        stx $dd0a ; 0
        inx
        stx $dc0b ; 1 (hour) stops TOD clock
        stx $dd0b ; 1 (hour) stops TOD clock

        lda $dc08 ; un-latch
        lda $dd08 ; un-latch

        ; clear pending flags
        lda $d01e ; Sprite to Sprite Collision Detect
        lda $d01f ; Sprite to Background Collision Detect

        ; clear pending irqs
        lda $d019
        sta $d019
        lda $dc0d
        lda $dd0d
        lda $df00 ; REU

        lda #0      ; return code = 0
        sta $d7ff
        
        dec $d020
        cli
        rts
