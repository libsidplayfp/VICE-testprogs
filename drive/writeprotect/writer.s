; write to disk without using ROM routines, original code supplied by fungus
;
; this program will destroy track 18 - run it on a write protected disk/image
; to verify that write protection actually works

        !convtab pet
        !cpu 6510

;-------------------------------------------------------------------------------

drivecode_start = $0300
drivecode_exec = drvstart

        !src "../framework.asm"

;-------------------------------------------------------------------------------
start:
        jsr clrscr

        lda #<drivecode
        ldy #>drivecode
        ldx #((drivecode_end - drivecode) + $1f) / $20 ; upload x * $20 bytes to 1541
        jsr upload_code

        lda #<drivecode_exec
        ldy #>drivecode_exec
        jsr start_code

        inc $d020
        jmp *-3

;-------------------------------------------------------------------------------

drivecode:
!pseudopc drivecode_start {


drvstart
         sei
         jsr ledmotor  ;led+motor on

         lda #$12      ;init to track
         sta $06       ;18,00
         lda #$00
         sta $07
         jsr stephead

         lda #$12      ;track to write
         sta track+1   ;key !!!!

         jsr writekey  ;key checker
         jsr motorled  ;led+motor off
         cli
         lda #$00
         jmp $c194     ;exit

ledmotor lda $1c00     ;motor on
         ora #$0c      ;led on
         sta $1c00
         lda #$ee      ;read mode
         sta $1c0c
         rts

motorled lda $1c00     ;motor off
         and #$f3      ;led off
         sta $1c00
         rts

stephead lda $06       ;step head
         cmp $22       ;track
         beq zonefind

         ldx #$00
         lda #$ff
         bcc stepout
         inx
         lda #$01
stepout  stx $c3       ;direction id
         sta $c0       ;direction
gettrack ldy #$03
         ldx $c3
         lda $22
         dey
         clc
         adc $c0
         pha
moveloop jsr movehead
         dey
         bne moveloop
         pla
         sta $22       ;track
         cmp $06       ;track
         bne gettrack
zonefind jsr findzone

         lda $1c00     ;set read
         and #$9f      ;density
         ora density,x
         sta $1c00
         rts

movehead clc
         lda $1c00
         adc $c0       ;direction
         and #$03
         sta $c1       ;save bits
         lda $1c00
         and #$fc
         ora $c1       ;set bits
         sta $1c00
         lda #$04
         sta $c1       ;timer hi
         ldx #$00
wait1    dex
         bne wait1
         dec $c1       ;timer hi
         bne wait1
         rts

findzone ldx #$03      ;find zone
getzone  cmp zone,x    ;density
         bcc gotzone
         dex
         bpl getzone
gotzone  rts

zone     !byte $24,$21,$1d,$12 ;track
density  !byte $00,$20,$40,$60

;---------------------------------------

writekey
track    lda #$02      ;track to write!!
         sta $06
         lda #$00
         sta $07       ;sector

         jsr stephead  ;seek it

continue lda $1c00
         and #$9f      ;set density
         ora #$20      ;zone 2
         sta $1c00     ;(non standard)

         lda $1c0c     ;turn on write
         and #$1f      ;mode
         ora #$c0
         sta $1c0c

         lda #$ff      ;ddr port a
         sta $1c03     ;to output

         lda #$d7
         sta $1c01
         ldx #$00
         ldy #$30
format   bvc *         ;write $3000
         clv           ;55's to track
         dex
         bne format    ;error 21 create
         dey
         bne format

         lda #$eb
         sta $1c01

         ldx #$00      ;512 $de,$ad
         ldy #$02
wait4    lda #$de
wait5    bvc wait5
         clv
         sta $1c01
         lda #$ad
wait6    bvc wait6
         clv
         sta $1c01
         dex
         bne wait4
         dey
         bne wait4

         ldx #$00
wait7    lda #$55      ;some $55
wait8    bvc wait8
         clv
         sta $1c01
         inx
         cpx #$0d
         bne wait7
wait9    bvc wait9     ;wait till done
         clv

         lda $1c0c     ;back to read
         and #$1f      ;mode
         ora #$e0
         sta $1c0c
         lda #$00
         sta $1c03

         rts           ;exit
} 
drivecode_end:
