
irqcount = $02

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
    
    ; clear mask(s)
    lda #$7f
    sta $dc0d
    sta $dd0d
    
    lda #0
    sta irqcount

    sta $dc0e   ; stop timer A
    sta $dc0f   ; stop timer B
    sta $dd0e   ; stop timer A
    sta $dd0f   ; stop timer B
    
    lda #$35
    sta $01
    
    ; set irq vector
    lda #>irq
    sta $ffff
    lda #<irq
    sta $fffe
    ; set nmi vector
    lda #>nmi
    sta $fffb
    lda #<nmi
    sta $fffa
    
    ; set timer
    lda #>$1000
    sta $dc05
    lda #<$1000
    sta $dc04
    lda #>$fff0
    sta $dd05
    lda #<$fff0
    sta $dd04

    ; start timer A, force load
    lda #$11
    sta $dd0e

    ; enable Timer A interrupts
    lda #$81
    sta $dd0d
    
    ; start timer A, force load, one shot
    lda #$19
    sta $dc0e

    ; enable Timer A interrupts
    lda #$81
    sta $dc0d

    ; wait for the irq to trigger
-   ldy irqcount
    beq -

    sty $0400

    ; wait for irq to trigger a second time
    ; this should not happen
-   cpy irqcount
    beq -

    sty $0401

    jmp *

irq:
    inc irqcount

    ldx #0
    lda #0
    ; dummy read in cycle 4, clears interrupt flags
    ; write in cycle 5, has no effect
    sta $dc0d,x

    rti

nmi:
    lda $0400
    cmp #1
    bne failed
    lda $0401
    cmp #$20
    bne failed

    lda #5      ; green
    sta $d020
    lda #0      ; passed
    sta $d7ff

    jmp *

failed:
    lda #2      ; green
    sta $d020
    lda #$ff    ; passed
    sta $d7ff

    jmp *    
