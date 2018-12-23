
zptmp = $02


videoram = $0400
colorram = $d800

result_akku = $0500
result_flags = $0600
result_mem = $0700

        !cpu 6510
        
;-------------------------------------------------------------------------------
        * = $0801
        !word bend
        !word 10
        !byte $9e
        !text "2061", 0
bend:   !word 0
;-------------------------------------------------------------------------------

        sei
        lda #$17
        sta $d018
        lda #$35
        sta $01

        ldx #0
-
        lda #$20
        sta videoram,x
        sta videoram+$0100,x
        sta videoram+$0200,x
        sta videoram+$0300,x
        lda #1
        sta colorram,x
        sta colorram+$0200,x
        lda #15
        sta colorram+$0100,x
        sta colorram+$0300,x
        inx
        bne -

        jmp main

;-------------------------------------------------------------------------------

testpage_adc:


        sed

        ldx #0
-
        
        txa     ; A = x

testpage_adc_clc = *
        clc
testpage_adc_imm = * + 1
!if INSTR=0 {   ; adc
        adc #0
}
!if INSTR=1 {   ; sbc
        sbc #0
}
!if INSTR=2 {   ; arr
        arr #0
}
!if INSTR=3 {   ; sbc eb
        !byte $eb
        !byte 0
}
        sta result_akku,x
        php
        pla
        and #%11001011
        sta result_flags,x
        
        inx
        bne -

        cld
        rts

;---------------------------------------------
        
testpage_isc:


        sed

        ldx #0
-
        
testpage_isc_imm = * + 1
        lda #0
        sta zptmp
        txa     ; A = x
testpage_isc_clc = *
        clc
!if INSTR=4 {   ; isc
        isc zptmp
}
!if INSTR=5 {   ; rra
        rra zptmp
}
        sta result_akku,x
        php
        pla
        and #%11001011
        sta result_flags,x
        lda zptmp
        sta result_mem,x
        
        inx
        bne -

        cld
        rts

;-------------------------------------------------------------------------------
        
!if INSTR<4 {   ; adc,sbc,arr,sbceb
checkpage:
        ldx #0
-
        lda result_akku,x
checkpage_akku_reference = * + 2
        cmp reference_akku,x
        bne fatalerror0

        lda result_flags,x
checkpage_flags_reference = * + 2
        cmp reference_flags,x
        bne fatalerror1

        inx
        bne -
        rts
        
fatalerror0:
        lda #10 ; red
        sta $d020
        lda #$ff
        sta $d7ff
-
        inc colorram+$0100,x
        jmp -
        
fatalerror1:
        lda #10 ; red
        sta $d020
        lda #$ff
        sta $d7ff
-
        inc colorram+$0200,x
        jmp -
        
} else {          ; rra, isc

checkpage_isc:
        ldx #0
-
        lda result_akku,x
checkpage_akku_reference = * + 2
        cmp reference_akku,x
        bne fatalerror0

        lda result_flags,x
checkpage_flags_reference = * + 2
        cmp reference_flags,x
        bne fatalerror1

        lda result_mem,x
checkpage_mem_reference = * + 2
        cmp reference_mem,x
        bne fatalerror2
        
        inx
        bne -
        rts

fatalerror0:
        lda #10 ; red
        sta $d020
        lda #$ff
        sta $d7ff
-
        inc colorram+$0100,x
        jmp -
        
fatalerror1:
        lda #10 ; red
        sta $d020
        lda #$ff
        sta $d7ff
-
        inc colorram+$0200,x
        jmp -
        
fatalerror2:
        lda #10 ; red
        sta $d020
        lda #$ff
        sta $d7ff
-
        inc colorram+$0300,x
        jmp -
}

        
;-------------------------------------------------------------------------------
    
main:

!if INSTR<4 {   ; adc,sbc,arr,sbceb
        lda #>reference_akku
        sta checkpage_akku_reference
        clc
        adc #NUMPAGES
        sta checkpage_flags_reference

        lda #STARTPAGE      ; start page for this program
        sta testpage_adc_imm
        
!if CARRY=1 {
        lda #$38    ; sec
} else {
        lda #$18    ; clc
}
        sta testpage_adc_clc

        ldy #NUMPAGES
-

        sed
        lda testpage_adc_imm
        and #$0f
        cmp #$0a
        adc #$30
        sta $0400+2
        lda testpage_adc_imm
        lsr
        lsr
        lsr
        lsr
        cmp #$0a
        adc #$30
        sta $0400+1
        cld

        sed
        lda checkpage_akku_reference
        and #$0f
        cmp #$0a
        adc #$30
        sta $0400+5
        lda checkpage_akku_reference
        lsr
        lsr
        lsr
        lsr
        cmp #$0a
        adc #$30
        sta $0400+4
        cld

        sed
        lda checkpage_flags_reference
        and #$0f
        cmp #$0a
        adc #$30
        sta $0400+8
        lda checkpage_flags_reference
        lsr
        lsr
        lsr
        lsr
        cmp #$0a
        adc #$30
        sta $0400+7
        cld

        jsr testpage_adc
        inc testpage_adc_imm

        jsr checkpage
        inc checkpage_akku_reference
        inc checkpage_flags_reference

        dey
        bne -
}
!if INSTR>=4 {   ; isc,rra
        lda #>reference_akku
        sta checkpage_akku_reference
        clc
        adc #NUMPAGES
        sta checkpage_flags_reference
        clc
        adc #NUMPAGES
        sta checkpage_mem_reference

        lda #STARTPAGE      ; start page for this program
        sta testpage_isc_imm

!if CARRY=1 {
        lda #$38    ; sec
} else {
        lda #$18    ; clc
}
        sta testpage_isc_clc
        
        ldy #NUMPAGES
-
        sed
        lda testpage_isc_imm
        and #$0f
        cmp #$0a
        adc #$30
        sta $0400+2
        lda testpage_isc_imm
        lsr
        lsr
        lsr
        lsr
        cmp #$0a
        adc #$30
        sta $0400+1
        cld

        sed
        lda checkpage_akku_reference
        and #$0f
        cmp #$0a
        adc #$30
        sta $0400+5
        lda checkpage_akku_reference
        lsr
        lsr
        lsr
        lsr
        cmp #$0a
        adc #$30
        sta $0400+4
        cld

        sed
        lda checkpage_flags_reference
        and #$0f
        cmp #$0a
        adc #$30
        sta $0400+8
        lda checkpage_flags_reference
        lsr
        lsr
        lsr
        lsr
        cmp #$0a
        adc #$30
        sta $0400+7
        cld

        sed
        lda checkpage_mem_reference
        and #$0f
        cmp #$0a
        adc #$30
        sta $0400+11
        lda checkpage_mem_reference
        lsr
        lsr
        lsr
        lsr
        cmp #$0a
        adc #$30
        sta $0400+10
        cld

        jsr testpage_isc
        inc testpage_isc_imm

        jsr checkpage_isc
        inc checkpage_akku_reference
        inc checkpage_flags_reference
        inc checkpage_mem_reference
        
        dey
        beq +
        jmp -
+
}

        lda #13 ; green
        sta $d020
        lda #$00
        sta $d7ff
        jmp *

;-------------------------------------------------------------------------------

        !align 255,0
!if CARRY=0 {

!if INSTR=0 {   ; adc
reference_akku:         !binary "ref_adc_akku.bin",NUMPAGES * $100,STARTPAGE*$100
reference_flags:        !binary "ref_adc_flags.bin",NUMPAGES * $100,STARTPAGE*$100
}
!if INSTR=1 {   ; sbc
reference_akku:         !binary "ref_sbc_akku.bin",NUMPAGES * $100,STARTPAGE*$100
reference_flags:        !binary "ref_sbc_flags.bin",NUMPAGES * $100,STARTPAGE*$100
}
!if INSTR=2 {   ; arr
reference_akku:         !binary "ref_arr_akku.bin",NUMPAGES * $100,STARTPAGE*$100
reference_flags:        !binary "ref_arr_flags.bin",NUMPAGES * $100,STARTPAGE*$100
}
!if INSTR=3 {   ; sbc eb
reference_akku:         !binary "ref_sbc_akku.bin",NUMPAGES * $100,STARTPAGE*$100
reference_flags:        !binary "ref_sbc_flags.bin",NUMPAGES * $100,STARTPAGE*$100
}
!if INSTR=4 {   ; isc
reference_akku:         !binary "ref_isc_akku.bin",NUMPAGES * $100,STARTPAGE*$100
reference_flags:        !binary "ref_isc_flags.bin",NUMPAGES * $100,STARTPAGE*$100
reference_mem:          !binary "ref_isc_mem.bin",NUMPAGES * $100,STARTPAGE*$100
}
!if INSTR=5 {   ; rra
reference_akku:         !binary "ref_rra_akku.bin",NUMPAGES * $100,STARTPAGE*$100
reference_flags:        !binary "ref_rra_flags.bin",NUMPAGES * $100,STARTPAGE*$100
reference_mem:          !binary "ref_rra_mem.bin",NUMPAGES * $100,STARTPAGE*$100
}

} else {

!if INSTR=0 {   ; adc
reference_akku:        !binary "ref_adc_sec_akku.bin",NUMPAGES * $100,STARTPAGE*$100
reference_flags:       !binary "ref_adc_sec_flags.bin",NUMPAGES * $100,STARTPAGE*$100
}
!if INSTR=1 {   ; sbc
reference_akku:        !binary "ref_sbc_sec_akku.bin",NUMPAGES * $100,STARTPAGE*$100
reference_flags:       !binary "ref_sbc_sec_flags.bin",NUMPAGES * $100,STARTPAGE*$100
}
!if INSTR=2 {   ; arr
reference_akku:        !binary "ref_arr_sec_akku.bin",NUMPAGES * $100,STARTPAGE*$100
reference_flags:       !binary "ref_arr_sec_flags.bin",NUMPAGES * $100,STARTPAGE*$100
}
!if INSTR=3 {   ; sbc eb
reference_akku:        !binary "ref_sbc_sec_akku.bin",NUMPAGES * $100,STARTPAGE*$100
reference_flags:       !binary "ref_sbc_sec_flags.bin",NUMPAGES * $100,STARTPAGE*$100
}
!if INSTR=4 {   ; isc
reference_akku:        !binary "ref_isc_sec_akku.bin",NUMPAGES * $100,STARTPAGE*$100
reference_flags:       !binary "ref_isc_sec_flags.bin",NUMPAGES * $100,STARTPAGE*$100
reference_mem:         !binary "ref_isc_sec_mem.bin",NUMPAGES * $100,STARTPAGE*$100
}
!if INSTR=5 {   ; rra
reference_akku:        !binary "ref_rra_sec_akku.bin",NUMPAGES * $100,STARTPAGE*$100
reference_flags:       !binary "ref_rra_sec_flags.bin",NUMPAGES * $100,STARTPAGE*$100
reference_mem:         !binary "ref_rra_sec_mem.bin",NUMPAGES * $100,STARTPAGE*$100
}

}
