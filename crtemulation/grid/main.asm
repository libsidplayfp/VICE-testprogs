            * = $0801
            !word eol,0
            !byte $9e, $32,$30,$36,$31, 0 ; SYS 2061
eol:        !word 0

start:
            lda #$18
            sta $d018
            
            lda #$3b
            sta $d011
            
            lda #1
            sta $d020
            
            ldx #0
-
            lda $3f40,x
            sta $0400,x
            lda $4040,x
            sta $0500,x
            lda $4140,x
            sta $0600,x
            lda $4240,x
            sta $0700,x
            inx
            bne -
            
            jmp *
            
            * = $2000
            !binary "grid.ocp",,2
