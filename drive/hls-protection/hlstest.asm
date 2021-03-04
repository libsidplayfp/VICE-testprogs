MW_DATA_LENGTH  = $20                   ;Bytes in one M/W command
drvstart        = $0300
trk             = 17
fa              = $ba


expect_ptr      = $40
expect_count    = $41
result_ptr      = $42
result_count    = $43

ciout           = $ffa8                 ;Kernal routines
listen          = $ffb1
second          = $ff93
unlsn           = $ffae
talk            = $ffb4
tksa            = $ff96
untlk           = $ffab
acptr           = $ffa5
chkin           = $ffc6
chkout          = $ffc9
chrin           = $ffcf
chrout          = $ffd2
close           = $ffc3
open            = $ffc0
setmsg          = $ff90
setnam          = $ffbd
setlfs          = $ffba
clrchn          = $ffcc
getin           = $ffe4
load            = $ffd5
save            = $ffd8

k_plot_set	= $fff0
k_getin		= $ffe4
k_chrout	= $ffd2
b_print_str	= $e716
b_clr_line	= $e9ff

black		= 0
white		= 1
red			= 2
cyan		= 3
violet		= 4
green		= 5
blue		= 6
yellow		= 7
orange		= 8
brown		= 9
lightred	= 10
grey1		= 11
grey2		= 12
lightgreen	= 13
lightblue	= 14
grey3		= 15

            * = $0801

            .word zeroes, 2021
            .byte $9e
            .text format("%d", start)
zeroes      .byte 0, 0, 0

start:
                lda fa
                bne +
                lda #$08
                sta fa
+               jsr listen
                lda #$6f
                jsr second
                lda #"i"
                jsr ciout
                jsr unlsn
                ldx #0
                ldy #0
-               dex
                bne -
                dey
                bne -

                lda #<drivecode_c64
                ldx #>drivecode_c64
                ldy #(drivecodeend_drv-drivecode_drv+MW_DATA_LENGTH-1)/MW_DATA_LENGTH

;=============================
; upload drive code
;=============================
il_begin:       sta il_senddata+1
                stx il_senddata+2
                sty loadtempreg         ;Number of "packets" to send
                lda #>drvstart
                sta il_mwstring+1
                ldy #$00
                sty il_mwstring+2       ;Drivecode starts at lowbyte 0
                beq il_nextpacket
il_sendmw:      lda il_mwstring,x       ;Send M-W command (backwards)
                jsr ciout
                dex
                bpl il_sendmw
                ldx #MW_DATA_LENGTH
il_senddata:    lda $bdbd,y             ;Send one byte of drivecode
                jsr ciout
                iny
                bne il_notover
                inc il_senddata+2
il_notover:     inc il_mwstring+2       ;Also, move the M-W pointer forward
                bne il_notover2
                inc il_mwstring+1
il_notover2:    dex
                bne il_senddata
                jsr unlsn               ;Unlisten to perform the command
il_nextpacket:  lda fa                  ;Set drive to listen
                jsr listen
                lda #$6f
                jsr second
                ldx #$05
                dec loadtempreg         ;All "packets" sent?
                bpl il_sendmw
                jsr unlsn
                
;==============================
; execute drive code
;==============================
exec_drvcode:
                lda fa
                jsr listen
                lda #$6f
                jsr second
                ldx #$05
il_sendme:      lda il_mestring,x       ;Send M-E command (backwards)
                jsr ciout
                dex
                bpl il_sendme
                jsr unlsn               ;Start drivecode


                ldx #$3f                ;copy the right table in based on track
                lda sel_track
                cmp #18
                bcs copy_high_track
-               lda expected1,x
                sta expected,x
                dex
                bpl -
                bmi print_results
copy_high_track:
                lda expected18,x
                sta expected,x
                dex
                bpl copy_high_track

print_results:
                lda #$00
                sta expect_ptr

                lda #$93                ;cls
                jsr k_chrout
                ldx #$00
-               lda header,x
                beq +
                jsr k_chrout
                inx
                bne -

+               ldx #$00
                ldy #$00
il_delay:       inx                     ;Delay to make sure the test-
                bne il_delay            ;drivecode executed to the end
                iny
                bpl il_delay

                lda #<result
                sta rslt+1
                lda #>result
                sta rslt+2
                lda #>$04c0
                sta il_mrstring+1
                lda #<$04c0
                sta il_mrstring+2
                jsr read_result
                lda #>$04e0
                sta il_mrstring+1
                lda #<$04e0
                sta il_mrstring+2
                jsr read_result

                ldx #$3f
-               lda result,x
                cmp expected,x
                bne prot_failed
                dex
                bpl -

                lda #green
                .byte $2c
prot_failed:
                lda #red
                sta $d020

                ldy #0
                cmp #red
                bne +
                ldy #$ff
+
                sty $d7ff

                ldx #$00
-               lda qst,x
                beq +
                jsr k_chrout
                inx
                bne -

+               lda sel_track
                jsr hexify
                jsr wait_key
                cmp #$03
                bne +
                rts                     ;run/stop exits
+               cmp #$2d                ;-
                bne +
                ldx sel_track
                dex
                bne set_trk
                inx
                bne set_trk
+               cmp #$2b                ;+
                bne +
                ldx sel_track
                inx
                cpx #25
                bcc set_trk
                dex
set_trk:
                stx sel_track
+               jmp exec_drvcode

;=============================
; read result
;=============================
read_result:
                lda fa                  ;Set drive to listen
                jsr listen
                lda #$6f
                jsr second
                ldx #$05
il_ddsendmr:    lda il_mrstring,x       ;Send M-R command (backwards)
                jsr ciout
                dex
                bpl il_ddsendmr
                jsr unlsn

                lda fa                  ;prep to receive bytes
                jsr talk
                lda #$6f
                jsr tksa

                lda #$00
                sta result_ptr

next_sector:
                jsr print_expected
                lda #4
                sta result_count
getabyte:
                jsr acptr               ;First byte: test value
rslt:
                sta result
                jsr hexify
                lda #$20
                jsr k_chrout

+               inc rslt+1
                bne +
                inc rslt+2
+               inc result_ptr
                lda result_ptr
                cmp #$20
                beq done_pkg1

                dec result_count
                bne +
                lda #$0d
                jsr k_chrout            ; print a CR after every 4 bytes
                jmp next_sector
+               jmp getabyte

done_pkg1:
                lda #$0d
                jsr k_chrout
                jmp untlk


print_expected:
                ldx #4
                stx expect_count

-               ldx expect_ptr
                lda expected,x
                jsr hexify
                lda #$20
                jsr k_chrout
                inc expect_ptr
                dec expect_count
                bne -
                
                lda #$20
                jsr k_chrout
                jsr k_chrout
                jsr k_chrout
                jmp k_chrout

	
hexify:
                ldy #$00
                tax
                lsr
                lsr
                lsr
                lsr
                jsr hexc							; convert upper nibble
                jsr output
                txa
                and #$0f							; convert lower nibble
                jsr hexc
output:
                jmp k_chrout
hexc:
                cmp #$0a							; subroutine converts 0-F to a character
                bcs hexa
                clc									; digit 0-9
                adc #48
                bne hexb
hexa:	
                clc
                adc #55;+$80						; digit, a-f (+$80 for caps)
hexb:	
                rts

wait_key
-	            jsr k_getin
                beq -
                rts

loadtempreg:    .byte $00


;-------------------------------------------------------------------------------
; M-W, M-E, M-R command strings
;-------------------------------------------------------------------------------

il_mwstring:    .byte MW_DATA_LENGTH, $00, $00
                .text "w-m"

sel_track:
il_mestring:    .byte trk, >dr_entry, <dr_entry
                .text "e-m"
il_mrstring:    .byte $20,>$04c0, <$4c0
                .text "r-m"


header:         .text "expected        actual",$0d,$0d,0
qst:            .text $0d,"track(+/- to adjust): $",0

;-------------------------------------------------------------------------------
; Drivecode
;-------------------------------------------------------------------------------

drivecode_c64:
                .logical drvstart
drivecode_drv:

l300	jsr $f50a
		tya
l304	bvc l304
l306	clv
l307	bvc l307
l309	sty $85
		sta $0c
		ldy #$00
		sty $0d
l311	ldx $eaea
l314	clv
		ldx $1c00
		bpl l326
l31a	bvc l31a
l31c	lda $1c01
		iny
		bne l311
l322	inc $0d
		bne l314
l326	ldx $0c
		sta $04c2,x
		tya
		sta $04c0,x
		lda $0d
		sta $04c1,x
		clc
		ldy $85
		clv
l338	bvc l338
l33a	clv
		lda $1c01
		sta $04c3,x
		txa
		adc #$04
		iny
		cpy #$10
		bcc l307
l361	lda #$01
		jmp $f969

dr_entry:
                lda #$24
                sta $1c07               ;speed up track seek
                lda $205                ;get track
                ldx #0
                sta $06
                stx $07
                cmp #18
                bcs +
                lda #$ae
                .byte $2c
+               lda #$ea
                sta l311
                lda #$e0
                jmp exec_cmd
exec_cmd:
                sta $00
wait_cmd:
                lda $00
                bmi wait_cmd
                cmp #$02
                rts

drivecodeend_drv:
                .here
drivecodeend_c64:

expected:       .fill $40
expected1:      .binary "expected_t1-17.bin"
expected18:     .binary "expected_t18-35.bin"
result:         .fill $40
