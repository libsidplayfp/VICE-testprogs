;------------------------------------------------------------------------------
;
; This test creates a gfx in the fastmode of the C128 with the VIC
;
; In the upper half of the screen is another timing behavior than in the lower 
; half, because in in upper half is an inc $c000 in each line which needs 6 cycles.
; In the lower half is an inc $d020 in each line which needs 6 cycles 
; + 2 cycles more = 8 cycles, because $d020 is an IO-register.
;
; Look at timing-change0.a ! 
;
;
; Look at the screenshot.
;
;
; done by Bodo^Rabenauge
;  
; email bodo.hinueber@rabenauge.com 
;
; 	
;------------------------------------------------------------------------------


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
	!byte 144  ; textcolor black
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
	stA $d020 ; border color black

	lda #1
	stA $d021  ; bg color white

	lda #8
	sta $D016  ; multicolor off
	
;--------------------------------------------------
;  New IRQ to Raster
;--------------------------------------------------
	lda #%01111111 ; disable timer irq
	sta $dc0d	
	lda $dc0d		; acknowledge irq

    lda #<irq     ; init the irq
    sta $fffe
    lda #>irq
    sta $ffff
    
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


; here is the code which creates the upper half of the screen
!for lo,1,100 {
	nop	
	nop 
	nop	
	nop
	bit $ea
	inc $c000  
	; creates the gfx-pattern
	!for x,1,37 {
		cmp #%01010101  ;   
	}

	!for i,1,15 {
		nop   ; wait 30 cycles
	}
}


; here is the code which creates the lower half of the screen
!for lo,1,100 {
	nop	
	nop 
	nop	
	nop
	bit $ea
	inc $d020	; 8 (!) cycles because io
	; creates the gfx-pattern
	!for x,1,36 {
		cmp #%01010101  ;   
	}
	!for i,1,15 {
		nop   ; wait 30 cycles
	}
}




	lda #$00
	sta $d030 ; disable 2MHz mode

	sta $d020 ; black is beautiful ;)

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
