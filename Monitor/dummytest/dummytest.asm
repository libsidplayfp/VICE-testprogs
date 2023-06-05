pages   = $20fe
zpFE    = $fe

DEFAULT_X = $10
DEFAULT_Y = $20

;-------------------------------------------------------------------------------

; Mode: Relative -- r  (2 bytes)  (2,3 and 4 cycles)
; (BCC,BCS,BEQ,BMI,BNE,BPL,BVC,BVS)

; +1 cycle if branch is taken;               dummy read from PC+2
; +1 cylce if branch crosses page boundary;  dummy read from PC+2+OFF

        * = $1f00-5
branchtest:
        sec
        bcs +
        nop
        nop
        nop
+
        nop
        rts
        nop

irqhandler:
        nop
        lda $dc0d
        nop
        rti
        nop
        
        * = $0ffd
tracestart:
        rts
        
;----------------------------------------
        * = $1000
        
        lda #$7f
        sta $dc0d
        sta $dd0d
        
        lda #$00
        sta $d01a
        
        nop
        
        sei
        lda #$35
        sta $01

        lda #$0b    ; disable the screen/badlines
        sta $d011
                    
        ldx #3      ; wait for at least one frame so its actually off
--        
-       bit $d011
        bpl -
-       bit $d011
        bmi -
        dex
        bne --
        
        lda #<irqhandler
        sta $fffe
        lda #>irqhandler
        sta $ffff
         
        ldx #0      ; init stack with known values
-
        txa
        sta $0100,x
        inx
        bne -
        
        ldx #$ff
        txs
        
        lda #>pages
        sta zpFE+1
        sta <(zpFE+$10+1)
        lda #<pages
        sta zpFE
        sta <(zpFE+$10)
        
        ldx #DEFAULT_X
        ldy #DEFAULT_Y
        
        jsr tracestart
        
;----------------------------------------

        jsr branchtest
        
; Mode: Absolute Indexed -- a,x  a,y (3 bytes)  (4 and 5)
; (ADC,AND,BIT,CMP,EOR,LDA,LDX,LDY,NOP,ORA,SBC,STA, LAS,LAX,SHA,SHS,SHX,SHY)

; dummy read access to the target address - 0x100 (before the high byte was corrected)

; abs,x
; 200f  dummy
; 210f  

; abs,y
; 201f  dummy
; 211f

        adc pages, x
        nop

        and pages, x
        nop

        ;bit pages, x
        ;nop

        cmp pages, x
        nop

        lda pages, x
        nop
        
        ;ldx pages, x
        ;nop
        
        ldy pages, x
        nop
        ldy #DEFAULT_Y
        nop
        
        !byte $3c, <pages, >pages   ;nop pages, x
        nop
        
        ora pages, x
        nop
        
        sbc pages, x
        nop
        
        sta pages, x
        nop
        
        ;---

        ;las pages, x
        ;nop

        ;lax pages, x
        ;nop

        ;sha pages, x
        ;nop

        ;shs pages, x
        ;nop

        ;shx pages, x
        ;nop

        shy pages, x
        nop
        
        ;----

        adc pages, y
        nop

        and pages, y
        nop

        ;bit pages, y
        ;nop

        cmp pages, y
        nop

        lda pages, y
        nop
        
        ldx pages, y
        nop
        ldx #DEFAULT_X
        nop
        
        ;ldy pages, y
        ;nop
        
        ;nop pages, y
        ;nop
        
        ora pages, y
        nop
        
        sbc pages, y
        nop
        
        sta pages, y
        nop
        
        ;---

        las pages, y
        nop
        ldx #DEFAULT_X
        nop

        lax pages, y
        nop
        ldx #DEFAULT_X
        nop

        sha pages, y
        nop

        ;shs pages, y
        ;nop

        shx pages, y
        nop

        ;shy pages, y
        ;nop

        
; Mode: Zeropage/Direct Indirect Indexed -- (d),y  (2 bytes)  (5 and 6 cycles)
; (ADC,AND,CMP,EOR,LAX,LDA,ORA,SBC,STA)
        
; dummy read from target address before high byte is incremented

; fe (<pages)
; ff (>pages)
; 20fe+20=201e dummy
; 20fe+20=211e

        adc (zpFE), y
        nop
        
        and (zpFE), y
        nop
        
        cmp (zpFE), y
        nop
        
        eor (zpFE), y
        nop
        
        lax (zpFE), y
        nop
        ldx #DEFAULT_X
        nop
        
        lda (zpFE), y
        nop
        
        ora (zpFE), y
        nop
        
        sbc (zpFE), y
        nop
        
        sta (zpFE), y
        nop
        
; Mode: Zeropage/Direct Indexed -- d,x  d,y  (2 bytes)  (4 cycles)
; (ADC,AND,BIT,CMP,EOR,LAX,LDA,LDX,LDY,NOP,ORA,SAX,SBC,STA,STX,STY)
        
; dummy-fetch from direct offset
        
        adc <zpFE, x
        nop

        and <zpFE, x
        nop

        ;bit <zpFE, x
        ;nop

        cmp <zpFE, x
        nop

        eor <zpFE, x
        nop

        ;lax <zpFE, x
        ;nop

        lda <zpFE, x
        nop

        ;ldx <zpFE, x
        ;nop

        ldy <zpFE, x
        nop
        ldy #DEFAULT_Y
        nop

        !byte $14, <zpFE    ;nop <zpFE, x
        nop

        ora <zpFE, x
        nop

        ;sax <zpFE, x
        ;nop

        sbc <zpFE, x
        nop

        sta <zpFE, x
        nop

        ;stx <zpFE, x
        ;nop

        sty <zpFE, x
        nop

        ;----
        
        ;adc <zpFE, y
        ;nop

        ;and <zpFE, y
        ;nop

        ;bit <zpFE, y
        ;nop

        ;cmp <zpFE, y
        ;nop

        ;eor <zpFE, y
        ;nop

        lax <zpFE, y
        nop
        ldx #DEFAULT_X
        nop

        ;lda <zpFE, y
        ;nop

        ldx <zpFE, y
        nop
        ldx #DEFAULT_X
        nop

        ;ldy <zpFE, y
        ;nop

        ;nop <zpFE, y
        ;nop

        ;ora <zpFE, y
        ;nop

        sax <zpFE, y
        nop

        ;sbc <zpFE, y
        ;nop

        ;sta <zpFE, y
        ;nop

        stx <zpFE, y
        nop

        ;sty <zpFE, y
        ;nop
        
  
; Mode: Zeropage/Direct Indexed Indirect -- (d,x)  (2 bytes)  (6 cycles)
; (ADC,AND,CMP,EOR,LAX,LDA,ORA,SAX,SBC,STA)

; dummy-fetch from direct offset

        adc (zpFE, x)
        nop
  
        and (zpFE, x)
        nop
  
        cmp (zpFE, x)
        nop
  
        eor (zpFE, x)
        nop
  
        lax (zpFE, x)
        nop
        ldx #DEFAULT_X
        nop

        lda (zpFE, x)
        nop
  
        ora (zpFE, x)
        nop
  
        sax (zpFE, x)
        nop
  
        sbc (zpFE, x)
        nop
  
        sta (zpFE, x)
        nop
  
; Mode: Absolute (JSR) -- a (3 bytes)  (6 cycles)
; (JSR)

; dummy fetch from stack
        jsr subfunc
        nop
  
; Mode: Stack (Pull) -- s  (1 byte)  (4 cycles)
; (PLA,PLP)
  
; dummy fetch from PC+1
; dummy fetch from stack
  
;        php
;        nop
;        pha
;        nop
  
        pla
        nop
        plp
        nop
  
; Mode: Absolute (R-M-W) -- a (3 bytes)  (6 and 8 cycles)
; (ASL,DCP,DEC,INC,ISC,LSR,RLA,ROL,ROR,RRA,SLO,SRE)
  
; dummy write with original value
        
        inc pages
        nop

        dcp pages
        nop

        dec pages
        nop

        inc pages
        nop

        isc pages
        nop

        lsr pages
        nop

        rla pages
        nop

        rol pages
        nop

        ror pages
        nop

        rra pages
        nop

        slo pages
        nop

        sre pages
        nop

; Mode: Zeropage/Direct (R-M-W) -- d  (2 bytes)  (5 cycles)
; (ASL,DCP,DEC,INC,ISC,LSR,RLA,ROL,ROR,RRA,SLO,SRE)
        
; dummy write with original value

        asl $02
        nop

        dcp $02
        nop

        dec $02
        nop

        inc $02
        nop

        isc $02
        nop

        lsr $02
        nop

        rla $02
        nop

        rol $02
        nop

        ror $02
        nop

        rra $02
        nop

        slo $02
        nop

        sre $02
        nop

; Mode: Absolute Indexed (R-M-W) -- a,x  (3 bytes)  (7 cycles)
; (ASL,DCP,DEC,INC,ISC,LSR,RLA,ROL,ROR,RRA,SLO,SRE)
 
; dummy fetch from page with old highbyte
; dummy write with original value
 
        asl pages, x
        nop

        dcp pages, x
        nop

        dec pages, x
        nop

        inc pages, x
        nop

        isc pages, x
        nop

        lsr pages, x
        nop

        rla pages, x
        nop

        rol pages, x
        nop

        ror pages, x
        nop

        rra pages, x
        nop

        slo pages, x
        nop

        sre pages, x
        nop

; Illegal Mode: Absolute Indexed (R-M-W) -- a,y (3 bytes)  (7 cycles)

; dummy fetch from page with old highbyte
; dummy write with original value

        ;asl pages, y
        ;nop

        dcp pages, y
        nop

        ;dec pages, y
        ;nop

        ;inc pages, y
        ;nop

        isc pages, y
        nop

        ;lsr pages, y
        ;nop

        rla pages, y
        nop

        ;rol pages, y
        ;nop

        ;ror pages, y
        ;nop

        rra pages, y
        nop

        slo pages, y
        nop

        sre pages, y
        nop
        
; Mode: Zeropage/Direct Indexed (R-M-W) -- d,x  (2 bytes)  (6 cycles)
; (ASL,DCP,DEC,INC,ISC,LSR,RLA,ROL,ROR,RRA,SLO,SRE)

; dummy fetch before x was added
; dummy write with original value

        asl zpFE,x
        nop
        
        dcp zpFE,x
        nop
        
        dec zpFE,x
        nop
        
        inc zpFE,x
        nop
        
        isc zpFE,x
        nop
        
        lsr zpFE,x
        nop
        
        rla zpFE,x
        nop
        
        rol zpFE,x
        nop
        
        ror zpFE,x
        nop
        
        rra zpFE,x
        nop
        
        slo zpFE,x
        nop
        
        sre zpFE,x
        nop
        
; Illegal Mode: Direct Indexed Indirect (R-M-W) -- (d),y  (2 bytes)  (7  and 8 cycles)
; (DCP,ISC,RLA,RRA,SLO,SRE)
  
; dummy read from target address before high byte is incremented
; dummy write with original value
  
        dcp (zpFE),y
        nop
        
        isc (zpFE),y
        nop
        
        rla (zpFE),y
        nop
        
        rra (zpFE),y
        nop
        
        slo (zpFE),y
        nop
        
        sre (zpFE),y
        nop
        
; Illegal Mode: Direct Indexed Indirect (R-M-W) -- (d,x)  (2 bytes)  (8 cycles)
; (DCP,ISC,RLA,RRA,SLO,SRE)        
  
; dummy read from direct offset
; dummy write with original value
  
        sre (zpFE, x)
        nop
  
        isc (zpFE, x)
        nop
  
        rla (zpFE, x)
        nop
  
        rra (zpFE, x)
        nop
  
        slo (zpFE, x)
        nop
  
        sre (zpFE, x)
        nop
  
; Mode: Stack (Software Interrupts) -- s  (2 bytes)  (7 cycles)
; (BRK)
  
; dummy fetch after opcode
  
        cli
        nop
        brk
        nop
        nop
        nop
        sei
        nop
        
; Mode: Stack (Hardware Interrupts) -- s  (0 bytes)  (6 cycles)
; (IRQ,NMI)
  
; dummy fetch from PC
        lda #$08 ; stop
        sta $dc0e
        lda #$81
        sta $dc0d
        lda $dc0d
  
        lda #>$0004
        sta $dc05
        lda #<$0004
        sta $dc04
        lda #$19 ; start, one-shot
        sta $dc0e
        cli
  
        nop
        nop

        sei
        lda #$08 ; stop
        sta $dc0e
        lda #$7f
        sta $dc0d
        
;----------------------------------------
  
        lda #0
        sta $d7ff
        jmp *

;-------------------------------------------------------------------------------  
 
; Mode: Stack (RTS) -- s  (1 byte)  (6 cycles)
; (RTS)

; dummy fetch from PC+1
; dummy read from stack
; dummy read from target address (NewPC-1)

subfunc:
        nop
        rts
