
; NEOS code taken from Krakout+NEOS crack by TSM
; https://csdb.dk/release/?id=216216

BUGFIX = 1
IGNOREDCODE = 0

mouseport = 0 ; 1 for port1, 0 for port0

readmouse:  ; $911a

!if BUGFIX = 1 {
    ; DDR is not initialized in the original release!
    lda     #$10
    sta     $DC02+mouseport
}
    ; unset clk
    LDA #$EF
    STA $DC00+mouseport

    LDX #$08
    JSR delay

    ; 4 bits (high) available - ignored
!if IGNOREDCODE = 1 {
    LDA $DC00+mouseport
    ASL
    ASL
    ASL
    ASL
    STA mousex
}
    ; set clk
    LDA #$10
    STA $DC00+mouseport

    LDX #$05
    JSR delay

    ; 4 bits (low) available - ignored
!if IGNOREDCODE = 1 {
    LDA $DC00+mouseport
    AND #$0F
    ORA mousex
    STA mousex
}
    ; unset clk
    LDA #$EF
    STA $DC00+mouseport

    LDX #$05
    JSR delay

    ; get 4 bits (high)
    LDA $DC00+mouseport
    ASL
    ASL
    ASL
    ASL
    STA mousey

    ; set clock
    LDA #%10111111
    STA $DC00+mouseport

    LDX #$05
    JSR delay

    ; get 4 bits (low)
    LDA $DC00+mouseport
    AND #$0F
    ORA mousey
    STA mousey
    RTS

; delay
delay:
    NOP
    NOP
    NOP
    DEX
    BNE delay
    RTS
