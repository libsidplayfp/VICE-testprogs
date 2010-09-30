
; --- Code

*=$0801
basic:
; BASIC stub: "1 SYS 2061"
!by $0b,$08,$01,$00,$9e,$32,$30,$36,$31,$00,$00,$00

start:
    jmp entrypoint

* = $0a00
entrypoint:
    sei
    lda #$7f
    sta $dc0d
    sta $dd0d
    lda #$00
    sta $dc0e
    sta $dc0f
    lda $dc0d
    lda $dd0d
    lda #$35
    sta $01
    lda #<irq_handler
    sta $fffe
    lda #>irq_handler
    sta $ffff
    lda #$1b
    sta $d011
    lda #$45
    sta $d012
    lda #$05
    sta $d01a
    sta $d019

	lda #$00
	sta $f5
	lda #<testtable
	sta $fe
	lda #>testtable
	sta $ff
	lda #$08
	sta $fd
	lda #$00
	sta screenptr+1
	sta colorptr+1
	
	lda #$03
	sta $d015
	lda #$f8
	sta $d000
	sta $d002
	lda #$49
	sta $d001
	sta $d003
	ldx #$40
	lda #$00
spritepatternloop:
    sta $3fc0,x
    dex
    bne spritepatternloop
    lda #$80
    sta $3fc0
    lda #$ff
    sta $07f8
    sta $07f9
    
    cli
entry_loop:
    jmp entry_loop

irq_handler:
    lda #<irq_handler_2
    sta $fffe
    lda #>irq_handler_2
    sta $ffff
    lda #$01
    sta $d019
    ldx $d012
    inx
    stx $d012
    cli
    ror $02
    ror $02
    ror $02
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    rti

irq_handler_2:
    lda #$01
    sta $d019
    ldx #$07
irq_handler_2_wait_1:
    dex
    bne irq_handler_2_wait_1
    nop
    nop
    lda $d012
    cmp $d012
    beq irq_handler_2_skip_1
irq_handler_2_skip_1:
    nop
    nop
    ldx #$04
irq_handler_2_wait_2:
    dex
    bne irq_handler_2_wait_2
    inc $d021
    dec $d021
	
	clc
	lda #$45
	sta $d012
	lda $d01e
	cli
    lda #<irq_handler_3
    sta $fffe
    lda #>irq_handler_3
    sta $ffff

	ldy #$01
    lda ($fe),y
	bne noend:
	jmp referenceoutput
noend:
    sta $c000
	iny
    lda ($fe),y
    sta $c001
	
	lda #'-'
	sta $fb
	ldy #$00

	lda #$18
	jsr delay

	lda ($fe),y
	clc
	adc $fd
	jsr delay
	jmp ($c000)

irq_handler_3:
	lda #'*'
	sta $fb	
	lda #$04
    sta $d019
    rti
	
irq_ack_test1:
    lda #$04
    sta $d019
	jmp irq_reset_frame

irq_ack_test2:
    inc $d019
	jmp irq_reset_frame

irq_ack_test3:
    asl $d019
	jmp irq_reset_frame
	
irq_reset_frame:
    lda $d01e
    lda #$05
	sta $d019
    lda $fb
    ldy $fd
screenptr:
	sta $0400,y
	lda #$01
colorptr:
	sta $d800,y

    lda #<irq_handler
    sta $fffe
    lda #>irq_handler
    sta $ffff

	dec $fd
	bne same_test
	lda #$08
	sta $fd
	clc
	lda $fe
	adc #$03
	sta $fe
	clc
	lda screenptr+1
	adc #$0a
	sta screenptr+1
	lda colorptr+1
	adc #$0a
	sta colorptr+1
same_test
    rti
	
end_of_tests
	jmp end_of_tests
	
* = $0900
testtable:
	!by $2b, <irq_ack_test1, >irq_ack_test1
	!by $2b, <irq_ack_test2, >irq_ack_test2
	!by $2b, <irq_ack_test3, >irq_ack_test3
	
	!by $00, $00, $00

reference:
    !scr " ****-***  ****-***  ********"
	!by $00

referenceoutput:
	sei
    ldy #$00
	ldx #$00
refloop:
    lda reference,y
	bne toscreen
	jmp end_of_tests
toscreen:
    sta $0428,x
    lda #$01
    sta $d828,x
    iny
    inx
    jmp refloop

  
* = $0850
delay:              ;delay 80-accu cycles, 0<=accu<=64
    lsr             ;2 cycles akku=akku/2 carry=1 if accu was odd, 0 otherwise
    bcc waste1cycle ;2/3 cycles, depending on lowest bit, same operation for both
waste1cycle:
    sta smod+1      ;4 cycles selfmodifies the argument of branch
    clc             ;2 cycles
;now we have burned 10/11 cycles.. and jumping into a nopfield 
smod:
    bcc *+10
!by $EA,$EA,$EA,$EA,$EA,$EA,$EA,$EA
!by $EA,$EA,$EA,$EA,$EA,$EA,$EA,$EA
!by $EA,$EA,$EA,$EA,$EA,$EA,$EA,$EA
!by $EA,$EA,$EA,$EA,$EA,$EA,$EA,$EA
    rts             ;6 cycles
