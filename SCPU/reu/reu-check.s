; acme -Wno-label-indent -v3  reu-check.s

expansion_memory_target_pointer		= $5c ; to $5e
expansion_transfer_local_addr		= $f7 ; through $f9
stash_size							= $0c63 ; and 0c64

screen								= $0400
source_buf							= screen
target_buf							= source_buf + 8*40
readback_buf						= target_buf + 8*40

source_colors						= $d800
target_colors						= source_colors + 8*40
readback_colors						= target_colors + 8*40

SCPU_TURBO_ON						= $d07b

DMA_CMD								= $df01

DMA_ADL								= $df02		; local address
DMA_ADH								= $df03

DMA_LO								= $df04		; REU address
DMA_HI								= $df05
DMA_BANK							= $df06

DMA_DAL								= $df07		; transfer length
DMA_DAH								= $df08

CLR									= $93

CHROUT								= $ffd2

!cpu 6510
!to "reu-check.prg", cbm

* = $0801
	!word next
	!word 0
	!byte $9e
	!byte '2', '0', '6', '1'
	!byte 0
next:
	!word 0

run_test
	sta SCPU_TURBO_ON

	lda #CLR
	jsr CHROUT

	; init source buffer ($ff..$00)
	ldx #255
	ldy #0
	lda #0
-	txa
	sta source_buf,y
	dex
	iny
	bne -

	; init target buffer ($ff)
	ldy #0
	lda #255
-	sta target_buf,y
	iny
	bne -

	ldy #0
	lda #1
-	sta source_colors,y
	sta source_colors+$0100,y
	sta source_colors+$0200,y
	sta source_colors+$0300,y
	dey
	bne -

	; transfer source -> REU

	lda #<source_buf
	sta expansion_transfer_local_addr
	lda #>source_buf
	sta expansion_transfer_local_addr+1

	lda #12
	sta expansion_memory_target_pointer
	lda #34
	sta expansion_memory_target_pointer+1
	lda #56
	sta expansion_memory_target_pointer+2

	lda #0
	sta stash_size
	lda #1
	sta stash_size+1

	jsr reu_stash_block

	; transfer REU -> target

	lda #<target_buf
	sta expansion_transfer_local_addr
	lda #>target_buf
	sta expansion_transfer_local_addr+1

	jsr reu_fetch_block

	; copy target buffer to readback buffer, this fails
	; if the DMA only ended up in C64 RAM, ie the CPU can
	; not read the previously written values.
	ldy #0
-	lda target_buf,y
	sta readback_buf,y
	iny
	bne -

	ldy #0
-	lda source_buf,y
	cmp target_buf,y
	bne fail
	iny
	bne -

	lda #5
	sta $d020

	jsr waitframes

	lda #0
	sta $d7ff
-	jmp -

fail
	pha
	lsr
	lsr
	lsr
	lsr
	jsr to_hex
	sta screen+24*40
	pla
	jsr to_hex
	sta screen+24*40+1

	lda target_buf,y
	lsr
	lsr
	lsr
	lsr
	jsr to_hex
	sta screen+24*40+3
	lda target_buf,y
	jsr to_hex
	sta screen+24*40+4

	lda #2
	sta $d020
	lda #10
	sta source_colors,y
	sta target_colors,y
	sta readback_colors,y

	jsr waitframes

	lda #$ff
	sta $d7ff
-	jmp -

waitframes:
	jsr waitframe
	jsr waitframe
waitframe
-	bit $d011
	bpl -
-	bit $d011
	bmi -
	rts

reu_fetch_block
	lda expansion_transfer_local_addr
	sta DMA_ADL
	lda expansion_transfer_local_addr+1
	sta DMA_ADH

	lda expansion_memory_target_pointer
	sta DMA_LO
	lda expansion_memory_target_pointer+1
	sta DMA_HI
	lda expansion_memory_target_pointer+2
	sta DMA_BANK

	lda stash_size
	sta DMA_DAL
	lda stash_size+1
	sta DMA_DAH

	lda #$91

	sta DMA_CMD
rts

reu_stash_block
	lda expansion_transfer_local_addr
	sta DMA_ADL
	lda expansion_transfer_local_addr+1
	sta DMA_ADH

	lda expansion_memory_target_pointer
	sta DMA_LO
	lda expansion_memory_target_pointer+1
	sta DMA_HI
	lda expansion_memory_target_pointer+2
	sta DMA_BANK

	lda stash_size
	sta DMA_DAL
	lda stash_size+1
	sta DMA_DAH

	lda #$90

	sta DMA_CMD
rts

to_hex
	and #$0f
	cmp #10
	bcs +
	adc #$30
rts

+	sbc #9
rts

