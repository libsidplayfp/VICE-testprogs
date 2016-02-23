; C128 REU Tests for Jens

*= $1C01 
	.word (+), 2005 ;pointer, line number
	.null $9e, ^start;will be sys 4096
+	.word 0	 ;basic line end
	
*= $1C10
start
; set up the MMU Prefconfigs
lda #%00001110
sta $D501 ; standard setup Bank 0
lda #%00111110
sta $d502 ; ALL RAM bar IO, Bank 0
lda #%01111110
sta $d503 ; ALL RAM bar IO, Bank 1
lda #%00000000
sta $d504 ; BASIC + KERANL + IO
sta $ff01 ; enable standard mode
lda $d506
and #%00111111
ora #%01000000
sta $d506 ; VIC BANK 1
lda #1
sta $d030 ; 2 MHZ Mode
; fill dummy data into 4000
ldx #00
- 
txa
sta $4000,x  ; 4000 = 00 01 02 03 04 05 06...FF
lda #0
sta $4100,x  ; 4100 = 00 00 00 00 00 00 00 
inx
bne -
; do a DMA transfer 128 -> REU
sei
lda #< $4000
sta $df02
lda #> $4000
sta $df03
lda #00
sta $df04
;lda #>reu
sta $df05
;lda #bank
sta $df06
sta $df08
sta $df0a
lda #255 ; we want to move 255 bytes
sta $df07
lda #176 ; do transfer
sta $df01
; copy exit code to $c000 so in shared ram
ldx # done-exit
-
lda exit,x
sta $c000,x
dex
bpl -
lda #%01001111 ; 16K shared RAM, both ends
sta $d506
sta $ff02 ; ALL RAM, Bank 0
jsr $c000 ; jump to the code below at the new location
sta $ff04 ; restore back to basic
rts
exit
; REU -> REU
sta $ff03 ; switch banks
lda #< $4100
sta $df02
lda #> $4100
sta $df03
lda #177 ; do transfer
sta $df01
sta $ff02 ; bank to bank 0
cli
lda $d506
and #%00111111
sta $d506 ; VIC BANK 0
lda #0
sta $d030 ; 1 MHZ Mode
rts
done

