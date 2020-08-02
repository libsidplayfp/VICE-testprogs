        !convtab pet
        !cpu 6510
        !to "rpm1.prg", cbm

        !src "mflpt.inc"

TESTTRACK = 30
TRACKSECTORS = 18

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

        ; get time stamps
        ldy #0
-
        jsr rcv_1byte
        sta $c000,y     ; lo
        jsr rcv_1byte
        sta $c028,y     ; hi

        jsr rcv_1byte
        sta $c050,y     ; cnt
        sta $0400+(24*40),y

        iny
        cpy #TRACKSECTORS+1
        bne -

        ; calculate delta times
        ldy #0
-
        sec
        lda $c000,y
        sbc $c000+1,y
        sta $c100,y

        lda $c028,y
        sbc $c028+1,y
        sta $c128,y

        ; the timer is stopped for (4+4+4+1) cycles when reading it
        lda $c100,y
        clc
        adc #4+4+4+1
        sta $c100,y

        lda $c128,y
        adc #0
        sta $c128,y

        iny
        cpy #TRACKSECTORS
        bne -

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

        lda $c128,y     ; hi
        tax
        lda $c100,y     ; lo
        tay
        txa
        jsr $b395       ; to FAC

        jsr $aabc       ; print FAC

        pla
        tay
        iny
        cpy #TRACKSECTORS
        bne -

        ; calculate total time for one revolution
        lda $c128       ; hi
        ldy $c100       ; lo
        jsr $b395       ; to FAC
        jsr $bc0c       ; ARG = FAC

        lda #0
        sta nonzero+1

        ldy #1
-
        tya
        pha

        lda $c128,y     ; hi
        ora $c100,y     ; lo
        beq +
        inc nonzero+1
+
        lda $c128,y     ; hi
        tax
        lda $c100,y     ; lo
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
        ; HACK: add some more cycles to compensate for BVC jitter
;         lda #0
;         ldy #4
;         jsr $b395       ; to FAC
;         lda $61
;         jsr $b86a       ; FAC = FAC + ARG
;         jsr $bc0c       ; ARG = FAC

        ; print total numbers of cycles
        clc
        ldx #0
        ldy #20
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
        +mflpt (200000 * 300)

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
        sta $1808
        sta $1809

        sty $180b       ; start it again

        ldy #0
-
        jsr nextsec
        sta htime,y
        txa
        sta ltime,y

        iny
        cpy #TRACKSECTORS+1
        bne -
 
        cli

        jmp $F99C       ; to job loop

nextsec:
        sty .ytmp1+1

        jsr dretry

        ldy $180b
        tya
        ora #$20        ; stop timer B
        sta $180b
        ldx $1808       ; 4 lo
        lda $1809       ; 4 hi
        sty $180b       ; 4 start it again

.ytmp1  ldy #0
        rts

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
