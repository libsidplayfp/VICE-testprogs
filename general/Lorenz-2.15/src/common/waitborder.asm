;wait until raster line is in border
;to prevent getting disturbed by DMAs

waitborder:
        dec $d020
           .block
            lda $d011
            bmi ok
wait
            lda $d012
            cmp #30
            bcs wait
ok
        inc $d020
;wait
;           lda $d011
;           bpl wait
            rts
           .bend 
           
