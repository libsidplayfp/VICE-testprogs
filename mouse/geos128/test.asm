
; = 1 to test non buggy code
TESTNOBUG = 0

potx = $fe
poty = $ff

screen = $0400

        * = $0801

        !word next
        !word 0
        !byte $9e
        !byte $32, $30, $36, $31
        !byte 0
next:
        !word 0

        sei

        lda #' '
        ldx #0
-
        sta screen,x
        sta screen+$100,x
        sta screen+$200,x
        sta screen+$300,x
        inx
        bne -

loop:

; start condition:
;Port A: ff  DDR: 00
;Port B: ff  DDR: 00
        lda #$00    ; input
        sta $dc02
        sta $dc03
        lda #$ff
        sta $dc00
        sta $dc01

;.C:fdde  8D 00 DC    STA $DC00      - A:40 X:09 Y:ED SP:c2 ..-..I..  101500742
        lda #$40
        sta $dc00
;.C:fde2  8D 03 DC    STA $DC03      - A:00 X:09 Y:ED SP:c3 ..-..IZ.  101500750
        lda #$00
        sta $dc03
;.C:fde6  8D 02 DC    STA $DC02      - A:FF X:09 Y:ED SP:c4 N.-..I..  101500758
        lda #$ff
        sta $dc02
;.C:c503  8D 00 DC    STA $DC00      - A:FF X:00 Y:00 SP:c3 N.-..I..  101502162
        lda #$ff
        sta $dc00

    ;...

;.C:c4d9  8D 00 DC    STA $DC00      - A:FE X:00 Y:00 SP:c5 N.-..I..  101503035
;PA ciacore_store_internal addr:0000 byte:fe rclk: 101503034
;store_ciapa: rclk: 101503035 maincpu_clk:  101503035 pot_port_mask_clk:  101502642 mask: 03->03

;.C:c4dc  AD 01 DC    LDA $DC01      - A:FF X:00 Y:00 SP:c5 N.-..I..  101503039
        lda $dc01
;.C:fe00  8D 02 DC    STA $DC02      - A:FF X:00 Y:FF SP:c6 N.-..I.C  101503093
;PA ciacore_store_internal addr:0002 byte:ff rclk: 101503092
        lda #$ff    ; PA output
        sta $dc02
;.C:fe05  8D 00 DC    STA $DC00      - A:40 X:00 Y:FF SP:c6 ..-..I.C  101503099
;PA ciacore_store_internal addr:0000 byte:40 rclk: 101503098
;store_ciapa: rclk: 101503099 maincpu_clk:  101503099 pot_port_mask_clk:  101503099 mask: 03->01
        lda #$40    ; PA write - select paddles port A
        sta $dc00

        ; some longish delay > 512 cycles
        ldx #0
-
        dex
        bne -

;.C:fd20  AD 02 DC    LDA $DC02      - A:FF X:20 Y:FF SP:c6 NV-..I.C  101520105
        lda $dc02
;.C:fd24  AD 03 DC    LDA $DC03      - A:00 X:20 Y:FF SP:c5 .V-..IZC  101520112
        lda $dc03
;.C:fd28  AD 00 DC    LDA $DC00      - A:40 X:20 Y:FF SP:c4 .V-..I.C  101520119
        lda $dc01

;.C:fd2e  8D 02 DC    STA $DC02      - A:00 X:20 Y:FF SP:c3 .V-..IZC  101520128
;PA ciacore_store_internal addr:0002 byte:00 rclk: 101520127
;store_ciapa: rclk: 101520128 maincpu_clk:  101520128 pot_port_mask_clk:  101520128 mask: 01->03    <- problem
    !if (TESTNOBUG = 1) {
        lda #$ff    ; PA output
    } else {
        lda #$00    ; PA input
    }
        sta $dc02   ; write DDRA    <- BUG!

;.C:fd31  8D 03 DC    STA $DC03      - A:00 X:20 Y:FF SP:c3 .V-..IZC  101520132
;PB ciacore_store_internal addr:0003 byte:00 rclk: 101520131
        lda #$00    ; PB input
        sta $dc03

        ; some short delay ~50 cycles or so
        ldx #10
-
        dex
        bne -

;.C:fd34  AD 01 DC    LDA $DC01      - A:FF X:20 Y:FF SP:c3 NV-..I.C  101520136
        lda $dc01

        ; cycles since PA write:    101520179 - 101503099 = 17080 (OK!)
        ; cycles since DDRA write:  101520179 - 101520128 = 51 (FAIL)

;.C:fd65  AD 19 D4    LDA $D419      - A:90 X:00 Y:FF SP:c3 N.-..I.C  101520179
;maincpu_clk:  101520178 port_changed_clk:  101520128 port_changed_diff_clk:         50 addr 0019
        lda $d419   ; potx read
        sta potx
;.C:fd98  AD 1A D4    LDA $D41A      - A:41 X:FF Y:90 SP:c3 ..-..I..  101520313
;maincpu_clk:  101520312 port_changed_clk:  101520128 port_changed_diff_clk:        184 addr 001a
        lda $d41a   ; poty read
        sta poty

        ; now display the values as simple bar graphs

        lda #'*'
        ldx #0
-
        sta screen,x
        inx
        cpx potx
        bne -

        lda #'-'
-
        sta screen,x
        inx
        bne -

        lda #'*'
        ldx #0
-
        sta screen+(10*40),x
        inx
        cpx poty
        bne -

        lda #'-'
-
        sta screen+(10*40),x
        inx
        bne -

        jmp loop
