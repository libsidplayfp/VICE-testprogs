; unconnected
; -----------
; Derived from the VIC-20 version, 2009 Hannu Nuotio
; Modifications for PET by Olaf "Rhialto" Seibert 2025.

; This program tests PET unconnected bus behaviour.
; Use with a model with 16 KB of memory, so that there is empty space before
; the screen memory. Do not use BASIC 4.0 since it wants $Bxxx to be empty and
; $Cxxx to be filled.  Also depends on empty space after 2 KB of screen memory
; so do not use -screen2001. Also wants $9xxx to be empty.

; BUGS:
;  - if addr MSB or ROM contents are TESTBYTE_ABS or TESTBYTE_ABS_X, the results may be incorrect

!ct scr

; --- Constants

; - hw

LOAD_ADDR = $0401
SYS_ADDR = $0410

SCREEN = $8000

; - sw

PRINT_LOC = SCREEN

TESTBYTE_ABS = $55
TESTBYTE_ABS_X = $aa

; result type
RESULT_BYTE_ITSELF = 0  ; byte at addr or addr,x
RESULT_ADDR_MSB = 1     ; addr >> 8
RESULT_BYTE_WRAP_X = 2  ; byte at wrapped addr
RESULT_VBUS = 3         ; vbus ("random")
RESULT_ROM = 4          ; ROM

; --- Variables

; - zero page

tmp = $5e

; pointer to print location
res_print = $5f
res_print_h = $60

; pointer to current test (definition) data
test_p = $61
test_ph = $62

; temp pointer to test location
tmp_p = $63
tmp_ph = $64

; result of test
result = $65


; --- Main

; start of program
* = LOAD_ADDR
entry:
; BASIC stub: "1 SYS 1040"
!by $0c,$10,$01,$00,$9e,$31,$30,$34,$30,$00,$00,$00

* = SYS_ADDR
mlcodeentry:

; - print info

jsr clearscreen

lda #>PRINT_LOC
sta res_print_h
lda #<PRINT_LOC
sta res_print

lda #<infotext_top
ldx #>infotext_top
jsr printstring

; - test init

lda #>testdata
sta test_ph
lda #<testdata
sta test_p

; -- test loop

test_next:
ldy #0
lda (test_p),y
bne test_setup
jmp test_finished

; - setup test

test_setup:
tay
lda testdata_opcode,y
sta test_opcode

lda #<infotext_test_start
ldx #>infotext_test_start
jsr printstring

ldy #1
lda (test_p),y
sta test_operand_high
sta tmp_ph
jsr printhex

ldy #2
lda (test_p),y
sta test_operand_low
sta tmp_p
jsr printhex

ldy #0
lda (test_p),y
cmp #1
beq +
lda #<infotext_test_abs_x
ldx #>infotext_test_abs_x
jmp ++
+
lda #<infotext_test_abs
ldx #>infotext_test_abs
++
jsr printstring

ldy #3
lda #TESTBYTE_ABS_X
sta (tmp_p),y
ldy #0
sta (tmp_p),y

ldy #0
clc
lda tmp_p
adc #3
bcc +
sta tmp_p
lda #TESTBYTE_ABS
sta (tmp_p),y
+

; - actual test

ldy #0
ldx #3
testloop:
test_opcode = *
test_operand_low = * + 1
test_operand_high = * + 2
lda $1234
sta result_buffer,y
iny
bne testloop

; - calculate results

lda result_buffer
ldy #1
calc_loop:
cmp result_buffer,y
bne calc_found_difference
iny
bne calc_loop
; no differences found, check type
cmp #TESTBYTE_ABS
bne +
lda #RESULT_BYTE_WRAP_X
jmp test_result_found
+
cmp #TESTBYTE_ABS_X
bne +
lda #RESULT_BYTE_ITSELF
jmp test_result_found
+
cmp test_operand_high
bne +
lda #RESULT_ADDR_MSB
jmp test_result_found
+
; assuming ROM
lda #RESULT_ROM
jmp test_result_found

calc_found_difference:
; difference in results found -> v-bus (not relevant for PETs)
lda #RESULT_VBUS

test_result_found:
sta result

; - print results
test_result_print:
jsr printresult

lda #<infotext_test_res_sep
ldx #>infotext_test_res_sep
jsr printstring

; - print reference
ldy #3
lda (test_p),y
jsr printresult

; - print first byte from buffer
lda #<infotext_test_res_hex
ldx #>infotext_test_res_hex
jsr printstring

lda result_buffer
jsr printhex

; - fill up the rest of the line
lda #<infotext_rest_of_line
ldx #>infotext_rest_of_line
jsr printstring
; - test done

clc
lda test_p
adc #4
sta test_p
bcc +
inc test_ph
+
jmp test_next

; - all tests finished

test_finished:
lda #<infotext_bottom
ldx #>infotext_bottom
jsr printstring

- jsr $ffe4
beq -

jmp mlcodeentry


; --- Subroutines

; - clearscreen
; changes:
;  y = 0
;
clearscreen:
ldy #0
- lda #' '
sta SCREEN,y
sta SCREEN+$100,y
sta SCREEN+$200,y
sta SCREEN+$300,y
iny
bne -
rts

; - printhex
; parameters:
;  res_print -> screen location to print to
;  a = value to print
; changes:
;  a, y = 0, tmp, res_print++
;
printhex:
stx tmp
pha
; get upper
lsr
lsr
lsr
lsr
; lookup
tax
lda hex_lut,x
; print
jsr print
; get lower
pla
and #$0f
; lookup
tax
lda hex_lut,x
; print
jsr print
ldx tmp
rts

; - printstring
;  res_print -> screen location to print to
;  a:x -> string to print
; changes:
;  a, x, y, res_print++
;
printstring:
sta printstring_src
stx printstring_src_h
ldx #0
printstring_src = * + 1
printstring_src_h = * + 2
-
lda $1234,x
beq +
jsr print
inx
bne -
inc printstring_src_h
bne -
+
rts

; - print
; parameters:
;  res_print -> screen location to print to
;  a = char to print
; changes:
;  y = 0, res_print++
;
print:
ldy #0
sta (res_print),y
inc res_print
bne +
inc res_print_h
+
rts

; - printresult
; parameters:
;  res_print -> screen location to print to
;  a = result
; changes:
;  a, x, y = 0, tmp, res_print++
;
printresult:
asl
asl
ldx #>infotext_test_result_tbl
clc
adc #<infotext_test_result_tbl
bcc +
inx
+
jsr printstring
rts


; --- Data

; - hex lookup table
hex_lut:
!tx "0123456789abcdef"

; - Strings
;   |0123456789012345678901234567890123456789|
infotext_top:
!tx "un-connected testprog                   "
!tx "test: result - ref/1st                  ",0

infotext_bottom:
!tx "press a key to restart                  ",0

infotext_test_start:
!tx "$",0
infotext_test_abs:
!tx          "  : ",0
infotext_test_abs_x:
!tx          ",x: ",0
infotext_test_res_sep:
!tx                " - ",0
infotext_test_res_hex:
!tx                "/$ ",0
infotext_rest_of_line:
!tx                        "                 ",0

; - test data
; format:
;  type - 0 = end, 1 = absolute, 2 = ,x
;  addr - hi, low
;  reference - (see defines)
testdata:
!by 1, $f0, $00, RESULT_ROM
!by 2, $f0, $00, RESULT_ROM
!by 1, $15, $00, RESULT_BYTE_ITSELF
!by 2, $16, $ff, RESULT_BYTE_ITSELF
!by 1, $90, $00, RESULT_ADDR_MSB
!by 2, $90, $00, RESULT_ADDR_MSB
!by 2, $87, $ff, RESULT_BYTE_WRAP_X ; X=3, 8702 is RAM, 8802 is empty; reads 8702
!by 1, $9d, $34, RESULT_ADDR_MSB
!by 2, $93, $ff, RESULT_ADDR_MSB
!by 1, $e8, $00, RESULT_ADDR_MSB    ; E800-E80F is empty
!by 1, $e8, $0f, RESULT_ADDR_MSB
!by 2, $e7, $ff, RESULT_ROM         ; X=3, E80x is empty, E7xx is ROM; reads E702
!by 2, $7f, $ff, RESULT_BYTE_ITSELF ; X=3, 7F02 is empty, 8002 is RAM; reads 8002
!by 2, $bf, $ff, RESULT_ROM         ; X=3, BF02 is empty, C002 is ROM; reads C002
!by 0

; Test  2, $7f, $ff, RESULT_BYTE_ITSELF is meant for a 16 K PET so that it
; dummy-reads empty, then reads RAM, but the result "RAM" is also reached for
; 32 KB models, where it dummy-reads and real-reads RAM.

; Test 2, $bf, $ff, RESULT_ROM depends on $Bxxx being empty, so it won't work
; as intended for BASIC 4 machines. For those it should be 2, $af, $ff, RESULT_ROM.
; But the result will be "ROM" in both cases.

; opcode, indexed by type field of testdata
testdata_opcode:
!by 0   ; 0 = unused
!by $ad ; 1 = LDA $nnnn
!by $bd ; 2 = LDA $nnnn,X

; result text table
infotext_test_result_tbl:
!tx "ram",0
!tx "msb",0
!tx "nox",0
!tx "v-b",0
!tx "rom",0

!by 1,2,3

result_buffer:
