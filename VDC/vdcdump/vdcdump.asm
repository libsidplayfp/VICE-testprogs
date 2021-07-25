
        ;       VDC Dump - memory test program for C128


*=$1c01

        ;       0 sys7181

        !byte    $0b,$1c,$00,$00,$9e,$37,$31,$38,$31,$00,$00,$00


*=$1c0d

        jmp     main

fail    !byte   $00     ; 0 if tests pass, non zero if fail

msgc    !byte    $3a

        ;       <cr>/<cr>

msgd    !byte    $0d
msgr    !byte    $0d,$00

        ;       esc-x/scnclr/esc-x

msgx    !byte    $1b,$58,$93,$1b,$58,$00

        ;       1/1,1/2,2/1,2/2

msg11   !byte    $31,$2f,$31,$00
msg12   !byte    $31,$2f,$32,$00
msg21   !byte    $32,$2f,$31,$00
msg22   !byte    $32,$2f,$32,$00

        ;       " ok"

msgok   !byte    $20,$4f,$4b,$00

        ;       " 64k"

msg64   !byte    $20,$36,$34,$4b,$00

        ;       " 16k"

msg16   !byte    $20,$31,$36,$4b,$00

        ;       " emu"

msgem   !byte    $20,$45,$4d,$55,$00

wplp    bit     $d600
        bpl     wplp
        rts

vdlx    stx     $d600
vdld    jsr     wplp
        lda     $d601
        rts

vd1c    ldx     #$1c

vdsx    stx     $d600
vdst    jsr     wplp
        sta     $d601
        rts

main    php
        sei

        lda     #$00
        ldx     #$1c
        sta     $fb
        sta     $fc
        sta     $fd
        sta     $fe

        jsr     vdlx
        pha

        jsr     test
        jsr     test

        pla
        jsr     vd1c

        ldx     #$00
        stx     $08

        lda     #<msgok
        sta     emu+1

        ;       check if only matching emulator layout

        lda     $fc
        cmp     #$c0
        bcc     resp

        and     #$30
        cmp     #$30
        bcs     resp

        sta     $fc
        asl
        asl
        ora     $fc
        sta     $fc

        lda     #$30
        and     $fb
        sta     $fb
        asl
        asl
        ora     $fb
        sta     $fb

        lda     #<msgem
        sta     emu+1
        
        inc fail    ; Emulator layout so fail

        ;       printing results (summary)

resp    txa
        stx     $09
        asl
        asl
        adc     #<msg11
        tax
        jsr     print

        ldx     $09
        lda     $fb,x
        cmp     #$c0
        bcs     xesp

        pha
emu     ldx     #<msgok
        jsr     print
        pla
        bne     nesp

        lda     $08
        bne     mesp

        lda     $09
        cmp     #$02
        bcc     ok64

        lda     $fb
        and     $fc
        and     #$40
        bne     xesp

ok64    lda     #$80

nesp    pha
        and     #$40
        bne     sesp

        ldx     #<msg64
        jsr     print

sesp    pla
        bmi     xesp

mesp    ldx     #<msg16
        jsr     print

        inc     $08

xesp    ldx     #<msgr
        jsr     print

        ldx     $09
        inx
        cpx     #$04
        bcc     resp

        plp

        ; Handle VICE debug cart
        lda fail
        bne +
        ; Pass
        sta $d7ff   ; Debug cart=0 for success
        lda #5
        sta $d020   ; Set border green for pass
        jmp ++
+       ; Fail
        lda #$ff
        sta $d7ff   ; Ddebug cart=$ff for fail
        lda #2
        sta $d020   ; Set border red for fail
++
        lda     $fffe
        cmp     #$17
        bne     pret

        jsr     $ff62

        ldx     #<msgx

        ;       print message

print   php
        cli

pelp    lda     $1c00,x
        beq     pend

        jsr     $ffd2

        inx
        bpl     pelp

pend    ldx     #$00
        plp

pret    rts

nulx    lda     #$00
        ldx     #$12
        sta     $06
        sta     $07
        jsr     vdsx

        inx
        jsr     vdsx

        tay
        tax
        lda     #$1f
        sta     $d600

        rts

        ;       the testing subroutine (called two times: 1st and 2nd round)

test    lda     #$3f
        jsr     vd1c

        jsr     nulx

telp    tya
        jsr     vdst

        inx
        bne     telp

        iny
        bne     telp

        stx     $08
        sty     $09

        lda     #$12
        eor     telp
        sta     telp

        cmp     #$98
        bne     rump

        dec     $09

        ;       dumping in 64K mode

rump    jsr     dump

        lda     #$2f
        jsr     vd1c

        dec     $08

        ;       dumping in 16K mode

dump    jsr     nulx

dulp    lda     $07
        sta     $02

        jsr     numpr

        ldx     #<msgc
        jsr     print

dxlp    jsr     vdld
        sta     $02

        bit     $08
        bvc     xump

        inx

        ;       check if matching any system (2nd round)

xump    bit     $09
        bvc     nump

        cmp     $06
        beq     temp

        lda     #$f0
        sta     $fd,x
        bne     temp

nxlp    bne     dxlp
nulp    bne     dulp

        ;       check if matching 16K real system (1st round)

nump    lda     $07

        bit     $08
        bvc     cump

        asl

cump    ora     #$81

        cmp     $02
        beq     qump

        lda     #$80
        ora     $fb,x
        sta     $fb,x

        ;       check if matching 64K real system (1st round)

qump    lda     $07

        bit     $08
        bvc     zump

        and     #$80
        sta     $03

        lda     $07
        and     #$01
        beq     harm

        lda     #$03
        ora     $03
        sta     $03

harm    lda     $07
        and     #$3e
        asl

        ora     $03

zump    cmp     $02
        beq     jump

        lda     #$40
        ora     $fb,x
        sta     $fb,x

        ;       check if matching 16K emulator system (1st round)

jump    lda     $07

        ora     #$c0

        cmp     $02
        beq     eump

        lda     #$20
        ora     $fb,x
        sta     $fb,x

        ;       check if matching 64K emulator system (1st round)

eump    lda     $07

        cmp     $02
        beq     temp

        lda     #$10
        ora     $fb,x
        sta     $fb,x

        ;       print number

temp    jsr     numpr

        lda     #$20
        jsr     $ffd2

        sei
        inc     $06
        bne     nxlp

        ldx     #<msgd
        jsr     print

        inc     $07
        bne     nulp

        rts

        ;       print number (in $02)

numpr   lda     #$00
        sta     $03

num16   sta     $04
num24   sta     $05
        ldx     #$08
        bne     nlp0

nlp1    lda     $02
        sbc     ntab1-1,x
        sta     $02
        lda     $03
        sbc     ntab2-1,x
        sta     $03
        lda     $04
        sbc     ntab3-1,x
        sta     $04
        iny

nlp2    lda     $02
        cmp     ntab1-1,x
        lda     $03
        sbc     ntab2-1,x
        lda     $04
        sbc     ntab3-1,x
        bcs     nlp1

        tya
        bne     nlp3
        ldy     $05
        beq     nlpy

nlp3    ora     #$30
        sty     $05
        jsr     $ffd2

nlp0    ldy     #$00
nlpy    dex
        bne     nlp2

        lda     #$30
        ora     $02
        jmp     $ffd2

ntab1   !byte    $0a,$64,$e8,$10,$a0,$40,$80
ntab2   !byte    $00,$00,$03,$27,$86,$42,$96
ntab3   !byte    $00,$00,$00,$00,$01,$0f,$98

        ;       compiled with CBM prg Studio v3.10 (by Arthur Jordison)
        ;       http://ajordison.co.uk/

        ;       Rosetta Interactive Fiction project homepage:

        ;       http://istennyila.hu/rosetta

        ;       v0.13 (c) 2012-2017 by Robert Olessak
