
                *=$0801
                ; BASIC stub: "1 SYS 2061"
                !byte $0b,$08,$01,$00,$9e,$32,$30,$36,$31,$00,$00,$00
                jmp start

                *=$1000

start:
                lda     #5
                sta     $d020

                lda     #<nmihandler1
                sta     $0318
                lda     #>nmihandler1
                sta     $0319

mainloop:
                lda     #0
                sta     $dd04
                sta     $dd05
                lda     #$81
                sta     $dd0d
                lda     #$19
                sta     $dd0e
                nop
                nop
                lda     #<nmihandler2
                sta     $0318
                lda     #>nmihandler2
                sta     $0319
                jmp     mainloop

nmihandler1:
                pha
                lda     #<nmihandler2
                sta     $0318
                lda     #>nmihandler2
                sta     $0319
                pla
                rti

                ; failed
nmihandler2:
                inc     $d020
                jmp     nmihandler2
