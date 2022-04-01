
; NEOS mouse in port2

; pin  bit          out in
; 1    0     up         d0
; 2    1     down       d1
; 3    2     left       d2
; 4    3     right      d3
; 6    4     Fire   clk LMB
; 9          potx       RMB

; clk  d0-d3
; 0    mousex upper 4 bits
; 1    mousex lower 4 bits
; 0    mousey upper 4 bits
; 1    mousey lower 4 bits

mousex = $19
mousey = $1a
mousebtn = $1b

mousexold = $1c
mouseyold = $1d
mousebtnold = $1e

pointerx = $fe
pointery = $ff

lineptr = $fa

;-------------------------------------------------------------------------------
            *=$0801
            !word bend
            !word 10
            !byte $9e
            !text "2061", 0
bend:       !word 0
;-------------------------------------------------------------------------------

        ; clear screen
        ldx #0
-
        lda #$20
        sta $0400,x
        sta $0500,x
        sta $0600,x
        sta $0700,x
        lda #$01
        sta $d800,x
        sta $d900,x
        sta $da00,x
        sta $db00,x
        dex
        bne -

        ; setup sprite
        ldy     #$3F
-       lda     sprite,y
        sta     $0340,y
        dey
        bpl     -

        lda     #$0D
        sta     $07F8
        lda     #$01
        sta     $D015
        lda     #$07
        sta     $D027

        ; disable irq sources
        lda     #$7f
        sta     $dc0d
        lda     $dc0d

        sei
mainlp:
        lda     #$7F
        sta     $DC00

        ; wait frame
-       lda     $d011
        bmi -
-       lda     $d011
        bpl -

        inc     $0400+39    ; indicate we are running

        inc     $d020

        jsr     readmouse

!if TEST = 0 {
        ; if carry set then RMB pressed
        lda     #$07
        bcc     +
        lda     #$0A    ; not RMB
+       sta     $D027
}

!if TEST = 1 {
        ; if A = 1 then RMB is pressed
        ldy     #$07
        cmp     #$01
        bne     +
        ldy     #$0A    ; not RMB
+       sty     $D027

        stx     mousex

        lda     #3
        sta     $dd00
}

!if TEST = 2 {
        ; check RMB in POTX
        lda     $D419
        cmp     #$FF
        ; if carry set then RMB pressed
        lda     #$07
        bcc     +
        lda     #$0A    ; not RMB
+       sta     $D027
}

        jsr     LC190
        jsr     LC1D0

        inc $d020
        
!if TEST = 0 {
        lda $DC00
        sta mousebtn
}
!if TEST = 2 {
        lda $DC00
        sta mousebtn
}
        lda mousex
        cmp mousexold
        bne +
        lda mousey
        cmp mouseyold
        bne +
        lda mousebtn
        cmp mousebtnold
        bne +
        
        jmp noprint
+
        jsr scrollup
        lda #>($0400+24*40)
        sta lineptr+1
        lda #<($0400+24*40)
        sta lineptr
        
        lda mousebtn
        jsr printhex
        
        inc lineptr

        lda mousex
        jsr printhex
        
        inc lineptr

        lda mousey
        jsr printhex
noprint:
        lda mousex
        sta mousexold
        lda mousey
        sta mouseyold
        lda mousebtn
        sta mousebtnold
        
        lda #0
        sta $d020
        
        ; check fire, if LMB pressed
        ldy     #0
        lda     mousebtn
        and     #$10
        bne     +
        ldy     #11
+
        sty     $d021
        jmp     mainlp
        
        
;-------------------------------------------------------------------------------
!if TEST = 0 {
    !src "mousecheese.s"
}
!if TEST = 1 {
    !src "arkanoid.s"
}
!if TEST = 2 {
    !src "krakout.s"
}
;-------------------------------------------------------------------------------
; add mouse movement to sprite positions
LC190:  
        lda     mousex
        bmi     LC1A2
        sec
        lda     pointerx
        sbc     mousex
        bcs     LC1AF
        lda     #$00
        beq     LC1AF
LC1A2:  sec
        lda     pointerx
        sbc     mousex
        bcs     LC1AD
        cmp     #$A0
        bcc     LC1AF
LC1AD:  lda     #$9F
LC1AF:  sta     pointerx

        lda     mousey
        bmi     LC1C0
        sec
        lda     pointery
        sbc     mousey
        bcs     LC1CD
        lda     #$00
        beq     LC1CD
LC1C0:  sec
        lda     pointery
        sbc     mousey
        bcs     LC1CB
        cmp     #$C8
        bcc     LC1CD
LC1CB:  lda     #$C7
LC1CD:  sta     pointery

        rts

;-------------------------------------------------------------------------------
; set sprite x/y position
LC1D0:  
        ; set x position
        lda     pointerx
        clc
        adc     #$0C
        asl
        pha
        bcc     +
        lda     $D010
        ora     #$01
        bne     LC1E5
+
        lda     $D010
        and     #$FE
LC1E5:  
        sta     $D010
        pla
        sta     $D000
        
        ; set y position
        clc
        lda     pointery
        adc     #$32
        sta     $D001
        rts

;-------------------------------------------------------------------------------
sprite: !byte   $FC, $00, $00
        !byte   $F0, $00, $00
        !byte   $F0, $00, $00
        !byte   $D8, $00, $00
        !byte   $8C, $00, $00
        !byte   $86, $00, $00
        !byte   $03, $00, $00
        !for n,0,63-8 {
        !byte   $00
        }

scrollup:
        ldx #0
-
        lda $0428,x
        sta $0400,x
        inx
        bne -
        ldx #0
-
        lda $0528,x
        sta $0500,x
        inx
        bne -
        ldx #0
-
        lda $0628,x
        sta $0600,x
        inx
        bne -
        ldx #0
-
        lda $0728,x
        sta $0700,x
        inx
        cpx #$e8-40
        bne -
        rts
        
printhex:
        pha
        lsr
        lsr
        lsr
        lsr
        tax
        lda hextab,x
        ldy #0
        sta (lineptr),y
        
        pla 
        and #$0f
        tax
        lda hextab,x
        iny
        sta (lineptr),y

        inc lineptr
printspace:
        inc lineptr
        rts
        
hextab:
    !scr "0123456789abcdef"
