
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

mousexold = $1b
mouseyold = $1c

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

        sei
mainlp:
        lda     #$7F
        sta     $DC00

-       lda $d011
        bmi -
-       lda $d011
        bpl -

        inc $d020

        jsr     readmouse

        ; if carry set then RMB pressed
        lda     #$07
        bcc     +
        lda     #$0A
+       sta     $D027

        jsr     LC190
        jsr     LC1D0

        inc $d020
        
        lda mousex
        cmp mousexold
        bne +
        lda mousey
        cmp mouseyold
        bne +
        
        jmp noprint
+
        jsr scrollup
        lda #>($0400+24*40)
        sta lineptr+1
        lda #<($0400+24*40)
        sta lineptr
        
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
        
        lda #0
        sta $d020
        
        ; check fire, if LMB pressed
        ldy     #0
        lda     $DC00
        and     #$10
        bne     +
        ldy     #11
+
        sty     $d021
        jmp     mainlp
        
        
;-------------------------------------------------------------------------------

readmouse:  lda     $DC00
        pha
        lda     $DC01
        pha
        lda     $DC02
        pha
        lda     $DC03
        pha

        lda     #$10
        sta     $DC02

        ; unset clk
        lda     $DC00
        and     #$EF
        sta     $DC00

        ldx     #$08
        jsr     delay

        ; get 4 bit from bits 0-3
        ; and rotate into bits 4-7
        lda     $DC00
        asl
        asl
        asl
        asl
        sta     mousex

        ; set clk
        lda     $DC00
        ora     #$10
        sta     $DC00
        
        ldx     #$05
        jsr     delay

        ; get 4 bit from bits 0-3
        ; and or into bits 0-3
        lda     $DC00
        and     #$0F
        ora     mousex
        sta     mousex

        ; unset clk
        lda     $DC00
        and     #$EF
        sta     $DC00
        
        ldx     #$05
        jsr     delay

        ; get 4 bit from bits 0-3
        ; and rotate into bits 4-7
        lda     $DC00
        asl
        asl
        asl
        asl
        sta     mousey

        ; set clk
        lda     $DC00
        ora     #$10
        sta     $DC00

        ldx     #$05
        jsr     delay

        ; get 4 bit from bits 0-3
        ; and or into bits 0-3
        lda     $DC00
        and     #$0F
        ora     mousey
        sta     mousey

        ; check RMB in POTX
        lda     $D419
        cmp     #$FF

        pla
        sta     $DC03
        pla
        sta     $DC02
        pla
        sta     $DC01
        pla
        sta     $DC00
        rts

delay:  nop
        nop
        nop
        dex
        bne     delay
        rts

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
