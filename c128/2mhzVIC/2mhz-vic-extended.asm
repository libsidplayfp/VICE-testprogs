;-----------------------------------------------------------------
;
; This test creates a  gfx  in the fastmode of the C128 with the VIC
; while the the Extended Color Mode is enable.
;
; It seems like the registers $D022 and $D023  are not uesed in 
; the Extended Color Mode when fastmode is enable.
; 
; The color can be set with $D024
;
;
; Look at the screenshot (rab-extendedcolor.png)
;
;
; done by Bodo^Rabenauge
;  
; email bodo.hinueber@rabenauge.com 
;
; 	
;-----------------------------------------------------------------


!macro loadReg {
	pla ;   load aku, x, y to stackpla 
	tay
	pla 
	tax	
	pla 
}

!macro saveReg {
	pha	;  save aku, x, y to stack 
	txa
	pha
	tya
	pha	
}


start=$2400
basicHeader=1
;------------------------------------------------------------------


!ifdef basicHeader {
; 10 SYS7181
*=$1c01  
	!byte  $0c,$08,$0a,$00,$9e,$37,$31,$38,$31,$00,$00,$00
*=$1c0d 
	jmp start
}
*=start
	
	jsr	$ff7d; PRIMM
	!byte 147  ; clearscreen
	!byte 145  ; textcolor green
	!byte 13
	!tx "  IF YOU CAN SEE THIS SCREEN,           "
	!tx "  SOMETHING IS WRONG!                   "
	!byte 13,13
	!tx "  ON A REAL C128 HERE SHOULD BE A GFX!  "
	!byte 0 ; end of text


;------------------------------------------------------------------------
	sei
	lda #%00110011 ; disable basic
	sta $01
	
; switch to bank 0  / turn ROM off / IO on
;	     %76543210
	lda #%00111110
	sta $ff00

; init VIC-registers

	lda #0
	stA $d020 ; frame color black

	lda #0
	sta $d021  ; bg color black

	lda #8
	sta $D016  ; multicolor off

    lda $d011
    ora #64
    and #%01111111
    sta $d011

	
;  The Extended Color Mode uses this register in the fastmode
	lda #6 ; blue 
	sta $D024
	
;--------------------------------------------------
;  New IRQ to Raster
;--------------------------------------------------
	lda #%01111111 ; disable dhTimer irq
	sta $dc0d	
	lda $dc0d		; acknowledge irq

    lda #<irq     ; init the irq
    ldx #>irq
    sta $fffe
    stx $ffff
    
    lda #48 ;	; line 
    sta $d012
    
    lda $d011
    and #%01111111
    sta $d011
    
    lda #01
    sta $d019	; raster-irq
    sta $d01a	; irq-mask
	       
	cli

	jmp *
;--------------------------------------------------
;  start of the irq-routine
;--------------------------------------------------
!align 255, 0	
irq:
	+saveReg

    lda #<DoubleIRQ
    sta $fffe
    lda #>DoubleIRQ
    sta $ffff

    ; Set the Raster IRQ to trigger on the next Raster line
    inc $d012

    ; Acknowlege current Raster IRQ
    lda #$01   
    sta $d019  

    tsx

    cli

    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
	
;---------------------------------------------------------
DoubleIRQ:
	txs        
    ldx #$08   
    dex        
    bne *-1    
    bit $00    

    lda $d012
    cmp $d012

    beq *+2
    
;---------------------------
;  stable code

; use nops for the timing as always on a C128  ;)
	!for in,1,27 { 
		nop
	}	

	lda #$01
	sta $d030 ; enable 2MHz mode
	!for x,1,5 {   
		nop
	}	
	nop ; try a 3 cycle opcode and you will see chaos on the screen ;)

; here is the code which creates the gfx on the screen
;	!src  "multicolor-test.asm"
	!src  "hires-test.asm"

	lda #$00
	sta $d030 ; disable 2MHz mode

	lda $d019 ; acknowledge irq
	sta $d019

    lda #<irq  ; init the irq
    ldx #>irq
    sta $fffe
    stx $ffff
    
    lda $d011
    and #%01111111
    sta $d011
    
    lda #48  	; line
    sta $d012
	+loadReg

	rti
