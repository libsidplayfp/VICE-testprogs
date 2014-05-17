; ------------------------------------------------------------------------------
; based on enhanced sidplayer "c64 sid.obj" by craig chamberlain (10/24/86)

;ORIGINALBINARY = 2 ; if 1, output will be exactly the same as the original
;                   ; if 2, will match exactly the player from libsidplay

.scope
                   
;playerloc       = $e000
;songdata        = $2000

; ------------------------------------------------------------------------------
; sidobj64.s  10/24/86
; ------------------------------------------------------------------------------

fac1    = $61
.if SIDNUM = 0
frekzp  = $fb   ; 5 bytes
.else
frekzp  = $fb-5 ; 5 bytes
.endif

ntscfl  = $02a6 ;ntsc/pal flag
;cinv    = $0314

timalo  = $dc04
timahi  = $dc05
;ciaicr  = $dc0d
;ciacra  = $dc0e

; ------------------------------------------------------------------------------
; ksidequ.s  10/24/86
; ------------------------------------------------------------------------------
vptr    = frekzp        ;points to current voice
comptr  = frekzp+2      ;points to current command
octtmp  = frekzp+2      ;octave temporary
hstmp   = frekzp+3      ;half step temporary
temp    = frekzp+4      ;utility temporary

plzp    = fac1 ;for sys play

.if SIDNUM = 0
sid     = $d400 ;sound interface device
.else
sid     = $d500
.endif

vfreql  = 0 ;frequency lo
vfreqh  = 1 ;frequency hi
vpwl    = 2 ;pulse width lo
vpwh    = 3 ;pulse width hi
vctl    = 4 ;control
vatdc   = 5 ;attack/decay
vssrl   = 6 ;sustain/release

fcl     = sid+21 ;filter cutoff lo
fch     = sid+22 ;filter cutoff hi
rf      = sid+23 ;resonance/filter
mv      = sid+24 ;mode/volume
osc3    = sid+27 ;oscillator three
env3    = sid+28 ;envelope three

; ------------------------------------------------------------------------------
cgplayer_init:  jmp doinit1
cgplayer_play:  ;jmp doplay1
; ---------------------------------------------------------------------------
doplay1:        LDA     #0
                AND     #$FF
                BEQ     @skp
                JMP     playcall
@skp:           rts

; ---------------------------------------------------------------------------
doinit1:
                ;LDX     #<stopplay
                ;LDY     #>stopplay
                ;STX     oldvec
                ;STY     oldvec+1
                JSR     initcall
.if SIDNUM = 0
                LDX     #<musdata
                LDY     #>musdata
.else
                LDX     #<strdata
                LDY     #>strdata
.endif
                JSR     play
                LDA     #7
                STA     status
                STA     doplay1+1
                RTS

; ------------------------------------------------------------------------------
; ksidvars.s  10/23/86
; ------------------------------------------------------------------------------

; user variables

status:         .byte $00 ;error and active status
flag:           .byte $00 ;user flag
npitch:         .byte $00 ;current pitch
                .byte $00
                .byte $00
ndurat:         .byte $00 ;current duration
                .byte $00
                .byte $00
msnuml:         .byte $00 ;measure number
                .byte $00
                .byte $00
msnumh:         .byte $00 ;measure number
                .byte $00
                .byte $00

; hardware shadows

sfreql:         .byte $00,$00,$00
sfreqh:         .byte $00,$00,$00
spwl:           .byte $00,$00,$00
spwh:           .byte $00,$00,$00
sctl:           .byte $00,$00,$00
satdc:          .byte $00,$00,$00
sssrl:          .byte $00,$00,$00
sfcl:           .byte $00
sfch:           .byte $00
srf:            .byte $00
smv:            .byte $00

; system variables

durw:           .byte $00               ;whole note duration (tempo)
durtri:         .byte $00               ;whole triplet duration
duru:           .byte $00               ;utility duration
durutv:         .byte $00,$00,$00       ;utility-voice durations
jiftim:         .word $00               ;new timer a value
vnum:           .byte $00               ;error voice number

; voice variables

durctr:         .byte $00,$00,$00 ;jiffy counter
invoic:         .byte $00,$00,$00
tsrflg:         .byte $00,$00,$00 ;tie/slur/rest flag
relpt:          .byte $00,$00,$00 ;release point
hldrst:         .byte $00,$00,$00 ;hold time reset
hldctr:         .byte $00,$00,$00 ;hold time counter
glproc:         .byte $00,$00,$00 ;glide processing flag
gratel:         .byte $00,$00,$00 ;glide rate lo
grateh:         .byte $00,$00,$00 ;glide rate hi
vibrat:         .byte $00,$00,$00 ;vibrato active rate
vibctr:         .byte $00,$00,$00 ;active counter
vibcml:         .byte $00,$00,$00 ;accumulation lo
vibcmh:         .byte $00,$00,$00 ;accumulation hi
vibrst:         .byte $00,$00,$00 ;depth counter reset
newrat:         .byte $00,$00,$00 ;new rate next center
newrst:         .byte $00,$00,$00 ;new reset next center
pandv:          .byte $00,$00,$00 ;portamento and vibrato
pwvdep:         .byte $00,$00,$00 ;
pwvctr:         .byte $00,$00,$00 ;
pwvcml:         .byte $00,$00,$00 ;
pwvcmh:         .byte $00,$00,$00 ;
pwvrst:         .byte $00,$00,$00 ;
newpwr:         .byte $00,$00,$00 ;
newpwd:         .byte $00,$00,$00 ;
svoctp:         .byte $00,$00,$00 ;last tps octave
svhstp:         .byte $00,$00,$00 ;last tps half step
savrtp:         .byte $00,$00,$00 ;last rtp value
octtps:         .byte $00,$00,$00 ;octave transpose
hstps:          .byte $00,$00,$00 ;half step transpose
detunl:         .byte $00,$00,$00 ;frequency offset lo
detunh:         .byte $00,$00,$00 ;frequency offset hi
ftargl:         .byte $00,$00,$00 ;target frequency lo
ftargh:         .byte $00,$00,$00 ;target frequency hi
pwswpl:         .byte $00,$00,$00 ;pulse width sweep lo
pwswph:         .byte $00,$00,$00 ;pulse width sweep hi
pwrstl:         .byte $00,$00,$00 ;pulse width reset lo
pwrsth:         .byte $00,$00,$00 ;pulse width reset hi
autofc:         .byte $00,$00,$00 ;auto cutoff select
fcswp:          .byte $00,$00,$00 ;filter cutoff sweep hi
fcrsth:         .byte $00,$00,$00 ;filter cutoff reset hi


comadl:         .byte $00,$00,$00 ;command address lo
comadh:         .byte $00,$00,$00 ;command address hi
rptvoc:         .byte $00,$00,$00
rptadl:         .byte $00,$00,$00 ;repeat address lo
rptadh:         .byte $00,$00,$00 ;repeat address hi
rptctr:         .byte $00,$00,$00 ;repeat counter
stkptr:         .byte $00,$00,$00 ;stack pointer

varend = *

; modulation variables

lfoval:         .byte $00
svosc3:         .byte $00
svenv3:         .byte $00

lfosrc:         .byte $00,$00,$00
lfodst:         .byte $00,$00,$00
lfosca:         .byte $00,$00,$00
lfotyp:         .byte $00
lforup:         .byte $00
lfordn:         .byte $00
lfomax:         .byte $00

lfofrl:         .byte $00,$00,$00
lfofrh:         .byte $00,$00,$00
lfopwl:         .byte $00,$00,$00
lfopwh:         .byte $00,$00,$00
lfofcl:         .byte $00,$00,$00
lfofch:         .byte $00,$00,$00

lfodir:         .byte $00
lfoctr:         .byte $00

; return addresses

stackl:         .byte $00,$00,$00,$00,$00 ;***
                .byte $00,$00,$00,$00,$00
                .byte $00,$00,$00,$00,$00
stackh:         .byte $00,$00,$00,$00,$00 ;***
                .byte $00,$00,$00,$00,$00
                .byte $00,$00,$00,$00,$00

; phrase addresses

phradl:         .byte $00,$00,$00,$00
                .byte $00,$00,$00,$00
                .byte $00,$00,$00,$00
                .byte $00,$00,$00,$00
                .byte $00,$00,$00,$00 ;***new
                .byte $00,$00,$00,$00 ;***new
phradh:         .byte $00,$00,$00,$00
                .byte $00,$00,$00,$00
                .byte $00,$00,$00,$00
                .byte $00,$00,$00,$00
                .byte $00,$00,$00,$00 ;***new
                .byte $00,$00,$00,$00 ;***new
tblend:

;-------------------------------------------------------------------------------
; non-initialized variables

;systim:         .word $00 ;normal timer a value

vocstk:         .byte $00,$00,$00,$00,$00 ;***
                .byte $00,$00,$00,$00,$00
                .byte $00,$00,$00,$00,$00

phrvoc:         .byte $00,$00,$00,$00
                .byte $00,$00,$00,$00
                .byte $00,$00,$00,$00
                .byte $00,$00,$00,$00
                .byte $00,$00,$00,$00 ;***new
                .byte $00,$00,$00,$00 ;***new

;                .byte 0,0, 0, 0,0

systim:         .word $00 ;normal timer a value

; ------------------------------------------------------------------------------
; ksidtabsys.s  10/24/86
; ------------------------------------------------------------------------------


; vectors

;vvproc:         jmp vproc       ;voice processing (unsused?)
;vcproc:         jmp cproc       ;command processing (unsused?)

;            err *&$ff/$ff
;oldvec:         .word $00       ;previous contents of cinv (unsused?)

;vdurap:         .word null      ;post processing (duration) (unsused?)
;vpostp:         .word null      ;post processing (note) (unsused?)

;                .byte 0,0, 0, 0,0

;            err *&$ff/$ff
;vpatch:         .word null ;aux machine code

; default aux and post processing
;null:
;                rts


; tables

; bit indices for voice numbers

bitab:          .byte $01,$02,$04

; voice pointer lo bytes

vtab:           .byte $00,$07,$0e

; double sharps and flats table

dshflt:         .byte 2, 2, 254, 2, 2, 254, 254

; note index offsets for accidentals

acctbl:         .byte $00,$01,$00,$ff

; note base values in half steps

hstabl:
                .byte 0  ;c
                .byte 2  ;d
                .byte 4  ;e
                .byte 5  ;f
                .byte 7  ;g
                .byte 9  ;a
                .byte 11 ;b

; frequency values

ftabl:          .byte 30  ;c natural
                .byte 24  ;c sharp/d flat
                .byte 139 ;d natural
                .byte 126 ;d sharp/e flat
                .byte 250 ;e natural
                .byte 6   ;f natural
                .byte 172 ;f sharp/g flat
                .byte 243 ;g natural
                .byte 230 ;g sharp/a flat
                .byte 143 ;a natural
                .byte 248 ;a sharp/b flat
                .byte 46  ;b natural

ftabh:          .byte 134 ;c natural
                .byte 142 ;c sharp/d flat
                .byte 150 ;d natural
                .byte 159 ;d sharp/e flat
                .byte 168 ;e natural
                .byte 179 ;f natural
                .byte 189 ;f sharp/g flat
                .byte 200 ;g natural
                .byte 212 ;g sharp/a flat
                .byte 225 ;a natural
                .byte 238 ;a sharp/b flat
                .byte 253 ;b natural

; auto filter tables

fcoctb:         .byte 140
                .byte 120
                .byte 100
                .byte 80
                .byte 60
                .byte 40
                .byte 20
                .byte 0

fchstb:         .byte 0  ;c
                .byte 2  ;c sharp/d flat
                .byte 3  ;d
                .byte 5  ;d sharp/e flat
                .byte 7  ;e
                .byte 8  ;f
                .byte 10 ;f sharp/g flat
                .byte 12 ;g
                .byte 13 ;g sharp/a flat
                .byte 15 ;a
                .byte 17 ;a sharp/b flat
                .byte 18 ;b

; filter cutoff sweep table
fcswtb:         .byte $00,$e0

; stack pointer minimum/maximum values
stkmin:         .byte $00                       ; bug?
stkmax:         .byte $05,$0a,$0f

; transpose command tables
tpstb1:         .byte 249
tpstb2:         .byte 0,245

; triplet duration table
dur3tb:         .byte   0,0,0
                .byte  16,0,0
                .byte  32,0,0
                .byte  48,0,0
                .byte  64,0,0
                .byte  80,0,0
                .byte  96,0,0
                .byte 112,0,0
                .byte 128,0,0
                .byte 144,0,0
                .byte 160,0,0

;-------------------------------------------------------------------------------
; sys routines

initcall:

;hook
            ;stop playing
            lda #$00
            sta status

            ; init ticks per second
            ldx #<$4295 ;assume ntsc
            ldy #>$4295
            lda ntscfl
            beq @hooksk
            ldx #<$4025 ;is pal
            ldy #>$4025
@hooksk:
            stx systim
            sty systim+1
            rts

;-------------------------------------------------------------------------------

play:
             ;stop playing
            lda #$00
            sta status

;.if ORIGINALBINARY < 2
;            ldx #<sondata
;            ldy #>sondata
;.endif
            stx plzp ;save adr of song
            sty plzp+1

            ldy #varend-status-1
loop1:
            sta status,y ;clear vars
            dey
            bne loop1

            ldy #tblend-varend
loop1b:
            sta varend-1,y ;clear tables
            dey
            bne loop1b

            sta fcl
            sta fch
            lda #$08
            sta srf ;mezzo forte
            sta rf
            sta smv ;f-x default on
            sta mv
            lda #144 ;m.m. 100
            sta durw
            lda #96
            sta durtri
            lda #12 ;eighth triplet
            sta duru
            lda systim
            sta jiftim
            lda systim+1
            sta jiftim+1
            lda #255
            sta lfomax ;***

            lda #>sid
            sta plzp+3
            ldx #2
loop2:
            lda #$ff
            sta msnumh,x
            lda #$01
            sta durctr,x ;start playing first frame
            sta durutv,x ;***utility-voice duration
            txa
            sta invoic,x ;**
            sta rptvoc,x ;**
            lda #$04
            sta relpt,x
            lda stkmin,x
            sta stkptr,x ;empty stack
            lda #91
            sta savrtp,x ;***
            lda vtab,x
            sta plzp+2
            lda #$00
            tay ;0
            sta (plzp+2),y ;freql
            iny
            sta (plzp+2),y ;freqh
            iny
            sta (plzp+2),y
            lda #$08
            sta spwh,x ;square width
            sta pwrsth,x
            iny
            sta (plzp+2),y
            iny
            sta (plzp+2),y ;test bit
            lda #$40
            sta sctl,x
            sta (plzp+2),y
            lda #$20
            sta satdc,x
            iny
            sta (plzp+2),y
            lda #$f5
            sta sssrl,x
            iny
            sta (plzp+2),y
            dex
            bpl loop2

            txa ;$ff
            ldx #23
loop4:
            sta phrvoc,x
            dex
            bpl loop4

            lda plzp ;***frekzp!
            clc
            adc #6 ;look past header
            sta plzp+2
            lda #$00
            tax
            tay
            adc plzp+1
loop5:
            sta plzp+3
            sta comadh,x
            sta rptadh,x
            lda plzp+2
            sta comadl,x
            sta rptadl,x

            clc
            adc (plzp),y
            sta plzp+2
            lda plzp+3
            iny
            adc (plzp),y
            iny

            inx
            cpx #3
            bne loop5
            ldx plzp+2
            tay ;return with text adr

            rts

;.if ORIGINALBINARY >= 1
hush:
            lda #$00
            sta sid+4
            sta sid+11
            sta sid+18
            sta sid+1
            sta sid+8
            sta sid+15
            lda #$08
            sta sid+23 ;f-x on
;.if ORIGINALBINARY = 1
;            sta sid+24 ;master volume
;.endif
            lda systim ;***
            sta timalo ;***
            lda systim+1 ;***
            sta timahi ;***
            rts
;.endif
 
; ------------------------------------------------------------------------------
; ksidsproc.s  10/24/86
; ------------------------------------------------------------------------------

; system processing

err5:
            lda #$08
            sta status
exit7:
            ;jmp (oldvec) ;***kplay?
            jmp stopplay
            ;rts

playcall:
; irq vector points here
sproc:
;.if ORIGINALBINARY = 1
;            lda ciaicr ;clear irq
;.endif 
            lda status
            bmi err5 ;branch if clobbered
            ora #$80 ;show processing
            tay
            and #$07
            beq exit7 ;branch if all stopped
            cld ;very important!!!
            sty status

;.if ORIGINALBINARY = 1
;            cli ;allow clobber *****
;.elseif ORIGINALBINARY = 2
;            nop
;.endif 

; **save zp ram?
.if 1 = 0
LDA     $FB             ; A <- M
STA     $E156       ; M <- (A)
LDA     $FC             ; A <- M
STA     $E157       ; M <- (A)
LDA     $FD             ; A <- M
STA     $E158       ; M <- (A)
LDA     $FE             ; A <- M
STA     $E159       ; M <- (A)
LDA     $FF             ; A <- M
STA     $E15A       ; M <- (A)
.endif
; update sid chip

updthw:
            lda sfcl
            clc
            adc lfofcl
            pha
            and #$07
            tay
            lda lfofch
            adc #0
            sta temp
            pla
            lsr temp
            ror a
            lsr temp
            ror a
            lsr temp
            ror a
            clc
            adc sfch
            sty fcl
            sta fch
            lda srf
            sta rf
            lda smv
            sta mv

            lda #>sid
            sta vptr+1
            ldx #0
sloop2:
            lda status
            and bitab,x
            beq skip19

            lda vtab,x
            sta vptr
            lda sfreql,x
            clc
            adc vibcml,x ;***
            tay ;save
            lda sfreqh,x
            adc vibcmh,x
            pha
            tya ;ret
            clc
            adc lfofrl,x
            ldy #vfreql
            sta (vptr),y
            pla
            adc lfofrh,x ;***
            iny
            sta (vptr),y
            lda spwl,x
            clc
            adc pwvcml,x ;***
            sta temp
            lda spwh,x
            adc pwvcmh,x
            pha
            lda temp
            clc
            adc lfopwl,x
            iny
            sta (vptr),y
            pla
            adc lfopwh,x ;***
            iny
            sta (vptr),y
            lda satdc,x
            iny
            iny
            sta (vptr),y
            lda sssrl,x
            iny
            sta (vptr),y
skip19:
            inx
            cpx #3
            bne sloop2

setctl:

            ldy sctl
            ldx sctl+1
            lda sctl+2

            sty sid+vctl
            stx sid+vctl+7
            sta sid+vctl+14

; update timer a

            ldx jiftim
            ldy jiftim+1
            stx timalo
            sty timahi

; save modulation values

audsk6:
            lda osc3
            sta svosc3
            lda env3
            sta svenv3

; process voice commands and notes

            ldx #0 ;start with first voice
sloop:
            lda status
            and bitab,x
            beq skip11 ;voice not active
            stx vnum ;save voice number
            jsr vproc ;process voice ;***vvproc
            lda status
            and #$78
            beq skip11 ;no error
            jmp lfos20
skip11:
            inx
            cpx #3
            bne sloop

; process software generated waveform

            lda lfotyp
            bne lfosk7 ;pulse
            lda lforup
            ora lfordn
            beq lfos13 ;no modulation change
            lda lfodir
            bne lfosk5 ;down
lfosk3:
            lda lforup
            beq lfosk6 ;do down
            clc
            adc lfoval
            bcs lfosk4 ;went over
            cmp lfomax
            bcc lfos12
            beq lfos12
lfosk4:
            lda #0
            sta lfodir
            lda lfordn
            beq lfos12
            inc lfodir ;down
            lda lfoval
            sbc lfordn ;carry is set
            jmp lfos12
lfosk5:
            lda lfordn
            beq lfosk3 ;do up
lfosk6:
            lda lfoval
            sec
            sbc lfordn
            bcs lfos12
            lda #0
            sta lfodir
            lda lforup
            bne lfos12
            inc lfodir
            bne lfos11 ;always
lfosk7:
            dec lfoctr
            bne lfos13 ;no modulation change
            lda lfodir
            bne lfosk9
            inc lfodir
            lda lfordn
            bne lfosk8
            lda #32
lfosk8:
            sta lfoctr
            lda #0
            beq lfos12 ;always
lfosk9:
            dec lfodir
            lda lforup
            bne lfos10
            lda #32
lfos10:
            sta lfoctr
lfos11:
            lda lfomax
lfos12:
            sta lfoval

; update modulation values

lfos13:
            ldx #0
lfolp1:
            lda lfodst,x
            beq lfos17 ;no modulation
            lda #0
            sta temp
            ldy lfosrc,x
            lda lfoval,y
            ldy lfosca,x
            beq lfos14 ;no scaling
            bmi lfolp3
lfolp2:
            asl a
            rol temp
            dey
            bne lfolp2
            beq lfos14 ;always
lfolp3:
            lsr a
            iny
            bne lfolp3
lfos14:
            ldy lfodst,x
            dey
            bne lfos15
            sta lfofrl,x
            lda temp
            sta lfofrh,x
            jmp lfos17
lfos15:
            dey
            bne lfos16
            sta lfopwl,x
            lda temp
            sta lfopwh,x
            jmp lfos17
lfos16:
            sta lfofcl
            lda temp
            sta lfofch
lfos17:
            inx
            cpx #3
            bne lfolp1

            lda status
            and #$7f ;turn off processing bit
lfos20:
            sta status
lfos21:
.if 1 = 0
; **restore zp ram?
LDA     $E156       ; A <- M
STA     $FB             ; M <- (A)
LDA     $E157       ; A <- M
STA     $FC             ; M <- (A)
LDA     $E158       ; A <- M
STA     $FD             ; M <- (A)
LDA     $E159       ; A <- M
STA     $FE             ; M <- (A)
LDA     $E15A       ; A <- M
STA     $FF             ; 
.endif
            ;jmp (oldvec) ;***kplay?
            jmp stopplay
            ;rts
; ------------------------------------------------------------------------------
; ksid.s
; ------------------------------------------------------------------------------

; duration processing

exit5:
            lda pandv,x
            bne exit5b
            jmp exit1
exit5b:
            jmp pvbrto

vproc:
            dec durctr,x
            bne vpskp1
            jmp nproc ;time for new note

vpskp1:
            lda tsrflg,x
            bmi exit5 ;no dur proc if rest
            bne vpskp3 ;no release if tie/slur
            lda hldctr,x
            beq vpskp2
            dec hldctr,x
            bne vpskp3
vpskp2:
            lda relpt,x
            cmp durctr,x
            bcc vpskp3 ;not time to release yet
            lda sctl,x
            and #$fe
            sta sctl,x ;release

vpskp3:

; process glide (portamento)

pgl:
            lda glproc,x
            beq pvbrto ;glide not selected
            asl a ;glide direction into carry
            lda sfreql,x
            bcs gldown
glup:
            adc gratel,x ;carry clear from branch
            sta sfreql,x
            tay ;save for later
            lda sfreqh,x
            adc grateh,x
            sta sfreqh,x
            pha ;save freq hi
            tya ;retrieve lo byte
            cmp ftargl,x ;check if glide complete
            pla
            sbc ftargh,x
            bcs stopgl ;reached or went past
            bcc aftrgl ;always  (not there yet)
gldown:
            sbc gratel,x
            sta sfreql,x
            lda sfreqh,x
            sbc grateh,x
            sta sfreqh,x
            lda ftargl,x
            cmp sfreql,x ;check if glide complete
            lda ftargh,x
            sbc sfreqh,x
            bcc aftrgl
stopgl:
            lda ftargl,x ;reset frequency to target
            sta sfreql,x
            lda ftargh,x
            sta sfreqh,x
            lda #$00
            sta glproc,x ;stop glide processing this note
aftrgl:
            lda pandv,x
            beq ppwswp

; process vibrato

pvbrto:
            lda vibrat,x
            beq aftrvb
            ldy #0
            dec vibctr,x
            bne addvib
            lda vibcml,x
            ora vibcmh,x
            bne vbrvrs ;not at center
            lda newrst,x
            sta vibrst,x
            sta vibctr,x
            lda vibrat,x ;get direction
            asl a ;sign into carry
            lda newrat,x
            bcc skip12
            eor #$ff ;negate
            adc #$00 ;carry is set
skip12:
            sta vibrat,x
            bne addvb2 ;always
vbrvrs:
            lda vibrst,x
            sta vibctr,x
            tya ;zero
            sec
            sbc vibrat,x ;reverse direction
            sta vibrat,x
addvib:
            cmp #0 ;get status
addvb2:
            bpl skip13
            dey ;to $ff
skip13:
            clc
            adc vibcml,x
            sta vibcml,x
            tya
            adc vibcmh,x
            sta vibcmh,x
aftrvb:
            lda tsrflg,x
            bmi ppwvib ;is rest

; process pulse width sweep

ppwswp:
            lda pwswpl,x
            beq ppwvib
            clc
            adc spwl,x
            sta spwl,x
            lda pwswph,x
            adc spwh,x
            sta spwh,x

; process pulse width vibrato

ppwvib:
            lda pwvdep,x
            beq aftrpw
            ldy #0
            dec pwvctr,x
            bne addpwv
            lda pwvcml,x
            ora pwvcmh,x
            bne pwvrvs ;not at center
            lda newpwr,x
            sta pwvrst,x
            sta pwvctr,x
            lda pwvdep,x ;get direction
            asl a ;sign into carry
            lda newpwd,x
            bcc pwvsk1
            eor #$ff ;negate
            adc #$00 ;carry is set
pwvsk1:
            sta pwvdep,x
            bne addpv2 ;always
pwvrvs:
            lda pwvrst,x
            sta pwvctr,x
            tya ;zero
            sec
            sbc pwvdep,x ;reverse direction
            sta pwvdep,x
addpwv:
            cmp #0 ;get status
addpv2:
            bpl pwvsk2
            dey ;to $ff
pwvsk2:
            clc
            adc pwvcml,x
            sta pwvcml,x
            tya
            adc pwvcmh,x
            sta pwvcmh,x
aftrpw:
            lda tsrflg,x
            bpl pfcswp
            jmp exit1 ;is rest

; process filter cutoff sweep

pfcswp:
            ldy #0
            lda fcswp,x
            beq exit1
            bpl skip21
            iny ;to $01
skip21:
            clc
            adc sfcl
            pha                 ;save overflow
            and #$07
            sta sfcl
            pla                 ;retrieve overflow
            ror a               ;include carry
            lsr a
            lsr a
            clc
            adc fcswtb,y        ;extend sign
            clc
            adc sfch
            sta sfch

exit1:
            rts


; note processing

; process note

nproc:
nproc2:
            lda comadl,x
            sta comptr          ;set zero page pointer
            lda comadh,x
            sta comptr+1
            bne mloop           ;always
exit2:
            rts
comand:
            jsr cproc           ;call command processing ;***vcproc
mloop:
            lda status
            and bitab,x
            beq exit2           ;return if halt or error

            ldy #$00
            lda (comptr),y      ;get next command
            sta temp            ;save first byte
            iny
            lda (comptr),y
            tay                 ;save second byte

            lda comptr
            clc
            adc #$02
            sta comptr          ;point to next command
            sta comadl,x
            lda comptr+1
            adc #$00
            sta comptr+1
            sta comadh,x

            lda temp            ;first byte
            and #$03
            bne comand          ;branch if not new note

            lda ftargl,x        ;force frequency to target
            sta sfreql,x
            lda ftargh,x
            sta sfreqh,x

            lda temp
            sta ndurat,x        ;save duration data
            tya                 ;second byte
            sta npitch,x        ;save pitch data
            and #$07
            tay
            lda dshflt-1,y
            sta acctbl
            lda npitch,x
            and #$38            ;preserve octave bits
            lsr a
            lsr a
            lsr a               ;clears carry
            adc octtps,x        ;transpose
            sta octtmp

            lda npitch,x
            and #$c0            ;preserve accidental bits
            asl a
            rol a
            rol a               ;clears carry
            tay
            lda acctbl,y
            sta hstmp           ;save for later
            lda npitch,x
            and #$07            ;get note selection (c to b)
            beq brdg3           ;branch if rest
            tay
            lda hstabl-1,y
            adc hstmp           ;add in accidental
            clc
            adc hstps,x         ;transpose
            bpl skip14
            clc
            adc #12
            inc octtmp          ;one octave lower
skip14:
            cmp #12
            bcc skip15
            sbc #12             ;carry set from branch
            dec octtmp          ;one octave higher
skip15:
            sta hstmp           ;for autofilter
            tay                 ;note index

            lda ftabh,y         ;get new frequency hi
            sta temp
            lda ftabl,y         ;get new frequency lo
            ldy octtmp
            dey
            bmi adddtn          ;branch if octave seven
floop:
            lsr temp
            ror a               ;divide frequency by one octave
            dey
            bpl floop
adddtn:
            clc
            adc detunl,x        ;add in frequency offset
            sta ftargl,x
            lda temp
            adc detunh,x
            sta ftargh,x

            lda ndurat,x
            bne skip22          ;skip around
            jmp nproc2          ;abs comm - reset comptr

skip22:
            lda gratel,x
            ora grateh,x
            beq transf          ;branch if glide not selected
setgl:
            lda sfreql,x
            cmp ftargl,x        ;calculate direction
            lda sfreqh,x
            sbc ftargh,x
            lda #$fe
            ror a               ;direction into top bit
            sta glproc,x
            bcc chekts          ;always
brdg3:
            beq setdur
transf:
            sta glproc,x        ;stop glide

            lda ftargl,x
            sta sfreql,x        ;force frequency to target
            lda ftargh,x
            sta sfreqh,x
chekts:
            lda tsrflg,x
            asl a               ;eliminate rest flag
            bne setdur          ;previous note tied/slurred
chekpw:
            lda pwswpl,x
            beq chekfc          ;not sweeping pulse width
            lda pwrstl,x
            sta spwl,x
            lda pwrsth,x
            sta spwh,x
chekfc:
            lda autofc,x
            beq ckswp           ;auto filter set not selected
            ldy octtmp
            clc
            adc fcoctb,y
            ldy hstmp
            clc
            adc fchstb,y
            clc
            bcc setfc           ;always
ckswp:
            lda fcswp,x
            beq setdur          ;not sweeping filter cutoff
            lda fcrsth,x
setfc:
            sta sfch
            lda #0
            sta sfcl
setdur:
            lda hldrst,x        ;***
            sta hldctr,x        ;***

            lda ndurat,x
            and #$40
            sta tsrflg,x        ;remember tie
            lda ndurat,x
            lsr a
            lsr a
            and #$07
            bne stdus2          ;not 64th type
            lda ndurat,x
            bmi stdus1          ;is 64th triplet
            lda durw
            and #$3c
            bne err1b
            lda durw
            asl a
            rol a
            rol a
            bne gtdusk
            lda #4
gtdusk:
            jmp gotdur
stdus1:
            lda durtri
            beq err1b
            and #$3f
            bne err1b
            lda durtri
            asl a
            rol a
            rol a
            bne gotdur          ;always
err1b:
            lda #$10
            sta status
            rts
stdus2:
            cmp #$01
            bne stdus4          ;is not utility
            lda ndurat,x
            and #$20
            bne stdus3          ;is not utl
            lda duru
            jmp gotdur
stdus3:
            lda durutv,x
            jmp gotdur
stdus4:
            tay
            lda ndurat,x
            and #$a0
            cmp #$80
            beq stdus6          ;is triplet
            sta temp
            clc
            lda durw
            bne stdus5          ;not tem 56
            sec
stdus5:
            dey
            dey
            beq adddot
stdul1:
            ror a
            bcs err1
            dey
            bne stdul1
adddot:
            ldy temp
            sta temp
            beq gotdur
            lsr temp
            bcs err1
            beq err2            ;***is tem 56
            adc temp            ;carry is clear
            bcs err2
            iny
            bpl gotdur
            lsr temp
            bcs err1
            adc temp            ;carry is clear
            bcc gotdur
            bcs err2            ;always
stdus6:
            lda durtri
            beq err1
            dey
            dey
            beq gotdur
stdul2:
            lsr a
            bcs err1
            dey
            bne stdul2
gotdur:
            sta durctr,x        ;set new frame count

            lda sctl,x
            and #$f6
            sta sctl,x          ;reset (no gate)

            sec
            lda npitch,x
            and #$07
            bne skip4           ;branch if not rest
            ror tsrflg,x        ;set rest, clear carry
skip4:
            lda sctl,x
            adc #$00            ;add in gate if not rest
            sta sctl,x
vexit:
            rts                 ;end of note processing
err1:
            lda #$10            ;illegal duration
            .byte $2c           ;hide next instruction
err2:
            lda #$18            ;duration overflow
            sta status
            rts


; command processing

cproc:
            tya ;get second byte
            pha ;save for later
            lda temp ;get first byte
            lsr a
            bcc skip23 ;skip around
            jmp com13
skip23:
            lsr a ;disregard normal note bit code
            lsr a
            bcs ckn ;not twelve bit command
            lsr a
            bcs setdtn

; set pulse width

setpw:
            sta pwrsth,x
            sta spwh,x
            pla
            sta pwrstl,x
            sta spwl,x
            rts

; set detune (frequency offset)

setdtn:
            lsr a ;sign bit into carry
            bcc skip5 ;branch if positive
            ora #$f8 ;extend negation
skip5:
            sta detunh,x
            pla
            sta detunl,x
            rts

ckn:
            lsr a
            bcs cknb
            jmp ck8 ;eight bit command
cknb:
            lsr a
            bcs ckmsjf ;process ms# or jif
            lsr a
            bcs ckrtsc ;check rtp or sca
            bne phld ;***

; set filter cutoff

            pla
            sta fcrsth,x
            sta sfch
            rts

; set hold time

phld:
            pla
            sta hldrst,x
            rts

ckrtsc:
            bne psca

; process relative transpose

prtp:
            pla
            sta savrtp,x
            cmp #91
            beq prtps3 ;rtp 0
            tay  ;save
            lsr a
            lsr a
            lsr a
            sec
            sbc #11
            clc
            adc hstps,x
            bmi prtps1
            cmp #12
            bcc prtps2
            sbc #12 ;carry is set
            dec octtps,x
            jmp prtps2
prtps1:
            cmp #245
            bcs prtps2
            adc #12 ;carry is clear
            inc octtps,x
prtps2:
            sta hstps,x
            tya
            and #$07
            sec
            sbc #3
            clc
            adc octtps,x
            sta octtps,x
            rts
prtps3:
            lda svoctp,x
            sta octtps,x
            lda svhstp,x
            sta hstps,x
            rts

; process modulation scale

psca:
            pla
            sta lfosca,x
            rts

ckmsjf:
            lsr a
            bcs pjif

; process measure marker

pms:
            sta msnumh,x
            pla
            sta msnuml,x
            rts

; set jiffy length

pjif:
            lsr a
            ror a
            ror a ;clears carry
            adc systim
            sta jiftim
            pla
            adc systim+1
            sta jiftim+1
            rts

ck8:
            lsr a
            bcc ck8b
            jmp p8xxx1
ck8b:
            lsr a
            bcs p8xx10
            lsr a
            bcs p8x100
            lsr a
            bcs pvdp

; set tempo (whole note duration)

ptem:
            pla
            sta durw
            lsr a
            lsr a
            lsr a
            tay
            lda dur3tb,y
            sta durtri
            rts

; set vibrato depth

pvdp:
            pla
            sta newrst,x
            rts

p8x100:
            lsr a
            bcs ppvd

; set flag

pflg:
            pla
            sta flag
            rts

; set pulse width vibrato depth

ppvd:
            pla
            beq ppvds2 ;stopping
            sta newpwd,x
            ldy pwvdep,x
            bne ppvds1 ;branch if already on
            sta pwvdep,x ;starting
            lda #1
            sta pwvctr,x ;force reload next jiffy
ppvds1:
            rts
ppvds2:
            sta pwvdep,x ;0  stop immediately
            sta pwvcml,x ;***
            sta pwvcmh,x ;***
            rts

p8xx10:
            lsr a
            bcs p8x110
            lsr a
            bcs ptps

; set release point

ppnt:
            pla
            sta relpt,x
            rts

; set transpose value

ptps:
            pla
            ldy #0
            lsr a
            bcc skip17
            iny ;to $01
            clc
skip17:
            pha
            and #$07
            adc tpstb1,y ;octaves
            sta svoctp,x
            sta octtps,x
            pla
            lsr a
            lsr a
            lsr a
            clc
            adc tpstb2,y ;half steps
            sta svhstp,x
            sta hstps,x
            lda #91 ;***
            sta savrtp,x
            rts

p8x110:
            lsr a
            bcs pmax

; set filter cutoff sweep rate

stfcsw:
            pla
            sta fcswp,x
            rts

; set modulation max

pmax:
            pla
            sta lfomax
            rts

p8xxx1:
            lsr a
            bcs p8xx11
            lsr a
            bcs p8x101
            lsr a
            bcs paut

; set utility duration

putl:
            pla
            sta duru
            rts

; set automatic filter mode

paut:
            pla
            sta autofc,x
            rts

p8x101:
            lsr a
            bcs ppvr

; set pulse width sweep

stpwsw:
            pla
            sta pwswpl,x
            ldy #0
            asl a ;get sign
            bcc skip6
            dey ;to $ff
skip6:
            tya
            sta pwswph,x
            rts

; set pulse width vibrato rate

ppvr:
            pla
            sta newpwr,x
            rts

p8xx11:
            lsr a
            bcs p8x111
            lsr a
            bcs paux

; repeat head

phed:
            pla
            sta rptctr,x ;set iteration counter
            lda comptr
            sta rptadl,x ;save reloop address
            lda comptr+1
            sta rptadh,x
            lda invoic,x
            sta rptvoc,x
            rts

; call auxiliary machine code

paux:
            pla
            ;jmp (vpatch)
            rts
p8x111:
            lsr a
            bcs putv

; set vibrato rate

pvrt:
            pla
            bne skip18
            sta vibrat,x ;0  stop immediately
            sta vibcml,x ;***
            sta vibcmh,x ;***
            rts
skip18:
            sta newrat,x
            ldy vibrat,x
            bne skip16 ;branch if already on
            sta vibrat,x ;starting
;  tya ;zero ;***necc?
;  sta vibcml,x ;clear accumulation ;***necc?
;  sta vibcmh,x ;***necc?
            lda #1
            sta vibctr,x ;force reload next frame
skip16:
            rts

; set utility-voice duration

putv:
            pla
            sta durutv,x
            rts

com13:
            lsr a
            bcc com1

; set portamento rate

            sta grateh,x
            pla
            sta gratel,x
            rts

com1:
            pla ;get second byte
            lsr a
            bcs brdg2 ;to ck1
            lsr a
            bcs ck4

; set envelope values

            lsr a
            bcs skip7 ;branch if upper nibble
            lsr a ;byte number into carry
            ldy #$f0
            bne skip8 ;always
skip7:
            asl a
            asl a
            asl a
            asl a ;byte number into carry
            ldy #$0f
skip8:
            sta temp
            tya
            bcs ssrl ;branch if second byte
            and satdc,x
            ora temp
            sta satdc,x
            rts
ssrl:
            and sssrl,x
            ora temp
            sta sssrl,x
            rts
ck4:
            lsr a
            bcs ckpdef
            lsr a
            bcs setres

; call phrase

cal2:
            sta temp ;save phrase number
            lda stkptr,x
            cmp stkmax,x
            beq err3 ;branch if stack full
            inc stkptr,x
            tay
            lda comptr
            sta stackl,y ;save return address
            lda comptr+1
            sta stackh,y
            lda invoic,x
            sta vocstk,y
            ldy temp ;retrieve phrase number
            lda phradh,y ;get phrase address
            beq err6 ;branch if phrase undefined
            sta comptr+1
            lda phradl,y
            sta comptr
            lda phrvoc,y
            sta invoic,x
            rts

brdg2:
            bcs ck1

ckpdef:
            lsr a
            bcs setvol

; phrase definition

def2:
            tay ;use phrase number as index
            lda comptr
            sta phradl,y
            lda comptr+1
            sta phradh,y
            lda invoic,x
            sta phrvoc,y
            lda stkptr,x
            cmp stkmax,x
            beq err3
            inc stkptr,x
            tay
            lda #$00
            sta stackh,y
            rts
err6:
            lda #$30 ;undefined phrase call
            .byte $2c ;hide next instruction
err3:
            lda #$28 ;stack overflow
            sta status
            rts

; set resonance

setres:
            asl a
            asl a
            asl a
            asl a
            eor srf
            and #$f0
            eor srf
            sta srf
            rts ;***bcc setrf ;always

; set master volume

setvol:
            eor smv
            and #$0f
            eor smv
            sta smv
            rts

ck1:
            lsr a
            bcs ck1c
            lsr a
            bcs prdn

; set modulation rate up

prup:
            sta lforup
            rts

; set modulation rate down

prdn:
            sta lfordn
            rts

ck1c:
            lsr a
            bcc ck1b
            jmp ck3
ck1b:
            lsr a ;data bit into carry ;*****
            tay
            beq pbump
            dey
            beq pfilt
            dey
            beq prmod
            dey
            beq psync
            dey
            beq pfext
            dey
            beq poff3 ;***
            dey
            beq plfo
            dey
            beq ppandv

; process phrase cal and def 16-23

            and #$07
            ora #$10
            bcs pcal2
            jmp def2
pcal2:
            jmp cal2

; bump master volume

pbump:
            ldy smv
            bcs voldec ;branch if decreasing
            iny
            tya
            and #$0f
            bne setmv1
            rts
voldec:
            tya
            and #$0f
            beq exit6
            dey
setmv1:
            sty smv
exit6:
            rts

; pass voice through filter

pfilt:
            lda bitab,x
            eor #$ff
            and srf
            bcc pfltsk
            ora bitab,x
pfltsk:
            sta srf ;bcs setrf ;always
            rts

; set ring modulation

prmod:
            lda sctl,x
            and #$fb
            bcc stsctl
            ora #$04
            bcs stsctl ;always

; set sync mode

psync:
            lda sctl,x
            and #$fd
            bcc stsctl
            ora #$02
            bcs stsctl ;always

; pass external through filter

pfext:
            lda srf
            and #$f7
            bcc setrf
            ora #$08
setrf:
            sta srf
            rts

; set voice three on/off

poff3:
            lda smv
            and #$7f
            bcc setmv2
            ora #$80
setmv2:
            sta smv
            rts

; set lfo type

plfo:
            tya ;0
            sta lfoval
            sta lfodir
            iny ;1
            sty lfoctr
            rol a
            sta lfotyp
            rts

; set portamento and vibrato on/off

ppandv:
            tya ;0
            rol a
            sta pandv,x
            rts

ck3:
            lsr a
            bcs ck0
            lsr a
            bcs setfm

; set waveform

            bne skip9
            lda #$08 ;set to noise
skip9:
            asl a
            asl a
            asl a
            asl a
            eor sctl,x
            and #$f0
            eor sctl,x
stsctl:
            sta sctl,x
            rts

; set filter mode

setfm:
            asl a
            asl a
            asl a
            asl a
            eor smv
            and #$70
            eor smv
            sta smv
            rts
ck0:
            lsr a
            bcc ck0b

; set modulation source

psrc:
            sta lfosrc,x
            rts

ck0b:
            tay
            beq ptal
            dey
            beq pend
            dey
            beq phlt

; set modulation destination

pdst:
            and #$03
            sta lfodst,x
            lda #0
            sta lfofrl,x
            sta lfofrh,x
            sta lfopwl,x
            sta lfopwh,x
            sta lfofcl
            sta lfofch
            rts

; repeat tail

ptal:
            lda rptctr,x
            beq rpeat ;infinite looping
            dec rptctr,x
            beq exit3 ;loop done
rpeat:
            lda invoic,x
            cmp rptvoc,x
            bne err7
            lda rptadl,x
            sta comptr ;reloop
            lda rptadh,x
            sta comptr+1
exit3:
            rts
err7:
            lda #$38
            sta status ;hed in wrong voice
            rts

; phrase end

pend:
            lda stkptr,x
            cmp stkmin,x
            beq err4 ;branch if stack empty
            dec stkptr,x
            tay
            dey
            lda stackh,y
            beq exit4 ;in definition mode
            sta comptr+1
            lda stackl,y
            sta comptr
            lda vocstk,y
            sta invoic,x
exit4:
            rts
err4:
            lda #$20 ;stack underflow
            sta status
            rts

; stop voice processing

phlt:
            lda status
            eor bitab,x
            sta status
            lda #1
            sta durctr,x ;ready to continue
            rts

; ---------------------------------------------------------------------------
stopplay:
                LDA     status
                AND     #7
                STA     doplay1+1
                BNE     locret_EC5E
                JSR     hush
locret_EC5E:
                RTS

.endscope
