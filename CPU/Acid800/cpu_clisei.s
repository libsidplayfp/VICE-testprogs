; Altirra Acid800 test suite
; Copyright (C) 2010 Avery Lee, All Rights Reserved.
;
; Permission is hereby granted, free of charge, to any person obtaining a copy
; of this software and associated documentation files (the "Software"), to deal
; in the Software without restriction, including without limitation the rights
; to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
; copies of the Software, and to permit persons to whom the Software is
; furnished to do so, subject to the following conditions:
;
; The above copyright notice and this permission notice shall be included in
; all copies or substantial portions of the Software.
;
; THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
; IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
; FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
; AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
; LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
; OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
; SOFTWARE. 

                !src "common.s"

                * =             $2000

main:
		ldy		#>testname
		lda		#<testname
		jsr		_testInit
		
		jsr		_screenOff
		jsr		_interruptsOff

		;enable SEROC IRQ only
		;mwa		#irq vimirq
                lda #<irq
                sta $fffe
                lda #>irq
                sta $ffff
		;mva		#$08 irqen
		;lda #$08
		;sta irqen
		
		;check that SEROC is responding... otherwise we have to skip this test
		;bit		irqst
		beq		seroc_ok
		
		+_SKIP	1
		;c"Serial output complete IRQ not responding."
		
seroc_ok:
		;do a CLI and check that we execute an extra insn
		ldx		#$ff
		stx		d0
		inx
		cli
		inx
		inx
		inx
		sei
		
		+_ASSERT1 d0, $01, 2
		;c"CPU did not execute 1 insn after CLI: $%x != $01"
		
		;do a CLI/SEI pair and check that we successfully interrupt with
		;I set (!)
		
		;mva		#$08 irqen
                ;lda #$08
                ;sta irqen

		ldx		#$ff
		stx		d0
		stx		d1
		inx
		cli
		sei
		inx
		inx
		inx
		
		+_ASSERT1 d0, $00, 3
		;c"CPU did not interrupt within in CLI/SEI pair"
		
		lda		d1
		and		#$04
		+_ASSERTA $04, 4
		;c"I flag was not set on stack after CLI/SEI/IRQ"
		
		;do a RTI/SEI pair and check that the interrupt happens between the
		;instructions
		
		;mva		#$08 irqen
		;lda#$08
		;sta irqen

		ldx		#$ff
		stx		d0
		stx		d1
		inx
		
		lda		#>next
		pha
		lda		#<next
		pha
		lda		#$20
		pha
		rti
next:
		sei
		inx
		inx
		inx
		
		+_ASSERT1 d0, $00, 5
		;c"CPU did not interrupt between RTI/SEI pair"
		
		lda		d1
		and		#$04
		+_ASSERTA $00, 6
		;c"I flag was set on stack after RTI/SEI"

		jmp		_testPassed
		
;==========================================================================
irq:
		pha
		txa
		pha
		
		stx		d0
		;mva		#0 irqen
		;lda #0
		;sta irqen
		
		tsx
		;mva		$0103,x d1
		;mwa		$0104,x d2
                lda $0103,x
                sta d1
                lda $0104,x
                sta d2
                lda $0105,x
                sta d3

		pla
		tax
		pla
		rti

		
;==========================================================================
testname:
		!scr "CPU: CLI/SEI timing",0
