The hi-res program depends on the IRQ timing of the vertical blanking,
and timing loops, to overwrite screen memory as the video circuitry
(not CRTC; this is for CRTC-less PETs) reads it. This way it makes
new characters from parts of existing ones.

The current CRTC-settings for this case are carefully tuned so that this
mostly works. There is some flickering remaining, but on real hardware
this is also true.

              63, /* R0 total horizontal characters - 1 */
              40, /* R1 displayed horizontal characters */
              50, /* R2 horizontal sync position */
            (0 << 4)|8, /* R3 vertical / horizontal sync width */
              31, /* R4 total vertical characters - 1 */
               4, /* R5 total vertical lines adjustment */
              25, /* R6 displayed vertical characters */
              29, /* R7 vertical sync position */
               0, /* R8 MODECTRL */
               7, /* R9 scanlines per character row - 1, including spacing */
               0, /* R10 CURSORSTART */
               0, /* R11 CURSOREND */
            0x10, /* R12 DISPSTARTH */
            0x00, /* R13 DISPSTARTL */

It may be that moving the moment that the IRQ is triggered a bit earlier
or later would work even better.

e67b  6C 19 02    JMP ($0219)        - A:00 X:e8 Y:ff SP:e8   -  IZ  218208287
0f2a  08          PHP                - A:00 X:e8 Y:ff SP:e8   -  IZ  218208291
0f2b  48          PHA                - A:00 X:e8 Y:ff SP:e7   -  IZ  218208294
0f2c  8A          TXA                - A:00 X:e8 Y:ff SP:e6   -  IZ  218208297
0f2d  48          PHA                - A:e8 X:e8 Y:ff SP:e6 N -  I   218208299
0f2e  98          TYA                - A:e8 X:e8 Y:ff SP:e5 N -  I   218208302
0f2f  48          PHA                - A:ff X:e8 Y:ff SP:e5 N -  I   218208304
0f30  EA          NOP                - A:ff X:e8 Y:ff SP:e4 N -  I   218208307
0f31  EA          NOP                - A:ff X:e8 Y:ff SP:e4 N -  I   218208309
0f32  EA          NOP                - A:ff X:e8 Y:ff SP:e4 N -  I   218208311
0f33  EA          NOP                - A:ff X:e8 Y:ff SP:e4 N -  I   218208313
0f34  EA          NOP                - A:ff X:e8 Y:ff SP:e4 N -  I   218208315
0f35  A2 53       LDX #$53           - A:ff X:e8 Y:ff SP:e4 N -  I   218208317
0f37  A0 53       LDY #$53           - A:ff X:53 Y:ff SP:e4   -  I   218208319
0f39  A9 20       LDA #$20           - A:ff X:53 Y:53 SP:e4   -  I   218208321
0f3b  8E 11 80    STX $8011          - A:20 X:53 Y:53 SP:e4   -  I   218208324
0f3e  8C 12 80    STY $8012          - A:20 X:53 Y:53 SP:e4   -  I   218208328
0f41  8D 13 80    STA $8013          - A:20 X:53 Y:53 SP:e4   -  I   218208332
0f44  A9 20       LDA #$20           - A:20 X:53 Y:53 SP:e4   -  I   218208335
0f46  8D 14 80    STA $8014          - A:20 X:53 Y:53 SP:e4   -  I   218208338
0f49  A9 20       LDA #$20           - A:20 X:53 Y:53 SP:e4   -  I   218208341
0f4b  8D 15 80    STA $8015          - A:20 X:53 Y:53 SP:e4   -  I   218208344
0f4e  A9 20       LDA #$20           - A:20 X:53 Y:53 SP:e4   -  I   218208347
0f50  8D 16 80    STA $8016          - A:20 X:53 Y:53 SP:e4   -  I   218208350
0f53  A9 20       LDA #$20           - A:20 X:53 Y:53 SP:e4   -  I   218208353
0f55  8D 17 80    STA $8017          - A:20 X:53 Y:53 SP:e4   -  I   218208356
0f58  A9 20       LDA #$20           - A:20 X:53 Y:53 SP:e4   -  I   218208359
0f5a  8D 18 80    STA $8018          - A:20 X:53 Y:53 SP:e4   -  I   218208362
0f5d  A9 20       LDA #$20           - A:20 X:53 Y:53 SP:e4   -  I   218208365
0f5f  8D 19 80    STA $8019          - A:20 X:53 Y:53 SP:e4   -  I   218208368
0f62  A9 00       LDA #$00           - A:20 X:53 Y:53 SP:e4   -  I   218208371
0f64  8D 1A 03    STA $031A          - A:00 X:53 Y:53 SP:e4   -  IZ  218208374
0f67  A0 DD       LDY #$DD           - A:00 X:53 Y:53 SP:e4   -  IZ  218208377
0f69  EA          NOP                - A:00 X:53 Y:dd SP:e4 N -  I   218208379
0f6a  EA          NOP                - A:00 X:53 Y:dd SP:e4 N -  I   218208381
0f6b  EA          NOP                - A:00 X:53 Y:dd SP:e4 N -  I   218208383
0f6c  EA          NOP                - A:00 X:53 Y:dd SP:e4 N -  I   218208385
0f6d  EA          NOP                - A:00 X:53 Y:dd SP:e4 N -  I   218208387
0f6e  EA          NOP                - A:00 X:53 Y:dd SP:e4 N -  I   218208389
0f6f  88          DEY                - A:00 X:53 Y:dd SP:e4 N -  I   218208391
0f70  D0 F7       BNE $0F69          - A:00 X:53 Y:dc SP:e4 N -  I   218208393
(that sequence of NOPs repeated a bunch of times)
0f72  A2 53       LDX #$53           - A:00 X:53 Y:00 SP:e4   -  IZ  218212135
0f74  A0 20       LDY #$20           - A:00 X:53 Y:00 SP:e4   -  I   218212137
0f76  A9 53       LDA #$53           - A:00 X:53 Y:20 SP:e4   -  I   218212139
0f78  8E 11 80    STX $8011          - A:53 X:53 Y:20 SP:e4   -  I   218212142
0f7b  8C 12 80    STY $8012          - A:53 X:53 Y:20 SP:e4   -  I   218212146
0f7e  8D 13 80    STA $8013          - A:53 X:53 Y:20 SP:e4   -  I   218212150
0f81  A9 20       LDA #$20           - A:53 X:53 Y:20 SP:e4   -  I   218212153
0f83  8D 14 80    STA $8014          - A:20 X:53 Y:20 SP:e4   -  I   218212156
0f86  A9 20       LDA #$20           - A:20 X:53 Y:20 SP:e4   -  I   218212159
0f88  8D 15 80    STA $8015          - A:20 X:53 Y:20 SP:e4   -  I   218212162
0f8b  A9 20       LDA #$20           - A:20 X:53 Y:20 SP:e4   -  I   218212165
0f8d  8D 16 80    STA $8016          - A:20 X:53 Y:20 SP:e4   -  I   218212168
0f90  A9 20       LDA #$20           - A:20 X:53 Y:20 SP:e4   -  I   218212171
0f92  8D 17 80    STA $8017          - A:20 X:53 Y:20 SP:e4   -  I   218212174
0f95  A9 20       LDA #$20           - A:20 X:53 Y:20 SP:e4   -  I   218212177
0f97  8D 18 80    STA $8018          - A:20 X:53 Y:20 SP:e4   -  I   218212180
0f9a  A9 20       LDA #$20           - A:20 X:53 Y:20 SP:e4   -  I   218212183
0f9c  8D 19 80    STA $8019          - A:20 X:53 Y:20 SP:e4   -  I   218212186
0f9f  A9 00       LDA #$00           - A:20 X:53 Y:20 SP:e4   -  I   218212189
0fa1  8D 1A 03    STA $031A          - A:00 X:53 Y:20 SP:e4   -  IZ  218212192
0fa4  EA          NOP                - A:00 X:53 Y:20 SP:e4   -  IZ  218212195
0fa5  EA          NOP                - A:00 X:53 Y:20 SP:e4   -  IZ  218212197
0fa6  A2 53       LDX #$53           - A:00 X:53 Y:20 SP:e4   -  IZ  218212199
0fa8  A0 20       LDY #$20           - A:00 X:53 Y:20 SP:e4   -  I   218212201
0faa  A9 20       LDA #$20           - A:00 X:53 Y:20 SP:e4   -  I   218212203
0fac  8E 11 80    STX $8011          - A:20 X:53 Y:20 SP:e4   -  I   218212206
0faf  8C 12 80    STY $8012          - A:20 X:53 Y:20 SP:e4   -  I   218212210
0fb2  8D 13 80    STA $8013          - A:20 X:53 Y:20 SP:e4   -  I   218212214
0fb5  A9 53       LDA #$53           - A:20 X:53 Y:20 SP:e4   -  I   218212217
0fb7  8D 14 80    STA $8014          - A:53 X:53 Y:20 SP:e4   -  I   218212220
0fba  A9 20       LDA #$20           - A:53 X:53 Y:20 SP:e4   -  I   218212223
0fbc  8D 15 80    STA $8015          - A:20 X:53 Y:20 SP:e4   -  I   218212226
0fbf  A9 20       LDA #$20           - A:20 X:53 Y:20 SP:e4   -  I   218212229
0fc1  8D 16 80    STA $8016          - A:20 X:53 Y:20 SP:e4   -  I   218212232
0fc4  A9 20       LDA #$20           - A:20 X:53 Y:20 SP:e4   -  I   218212235
0fc6  8D 17 80    STA $8017          - A:20 X:53 Y:20 SP:e4   -  I   218212238
0fc9  A9 20       LDA #$20           - A:20 X:53 Y:20 SP:e4   -  I   218212241
0fcb  8D 18 80    STA $8018          - A:20 X:53 Y:20 SP:e4   -  I   218212244
0fce  A9 20       LDA #$20           - A:20 X:53 Y:20 SP:e4   -  I   218212247
0fd0  8D 19 80    STA $8019          - A:20 X:53 Y:20 SP:e4   -  I   218212250
0fd3  A9 00       LDA #$00           - A:20 X:53 Y:20 SP:e4   -  I   218212253
0fd5  8D 1A 03    STA $031A          - A:00 X:53 Y:20 SP:e4   -  IZ  218212256
(etc etc)
