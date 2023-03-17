
################################################################################

               char         char            chars/ dots/   dot pitch
           height width  height width         line  line   vert.  hor.
           pins   dots   inch   inch

2022          7       6  0.11   0.10          80    480
2023          7       6  0.11   0.10          80    480
4023          8       8  0.094  0.08          80    640

8023P         8       5  0.116  0.08         136    680

802/1526      8       8  0.094  0.08          80    640
MPS1000

early 801     7       6                       80    480
803           7       6  0.09   0.08          80    480    1/72"   1/60"


################################################################################

           SA= 0  1  2  3  4  5  6  7  8  9 10 11 12 13 14 15 16 17 18 19 20 21

2022           *  *  *  *  *  *  *
2023           *  *  *  *  *  *
4023           *  *  *  *  *  *  *  *  *  *  *

8023P          *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *     *  *        *

MPS802         *  *  *  *  *  *  *  *     *  *
MPS1000        *  *  *  *  *  *  *  *     *  *

early MPS801   *                 *  *  *     *
MPS803         *                    *

SA= 0: Print data exactly as received
       (mps801,mps803: Select graphic mode)
SA= 1: Print data in previously defined format
SA= 2: save format data
SA= 3: set lines per page
SA= 4: Format Error request
SA= 5: define user programmable character bitmap (character 254)
SA= 6: Setting spacing between lines
SA= 7: Select business mode
SA= 8: Select graphic mode
SA= 9: prevent error messages
SA=10: Reset the printer

SA=11: Set unidirectional printing.
SA=12: Set bidirectional printing.
SA=13: Set 15 cpi. (condense mode)
SA=14: Set 10 cpi. (reset condense mode)
SA=15: Enable correspondence (overstrike, pseudo letter quality) mode.

SA=17: Print bit image graphics.
SA=18: Print received bit image graphics again.

SA=21: Disable correspondence (overstrike, pseudo letter quality) mode.
       (To disable send on SA=21, then SA=14)

################################################################################

      code=   1   2   8  10  12  13  14  15  16  17  18  19  26  27  29  34 129 141 145 146 147 159 160 254

2022          *           *       *               *   *   *           *   *   *   *   *   *   *           *
2023          *           *       *               *   *   *           *   *   *   *   *   *   *           *
4023          *           *       *               *   *   *           *   *   *   *   *   *   *           *

8023P         *           *                       *   *   *           *   *   *   *   *   *   *           *

MPS802                    *       *   *           *   *   *           *   *   *   *   *   *   *           *
MPS1000       *   *   *   *   *   *   *   *   *   *   *   *   *   *   *   *       *   *   *   *   *   *   *

MPS801                *   *       *   *   *   *   *   *       *   *                   *   *
MPS803                *   *       *   *   *   *   *   *       *   *       *           *   *

  1: Enhance (increase width)
     (MPS1000: Single density (480 DPL) bit image graphics)
  2: (MPS1000: Double density (960 DPL) bit image graphics)
  8: Enter Graphic Mode (Bit Image Printing)
     (MPS1000: Bit image (7-vertical dot) with 7/72" line feed)
 10: Line Feed
     (MPS1000: with carriage return)
 12: Form Feed
 13: Carriage Return
     (MPS1000: with line feed)
 14: Enhance ON (Enter Double Width Character Mode)
 15: Enter Standard Character Mode
     (mps803: enhance off)
 16: Tab setting the Print Head ("NHNL")
 17: Lowercase / Business Mode (Enter Cursor Down Mode)
 18: Reverse ON
 19: Paging OFF (HOME)
 26: Repeat Graphics Selected (Bit Image Repeat)
 27: specify Dot Address (must follow Print Head Tab Code)
 29: Skip Space
 34: Quote
129: Enhance OFF
141: Carriage Return without Line Feed
145: Uppercase / Graphics Mode (Enter Cursor Up Mode)
146: Reverse OFF
147: Paging ON (CLR)
159: NLQ OFF
160: Prints blank alpha field in formatting print
254: print programmable character
