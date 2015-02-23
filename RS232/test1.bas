
10 print "opening port..."
11 open 1,2,0,chr$(10)
12 gosub 1000: if ec <> 0 then close 1:end

15 print "type your message:"

20 for i = 0 to 2
30 input m$
40 print#1, m$ + str$(i) + chr$(13) + chr$(10)
50 gosub 1000
50 next i

60 print "waiting for reply..."

70 get #1, a$: ec = st: if ec = 8 then goto 70
80 if ec <> 0 then print "error:";ec

100 if a$ <> "" then print a$;
105 goto 70

;  +-----------------------------------------------------------------------+
;  | [7] [6] [5] [4] [3] [2] [1] [0] (Machine Lang.-RSSTAT                 |
;  |  |   |   |   |   |   |   |   +- PARITY ERROR BIT                      |
;  |  |   |   |   |   |   |   +----- FRAMING ERROR BIT                     |
;  |  |   |   |   |   |   +--------- RECEIVER BUFFER OVERRUN BIT           |
;  |  |   |   |   |   +------------- RECEIVER BUFFER-EMPTY                 |
;  |  |   |   |   |                  (USE TO TEST AFTER A GET#)            |
;  |  |   |   |   +----------------- CTS SIGNAL MISSING BIT                |
;  |  |   |   +--------------------- UNUSED BIT                            |
;  |  |   +------------------------- DSR SIGNAL MISSING BIT                |
;  |  +----------------------------- BREAK DETECTED BIT                    |
;  |                                                                       |
;  +-----------------------------------------------------------------------+
; also see https://www.c64-wiki.com/index.php/STATUS#STATUS_bits_and_values

; get ST and print error code on error
1000 ec = st
1001 if ec > 0 then print "error:";ec
1010 return
