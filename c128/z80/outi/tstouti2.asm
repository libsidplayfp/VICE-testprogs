; C128 file that is loaded and executed to start z80

    maclib  x6502   ;; mos assembly
    maclib  z80
; This is in BASIC data area so it must be loaded as a BASIC
; file at $1C00 that then jumps to $1C0F

    ORG     01C00h - 1
z80l SET low go80
z80h SET high go80

basicloader: ;; sys 1C0D

    DW      01C01h  ;; load address of prg
    DB      0bh, 1ch        ; next basic line
    DB      1       ; line nr 1
    DB      0
    DB      09eh    ; sys
    DB      '7181',0 ; 01C0D
    DB      0,0     ; end of program
program: ; 1C0D

    @LDA    jmp,#
    @STA    0FFEEh  ;; rst1 becomes jmp
    @LDA    z80l,#
    @STA    0FFEFh  ;; return 6502 to z80 lo
    @LDA    z80h,#
    @STA    0FFF0h  ;; return 6502 to z80 hibyte
    @LDA    03Eh,#  ;; IO0
    @STA    0FF00h
    @DEC    0D505h  ;; enable z80, jumps to goz80
    @BRK
go80:

    lxi     sp,4000h        ; safe spot for a stack
    ; test 1
    ; output value green to border using OUTI
    lxi     b,0d020h
    mvi     a,6             ; blue border
    outp    a
    ;
    lxi     h,2000h
    mvi     m,0f5h          ; value 5 to be read from HL
    inr     b               ; preincrement d020 to d120
    ; does: b--,  out (c), (hl),  hl++
    OUTI                    ; put 0 into border
    ; VIC replies 1111 for unused bits in d020
    inp     a               ; read D020
    cpi     0F5h            ; 5, set Z if F5 found
    jnz     enok            ; end if not 0

    ; test 2
    ; output mmu using OUTD
    lxi     b,0d020h
    mvi     a,4             ; pur border
    outp    a
    mvi     a,3eh           ; IO 0, map in mmu
    sta     0ff00h
    mvi     a,0d5h
    in      5               ; d505
    sta     keep            ; 8040 key value
    lxi     b,0d50ah        ; mmu end
    lxi     h,mmutab+9
mmulp:

    inr     b               ; prep out
    OUTD                    ; put into mmu
    dcr     c               ; next mmu
    jnz     mmulp
    ; verify all of them
    lxi     h,mmutab+9
    lxi     b,0d50ah
mmutst:

    inp     a               ; read an MMU reg
    cmp     m               ; A == HL
    dcx     h
    jnz     enok            ; nonzero out == NOK
    dcr     c               ; next mmu
    jnz     mmutst          ; test next
    ;

    ; test 3
    ; output mmu using OTIR, write to z80 rom 0xxx
    ; ends up in Dxxx mem
    ; prep memory to get values from
    lxi     h,2000h
    mvi     a,15
fillm:

    mov     m,a
    inx     h
    dcr     a
    jp      fillm           ; list of 17 16 15 ..
    ; 2000: 0f 0e 0d 0c 0b 0a 09 08 07 06 05 04 03 02 01 00
    ; 2010: ..
    lxi     h,2000h         ; source for OTIR
    lxi     b,101fh         ; under z80 rom --> ram
    ; B-- (0F), out (hl), hl++. ram DFf1 = 0f
    ; B-- (0E), out (hl), hl++. ram DEf1 = 0e
    ; ..
    ; B-- (00), out (hl), hl++. ram D0f1 = 00
    OUTIR                   ; outI 16 times
    ; done, mem at DF1f .. D01f should be 0f 0e ..
    lxi     h,0DF1fh
    mvi     a,15
tstm1:

    cmp     m
    jnz     enok
    dcr     h
    dcr     a
    jp      tstm1   ; until D0
    ; test 4
    ; output mmu using OTDR, write to z80 rom 0xxx
    ; ends up in Dxxx mem
    ; We'll reuse the values in 2000-2010
    ; 2000: 0f 0e 0d 0c 0b 0a 09 08 07 06 05 04 03 02 01 00
    ; 2010: ..
    lxi     h,200fh         ; source for OTDR
    lxi     b,101fh         ; under z80 rom --> ram
    ; B-- (0F), out (hl), hl++. ram DFf1 = 00
    ; B-- (0E), out (hl), hl++. ram DEf1 = 01
    ; ..
    ; B-- (00), out (hl), hl++. ram D0f1 = 0f
    OUTDR                   ; outD 16 times
    ; done, mem at DF1f .. D01f should be 00 01 ..
    lxi     h,0D01fh
    mvi     a,15
tstm2:

    cmp     m
    jnz     enok
    inr     h
    dcr     a
    jp      tstm2   ; until DF
    jmp     eok             ; end ok
    ;
    ; these match what will be read out (bits set)
    ;  1    2    3    4
mmutab:

     db 3fh, 7fh, 3eh, 7eh   ; d501-d504 ram0, ram1, io0, io1
keep:

    db 0h           ; d505 (z80)
    db 0ah          ; d506 8k comm hi
    db 00, 0f1h, 01h, 0f1h  ; d507-d50a p0 and 1 to bank1
;end nOK
enok:

    mvi     a,0ffh
    db      06h             ; mvi b,xra
eok:

    xra     a               ; Zero = OK
;debug out

    lxi     b,0d020h
    outp    a               ; border FF is nok
    lxi     b,0d7ffh
    outp    a               ; debugcart d7ff = 0 = OK
    sta     0d7ffh          ; just to be sure
    ;
    ; die
    di
    hlt

    END     01c00h
