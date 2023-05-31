; noise reset routine

; uses test bit, works only on a warmed up chip

; set testbit to reset noise
    lda #$08
    sta $d412

; noise reg need some time to reset
!if NEWSID = 0 {
    ldy #1    ; wait ~1 sec for 6581
} else {
    ldy #10   ; wait ~10 sec for 8580
}
---
    ldx #60   ; sixty frames = 1 sec for NTSC, 1.2 sec for PAL
--
w1: bit $d011
    bpl w1
w2: bit $d011
    bmi w2
    dex
    bne --
    dey
    bne ---
