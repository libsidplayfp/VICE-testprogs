
REUStatus		= $df00
REUCommand		= $df01
REUC64			= $df02
REUREU			= $df04
REUTransLen		= $df07
REUIRQMask		= $df09
REUAddrMode		= $df0a

REUStatusFault = $20		; Error during compare
REUCMDExecute = $80+$10	; Start transfer/compare/swap without waiting for write to $ff00
REUCMDExecuteFF00 = $80	; Start transfer/compare/swap after write access to $ff00 (for using RAM below I/O area $d000-$dfff)
REUCMDAutoload = $20		; Restore address and length registers after execute
REUCMDTransToREU = 0		; Bit 0-1 : 00 = transfer C64 -> REU
REUCMDTransToC64 = 1		; Bit 0-1 : 01 = transfer REU -> C64
REUCMDSwap = 2			; Bit 0-1 : 10 = swap C64 <-> REU
REUCMDCompare = 3		; Bit 0-1 : 11 = compare C64 - REU
REUAddrFixedC64 = $80	; Bit 7 : C64 ADDRESS CONTROL  (1 = fix C64 address)
REUAddrFixedREU = $40	; Bit 6 : REU ADDRESS CONTROL  (1 = fix REU address)
