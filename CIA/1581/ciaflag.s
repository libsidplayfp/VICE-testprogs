; ciaflag.s - a test for a lost CIA FLAG interrupt in true drive emulation of a 1581.
;
; The C64 uploads a small program to the 1581 at device 8 (M-W) and starts it (M-E). The drive
; points its IRQ vector ($0192) at a handler that counts FLAG interrupts (the 1581's FLAG pin is
; ATN), enables only the FLAG interrupt and runs a busy loop with interrupts on. The C64, with
; interrupts off, then sends 1,000 bursts of two ATN pulses each, 400 cycles apart, with a pause
; of 5,100 to 10,200 cycles (pseudo-random) after each burst. Then it pulls CLK: the drive puts
; its IRQ vector and interrupt mask back and returns to DOS, and the C64 reads the count (M-R).
;
; Each pulse is one FLAG interrupt, so the count must be 2,000. A round that counts fewer has
; lost interrupts. 16 rounds; the screen shows each round's count, then OK (green border) or
; LOST (red border). The result is also at $033c: $aa when done, then rounds run, then the
; interrupts lost in all rounds (16 bits), and written to $d7ff (the debug cartridge: 0 passed,
; $ff failed).
;
;     64tass -o ciaflag.prg ciaflag.s
;     x64sc -debugcart -drive8type 1581 -drive8truedrive -autostartprgmode 1 -autostart ciaflag.prg

        .cpu "6502"
        .enc "none"

ROUNDS  = 16
BURSTS  = 1000                  ; two pulses each
RES     = $033c                 ; +0 $aa done, +1 rounds, +2/3 interrupts lost
lfsr    = $fa
nb      = $fb                   ; 2 bytes: bursts left
src     = $fd                   ; 2 bytes
SETLFS  = $ffba
SETNAM  = $ffbd
OPEN    = $ffc0
CHKOUT  = $ffc9
CHKIN   = $ffc6
CLRCHN  = $ffcc
CHROUT  = $ffd2
CHRIN   = $ffcf

        * = $0801
        .word +, 10
        .null $9e, format("%d", start)
+       .word 0

start   lda #0
        sta RES
        sta RES + 1
        sta RES + 2
        sta RES + 3
        lda #$5a
        sta lfsr
        lda #15                 ; the command channel
        ldx #8
        ldy #15
        jsr SETLFS
        lda #0
        jsr SETNAM
        jsr OPEN

        lda #<dcode             ; upload the drive code, 32 bytes a M-W
        sta src
        lda #>dcode
        sta src + 1
        lda #<DRIVE
        sta mwlo
        lda #>DRIVE
        sta mwhi
up      ldx #15
        jsr CHKOUT
        ldx #0
-       lda mwcmd,x
        jsr CHROUT
        inx
        cpx #6
        bne -
        ldy #0
-       lda (src),y
        jsr CHROUT
        iny
        cpy #32
        bne -
        jsr CLRCHN              ; (the unlisten runs the command)
        clc
        lda src
        adc #32
        sta src
        bcc +
        inc src + 1
+       clc
        lda mwlo
        adc #32
        sta mwlo
        bcc +
        inc mwhi
+       lda src + 1
        cmp #>dcode_end
        bcc up
        lda src
        cmp #<dcode_end
        bcc up

round   lda #<msgr
        ldy #>msgr
        jsr print
        ldx #15                 ; start the drive code
        jsr CHKOUT
        ldx #0
-       lda mecmd,x
        jsr CHROUT
        inx
        cpx #5
        bne -
        jsr CLRCHN
        ldx #20                 ; about 0.4 s for the drive to set up
        jsr jiffies

        sei
        lda #<BURSTS
        sta nb
        lda #>BURSTS
        sta nb + 1
burst   jsr pulse
        jsr gap
        jsr pulse
        jsr pause
        lda nb
        bne +
        dec nb + 1
+       dec nb
        lda nb
        ora nb + 1
        bne burst

        lda $dd00               ; done: CLK pulled
        ora #$10
        sta $dd00
        ldx #0
-       dex
        bne -
        lda $dd00
        and #$ef
        sta $dd00
        cli
        ldx #10
        jsr jiffies

        ldx #15                 ; read the count
        jsr CHKOUT
        ldx #0
-       lda mrcmd,x
        jsr CHROUT
        inx
        cpx #6
        bne -
        jsr CLRCHN
        ldx #15
        jsr CHKIN
        jsr CHRIN
        sta cnt
        jsr CHRIN
        sta cnt + 1
        jsr CLRCHN

        lda cnt + 1             ; print it: hex
        jsr hex
        lda cnt
        jsr hex
        lda #13
        jsr CHROUT
        sec                     ; lost = 2 * BURSTS - count
        lda #<(2 * BURSTS)
        sbc cnt
        tax
        lda #>(2 * BURSTS)
        sbc cnt + 1
        tay
        txa
        clc
        adc RES + 2
        sta RES + 2
        tya
        adc RES + 3
        sta RES + 3
        inc RES + 1
        lda RES + 1
        cmp #ROUNDS
        beq +
        jmp round
+       lda RES + 2
        ora RES + 3
        bne lost
        lda #5
        sta $d020
        lda #0                  ; the testbench's debug cartridge: 0 passed
        sta $d7ff
        lda #<msgok
        ldy #>msgok
        jmp fin
lost    lda #2
        sta $d020
        lda #$ff                ; $ff failed
        sta $d7ff
        lda #<msglost
        ldy #>msglost
fin     jsr print
        lda RES + 3
        jsr hex
        lda RES + 2
        jsr hex
        lda #13
        jsr CHROUT
        lda #$aa
        sta RES
        rts

; one ATN pulse: about 40 cycles low, then about 400 cycles before anything else
pulse   lda $dd00
        ora #$08
        sta $dd00
        ldx #8
-       dex
        bne -
        and #$f7
        sta $dd00
gap     ldx #80
-       dex
        bne -
        rts

; 5,100 to 10,200 cycles: 4 * 1,280 plus 0 to 255 * 20
pause   lda lfsr                ; the next pseudo-random byte (Galois LFSR, period 255)
        lsr a
        bcc +
        eor #$b8
+       sta lfsr
        tax
-       nop
        nop
        nop
        nop
        nop
        nop
        nop
        dex
        bne -
        ldy #4
pa_y    ldx #0
-       dex
        bne -
        dey
        bne pa_y
        rts

jiffies txa                     ; X jiffies (50 a second)
        clc
        adc $a2
-       cmp $a2
        bne -
        rts

print   sta src                 ; the string at A/Y, to its 0
        sty src + 1
        ldy #0
-       lda (src),y
        beq +
        jsr CHROUT
        iny
        bne -
+       rts

hex     pha
        lsr a
        lsr a
        lsr a
        lsr a
        jsr hexd
        pla
        and #15
hexd    cmp #10
        bcc +
        adc #6
+       adc #'0'
        jmp CHROUT

cnt     .word 0
mwcmd   .text "M-W"
mwlo    .byte 0
mwhi    .byte 0
        .byte 32
mecmd   .text "M-E"
        .word DRIVE
mrcmd   .text "M-R"
        .word dcnt
        .byte 2
msgr    .text "COUNT (MUST BE ", format("%04X", 2 * BURSTS), "): $", 0
msgok   .text "OK, INTERRUPTS LOST: $", 0
msglost .text "LOST INTERRUPTS: $", 0

; ---- the drive code, at $0500 in the 1581 ----
DRIVE   = $0500
dcode   .logical DRIVE
dstart  php
        sei
        lda $0192               ; the ROM's IRQ entry ($ff03) is jmp ($0192)
        sta ov
        lda $0193
        sta ov + 1
        lda #<dirq
        sta $0192
        lda #>dirq
        sta $0193
        lda #$7f                ; every CIA interrupt off, then FLAG only
        sta $400d
        lda $400d
        lda #0
        sta dcnt
        sta dcnt + 1
        lda #$90
        sta $400d
        cli
        ldx #0
dloop   inc work,x              ; busy, interrupts on (mostly 7-cycle instructions)
        inc work,x
        inc work,x
        inc work,x
        inx
        lda $4001               ; until the C64 pulls CLK (bit 2, CLK in)
        and #$04
        beq dloop
        sei
        lda #$7f
        sta $400d
        lda $400d
        lda ov                  ; DOS's vector and interrupt mask ($9a) back
        sta $0192
        lda ov + 1
        sta $0193
        lda #$9a
        sta $400d
        plp
        rts
dirq    pha                     ; (the ROM's entry saves nothing)
        lda $400d               ; acknowledge
        inc dcnt
        bne +
        inc dcnt + 1
+       pla
        rti
ov      .word 0
dcnt    .word 0
work    = $0600
        .endlogical
dcode_end
