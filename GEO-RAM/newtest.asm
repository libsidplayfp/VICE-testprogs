;------------------------------------------------------------
; Geo-/ Neoram-Test Version 1.0
;------------------------------------------------------------
;
; [/] 28. March 2011 , M. Sachse http://www.cbmhardware.de
;
; Detects Geo-/Neoram and runs test.
;
; Yellow Point: Read into buffer and compare
; Green Point: Write back and compare
; Red border and stop: a critical error !
;
; Change-Log: complete rewrite :)
;
; + advanced detection
; + faster routines
; + smaller code : less than 1,3 Kbytes
;
;------------------------------------------------------------
*= $0800
!byte $00,$0c,$08,$0a,$00,$9e,$32,$30,$36,$34,$00,$00,$00,$00


bsout         = $ffd2
gport         = $de00
gpage         = $dffe
gwindow16k    = $dfff
set_cursor    = $fff0
get           = $ffe4
check_buf     = $4000
ch64_magic    = $d0fe


*=$0810


                 lda #$93
                 jsr bsout

;------------------------------------------------------------
; ride the chameleon ?
;------------------------------------------------------------

                 lda #$07
                 sta $0286
                 ldx #$ff
                 lda #$2a
                 sta ch64_magic
                 lda ch64_magic
                 sta temp
                 stx ch64_magic
                 cmp #$01
                 beq c64_ch64
                 cmp #$a1
                 beq ch64
                 cmp #$ff
                 beq goon
                 ldx #$14                   ; line
                 ldy #$01                   ; column
                 clc
                 jsr set_cursor             ; set cursor
                 ldx #$00
-                lda nothing,x              ; anything is wrong
                 jsr bsout
                 inx
                 cpx #$28
                 bne  -
                 rts

;-----------------------------------------------------
c64_ch64:
                 ldx #$14                   ; line
                 ldy #$01                   ; column
                 clc
                 jsr set_cursor             ; set cursor
                 ldx #$00
-                lda chc64,x                ; text: c64 and Chameleon 64
                 jsr bsout
                 inx
                 cpx #$28
                 bne -
                 beq goon
;-----------------------------------------------------
ch64:
                 ldx #$14                   ; line
                 ldy #$01                   ; column
                 clc
                 jsr set_cursor             ; set cursor
                 ldx #$00
-                lda cham,x                 ; text: chameleon 64 alone
                 jsr bsout
                 inx
                 cpx #$28
                 bne -
;-----------------------------------------------------
goon:
                 lda #$40
                 sta m0+2                   ; restore "nerdish" selfmodifying code
                 sta m1+2
                 sta m4+2
                 sta m5+2
                 lda #$05
                 sta m2+2
                 lda #$d9
                 sta m3+2
                 lda #$44
                 sta m2+1
                 sta m3+1

                 lda #$17
                 sta 53272
                 ldx #$00
                 lda #$00
                 sta geo_banks
                 sta geo_hi
                 sta gwindow16k
                 sta gpage
-                lda gport,x
                 sta check_buf,x
                 inx
                 bne -
                 ldx #$00
-                txa
                 sta dummy,x                 ; write values and compare georam-port
                 sta gport,x
                 lda gport,x
                 cmp dummy,x
                 bne nogr
                 inx
                 bne -
                 beq +
nogr:
                 ldx #$00
-                lda not_active,x            ; text: no georam
                 jsr bsout
                 inx
                 cpx #$28
                 bne -

!if TESTBENCH = 1 {
                  lda #$ff  ; failure
                  sta $d7ff
}

                 jmp end
+
-                lda check_buf,x            ; restore georam
                 sta gport,x
                 inx
                 bne -

;------------------------------------------------------------
; evaluate banks
;------------------------------------------------------------

                  ldx #$00
                  stx geo_hi
                  stx gpage
-                 stx gwindow16k
                  lda gport
                  sta temp_buffer,x
                  inx
                  bne -
-                 stx gwindow16k            ; write 256 x $00
                  lda #$00
                  sta gport
                  inx
                  bne -
-                 lda gport                 ; check for wrap
                  cmp #$01
                  beq restore
                  lda #$01                  ; write next marker
                  sta gport
                  inc geo_hi
                  inx
                  stx gwindow16k
                  bne -
restore:          inx
-                 lda temp_buffer,x         ; restore buffered bytes
                  sta gport
                  stx gwindow16k
                  inx
                  bne -
                  beq main

end:              
                  rts





;------------------------------------------------------------
; main program
;------------------------------------------------------------

main:
                  ldx #$00
                  stx counter
                  stx $d020
                  stx $d021
                  inx
                  stx $0286
                  ldy #$01                   ; column
                  clc
                  jsr set_cursor             ; set cursor
                  dex
-                 lda title,x                ; text: title
                  jsr bsout
                  inx
                  cpx #$28
                  bne -

                  ldx #$03                   ; line
                  ldy #$04                   ; column
                  clc
                  jsr set_cursor             ; set cursor
                  ldx #$00
-                 lda detected,x             ; text: detection evaluated
                  jsr bsout
                  inx
                  cpx #$18
                  bne -
                  inx
                  lda geo_hi                 ; build hex for output
                  sta geo_banks
                  lsr
                  lsr
                  lsr
                  lsr
                  jsr add1
                  lda geo_banks
                  jsr add1
                  ldx #$00
-                 lda detected1,x             ; text: banks
                  jsr bsout
                  inx
                  cpx #$6
                  bne -

                  ldx #$16                   ; line
                  ldy #$01                   ; column
                  clc
                  jsr set_cursor             ; set cursor
                  ldx #$00
-                 lda spckey,x               ; text: press space or x
                  jsr bsout
                  inx
                  cpx #$28
                  bne -
;------------------------------------------------------------
; keyboard
;------------------------------------------------------------

!if TESTBENCH = 0 {

keys              jsr get
                  cmp #$20                   ; spc-key
                  beq check
                  cmp #$58                   ; x for exit
                  beq end
                  bne keys
} 

;------------------------------------------------------------
; check 16k-page
;------------------------------------------------------------


check:            inc geo_hi
                  ldx #$16                   ; line
                  ldy #$01                   ; column
                  clc
                  jsr set_cursor             ; set cursor
                  ldx #00
-                 lda plzwait,x              ; text: please wait
                  jsr bsout
                  inx
                  cpx #$28
                  bne -
                  ldx #$00
-                 txa
                  pha
                  sta errpage

                  lda #$07
                  sta color
                  lda #$7b
                  sta char
                  jsr show_check
                  jsr read16k
                  pla
                  tax
                  pha
                  lda #$6c
                  sta char
                  lda #$05
                  sta color
                  jsr show_check
                  jsr write16k
                  lda #$40
                  sta m0+2
                  sta m1+2
                  sta m4+2
                  sta m5+2
                  pla
                  tax
                  inx
                  cpx geo_hi
                  bne -
                  ldx #$16                   ; line
                  ldy #$01                   ; column
                  clc
                  jsr set_cursor             ; set cursor
                  ldx #$00
-                 lda finished,x             ; text: finished
                  jsr bsout
                  inx
                  cpx #$28
                  bne -
!if TESTBENCH = 1 {
                  lda #$00  ; success
                  sta $d7ff
}
                  jmp end

;------------------------------------------------------------
; write 16k from mem to georam
;------------------------------------------------------------



write16k:         ldy #$00
                  ldx #$00
-
m4                lda check_buf,x
                  sta gport,x
                  lda gport,x
m5                cmp check_buf,x
                  bne error
                  inx
                  bne -
                  inc m4+2
                  inc m5+2
                  iny
                  tya
                  sta gpage
                  cpy #$40
                  bne -
                  rts

;------------------------------------------------------------
; write 16k from georam to mem
;------------------------------------------------------------


read16k:          ldy #$00
                  ldx #$00
-                 lda gport,x
m0                sta check_buf,x
                  lda gport,x
m1                cmp check_buf,x
                  bne error
                  inx
                  bne -
                  inc m0+2
                  inc m1+2
                  iny
                  tya
                  sta gpage
                  cpy #$40
                  bne -
                  rts

;------------------------------------------------------------
; drop some chars on screen ... we're working
;------------------------------------------------------------

show_check:
                  lda char
m2:               sta $0544,x               ; show char
                  lda color
m3:               sta $d944,x               ; set color ram
                  inc counter
                  lda counter
                  cmp #$40
                  beq next_line
                  rts
next_line:

                  lda m2+1
                  clc
                  adc #$08
                  sta m2+1
                  bcs scram_hi
                  lda m3+1
                  clc
                  adc #$08
                  sta m3+1
                  bcs cram_hi
                  lda #$00
                  sta counter
                  rts
scram_hi:         inc m2
                  rts
cram_hi:          inc m3
                  rts

;------------------------------------------------------------
; show an error. format: geoport $hhll at 16k-page $ll
;------------------------------------------------------------


error:            lda #$02
                  sta $d020
                  txa
                  sta temp                   ; store addr-lo
                  ldx #$05                   ; line
                  ldy #$01                   ; column
                  clc
                  jsr set_cursor             ; set cursor
                  ldx #$00
-                 lda err_txt,x              ; text
                  jsr bsout
                  inx
                  cpx #$10
                  bne -

!if TESTBENCH = 1 {
                  lda #$ff  ; failure
                  sta $d7ff
}
                  ldx #$06                   ; line
                  ldy #$01                   ; column
                  clc
                  jsr set_cursor             ; set cursor
                  ldx #00
-                 lda err_addr,x             ; text
                  jsr bsout
                  inx
                  cpx #$0e
                  bne -
                  lda m1+2                   ; get hi for output
                  sta err_hi
                  sec
                  sbc #$40
                  lsr
                  lsr
                  lsr
                  lsr
                  jsr add1
                  lda err_hi
                  jsr add1
                  lda temp                   ; get low for output
                  lsr
                  lsr
                  lsr
                  lsr
                  jsr add1
                  lda temp
                  jsr add1
                  ldx #$00
-                 lda err_page,x             ; text
                  jsr bsout
                  inx
                  cpx #$0c
                  bne -
                  lda errpage                ; get 16k-page
                  lsr
                  lsr
                  lsr
                  lsr
                  jsr add1
                  lda errpage
                  jsr add1
                  pla
                  jmp end
add1              and #$0f                   ; calculate to hex
                  cmp #$0a
                  clc
                  bmi +
                  adc #$07
+                 adc #$30
                  jsr bsout
                  rts


;------------------------------------------------------------
; some text and bytes for working
;------------------------------------------------------------
cham:       !tx "    cHAMELEON c64 eMULATION DETECTED !  "
chc64:      !tx "    c64 AND cHAMELEON 64 DETECTED !     "
nothing:    !tx "    sORRY, dETECTION WAS FAULTY !       "
err_txt:    !tx " vERIFY-eRROR ! "
err_addr:   !tx "AT ADDRESS : $"
err_page:   !tx " IN PAGE : $"
title:      !tx "== gEO- AND nEORAM-tEST vERSION 1.0  =="
detected:   !tx " dETECTION EVALUATED : $"
detected1:  !tx " bANKS"
not_active: !tx " sORRY, NO ACTIVE RAM-EXPANSION FOUND.  "
spckey:     !tx "   - sPACE TO START OR x FOR EXIT -     "
plzwait:    !tx "  -- pLEASE WAIT - iT TAKES A WHILE --  "
finished:   !tx "  -- nO eRROR - hAVE A NICE DAY !   --  "

dummy:       !by $00
geo_banks:   !by $00
temp:        !by $00
geo_hi:      !by $00
errpage:     !by $00
err_hi:      !by $00
counter:     !by $00
char         !by $00
color        !by $00
temp_buffer: !by $00

