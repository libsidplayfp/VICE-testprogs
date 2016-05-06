;**** report 6502 funtional test errors to standard I/O ****
;
;this include file is part of the 6502 functional tests
;it is used when you configure report = 1 in the tests
;
;to adopt the standard output vectors of your test environment
;you must modify the rchar and rget subroutines in this include
;
;I/O hardware may have to be initialized in report_init

;print message macro - \1 = message location
!macro rprt arg1 {
        ldx #0
        lda arg1
-
        jsr rchar
        inx
        lda arg1,x
        bne -
        }

;initialize I/O as required (example: configure & enable ACIA)
report_init
        ;nothing to initialize
        +rprt rmsg_start
        rts

clearscreen:
        php
        pha
        lda #$93
        jsr $ffd2
        pla
        plp
        rts

putchar:
        php
        pha
        jsr $ffd2
        pla
        plp
        rts

getchar:
        php
        lda #$81
        sta $dc0d
        lda $dc0d
        cli
        jsr $ffcf   ;example: CHRIN for a C64
        pha
        sei
        lda #$7f
        sta $dc0d
        lda $dc0d
        pla
        plp
        rts

;show stack (with saved registers), zeropage and absolute memory workspace
;after an error was trapped in the test program
report_error
;save registers
        php
        pha
        txa
        pha
        tya
        pha
        cld
;show stack with index to registers at error
        jsr clearscreen
!if test_case {
        lda test_case
        jsr rhex
}
        +rprt rmsg_stack
        tsx
        inx
        lda #1      ;address high
        jsr rhex
        txa         ;address low
        jsr rhex
rstack  jsr rspace
        lda $100,x  ;stack data
        jsr rhex
        inx
        bne rstack
        jsr rcrlf   ;new line
;show zero page workspace
        lda #0
        jsr rhex
        lda #zpt
        tax
        jsr rhex
rzp     jsr rspace
        lda 0,x
        jsr rhex
        inx
        cpx #zp_bss
        bne rzp
        jsr rcrlf
;show absolute workspace
        lda #>(data_segment)
        jsr rhex
        lda #<(data_segment)
        jsr rhex
        ldx #0
rabs    jsr rspace
        lda data_segment,x
        jsr rhex
        inx
        cpx #(data_bss-data_segment)
        bne rabs
;ask to continue
        +rprt rmsg_cont

        ; signal failure
        lda #10
        sta $d020
        lda #$ff
        sta $d7ff

rerr1   jsr rget
        cmp #'C'
        bne rerr1        
;restore registers
        pla
        tay
        pla
        tax
        pla 
        plp
        rts   

;show test has ended, ask to repeat
report_success
    !if rep_int = 1 {
        +rprt rmsg_priority
        lda data_segment    ;show interrupt sequence
        jsr rhex
        jsr rspace
        lda data_segment+1
        jsr rhex
        jsr rspace
        lda data_segment+2
        jsr rhex
    }
        +rprt rmsg_success

        ; signal success
        lda #5
        sta $d020
        lda #$00
        sta $d7ff

rsuc1   jsr rget
        cmp #'R'
        bne rsuc1

        lda #14
        sta $d020

        rts

;input subroutine
;get a character from standard input 
;adjust according to the needs in your test environment
rget                ;get character in A
;rget1
;        lda $bff1   ;wait RDRF
;        and #8
;        beq rget1
;not a real ACIA - so RDRF is not checked
;        lda $bff0   ;read acia rx reg
;the load can be replaced by a call to a kernal routine
        jsr getchar   ;example: CHRIN for a C64
        cmp #'a'    ;lower case
        bcc rget1
        and #$5f    ;convert to upper case
rget1   rts

;output subroutines
rcrlf   lda #10
        jsr rchar
        lda #13
        bne rchar

rspace  lda #' '
        bne rchar
        
rhex    pha         ;report hex byte in A
        lsr        ;high nibble first
        lsr
        lsr
        lsr
        jsr rnib
        pla         ;now low nibble
        and #$f

rnib    clc         ;report nibble in A
        adc #'0'    ;make printable 0-9
        cmp #'9'+1
        bcc rchar
        adc #6      ;make printable A-F

;send a character to standard output 
;adjust according to the needs in your test environment
;register X needs to be preserved!
rchar               ;report character in A
;        pha         ;wait TDRF
;rchar1  lda $bff1
;        and #$10
;        beq rchar1
;        pla
;not a real ACIA - so TDRF is not checked
;        sta $bff0   ;write acia tx reg
;the store can be replaced by a call to a kernal routine
        jsr putchar   ;example: CHROUT for a C64
        rts

rmsg_start
        !pet  $93, 10,13,"Started testing",10,13,0
rmsg_stack
        !pet  10,13,"regs Y  X  A  PS PCLPCH",10,13,0
rmsg_cont
        !pet  10,13,"press C to continue",10,13,0
rmsg_success
        !pet  10,13,"All tests completed, press R to repeat",10,13,0
    !if rep_int = 1 {
rmsg_priority
        !pet  10,13,"interrupt sequence (NMI IRQ BRK) ",0
    }
   