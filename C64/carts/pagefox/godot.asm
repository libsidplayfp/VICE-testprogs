
pf_bank = $a0

destptr_lo = $ae
destptr_hi = $af

ROMSTART = $8000

    * = ROMSTART

    !word start
    !word start
    !byte $c3, $c2, $cd, $38, $30

start:
    sei
    lda #$1b
    sta $d011
    lda #$17
    sta $d018
    lda #$c8
    sta $d016
    lda #0
    sta $d020
    sta $d021

    lda #$e7
    sta $01
    lda #$2f
    sta $00
    
    ldx #$ff
    txs

    ldx #0
lp:
    lda code,x
    sta $1000,x
    lda code+$100,x
    sta $1100,x
    lda #1
    sta $d800,x
    lda #2
    sta $d900,x
    lda #3
    sta $da00,x
    lda #4
    sta $db00,x
    lda #$20
    sta $0400,x
    sta $0500,x
    sta $0600,x
    sta $0700,x
    inx
    bne lp
    jmp $1000

;-------------------------------------------------------------------------------
code:
            !pseudopc $1000 {
                lda #$08
                sta	pf_bank
                lda #$80
                sta destptr_hi
                lda #$00
                sta destptr_lo

                LDA     #$FF            ; disable cartridge
                STA     $DE80
                LDX     #$34            ; all RAM
                STX     1

                ; put pattern to C64 RAM
                ldx #0
-
                txa
                sta $8000,x
                eor #$ff
                sta $a000,x
                inx
                bne -

                lda #$08
                sta	pf_bank
                lda #$80
                sta destptr_hi
                lda #$00
                sta destptr_lo

                ; put pattern to pagefox RAM
                ldx #0
-
                txa
                eor #%01010101
                jsr sub_C23F
                inx
                bne -

                lda #$0a
                sta	pf_bank
                lda #$a0
                sta destptr_hi
                lda #$00
                sta destptr_lo

                ; put pattern to pagefox RAM
                ldx #0
-
                txa
                eor #%10101010
                jsr sub_C23F
                inx
                bne -

                ldy #10

                LDA     #$FF            ; disable cartridge
                STA     $DE80
                LDX     #$34            ; all RAM
                STX     1

                ; check pattern in C64 RAM
                ldx #0
-
                txa
                cmp $8000,x
                sta $0400,x
                cmp $a000,x
                sta $0500,x
                cmp $8000,x
                bne doneerror
                eor #$ff
                cmp $a000,x
                bne doneerror
                inx
                bne -

                LDX     #$37
                STX     1
                LDA     #$08            ; ensable cartridge
                STA     $DE80

                ; check pattern in cart RAM
                ldx #0
-
                lda $8000,x
                sta $0600,x
                txa
                eor #%01010101
                cmp $8000,x
                bne doneerror
                inx
                bne -

                LDA     #$0a            ; ensable cartridge
                STA     $DE80

                ldx #0
-
                lda $a000,x
                sta $0700,x
                txa
                eor #%10101010
                cmp $a000,x
                bne doneerror
                inx
                bne -

                ldy #5
doneerror:
                lda #$35
                sta $01

                sty $d020

                lda #0      ; success
                cpy #5
                beq nofail
                lda #$ff    ; failure
nofail:
                sta $d7ff

done
                jmp *
                
                
;-------------------------------------------------------------------------------
; code from the godot "4bit2pagefox" module
                
sub_C23F:
                STX     $B0
                STY     $B1

                LDX     #$34            ; all RAM
                STX     1

                LDY     #0
                TAX                     ; save A

                LDA     (destptr_lo),Y  ; read from RAM, save value
                PHA

                INC     1               ; enable ROM

                LDA     pf_bank         ; enable cartridge+set bank
                STA     $DE80

                TXA                     ; restore A
                STA     (destptr_lo),Y  ; write into cartridge RAM

                LDA     #$FF            ; disable cartridge
                STA     $DE80

                DEC     1               ; all RAM

                PLA                     ; restore value in RAM
                STA     (destptr_lo),Y

                INC     destptr_lo      ; increment pointer
                BNE     +
                INC     destptr_hi
+
                LDA     destptr_hi
                CMP     #$BE
                BCC     +
                LDA     destptr_lo
                CMP     #$80
                BCC     +

                LDA     pf_bank
                CMP     #$A
                BEQ     +

                LDA     #$A
                STA     pf_bank

                LDA     #$80            ; set pointer to $8000
                STA     destptr_hi
                ASL                     ; A = 0
                STA     destptr_lo
+
                LDA     #$36            ; enable kernal ROM
                STA     1

                LDX     $B0
                LDY     $B1
                RTS

}
