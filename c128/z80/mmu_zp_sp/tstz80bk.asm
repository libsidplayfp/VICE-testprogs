  ; Martijn Wehrens, 2023

    ; This is a C128 file that is loaded and executed to start z80
    ; z80 code to write data into F000-F0ff bank1
    ; then using bank2 write this data to 0100 WHILE 8K share top

    maclib  x6502   ;; mos assembly
    maclib  z80

; This is in BASIC data area so it must be loaded as a BASIC
; file at $1C00 that then jumps to $1C0F

    ORG     01C00h - 1

z80l SET low go80
z80h SET high go80

basicloader: ;; sys 1C0D
DW 01C01h ;; load address of prg

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
    ; bank0, page F0 with zeros
    mvi     a,03eh          ; io0 (z80 needs IO to see MMU)
    sta     0ff00h
    lxi     h,0f000h
    lxi     d,0f001h
    lxi     b,0ffh
    mvi     m,0             ; clear F000-F100 in bank0
    ldir                    ; zeroes
    ; prepare, increase common to 16k and access 1F000
    ; (on purpose using a different type access,
    ;  not the relocated page0 1)
    lxi     b,0d506h        ; common ram reg
    ;      tb   b = bottom
    ; 0000 1000 top 1
    ; 0000 1001 top 4
    ; 0000 1010 top 8
    ; 0000 1011 top 16
    ; 0000 0111 bottom 16
    mvi     a,00000111b
    outp    a               ; 0-$4000 is always bank0 now
    ; can safely switch to bank1 in 4000-FFFF
    mvi     a,07eh          ; io1
    sta     0ff00h
    lxi     h,0f000h
    ; put 0-ff into F000-F0ff (this we want to copy)

fill1:

    mov     m,l
    inr     l
    jrnz    fill1
    ;
    mvi     a,00001111b     ; 16k both
    lxi     b,0d506h        ; common mem
    outp    a               ; 16k hi and low
    ; 0-$4000 bk0, 4000-C000 bank1, C000-FFFF bank0
    ; copy whole of 1c00-1e00 from bank0 to bank1
    ; using a bank-copy located in high-common E000
    lxi     h,bkcopy        ; source
    lxi     d,0E000h        ; bank0 target
    lxi     b,bkcopye-bkcopy
    ldir
    lxi     b,0d506h        ; common mem
    mvi     d,00001011b     ; 16k top
    mvi     e,00001111b     ; 16 both
    lxi     h,01c00h        ; source and dest
    jmp     0e000h          ; code in common high
    ;
    ; common high code:

bkcopy:

    ; this goes to E000, switching bank0 inout
    outp    e               ; both
    mov     a,m             ; byte from bank0
    outp    d               ; 16K top
    mov     m,a             ; byte to bank1
    inx     h
    mov     a,h
    cpi     020h            ; end
    jrnz    bkcopy
    jmp     test1           ; in bank1

bkcopye:
;
; test 1
; use page reloc to copy 1F000 to 10200
; while Common is OFF
test1:

    xra     a
    lxi     b,0d506h        ; ram reg
    outp    a               ; turn off shared
    ; mem = 0-ffff bank1 (with IO)
    inr     a               ; A = 1
    mvi     d,0f0h          ; for page F0
    mvi     e,02h           ; for page 02
    mvi     c,0Ah           ; D50a Bank for page 1
    outp    a
    dcr     c
    outp    e               ; D509 page 02 for page 1
    dcr     c
    outp    a               ; D508 Bank for page 0
    dcr     c
    outp    d               ; D507 page F0 for page 0
    ; Note: since code is copied in bank1/0 we can
    ; jump around and continue as if nothing happend
    mvi     a,0bfh          ; ram2 = ram0 without z80rom
    sta     0ff00h
    ; now we have
    ; page 0 pointer: $1f000
    ; page 1 pointer: $10200
    ; common Off
    ; Bank2 with IO
    ;
    ; copy f000 to 0100 via p0 p1
    lxi     h,0000h         ; page 0 (F000)
    lxi     d,0100h         ; page 1 (0200)
    lxi     b,0100h
    ldir
    ; restore page 0 and 1 to their normal spot (but bank1)
    ; Needed because otherwise they would show the content
    ; of their swap-ptr (reading 0200 would give 0100 values)
    xra     a
    lxi     b,0d507h        ; D507 page 0 for page 0
    outp    a
    inr     a
    mvi     c,09h           ; D509 page 1 for page 1
    outp    a
    ;
    ; read bank1
    mvi     a,07eh          ; io1
    sta     0ff00h
    lxi     h,0200h         ; see nr-range here

chk1:

    mov     a,m
    cmp     l
    jnz     enok            ; fail
    inr     l
    jrnz    chk1
     ;
    ;
    ; test 2
    ; use page reloc to copy 1F000 to 10200
    ; while Common is set to 8K Hi

test2:

    mvi     a,00001010b     ; top 8k
    lxi     b,0d506h        ; ram reg
    outp    a
    ; mem = 0-e000 bank0
    inr     a               ; A = 1
    mvi     d,0f0h          ; for page F0
    mvi     e,02h           ; for page 02
    mvi     c,0Ah           ; D50a Bank for page 1
    outp    a
    dcr     c
    outp    e               ; D509 page 02 for page 1
    dcr     c
    outp    a               ; D508 Bank for page 0
    dcr     c
    outp    d               ; D507 page F0 for page 0
    ; Note: since code is copied in bank1/0 we can
    ; jump around and continue as if nothing happend
    mvi     a,0bfh          ; ram2 = ram0 without z80rom
    sta     0ff00h
    ; now we have
    ; page 0 pointer: $1f000
    ; page 1 pointer: $10200
    ; common 8k top
    ; Bank2 with IO
    ;
    ; copy f000 to 0100 via p0 p1
    lxi     h,0000h         ; page 0 (F000)
    lxi     d,0100h         ; page 1 (0200)
    lxi     b,0100h
    ldir
    ; restore page 0 and 1 to their normal spot (but bank1)
    ; Needed because otherwise they would show the content
    ; of their swap-ptr (reading 0200 would give 0100 values)
    xra     a
    lxi     b,0d507h        ; D507 page 0 for page 0
    outp    a
    inr     a
    mvi     c,09h           ; D509 page 1 for page 1
    outp    a
    ; read bank1
    mvi     a,07eh          ; io1
    sta     0ff00h
    lxi     h,0200h         ; see nr-range here

chk2:

    mov     a,m
    cmp     l
    jnz     enok            ; fail
    inr     l
    jrnz    chk2
    ;
    jmp     eok             ; good

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
