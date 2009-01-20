; adsr
; ----
; 2008, 2009 Hannu Nuotio

; This program tests DTVSID ADSR.

!ct scr

; --- Constants

!src "config.asm"

Vol = $f

; --- Variables

; - zero page

; --- Main 

; start of program
*=$0801
entry:
; BASIC stub: "1 SYS 2061"
!by $0b,$08,$01,$00,$9e,$32,$30,$36,$31,$00,$00,$00


mlcodeentry:

; enable extended registers
lda #1
sta $d03f

; disable interrupts
sei

; disable badlines and colorram fetch
lda #%00110000
sta $d03c

; enable skip+burst
!by $32, $99    ; sac #$99
lda #3
; set zero page to $d4xx
!by $32, $aa    ; sac #$aa
lda #$d4
!by $32, $00    ; sac #$00

; - Sync to DTVSID 8 clk pattern
lda #$10    ; attack & decay: 24 cycles
ldx #$00    ; release: 64 cycles
sta $13
stx $14
; osc3 = pulse, gate = 1
ldx #$02
!align 3,0  ; align to burst boundary
lda #$41
sta $12
- cpx $1c
bne -
; Now at cycle 1, 2 or 3
nop
nop
ldy #18
- nop
dey
bne -
; check if env has changed (cycle 22/23/24)
cpx $1c
bne syncfound       ; if it has, sync found (cycle 3)
; Now at cycle 1 or 2
inx
nop
ldy #21
- nop
dey
bne -
; check if env has changed (cycle 23/24)
cpx $1c
bne syncfound         ; if it has, sync found (cycle 3)
; if not, waste one more cycle
nop
nop
nop
inx

syncfound:
nop
stx $c000
; osc3 = pulse, gate = 0
lda #$40
sta $12
; waste at least 64*4+24 cycles to ensure env = 0
nop
nop
ldx #1+(64*4+24)/8
- nop
lda $c000
nop
lda $c001
nop
lda $c002
nop
nop
nop
nop
nop
dex
bne -

; set zero page to $00xx
!by $32, $aa    ; sac #$aa
lda #$00
!by $32, $00    ; sac #$00

; - test settings

; set output volume
lda #Vol
sta $d418

; set freq
lda #$ff
sta $d40e
lda #$ff
sta $d40f

; set PW
lda #$00
sta $d410
lda #$08
sta $d411

; setup common dma
ldx #(common_dma_values_len - 1)
- lda common_dma_values,x
sta $d300,x
dex
bpl -


; - actual test
!align 3,0
; set ADSR
lda #AD
ldx #SR
nop
sta $d413
nop
stx $d414

; adjust the attack moment
nop
nop
ldx #ATTDELAY+5
- nop
dex
bne -


; start DMA
lda #$0d
; osc3 = pulse, gate = 1
ldx #$41
nop
sta $d31f
nop
stx $d412

!if RELEASE = 1 {
; wait until env is ENV
nop
nop
lda #ENV
- nop
cmp $d41c
nop
nop
bne -
nop
nop
lda #$40
nop
sta $d412
}

; enable interrupts
cli

; wait until DMA is finished
- lda $d31f
bne -

; osc3 = pulse, gate = 0
lda #$40
sta $d412

jmp $0900

common_dma_values:
!by <$d41c  ; 00 source low
!by >$d41c  ; 01 source mid
!by $80     ; 02 source high (IO $d41c)
!by 0       ; 03 dest low
!by 0       ; 04 dest middle
!by $42     ; 05 dest high (RAM $020000)
!by 0       ; 06 source step low
!by 0       ; 07 source step high
!by 1       ; 08 dest step low
!by 0       ; 09 dest step high
!by <$ffff  ; 0a dma len low
!by >$ffff  ; 0b dma len high (1000)
!by 0       ; 0c source mod low
!by 0       ; 0d source mod high
!by 0       ; 0e dest mod low
!by 0       ; 0f dest mod high
!by <$ffff  ; 10 source (line) len low
!by >$ffff  ; 11 source (line) len high
!by <$ffff  ; 12 dest (line) len low
!by >$ffff  ; 13 dest (line) len high
!by 0       ; 14 ?
!by 0       ; 15 ?
!by 0       ; 16 ?
!by 0       ; 17 ?
!by 0       ; 18 ?
!by 0       ; 19 ?
!by 0       ; 1a ?
!by 0       ; 1b ?
!by 0       ; 1c ?
!by 0       ; 1d no continue
!by 0       ; 1e no modulos
common_dma_values_len = * - common_dma_values

* = $0900
- jmp -

