
; the following is an excerpt from ninjas original article:

;  snes-pad-pin-description:          c64-joyport-pin-description:
; 
;   a = +5v                            1 = joy 0
;   b = clock                          2 = joy 1
;   c = reset                          3 = joy 2
;   d = data1                          4 = joy 3
;   e = data2 (unused)                 5 = paddle y
;   f = data3 (unused)                 6 = joy 4
;   g = ground                         7 = +5v
;                                      8 = ground
;                                      9 = paddle x
;
;   you see, the secret of connecting eight pads to the joyports is that the
;   data is sent serial! the flow control is done via pins b and c, the data
;   itself uses pin d (note: pins e and f are not used by normal pads, they
;   are necessary for those snes-port-multiplexers). let's have a closer
;   look at this. at the beginning you have to raise and lower the
;   reset-line. now you can read the first bit from data1. after that you
;   raise and lower the clock-line and get the next bit from data1. repeat
;   this until you've got a total of 12 bits, then start again.
;
;   no problem with that. and as our c64 got 10 digital lines on
;   its joyports, minus two for the flow control, we should be able to
;   connect eight of those great pads to it. here is how it can be done:
;
; 
;            port 2                          port 1
; 
;     7     1 2 3 4 8   6               7 4 6 1 2  3  8
;     o     o o o o o   o               o o o o o  o  o
;     i     i i i i i   i               i i i i i  i  i
;     i *---i-i-i-i-i---i---------------i-* i i i  i  i
;     i i *-i-i-i-i-i---i---------------i-i-* i i  i  i
;     i i i i i i i i   i               i i i i i  i  i
;     i i i i i i i i   i               i i i i i  i  i
;    -*-*-*-*-------*-  i              -*-*-*-*-------*-
;   i o o o o   o o o ) i             i o o o o   o o o )
;    -*-*-*---------*-  i              -*-*-*---------*-
;     i i i   i i i i   i               i i i   i  i  i
;     i i i ,-' i i i   i               i i i ,-'  i  i
;     i i i i   i i i   i               i i i i    i  i
;    -*-*-*-*-------*-  i              -*-*-*-*-------*-
;   i o o o o   o o o ) i             i o o o o   o o o )
;    -*-*-*---------*-  i              -*-*-*---------*-
;     i i i     i i i   i               i i i      i  i
;     i i i ,---' i i   i               i i i ,----'  i
;     i i i i     i i   i               i i i i       i
;    -*-*-*-*-------*-  i              -*-*-*-*-------*-
;   i o o o o   o o o ) i             i o o o o   o o o )
;    -*-*-*---------*-  i              -----------------
;     i i i       i i   i               a b c d   e f g
;     i i i ,-----' i   i
;     i i i i       i   i
;    -*-*-*-*-------*-  i
;   i o o o o   o o o ) i
;    -*-*-*---------*-  i
;     i i i         i   i
;     i i i ,-------i---'
;     i i i i       i
;    -*-*-*-*-------*-
;   ± o o o o   o o o )
;    -----------------
;     a b c d   e f g
;
;   i decided to use port 1 for doing the flow control, because then you can
;   have three pads connected while still using your joystick in port 2.
;   i think this will be suitable for most cases, since there are not too
;   many games for more than three players. in addition to that we now
;   reduced the chance that keyboard routines will disturb the pads since
;   you normally write to $dc00 and rarely to $dc01. on the other hand the
;   pads may interfere with the keyboard, but we can get around this problem
;   very easy (see listing).
;

joy           = $0400       ; so you can see, if something happens
                            ; otherwise zeropage should be preferred

status        = $0450
                            
;-----------------------------------------------------------------------------
            *=$0801
            !word bend
            !word 10
            !byte $9e
            !text "2061", 0
bend:       !word 0
;-----------------------------------------------------------------------------

            sei
            ldx #0
-
            lda #$20
            sta $0400,x
            sta $0500,x
            sta $0600,x
            sta $0700,x
            lda #$01
            sta $d800,x
            sta $d900,x
            sta $da00,x
            sta $db00,x
            inx
            bne -

            ldx #0
-
            lda screendata,x
            sta $0400+(3*40),x
            inx
            bne -

            ldx #<(irq)   ; standard...
            ldy #>(irq)   ; procedure...
            stx $0314     ; for...
            sty $0315     ; setting...
            lda #$81      ; up...
            sta $d01a     ; an...
            lda #$ff      ; irq-routine.
            sta $d012     ; nothing...
            lda #$1b      ; special...
            sta $d011     ; about...
            cli           ; it..
            jmp *

;-----------------------------------------------------------------------------
irq:
            lda $d019     ; get irq-flag
            bpl noirq     ; irq generated by vic?
            sta $d019     ; yes, then clear flag
            jsr getsnes   ; main routine

            lda joy+10
            ldx #0
-
            rol
            ldy #'.'
            bcc +
            ldy #'*'
+
            pha
            tya
            sta status,x
            pla
            inx
            cpx #8
            bne -
            
            lda joy+11
            ldx #0
-
            rol
            ldy #'.'
            bcc +
            ldy #'*'
+
            pha
            tya
            sta status+9,x
            pla
            inx
            cpx #8
            bne -
            
noirq:

; this routine will prevent the pads from interfering with the
; keyboard. it is necessary as we need to reset $dc03 to zero for the
; keyboard scan. unfortunately this causes a permanent high signal on
; our snes-reset-line, what means we always have the status bit from
; button b present on $dc01. so, this is how you can get around that
; little problem.

            lda #$ff      ; disable keys by setting all keyboard
            sta $dc00     ; scan lines high...
            cmp $dc01     ; ...so any low signal must be sent by a pad
            bne nokeyb    ; did we get an interference?
            jmp $ea31     ; no, then we can check the keyboard
nokeyb:
            jmp $ea7e     ; yes, skip keyboard this time


; the following routine grabs all the bits from the snes-pads.
; of course, this code isn't optimized, since it is only for
; demonstration purposes. anyway, here are the bit descriptions in the
; order as they are sent by the pad. rol them, ror them, read them at
; once for all 8 pads, or whatever. you have quite a number of options
; :)
;
;    bit  0 : button b
;    bit  1 : button y
;    bit  2 : select
;    bit  3 : start
;    bit  4 : up
;    bit  5 : down
;    bit  6 : left
;    bit  7 : right
;    bit  8 : button a
;    bit  9 : button x
;    bit 10 : top-left l
;    bit 11 : top-right r
;    bit 12+: always 1
;
; normally a cleared bit means 'button pressed'. of course, you can
; change this by using an eor #$?? command.

getsnes:
            lda #$00      ; pa 0-7 = input
            sta $dc02     ;
            lda #$f8      ; pb 0-2 = input
            sta $dc03     ; pb 3-7 = output
            lda #$10      ; send "reset" command
            sta $dc01     ; to all pads
            lda #0        ; and
            sta $dc01     ; clear it
            ldy #16       ; get 16 bits (we actually need only 12
                        ; bits, but this way we have constant
loop3:                      ; values on the screen.)
            ldx #14       ; counter for 8 pads
            lda $dc01     ; get data from joyport 1
            eor #7        ; invert bits from pads (not necessary)
loop1:
            lsr           ; shift bit from pad into carry...
            rol joy+0,x   ; ...then into its destination
            rol joy+1,x   ; ...rotate 16 bits
            dex           ; decrement counter by 2 as we use
            dex           ; two bytes for storage
            cpx #8        ; first three pads done?
            bne loop1     ; no? then continue
            lda $dc00     ; get data from joyport 2
            eor #$1f      ; invert bits from pads (not necessary)
loop2:
            lsr           ; shift bit from pad into carry...
            rol joy+0,x   ; ...then into its destination
            rol joy+1,x   ; ...rotate 16 bits
            dex           ; again decrement counter
            dex
            bpl loop2     ; all done?
            lda #8        ; send "next" command
            sta $dc01     ; to all pads
            lda #0        ; and
            sta $dc01     ; clear it
            dey           ; did we get 12 bits?
            bne loop3     ; if not, loop
            lda #$ff      ; back...
            sta $dc02     ; to...
            lda #$00      ; normal...
            sta $dc03     ; for keyboard scan.
            rts           ; go back...

; if you use the rol instruction to collect the bits from the pad,
; you can use this table to fix the directions, so that it is
; compatible with the standard c64 format. simply isolate the
; direction-bits and use them as an index. by the way use the ror
; instruction and you won't have this problem...

fixtab:
            !byte $00,$08,$04,$0c,$02,$0a,$06,$0e
            !byte $01,$09,$05,$0d,$03,$0b,$07,$0f

screendata:
          ;1234567890123456789012345678901234567890
    !scr  "21lr     43ssdddd                       "
    !scr  "           etpppp    use trapthem-pad   "
    !scr  "ru       dllaaaaa                       "
    !scr  "ip       oeerdddd    in port 1          "
    !scr  "g        wfct----                       "
    !scr  "h        ntt udlr                       "
    !scr  "t                                       "
            
