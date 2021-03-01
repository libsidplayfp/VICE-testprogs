; Copyright (C) 2021 by Krill/Plush

; Permission to use, copy, modify, and/or distribute this software for any
; purpose with or without fee is hereby granted.

; THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES WITH
; REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF MERCHANTABILITY
; AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY SPECIAL, DIRECT,
; INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES WHATSOEVER RESULTING FROM
; LOSS OF USE, DATA OR PROFITS, WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR
; OTHER TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR
; PERFORMANCE OF THIS SOFTWARE.

CHKTRK = 18
CHKSEC = 10

READST = $ffb7
SETLFS = $ffba
SETNAM = $ffbd
OPEN   = $ffc0
CLOSE  = $ffc3
CHKIN  = $ffc6
CKOUT  = $ffc9
CLRCH  = $ffcc
BASIN  = $ffcf
BSOUT  = $ffd2

FNLEN  = $b7
FA     = $ba
FNADR  = $bb

IERROR = $0300

ERRCHN = 15
CR     = $0d

            * = $0801

            .word zeroes, 2021
            .byte $9e
            .text format("%d", start)
zeroes      .byte 0, 0, 0

start       lda #modeldtcted - modeldetect
            ldx #<modeldetect
            ldy #>modeldetect
            jsr readbyte
            bcs error
            ldx #devincompat - strings
            and #8
            bne printstring

            lda #<BUFS
            sta drivecodeto
            lda #>BUFS
            sta drivecodeto + 1
            lda #drvcodeend - drivecode
            ldx #<drivecode
            ldy #>drivecode
            jsr uploadcode
            bcs error

            lda #rundrvcodend - rundrvcode
            ldx #<rundrvcode
            ldy #>rundrvcode
            jsr openerrcmdc
            bcs error
            jsr CLRCH

            ldx #ERRCHN
            jsr CHKIN
            lda #CR
            jsr BSOUT
-           jsr READST
            bne +
            jsr BASIN
msgbuf=*+1
            sta $5000
            inc msgbuf
            jsr BSOUT
            cmp #CR
            bne -
+           jsr closechannl

            lda #masstoragee - masstoragec
            ldx #<masstoragec
            ldy #>masstoragec
            jsr readbyte
            bcs error
            cmp #128 + 1
            clc
            beq closechannl2
            ldx #masstoragem - strings

printstring lda strings,x
            beq closechannl2
            jsr BSOUT
            inx
            bne printstring
closechannl2
            jsr checkmsgbuffer

closechannl php
            pha
            jsr CLRCH
            lda #ERRCHN
            jsr CLOSE

            pla
            plp
            rts

error       jsr closechannl

            ldy #10
            sty $d020
            ldy #$ff
            sty $d7ff

            tax
            jmp (IERROR)

readbyte    jsr openerrcmdc
            bcs errorreturn
            ldx #ERRCHN
            jsr CHKIN
            jsr BASIN
            clc
errorreturn rts

openerrcmdc jsr SETNAM
            lda #ERRCHN
            ldx FA
            bne +
            ldx #8
+           tay
            jsr SETLFS
            jmp OPEN

uploadcode  jsr SETNAM
uploadloop  ldx #ERRCHN
            jsr CKOUT
            bcs errorreturn
            ldx #0
-           lda drivecodemw,x
            jsr BSOUT
            inx
            cpx #drvcodemwed - drivecodemw
            bne -
            ldy #0
-           lda (FNADR),y
            jsr BSOUT
            iny
            cpy FNLEN
            bcs +
            cpy #35
            bcc -
+           jsr CLRCH
            clc
            lda #35
            adc drivecodeto
            sta drivecodeto
            bcc +
            inc drivecodeto + 1
            clc
+           lda #35
            adc FNADR
            sta FNADR
            bcc +
            inc FNADR + 1
+           sec
            lda FNLEN
            sbc #35
            sta FNLEN
            bcs uploadloop
            jmp closechannl

strings
devincompat .text "DEVICE INCOMPATIBLE"
            .byte CR, 0

masstoragem .text "MASS STORAGE DEVICE"
            .byte CR, 0

checkmsgbuffer:
            ldy #13
            ldx #$00
            lda $5000+4
            cmp #$4f ; O
            beq +
            ldy #10
            ldx #$ff
+
            sty $d020
            stx $d7ff
            rts

INTDRV = $d005
MODEL  = $e5c6
CMDER2 = $e648
SRCH   = $f510
SYNC   = $f556
TRNOFF = $f98f

DSKCNT = $1c00
MOTOR  = 4
T1HC2  = $1c05
T1HL2  = $1c07
T2HC2  = $1c09
IFR2   = $1c0d
TI2FLG = $20

JOBS   = $00
HDRS   = $06
WORK   = $44

CMDBUF = $0200
ERRBUF = $02d5
BUFS   = $0300

EXEC   = $e0

modeldetect .text "M-R"
            .word MODEL
            .byte 1
modeldtcted

drivecodemw .text "M-W"
drivecodeto .word 0
            .byte 35
drvcodemwed

drivecode
            .logical BUFS

            lda #CHKSEC
            sta HDRS + 1
            ldx #3
            jsr readandstep
            lda #>((3 * 200000 / 19) + 1000)
            sta T2HC2
            ldx #1
            jsr readandstep
            jsr readandstep
            lda #TI2FLG
            and IFR2
            beq isemu

            inc ERRBUF + 1
            lsr halftrkstps + 1
            lda #28
            sta stepwait + 1
            lda #$ff
            sta T2HC2
            ldx #3
            stx WORK
            jsr halftrkstps
            jsr SYNC
            ldx #1
            stx WORK
            jsr halftrkstps
            lda #CHKSEC + 6
            sta HDRS + 1
            jsr readandstep
            lda #TI2FLG
            and IFR2
            bne isemu
            dec ERRBUF + 1

isemu       sta JOBS
            rts

readandstep stx WORK
            jsr SRCH
halftrkstps ldx #4
trackstep   lda DSKCNT
            and #255 - MOTOR
            clc
            adc WORK
            ora #MOTOR
            sta DSKCNT
stepwait    ldy #2
halftrkstep lda T1HC2
waitstep    cmp T1HC2
            beq waitstep
            dey
            bne halftrkstep
            dex
            bne trackstep
            inc HDRS + 1
            rts

check       inc masstoragev

            jsr INTDRV

            lda #CHKTRK
            sta HDRS
            ldx #2
retry       lda #EXEC
            sta JOBS
-           lda JOBS
            bmi -
            bne +
            jmp TRNOFF

+           dex
            bne retry
            beq +
-           sta ERRBUF + 3,x
            inx
+           lda message,x
            bpl -

            jmp CMDER2

message     .text "EMU"
masstoragev .byte 128

            .here
drvcodeend

rundrvcode  .text "M-E"
            .word check
rundrvcodend

masstoragec .text "M-R"
            .word masstoragev
            .byte 1
masstoragee
