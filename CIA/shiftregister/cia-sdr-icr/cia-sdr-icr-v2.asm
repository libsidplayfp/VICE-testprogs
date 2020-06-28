!if CIA = 1 {
CIABASE=$dc00
} else {
CIABASE=$dd00
}

;------------------------------------------------------------------------------

; ** THESE VALUES CAN BE ADJUSTED **
results = $0400
reference1 = $1000
reference2 = $1400
results2 = $2400
samples = 1000

;------------------------------------------------------------------------------

; ** OFFSETS FOR GENERATATION OF REFERENCE DATA**
offset1 = 29 
offset2 = 40

;------------------------------------------------------------------------------

      *=$0801             ; basic start
      !WORD +
      !WORD 10
      !BYTE $9E
      !TEXT "2061"
      !BYTE 0
+     !WORD 0

;------------------------------------------------------------------------------
    
    sei
    
    lda #0
    sta $d020
    sta $d021
    jsr init

   
    lda #$0b
    sta $d011    ; disable screen
    jsr waitframes
	
start	
    jsr reset
    lda CIABASE+$0e
    and #%10000000
    sta CIABASE+$0e    ; stop TA (keep 50Hz flag)
    lda #%00000000    
    sta CIABASE+$0f    ; stop TB
baud = * + 1	
    ldx #$08
    stx CIABASE+$04    ; TA low
    lda #$00
    sta CIABASE+$05    ; TA hi
    lda #%01111111
    sta CIABASE+$0d    ; disable interrupts
    jsr test
    jmp nextloop       ; Ignore first result

loop
	inc $d020
	jsr test
	dec $d020
	
    jsr storeresult1
    jsr storeresult2
nextloop	
	ldx delay+1
    dex
    stx delay+1
    cpx #$ff
    bne loop  
    inc delay256+1
    lda #>samples
    cmp delay256+1
    bcs loop
	jsr checkresult2
	jsr checkresult1
	
!if INTERACTIVEMODE	= 0 {
	lda #$7f  ;%01111111
    sta $dc00 
    lda $dc01 
    and #$10  ;mask %00010000 
	beq +
	
	lda baud	
	cmp #$7f  ; Maximum Timer A value program supports
	beq +
	lda status
	bne +
	inc $d020
	inc baud
	bne start
}
	
+	lda #$1b
    sta $d011    ; enable screen
	lda #$7f  ;%01111111
	sta $dc00 
status = * + 1	
	ldy #$00
    sty $d7ff  ; testbench result
    bne failed 
    lda #13       ; pass
    sta $d020
    jmp releasespace
    
failed:
    lda #10       ; fail
    sta $d020 
releasespace 
    lda $dc01 
    cmp #$ff 
    bne releasespace    
waitspace  
    lda $dc01 
    and #$10  ;mask %00010000 
    bne waitspace 
    lda $d018
    eor #$80
    sta $d018
    bpl show1
    jsr checkresult2
    jmp releasespace
show1
    jsr checkresult1
	jmp releasespace
	
test
	ldy CIABASE+$0d    ; clear ICR
    ldy #$55
    ; setup SDR
    lda #%01010001    ; TA started, force load, SDR output
    sta CIABASE+$0e
    sty CIABASE+$0c    ; send
    ldy CIABASE+$0d    ; clear ICR
delay    
    jsr clockslide
delay256
	ldx #0
    beq c1          ;2                    (  2)
    jsr clockslide+(255-(249-14)) ;249  (251)
    dex             ;2                    (253)
    jmp delay256+2  ;3                  (256)
c1    
    ldx CIABASE+$0d    ; clear ICR - lag of 14 + 5 +4
l1    

next
    lda CIABASE+$0e
    and #%10000000
    sta CIABASE+$0e    ; stop TA (keep 50Hz flag)    
    rts	
	
checkresult1
	jsr reset1
	lda #<results
    sta source+1
    lda #>results
    sta source+2
	lda #<check1
    sta checklp+1
    lda #>check1
    sta checklp+2
    jsr check
    rts	

checkresult2
	jsr reset2
	lda #<results2
    sta source+1
    lda #>results2
    sta source+2
	lda #<check2
    sta checklp+1
    lda #>check2
    sta checklp+2
    jsr check
    rts	
	
	
check
    ldx #$00
    stx col+1
    lda #$d8
    sta col+2
    ldx #<samples
    ldy #>samples 
checklp
    jsr check1
	jsr storeref
source   
    cmp $0400
    beq checkok
    lda #$ff
    sta status
    lda #10   ; fail
    jmp col
    
    
checkok
    lda #13   ; pass
col
    sta $d800
    dex
lobyte	
    bne nextcheck
    dey
    bpl nextcheck
    rts
nextcheck    
	inc source+1
	bne +
	inc source+2
	
+	inc col+1
	bne +
	inc col+2
+   jmp checklp

	
check1
    lda baud
	bne +
	lda #$01
	rts
+	dec count1
	bpl +
	lda baud	;max value of 127
	sta count1
newvalue = * + 1	
	lda #$01
	sta expected1
	dec bits
	bne +
	lda #$09
	sta newvalue
delaysetsdr1 = * + 1	
	lda #$03
	sta count1
expected1 = * +1
+	lda #$00
	rts
	
check2
    lda baud
	bne +
	lda #$09
	rts
	
+	dec count2
	bpl clearta
	lda baud
	sta count2
	lda expected2
	ora #$01
	sta expected2
	lda bits
	beq clearsdr
	dec bits
	lda bits
	bne +
sdrfinal = * + 1	
	lda #$14
	sta sdrpipe  ;bit 1 will always be false here so will branch to clearsdr here
+	and #1
	bne clearsdr
	lda clearsdrdelay
bouncesdr = * + 1	
	ora #$08
	sta clearsdrdelay
	lda delaysetsdr
sdrpipe = * + 1
	ora #$14
	sta delaysetsdr
	bne +
	
clearsdr
    lda clearsdrdelay
sdrdelayflag = * + 1 	
	ora #$02
	sta clearsdrdelay
	bne +
	
clearta
	lda expected2
clearmask = * + 1
	and #$fe
	sta expected2



clearsdrdelay = * + 1
+	lda #$00
	asl
	sta clearsdrdelay
	bcc +
	lda expected2
	and #$f7
	sta expected2

delaysetsdr = * + 1
+	lda #$00
	asl 
	sta delaysetsdr
	bcc +
	lda expected2
	ora #$08
	sta expected2

expected2 = * +1
+	lda #$00
	rts
	
storeref  
    sta reference1
    inc storeref+1
    bne endsref
    inc storeref+2
endsref
    rts
	
	
storeresult1  
    stx results
    inc storeresult1+1
    bne +
    inc storeresult1+2
+   rts
    
storeresult2  
    sty results2
    inc storeresult2+1
    bne +
    inc storeresult2+2
+   rts
	
init

	jsr initclockslide
!if CIATYPE = 0 {
    jsr set4485
} else {
	jsr setnormal
}
	
	lda #BAUDRATE
	sta baud
	lda #$00
	sta status
	rts

reset
	lda #$00
	sta delay256+1
	lda #255
    sta delay+1
    lda #<results
    sta storeresult1+1
    lda #>results
    sta storeresult1+2
    lda #<results2
    sta storeresult2+1
    lda #>results2
    sta storeresult2+2
	rts
	
reset1
	lda #$03
	ldx baud
	stx count1
	cpx #$03
	bcs +
	txa
	ora #$04
+	sta delaysetsdr1
	ldx #$00
	stx expected1
	inx
	stx newvalue
	lda #$0f
	sta bits
	ldx #offset1
-	jsr check1
	dex 
	bne -
	lda #<reference1
    sta storeref+1
    lda #>reference1
    sta storeref+2
	rts
	
reset2
	lda #$ff
	ldx baud
	stx count2
+	cpx #$06
	bcc +
	and #$fe
+	sta clearmask
	ldx #$00
	stx expected2
	stx clearsdrdelay
	stx delaysetsdr
	lda #$0f
	sta bits
	lda #$14
	sta sdrpipe
	ldx #offset2
	ldy baud
	cpy #$02
	bne applyoffset2
	dex		;HACK for Timer A = 2
	dex
	dex
applyoffset2
	jsr check2
	dex 
	bne applyoffset2
	lda #<reference2
    sta storeref+1
    lda #>reference2
    sta storeref+2
+	rts

setnormal
	lda #$04
	sta sdrfinal
	lda #$08
	sta bouncesdr
	rts

set4485
	lda #$08
	sta sdrfinal
	lda #$00
	sta bouncesdr
	rts
	
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
waitframes:
    jsr l3
l3  bit $d011
    bpl l3
l4    
    bit $d011
    bmi l4
    rts
	
count1 !byte 0
count2 !byte 0
bits   !byte 0

clockslide=(*+$ff)&$ff00        ; jsr clockslide+(255-x) = 14+x cycles  257 bytes total
