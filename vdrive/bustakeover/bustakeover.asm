

opcodeBITAbs            = $2c

;Error Codes
XerrorNoAtnAck          = $01
XerrorDeviceBusy        = $02
XerrorNoEoiAck          = $03
XerrorNoEoiEndAck       = $04
XerrorNoByteAck         = $05
XerrorNoTurnAck         = $06
XerrorTalkerBusy        = $07
XerrorMissingDataSetup  = $08
XerrorMissingDataHold   = $09
XerrorBusProblem        = $0a

SRDshift            = $09
SRDshiftcount       = $0a
SRDeoi              = $0b
SRDptr              = $ae
SRDptrlen           = $ac
SRDptrcnt           = $ad

SRDcurdev           = $ba
SRDgetstatustmp     = $80

;-------------------------------------------------------------------------------

                * = $0801

               !word Lnullbasicline ; ptr to next line
               !word 1              ; line-num
               !byte $9e            ; sys

               !byte $30 + (Lteststartup / 1000)
               !byte $30 + (Lteststartup % 1000) / 100
               !byte $30 + ((Lteststartup % 1000) % 100) / 10
               !byte $30 + (((Lteststartup % 1000) % 100) % 10)

               !byte 00
Lnullbasicline:
               !byte 00,00

;-------------------------------------------------------------------------------

                * = $0810
Lcommonserialstart:

SRDdelay:      dex
               bne SRDdelay
               rts

SRDpAtn:       lda $dd00
               ora #$08
               sta $dd00
               rts

SRDpClk:       lda $dd00
               ora #$10
               sta $dd00
               rts

SRDpDat:       lda $dd00
               ora #$20
               sta $dd00
               rts

SRDrAtn:       lda $dd00
               and #$f7
               sta $dd00
               rts

SRDrClk:       lda $dd00
               and #$ef
               sta $dd00
               rts

SRDrDat:       lda $dd00
               and #$df
               sta $dd00
               rts

SRDreaddatstable:
               lda $dd00
               cmp $dd00
               bne SRDreaddatstable
               asl
               rts

; these 4 wait functions don't
; look pretty, but return
; both linestates in n,v flags,
; all sampled at the same time
; as well as timeout info in cy.

SRDwclk1:      lda #$c0
               clc
SRDwclk1loop:  dex
               beq SRDtimeout
               bit $dd00
               bvc SRDwclk1loop
               rts

SRDwclk0:      lda #$c0
               clc
SRDwclk0loop:  dex
               beq SRDtimeout
               bit $dd00
               bvs SRDwclk0loop
               rts 

SRDwdat0:      lda #$c0
               clc
SRDwdat0loop:  dex
               beq SRDtimeout
               bit $dd00
               bmi SRDwdat0loop
               rts 

SRDwdat1:      lda #$c0
               clc
SRDwdat1loop:  dex
               beq SRDtimeout
               bit $dd00
               bpl SRDwdat1loop
               rts 

SRDtimeout:    sec
               rts


XerrSrcSndAtn       = $10;
XerrSrcSndByt       = $20;
XerrSRDsendATNbyte  = $30;
XerrSRDreqListenCh  = $40;
XerrSRDreqTalkChErr = $50;

SRDerrlog:     sec
               rts

SRDsndAtn:     jsr SRDrDat
               jsr SRDpAtn
               jsr SRDpClk
               ldx #$c8 ;200x5
               jsr SRDdelay
               ldx #$02
               jsr SRDwdat0
               bcc SRDsndAtndone
               jsr SRDrAtn
               lda # XerrorNoAtnAck+XerrSrcSndAtn
               jmp SRDerrlog
SRDsndAtndone: rts

; The sendbyte part is a cycle accurate copy
; of the C64 rom. Given that devices like
; the 1541 floppy sample bus lines
; very infrequent relative to the given
; code snipet's runtime, we could only
; make things worse here (eithr lesss
; compatible or slower). For example,
; when the 1541 waits for data setup
; phase, it scans the bus every 50us, 
; only. that's a huge number compared
; to the about 94 cycles the given 
; snippet might take per full bus cycle. 


SRDsendbyte:
;###########
                 php
                 sei 
                 jsr SRDrDat
                 JSR SRDreaddatstable 
                 BCS SRDsndbusprob 
                 JSR SRDrClk 
                 lda SRDeoi
                 beq SRDsndwaitrfd
SRDsndwaiteoi:   JSR SRDreaddatstable 
                 BCC SRDsndwaiteoi 
SRDsndwaiteeoi:  JSR SRDreaddatstable 
                 BCS SRDsndwaiteeoi 
SRDsndwaitrfd:   JSR SRDreaddatstable
                 BCC SRDsndwaitrfd

                 JSR SRDpClk
                 LDA #$08 
                 STA SRDshiftcount
SRDcbmsendbit:   LDA $DD00 
                 CMP $DD00 
                 BNE SRDcbmsendbit 
                 ASL 
                 BCC SRDsndbusprob
                 ROR SRDshift
                 BCS SRDcbmsend1
SRDcbmsend0:     JSR SRDpDat 
                 BNE SRDcbmsendclk
SRDcbmsend1:     JSR SRDrDat
SRDcbmsendclk:   JSR SRDrClk 
                 nop
                 nop
                 nop
                 nop     
                 LDA $DD00 
                 AND #$DF  ; release dat
                 ORA #$10  ; pull clk
                 STA $DD00 
                 DEC SRDshiftcount
                 BNE SRDcbmsendbit
                 ldx #$20; 64x13
                 jsr SRDwdat0
                 ldx #$5c
                 jsr SRDwdat0
                 bcs SRDsndnobyteack
                 plp
                 rts

; error handling
SRDsndbusprob:   lda # XerrSrcSndByt + XerrorBusProblem     
SRDsndbyteerr:   plp ; cli
                 jmp SRDerrlog
SRDsndnobyteack: lda # XerrSrcSndByt + XerrorNoByteAck
                 bne SRDsndbyteerr ; unconditional

SRDrcvbyte:
;##########
               php
               sei
               JSR SRDrClk
               lda #$00
               sta SRDeoi
SRDrcvbusywt:  ldx #$ff
               jsr SRDwclk1
               bcs SRDrcvbusywt
SRDchkEoi:     jsr SRDrDat
               ldx #$18
               jsr SRDwclk0               
               bcc SRDrcvbits
               jsr SRDpDat
               ldx #$10
               stx SRDeoi
               jsr SRDdelay
               jsr SRDrDat

SRDrcvbits:
               lda #$08
               sta SRDshiftcount

SRDrcvcbmw1:   LDA $DD00 
               CMP $DD00 
               BNE SRDrcvcbmw1 
               ASL 
               BPL SRDrcvcbmw1 ; repeat if clk still high (port low)
               ROR SRDshift              
SRDrcvcbmw2:   LDA $DD00 
               CMP $DD00 
               BNE SRDrcvcbmw2 
               ASL 
               BMI SRDrcvcbmw2 ; repeat if clk still low (port high)
               DEC SRDshiftcount 
               BNE SRDrcvcbmw1 

               jsr SRDpDat 
               lda SRDshift
               plp
               clc
               rts

SRDsendSAlisten:
;###############
               sta SRDshift
               jsr SRDsendbyte
               jsr SRDrAtn ; cy not mod
               rts

SRDsendSATalk:
;#############
               php
               sei
               sta SRDshift
               jsr SRDsendbyte
               ;jsr SRDpDat
               ;lda $dd00
               ;and #$f7 ; release atn
               ;sta $dd00
               ;and #$ef ; release clk
               ;sta $dd00
               jsr SRDpDat
               jsr SRDrAtn
               jsr SRDrClk ; 1541 doesn't wait for this
SRDsendSATw:   jsr SRDreaddatstable ; wait for clk lo
               bmi SRDsendSATw      ; despite we've released it 
               plp
               clc
               rts

PROBLEMATICSRDsendSATalk:
;#############
               php
               sei
               sta SRDshift
               jsr SRDsendbyte
               ;jsr SRDpDat
               lda $dd00
               and #$f7 ; release atn
               sta $dd00
               and #$ef ; release clk
               sta $dd00
               jsr SRDpDat
               jsr SRDrAtn
               jsr SRDrClk ; 1541 doesn't wait for this
PSRDsendSATw:  jsr SRDreaddatstable ; wait for clk lo
               bmi PSRDsendSATw     ; despite we've released it 
               plp
               clc
               rts

SRDsendATNbyte:
;##############

               ora SRDcurdev
               sta SRDshift
               lda #$00
               sta SRDeoi
               jsr SRDsndAtn
               bcs SRDsndATNberr
               jsr SRDsendbyte
               bcc SRDsndATNbrts
SRDsndATNberr: jsr SRDrAtn
               lda # XerrSRDsendATNbyte
               jmp SRDerrlog
SRDsndATNbrts: rts

SRDreqUnTalk:
;############
               lda #$5f
               bne SRDreq1byte

SRDreqUnlisten:
;##############

               lda #$3f
SRDreq1byte:
               jsr SRDsendATNbyte
               jsr SRDrAtn
               rts

SRDreqCloseCh:
;#############

               ora #$e0
               jsr SRDreqListenCh_altin
               jmp SRDreqUnlisten

SRDreqOpenCh:
;############
               ora #$f0
               ldy SRDptrlen
               bne SRDreqOpenChSkip
               ldx #$ff
               ;stx SRDeoi 
SRDreqOpenChSkip:
               jsr SRDreqListenCh_altin
               jsr SRDsndStr
               jmp SRDreqUnlisten

SRDreqListenCh:
;##############

               ora #$60
SRDreqListenCh_altin:
               pha
               lda #$20
               jsr SRDsendATNbyte
               pla
               bcs SRDreqLstChErr
               jsr SRDsendSAlisten
               bcs SRDreqLstChErr
               rts
SRDreqLstChErr:
               lda # XerrSRDreqListenCh
               jmp SRDerrlog

SRDreqTalkCh:
;############
               ora #$60
               pha
               lda #$40
               jsr SRDsendATNbyte
               pla
               bcs SRDreqTalkChErr

Ltestprobcall:  ;refpos to apply test patch here #################

               jsr SRDsendSATalk
               bcs SRDreqTalkChErr
               rts
SRDreqTalkChErr:
               lda # XerrSRDreqTalkChErr
               jmp SRDerrlog

SRDsndStr:
;#########
               lda #$00
               sta SRDptrcnt
               lda SRDptrlen
               beq SRDsendstrrts

SRDsndStrloop: ldy SRDptrcnt
               iny
               sty SRDptrcnt
               cpy SRDptrlen
               beq SRDsndStrlast
               dey
               lda (SRDptr),y
               jsr SRDsendchar
               jmp SRDsndStrloop

SRDsndStrlast: dey
               lda (SRDptr),y
               jmp SRDsendlastchar
SRDsendstrrts: clc
               rts

SRDsendlastchar:
               ldx #$ff
               stx SRDeoi
SRDsendchar:   sta SRDshift
               jmp SRDsendbyte

SRDgetstatus:
;################
               lda #$0f
               jsr SRDreqTalkCh
               jsr SRDrcvbyte
               rol
               rol
               rol
               rol
               and #$f0
               sta SRDgetstatustmp
               jsr SRDrcvbyte
               and #$0f
               ora SRDgetstatustmp
               sta SRDgetstatustmp
SRDgetstatusloop:
               jsr SRDrcvbyte
               lda SRDeoi
               beq SRDgetstatusloop
               jsr SRDreqUnTalk
               lda SRDgetstatustmp
               cmp #$20
               rts

Lcommonserialend:

Ltestfn: 
                !pet "testseq,s,r"
Ltestfnend:
LtestBytesRead: !byte 0,0
Ltestch         = 7

Ltestloadputbyte:
               inc $0400
               inc LtestBytesRead
               beq LtestloadputbyteskipIncHiByte
               inc LtestBytesRead+1
LtestloadputbyteskipIncHiByte:
               rts

Ltestload:
               lda #0
               sta LtestBytesRead
               sta LtestBytesRead+1
               lda #<Ltestfn
               sta SRDptr
               lda #>Ltestfn
               sta SRDptr+1
               lda #Ltestfnend-Ltestfn
               sta SRDptrlen
               lda #Ltestch
               jsr SRDreqOpenCh
               jsr SRDgetstatus
               bcs LtestloadfileNotFound
               lda #Ltestch

               jsr SRDreqTalkCh
               bcs Ltestloadfiledone
Ltestloadfileloop:
               jsr SRDrcvbyte
               jsr Ltestloadputbyte
               lda SRDeoi
               beq Ltestloadfileloop
Ltestloadfiledone:
               jsr SRDreqUnTalk
               lda #Ltestch
               jsr SRDreqCloseCh
               clc
               rts
LtestloadfileNotFound:
               sec
               rts

;-------------------------------------------------------------------------------

Ltestruns       = 16
Ltestruncnt:    !byte 0

Ltestdotest:
               lda #Ltestruns
               sta Ltestruncnt
Ltestloop1:    jsr Ltestload
               bcs Ltesterrloop
               ldx Ltestruncnt
               lda #'*'
statline=*+1
               sta $03ff+40,x
               dec Ltestruncnt
               bne Ltestloop1
               rts

Ltesterrloop:

               ; failed
               lda #2
               sta $d020
               lda #$ff
               sta $d7ff

               jmp *

Ltestdoproblematictest:
               lda #<PROBLEMATICSRDsendSATalk
               sta Ltestprobcall+1
               lda #>PROBLEMATICSRDsendSATalk
               sta Ltestprobcall+2
               lda #<($03ff+80)
               sta statline
               jmp Ltestdotest


Lteststartup:
                ldx #0
                stx $d020
                stx $d021
-
                lda #1
                sta $d800,x
                sta $d900,x
                sta $da00,x
                sta $db00,x
                lda #$20
                sta $0400,x
                sta $0500,x
                sta $0600,x
                sta $0700,x
                inx
                bne -

               lda SRDcurdev
               bne Lteststartupskipdefault
               lda #8
Lteststartupskipdefault:
               sta SRDcurdev
               jsr Ltestdotest

               jsr Ltestdoproblematictest

               ; success
               lda #5
               sta $d020
               lda #0
               sta $d7ff

               jmp *
Ltestend:
