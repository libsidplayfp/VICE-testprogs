        !convtab pet
        !cpu 6510
        !to "rpm1.prg", cbm

;-------------------------------------------------------------------------------

drivecode_start = $0300
drivecode_exec = drvstart ; skip $10 bytes table

        !src "../framework.asm"

start:
        jsr clrscr

        lda #<drivecode
        ldy #>drivecode
        ldx #((drivecode_end - drivecode) + $1f) / $20 ; upload x * $20 bytes to 1541
        jsr upload_code

        lda #<drivecode_exec
        ldy #>drivecode_exec
        jsr start_code

        lda #$93
        jsr $ffd2

        sei
        jsr rcv_init
lp:
        sei
        jsr rcv_wait

        ldy #0
-
        jsr rcv_1byte
        sta $c000,y     ; lo
        jsr rcv_1byte
        sta $c028,y     ; hi

        iny
        cpy #19+1
        bne -

        ldy #0
-
        sec
        lda $c000,y
        sbc $c000+1,y
        sta $c100,y

        lda $c028,y
        sbc $c028+1,y
        sta $c128,y

        iny
        cpy #19
        bne -

        lda #19
        jsr $ffd2

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
        cpy #19
        bne -

        lda #$0d
        jsr $ffd2

        lda $c128       ; hi
        ldy $c100       ; lo
        jsr $b395       ; to FAC
        jsr $bc0c       ; ARG = FAC
        
        ldy #1
-
        tya
        pha

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
        cpy #19
        bne -

        jsr $bc0c       ; ARG = FAC

        lda #<c6000000
        ldy #>c6000000
        jsr $ba8c       ; in ARG

        lda $61
        jsr $bb12       ; FAC = ARG / FAC

        jsr $aabc       ; print FAC
        jmp lp

c6000000:
        !byte $9a,$64,$e1,$c0,$00

;-------------------------------------------------------------------------------

drivecode:
!pseudopc drivecode_start {
.data1 = $0016

        !src "../framework-drive.asm"

drvstart
        sei
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

        ; the timer is stopped for (4+4+4) cycles when reading it,
        ; so advance it by that amount here before sending the value
        sec
        sbc #4+4+4
        bcs skp
        dex
skp:
        jsr snd_1byte
        txa
        jsr snd_1byte

        iny
        cpy #19+1
        bne -

        jmp drvlp

measure:

        lda #18         ; track nr
        sta $08  
        ldx #$00        ; sector nr
        stx $09  
        lda #$e0        ; seek and start program at $0400
        sta $01
        cli
        lda $01  
        bmi *-2
        sei
        rts

htime:  !byte 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
ltime:  !byte 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0

        ;* = $0400
        !align $ff, 0, 0

measureirq:

-
        jsr dretry

        lda #0
        cmp $19
        bne -

        ldy $180b
        tya
        ora #$20        ; stop timer B
        sta $180b

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
        cpy #19+1
        bne -

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

        LDA #$52
        STA $24

        JSR $F556       ; wait for sync

        BVC *           ; wait byte ready
        CLV             ; clear byte ready flag
        LDA $1C01
        CMP $24
        BNE dretry      ; not a header
dlp:
        BVC *           ; wait byte ready
        CLV             ; clear byte ready flag
        LDA $1C01
        STA $25,x

        INX
        CPX #$07
        BNE dlp

        lda #0
        sta $01

        JSR $F497       ; decode GCR $24- to $16-

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
