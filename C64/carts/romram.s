ROMSTART = $8000

    !to "romram.crt",plain

;-------------------------------------------------------------------------------
; CRT header ($40 bytes)

    * = ROMSTART - ($10 + $40)

!byte $43, $36, $34, $20, $43, $41, $52, $54, $52, $49, $44, $47, $45, $20, $20, $20
!byte $00, $00, $00, $40 
!byte $01, $00 

;         0016-0017 - Cartridge hardware type ($0000, high/low)
!byte $00, 32 ; easyflash
;              0018 - Cartridge port EXROM line status
;              0019 - Cartridge port GAME line status
;                      0 - inactive
;                      1 - active
!byte $01, $00 ; ultimax

;-------------------------------------------------------------------------------
; CHIP header ($10 bytes)

    * = ROMSTART - ($10)

!byte $43, $48, $49, $50
;         0004-0007 - Total packet length ($00002010,  ROM  image  size  and
;                     header combined) (high/low format)
!byte $00, $00, $20, $10
;         0008-0009 - Chip type
;                      0 - ROM
;                      1 - RAM, no ROM data
;                      2 - Flash ROM
!byte $00, $00
;         000A-000B - Bank number ($0000 - normal cartridge)
!byte $00, $00
;         000C-000D - Starting load address (high/low format)
!byte $80, $00
;         000E-000F - ROM image size in bytes  (high/low  format,  typically
;                     $2000 or $4000)
!byte $20, $00

;-------------------------------------------------------------------------------
; now comes the ROM data
    * = ROMSTART
start:
    sei
    lda #$07    ; 16k game mode
    sta $de02
    ; copy ROM to RAM
    ldx #0
lp2:
    lda $8000,x
    sta $8000,x
    lda $8100,x
    sta $8100,x
    inx
    bne lp2
    
    lda #$4c    ; JMP
    sta opc

    lda #$04    ; rom off
    sta $de02

    ; executes in RAM. opc is JMP in RAM
opc: lda contok

    ; if opc was not fetched from RAM, then
    ; banking is broken
notok:
    lda #2
    sta $d020
    jmp *

contok:
    lda #5
    sta $d020
    jmp *
    
;-------------------------------------------------------------------------------
; CHIP header ($10 bytes)

    * = ROMSTART + $2000

!byte $43, $48, $49, $50
;         0004-0007 - Total packet length ($00002010,  ROM  image  size  and
;                     header combined) (high/low format)
!byte $00, $00, $20, $10
;         0008-0009 - Chip type
;                      0 - ROM
;                      1 - RAM, no ROM data
;                      2 - Flash ROM
!byte $00, $00
;         000A-000B - Bank number ($0000 - normal cartridge)
!byte $00, $00
;         000C-000D - Starting load address (high/low format)
!byte $e0, $00
;         000E-000F - ROM image size in bytes  (high/low  format,  typically
;                     $2000 or $4000)
!byte $20, $00

;-------------------------------------------------------------------------------

    * = ROMSTART + $2010

; add proper hardware vectors
    * = ROMSTART + $2010 + $1ffa
    !word start
    !word start
    !word start

