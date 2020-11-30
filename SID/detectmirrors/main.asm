    *=$0801
    !word l                 ; link addr
    !word 10                ; line number
    !byte $9e               ; SYS
    !text "2080"
    !byte 0
l:  !word 0                 ; link

    !fill 2080-*,0

    lda #0
    sta $d020
    sta $d021
    
    ldx #0
-
    lda #$20
    sta $0400,x
    sta $0500,x
    sta $0600,x
    sta $0700,x
    lda #1
    sta $d800,x
    sta $d900,x
    sta $da00,x
    sta $db00,x
    inx
    bne -

    jsr sidDetect
    
    jmp *
    
zfb = $fb

sidDetect:
    jsr zeroSid

    ldx #$d4
    stx zfb+1

    lda #$81   ; init random
    ldy #$12
    sta (zfb),y
    lda #$ff
    ldy #$0f
    sta (zfb),y

loopMirror:
    lda zfb
    clc
    adc #$20
    sta zfb
    bne noIncZfc
    inc zfb+1
    lda zfb+1
    cmp #$d8
    beq done
noIncZfc:

    ldx #$0
tryAgain:
    ldy #$1b
    lda (zfb),y
    bne loopMirror
    inx
    cpx #10 ;  if random gets 0 for some times it means it's not a mirror of d41b
    bne tryAgain

mirrorFound:
    ldy #0
    lda zfb+1
    sta sidAddress+1
    jsr cciph
    lda zfb
    sta sidAddress
    jsr cciph

done:
    ldy #>output
    lda #<output
    jsr $ab1e
    ;  0 again in output2 for a 2nd run
    ldy #0
    tya
    jsr cciph
    lda #0
    jsr cciph

zeroSid:
    lda #0
    tay
    sta zfb
    ldx #$d4
lp0:
    stx zfb+1
lp1:
    sta (zfb),y
    iny
    bne lp1
    inx
    cpx #$d8
    bne lp0
    rts

cciph:
    pha
    lsr
    lsr
    lsr
    lsr
    jsr ccipher2
    pla
    and #$0f
ccipher2:
    clc
    adc #$30
    cmp #$3a
    bcc notLetter
    adc #$06
notLetter:
    sta outputAddr,y
    iny
    rts

output:
    !pet "detected second sid at "
outputAddr:
    !pet "0000."
    !byte 0
    
sidAddress:
    !word 0
