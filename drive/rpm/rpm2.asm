        !convtab pet
        !cpu 6510
        !to "rpm2.prg", cbm

        !src "mflpt.inc"

TESTTRACK = 30

;-------------------------------------------------------------------------------

rpmline = $0400 + (0 * 40)

drivecode_start = $0300
drivecode_exec = drvstart ; skip $10 bytes table

factmp = $340

        !src "../framework.asm"

start:
        jsr clrscr

        inc $d021

        lda #<drivecode
        ldy #>drivecode
        ldx #((drivecode_end - drivecode) + $1f) / $20 ; upload x * $20 bytes to 1541
        jsr upload_code

        lda #<drivecode_exec
        ldy #>drivecode_exec
        jsr start_code

        dec $d021

        lda #$01
        sta $286
        lda #$93
        jsr $ffd2

        sei
        jsr rcv_init
lp:
        sei
        jsr rcv_wait

        ; get time stamp

        jsr rcv_1byte
        sta $c000     ; lo
        jsr rcv_1byte
        sta $c028     ; hi

        lda #19
        jsr $ffd2
        lda #$0d
        jsr $ffd2
        lda #$0d
        jsr $ffd2

        ; print delta times
;         ldy $c000     ; lo
;         lda #0
;         jsr $b395     ; to FAC
; 
;         jsr $aabc     ; print FAC
; 
;         lda #$0d
;         jsr $ffd2
;         
;         ldy $c028     ; lo
;         lda #0
;         jsr $b395     ; to FAC
; 
;         jsr $aabc     ; print FAC
; 
;         lda #$0d
;         jsr $ffd2

        ; calculate total time for one revolution

        lda $c028     ; lo
        ldy $c000
        jsr $b395     ; to FAC
        lda $90
        eor #$ff
        sta $90
        jsr $bc0c       ; ARG = FAC

        lda #<c2000000
        ldy #>c2000000
        jsr $bba2       ; in FAC

        lda $61
        jsr $b853       ; FAC = FAC - ARG

        ; need to preserve FAC
        ldx #5
-
        lda $61,x
        sta factmp,x
        dex
        bpl -

        jsr $aabc       ; print FAC

        ; restore FAC
        ldx #5
-
        lda factmp,x
        sta $61,x
        dex
        bpl -

        lda #$20
        ldx #10
-       sta rpmline+4,x
        dex
        bpl -

        ; calculate RPM

        ; expected ideal:
        ; 300 rounds per minute 
        ; = 5 rounds per second
        ; = 200 milliseconds per round
        ; at 1MHz (0,001 milliseconds per clock)
        ; = 200000 cycles per round

        ; to calculate RPM from cycles per round:
        ; RPM = (200000 * 300) / cycles

        lda #<c6000000
        ldy #>c6000000
        jsr $ba8c       ; in ARG

        lda $61
        jsr $bb12       ; FAC = ARG / FAC
 
        lda #19
        jsr $ffd2

        jsr $aabc       ; print FAC

        ; give the test two loops to settle
framecount = * + 1
        lda #2
        beq +
        dec framecount
        jmp lp
+
        ; compare, we consider 299,300,301 as acceptable
        ldy #10

        lda rpmline+1
        cmp #$32    ; 2
        bne cmp300
        lda rpmline+2
        cmp #$39    ; 9
        bne cmp300
        lda rpmline+3
        cmp #$39    ; 9
        bne cmp300
        ; is 299
        ldy #5
cmp300:        
        lda rpmline+1
        cmp #$33    ; 3
        bne cmp301
        lda rpmline+2
        cmp #$30    ; 0
        bne cmp301
        lda rpmline+3
        cmp #$30    ; 0
        bne cmp301
        ; is 301
        ldy #5
cmp301:        
        lda rpmline+1
        cmp #$33    ; 3
        bne cmpfail
        lda rpmline+2
        cmp #$30    ; 0
        bne cmpfail
        lda rpmline+3
        cmp #$31    ; 1
        bne cmpfail
        ; is 301
        ldy #5
cmpfail:       
        
        sty rpmline+$d401
        sty rpmline+$d402 
        sty rpmline+$d403 
        sty $d020
        
        lda #$ff
        cpy #5
        bne +
        lda #0
+        
        sta $d7ff

        jsr wait2frame
      
        jmp lp

c6000000:
        +mflpt (-200000 * 300)
c2000000:
        +mflpt (200000 - 3361)

wait2frame:
        jsr waitframe
waitframe:
-       lda $d011
        bpl -
-       lda $d011
        bmi -
        rts
        
;-------------------------------------------------------------------------------

drivecode:
!pseudopc drivecode_start {
.data1 = $0016

        !src "../framework-drive.asm"

drvstart
        sei
        lda $180b
        and #%11011111  ; start timer B
        sta $180b
        jsr snd_init

drvlp:
        jsr measure

        sei
        jsr snd_start

        lda ltime+0
        jsr snd_1byte
        lda htime+0
        jsr snd_1byte

        jmp drvlp

measure:

        lda #TESTTRACK  ; track nr
        sta $08
        ldx #$00        ; sector nr
        stx $09
        lda #$e0        ; seek and start program at $0400
        sta $01
        cli
        lda $01
        bmi *-2
        rts

htime:  !byte 1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21
ltime:  !byte 1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21

        ;* = $0400
        !align $ff, 0, 0

measureirq:

        sei

        ; wait for sektor 0 header
-
        jsr dretry

        lda $19
        bne -
 
        ldy $180b
        tya
        ora #$20        ; stop timer B
        sta $180b

        ; load timer with $ffff
        lda #$ff
        sta $1809
        sta $1808

        sty $180b       ; start it again

        ; wait for sektor 0 header
-
        jsr dretry

        lda $19
        bne -

        ldy $180b
        tya
        ora #$20        ; stop timer B
        sta $180b

        lda $1809       ; 4 hi
        ldx $1808       ; 4 lo

        sty $180b       ; start it again

        sta htime + 0
        stx ltime + 0
 
        cli

        jmp $F99C       ; to job loop

dretry:
        LDX #$00

;        JSR $F556       ; wait for sync
; F556: A9 D0     LDA #$D0        ; 208
; F558: 8D 05 18  STA $1805       ; start timer
; F55B: A9 03     LDA #$03        ; error code
; F55D: 2C 05 18  BIT $1805
; F560: 10 F1     BPL $F553       ; timer run down, then 'read error'
; F562: 2C 00 1C  BIT $1C00       ; SYNC signal
; F565: 30 F6     BMI $F55D       ; not yet found?
; F567: AD 01 1C  LDA $1C01       ; read byte
; F56A: B8        CLV
; F56B: A0 00     LDY #$00
; F56D: 60        RTS        
-       bit $1c00
        bmi -
        lda $1c01
        clv

        ; read byte after sync
        BVC *           ; wait byte ready
        CLV             ; clear byte ready flag

        ; check if it's a header
        LDA $1C01
        cmp #$52
        bne -

        ; read rest of header
-
        BVC *           ; wait byte ready
        CLV             ; clear byte ready flag

        LDA $1C01
        STA $25,x

        INX
        CPX #$07
        BNE -

        JSR $F497       ; decode GCR $24- to $16-

        lda #0
        sta $01
        rts

} 
drivecode_end:
