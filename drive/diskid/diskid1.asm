        !convtab pet
        !cpu 6510
        !to "diskid1.prg", cbm

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

        lda #14
        jsr $ffd2

        lda #10
        sta $d020

        sei
        jsr rcv_init
lp:
        sei
        jsr rcv_wait

        lda #0
        sta fails+1

        ldy #0
-
        jsr rcv_1byte
        sta $0400+(0*40),y
        ldx #5
        cmp #$41        ; a
        beq sk1
        ldx #10
        inc fails+1
sk1:
        txa
        sta $d800+(0*40),y

        jsr rcv_1byte
        sta $0400+(1*40),y
        ldx #5
        cmp #$58        ; x
        beq sk2
        ldx #10
        inc fails+1
sk2:
        txa
        sta $d800+(1*40),y

        iny
        cpy #19
        bne -

        ldx #5
fails:  lda #0
        beq sk3
        ldx #10
sk3:
        stx $d020

        lda #$ff
        cpx #5
        bne failed
        lda #0
failed:
        sta $d7ff

        jmp lp


;-------------------------------------------------------------------------------

drivecode:
!pseudopc drivecode_start {
;.data1 = $0016

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
        lda hdr0,y
        jsr snd_1byte
        lda hdr1,y
        jsr snd_1byte

        iny
        cpy #19
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

hdr0:  !byte 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
hdr1:  !byte 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0

        ;* = $0400
        !align $ff, 0, 0

measureirq:

-
        jsr dretry

        lda #0
        cmp $19
        bne -

        ldy #0
-
        jsr nextsec

        lda $16+0       ; ID2
        sta hdr0,y
        lda $16+1       ; ID1
        sta hdr1,y

        iny
        cpy #19
        bne -

        jmp $F99C       ; to job loop

nextsec:
        sty .ytmp1+1

        jsr dretry


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
