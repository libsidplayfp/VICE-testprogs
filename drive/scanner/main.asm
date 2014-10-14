        !convtab pet
        !cpu 6510

;-------------------------------------------------------------------------------

drivecode_start = $0300
drivecode_exec = drvstart ; skip $10 bytes table

        !src "../framework.asm"

start:
        jsr clrscr

        ldx #1
.lp:
        lda hextab,x
        sta $0400+(40*10)-1,x
        inx
        cpx #$10
        bne .lp

        ldx #0
-
        lda info,x
        beq +
        sta $0400+(40*20),x
        inx
        bne -
+

        lda #<drivecode
        ldy #>drivecode
        ldx #((drivecode_end - drivecode) + $1f) / $20 ; upload x * $20 bytes to 1541
        jsr upload_code

        lda #<drivecode_exec
        ldy #>drivecode_exec
        jsr start_code

        sei
        jsr rcv_init

        lda #1
        sta rtrk
        lda #17
        sta rsec

lp:

        jsr rcv_wait

        jsr rcv_1byte           ; get track nr
        cmp #$ff
        beq recend
        sta rtrk
        tax
        lda #'*'
        sta $0400+(40*13)-1,x

        jsr rcv_1byte           ; get sector nr
        sta rsec
        jsr rcv_1byte           ; get result code
        ;clc
        ;adc #$30 ; '0'
        tay
        lda hextab,y
        sta $0400+(40*11)-1,x

        ; get block
        ldx #$00
-
        jsr rcv_1byte
        sta $0400,x
        inx
        bne -

    !if (0) {
        ; we skip track 17/18 because this program and the directory 
        ; will be there
        lda rtrk
        cmp #17
        beq lp
        cmp #18
        beq lp
    }

        ; compare block
        ldx rtrk
        lda #10
        sta $d800+(40*13)-1,x

        ldx #$00
-
        lda #10
        sta $d800,x
;        inx
;        sta $d800,x
;        dex

        txa
        eor rtrk
        cmp $0400,x
        bne recerr
        lda #5
        sta $d800,x

        inx
        txa
        eor rsec
        cmp $0400,x
        bne recerr
        lda #5
        sta $d800,x

        inx
        bne -

        ldx rtrk
        lda #5
        sta $d800+(40*13)-1,x

        jmp lp

recerr:
        lda rtrk
        cmp #TRACKS+1
        bcs skp

        !if (ERRORS = 1) {
        cmp #2
        beq skp
        cmp #3
        beq skp
        cmp #9
        beq skp
        cmp #$b
        beq skp
        }

        lda #10
        sta rescol
skp:
        jmp lp

recend:
        lda rescol
        sta $d020
        jmp *

rtrk: !byte 0
rsec: !byte 0

rescol: !byte 5

info:
    !scr "scanning "
    !if (TRACKS = 35) {
        !scr "35"
    }
    !if (TRACKS = 40) {
        !scr "40"
    }
    !if (TRACKS = 42) {
        !scr "42"
    }
    !scr " tracks"
    !if (ERRORS = 1) {
        !scr " (with error map)"
    }
    !byte 0

;-------------------------------------------------------------------------------

drivecode:
!pseudopc drivecode_start {
.data1 = $0700

        !src "../framework-drive.asm"

drvstart
        sei
        lda #$7a
        sta $1802
        ldy #$00
        sty $1800

drvlp:

        ; clear the buffer
        ldy #$00
-       tya
        sta .data1,y
        iny
        bne -

trk     lda #1
;trk     lda #4
sect    ldx #16
        jsr read

        pha

        jsr snd_start

        lda trk+1
        jsr snd_1byte   ; send track nr
        lda sect+1
        jsr snd_1byte   ; send sector nr
        pla
        jsr snd_1byte   ; send result code

        ; send the buffer
        ldy #$00
-
        lda .data1,y
        jsr snd_1byte
        iny
        bne -

        inc trk+1
        lda trk+1
        cmp #43
;        cmp #5
        beq drvend
        jmp drvlp
drvend:
        lda #18
        lda #0
        jsr read

        jsr snd_start
        lda #$ff
        jsr snd_1byte
        rts

read:
        cmp #36
        bcs read36

;sect    ldx #0
        stx $0f         ; sector
;trk     lda #1
        sta $0e         ; track
        lda #$80        ; read block
        sta $04

        ; execute jobcode
        cli
        lda $04
        bmi *-2
        sei
        rts
read36:
;        lda #36         ; track nr
        sta $08  
;        ldx #$00        ; sector nr
        stx $09  
        lda #$e0        ; seek and start program at $0400
        sta $01
        cli
        lda $01  
        bmi *-2
        sei
        rts

        ; irq/jobcode routine for loading tracks > 35
        ;* = $0400
        !align $ff, 0, 0

        lda $1c00
        and #$9F
        ora #$00
        sta $1c00        ; set speedzone

        lda #$11         ; nr of sectors
        sta $43
        lda #>.data1     ; highbyte of target buffer
        sta $31
        jmp $F4d1        ; load sector
;
; code from data beckers "anti cracker book" (page 248):
;
; 0600 lda $1c00          Control-Port laden
; 0603 and #$9F           Bits für Speed löschen
; 0605 ora #$00           und mit neuern Speed verknüpfen
; 0607 sta $1c00          Wert wieder speichern
; 060A lda #$11           Anzahl der Sektoren laden
; 060C sta $43            und übergeben
; 060E lda #$05           HIGH-Byte der Pufferadresse, in den
; 0610 sta $31            geladen werden soll, angeben.
; 0612 jmp $F4d1          zur laderoutine springen
; 
; Das Programm wird hier gestartet
; 
; 0615 lda #$24           zu ladenden Track für
; 0617 sta $0c            den Job übergeben
; 06I9 lda #$00           Sektor-Nl.I11I'Ier an
; 061B sta $0d            den Job übergeben
; 0610 lda #$e0           Job·Code für Programm ausführen in den
; 061F sta $03            Job-Speicher schreiben
; 0621 lda $03            Rückmeldung abwarten
; 0623 bmi $0621          verzweige, wenn noch nicht fertig
; 0625 rts                Rücksprung
} 
drivecode_end:
