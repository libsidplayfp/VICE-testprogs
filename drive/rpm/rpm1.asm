        !convtab pet
        !cpu 6510

        !src "mflpt.inc"

TESTTRACK = 30
TRACKSECTORS = 18

;-------------------------------------------------------------------------------

rpmline = $0400 + (0 * 40)

drivecode_start = $0300
drivecode_exec = drvstart ; skip $10 bytes table

factmp = $340
timerlotab = $c000
timerhitab = $c028
deltalotab = $c100
deltahitab = $c128
timerlo=$c200
timerhi=$c201

        !src "../framework.asm"

start:
!if DOPLOT = 0 {
        jsr clrscr
} else {
        jsr initplot
}
        inc $d021

        lda #<drivecode
        ldy #>drivecode
        ldx #((drivecode_end - drivecode) + $1f) / $20 ; upload x * $20 bytes to 1541
        jsr upload_code

        lda #<drivecode_exec
        ldy #>drivecode_exec
        jsr start_code

        dec $d021

!if DOPLOT = 0 {
        lda #$01
        sta $286
        lda #$93
        jsr $ffd2
}
        sei
        jsr waitframe
        jsr rcv_init
lp:
        sei
        jsr waitframe
        jsr rcv_wait

        ; get time stamps
        ldy #0
-
        jsr rcv_1byte
        sta timerlotab,y     ; lo
        jsr rcv_1byte
        sta timerhitab,y     ; hi

        jsr rcv_1byte        ; sector
        
        sta $c050,y     ; cnt
!if DOPLOT = 0 {
        sta $0400+(24*40),y
}
        iny
        cpy #TRACKSECTORS+1
        bne -

        ; calculate delta times
        ldy #0
-
        sec
        lda timerlotab,y
        sbc timerlotab+1,y
        sta deltalotab,y

        lda timerhitab,y
        sbc timerhitab+1,y
        sta deltahitab,y

        iny
        cpy #TRACKSECTORS
        bne -

!if DOPLOT = 0 {
        lda #19
        jsr $ffd2
        lda #$0d
        jsr $ffd2
        lda #$0d
        jsr $ffd2

        ; print delta times
        ldy #0
-
        tya
        pha

        lda deltahitab,y     ; hi
        tax
        lda deltalotab,y     ; lo
        tay
        txa
        jsr $b395       ; to FAC

        jsr $aabc       ; print FAC

        pla
        tay
        iny
        cpy #TRACKSECTORS
        bne -
}
        ; calculate total time for one revolution
        lda deltahitab       ; hi
        ldy deltalotab       ; lo
        jsr $b395       ; to FAC
        jsr $bc0c       ; ARG = FAC

        lda #0
        sta nonzero+1

        ldy #1
-
        tya
        pha

        lda deltahitab,y     ; hi
        ora deltalotab,y     ; lo
        beq +
        inc nonzero+1
+
        lda deltahitab,y     ; hi
        tax
        lda deltalotab,y     ; lo
        tay
        txa
        jsr $b395       ; to FAC

        lda $61
        jsr $b86a       ; FAC = FAC + ARG
        jsr $bc0c       ; ARG = FAC

        pla
        tay
        iny
        cpy #TRACKSECTORS
        bne -

nonzero: 
        lda #0
        bne +
        jmp lp
+
        ; compensate cycle difference between timer start and read
        lda #0
        ldy #< (11 + 8)
        jsr $b395       ; to FAC
        lda $61
        jsr $b86a       ; FAC = FAC + ARG
        jsr $bc0c       ; ARG = FAC

        ; need to preserve FAC
        ldx #5
-
        lda $61,x
        sta factmp,x
        dex
        bpl -

        jsr $bc9b       ; $64/$65 = FAC
        lda $65
        eor #$ff
        sta timerlo
        lda $64
        eor #$ff
        sta timerhi

!if DOPLOT = 0 {
        lda timerhi
        jsr mkhex
        sta $0400+(2*40)+16
        sty $0400+(2*40)+17
        lda timerlo
        jsr mkhex
        sta $0400+(2*40)+18
        sty $0400+(2*40)+19
}
        ; restore FAC
        ldx #5
-
        lda factmp,x
        sta $61,x
        dex
        bpl -

!if DOPLOT = 0 {
        ; print total numbers of cycles
        clc
        ldx #0
        ldy #15
        jsr $fff0

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

        lda #'0'
        ldx #6
-
        sta rpmline+5,x
;        sta rpmline+45,x
        dex
        bpl -
        lda #'.'
        sta rpmline+4

        jsr $aabc       ; print FAC

        ; calculate RPM again, this time rounding to two decimals

        ; restore FAC
        ldx #5
-
        lda factmp,x
        sta $61,x
        dex
        bpl -

        lda #<c600000000
        ldy #>c600000000
        jsr $ba8c       ; in ARG

        lda $61
        jsr $bb12       ; FAC = ARG / FAC

        jsr $B849       ; Add 0.5 to FAC
        jsr $BDDD       ; Convert FAC#1 to ASCII String at $100
 
        lda $101+0
        sta rpmline+25
        lda $101+1
        sta rpmline+26
        lda $101+2
        sta rpmline+27
        lda #'.'
        sta rpmline+28
        lda $101+3
        sta rpmline+29
        lda $101+4
        sta rpmline+30
        
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

        lda $0400+(24*40)+39
        eor #$80
        sta $0400+(24*40)+39
} else {
        jsr doplot
        lda $d020
        eor #$0f
        sta $d020
}
      
        jmp lp
        
;-------------------------------------------------------------------------------

c6000000:
        +mflpt (200000 * 300)
c600000000:
        +mflpt (20000000 * 300)

wait2frame:
        jsr waitframe
waitframe:
-       lda $d011
        bmi -
-       lda $d011
        bpl -
        rts

mkhex:
        pha
        and #$0f
        tax
        lda hextab,x
        tay             ; lo in Y
        pla
        lsr
        lsr
        lsr
        lsr
        tax
        lda hextab,x    ; hi in A
        rts
;-------------------------------------------------------------------------------

drivecode:
!pseudopc drivecode_start {

        !src "../framework-drive.asm"

drvstart
        sei
        lda $180b
        and #%11011111  ; start timer B
        sta $180b
        jsr snd_init

        lda #TESTTRACK  ; track nr
        sta $08
        ldx #$00        ; sector nr
        stx $09
        lda #$e0        ; seek and start program at $0400
        sta $01
        cli

        jmp *

htime:  !byte 1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21
ltime:  !byte 1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21

        ;* = $0400
        !align $ff, 0, 0

measurelp:
        sei
        jsr domeasure

        sei
        jsr snd_start

        ldy #0
-
        lda htime,y
        tax
        lda ltime,y

        jsr snd_1byte
        txa
        jsr snd_1byte

        tya
        jsr snd_1byte

        iny
        cpy #TRACKSECTORS+1
        bne -

        jmp measurelp

domeasure:
        sei
-
        jsr dretry

        lda $19         ; 2
        bne -           ; 2
 
        ; load timer with $ffff
        ; lo first, writing hi reloads latch when timer is running
        lda #$ff        ; 2
        sta $1808       ; 4
        sta $1809       ; 4

        ; timer starts 14 cycles after sector 0 was detected

        ldy #0
-
        sty .ytmp1+1
        jsr dretry

        ; get timer value
        lda $1808       ; 4 lo
        ldx $1809       ; 4 hi
        cmp #4
        bcs +
        inx             ; compensate hi-byte decrease
+
        ; timer was read 4 cycles after sector header was detected

.ytmp1: ldy #0
        sta ltime,y
        txa
        sta htime,y

        iny
        cpy #TRACKSECTORS+1
        bne -
 
        rts
 
dretry:
        LDX #$00

        ; wait for sync
-       bit $1c00
        bmi -
        lda $1c01       ; this is needed on real drive, works in VICE without!
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

        jmp $F497       ; decode GCR $24- to $16-

;
; code from data beckers "anti cracker book" (page 235/236):
;
; 
; 0500 JMP $0503   Sprung für den ersten Durchlauf unbedeutend
; 0503 LDA #$19    Low Byte der Einsprungadresse
; 0505 STA $0501   in den JMP-Befehl schreiben (JMP $0519)
; 0508 LDA #$01    Track, auf dem ausgeführt werden soll
; 050A STA $0A     in Speicher für Puffer zwei speichern
; 050C LDA #$00    Sektornummer (unerheblich)
; 050E STA $0B     speichern
; 0510 LDA #$EO    Jobcode $E0 (Programm im Puffer ausführen)
; 0512 STA $02     in Jobspeicher für Puffer zwei schreiben
; 0514 LDA $02     Jobspeicher lesen
; 0516 BMI $0514   verzweige wenn nicht beendet
; 0518 RTS         Rücksprung
; 
; 0519 LDA #$03    Einspung wieder
; 0518 STA $0501   normalisieren (JMP $0503)
; 051E LDX #$5A    90 Leseveruche
; 0520 STX $4b     im Zähler speichern
; 0522 LDX #$00    Zeiger auf 0 setzen
; 0524 LDA #$52    GCR-Codierung $08 (Headerkennzeichen)
; 0526 STA $24     in Arbeitsspeicher speichern
; 0528 JSR $F556   auf SYNC warten
; 052b BVC $052b   auf BYTE-READY beim Lesen warten
; 0520 CLV         BYTE-READY wieder Löschen
; 052E LDA $1C01   gelesenes Byte vom Port holen
; 0531 CMP $24     mit gespeichertem Header vergleichen
; 0533 BNE $0548   verzweige, wenn kein Blockheader gefunden
; 0535 BVC $0535   sonst auf BYTE-READY warten
; 0537 CLV         Leitung rücksetzen
; 0538 LDA $1C01   gelesenes Byte holen
; 053B STA $25,x   und in Arbeitsspeicher schieben
; 0530 INX         Zeiger erhöhen
; 053E CPX #$07    schon ganzen HEADER geleser,?
; 0540 BNE $0535   verzweige, wenn noch nicht alte Zeichen
; 0542 JSR $F497   GCR-BYTEs in Bitform wandeln
; 0545 JMP $FD9E   Rücksprung aus dem Interrupt (ok)

; 0548 DEC $4b     Zähler für Fehlversuche verringern
; 054A BNE $0522   verzweige wenn weitere Versuche
; 054C LDA #$02    Fehlermeldung ($02=Blockheader nicht
; 054E JMP $F969   gefunden) ausgeben und Programm beenden
; 

} 
drivecode_end:

!if DOPLOT=1 {
    !src "plotter.asm"
}
