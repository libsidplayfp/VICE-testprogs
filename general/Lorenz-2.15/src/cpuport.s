
; original file was: cpuport.asm
;-------------------------------------------------------------------------------

;ISC128 = 0
;ISC128C64 = 0

            *= $0801
           
            .word baslink
            .word 0
            .byte $9e ; SYS
            .byte $32, $30, $36, $31
baslink:
            .byte 0,0,0

            jmp main
           
;-------------------------------------------------------------------------------           
           
config      .byte 0
abackup     .byte 0,0    ; copy of written values for error checking
acheck      .byte 0,0    ; values read back
laststate   .byte 0      ; track DATA bit 7,6,3 state
right       .byte 0

;-------------------------------------------------------------------------------           

            ; enable BASIC+Kernal+IRQ
rom:
            lda #$2f
            sta 0
            lda #$37
            sta 1
            cli
            rts


main
            jsr print
            .byte 13
            .text "{up}cpuport"
            .byte 0

            lda #0
            sta config
nextconfig
            sei
            lda #$ff
            sta 0
            sta 1
            sta abackup+0
            sta abackup+1
            sta laststate

            ; push config<<1,config<<2,..,config<<7
            ldx #8
            lda config
push
            asl a
            php
            dex
            bne push

            ; write 0,1 0,1 0,1
            ldx #4
pull
            pla
            and #1
            tay
            lda #0
            plp
            sbc #0
            sta 0,y
            sta abackup,y ;0-1

            ; laststate = ((backup0 ^ $ff) & laststate) |
            ;             (backup0 & backup1)

            ;inputs: keep last state
            lda abackup+0
            eor #$ff
            and laststate
            sta or1+1
            ;outputs: set new state
            lda abackup+0
            and abackup+1
or1         ora #$11
            sta laststate

            ;delay for larger capacitives
            ldy #0
delay
            iny
            bne delay

            dex
            bne pull

            ;check values
            
            lda 0
            sta acheck+0
            lda 1
            sta acheck+1

            ; value in $00 should not have changed
            lda abackup+0
            cmp acheck+0
            bne error

            ; expected value in $01 is =
            ;
            ; (((backup0 ^ $ff) | backup1) & %00110111) |
            ; (laststate & %11001000) &
            ; ~((backup0 ^ $ff) & %00001000)

            lda abackup+0
            eor #$ff
            ora abackup+1
            and #$37
            sta or2+1

            ; get bits 7,6,3 from laststate
            lda laststate
            and #$c8
or2         ora #$11

            ;bit 5 is drawn low if input
            tax
            lda #$20
            bit abackup+0
            bne no5low
            txa
            and #$df
            tax
no5low

            .ifne ISC128C64
            ;bit 6 is high on c128? (DIN/ASCII key)
;            tax
;            lda #$40
;            bit abackup+0
;            bne no6low
;            txa
;            ora #$40
;            tax
;no6low         
            ; since we dont know the state of the key, ignore bit 6
            lda acheck+1
            ora #$40
            sta acheck+1
            txa
            ora #$40
            tax
            .endif

            stx right    ; remember expected value for $01
            cpx acheck+1
            bne error
noerror
            inc config
            beq done
            jmp nextconfig
done
            jsr rom
            jmp ok
            
            ;--------------------------------

error

            lda acheck+1
            pha
            lda acheck+0
            pha
            jsr rom

            jsr print
            .byte 13
            .text "0=ff 1=ff"
            .byte 0

            ldx #8
            lda config
push1
            asl a
            php
            dex
            bne push1

            ldx #4
pull1
            lda #32
            jsr $ffd2
            pla
            and #1
            ora #"0"
            jsr $ffd2
            lda #"="
            jsr $ffd2
            lda #0
            plp
            sbc #0
            stx oldx+1
            jsr printhb
oldx
            ldx #$11
            dex
            bne pull1
            
            jsr print
            .byte 13
            .text "after  "
            .byte 0

            pla
            jsr printhb
            lda #32
            jsr $ffd2
            pla
            jsr printhb
            
            jsr print
            .byte 13
            .text "right  "
            .byte 0
            
            lda abackup+0
            jsr printhb
            lda #32
            jsr $ffd2
            
            lda right
            jsr printhb
            lda #13
            jsr $ffd2  

            lda #$ff       ; failure
            sta $d7ff

wait     
            jsr $ffe4
            beq wait
            jmp noerror

         
            ; success, load the next test

ok
            jsr print
            .text " - ok"
            .byte 13,0

            lda #0         ; success
            sta $d7ff

load
            lda #47
            sta 0
            
            jsr print
name        .text "cputiming"
namelen    = *-name
            .byte 0
            
            lda #0
            sta $0a
            sta $b9
            lda #namelen
            sta $b7
            lda #<name
            sta $bb
            lda #>name
            sta $bc
            pla
            pla
            jmp $e16f

            ; return addr on stack == ptr to string
print      
            .block
            pla
            sta print0+1
            pla
            sta print0+2

            ldx #1
print0      lda $dead,x
            beq print1
            jsr $ffd2
            inx
            bne print0
print1     
            sec
            txa
            adc print0+1
            sta print2+1
            lda #0
            adc print0+2
            sta print2+2
print2      jmp $dead
            .bend

            ; print hex byte in Akku
printhb
            .block
            pha
            lsr a
            lsr a
            lsr a
            lsr a
            jsr printhn
            pla
            and #$0f
printhn
            ora #$30
            cmp #$3a
            bcc printhn0
            adc #6
printhn0
            jsr $ffd2
            rts
            .bend


