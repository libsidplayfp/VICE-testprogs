; this file is part of the C64 Emulator Test Suite. public domain, no copyright

            *= $0801
           
            .word baslink
            .word 0
            .byte $9e ; SYS
            .byte $32, $30, $36, $31
baslink:
            .byte 0,0,0

;            jmp main_
;main_:
           .block
           ldx #0
           stx $d3
           
           stx $d020    ; neutral border color at startup
           
           lda thisname
printthis
           jsr $ffd2
           inx
           lda thisname,x
           bne printthis
           
           jsr main
           
           ; success
           
           lda #$37
           sta 1
           lda #$2f
           sta 0
           
           jsr $fd15
           jsr $fda3
           jsr print
           .text " - ok"
           .byte 13,0

            #SET_EXIT_CODE_SUCCESS
            
           .bend
           
        ; entry point used by waitkey
loadnext:
           .block
           ldx #$f8
           txs
           
           lda #47
           sta 0
           
           lda nextname
           cmp #"-"
           bne notempty
           jmp $a474
notempty
           ldx #0
printnext
           jsr $ffd2
           inx
           lda nextname,x
           bne printnext

           lda #0
           sta $0a
           sta $b9
           stx $b7  ; namelen
           lda #<nextname
           sta $bb
           lda #>nextname
           sta $bc
           jmp $e16f
           .bend
