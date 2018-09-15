            *=$0801
            !word bend
            !word 10
            !byte $9e
            !byte "2","0","6","1", 0
bend:       !word 0
;-------------------------------------------------------------------------------

; disallow interrupts and disable screen to get stable timing
    sei
    jsr clrscreen
    lda #5
    sta finalresult+1
    lda #0
    sta $d011
    sta currenttest
; set frequency
    
    lda #$ff
    ldx #$ff
    sta $d40E
    stx $d40F

start
    ldx currenttest
    cpx #$08
    bne next
    jmp end
next
    jsr reset

; at this point all bit should be high
    ldx #$00
    jsr plot

    ldy currenttest
    lda test,y
    asl
    asl
    asl
    asl
    sta $d412
    jsr plot

; set testbit and waveform
    ora #$08
    sta $d412
    jsr plot

    lda #$80
    sta $d412
  
loopx
    lda $d41b
result
    sta $0400,x
    inx
    cpx #80
    bne loopx
    inc currenttest
    inc $d020
    jmp start
end
    lda #<reference
    sta refptr+1
    lda #>reference
    sta refptr+2
    lda #<$400
    sta scrptr+1
    lda #>$400
    sta scrptr+2
    lda #<$d800
    sta color+1
    lda #>$d800
    sta color+2
    ldx #0
    stx xcount+1
refptr
    lda reference,x
scrptr
    cmp $400,x
    bne error
    lda #5
    jmp color
error
    lda #2
    sta finalresult+1
color
    sta $d800,x
    inx
xcount
    cpx #0
    bne refptr
    inc color+2
    inc refptr+2
    inc scrptr+2
    lda #7
    cmp scrptr+2
    bcc finalresult
    bne refptr
    lda #$e8
    sta xcount+1
    jmp refptr

plot
    lda $d41b
plotloc
    sta $400,x
    inx
    rts
   
finalresult
    lda #5
    sta $D020
    ldy #0      ; success
    lda $d020
    and #$0f
    cmp #5
    beq branch4
    ldy #$ff    ; failure
branch4
    sty $d7ff

; enable screen again to make result visible
    cli
    lda #$1b
    sta $d011
keypress
    lda $dc01
    cmp #$ef
    bne keypress
    lda #$35
    sta $d018
keyrelease
    lda $dc01
    cmp #$ef
    beq keyrelease
    lda #$15
    sta $d018
    jmp keypress

reset
; noise reg may need some time
; to reset
    txa
    asl
    tay
    lda result1,y
    sta result+1
    sta plotloc+1
    lda result1+1,y
    sta result+2
    sta plotloc+2

    lda test,x
    asl
    asl
    asl
    asl
    ora #$08
    sta $d412

    ldy #$10
branch3
    ldx #$00
branch2
    lda #$f0
branch1
    cmp $d012
    bne branch1
    dex
    bne branch2
    dey
    bne branch3
    rts
clrscreen
    lda #$20    ;Clear the screen
    ldx #$00
clrscr   
    sta $0400,x
    sta $0500,x
    sta $0600,x
    sta $0700,x
    dex
    bne clrscr
    rts

result1 
    !word $400,$400+(3*40),$400+(6*40),$400+(9*40),$400+(12*40),$400+(15*40),$400+(18*40),$400+(21*40)
test 
    !byte $8,$9,$a,$b,$c,$d,$e,$f
currenttest 
    !byte 0

*=$c00
reference

!if NEWSID=0 {
    !binary "data.bin"
}
!if NEWSID=1 {
    !binary "data8580.bin"
}
