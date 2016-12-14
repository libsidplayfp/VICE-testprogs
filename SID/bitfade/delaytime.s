
    .macpack longbranch
    .export Start

.ifdef SCANFRQ0
scanreg = $d400
scantype = 1
.endif
.ifdef SCANOSC3
scanreg = $d41b
scantype = 0
.endif
.ifdef SCANENV3
scanreg = $d41c
scantype = 0
.endif
.ifdef SCANNOISE
scanreg = $d41b
scantype = 2
.endif

VOICE1 = $d400
VOICE2 = $d407
VOICE3 = $d40e


scp = $02

Start:
        sei
        lda #$35
        sta $01

        lda #$20
        ldx #0
lp1:
        sta $0400,x
        sta $0500,x
        sta $0600,x
        sta $0700,x
        inx
        bne lp1

.if (scantype = 0) || (scantype = 1) || (scantype = 2)
                ; init sid
                LDA     #0
                LDX     #$17

loc_90F:
                STA     $D400,X
                DEX
                BPL     loc_90F

                LDA     #$F
                STA     $D418

                ; SR
                LDA     #$F0
                STA     VOICE1+6
                STA     VOICE2+6
                STA     VOICE3+6
.endif

mainloop:
        ; stop timers
        lda #%00000000
        sta $dc0e
        lda #%01000000
        sta $dc0f
        
        lda #$ff
        sta $dc04
        sta $dc05
        sta $dc06
        sta $dc07

                ; trigger one "8 bit sample"
.if scantype = 0
                LDA     #$11     ; gate on, waveform 1
                STA     VOICE3+4
                LDA     #$09     ; gate on, testbit on, waveform 0
                STA     VOICE3+4

                lda     #$ff
                STA     VOICE3+1 ; freq hi
                LDA     #$01     ; gate on, waveform 0
                STA     VOICE3+4
.endif
                ; trigger simple note
.if scantype = 1
                LDA     #$11     ; gate on, waveform 1
                STA     VOICE1+4
                lda     #$2f
                STA     VOICE1+1 ; freq hi
                lda     #$ff
                STA     VOICE1+0 ; freq lo
                LDA     #$11     ; gate on, waveform 1
                STA     VOICE1+4
.endif
                ; trigger noise, then lock it
.if scantype = 2
                LDA     #$81     ; gate on, waveform 8
                STA     VOICE3+4
                lda     #$ff
                STA     VOICE3+1 ; freq hi
                lda     #$ff
                STA     VOICE3+0 ; freq lo
                ldx #0
@lp2:
                bit $eaea
                bit $eaea
                dex
                bne @lp2
@lp1:
                lda scanreg             ; 4
                beq @lp1
                LDA     #$81+8   ; gate on, waveform 8 + test bit
                STA     VOICE3+4
.endif

        ; force load and start chained timers
        lda #%00010001
        sta $dc0e
        lda #%01010001
        sta $dc0f

.if (scantype = 0) || (scantype = 1)
        lda #$ff                ; 2
        sta scanreg             ; 4

loop:
        lda scanreg             ; 4
        cmp #$ff                ; 2
        beq loop                ; 2+1
.endif
.if (scantype = 2)
loop:
        lda scanreg             ; 4
        cmp #$ff                ; 2
        bne loop                ; 2+1
.endif
        ; stop timers
        lda #%00000000          ; 2
        sta $dc0e               ; 4
        lda #%01000000          ; 2
        sta $dc0f               ; 4
                                ; = 26

        jsr gettimers

        lda #>$0428
        sta scp+1
        lda #<$0428
        sta scp+0
        jsr timerout

        lda 1
        ldy #10
        jsr hexout

        jmp mainloop

gettimers:
        lda $dc04
        eor #$ff
        sta val+3
        lda $dc05
        eor #$ff
        sta val+2
        lda $dc06
        eor #$ff
        sta val+1
        lda $dc07
        eor #$ff
        sta val+0

        sec
        lda val+3
        sbc #24
        sta val+3
        lda val+2
        sbc #0
        sta val+2
        lda val+1
        sbc #0
        sta val+1
        lda val+0
        sbc #0
        sta val+0

        rts

timerout:
        ldy #0
        lda val+0
        jsr hexout
        lda val+1
        jsr hexout
        lda val+2
        jsr hexout
        lda val+3
        jsr hexout
        rts
        
hexout:
        pha
        lsr
        lsr
        lsr
        lsr
        tax
        lda hexval,x
        sta (scp),y
        iny
        pla
        and #$0f
        tax
        lda hexval,x
        sta (scp),y
        iny
        rts

hexval:
        .byte "0123456789"
        .byte 1,2,3,4,5,6
        
val:
        .byte 0,0,0,0

    .segment "INIT"
