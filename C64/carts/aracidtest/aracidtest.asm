/*  (c)ranked up by Count Zero/CyberpunX/SCS*TRC

For anyone reading the source - sorry for just writing it down without too much 
commenting - its straight forward code I hope anyways :)

2010-08-mid  Action Replay & Clones Acid Ramtest v0.1
             Initial writeup with simplicity in mind, so the program is easily 
             traceable whenever the explanation is not sufficient

*/

/* Action/Retro Replay $DE00 */
; bit 7 - ROM bank selector (A15)
; bit 6 - Restores memory map after freeze, GAME and EXROM "reset"
;      - no function when not in freeze mode
; bit 5 - 0 = ROM and 1 = RAM
; bit 4 - ROM bank selector (A14)
; bit 3 - ROM bank selector (A13)
; bit 2 - 1 = cartridge kill
; bit 1 - 1 = /EXROM high  (0 = "assert" and 1 = "de-assert")
; bit 0 - 1 = /GAME  low   (1 = "assert" and 0 = "de-assert"

/* Nordic Power $DE00 */
; the hardware is very similar to Action Replay 5, with one exception

; bit 7 - (unused) extra ROM bank selector (A15)
; bit 6 - 1 = resets FREEZE-mode (turns back to normal mode)
; bit 5 - 1 = enable RAM at ROML ($8000-$9FFF) & I/O2 ($DF00-$DFFF = $9F00-$9FFF)
; bit 4 - ROM bank selector high (A14)
; bit 3 - ROM bank selector low  (A13)
; bit 2 - 1 = disable cartridge (turn off $DE00)
; bit 1 - 1 = /EXROM high
; bit 0 - 1 = /GAME low

;   different to original AR:
;
;   if bit 5 (RAM enable)   == 1,
;      bit 0,1 (exrom/game) == 2 (cart off),
;      bit 2,6,7 (cart disable, freeze clear) are 0,
;
;   then Cart ROM (Bank 0..3) is mapped at 8000-9fff,
;    and Cart RAM (Bank 0)    is mapped at A000-bfff
;        using 16K Game config


; we always aim at AR RAM bank 0 for basic behaviour testing

;normal		= %00100000 = $20
;normal_exr	= %00100010 = $22
;normal_gam	= %00100001 = $21
;normal_ex_gam	= %00100011 = $23

; FIXME

        #include "common.inc"

        #include "basicstart.asm"

; $f8/$f9 is used as pointer for the IO area after test 2
; $fe/$ff is used as temporary counter/pointer

		jsr println
		.dw Ramtest_Text0		;print intro screen
		jsr spacekeyreal
		
		;======================================== TEST 1
ntest0:
		jsr ramdetect			; program is not stopped (anymore) by failed tests!


ntest1:
		jsr spacer
		.dw ntest0
		;======================================== TEST 2
ntest1a:
		jsr ramsizedetect
		jsr spacer
		.dw ntest1a
#ifdef QUICKRUN
		jmp printscore
#endif
		;======================================== TEST 3
ntest2:
		lda #$20
		jsr ariotest1
		jsr spacekey
		
		lda #$21
		jsr ariotest1
		jsr spacekey

		lda #$22
		jsr ariotest1
		jsr println
		.dw Note3
		jsr spacekey
		
		lda #$23
		jsr ariotest1
		jsr spacer
		.dw ntest2
		;======================================== TEST 4

ntest3:
		lda #$20
		jsr ariotest2
		jsr spacekey
		
		lda #$21
		jsr ariotest2
		jsr spacekey

		lda #$22
		jsr ariotest2
		jsr println       ; also for plain read on IO #$22 is allowed to fail
		.dw Note3
		jsr spacekey
		
		lda #$23
		jsr ariotest2
		jsr spacer
		.dw ntest3
		;======================================== TEST 5

ntest4:
		lda #$20
		jsr arramtest2
		jsr println
		.dw Note5a
		jsr spacer
		.dw ntest4
ntest4a:		
		lda #$21
		jsr arramtest2
		jsr println
		.dw Note5a
		jsr spacer
		.dw ntest4a
ntest4b:
		lda #$22
		jsr arramtest2
		jsr println
		.dw Note5b
		jsr spacer
		.dw ntest4b
ntest4c:
		lda #$23
		jsr arramtest2
		jsr println
		.dw Note5c
		jsr spacer
		.dw ntest4
		;======================================== TEST 6

;=========================================================
; subs
;=========================================================
musicplay:
		jsr println
		.dw Test6

		lda #$23
		jsr printarvalue

		jsr println
		.dw Test6a

		jsr println
		.dw t_vrfyc64ram

		jsr println
		.dw Note6a

		ldx #clrval
		stx $de00
		jsr c64ramclr
		jsr c64ramsetup

		jsr zakcopy

		sei
		lda #<no_escape
		sta $0318
		lda #>no_escape
		sta $0319
		lda #$23
		sta $de00
		lda #$00
		sta $fe
		sta $ff
		tax
		tay
		jsr $9554
contplay:	
		lda #<no_escape
		sta $0318
contplay2:
		lda #>no_escape
		sta $0319
		
		lda #clrval
		sta $de00
		lda #$fb
		cmp $d012
		bne *-3
		dec $d020
		lda #<no_escape
		sta $0318
		lda #>no_escape
		sta $0319
		lda #$23
		sta $de00
		jsr $8012
		inc $d020
		lda #clrval
		sta $de00
		; wait counter for music
		cld
		lda $fe
		clc
dissy1:		adc #$01
		sta $fe
		lda $ff
		adc #$00
		sta $ff
		cmp #$06
#ifdef QUICKRUN2
		cmp #$01
#endif
		bne contplay
		lda #$00
		sta dissy1+1
		sta $ff
		ldx #08
		ldy #17
		clc
		jsr $fff0

		lda #clrval
		sta $de00
		
		jsr c64ramverify
		jsr okfailout
		sta resultTest6
		ldx #21
		ldy #0
		clc
		jsr $fff0

		lda #<escmucke
		sta contplay+1
		lda #>escmucke
		sta contplay2+1
		jsr println
		.dw Note6b		
		jmp contplay

escmucke:
		lda #$00
		sta $d418
		lda #$47
		sta $0318
		lda #$fe
		sta $0319

;========================================================= output results
printscore:
		jsr println
		.dw Results

		ldx #$00
		lda #$00
rloop:		
		clc
		adc resultTest2,x
		inx
		cpx #40
		bne rloop
; output score
		tax
		lda #$00
		jsr $bdcd
		sei
		jsr println
		.dw Results2         ; score table

		ldx resultTest2
;		bne stressme
		lda #$00
		jsr $bdcd
		sei
		jsr println
		.dw Results3
		
;		jsr println
;		.dw Results4
endprg:
		inc $d020
		dec $d020
		pha
		pla
		pha
		pla
		pha
		pla
		pha
		pla
		pha
		pla
		pha
		pla
		pha
		pla
		pha
		pla
		pha
		pla
		jmp endprg

/*
stressme:
		lda #$00
		jsr $bdcd
		sei
		jsr println
		.dw Results3

		dec $d020
		inc $d020
		

		jsr spacekeyreal
*/
;========================================================= stresstest
Stresstest:



;========================================================= RTI for musicstuff

no_escape:	rti

        #include "test-arramtest2.asm"
        #include "test-ariotest2.asm"
        #include "test-ariotest1.asm"
		#include "test-ramdetect.asm"
		#include "test-ramsizedetect.asm"
		#include "test-common.asm"

;=========================================================
; copy music to AR RAM - $18 pages from $3000 -> $8000
zakcopy:
		sei
		ldx #$18
		lda #$80
		sta $ff
		lda #>musicmem
		sta $fd
		lda #$00
		sta $fe
		sta $fc
		tay
clr11:		lda #clrval
		sta $de00
		lda ($fc),y
		pha
		lda #$23
		sta $de00
		pla
		sta ($fe),y
		iny
		bne clr11
		inc $ff
		inc $fd
		dex
		bpl clr11
		lda #clrval
		sta $de00
		rts
		
		
;=========================================================
#if *>=$1000
#error "Routines running in ULTIMAX above $1000, this will crash!"
#endif
;========================================================= testvalue

        #include "common.asm"

;=========================================================
Ramtest_Text0:
		.db 5,147
		.pet $1e,"Action Replay & Clones ",$9e,"Acid Ramtest",5," v0.1"
		.pet $96,"****************************************",5,13,13
		
		.pet "This tests accessibility of the RAM and "
		.pet "was created due to a problem found on   "
		.pet "various emulations including ",$96,"RR",$5,", ",$96,"MMCR",$5,",  "
		.pet $96,"1541U",$5," and ",$96,"VICE",$5," (up to 2.2.6).",13,13
		.pet "Run this with your cart enabled and any",13
		.pet "valid ROM to ensure initial setup.",13,13
		
;		.pet "These tests will pass ",$1e,"OK",5," on original",13
;		.pet "Action Replay, Action & Nordic Power.",13,13

		.pet " This simple rundown of possible values "
		.pet $96," EXPECTS some FAILS",5,". Don't worry, check "
		.pet "       ",$9e,"the scoring",$5," at the end.",13,13

		.pet "Little code - much text to make the prg "
		.pet "useful to hardware implementers and",13
		.pet "emulationers... damn illiterates :)",13,13
		.pet $96,"     If this prg crashes, RESTART!",13
		.pet "    It really is pretty unstable :(",13,13,5
		.pet "           mailto: count0@pokefinder.org"
		.pet "     http: rr.c64.org - www.scs-trc.net"
		.db 0
;=========================================================
        #include "text-common.asm"
        #include "text-ramdetect.asm"
        #include "text-ramsizedetect.asm"
        #include "text-ariotest1.asm"
        #include "text-ariotest2.asm"
        #include "text-arramtest2.asm"

;=========================================================
Test6:
		.db 5,147
		.pet "Test 6: Entertainment Test",13,13
		.pet "data -> $8000 C64 RAM",13
		.pet "code -> $8000 AR RAM using:",13
		.db 0

Test6a:         .pet "play -> funky music by Rob Hubbard!",13,13
		.db 0

Note6a:		.pet 13,13,13,$1e,"Note: ",5,"This should play a classic on any "
		.pet "      replay platform -",$1e," from cart ram.  ",5
		.pet "      Under the right circumstances many"
		.pet "      programs can be adapted to utilise"
		.pet "      this extended ram. Code execution "
		.pet "      needs to be possible using ",$1e,"#$20",5," as"
		.pet "      well, but #$23 does not corrupt",13
		.pet "      c64 ram due to the ultimax mode.",13,13,13
		.pet $9e,"             Please wait...",0
Note6b:
		.pet $9e,"  Hitting RESTORE will take you to the  "
		.pet " results and RAM stress test (tbd soon) "
;		.pet "RAM stableness and all banks up to 64 kb"
		.db 0

Results:
		.db 5,147
		.pet "Results for the ",$9e,"Acid Ramtest",5," v0.1",13,13,13
		.pet "You scored ",$1e,0
Results2:       .pet 5," points!",13,13
		.pet "Known and expected so far:",13,13
		.pet " 13 - CCS v3+ (including v3.8)",13
		.pet " 15 - Original AR/NP hardware (",$9a,"8kb RAM",5,")",13
		.pet " 19 - Old flaky VICE AR/NP (pre 2.2.6)",13
		.pet " 39 - plain C64? ",$9a,"No AR RAM FOUND!",5,13
		.pet " 39 - RR desired behaviour (",$9a,"32kb RAM",5,")",13
		.pet " 43 - RR, MMCR, 1541U (current) reality",13
		.pet $1e," 71 - The perfect AR RAM emulation!",5,13
		.pet "      Whats the trick? Good emulation?",13,13
		.pet $9e," Score = kb_of_ram + encountered_errors!",13
		.pet $1e,"YES! Some FAILS are expected! MIND THAT!",5,13
		.pet " We expect any 1541U and EasyFlash2 to",13
		.pet "              hit ",$1e,"71",5," soon.",13,13,$96,0

Results3:
		.pet 5," kb RAM stress test to be implemented",13
		.pet "with v0.2 or so...                  /cz",0

/*
Results3:
		.pet 5," kbyte RAM stress test is next. SPACE",0
Results4:	.pet $9e,"    No AR RAM found - No Stress Test",13
		.pet "                      End of Program...",0


Stressram:
		.db 5,147
		.pet $9e,"Ram Stress Test",5," v0.1 - Reset to quit prg"
		.pet 0

Stressbank:
		.pet $9e,"Bank: ",0
Stresserror:
		.pet 5,"      Errors: ",0


		*=$1f00

stressbanks:	.db 0		; number of bank to test
		
Stresserror0:
		.db 0,0		; amount of errors per bank
Stresserror1:
		.db 0,0
Stresserror2:
		.db 0,0
Stresserror3:
		.db 0,0
Stresserror4:
		.db 0,0
Stresserror5:
		.db 0,0

Stresserror6:
		.db 0,0
Stresserror7:
		.db 0,0
*/
;=========================================================

		*= $2000

resultTest2:	.db $fe ; 0, 8, 32, 64 kb        >= 8 required
resultTest1a:	.db $ff ; 0 - passed, 1 - failed == required
resultTest1b:	.db $ff ; 0 - passed, 1 - failed == required

resultTest3:	.db $ff,$ff,$ff,$ff ; 0 - passed, 1 - failed    $20 - $23 c64 ram
resultTest3a:	.db $ff,$ff,$ff,$ff ; 0 - passed, 1 - failed    $20 - $23 ar io ram
resultTest3b:	.db $ff,$ff,$ff,$ff ; 0 - passed, 1 - failed    $20 - $23 ar ram

resultTest4:	.db $ff,$ff,$ff,$ff ; 0 - passed, 1 - failed    $20 - $23 c64 ram
resultTest4a:	.db $ff,$ff,$ff,$ff ; 0 - passed, 1 - failed    $20 - $23 ar io ram
resultTest4b:	.db $ff,$ff,$ff,$ff ; 0 - passed, 1 - failed    $20 - $23 ar ram

resultTest5:	.db $ff,$ff,$ff,$ff ; 0 - passed, 1 - failed    $20 - $23 c64 ram
resultTest5a:	.db $ff,$ff,$ff,$ff ; 0 - passed, 1 - failed    $20 - $23 ar io ram
resultTest5b:	.db $ff,$ff,$ff,$ff ; 0 - passed, 1 - failed    $20 - $23 ar ram

resultTest6:	.db $ff ; 0 - passed, 1 - failed
baseio:		.db $ff ; de or df for RAM IO  (set by test2, ramsizedetect)

		*=$3000
musicmem:
		.binclude "monty.sid"
