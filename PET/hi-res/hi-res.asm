    *=$0ef4

    SEI             ; 0ef4  78      
    LDA $0219       ; 0ef5  AD 19 02
    LDX i1763       ; 0ef8  AE 63 17
    STA i1763       ; 0efb  8D 63 17
    STX $0219       ; 0efe  8E 19 02
    LDA $021A       ; 0f01  AD 1A 02
    LDX i1764       ; 0f04  AE 64 17
    STA i1764       ; 0f07  8D 64 17
    STX $021A       ; 0f0a  8E 1A 02
    CLI             ; 0f0d  58      
    RTS             ; 0f0e  60      

    SEI             ; 0f0f  78      
    LDA $0090       ; 0f10  AD 90 00
    LDX i1763       ; 0f13  AE 63 17
    STA i1763       ; 0f16  8D 63 17
    STX $0090       ; 0f19  8E 90 00
    LDA $0091       ; 0f1c  AD 91 00
    LDX i1764       ; 0f1f  AE 64 17
    STA i1764       ; 0f22  8D 64 17
    STX $0091       ; 0f25  8E 91 00
    CLI             ; 0f28  58      
    RTS             ; 0f29  60      

i0F2A:                             
    PHP             ; 0f2a  08      
    PHA             ; 0f2b  48      
    TXA             ; 0f2c  8A      
    PHA             ; 0f2d  48      
    TYA             ; 0f2e  98      
    PHA             ; 0f2f  48      

    NOP             ; 0f30  EA      
    NOP             ; 0f31  EA      
    NOP             ; 0f32  EA      
    NOP             ; 0f33  EA      
    NOP             ; 0f34  EA      

    LDX #$20        ; 0f35  A2 20   
    LDY #$20        ; 0f37  A0 20   
    LDA #$20        ; 0f39  A9 20   
    STX $8011       ; 0f3b  8E 11 80
    STY $8012       ; 0f3e  8C 12 80
    STA $8013       ; 0f41  8D 13 80
    LDA #$20        ; 0f44  A9 20   
    STA $8014       ; 0f46  8D 14 80
    LDA #$20        ; 0f49  A9 20   
    STA $8015       ; 0f4b  8D 15 80
    LDA #$20        ; 0f4e  A9 20   
    STA $8016       ; 0f50  8D 16 80
    LDA #$20        ; 0f53  A9 20   
    STA $8017       ; 0f55  8D 17 80
    LDA #$20        ; 0f58  A9 20   
    STA $8018       ; 0f5a  8D 18 80
    LDA #$20        ; 0f5d  A9 20   
    STA $8019       ; 0f5f  8D 19 80
    LDA #$00        ; 0f62  A9 00   
    STA $031A       ; 0f64  8D 1A 03

    LDY #$DD        ; 0f67  A0 DD   
i0F69:                             
    NOP             ; 0f69  EA      
    NOP             ; 0f6a  EA      
    NOP             ; 0f6b  EA      
    NOP             ; 0f6c  EA      
    NOP             ; 0f6d  EA      
    NOP             ; 0f6e  EA      
    DEY             ; 0f6f  88      
    BNE i0F69       ; 0f70  D0 F7   

    LDX #$20        ; 0f72  A2 20   
    LDY #$20        ; 0f74  A0 20   
    LDA #$67        ; 0f76  A9 67   
    STX $8011       ; 0f78  8E 11 80
    STY $8012       ; 0f7b  8C 12 80
    STA $8013       ; 0f7e  8D 13 80
    LDA #$20        ; 0f81  A9 20   
    STA $8014       ; 0f83  8D 14 80
    LDA #$20        ; 0f86  A9 20   
    STA $8015       ; 0f88  8D 15 80
    LDA #$20        ; 0f8b  A9 20   
    STA $8016       ; 0f8d  8D 16 80
    LDA #$20        ; 0f90  A9 20   
    STA $8017       ; 0f92  8D 17 80
    LDA #$20        ; 0f95  A9 20   
    STA $8018       ; 0f97  8D 18 80
    LDA #$20        ; 0f9a  A9 20   
    STA $8019       ; 0f9c  8D 19 80
    LDA #$00        ; 0f9f  A9 00   
    STA $031A       ; 0fa1  8D 1A 03

    NOP             ; 0fa4  EA      
    NOP             ; 0fa5  EA      

    LDX #$E5        ; 0fa6  A2 E5   
    LDY #$A0        ; 0fa8  A0 A0   
    LDA #$76        ; 0faa  A9 76   
    STX $8011       ; 0fac  8E 11 80
    STY $8012       ; 0faf  8C 12 80
    STA $8013       ; 0fb2  8D 13 80
    LDA #$A0        ; 0fb5  A9 A0   
    STA $8014       ; 0fb7  8D 14 80
    LDA #$A0        ; 0fba  A9 A0   
    STA $8015       ; 0fbc  8D 15 80
    LDA #$A0        ; 0fbf  A9 A0   
    STA $8016       ; 0fc1  8D 16 80
    LDA #$A0        ; 0fc4  A9 A0   
    STA $8017       ; 0fc6  8D 17 80
    LDA #$A0        ; 0fc9  A9 A0   
    STA $8018       ; 0fcb  8D 18 80
    LDA #$E7        ; 0fce  A9 E7   
    STA $8019       ; 0fd0  8D 19 80
    LDA #$00        ; 0fd3  A9 00   
    STA $031A       ; 0fd5  8D 1A 03

    NOP             ; 0fd8  EA      
    NOP             ; 0fd9  EA      

    LDX #$A0        ; 0fda  A2 A0   
    LDY #$A0        ; 0fdc  A0 A0   
    LDA #$F5        ; 0fde  A9 F5   
    STX $8011       ; 0fe0  8E 11 80
    STY $8012       ; 0fe3  8C 12 80
    STA $8013       ; 0fe6  8D 13 80
    LDA #$A0        ; 0fe9  A9 A0   
    STA $8014       ; 0feb  8D 14 80
    LDA #$A0        ; 0fee  A9 A0   
    STA $8015       ; 0ff0  8D 15 80
    LDA #$A0        ; 0ff3  A9 A0   
    STA $8016       ; 0ff5  8D 16 80
    LDA #$A0        ; 0ff8  A9 A0   
    STA $8017       ; 0ffa  8D 17 80
    LDA #$A0        ; 0ffd  A9 A0   
    STA $8018       ; 0fff  8D 18 80
    LDA #$A0        ; 1002  A9 A0   
    STA $8019       ; 1004  8D 19 80
    LDA #$20        ; 1007  A9 20   
    STA $031A       ; 1009  8D 1A 03

    NOP             ; 100c  EA      
    NOP             ; 100d  EA      

    LDX #$A0        ; 100e  A2 A0   
    LDY #$A0        ; 1010  A0 A0   
    LDA #$76        ; 1012  A9 76   
    STX $8011       ; 1014  8E 11 80
    STY $8012       ; 1017  8C 12 80
    STA $8013       ; 101a  8D 13 80
    LDA #$A0        ; 101d  A9 A0   
    STA $8014       ; 101f  8D 14 80
    LDA #$A0        ; 1022  A9 A0   
    STA $8015       ; 1024  8D 15 80
    LDA #$A0        ; 1027  A9 A0   
    STA $8016       ; 1029  8D 16 80
    LDA #$A0        ; 102c  A9 A0   
    STA $8017       ; 102e  8D 17 80
    LDA #$A0        ; 1031  A9 A0   
    STA $8018       ; 1033  8D 18 80
    LDA #$A0        ; 1036  A9 A0   
    STA $8019       ; 1038  8D 19 80
    LDA #$20        ; 103b  A9 20   
    STA $031A       ; 103d  8D 1A 03

    NOP             ; 1040  EA      
    NOP             ; 1041  EA      

    LDX #$EA        ; 1042  A2 EA   
    LDY #$20        ; 1044  A0 20   
    LDA #$67        ; 1046  A9 67   
    STX $8011       ; 1048  8E 11 80
    STY $8012       ; 104b  8C 12 80
    STA $8013       ; 104e  8D 13 80
    LDA #$20        ; 1051  A9 20   
    STA $8014       ; 1053  8D 14 80
    LDA #$20        ; 1056  A9 20   
    STA $8015       ; 1058  8D 15 80
    LDA #$20        ; 105b  A9 20   
    STA $8016       ; 105d  8D 16 80
    LDA #$20        ; 1060  A9 20   
    STA $8017       ; 1062  8D 17 80
    LDA #$20        ; 1065  A9 20   
    STA $8018       ; 1067  8D 18 80
    LDA #$F4        ; 106a  A9 F4   
    STA $8019       ; 106c  8D 19 80
    LDA #$20        ; 106f  A9 20   
    STA $031A       ; 1071  8D 1A 03

    NOP             ; 1074  EA      
    NOP             ; 1075  EA      

    LDX #$F6        ; 1076  A2 F6   
    LDY #$20        ; 1078  A0 20   
    LDA #$20        ; 107a  A9 20   
    STX $8011       ; 107c  8E 11 80
    STY $8012       ; 107f  8C 12 80
    STA $8013       ; 1082  8D 13 80
    LDA #$20        ; 1085  A9 20   
    STA $8014       ; 1087  8D 14 80
    LDA #$20        ; 108a  A9 20   
    STA $8015       ; 108c  8D 15 80
    LDA #$20        ; 108f  A9 20   
    STA $8016       ; 1091  8D 16 80
    LDA #$20        ; 1094  A9 20   
    STA $8017       ; 1096  8D 17 80
    LDA #$20        ; 1099  A9 20   
    STA $8018       ; 109b  8D 18 80
    LDA #$F5        ; 109e  A9 F5   
    STA $8019       ; 10a0  8D 19 80
    LDA #$20        ; 10a3  A9 20   
    STA $031A       ; 10a5  8D 1A 03

    NOP             ; 10a8  EA      
    NOP             ; 10a9  EA      

    LDX #$F6        ; 10aa  A2 F6   
    LDY #$20        ; 10ac  A0 20   
    LDA #$20        ; 10ae  A9 20   
    STX $8011       ; 10b0  8E 11 80
    STY $8012       ; 10b3  8C 12 80
    STA $8013       ; 10b6  8D 13 80
    LDA #$20        ; 10b9  A9 20   
    STA $8014       ; 10bb  8D 14 80
    LDA #$20        ; 10be  A9 20   
    STA $8015       ; 10c0  8D 15 80
    LDA #$20        ; 10c3  A9 20   
    STA $8016       ; 10c5  8D 16 80
    LDA #$20        ; 10c8  A9 20   
    STA $8017       ; 10ca  8D 17 80
    LDA #$20        ; 10cd  A9 20   
    STA $8018       ; 10cf  8D 18 80
    LDA #$F5        ; 10d2  A9 F5   
    STA $8019       ; 10d4  8D 19 80
    LDA #$20        ; 10d7  A9 20   
    STA $031A       ; 10d9  8D 1A 03

    NOP             ; 10dc  EA      
    NOP             ; 10dd  EA      

    LDX #$F6        ; 10de  A2 F6   
    LDY #$51        ; 10e0  A0 51   
    LDA #$56        ; 10e2  A9 56   
    STX $8039       ; 10e4  8E 39 80
    STY $803A       ; 10e7  8C 3A 80
    STA $803B       ; 10ea  8D 3B 80
    LDA #$66        ; 10ed  A9 66   
    STA $803C       ; 10ef  8D 3C 80
    LDA #$5A        ; 10f2  A9 5A   
    STA $803D       ; 10f4  8D 3D 80
    LDA #$66        ; 10f7  A9 66   
    STA $803E       ; 10f9  8D 3E 80
    LDA #$4A        ; 10fc  A9 4A   
    STA $803F       ; 10fe  8D 3F 80
    LDA #$2A        ; 1101  A9 2A   
    STA $8040       ; 1103  8D 40 80
    LDA #$F5        ; 1106  A9 F5   
    STA $8041       ; 1108  8D 41 80
    LDA #$20        ; 110b  A9 20   
    STA $0342       ; 110d  8D 42 03

    NOP             ; 1110  EA      
    NOP             ; 1111  EA      

    LDX #$F6        ; 1112  A2 F6   
    LDY #$51        ; 1114  A0 51   
    LDA #$56        ; 1116  A9 56   
    STX $8039       ; 1118  8E 39 80
    STY $803A       ; 111b  8C 3A 80
    STA $803B       ; 111e  8D 3B 80
    LDA #$66        ; 1121  A9 66   
    STA $803C       ; 1123  8D 3C 80
    LDA #$5A        ; 1126  A9 5A   
    STA $803D       ; 1128  8D 3D 80
    LDA #$E6        ; 112b  A9 E6   
    STA $803E       ; 112d  8D 3E 80
    LDA #$4A        ; 1130  A9 4A   
    STA $803F       ; 1132  8D 3F 80
    LDA #$2A        ; 1135  A9 2A   
    STA $8040       ; 1137  8D 40 80
    LDA #$F5        ; 113a  A9 F5   
    STA $8041       ; 113c  8D 41 80
    LDA #$20        ; 113f  A9 20   
    STA $0342       ; 1141  8D 42 03

    NOP             ; 1144  EA      
    NOP             ; 1145  EA      

    LDX #$F6        ; 1146  A2 F6   
    LDY #$51        ; 1148  A0 51   
    LDA #$56        ; 114a  A9 56   
    STX $8039       ; 114c  8E 39 80
    STY $803A       ; 114f  8C 3A 80
    STA $803B       ; 1152  8D 3B 80
    LDA #$66        ; 1155  A9 66   
    STA $803C       ; 1157  8D 3C 80
    LDA #$5A        ; 115a  A9 5A   
    STA $803D       ; 115c  8D 3D 80
    LDA #$66        ; 115f  A9 66   
    STA $803E       ; 1161  8D 3E 80
    LDA #$4A        ; 1164  A9 4A   
    STA $803F       ; 1166  8D 3F 80
    LDA #$2A        ; 1169  A9 2A   
    STA $8040       ; 116b  8D 40 80
    LDA #$F5        ; 116e  A9 F5   
    STA $8041       ; 1170  8D 41 80
    LDA #$20        ; 1173  A9 20   
    STA $0342       ; 1175  8D 42 03

    NOP             ; 1178  EA      
    NOP             ; 1179  EA      

    LDX #$F6        ; 117a  A2 F6   
    LDY #$51        ; 117c  A0 51   
    LDA #$56        ; 117e  A9 56   
    STX $8039       ; 1180  8E 39 80
    STY $803A       ; 1183  8C 3A 80
    STA $803B       ; 1186  8D 3B 80
    LDA #$66        ; 1189  A9 66   
    STA $803C       ; 118b  8D 3C 80
    LDA #$5A        ; 118e  A9 5A   
    STA $803D       ; 1190  8D 3D 80
    LDA #$E6        ; 1193  A9 E6   
    STA $803E       ; 1195  8D 3E 80
    LDA #$4A        ; 1198  A9 4A   
    STA $803F       ; 119a  8D 3F 80
    LDA #$2A        ; 119d  A9 2A   
    STA $8040       ; 119f  8D 40 80
    LDA #$F5        ; 11a2  A9 F5   
    STA $8041       ; 11a4  8D 41 80
    LDA #$20        ; 11a7  A9 20   
    STA $0342       ; 11a9  8D 42 03

    NOP             ; 11ac  EA      
    NOP             ; 11ad  EA      

    LDX #$F6        ; 11ae  A2 F6   
    LDY #$57        ; 11b0  A0 57   
    LDA #$5A        ; 11b2  A9 5A   
    STX $8039       ; 11b4  8E 39 80
    STY $803A       ; 11b7  8C 3A 80
    STA $803B       ; 11ba  8D 3B 80
    LDA #$6C        ; 11bd  A9 6C   
    STA $803C       ; 11bf  8D 3C 80
    LDA #$E9        ; 11c2  A9 E9   
    STA $803D       ; 11c4  8D 3D 80
    LDA #$66        ; 11c7  A9 66   
    STA $803E       ; 11c9  8D 3E 80
    LDA #$55        ; 11cc  A9 55   
    STA $803F       ; 11ce  8D 3F 80
    LDA #$5D        ; 11d1  A9 5D   
    STA $8040       ; 11d3  8D 40 80
    LDA #$F5        ; 11d6  A9 F5   
    STA $8041       ; 11d8  8D 41 80
    LDA #$20        ; 11db  A9 20   
    STA $0342       ; 11dd  8D 42 03

    NOP             ; 11e0  EA      
    NOP             ; 11e1  EA      

    LDX #$F6        ; 11e2  A2 F6   
    LDY #$57        ; 11e4  A0 57   
    LDA #$5A        ; 11e6  A9 5A   
    STX $8039       ; 11e8  8E 39 80
    STY $803A       ; 11eb  8C 3A 80
    STA $803B       ; 11ee  8D 3B 80
    LDA #$6C        ; 11f1  A9 6C   
    STA $803C       ; 11f3  8D 3C 80
    LDA #$E9        ; 11f6  A9 E9   
    STA $803D       ; 11f8  8D 3D 80
    LDA #$E6        ; 11fb  A9 E6   
    STA $803E       ; 11fd  8D 3E 80
    LDA #$55        ; 1200  A9 55   
    STA $803F       ; 1202  8D 3F 80
    LDA #$5D        ; 1205  A9 5D   
    STA $8040       ; 1207  8D 40 80
    LDA #$F5        ; 120a  A9 F5   
    STA $8041       ; 120c  8D 41 80
    LDA #$20        ; 120f  A9 20   
    STA $0342       ; 1211  8D 42 03

    NOP             ; 1214  EA      
    NOP             ; 1215  EA      

    LDX #$F6        ; 1216  A2 F6   
    LDY #$57        ; 1218  A0 57   
    LDA #$5A        ; 121a  A9 5A   
    STX $8039       ; 121c  8E 39 80
    STY $803A       ; 121f  8C 3A 80
    STA $803B       ; 1222  8D 3B 80
    LDA #$6C        ; 1225  A9 6C   
    STA $803C       ; 1227  8D 3C 80
    LDA #$E9        ; 122a  A9 E9   
    STA $803D       ; 122c  8D 3D 80
    LDA #$66        ; 122f  A9 66   
    STA $803E       ; 1231  8D 3E 80
    LDA #$55        ; 1234  A9 55   
    STA $803F       ; 1236  8D 3F 80
    LDA #$5D        ; 1239  A9 5D   
    STA $8040       ; 123b  8D 40 80
    LDA #$F5        ; 123e  A9 F5   
    STA $8041       ; 1240  8D 41 80
    LDA #$20        ; 1243  A9 20   
    STA $0342       ; 1245  8D 42 03

    NOP             ; 1248  EA      
    NOP             ; 1249  EA      

    LDX #$F6        ; 124a  A2 F6   
    LDY #$57        ; 124c  A0 57   
    LDA #$5A        ; 124e  A9 5A   
    STX $8039       ; 1250  8E 39 80
    STY $803A       ; 1253  8C 3A 80
    STA $803B       ; 1256  8D 3B 80
    LDA #$6C        ; 1259  A9 6C   
    STA $803C       ; 125b  8D 3C 80
    LDA #$E9        ; 125e  A9 E9   
    STA $803D       ; 1260  8D 3D 80
    LDA #$E6        ; 1263  A9 E6   
    STA $803E       ; 1265  8D 3E 80
    LDA #$55        ; 1268  A9 55   
    STA $803F       ; 126a  8D 3F 80
    LDA #$5D        ; 126d  A9 5D   
    STA $8040       ; 126f  8D 40 80
    LDA #$F5        ; 1272  A9 F5   
    STA $8041       ; 1274  8D 41 80
    LDA #$20        ; 1277  A9 20   
    STA $0342       ; 1279  8D 42 03

    NOP             ; 127c  EA      
    NOP             ; 127d  EA      

    LDX #$F6        ; 127e  A2 F6   
    LDY #$A0        ; 1280  A0 A0   
    LDA #$58        ; 1282  A9 58   
    STX $8061       ; 1284  8E 61 80
    STY $8062       ; 1287  8C 62 80
    STA $8063       ; 128a  8D 63 80
    LDA #$A0        ; 128d  A9 A0   
    STA $8064       ; 128f  8D 64 80
    LDA #$4E        ; 1292  A9 4E   
    STA $8065       ; 1294  8D 65 80
    LDA #$20        ; 1297  A9 20   
    STA $8066       ; 1299  8D 66 80
    LDA #$20        ; 129c  A9 20   
    STA $8067       ; 129e  8D 67 80
    LDA #$20        ; 12a1  A9 20   
    STA $8068       ; 12a3  8D 68 80
    LDA #$F5        ; 12a6  A9 F5   
    STA $8069       ; 12a8  8D 69 80
    LDA #$20        ; 12ab  A9 20   
    STA $036A       ; 12ad  8D 6A 03

    NOP             ; 12b0  EA      
    NOP             ; 12b1  EA      

    LDX #$F6        ; 12b2  A2 F6   
    LDY #$20        ; 12b4  A0 20   
    LDA #$58        ; 12b6  A9 58   
    STX $8061       ; 12b8  8E 61 80
    STY $8062       ; 12bb  8C 62 80
    STA $8063       ; 12be  8D 63 80
    LDA #$A0        ; 12c1  A9 A0   
    STA $8064       ; 12c3  8D 64 80
    LDA #$4E        ; 12c6  A9 4E   
    STA $8065       ; 12c8  8D 65 80
    LDA #$20        ; 12cb  A9 20   
    STA $8066       ; 12cd  8D 66 80
    LDA #$20        ; 12d0  A9 20   
    STA $8067       ; 12d2  8D 67 80
    LDA #$20        ; 12d5  A9 20   
    STA $8068       ; 12d7  8D 68 80
    LDA #$F5        ; 12da  A9 F5   
    STA $8069       ; 12dc  8D 69 80
    LDA #$20        ; 12df  A9 20   
    STA $036A       ; 12e1  8D 6A 03

    NOP             ; 12e4  EA      
    NOP             ; 12e5  EA      

    LDX #$F6        ; 12e6  A2 F6   
    LDY #$A0        ; 12e8  A0 A0   
    LDA #$58        ; 12ea  A9 58   
    STX $8061       ; 12ec  8E 61 80
    STY $8062       ; 12ef  8C 62 80
    STA $8063       ; 12f2  8D 63 80
    LDA #$A0        ; 12f5  A9 A0   
    STA $8064       ; 12f7  8D 64 80
    LDA #$4E        ; 12fa  A9 4E   
    STA $8065       ; 12fc  8D 65 80
    LDA #$20        ; 12ff  A9 20   
    STA $8066       ; 1301  8D 66 80
    LDA #$20        ; 1304  A9 20   
    STA $8067       ; 1306  8D 67 80
    LDA #$F5        ; 1309  A9 F5   
    STA $8068       ; 130b  8D 68 80
    LDA #$F5        ; 130e  A9 F5   
    STA $8069       ; 1310  8D 69 80
    LDA #$20        ; 1313  A9 20   
    STA $036A       ; 1315  8D 6A 03

    NOP             ; 1318  EA      
    NOP             ; 1319  EA      

    LDX #$F6        ; 131a  A2 F6   
    LDY #$20        ; 131c  A0 20   
    LDA #$58        ; 131e  A9 58   
    STX $8061       ; 1320  8E 61 80
    STY $8062       ; 1323  8C 62 80
    STA $8063       ; 1326  8D 63 80
    LDA #$A0        ; 1329  A9 A0   
    STA $8064       ; 132b  8D 64 80
    LDA #$4E        ; 132e  A9 4E   
    STA $8065       ; 1330  8D 65 80
    LDA #$5D        ; 1333  A9 5D   
    STA $8066       ; 1335  8D 66 80
    LDA #$74        ; 1338  A9 74   
    STA $8067       ; 133a  8D 67 80
    LDA #$42        ; 133d  A9 42   
    STA $8068       ; 133f  8D 68 80
    LDA #$F5        ; 1342  A9 F5   
    STA $8069       ; 1344  8D 69 80
    LDA #$20        ; 1347  A9 20   
    STA $036A       ; 1349  8D 6A 03

    NOP             ; 134c  EA      
    NOP             ; 134d  EA      

    LDX #$F6        ; 134e  A2 F6   
    LDY #$A0        ; 1350  A0 A0   
    LDA #$A0        ; 1352  A9 A0   
    STX $8061       ; 1354  8E 61 80
    STY $8062       ; 1357  8C 62 80
    STA $8063       ; 135a  8D 63 80
    LDA #$DC        ; 135d  A9 DC   
    STA $8064       ; 135f  8D 64 80
    LDA #$56        ; 1362  A9 56   
    STA $8065       ; 1364  8D 65 80
    LDA #$20        ; 1367  A9 20   
    STA $8066       ; 1369  8D 66 80
    LDA #$74        ; 136c  A9 74   
    STA $8067       ; 136e  8D 67 80
    LDA #$42        ; 1371  A9 42   
    STA $8068       ; 1373  8D 68 80
    LDA #$F5        ; 1376  A9 F5   
    STA $8069       ; 1378  8D 69 80
    LDA #$20        ; 137b  A9 20   
    STA $036A       ; 137d  8D 6A 03

    NOP             ; 1380  EA      
    NOP             ; 1381  EA      

    LDX #$F6        ; 1382  A2 F6   
    LDY #$20        ; 1384  A0 20   
    LDA #$A0        ; 1386  A9 A0   
    STX $8061       ; 1388  8E 61 80
    STY $8062       ; 138b  8C 62 80
    STA $8063       ; 138e  8D 63 80
    LDA #$DC        ; 1391  A9 DC   
    STA $8064       ; 1393  8D 64 80
    LDA #$56        ; 1396  A9 56   
    STA $8065       ; 1398  8D 65 80
    LDA #$20        ; 139b  A9 20   
    STA $8066       ; 139d  8D 66 80
    LDA #$20        ; 13a0  A9 20   
    STA $8067       ; 13a2  8D 67 80
    LDA #$F5        ; 13a5  A9 F5   
    STA $8068       ; 13a7  8D 68 80
    LDA #$F5        ; 13aa  A9 F5   
    STA $8069       ; 13ac  8D 69 80
    LDA #$20        ; 13af  A9 20   
    STA $036A       ; 13b1  8D 6A 03

    NOP             ; 13b4  EA      
    NOP             ; 13b5  EA      

    LDX #$F6        ; 13b6  A2 F6   
    LDY #$A0        ; 13b8  A0 A0   
    LDA #$A0        ; 13ba  A9 A0   
    STX $8061       ; 13bc  8E 61 80
    STY $8062       ; 13bf  8C 62 80
    STA $8063       ; 13c2  8D 63 80
    LDA #$DC        ; 13c5  A9 DC   
    STA $8064       ; 13c7  8D 64 80
    LDA #$56        ; 13ca  A9 56   
    STA $8065       ; 13cc  8D 65 80
    LDA #$20        ; 13cf  A9 20   
    STA $8066       ; 13d1  8D 66 80
    LDA #$20        ; 13d4  A9 20   
    STA $8067       ; 13d6  8D 67 80
    LDA #$20        ; 13d9  A9 20   
    STA $8068       ; 13db  8D 68 80
    LDA #$F5        ; 13de  A9 F5   
    STA $8069       ; 13e0  8D 69 80
    LDA #$20        ; 13e3  A9 20   
    STA $036A       ; 13e5  8D 6A 03

    NOP             ; 13e8  EA      
    NOP             ; 13e9  EA      

    LDX #$F6        ; 13ea  A2 F6   
    LDY #$57        ; 13ec  A0 57   
    LDA #$A0        ; 13ee  A9 A0   
    STX $8061       ; 13f0  8E 61 80
    STY $8062       ; 13f3  8C 62 80
    STA $8063       ; 13f6  8D 63 80
    LDA #$DC        ; 13f9  A9 DC   
    STA $8064       ; 13fb  8D 64 80
    LDA #$56        ; 13fe  A9 56   
    STA $8065       ; 1400  8D 65 80
    LDA #$20        ; 1403  A9 20   
    STA $8066       ; 1405  8D 66 80
    LDA #$20        ; 1408  A9 20   
    STA $8067       ; 140a  8D 67 80
    LDA #$20        ; 140d  A9 20   
    STA $8068       ; 140f  8D 68 80
    LDA #$F5        ; 1412  A9 F5   
    STA $8069       ; 1414  8D 69 80
    LDA #$20        ; 1417  A9 20   
    STA $036A       ; 1419  8D 6A 03

    NOP             ; 141c  EA      
    NOP             ; 141d  EA      

    LDX #$F6        ; 141e  A2 F6   
    LDY #$57        ; 1420  A0 57   
    LDA #$20        ; 1422  A9 20   
    STX $8089       ; 1424  8E 89 80
    STY $808A       ; 1427  8C 8A 80
    STA $808B       ; 142a  8D 8B 80
    LDA #$20        ; 142d  A9 20   
    STA $808C       ; 142f  8D 8C 80
    LDA #$20        ; 1432  A9 20   
    STA $808D       ; 1434  8D 8D 80
    LDA #$20        ; 1437  A9 20   
    STA $808E       ; 1439  8D 8E 80
    LDA #$20        ; 143c  A9 20   
    STA $808F       ; 143e  8D 8F 80
    LDA #$20        ; 1441  A9 20   
    STA $8090       ; 1443  8D 90 80
    LDA #$F5        ; 1446  A9 F5   
    STA $8091       ; 1448  8D 91 80
    LDA #$20        ; 144b  A9 20   
    STA $0392       ; 144d  8D 92 03

    NOP             ; 1450  EA      
    NOP             ; 1451  EA      

    LDX #$F6        ; 1452  A2 F6   
    LDY #$57        ; 1454  A0 57   
    LDA #$20        ; 1456  A9 20   
    STX $8089       ; 1458  8E 89 80
    STY $808A       ; 145b  8C 8A 80
    STA $808B       ; 145e  8D 8B 80
    LDA #$61        ; 1461  A9 61   
    STA $808C       ; 1463  8D 8C 80
    LDA #$5C        ; 1466  A9 5C   
    STA $808D       ; 1468  8D 8D 80
    LDA #$56        ; 146b  A9 56   
    STA $808E       ; 146d  8D 8E 80
    LDA #$5F        ; 1470  A9 5F   
    STA $808F       ; 1472  8D 8F 80
    LDA #$20        ; 1475  A9 20   
    STA $8090       ; 1477  8D 90 80
    LDA #$F5        ; 147a  A9 F5   
    STA $8091       ; 147c  8D 91 80
    LDA #$20        ; 147f  A9 20   
    STA $0392       ; 1481  8D 92 03

    NOP             ; 1484  EA      
    NOP             ; 1485  EA      

    LDX #$F6        ; 1486  A2 F6   
    LDY #$57        ; 1488  A0 57   
    LDA #$20        ; 148a  A9 20   
    STX $8089       ; 148c  8E 89 80
    STY $808A       ; 148f  8C 8A 80
    STA $808B       ; 1492  8D 8B 80
    LDA #$E1        ; 1495  A9 E1   
    STA $808C       ; 1497  8D 8C 80
    LDA #$5C        ; 149a  A9 5C   
    STA $808D       ; 149c  8D 8D 80
    LDA #$56        ; 149f  A9 56   
    STA $808E       ; 14a1  8D 8E 80
    LDA #$5F        ; 14a4  A9 5F   
    STA $808F       ; 14a6  8D 8F 80
    LDA #$20        ; 14a9  A9 20   
    STA $8090       ; 14ab  8D 90 80
    LDA #$F5        ; 14ae  A9 F5   
    STA $8091       ; 14b0  8D 91 80
    LDA #$20        ; 14b3  A9 20   
    STA $0392       ; 14b5  8D 92 03

    NOP             ; 14b8  EA      
    NOP             ; 14b9  EA      

    LDX #$F6        ; 14ba  A2 F6   
    LDY #$57        ; 14bc  A0 57   
    LDA #$5D        ; 14be  A9 5D   
    STX $8089       ; 14c0  8E 89 80
    STY $808A       ; 14c3  8C 8A 80
    STA $808B       ; 14c6  8D 8B 80
    LDA #$61        ; 14c9  A9 61   
    STA $808C       ; 14cb  8D 8C 80
    LDA #$5C        ; 14ce  A9 5C   
    STA $808D       ; 14d0  8D 8D 80
    LDA #$56        ; 14d3  A9 56   
    STA $808E       ; 14d5  8D 8E 80
    LDA #$5F        ; 14d8  A9 5F   
    STA $808F       ; 14da  8D 8F 80
    LDA #$20        ; 14dd  A9 20   
    STA $8090       ; 14df  8D 90 80
    LDA #$F5        ; 14e2  A9 F5   
    STA $8091       ; 14e4  8D 91 80
    LDA #$20        ; 14e7  A9 20   
    STA $0392       ; 14e9  8D 92 03

    NOP             ; 14ec  EA      
    NOP             ; 14ed  EA      

    LDX #$F6        ; 14ee  A2 F6   
    LDY #$57        ; 14f0  A0 57   
    LDA #$48        ; 14f2  A9 48   
    STX $8089       ; 14f4  8E 89 80
    STY $808A       ; 14f7  8C 8A 80
    STA $808B       ; 14fa  8D 8B 80
    LDA #$E1        ; 14fd  A9 E1   
    STA $808C       ; 14ff  8D 8C 80
    LDA #$5C        ; 1502  A9 5C   
    STA $808D       ; 1504  8D 8D 80
    LDA #$56        ; 1507  A9 56   
    STA $808E       ; 1509  8D 8E 80
    LDA #$5F        ; 150c  A9 5F   
    STA $808F       ; 150e  8D 8F 80
    LDA #$20        ; 1511  A9 20   
    STA $8090       ; 1513  8D 90 80
    LDA #$F5        ; 1516  A9 F5   
    STA $8091       ; 1518  8D 91 80
    LDA #$20        ; 151b  A9 20   
    STA $0392       ; 151d  8D 92 03

    NOP             ; 1520  EA      
    NOP             ; 1521  EA      

    LDX #$F6        ; 1522  A2 F6   
    LDY #$51        ; 1524  A0 51   
    LDA #$E7        ; 1526  A9 E7   
    STX $8089       ; 1528  8E 89 80
    STY $808A       ; 152b  8C 8A 80
    STA $808B       ; 152e  8D 8B 80
    LDA #$61        ; 1531  A9 61   
    STA $808C       ; 1533  8D 8C 80
    LDA #$20        ; 1536  A9 20   
    STA $808D       ; 1538  8D 8D 80
    LDA #$57        ; 153b  A9 57   
    STA $808E       ; 153d  8D 8E 80
    LDA #$DF        ; 1540  A9 DF   
    STA $808F       ; 1542  8D 8F 80
    LDA #$20        ; 1545  A9 20   
    STA $8090       ; 1547  8D 90 80
    LDA #$F5        ; 154a  A9 F5   
    STA $8091       ; 154c  8D 91 80
    LDA #$20        ; 154f  A9 20   
    STA $0392       ; 1551  8D 92 03

    NOP             ; 1554  EA      
    NOP             ; 1555  EA      

    LDX #$F6        ; 1556  A2 F6   
    LDY #$51        ; 1558  A0 51   
    LDA #$48        ; 155a  A9 48   
    STX $8089       ; 155c  8E 89 80
    STY $808A       ; 155f  8C 8A 80
    STA $808B       ; 1562  8D 8B 80
    LDA #$E1        ; 1565  A9 E1   
    STA $808C       ; 1567  8D 8C 80
    LDA #$20        ; 156a  A9 20   
    STA $808D       ; 156c  8D 8D 80
    LDA #$57        ; 156f  A9 57   
    STA $808E       ; 1571  8D 8E 80
    LDA #$DF        ; 1574  A9 DF   
    STA $808F       ; 1576  8D 8F 80
    LDA #$20        ; 1579  A9 20   
    STA $8090       ; 157b  8D 90 80
    LDA #$F5        ; 157e  A9 F5   
    STA $8091       ; 1580  8D 91 80
    LDA #$20        ; 1583  A9 20   
    STA $0392       ; 1585  8D 92 03

    NOP             ; 1588  EA      
    NOP             ; 1589  EA      

    LDX #$F6        ; 158a  A2 F6   
    LDY #$51        ; 158c  A0 51   
    LDA #$5D        ; 158e  A9 5D   
    STX $8089       ; 1590  8E 89 80
    STY $808A       ; 1593  8C 8A 80
    STA $808B       ; 1596  8D 8B 80
    LDA #$61        ; 1599  A9 61   
    STA $808C       ; 159b  8D 8C 80
    LDA #$20        ; 159e  A9 20   
    STA $808D       ; 15a0  8D 8D 80
    LDA #$57        ; 15a3  A9 57   
    STA $808E       ; 15a5  8D 8E 80
    LDA #$DF        ; 15a8  A9 DF   
    STA $808F       ; 15aa  8D 8F 80
    LDA #$6A        ; 15ad  A9 6A   
    STA $8090       ; 15af  8D 90 80
    LDA #$F5        ; 15b2  A9 F5   
    STA $8091       ; 15b4  8D 91 80
    LDA #$20        ; 15b7  A9 20   
    STA $0392       ; 15b9  8D 92 03

    NOP             ; 15bc  EA      
    NOP             ; 15bd  EA      

    LDX #$F6        ; 15be  A2 F6   
    LDY #$51        ; 15c0  A0 51   
    LDA #$20        ; 15c2  A9 20   
    STX $80B1       ; 15c4  8E B1 80
    STY $80B2       ; 15c7  8C B2 80
    STA $80B3       ; 15ca  8D B3 80
    LDA #$E1        ; 15cd  A9 E1   
    STA $80B4       ; 15cf  8D B4 80
    LDA #$20        ; 15d2  A9 20   
    STA $80B5       ; 15d4  8D B5 80
    LDA #$57        ; 15d7  A9 57   
    STA $80B6       ; 15d9  8D B6 80
    LDA #$DF        ; 15dc  A9 DF   
    STA $80B7       ; 15de  8D B7 80
    LDA #$6A        ; 15e1  A9 6A   
    STA $80B8       ; 15e3  8D B8 80
    LDA #$F5        ; 15e6  A9 F5   
    STA $80B9       ; 15e8  8D B9 80
    LDA #$20        ; 15eb  A9 20   
    STA $03BA       ; 15ed  8D BA 03

    NOP             ; 15f0  EA      
    NOP             ; 15f1  EA      

    LDX #$F6        ; 15f2  A2 F6   
    LDY #$20        ; 15f4  A0 20   
    LDA #$20        ; 15f6  A9 20   
    STX $80B1       ; 15f8  8E B1 80
    STY $80B2       ; 15fb  8C B2 80
    STA $80B3       ; 15fe  8D B3 80
    LDA #$20        ; 1601  A9 20   
    STA $80B4       ; 1603  8D B4 80
    LDA #$20        ; 1606  A9 20   
    STA $80B5       ; 1608  8D B5 80
    LDA #$20        ; 160b  A9 20   
    STA $80B6       ; 160d  8D B6 80
    LDA #$20        ; 1610  A9 20   
    STA $80B7       ; 1612  8D B7 80
    LDA #$20        ; 1615  A9 20   
    STA $80B8       ; 1617  8D B8 80
    LDA #$F5        ; 161a  A9 F5   
    STA $80B9       ; 161c  8D B9 80
    LDA #$20        ; 161f  A9 20   
    STA $03BA       ; 1621  8D BA 03

    NOP             ; 1624  EA      
    NOP             ; 1625  EA      

    LDX #$EA        ; 1626  A2 EA   
    LDY #$20        ; 1628  A0 20   
    LDA #$20        ; 162a  A9 20   
    STX $80B1       ; 162c  8E B1 80
    STY $80B2       ; 162f  8C B2 80
    STA $80B3       ; 1632  8D B3 80
    LDA #$20        ; 1635  A9 20   
    STA $80B4       ; 1637  8D B4 80
    LDA #$20        ; 163a  A9 20   
    STA $80B5       ; 163c  8D B5 80
    LDA #$20        ; 163f  A9 20   
    STA $80B6       ; 1641  8D B6 80
    LDA #$65        ; 1644  A9 65   
    STA $80B7       ; 1646  8D B7 80
    LDA #$20        ; 1649  A9 20   
    STA $80B8       ; 164b  8D B8 80
    LDA #$F4        ; 164e  A9 F4   
    STA $80B9       ; 1650  8D B9 80
    LDA #$20        ; 1653  A9 20   
    STA $03BA       ; 1655  8D BA 03

    NOP             ; 1658  EA      
    NOP             ; 1659  EA      

    LDX #$A0        ; 165a  A2 A0   
    LDY #$A0        ; 165c  A0 A0   
    LDA #$A0        ; 165e  A9 A0   
    STX $80B1       ; 1660  8E B1 80
    STY $80B2       ; 1663  8C B2 80
    STA $80B3       ; 1666  8D B3 80
    LDA #$A0        ; 1669  A9 A0   
    STA $80B4       ; 166b  8D B4 80
    LDA #$A0        ; 166e  A9 A0   
    STA $80B5       ; 1670  8D B5 80
    LDA #$A0        ; 1673  A9 A0   
    STA $80B6       ; 1675  8D B6 80
    LDA #$75        ; 1678  A9 75   
    STA $80B7       ; 167a  8D B7 80
    LDA #$A0        ; 167d  A9 A0   
    STA $80B8       ; 167f  8D B8 80
    LDA #$A0        ; 1682  A9 A0   
    STA $80B9       ; 1684  8D B9 80
    LDA #$A0        ; 1687  A9 A0   
    STA $03BA       ; 1689  8D BA 03

    NOP             ; 168c  EA      
    NOP             ; 168d  EA      

    LDX #$A0        ; 168e  A2 A0   
    LDY #$A0        ; 1690  A0 A0   
    LDA #$A0        ; 1692  A9 A0   
    STX $80B1       ; 1694  8E B1 80
    STY $80B2       ; 1697  8C B2 80
    STA $80B3       ; 169a  8D B3 80
    LDA #$A0        ; 169d  A9 A0   
    STA $80B4       ; 169f  8D B4 80
    LDA #$A0        ; 16a2  A9 A0   
    STA $80B5       ; 16a4  8D B5 80
    LDA #$A0        ; 16a7  A9 A0   
    STA $80B6       ; 16a9  8D B6 80
    LDA #$F6        ; 16ac  A9 F6   
    STA $80B7       ; 16ae  8D B7 80
    LDA #$A0        ; 16b1  A9 A0   
    STA $80B8       ; 16b3  8D B8 80
    LDA #$A0        ; 16b6  A9 A0   
    STA $80B9       ; 16b8  8D B9 80
    LDA #$A0        ; 16bb  A9 A0   
    STA $03BA       ; 16bd  8D BA 03

    NOP             ; 16c0  EA      
    NOP             ; 16c1  EA      

    LDX #$E5        ; 16c2  A2 E5   
    LDY #$A0        ; 16c4  A0 A0   
    LDA #$A0        ; 16c6  A9 A0   
    STX $80B1       ; 16c8  8E B1 80
    STY $80B2       ; 16cb  8C B2 80
    STA $80B3       ; 16ce  8D B3 80
    LDA #$A0        ; 16d1  A9 A0   
    STA $80B4       ; 16d3  8D B4 80
    LDA #$A0        ; 16d6  A9 A0   
    STA $80B5       ; 16d8  8D B5 80
    LDA #$A0        ; 16db  A9 A0   
    STA $80B6       ; 16dd  8D B6 80
    LDA #$75        ; 16e0  A9 75   
    STA $80B7       ; 16e2  8D B7 80
    LDA #$A0        ; 16e5  A9 A0   
    STA $80B8       ; 16e7  8D B8 80
    LDA #$E7        ; 16ea  A9 E7   
    STA $80B9       ; 16ec  8D B9 80
    LDA #$20        ; 16ef  A9 20   
    STA $03BA       ; 16f1  8D BA 03

    NOP             ; 16f4  EA      
    NOP             ; 16f5  EA      

    LDX #$20        ; 16f6  A2 20   
    LDY #$20        ; 16f8  A0 20   
    LDA #$20        ; 16fa  A9 20   
    STX $80B1       ; 16fc  8E B1 80
    STY $80B2       ; 16ff  8C B2 80
    STA $80B3       ; 1702  8D B3 80
    LDA #$20        ; 1705  A9 20   
    STA $80B4       ; 1707  8D B4 80
    LDA #$20        ; 170a  A9 20   
    STA $80B5       ; 170c  8D B5 80
    LDA #$20        ; 170f  A9 20   
    STA $80B6       ; 1711  8D B6 80
    LDA #$65        ; 1714  A9 65   
    STA $80B7       ; 1716  8D B7 80
    LDA #$20        ; 1719  A9 20   
    STA $80B8       ; 171b  8D B8 80
    LDA #$20        ; 171e  A9 20   
    STA $80B9       ; 1720  8D B9 80
    LDA #$20        ; 1723  A9 20   
    STA $03BA       ; 1725  8D BA 03

    NOP             ; 1728  EA      
    NOP             ; 1729  EA      

    LDX #$20        ; 172a  A2 20   
    LDY #$20        ; 172c  A0 20   
    LDA #$20        ; 172e  A9 20   
    STX $80B1       ; 1730  8E B1 80
    STY $80B2       ; 1733  8C B2 80
    STA $80B3       ; 1736  8D B3 80
    LDA #$20        ; 1739  A9 20   
    STA $80B4       ; 173b  8D B4 80
    LDA #$20        ; 173e  A9 20   
    STA $80B5       ; 1740  8D B5 80
    LDA #$20        ; 1743  A9 20   
    STA $80B6       ; 1745  8D B6 80
    LDA #$20        ; 1748  A9 20   
    STA $80B7       ; 174a  8D B7 80
    LDA #$20        ; 174d  A9 20   
    STA $80B8       ; 174f  8D B8 80
    LDA #$20        ; 1752  A9 20   
    STA $80B9       ; 1754  8D B9 80
    LDA #$20        ; 1757  A9 20   
    STA $03BA       ; 1759  8D BA 03

    PLA             ; 175c  68      
    TAY             ; 175d  A8      
    PLA             ; 175e  68      
    TAX             ; 175f  AA      
    PLA             ; 1760  68      
    PLP             ; 1761  28      
i1763 = * + 1                      
i1764 = * + 2                      
    JMP i0F2A       ; 1762  4C 2A 0F
    BRK             ; 1765  00      
