
cheesemouseport=1 ; 1 for port1, 0 for port0

readmouse:  ; 3a52
!if cheesemouseport = 0 {
        lda     $DC00
        pha
}
!if cheesemouseport = 1 {
        lda     $DC01
        pha
}
!if cheesemouseport = 0 {
        lda     $DC02
        pha
}
!if cheesemouseport = 1 {
        lda     $DC03
        pha
}
        lda     #$10
        sta     $DC02+cheesemouseport

        ; unset clk
        lda     $DC00+cheesemouseport
        and     #$EF
        sta     $DC00+cheesemouseport

        ldx     #$08
        jsr     delay

        ; get 4 bit from bits 0-3
        ; and rotate into bits 4-7
        lda     $DC00+cheesemouseport
        asl
        asl
        asl
        asl
        sta     mousex

        ; set clk
        lda     $DC00+cheesemouseport
        ora     #$10
        sta     $DC00+cheesemouseport
        
        ldx     #$05
        jsr     delay

        ; get 4 bit from bits 0-3
        ; and or into bits 0-3
        lda     $DC00+cheesemouseport
        and     #$0F
        ora     mousex
        sta     mousex

        ; unset clk
        lda     $DC00+cheesemouseport
        and     #$EF
        sta     $DC00+cheesemouseport
        
        ldx     #$05
        jsr     delay

        ; get 4 bit from bits 0-3
        ; and rotate into bits 4-7
        lda     $DC00+cheesemouseport
        asl
        asl
        asl
        asl
        sta     mousey

        ; set clk
        lda     $DC00+cheesemouseport
        ora     #$10
        sta     $DC00+cheesemouseport

        ldx     #$05
        jsr     delay

        ; get 4 bit from bits 0-3
        ; and or into bits 0-3
        lda     $DC00+cheesemouseport
        and     #$0F
        ora     mousey
        sta     mousey

        ; check RMB in POTX
        lda     $D419
        cmp     #$FF

!if cheesemouseport = 1 {
        pla
        sta     $DC03
}
!if cheesemouseport = 0 {
        pla
        sta     $DC02
}
!if cheesemouseport = 1 {
        pla
        sta     $DC01
}
!if cheesemouseport = 0 {
        pla
        sta     $DC00
}
        rts

delay:  nop
        nop
        nop
        dex
        bne     delay
        rts

 
