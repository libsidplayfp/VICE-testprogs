
ramtarget = $900

!if MAKECRT = 1 {    

CHKOFF=($8000-ramtarget)

    * = $8000

    !word start
    !word start

    !byte $c3,$c2,$cd,$38,$30
    
    !scr " ROML 8000 "

} else {

CHKOFF=0

    * = $0801

    !word +
    !word 2020
    !byte $9e
    !byte $32, $30, $36, $31
+
    !byte 0,0,0

    * = $080d
}

start:
    sei
    ; we must set data first, then update DDR
    lda #$37
    sta $01
    lda #$2f
    sta $00

    lda #$1b
    sta $d011
    
    lda #$c8
    sta $d016

    lda #$03
    sta $dd00
    
    lda #$17
    sta $d018
    
    lda #$ff
    sta $dc02
    lda #$00
    sta $dc03
    
    ldx #0
-
    lda #1
    sta $d800,x
    sta $d900,x
    sta $da00,x
    sta $db00,x
    lda #$20
    sta $0400,x
    sta $0500,x
    sta $0600,x
    sta $0700,x
!if MAKECRT = 1 {    
    lda $8000,x
    sta ramtarget,x
    lda $8100,x
    sta ramtarget+$0100,x
    lda $8200,x
    sta ramtarget+$0200,x
    lda $8300,x
    sta ramtarget+$0300,x
    lda $8400,x
    sta ramtarget+$0400,x
    lda $8500,x
    sta ramtarget+$0500,x
}
    inx
    bne -

    lda #15
    ldx #(3*40)-1
-
    sta $d800+(3*40),x
    sta $d800+(9*40),x
    sta $d800+(16*40),x
    sta $d800+(22*40),x
    dex
    bpl -
    
    lda #0
    sta $d020
    sta $d021
    
!if MAKECRT = 1 {    
    jmp go - ($8000-ramtarget)
}    
go:

!if RRMODE = 1 {
    ; non REU mapping
    lda #0
    sta $de01
}
!if RRMODE = 2 {
    ; REU mapping
    lda #$40
    sta $de01
}

    ; Cart RAM at 8000 (ultimax!)
    ldx #$23
    stx $de00

    ; we init the Cart ram with a certain pattern
    ; writes also go to C64 RAM
    ldx #0
-
    lda #$43        ; 'C'
    sta $8000,x
    lda #$49        ; 'I'
    sta $9e00,x
    lda #$4a        ; 'J'
    sta $9f00,x
    inx
    bne -

    ; disable the cartridge
    ldx #$02
    stx $de00
    
    lda #$33
    sta $01

    ; we init the C64 ram with a certain pattern
    ldx #0
-
    lda #$08        ; 'h'
    sta $8000,x
    lda #$0a        ; 'j'
    sta $a000,x
    lda #$de
    sta $de00,x
    lda #$df
    sta $df00,x
    inx
    bne -
    
    lda #$37
    sta $01

    ; "nordic power" mode, RAM at A000
    ldx #$22
    stx $de00
 
    ldx #0
-
; on real AR we need to avoid the dummy accesses (reads)
!if ARSAFE=0 {
    lda #$c8        ; 'H' inverse        
    sta $8000+20,x
}
    lda #$ca        ; 'J' inverse
    sta $a000+60,x
; on real AR and NP the register is mirrored all over io1
!if IO1READ=1 {
    lda #$cb        ; 'K' inverse
    sta $de00+100,x
}
    lda #$c9        ; 'I' inverse
    sta $df00+100,x
    inx
    cpx #20
    bne -

    ; unroll the writes to $8000 to avoid dummy accesses
!if ARSAFE=1 {
    !for i,0,19 {
    lda #$c8        ; 'H' inverse        
    sta $8000+20+i
    }
}

loop:    
    ; copy to screen (NP mode)

    lda #$37
    sta $01

    ; "nordic power" mode, RAM at A000
    ldx #$22
    stx $de00
    
    ldx #(3*40)-1
-
!if ARSAFE=0 {
    lda $8000,x
    sta $0400+(0*40),x
}
    lda $a000,x
    sta $0400+(3*40),x
!if IO1READ=1 {
    lda $de00,x
    sta $0400+(6*40),x
}
    lda $df00,x
    sta $0400+(9*40),x
    dex
    bpl -

    
    ; on actual AR5 we dont want to read from 8000 when "Nordic Power"
    ; mode is enabled
!if ARSAFE=1 {
    ldx #$20
    stx $de00
    
    ldx #(3*40)-1
-
    lda $8000,x
    sta $0400+(0*40),x
    dex
    bpl -
}    
    
    ; disable the cartridge
    ldx #$02
    stx $de00

    lda #$34
    sta $01
    
    ldx #(3*40)-1
-
    lda $8000,x
    sta $0400+(13*40),x
    lda $a000,x
    sta $0400+(16*40),x
;!if IO1READ=1 {
    lda $de00,x
    sta $0400+(19*40),x
;}
    lda $df00,x
    sta $0400+(22*40),x
    dex
    bpl -

    lda #$35
    sta $01
    
    ; check results
    ldy #13 ; green
    sty $02

    ; this is cart ROM on nordic power, so we cant check it in the prg
!if ARMODE = 0 {    
!if MAKECRT = 1 {    
    ldx #$0a
-
    ldy #13 ; green
    lda $0400 + (0*40) + 9,x
    cmp check_block00 - CHKOFF,x
    beq +
    ldy #10 ; red
    sty $02
+
    tya
    sta $d800 + (0*40) + 9,x

    dex
    bpl -
}
}
    ; on real AR/RR we read RAM here
!if (ARMODE = 1) | (ARMODE = 2) {    
    ldx #(3*40)-1
-
    ldy #13 ; green
    lda $0400 + (0*40),x
    cmp check_block00 - CHKOFF,x
    beq +
    ldy #10 ; red
    sty $02
+
    tya
    sta $d800 + (0*40),x

    dex
    bpl -
}

!if ARMODE = 0 {    
    ldx #(3*40)-1
-
    ldy #13 ; green
    lda $0400 + (3*40),x
    cmp check_block01 - CHKOFF,x
    beq +
    ldy #10 ; red
    sty $02
+
    tya
    sta $d800 + (3*40),x

    dex
    bpl -
}

    ; on real AR/RR we see the basic ROM
!if (ARMODE = 1) | (ARMODE = 2) {    
    ldx #7
-
    ldy #13 ; green
    lda $0400 + (3*40)+4,x
    cmp check_block01 - CHKOFF,x
    beq +
    ldy #10 ; red
    sty $02
+
    tya
    sta $d800 + (3*40)+4,x

    dex
    bpl -
}

    ; on RR (REU mapping) we see cartridge RAM in IO1
!if (RRMODE == 2) {
    ldx #(3*40)-1
-
    ldy #13 ; green
    lda $0400 + (6*40) + 0,x
    cmp check_block02 - CHKOFF,x
    beq +
    ldy #10 ; red
    sty $02
+
    tya
    sta $d800 + (6*40) + 0,x

    dex
    bpl -
}

    ; on RR (REU mapping) we see open I/O in IO2
!if (RRMODE != 2) {
    ldx #(3*40)-1
-
    ldy #13 ; green
    lda $0400 + (9*40) + 0,x
    cmp check_block03 - CHKOFF,x
    beq +
    ldy #10 ; red
    sty $02
+
    tya
    sta $d800 + (9*40) + 0,x

    dex
    bpl -
}
    
    ; NP mode

    ldx #(3*40)-1
-
    ldy #13 ; green
    lda $0400 + (13*40) + 0,x
    cmp check_block10 - CHKOFF,x
    beq +
    ldy #10 ; red
    sty $02
+
    tya
    sta $d800 + (13*40) + 0,x

    dex
    bpl -

    ldx #(3*40)-1
-
    ldy #13 ; green
    lda $0400 + (16*40) + 0,x
    cmp check_block11 - CHKOFF,x
    beq +
    ldy #10 ; red
    sty $02
+
    tya
    sta $d800 + (16*40) + 0,x

    dex
    bpl -

    ldx #(3*40)-1
-
    ldy #13 ; green
    lda $0400 + (19*40) + 0,x
    cmp check_block12 - CHKOFF,x
    beq +
    ldy #10 ; red
    sty $02
+
    tya
    sta $d800 + (19*40) + 0,x

    dex
    bpl -
 
    
    ldx #(3*40)-1
-
    ldy #13 ; green
    lda $0400 + (22*40) + 0,x
    cmp check_block13 - CHKOFF,x
    beq +
    ldy #10 ; red
    sty $02
+
    tya
    sta $d800 + (22*40) + 0,x

    dex
    bpl -
 
    ldx #0 ; pass
    lda $02
    sta $d020
    cmp #13 ; green
    beq +
    ldx #$ff ; fail
+
    stx $d7ff

    ; wait for space, on space reset
    lda #$0
    sta $dc00
    lda $dc01
    cmp #$ff
    beq +
    
    lda #$37
    sta $01
    jmp $fce2
    
+    
    
!if MAKECRT = 1 {    
    jmp loop - $7000
} else {
    jmp loop
}

;------------------------------ 8000 (cartridge)
check_block00:
!if ARMODE=0 {
    !scr " ROML 8000 "
}
!if ARMODE=1 {
!if ARSAFE=0 {
    ; unsafe read ORs the C64 ram with Cartridge RAM
    !scr "KKKKKKKKKKKKKKKKKKKK" ; $08 or $43 -> $4b
    !byte $c8,$c8,$c8,$c8,$c8,$c8,$c8,$c8,$c8,$c8,$c8,$c8,$c8,$c8,$c8,$c8,$c8,$c8,$c8,$c8
    !scr "KKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKK"
    !scr "KKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKK"
}
!if ARSAFE=1 {
    !scr "CCCCCCCCCCCCCCCCCCCC"
    !byte $c8,$c8,$c8,$c8,$c8,$c8,$c8,$c8,$c8,$c8,$c8,$c8,$c8,$c8,$c8,$c8,$c8,$c8,$c8,$c8
    !scr "CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC"
    !scr "CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC"
}
}
!if ARMODE=2 {
    !scr "hhhhhhhhhhhhhhhhhhhh"
    !byte $c8,$c8,$c8,$c8,$c8,$c8,$c8,$c8,$c8,$c8,$c8,$c8,$c8,$c8,$c8,$c8,$c8,$c8,$c8,$c8
    !scr "hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh"
    !scr "hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh"
}
check_block01:
!if ARMODE=0 {
    !scr "CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC"
    !scr "CCCCCCCCCCCCCCCCCCCC"
    !byte $ca,$ca,$ca,$ca,$ca,$ca,$ca,$ca,$ca,$ca,$ca,$ca,$ca,$ca,$ca,$ca,$ca,$ca,$ca,$ca
    !scr "CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC"
}
!if ARMODE=1 {
    !scr "CBMBASIC"
}
!if ARMODE=2 {
    !scr "CBMBASIC"
}
check_block02:
    !byte $40,$40
    !scr "IIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIII"
    !scr "IIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIII"
    !scr "IIIIIIIIIIIIIIIIIIII"
    !byte $cb,$cb,$cb,$cb,$cb,$cb,$cb,$cb,$cb,$cb,$cb,$cb,$cb,$cb,$cb,$cb,$cb,$cb,$cb,$cb

check_block03:
         ;1234567890123456789012345678901234567890
    !scr "JJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJ"
    !scr "JJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJ"
    !scr "JJJJJJJJJJJJJJJJJJJJ"
    !byte $c9,$c9,$c9,$c9,$c9,$c9,$c9,$c9,$c9,$c9,$c9,$c9,$c9,$c9,$c9,$c9,$c9,$c9,$c9,$c9

;------------------------------ 8000 (C64 RAM)
check_block10:
    !scr "hhhhhhhhhhhhhhhhhhhh"
    !byte $c8,$c8,$c8,$c8,$c8,$c8,$c8,$c8,$c8,$c8,$c8,$c8,$c8,$c8,$c8,$c8,$c8,$c8,$c8,$c8
    !scr "hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh"
    !scr "hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh"
check_block11:
!if ARMODE=0 {
    !scr "jjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjj"
    !scr "jjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjj"
    !scr "jjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjj"
}
!if ARMODE=1 {
    !scr "jjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjj"
    !scr "jjjjjjjjjjjjjjjjjjjj"
    !byte $ca,$ca,$ca,$ca,$ca,$ca,$ca,$ca,$ca,$ca,$ca,$ca,$ca,$ca,$ca,$ca,$ca,$ca,$ca,$ca
    !scr "jjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjj"
}
!if ARMODE=2 {
    !scr "jjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjj"
    !scr "jjjjjjjjjjjjjjjjjjjj"
    !byte $ca,$ca,$ca,$ca,$ca,$ca,$ca,$ca,$ca,$ca,$ca,$ca,$ca,$ca,$ca,$ca,$ca,$ca,$ca,$ca
    !scr "jjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjj"
}
check_block12:
    !byte $de,$de,$de,$de,$de,$de,$de,$de,$de,$de,$de,$de,$de,$de,$de,$de,$de,$de,$de,$de
    !byte $de,$de,$de,$de,$de,$de,$de,$de,$de,$de,$de,$de,$de,$de,$de,$de,$de,$de,$de,$de
    !byte $de,$de,$de,$de,$de,$de,$de,$de,$de,$de,$de,$de,$de,$de,$de,$de,$de,$de,$de,$de
    !byte $de,$de,$de,$de,$de,$de,$de,$de,$de,$de,$de,$de,$de,$de,$de,$de,$de,$de,$de,$de
    !byte $de,$de,$de,$de,$de,$de,$de,$de,$de,$de,$de,$de,$de,$de,$de,$de,$de,$de,$de,$de
    !byte $de,$de,$de,$de,$de,$de,$de,$de,$de,$de,$de,$de,$de,$de,$de,$de,$de,$de,$de,$de
check_block13:
    !byte $df,$df,$df,$df,$df,$df,$df,$df,$df,$df,$df,$df,$df,$df,$df,$df,$df,$df,$df,$df
    !byte $df,$df,$df,$df,$df,$df,$df,$df,$df,$df,$df,$df,$df,$df,$df,$df,$df,$df,$df,$df
    !byte $df,$df,$df,$df,$df,$df,$df,$df,$df,$df,$df,$df,$df,$df,$df,$df,$df,$df,$df,$df
    !byte $df,$df,$df,$df,$df,$df,$df,$df,$df,$df,$df,$df,$df,$df,$df,$df,$df,$df,$df,$df
    !byte $df,$df,$df,$df,$df,$df,$df,$df,$df,$df,$df,$df,$df,$df,$df,$df,$df,$df,$df,$df
    !byte $df,$df,$df,$df,$df,$df,$df,$df,$df,$df,$df,$df,$df,$df,$df,$df,$df,$df,$df,$df

!if MAKECRT = 1 {    
    
    !scr "ROML 8000"
    
    * = $9e00
    !scr "ROML 9e00"
    * = $9f00
    !scr "ROML 9f00"
    
    * = $a000
    !scr "ROML a000"
    * = $be00
    !scr "ROML be00"
    * = $bf00
    !scr "ROML bf00"
    
}
