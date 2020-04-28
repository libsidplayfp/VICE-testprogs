    *= $8000
    jmp ColdStart       ; reset vector
    jmp WarmStart
    
    !byte 1             ; we are autostart
    !byte $43,$42,$4d   ; CBM

ColdStart:
WarmStart:
    ldx #0
    stx $d020

    ; put welcome message
-   lda WelcomeText,x
    beq +
;    jsr $ffd2
    inx
    jmp -
+   
    ; spin around
- 
    inc $d020
    dec $d020
    jmp -
;    rts

WelcomeText:
    !text "hello",0 

    *= $bfff
    !byte $ff
