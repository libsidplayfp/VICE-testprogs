; test hostfs multiple-chkin bug

.include "cbm_kernal.inc"

lfn = 1         ; logical file number
dev = 8         ; device number (8=disk)
sa  = 2         ; channel number 

.zeropage
ptr:            .res 2

.data
overwrite:      .byte "@0:"
filename:       .byte "test.txt"
suffix:         .byte ",s,w"
endname:        

text:           .byte "this is a test",13
                .byte "with a total of",13
                .byte "49 bytes of data.",13,0

writing:        .byte 5,"creating data file",0
reading1:       .asciiz "reading data file back with single chkin call"
reading2:       .asciiz "reading data file back with multiple chkin calls"
verify_error:   .asciiz "verify error"
verify_ok:      .asciiz "verify ok"
file_kept:      .asciiz "file kept:"

.bss
bytesread:      .res 2

.code

Start:          lda #<writing
                ldx #>writing
                jsr puts

                ; create data file
                lda #(endname - overwrite)
                ldx #<overwrite
                ldy #>overwrite
                jsr SETNAM

                lda #lfn
                ldx #dev
                ldy #sa
                jsr SETLFS

                jsr OPEN

                ldx #lfn
                jsr CHKOUT

                lda #<text
                sta ptr
                lda #>text
                sta ptr+1
                ldy #0
writeloop:      lda (ptr),y
                beq wrote
                jsr CHROUT
                iny
                bne writeloop

wrote:          jsr CLRCHN
                lda #lfn
                jsr CLOSE

                lda #<reading1
                ldx #>reading1
                jsr puts

                ; verify data file
                lda #(suffix - filename)
                ldx #<filename
                ldy #>filename
                jsr SETNAM

                lda #lfn
                ldx #dev
                ldy #sa
                jsr SETLFS

                jsr OPEN

                ldx #lfn
                jsr CHKIN

                lda #<text
                sta ptr
                lda #>text
                sta ptr+1
                ldy #0

vloop1:         jsr CHRIN
                cmp (ptr),y
                bne verror1
                jsr READST
                and #$40
                bne vdone1
                iny
                bne vloop1

vdone1:         jsr CLRCHN
                lda #lfn
                jsr CLOSE

                lda #<verify_ok
                ldx #>verify_ok
                jsr puts
                jmp verify2

verror1:        jsr CLRCHN
                lda #lfn
                jsr CLOSE
                lda #<verify_error
                ldx #>verify_error
                jsr puts

verify2:        lda #<reading2
                ldx #>reading2
                jsr puts

                ; verify data file
                lda #(suffix - filename)
                ldx #<filename
                ldy #>filename
                jsr SETNAM

                lda #lfn
                ldx #dev
                ldy #sa
                jsr SETLFS

                jsr OPEN

                lda #<text
                sta ptr
                lda #>text
                sta ptr+1
                ldy #0

vloop2:         ldx #lfn
                jsr CHKIN

                jsr CHRIN
                cmp (ptr),y
                bne verror2
                jsr READST
                and #$40
                bne vdone2
                iny
                bne vloop2

vdone2:         jsr CLRCHN
                lda #lfn
                jsr CLOSE

                lda #<verify_ok
                ldx #>verify_ok
                jsr puts

                ; since the verify was ok, delete the test file
                lda #'s'
                sta overwrite
                lda #(suffix - overwrite)
                ldx #<overwrite
                ldy #>overwrite
                jsr SETNAM
                lda #15
                ldx #dev
                ldy #15
                jsr SETLFS
                jsr OPEN
                jmp CLOSE

verror2:        jsr CLRCHN
                lda #lfn
                jsr CLOSE
                lda #<verify_error
                ldx #>verify_error
                jsr puts

                lda #<file_kept
                ldx #>file_kept
                jsr puts

                lda #$00
                sta suffix
                lda #<filename
                ldx #>filename

puts:           sta ptr
                stx ptr+1
                ldy #$00
ploop:          lda (ptr),y
                beq @puts_done
                jsr CHROUT
                iny
                bne ploop

@puts_done:     lda #$0d
                jmp CHROUT
