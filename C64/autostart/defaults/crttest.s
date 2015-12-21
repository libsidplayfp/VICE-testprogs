USEULTIMAX = 1
ROMSTART = $e000

    !to "test.crt",plain

MEMBUFFER = $0800
REGBUFFER = $0800 + $0400

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

!byte 0,0,0,0,0,0

!text "EasyFlash"

!byte 0

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
!byte $00, $02
;         000A-000B - Bank number ($0000 - normal cartridge)
!byte $00, $00
;         000C-000D - Starting load address (high/low format)
!byte $e0, $00
;         000E-000F - ROM image size in bytes  (high/low  format,  typically
;                     $2000 or $4000)
!byte $20, $00

;-------------------------------------------------------------------------------
; now comes the ROM data
    * = ROMSTART
CODESTART = ROMSTART
    !src "test.s"

    !src "refioreset.s"
    !src "refmemreset.s"

testname:
          ;1234567890123456
    !text "CRT DEFAULTS    "
    
; when using ultimax mode, add character set in the ROM
!if (USEULTIMAX = 1) {
    * = ROMSTART + $1000
    !bin "charset.bin"
}
; if ROM starts at $e000, add proper hardware vectors
!if (ROMSTART = $e000) {
    * = ROMSTART + $1ffa
    !word start
    !word start
    !word start
} 
