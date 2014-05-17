
cglprzp = $f0

;-------------------------------------------------------------------------------

cgplayer_inittune = *
cgplayer_playtick = * + 3

                jmp cgplayer_initall
                jmp cgplayer_playall

musaddr:        .word musdata
straddr:        .word strdata

;-------------------------------------------------------------------------------
cgplayer_init1 = *
cgplayer_play1 = * + 3
;.undef SIDNUM
.define SIDNUM 0
                .include "cgplayercore.s"
;-------------------------------------------------------------------------------
cgplayer_init2 = *
cgplayer_play2 = * + 3
.undef SIDNUM
.define SIDNUM 1
                .include "cgplayercore.s"
;-------------------------------------------------------------------------------

cgplayer_initall:

                lda straddr + 1
                beq @mono
                sta cglprzp + 1
                lda straddr + 0
                sta cglprzp + 0
                ldy #1
                lda (cglprzp),y
                bne @stereo
                ;lda #0
                sta straddr + 1
                beq @mono
@stereo:
                jsr cgplayer_init2
@mono:
                jmp cgplayer_init1

cgplayer_playall:

                lda straddr + 1
                beq @mono
                jsr cgplayer_play2
@mono:
                jmp cgplayer_play1

