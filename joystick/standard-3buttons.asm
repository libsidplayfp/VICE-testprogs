
; simple joystick tester, including 2nd and 3rd button (POTX/POTY)


joy = $0400

status = $0400+2*40

;-----------------------------------------------------------------------------
            *=$0801
            !word bend
            !word 10
            !byte $9e
            !text "2061", 0
bend:       !word 0
;-----------------------------------------------------------------------------

            sei
            ldx #0
-
            lda #$20
            sta $0400,x
            sta $0500,x
            sta $0600,x
            sta $0700,x
            lda #$01
            sta $d800,x
            sta $d900,x
            sta $da00,x
            sta $db00,x
            inx
            bne -

            ldx #0
-
            lda screendata,x
            sta $0400+(3*40),x
            inx
            bne -
loop:
            lda #$00
            sta $dc02
            sta $dc03
 
            lda $dc01
            eor #$ff
            sta joy

            lda $dc00
            eor #$ff
            sta joy+1

            lda #$ff
            sta $dc02
            
            lda #$40 ; select port 1
            sta $dc00
 
            ldx #0
-
            dex
            bne -
            
            lda $d419
            sta joy+3
            and #$80
            eor #$80
            ora joy
            sta joy
            
            lda $d41a
            sta joy+4
            and #$80
            eor #$80
            lsr
            ora joy
            sta joy
 
            lda #$80 ; select port 2
            sta $dc00

            ldx #0
-
            dex
            bne -
            
            lda $d419
            sta joy+6
            and #$80
            eor #$80
            ora joy+1
            sta joy+1
            
            lda $d41a
            sta joy+7
            and #$80
            eor #$80
            lsr
            ora joy+1
            sta joy+1

            lda joy
            ldx #0
-
            rol
            ldy #'.'
            bcc +
            ldy #'*'
+
            pha
            tya
            sta status,x
            pla
            inx
            cpx #8
            bne -
            
            lda joy+1
            ldx #0
-
            rol
            ldy #'.'
            bcc +
            ldy #'*'
+
            pha
            tya
            sta status+9,x
            pla
            inx
            cpx #8
            bne -

            jmp loop
 
 
 
 
screendata:
          ;1234567890123456789012345678901234567890
    !scr  "23 frldu 23 frldu                       "
    !scr  "nr iieop nr iieop                       "
    !scr  "dd rgfw  dd rgfw                        "
    !scr  "   ehtn     ehtn                        "
    !scr  "    t        t                          "
    !scr  "                                        "
    !scr  "port 1   port 2                         "
