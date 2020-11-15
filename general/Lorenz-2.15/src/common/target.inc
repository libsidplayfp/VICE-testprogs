
CPU6510     = 0 
CPU6502     = 1 
CPU65C02    = 2 

TARGETC64       = 0
TARGETC128      = 1
TARGETC128C64   = 2
TARGETVIC20     = 3
TARGETPLUS4     = 4

TARGET1541      = 5
TARGET1571      = 6

;------------------------------------------------------------------------------
.ifeq (TARGET - TARGETC64)
TARGETCPU = CPU6510

VICII = $d000
SID   = $d400
CIA1  = $dc00
CIA2  = $dd00

SET_EXIT_CODE_SUCCESS:  .macro
        pha
        lda #$00
        sta $d7ff
        lda #13 ; l.green
        sta $d020
        pla
                        .endm

SET_EXIT_CODE_FAILURE:  .macro
        pha
        lda #$ff
        sta $d7ff
        lda #10 ; l.red
        sta $d020
        pla
                        .endm

.endif

;------------------------------------------------------------------------------
.ifeq (TARGET - TARGETC128C64)
TARGETCPU = CPU6510

VICII = $d000
SID   = $d400
CIA1  = $dc00
CIA2  = $dd00

SET_EXIT_CODE_SUCCESS:  .macro
        pha
        lda #$00
        sta $d7ff
        lda #13 ; l.green
        sta $d020
        pla
                        .endm

SET_EXIT_CODE_FAILURE:  .macro
        pha
        lda #$ff
        sta $d7ff
        lda #10 ; l.red
        sta $d020
        pla
                        .endm

.endif

;------------------------------------------------------------------------------
.ifeq (TARGET - TARGETC128)
TARGETCPU = CPU6510
.endif

;------------------------------------------------------------------------------
.ifeq (TARGET - TARGETVIC20)
TARGETCPU = CPU6502
.endif
