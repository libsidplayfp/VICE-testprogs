      *=$0801             ; basic start
      !WORD +
      !WORD 10
      !BYTE $9E
      !TEXT "2061"
      !BYTE 0
+     !WORD 0
results = $0400
results2 = $2400
tottests = 1000-1
	lda #$93
	jsr $ffd2

l3  bit $d011
	bpl l3
l4	bit $d011
	bmi l4
	jsr initclockslide
	lda #<tottests
	sta dl+1
	lda #<results
	sta sr+1
	lda #>results
	sta sr+2
	lda #<results2
	sta sr2+1
	lda #>results2
	sta sr2+2
	lda #>tottests
	sta testflag
	lda #$00
	sta status
	lda #0
	sta delay256+1
	
	lda $d011
	and #%11101111
	sta $d011	; disable screen
	
l5	bit $d011
	bpl l5
l6	bit $d011
	bmi l6

	lda $dd0e
	and #%10000000
	sta $dd0e	; stop TA (keep 50Hz flag)
	lda #%00000000	
	sta $dd0f	; stop TB
	lda #<64
	sta $dd04	; TA low
	lda #>64
	sta $dd05	; TA hi
loop
	sei

	; setup ICR and CRx
	lda #%0111111
	sta $dd0d	; disable interrupts
	
	
	ldy $dd0d	; clear ICR
	ldy #$55
	; setup SDR
	lda #%01010001	; TA started, force load, SDR output
	sta $dd0e
	sty $dd0c	; send
	ldy $dd0d	; clear ICR
dl	jsr clockslide
delay256
    ldx #0
    beq c1          ;2            		(  2)
	jsr clockslide+(255-(249-14)) ;249  (251)
    dex             ;2            		(253)
    jmp delay256+2  ;3          		(256)
c1	lda $dd0d

	jsr sr
	jsr sr2
l1	and #8
	beq next
	lda $dd0d
	jmp l1
next
	lda $dd0e
	and #%10000000
	sta $dd0e	; stop TA (keep 50Hz flag)	
	cli
	ldx dl+1
	dex
	stx dl+1
	cpx #$ff
	bne loop
	inc delay256+1
	lda #>tottests
	cmp delay256+1
	bcs loop

	lda $d011
	ora #%00010000
	sta $d011	; enable screen
	
	jsr checkresults
	ldy status
	sty $d7ff  ; testbench result
	bne failed 
    lda #13	   ; pass
    sta $d020
	jmp waitspace
	
failed:
    lda #10	   ; fail
    sta $d020 
	
waitspace  
	lda #$7F  ;%01111111
	sta $dc00 
    lda $dc01 
    and #$10  ;mask %00010000 
    bne waitspace 
	lda $d018
	eor #$80
	sta $d018
	bpl show1
	jsr check2
	jmp releasespace
show1
	jsr check1
releasespace 
    lda $dc01 
    cmp #$FF 
    bne releasespace 
    jmp waitspace 

sr  
	sta results
	inc sr+1
	bne endsr
	inc sr+2
endsr
	rts
	
sr2  
	sty results2
	inc sr2+1
	bne endsr2
	inc sr2+2
endsr2
	rts

checkresults
	jsr check2
	jsr check1
	rts
check1
	lda #$10
	clc
	adc #>tottests
	sta checklp+2
	lda #$04
	clc
	adc #>tottests
	sta checklp+5
	jsr check
	rts
check2	
	lda #$14
	clc
	adc #>tottests
	sta checklp+2
	lda #$24
	clc
	adc #>tottests
	sta checklp+5
	jsr check
	rts
check
	ldx #$00
	stx checklp+1
	stx checklp+4
	stx col+1
	lda #$d8
	clc
	adc #>tottests
	sta col+2
	ldx #<tottests
	ldy #>tottests	
checklp
    lda $1000,x
    cmp $0400,x
    beq checkok
    lda #$ff
	sta status
	lda #$02
	jmp col
	
	
checkok
    lda #$07
col
	sta $d800,x
    dex
	cpx #$ff
	bne checklp
	dey
	bpl nextcheck
	rts
nextcheck	
	dec checklp+2
	dec checklp+5
	dec col+2
	jmp checklp
	
	
	* = (*+$ff)&$ff00 

status !byte 0
testflag !byte 1

initclockslide
         lda #$c9
         ldx #0
         sta clockslide,x
         inx
         bne *-4
         lda #$c5
         ldx #$ea
         ldy #$60
         sta clockslide+254
         stx clockslide+255
         sty clockslide+256
         rts

clockslide=(*+$ff)&$ff00        ; jsr clockslide+(255-x) = 14+x cycles  257 bytes total
!word $fce6,$fce7,$fce8,$fce9,$fcea,$fce4,$fce5
*=$1000
!bin "cia-sdr-icr-dump1.bin"
*=$1400
!if NEWCIA = 1{
	!bin "cia-sdr-icr-new-dump2.bin"
}else {
	!bin "cia-sdr-icr-old-dump2.bin"
}
endif
