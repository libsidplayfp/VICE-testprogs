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

; disable badlines and colorram fetch
lda #%00110000
sta $d03c

; setup common dma
ldx #(common_dma_values_len - 1)
- lda common_dma_values,x
sta $d300,x
dex
bpl -

; set output volume
lda #Vol
sta $d418

; set freq
lda #$ff
sta $d40e
lda #$ff
sta $d40f

; set ADSR
!if RELEASE = 0 {
lda #A_D
ldx #$00
} else {
lda #$00
ldx #(REL | $f0)
}
sta $d413
stx $d414

; set PW
lda #$00
sta $d410
lda #$08
sta $d411

; disable screen
lda $d011
and #$ef
sta $d011

; disable interrupts
sei

; start DMA
lda #$0d
sta $d31f

; osc3 = pulse, gate = 1
lda #$41
sta $d412

!if RELEASE = 1 {
; wait until env is $ff
- inc $d418
bne -
; gate = 0
lda #$40
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

; enable screen
lda $d011
ora #$10
sta $d011

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

