          *=$0801             ; basic start
          !WORD +
          !WORD 10
          !BYTE $9E
          !TEXT "2061"
          !BYTE 0
+         !WORD 0

          lda #$93
          jsr $ffd2

          ldx #0
tlp
          lda text,x
          beq tsk
          sta $0400+(24*40),x
          inx
          bne tlp
tsk

          sei
          lda #$8f
          sta $dc0d

          LDA #0
          TAX                 ; Counter X = 0
          STA $DC0E           ; stop CIA Timer A
          STA $DC05
          
          LDA #1
          STA $DC04           ; Timer A value = 1
          
          LDA #2
          STA $D020           ; border = red
          
          !if (ONESHOT=1) {
          LDA #%11011001      ; force load Timer A; Run Mode: One-Shot
          STA $DC0E           ; shift register: SP is output; TOD=50Hz 
                              ; set mode and start Timer A
          } else {
          lda #%11010001
          sta $dc0e
          }
                              
;          LDA #$A8            ; write byte in "serial data register"
;          STA $DC0C           ; and start transfer
          
loop:
          !if (ONESHOT=1) {
          LDA #%11011001      ; force load Timer A, Run Mode: One-Shot
          STA $DC0E           ; shift register: SP is output; TOD=50Hz 
                              ; start Timer A
          }

-         LDA $DC0D           ; read and clear the "interrupt control register"
          sta $0400+(2*40),x
          AND #1              ; Interrupt from Timer A?
          BEQ -               ; no, then try again

          lda $dc0d           ; restore value from "interrupt control register"
          sta $0400+(10*40),x
;          AND #8              ; Interrupt from SP?
;          BEQ loop            ; no, then do it again
                              ; --> endless loop in standalone/dockingstation mode
;          LDA #7
;          STA $D020           ; SP interrupt occured: border = yellow

;          !if (ONESHOT=1) {
;          CPX #16             ; 16 loops? (2 x 8-Bit)
;          } else {
;          cpx #2
;          }
;          BNE notok
          inx
          bne loop
                           
OK:       LDA #5
          STA $D020           ; test ok: border = green

;notok:    LDA #0
;          JSR $BDCD           ; print value X/A on screen

          lda #$7f
          sta $dc0d
          lda $dc0d
          sei

          ldx #0
lp1:
          ldy #5
          lda $0400,x
          cmp reference,x
          beq sk1
          ldy #10
sk1:
          tya
          sta $d800,x
          inx
          bne lp1

          ldx #0
lp2:
          ldy #5
          lda $0400+$100,x
          cmp reference+$100,x
          beq sk2
          ldy #10
sk2:
          tya
          sta $d800+$100,x
          inx
          bne lp2

          ldx #0
lp3:
          ldy #5
          lda $0400+$200,x
          cmp reference+$200,x
          beq sk3
          ldy #10
sk3:
          tya
          sta $d800+$200,x
          inx
          bne lp3

          JMP *

text:
        !scr "cia icr test - "
          !if (ONESHOT=1) {
            !scr "oneshot "
          } else {
            !scr "continues "
          }
          !if (CIA=1) {
            !scr "(new cia)"
          } else {
            !scr "(old cia)"
          }
        !byte 0

reference:
          !if (CIA=1) {
            !if (ONESHOT=1) {
                !binary "icr-oneshot-new.ref",,2
            } else {
                !binary "icr-continues-new.ref",,2
            }
          } else {
            !if (ONESHOT=1) {
                !binary "icr-oneshot-old.ref",,2
            } else {
                !binary "icr-continues-old.ref",,2
            }
          }
