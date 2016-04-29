
; freezer/cartridge detection extracted from "Darkstar BBS" Disk
; note: the first test fails on some common RAM init patterns!
;
; thanks to tlr for finding this routine

            *=$0801
            ; BASIC stub: "1 SYS 2061"
            !byte $0b,$08,$01,$00,$9e,$32,$30,$36,$31,$00,$00,$00
            jmp start
start:
            sei
            jsr darkstartest
            lda #5
            sta $d020
            lda #$00
            sta $d7ff
            jmp *

i1415 =         $1415

            * = $18f3
darkstartest:
            ; first test (main)
            LDA #$40
            JSR i1914
            LDA #$50
            JSR i1914
            LDA #$60
            JSR i1914
            LDA #$70
            JSR i1914
            LDA #$80
            JSR i1914
            LDA #$90
            JSR i1914
            JMP i193D          ; go to second test

            ; first test (sub)
            ; checks if the first 10 bytes of a page are equal to the first
            ; byte of a page. fails if that is the case
i1914:
            STA $07
            LDA #$00
            STA $06

            LDY #$00
            LDA ($06),Y
            STA i193C           ; remember first value in page
            STY i1415           ; = 0

i1924:
            LDA ($06),Y         ; value at current address
            CMP i193C           ; first value in page
            BNE i192E
            INC i1415           ; increment if equal to first value in page
i192E:
            INY
            CPY #$0A
            BNE i1924

            CPY i1415           ; Y = 10
            BNE i193B           ; branch if counter is not 10
            JMP i198D           ; test failed
i193B:
            ; first test passed
            RTS
i193C:
            !byte 0

            ; second test (main)
i193D:
            LDA #$40
            JSR i1958
            LDA #$50
            JSR i1958
            LDA #$60
            JSR i1958
            LDA #$70
            JSR i1958
            LDA #$80
            JSR i1958
            LDA #$90

            ; second test (sub)
            ; in a 4k block check if the first 8 bytes of any page contains an
            ; incrementing pattern (like 2,3,4,5,6,7,8,9) and fail if that is
            ; the case
i1958:
            STA $07
            LDY #$00
            STY $06

            LDA #$10
            STA i198C
i1963:
            LDA ($06),Y
            STA i193C           ; remember first value in page
            STY i1415           ; = 0
i196B:
            LDA ($06),Y         ; value at current address
            CMP i193C           ; first value in page
            BNE i1978
            INC i193C
            INC i1415
i1978:
            INY
            CPY #$08
            BNE i196B

            CPY i1415           ; Y = 8
            BEQ i198D

            LDY #$00
            INC $07
            DEC i198C
            BNE i1963
i198B:
            ; both test passed
            rts
i198C:
            !byte 0

            ; test failed
i198D:
            lda #10
            sta $d020
            lda #$ff
            sta $d7ff
            jmp *

            ; test failed -> crash
;.C:198d  A2 00       LDX #$00           ; copy code to $0200
;.C:198f  BD 9D 19    LDA $199D,X
;.C:1992  9D 00 02    STA $0200,X
;.C:1995  E8          INX
;.C:1996  E0 58       CPX #$58
;.C:1998  D0 F5       BNE $198F
;.C:199a  4C 00 02    JMP $0200
;.C:199d  A9 08       LDA #$08           ; clear $0800-$d000
;.C:199f  85 07       STA $07
;.C:19a1  A0 00       LDY #$00
;.C:19a3  84 06       STY $06
;.C:19a5  A2 C8       LDX #$C8
;.C:19a7  98          TYA
;.C:19a8  91 06       STA ($06),Y
;.C:19aa  C8          INY
;.C:19ab  D0 FB       BNE $19A8
;.C:19ad  E6 07       INC $07
;.C:19af  CA          DEX
;.C:19b0  D0 F6       BNE $19A8
;.C:19b2  AD C9 19    LDA $19C9          ; crash/hang
;.C:19b5  8D 00 01    STA $0100
;.C:19b8  A2 00       LDX #$00
;.C:19ba  8E 18 03    STX $0318
;.C:19bd  E8          INX
;.C:19be  8E 19 03    STX $0319
;.C:19c1  78          SEI
;.C:19c2  A9 1B       LDA #$1B
;.C:19c4  8D 11 D0    STA $D011
;.C:19c7  D0 FE       BNE $19C7
;.C:19c9  40          RTI

