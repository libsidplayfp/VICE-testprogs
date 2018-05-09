;----------------------------------------------------------------------
;
; Here is the source which creates the gfx in the fastmode of the C128
;
;
; done by Bodo^Rabenauge
;  
; email bodo.hinueber@rabenauge.com 
;
;----------------------------------------------------------------------


!macro lineHead {
	nop	
	nop 
	nop	
	nop
	bit $ea
}

!macro lineTail {
	!for i,1,15 {
		nop   ; wait 30 cycles
	}
}

+lineHead
!byte $e2,$FF,$c9,$FF,$4b,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF
+lineTail
+lineHead
!byte $e2,$FF,$c9,$FF,$4b,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FD,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF
+lineTail
+lineHead
!byte $e2,$FF,$c9,$FF,$4b,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$F9,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF
+lineTail
+lineHead
!byte $e2,$FF,$c9,$FF,$4b,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$F3,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF
+lineTail
+lineHead
!byte $e2,$FF,$c9,$FF,$4b,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$F3,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF
+lineTail
+lineHead
!byte $e2,$FF,$c9,$FF,$4b,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$E3,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF
+lineTail
+lineHead
!byte $e2,$FF,$c9,$FF,$4b,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$C7,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF
+lineTail
+lineHead
!byte $e2,$FF,$c9,$FF,$4b,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$87,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF
+lineTail
+lineHead
!byte $e2,$FF,$c9,$FF,$4b,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$87,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF
+lineTail
+lineHead
!byte $e2,$FF,$c9,$FF,$4b,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$27,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF
+lineTail
+lineHead
!byte $e2,$FF,$c9,$FF,$4b,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FE,$e0,$4F,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF
+lineTail
+lineHead
!byte $e2,$FF,$c9,$FF,$4b,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FC,$e0,$CF,$e0,$FF,$e0,$FF,$e0,$DF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF
+lineTail
+lineHead
!byte $e2,$FF,$c9,$FF,$4b,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$F8,$e0,$CF,$e0,$FF,$e0,$FF,$e0,$3F,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF
+lineTail
+lineHead
!byte $e2,$FF,$c9,$FF,$4b,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$F7,$e0,$F9,$e0,$8F,$e0,$FF,$e0,$FE,$e0,$3F,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF
+lineTail
+lineHead
!byte $e2,$FF,$c9,$FF,$4b,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$C7,$e0,$F3,$e0,$9F,$e0,$FF,$e0,$FC,$e0,$7F,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF
+lineTail
+lineHead
!byte $e2,$FF,$c9,$FF,$4b,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$8F,$e0,$E7,$e0,$9F,$e0,$FF,$e0,$F0,$e0,$7F,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF
+lineTail
+lineHead
!byte $e2,$FF,$c9,$FF,$4b,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$0F,$e0,$CF,$e0,$9F,$e0,$FF,$e0,$E0,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF
+lineTail
+lineHead
!byte $e2,$FF,$c9,$FF,$4b,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FC,$e0,$0F,$e0,$8F,$e0,$1F,$e0,$FF,$e0,$8C,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF
+lineTail
+lineHead
!byte $e2,$FF,$c9,$FF,$4b,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$F0,$e0,$9F,$e0,$9F,$e0,$3F,$e0,$FF,$e0,$19,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF
+lineTail
+lineHead
!byte $e2,$FF,$c9,$FF,$4b,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$E3,$e0,$9F,$e0,$3F,$e0,$3F,$e0,$FC,$e0,$39,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF
+lineTail
+lineHead
!byte $e2,$FF,$c9,$FF,$4b,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$87,$e0,$1E,$e0,$7F,$e0,$3F,$e0,$F8,$e0,$F3,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF
+lineTail
+lineHead
!byte $e2,$FF,$c9,$FF,$4b,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$1F,$e0,$1C,$e0,$FE,$e0,$3F,$e0,$E1,$e0,$F3,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF
+lineTail
+lineHead
!byte $e2,$FF,$c9,$FF,$4b,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FC,$e0,$3F,$e0,$39,$e0,$FE,$e0,$7F,$e0,$C7,$e0,$E3,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF
+lineTail
+lineHead
!byte $e2,$FF,$c9,$FF,$4b,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$F8,$e0,$FF,$e0,$39,$e0,$FE,$e0,$7F,$e0,$0F,$e0,$E7,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF
+lineTail
+lineHead
!byte $e2,$FF,$c9,$FF,$4b,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$E3,$e0,$FE,$e0,$73,$e0,$FE,$e0,$7E,$e0,$3F,$e0,$E7,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF
+lineTail
+lineHead
!byte $e2,$FF,$c9,$FF,$4b,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$87,$e0,$FE,$e0,$67,$e0,$FC,$e0,$78,$e0,$7F,$e0,$CF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF
+lineTail
+lineHead
!byte $e2,$FF,$c9,$FF,$4b,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$1F,$e0,$FE,$e0,$4F,$e0,$FC,$e0,$F1,$e0,$FF,$e0,$CF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF
+lineTail
+lineHead
!byte $e2,$FF,$c9,$FF,$4b,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FC,$e0,$3F,$e0,$FC,$e0,$DF,$e0,$FC,$e0,$C3,$e0,$FF,$e0,$9F,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF
+lineTail
+lineHead
!byte $e2,$FF,$c9,$FF,$4b,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$F8,$e0,$FF,$e0,$FC,$e0,$9F,$e0,$FC,$e0,$8F,$e0,$FF,$e0,$9F,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF
+lineTail
+lineHead
!byte $e2,$FF,$c9,$FF,$4b,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$E1,$e0,$FF,$e0,$FC,$e0,$3F,$e0,$FC,$e0,$1F,$e0,$FF,$e0,$1F,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF
+lineTail
+lineHead
!byte $e2,$FF,$c9,$FF,$4b,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$C7,$e0,$FF,$e0,$FC,$e0,$7F,$e0,$F8,$e0,$7F,$e0,$FF,$e0,$3F,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF
+lineTail
+lineHead
!byte $e2,$FF,$c9,$FF,$4b,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$1F,$e0,$FF,$e0,$F8,$e0,$FF,$e0,$F8,$e0,$FF,$e0,$FF,$e0,$3F,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF
+lineTail
+lineHead
!byte $e2,$FF,$c9,$FF,$4b,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FC,$e0,$3F,$e0,$FF,$e0,$F9,$e0,$FF,$e0,$F3,$e0,$FF,$e0,$FE,$e0,$7F,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF
+lineTail
+lineHead
!byte $e2,$FF,$c9,$FF,$4b,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$F8,$e0,$FF,$e0,$FF,$e0,$F9,$e0,$FF,$e0,$F7,$e0,$FF,$e0,$FE,$e0,$7F,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF
+lineTail
+lineHead
!byte $e2,$FF,$c9,$FF,$4b,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$E3,$e0,$FF,$e0,$FF,$e0,$FB,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FC,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF
+lineTail
+lineHead
!byte $e2,$FF,$c9,$FF,$4b,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$C7,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FC,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF
+lineTail
+lineHead
!byte $e2,$FF,$c9,$FF,$4b,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$1F,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$F9,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF
+lineTail
+lineHead
!byte $e2,$FF,$c9,$FF,$4b,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FE,$e0,$3F,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$F9,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF
+lineTail
+lineHead
!byte $e2,$FF,$c9,$FF,$4b,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FC,$e0,$7F,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FC,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF
+lineTail
+lineHead
!byte $e2,$FF,$c9,$FF,$4b,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$F8,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FE,$e0,$7F,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF
+lineTail
+lineHead
!byte $e2,$FF,$c9,$FF,$4b,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$F3,$e0,$FF,$e0,$FF,$e0,$C0,$e0,$0F,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$3F,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF
+lineTail
+lineHead
!byte $e2,$FF,$c9,$FF,$4b,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$E7,$e0,$FF,$e0,$FE,$e0,$1F,$e0,$E1,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$9F,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF
+lineTail
+lineHead
!byte $e2,$FF,$c9,$FF,$4b,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$CF,$e0,$FF,$e0,$F8,$e0,$F0,$e0,$3C,$e0,$7F,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$9F,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF
+lineTail
+lineHead
!byte $e2,$FF,$c9,$FF,$4b,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$9F,$e0,$FF,$e0,$F3,$e0,$80,$e0,$07,$e0,$3F,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$CF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF
+lineTail
+lineHead
!byte $e2,$FF,$c9,$FF,$4b,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$1F,$e0,$FF,$e0,$EE,$e0,$00,$e0,$01,$e0,$DF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$EF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF
+lineTail
+lineHead
!byte $e2,$FF,$c9,$FF,$4b,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FE,$e0,$3F,$e0,$FF,$e0,$D8,$e0,$00,$e0,$00,$e0,$6F,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$E7,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF
+lineTail
+lineHead
!byte $e2,$FF,$c9,$FF,$4b,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FE,$e0,$7F,$e0,$FF,$e0,$B0,$e0,$00,$e0,$00,$e0,$37,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$F3,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF
+lineTail
+lineHead
!byte $e2,$FF,$c9,$FF,$4b,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FC,$e0,$FF,$e0,$FF,$e0,$60,$e0,$00,$e0,$00,$e0,$1B,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$F3,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF
+lineTail
+lineHead
!byte $e2,$FF,$c9,$FF,$4b,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$F8,$e0,$FF,$e0,$FE,$e0,$C0,$e0,$00,$e0,$00,$e0,$0D,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$F9,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF
+lineTail
+lineHead
!byte $e2,$FF,$c9,$FF,$4b,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$F9,$e0,$FF,$e0,$FC,$e0,$80,$e0,$00,$e0,$00,$e0,$04,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$F9,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF
+lineTail
+lineHead
!byte $e2,$FF,$c9,$FF,$4b,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$F3,$e0,$FF,$e0,$FD,$e0,$80,$e0,$00,$e0,$00,$e0,$06,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FC,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF
+lineTail
+lineHead
!byte $e2,$FF,$c9,$FF,$4b,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$F3,$e0,$FF,$e0,$F9,$e0,$00,$e0,$00,$e0,$00,$e0,$02,$e0,$7F,$e0,$FF,$e0,$FF,$e0,$FC,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF
+lineTail
+lineHead
!byte $e2,$FF,$c9,$FF,$4b,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$E7,$e0,$FF,$e0,$FB,$e0,$00,$e0,$00,$e0,$00,$e0,$03,$e0,$7F,$e0,$FF,$e0,$FF,$e0,$FE,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$E0,$e0,$00,$e0,$7F,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF
+lineTail
+lineHead
!byte $e2,$FF,$c9,$FF,$4b,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$E7,$e0,$FF,$e0,$F2,$e0,$00,$e0,$3F,$e0,$00,$e0,$01,$e0,$7F,$e0,$FF,$e0,$FF,$e0,$FE,$e0,$7F,$e0,$FF,$e0,$FF,$e0,$80,$e0,$00,$e0,$7F,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF
+lineTail
+lineHead
!byte $e2,$FF,$c9,$FF,$4b,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$E7,$e0,$FF,$e0,$F2,$e0,$00,$e0,$FF,$e0,$C0,$e0,$01,$e0,$3F,$e0,$FF,$e0,$FF,$e0,$FE,$e0,$7F,$e0,$FF,$e0,$FE,$e0,$1F,$e0,$FE,$e0,$7F,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF
+lineTail
+lineHead
!byte $e2,$FF,$c9,$FF,$4b,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$CF,$e0,$FF,$e0,$F6,$e0,$03,$e0,$FF,$e0,$E0,$e0,$01,$e0,$BF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$7F,$e0,$FF,$e0,$FC,$e0,$7F,$e0,$FE,$e0,$7F,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF
+lineTail
+lineHead
!byte $e2,$FF,$c9,$FF,$4b,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$CF,$e0,$FF,$e0,$F4,$e0,$07,$e0,$FF,$e0,$F0,$e0,$00,$e0,$BF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$3F,$e0,$FF,$e0,$FC,$e0,$FF,$e0,$FE,$e0,$7F,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF
+lineTail
+lineHead
!byte $e2,$FF,$c9,$FF,$4b,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$CF,$e0,$FF,$e0,$F4,$e0,$07,$e0,$FF,$e0,$F8,$e0,$00,$e0,$BF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$3F,$e0,$FF,$e0,$F9,$e0,$FF,$e0,$FE,$e0,$7F,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF
+lineTail
+lineHead
!byte $e2,$FF,$c9,$FF,$4b,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$9F,$e0,$FF,$e0,$F4,$e0,$0F,$e0,$FF,$e0,$F8,$e0,$00,$e0,$BF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$3F,$e0,$FF,$e0,$F3,$e0,$FF,$e0,$FE,$e0,$7F,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF
+lineTail
+lineHead
!byte $e2,$FF,$c9,$FF,$4b,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$9F,$e0,$FF,$e0,$F4,$e0,$08,$e0,$FF,$e0,$FC,$e0,$00,$e0,$BF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$3F,$e0,$FF,$e0,$F3,$e0,$FF,$e0,$FE,$e0,$7F,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF
+lineTail
+lineHead
!byte $e2,$FF,$c9,$FF,$4b,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$9F,$e0,$FF,$e0,$F4,$e0,$18,$e0,$FF,$e0,$FC,$e0,$00,$e0,$BF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$BF,$e0,$FF,$e0,$E7,$e0,$FF,$e0,$FC,$e0,$7F,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF
+lineTail
+lineHead
!byte $e2,$FF,$c9,$FF,$4b,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$9F,$e0,$FF,$e0,$F4,$e0,$18,$e0,$FF,$e0,$FC,$e0,$00,$e0,$BF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$BF,$e0,$FF,$e0,$E7,$e0,$FF,$e0,$F8,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF
+lineTail
+lineHead
!byte $e2,$FF,$c9,$FF,$4b,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$9F,$e0,$FF,$e0,$F4,$e0,$1F,$e0,$FF,$e0,$FC,$e0,$01,$e0,$BF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$9F,$e0,$FF,$e0,$CF,$e0,$FF,$e0,$F0,$e0,$00,$e0,$1F,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF
+lineTail
+lineHead
!byte $e2,$FF,$c9,$FF,$4b,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$9F,$e0,$FF,$e0,$F6,$e0,$1F,$e0,$FF,$e0,$8C,$e0,$01,$e0,$3F,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$9F,$e0,$FF,$e0,$CF,$e0,$FF,$e0,$E0,$e0,$00,$e0,$1F,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF
+lineTail
+lineHead
!byte $e2,$FF,$c9,$FF,$4b,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$9F,$e0,$FF,$e0,$F2,$e0,$0F,$e0,$FE,$e0,$04,$e0,$01,$e0,$7F,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$9F,$e0,$FF,$e0,$CF,$e0,$FF,$e0,$87,$e0,$FF,$e0,$9F,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF
+lineTail
+lineHead
!byte $e2,$FF,$c9,$FF,$4b,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$9F,$e0,$FF,$e0,$FA,$e0,$0F,$e0,$FC,$e0,$00,$e0,$01,$e0,$7F,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$9F,$e0,$FF,$e0,$9F,$e0,$FF,$e0,$1F,$e0,$FF,$e0,$9F,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF
+lineTail
+lineHead
!byte $e2,$FF,$c9,$FF,$4b,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$9F,$e0,$FF,$e0,$F9,$e0,$0F,$e0,$F8,$e0,$00,$e0,$02,$e0,$7F,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$9F,$e0,$FF,$e0,$9F,$e0,$FE,$e0,$3F,$e0,$FF,$e0,$9F,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF
+lineTail
+lineHead
!byte $e2,$FF,$c9,$FF,$4b,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$9F,$e0,$FF,$e0,$FD,$e0,$07,$e0,$F8,$e0,$00,$e0,$02,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$9F,$e0,$FF,$e0,$3F,$e0,$FC,$e0,$7F,$e0,$FF,$e0,$9F,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF
+lineTail
+lineHead
!byte $e2,$FF,$c9,$FF,$4b,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$9F,$e0,$FF,$e0,$FC,$e0,$87,$e0,$F8,$e0,$00,$e0,$04,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$9F,$e0,$FF,$e0,$3F,$e0,$FC,$e0,$FF,$e0,$FF,$e0,$BF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF
+lineTail
+lineHead
!byte $e2,$FF,$c9,$FF,$4b,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$9F,$e0,$FF,$e0,$FE,$e0,$C3,$e0,$F8,$e0,$00,$e0,$0D,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$9F,$e0,$FE,$e0,$7F,$e0,$F9,$e0,$FF,$e0,$FF,$e0,$3F,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF
+lineTail
+lineHead
!byte $e2,$FF,$c9,$FF,$4b,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$9F,$e0,$FF,$e0,$FF,$e0,$40,$e0,$FC,$e0,$00,$e0,$1B,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$BF,$e0,$FE,$e0,$7F,$e0,$F3,$e0,$FF,$e0,$FF,$e0,$3F,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF
+lineTail
+lineHead
!byte $e2,$FF,$c9,$FF,$4b,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$9F,$e0,$FF,$e0,$FF,$e0,$20,$e0,$7E,$e0,$00,$e0,$33,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$BF,$e0,$FC,$e0,$FF,$e0,$F3,$e0,$FF,$e0,$FF,$e0,$3F,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF
+lineTail
+lineHead
!byte $e2,$FF,$c9,$FF,$4b,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$9F,$e0,$FF,$e0,$FF,$e0,$98,$e0,$00,$e0,$00,$e0,$67,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$3F,$e0,$F9,$e0,$FF,$e0,$E7,$e0,$FF,$e0,$FE,$e0,$7F,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF
+lineTail
+lineHead
!byte $e2,$FF,$c9,$FF,$4b,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$CF,$e0,$FF,$e0,$FF,$e0,$CC,$e0,$00,$e0,$00,$e0,$CF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$3F,$e0,$F9,$e0,$FF,$e0,$E7,$e0,$FF,$e0,$FE,$e0,$00,$e0,$0F,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF
+lineTail
+lineHead
!byte $e2,$FF,$c9,$FF,$4b,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$CF,$e0,$FF,$e0,$FF,$e0,$F7,$e0,$00,$e0,$03,$e0,$3F,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$3F,$e0,$F3,$e0,$FF,$e0,$CF,$e0,$FF,$e0,$F8,$e0,$00,$e0,$0F,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF
+lineTail
+lineHead
!byte $e2,$FF,$c9,$FF,$4b,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$CF,$e0,$FF,$e0,$FF,$e0,$F9,$e0,$E0,$e0,$1E,$e0,$7F,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$3F,$e0,$E7,$e0,$FF,$e0,$9F,$e0,$FF,$e0,$E1,$e0,$FF,$e0,$CF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF
+lineTail
+lineHead
!byte $e2,$FF,$c9,$FF,$4b,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$C7,$e0,$FF,$e0,$FF,$e0,$FE,$e0,$3F,$e0,$F1,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$3F,$e0,$C7,$e0,$FF,$e0,$9F,$e0,$FF,$e0,$C7,$e0,$FF,$e0,$CF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF
+lineTail
+lineHead
!byte $e2,$FF,$c9,$FF,$4b,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$E7,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$80,$e0,$07,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$BF,$e0,$7F,$e0,$8F,$e0,$FF,$e0,$3F,$e0,$FF,$e0,$CF,$e0,$FF,$e0,$DF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF
+lineTail
+lineHead
!byte $e2,$FF,$c9,$FF,$4b,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$E7,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$F8,$e0,$7F,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$DE,$e0,$7E,$e0,$1F,$e0,$FF,$e0,$7F,$e0,$FF,$e0,$9F,$e0,$FF,$e0,$9F,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF
+lineTail
+lineHead
!byte $e2,$FF,$c9,$FF,$4b,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$E3,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$C0,$e0,$00,$e0,$7F,$e0,$FE,$e0,$7F,$e0,$FF,$e0,$3F,$e0,$FF,$e0,$9F,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF
+lineTail
+lineHead
!byte $e2,$FF,$c9,$FF,$4b,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$F0,$e0,$1F,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$F0,$e0,$01,$e0,$FF,$e0,$FC,$e0,$FF,$e0,$FE,$e0,$3F,$e0,$FF,$e0,$9F,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF
+lineTail
+lineHead
!byte $e2,$FF,$c9,$FF,$4b,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$F0,$e0,$00,$e0,$7F,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$F9,$e0,$FF,$e0,$FE,$e0,$7F,$e0,$FF,$e0,$9F,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF
+lineTail
+lineHead
!byte $e2,$FF,$c9,$FF,$4b,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$E7,$e0,$C0,$e0,$0F,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$F3,$e0,$FF,$e0,$FC,$e0,$FF,$e0,$FF,$e0,$9F,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF
+lineTail
+lineHead
!byte $e2,$FF,$c9,$FF,$4b,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$CF,$e0,$FE,$e0,$01,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$E7,$e0,$FF,$e0,$FC,$e0,$FF,$e0,$FF,$e0,$3F,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF
+lineTail
+lineHead
!byte $e2,$FF,$c9,$FF,$4b,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$CF,$e0,$FF,$e0,$E0,$e0,$7F,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$CF,$e0,$FF,$e0,$F9,$e0,$FF,$e0,$FF,$e0,$3F,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF
+lineTail
+lineHead
!byte $e2,$FF,$c9,$FF,$4b,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$9F,$e0,$FF,$e0,$FC,$e0,$1F,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$3F,$e0,$FF,$e0,$F1,$e0,$FF,$e0,$FF,$e0,$3F,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF
+lineTail
+lineHead
!byte $e2,$FF,$c9,$FF,$4b,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$9F,$e0,$FF,$e0,$FF,$e0,$07,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FE,$e0,$7F,$e0,$FF,$e0,$F3,$e0,$FF,$e0,$FF,$e0,$3F,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF
+lineTail
+lineHead
!byte $e2,$FF,$c9,$FF,$4b,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$3F,$e0,$FF,$e0,$FF,$e0,$E1,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$F8,$e0,$FF,$e0,$FF,$e0,$E7,$e0,$FF,$e0,$FE,$e0,$7F,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF
+lineTail
+lineHead
!byte $e2,$FF,$c9,$FF,$4b,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FE,$e0,$3F,$e0,$FF,$e0,$FF,$e0,$F8,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$E3,$e0,$FF,$e0,$FF,$e0,$C7,$e0,$FF,$e0,$FE,$e0,$7F,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF
+lineTail
+lineHead
!byte $e2,$FF,$c9,$FF,$4b,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FE,$e0,$7E,$e0,$7F,$e0,$FF,$e0,$F8,$e0,$7F,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$8F,$e0,$FF,$e0,$FF,$e0,$CF,$e0,$FF,$e0,$FE,$e0,$7F,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF
+lineTail
+lineHead
!byte $e2,$FF,$c9,$FF,$4b,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FC,$e0,$78,$e0,$1F,$e0,$FF,$e0,$F8,$e0,$3F,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$9F,$e0,$FF,$e0,$FE,$e0,$7F,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF
+lineTail
+lineHead
!byte $e2,$FF,$c9,$FF,$4b,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FC,$e0,$F1,$e0,$FF,$e0,$FF,$e0,$F3,$e0,$1F,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$3F,$e0,$FF,$e0,$FC,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF
+lineTail
+lineHead
!byte $e2,$FF,$c9,$FF,$4b,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FC,$e0,$E3,$e0,$FF,$e0,$FF,$e0,$E3,$e0,$9F,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FE,$e0,$7F,$e0,$FF,$e0,$FC,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF
+lineTail
+lineHead
!byte $e2,$FF,$c9,$FF,$4b,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$F9,$e0,$E7,$e0,$FF,$e0,$FF,$e0,$C7,$e0,$CF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FC,$e0,$FF,$e0,$FF,$e0,$FC,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF
+lineTail
+lineHead
!byte $e2,$FF,$c9,$FF,$4b,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$F9,$e0,$E7,$e0,$FF,$e0,$FF,$e0,$87,$e0,$C7,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$F9,$e0,$FF,$e0,$FF,$e0,$F9,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF
+lineTail
+lineHead
!byte $e2,$FF,$c9,$FF,$4b,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$F3,$e0,$E7,$e0,$FF,$e0,$FF,$e0,$2F,$e0,$E7,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$F7,$e0,$FF,$e0,$FF,$e0,$F9,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF
+lineTail
+lineHead
!byte $e2,$FF,$c9,$FF,$4b,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$F3,$e0,$F3,$e0,$FF,$e0,$FE,$e0,$4F,$e0,$F3,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FE,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$CF,$e0,$FF,$e0,$FF,$e0,$F3,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF
+lineTail
+lineHead
!byte $e2,$FF,$c9,$FF,$4b,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$F3,$e0,$FB,$e0,$FF,$e0,$FC,$e0,$DF,$e0,$F3,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$7F,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$3F,$e0,$FF,$e0,$FF,$e0,$F3,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF
+lineTail
+lineHead
!byte $e2,$FF,$c9,$FF,$4b,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$E7,$e0,$FD,$e0,$FF,$e0,$F9,$e0,$9F,$e0,$FB,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$BF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FC,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$E7,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF
+lineTail
+lineHead
!byte $e2,$FF,$c9,$FF,$4b,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$E7,$e0,$FF,$e0,$FF,$e0,$F3,$e0,$BF,$e0,$F9,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$9F,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$F3,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$E7,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF
+lineTail
+lineHead
!byte $e2,$FF,$c9,$FF,$4b,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$E7,$e0,$FF,$e0,$FF,$e0,$E7,$e0,$BF,$e0,$F9,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$CF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$CF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF
+lineTail
+lineHead
!byte $e2,$FF,$c9,$FF,$4b,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$CF,$e0,$FF,$e0,$FF,$e0,$CF,$e0,$3F,$e0,$F9,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$C3,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$CF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF
+lineTail
+lineHead
!byte $e2,$FF,$c9,$FF,$4b,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$CF,$e0,$FF,$e0,$FF,$e0,$9F,$e0,$7F,$e0,$FC,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$91,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$9F,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF
+lineTail
+lineHead
!byte $e2,$FF,$c9,$FF,$4b,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$CF,$e0,$FF,$e0,$FF,$e0,$3E,$e0,$7F,$e0,$FC,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$3C,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$3F,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF
+lineTail
+lineHead
!byte $e2,$FF,$c9,$FF,$4b,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$9F,$e0,$FF,$e0,$FE,$e0,$7E,$e0,$FF,$e0,$FC,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FC,$e0,$7E,$e0,$7F,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FE,$e0,$3F,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF
+lineTail
+lineHead
!byte $e2,$FF,$c9,$FF,$4b,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$9F,$e0,$FF,$e0,$FC,$e0,$FC,$e0,$FF,$e0,$FC,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$F8,$e0,$FF,$e0,$3F,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FC,$e0,$7F,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF
+lineTail
+lineHead
!byte $e2,$FF,$c9,$FF,$4b,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$9F,$e0,$FF,$e0,$F9,$e0,$F9,$e0,$FF,$e0,$FE,$e0,$7F,$e0,$FF,$e0,$FF,$e0,$F3,$e0,$FF,$e0,$8F,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$F8,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF
+lineTail
+lineHead
!byte $e2,$FF,$c9,$FF,$4b,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$3F,$e0,$FF,$e0,$F3,$e0,$F9,$e0,$FF,$e0,$FE,$e0,$7F,$e0,$FF,$e0,$FF,$e0,$C7,$e0,$FF,$e0,$C7,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$E3,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF
+lineTail
+lineHead
!byte $e2,$FF,$c9,$FF,$4b,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$3F,$e0,$FF,$e0,$E7,$e0,$F3,$e0,$FF,$e0,$FC,$e0,$7F,$e0,$FF,$e0,$FF,$e0,$8F,$e0,$FF,$e0,$F1,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$C7,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF
+lineTail
+lineHead
!byte $e2,$FF,$c9,$FF,$4b,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FE,$e0,$3F,$e0,$FF,$e0,$CF,$e0,$E7,$e0,$FF,$e0,$F8,$e0,$FF,$e0,$FF,$e0,$FE,$e0,$3F,$e0,$FF,$e0,$F8,$e0,$7F,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$0F,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF
+lineTail
+lineHead
!byte $e2,$FF,$c9,$FF,$4b,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FE,$e0,$7F,$e0,$FF,$e0,$9F,$e0,$CF,$e0,$FF,$e0,$F3,$e0,$FF,$e0,$FF,$e0,$F8,$e0,$7F,$e0,$FF,$e0,$FE,$e0,$1F,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FC,$e0,$3F,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF
+lineTail
+lineHead
!byte $e2,$FF,$c9,$FF,$4b,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FE,$e0,$7F,$e0,$FF,$e0,$3F,$e0,$9F,$e0,$FF,$e0,$C7,$e0,$FF,$e0,$FF,$e0,$E1,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$87,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$F0,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF
+lineTail
+lineHead
!byte $e2,$FF,$c9,$FF,$4b,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FC,$e0,$FF,$e0,$FE,$e0,$7F,$e0,$3F,$e0,$FF,$e0,$80,$e0,$7F,$e0,$FE,$e0,$07,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$E0,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$C3,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF
+lineTail
+lineHead
!byte $e2,$FF,$c9,$FF,$4b,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FC,$e0,$FF,$e0,$FC,$e0,$FE,$e0,$7F,$e0,$FF,$e0,$3C,$e0,$01,$e0,$E0,$e0,$3F,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FC,$e0,$07,$e0,$FF,$e0,$FE,$e0,$0F,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF
+lineTail
+lineHead
!byte $e2,$FF,$c9,$FF,$4b,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$F8,$e0,$FF,$e0,$F9,$e0,$FC,$e0,$FF,$e0,$FC,$e0,$7F,$e0,$E0,$e0,$03,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$80,$e0,$3F,$e0,$C0,$e0,$3F,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF
+lineTail
+lineHead
!byte $e2,$FF,$c9,$FF,$4b,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$F9,$e0,$FF,$e0,$F3,$e0,$F9,$e0,$FF,$e0,$F8,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$F8,$e0,$00,$e0,$01,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF
+lineTail
+lineHead
!byte $e2,$FF,$c9,$FF,$4b,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$F9,$e0,$FF,$e0,$E7,$e0,$F3,$e0,$FF,$e0,$E3,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$F0,$e0,$7F,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF
+lineTail
+lineHead
!byte $e2,$FF,$c9,$FF,$4b,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$F3,$e0,$FF,$e0,$CF,$e0,$E7,$e0,$FF,$e0,$C7,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF
+lineTail
+lineHead
!byte $e2,$FF,$c9,$FF,$4b,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$F3,$e0,$FF,$e0,$9F,$e0,$CF,$e0,$FF,$e0,$8F,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF
+lineTail
+lineHead
!byte $e2,$FF,$c9,$FF,$4b,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$F3,$e0,$FF,$e0,$3F,$e0,$9F,$e0,$FE,$e0,$3F,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF
+lineTail
+lineHead
!byte $e2,$FF,$c9,$FF,$4b,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$E7,$e0,$FE,$e0,$7F,$e0,$3F,$e0,$FC,$e0,$7F,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF
+lineTail
+lineHead
!byte $e2,$FF,$c9,$FF,$4b,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$E7,$e0,$FC,$e0,$FE,$e0,$7F,$e0,$F9,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF
+lineTail
+lineHead
!byte $e2,$FF,$c9,$FF,$4b,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$CF,$e0,$F9,$e0,$FC,$e0,$FF,$e0,$E3,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF
+lineTail
+lineHead
!byte $e2,$FF,$c9,$FF,$4b,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$CF,$e0,$F3,$e0,$F9,$e0,$FF,$e0,$C7,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF
+lineTail
+lineHead
!byte $e2,$FF,$c9,$FF,$4b,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$8F,$e0,$E7,$e0,$F3,$e0,$FF,$e0,$1F,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF
+lineTail
+lineHead
!byte $e2,$FF,$c9,$FF,$4b,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$9F,$e0,$CF,$e0,$E7,$e0,$FE,$e0,$3F,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF
+lineTail
+lineHead
!byte $e2,$FF,$c9,$FF,$4b,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$9F,$e0,$9F,$e0,$CF,$e0,$FC,$e0,$7F,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF
+lineTail
+lineHead
!byte $e2,$FF,$c9,$FF,$4b,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$3F,$e0,$3F,$e0,$9F,$e0,$F1,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF
+lineTail
+lineHead
!byte $e2,$FF,$c9,$FF,$4b,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$3E,$e0,$7F,$e0,$3F,$e0,$E3,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF
+lineTail
+lineHead
!byte $e2,$FF,$c9,$FF,$4b,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FE,$e0,$7C,$e0,$FE,$e0,$7F,$e0,$C7,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF
+lineTail
+lineHead
!byte $e2,$FF,$c9,$FF,$4b,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FE,$e0,$79,$e0,$FC,$e0,$FF,$e0,$1F,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF
+lineTail
+lineHead
!byte $e2,$FF,$c9,$FF,$4b,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FE,$e0,$73,$e0,$F9,$e0,$FE,$e0,$3F,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF
+lineTail
+lineHead
!byte $e2,$FF,$c9,$FF,$4b,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FC,$e0,$E7,$e0,$F3,$e0,$F8,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF
+lineTail
+lineHead
!byte $e2,$FF,$c9,$FF,$4b,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FD,$e0,$CF,$e0,$E7,$e0,$E1,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF
+lineTail
+lineHead
!byte $e2,$FF,$c9,$FF,$4b,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$F9,$e0,$9F,$e0,$CF,$e0,$C7,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF
+lineTail
+lineHead
!byte $e2,$FF,$c9,$FF,$4b,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$F9,$e0,$3F,$e0,$9E,$e0,$0F,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF
+lineTail
+lineHead
!byte $e2,$FF,$c9,$FF,$4b,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FA,$e0,$7F,$e0,$38,$e0,$3F,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF
+lineTail
+lineHead
!byte $e2,$FF,$c9,$FF,$4b,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$F0,$e0,$FE,$e0,$61,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF
+lineTail
+lineHead
!byte $e2,$FF,$c9,$FF,$4b,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$F1,$e0,$FC,$e0,$C7,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF
+lineTail
+lineHead
!byte $e2,$FF,$c9,$FF,$4b,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$F3,$e0,$F8,$e0,$1F,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF
+lineTail
+lineHead
!byte $e2,$FF,$c9,$FF,$4b,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$F7,$e0,$F0,$e0,$7F,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF
+lineTail
+lineHead
!byte $e2,$FF,$c9,$FF,$4b,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$E3,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF
+lineTail
+lineHead
!byte $e2,$FF,$c9,$FF,$4b,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$CF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF
+lineTail
+lineHead
!byte $e2,$FF,$c9,$FF,$4b,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF
+lineTail
+lineHead
!byte $e2,$FF,$c9,$FF,$4b,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF
+lineTail
+lineHead
!byte $e2,$FF,$c9,$FF,$4b,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF
+lineTail
+lineHead
!byte $e2,$FF,$c9,$FF,$4b,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF
+lineTail
+lineHead
!byte $e2,$FF,$c9,$FF,$4b,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF
+lineTail
+lineHead
!byte $e2,$FF,$c9,$FF,$4b,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF
+lineTail
+lineHead
!byte $e2,$FF,$c9,$FF,$4b,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF
+lineTail
+lineHead
!byte $e2,$FF,$c9,$FF,$4b,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF
+lineTail
+lineHead
!byte $e2,$FF,$c9,$FF,$4b,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF
+lineTail
+lineHead
!byte $e2,$FF,$c9,$FF,$4b,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF
+lineTail
+lineHead
!byte $e2,$FF,$c9,$FF,$4b,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF
+lineTail
+lineHead
!byte $e2,$FF,$c9,$FF,$4b,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$F8,$e0,$03,$e0,$FF,$e0,$E0,$e0,$7F,$e0,$C0,$e0,$0F,$e0,$F8,$e0,$00,$e0,$78,$e0,$7E,$e0,$1F,$e0,$F0,$e0,$3F,$e0,$E1,$e0,$F8,$e0,$7F,$e0,$E0,$e0,$3F,$e0,$80,$e0,$07,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF
+lineTail
+lineHead
!byte $e2,$FF,$c9,$FF,$4b,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$F8,$e0,$00,$e0,$FF,$e0,$E0,$e0,$7F,$e0,$C0,$e0,$03,$e0,$F8,$e0,$00,$e0,$78,$e0,$3E,$e0,$1F,$e0,$F0,$e0,$3F,$e0,$E1,$e0,$F8,$e0,$7F,$e0,$80,$e0,$0F,$e0,$80,$e0,$07,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF
+lineTail
+lineHead
!byte $e2,$FF,$c9,$FF,$4b,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$F8,$e0,$00,$e0,$7F,$e0,$E0,$e0,$7F,$e0,$C0,$e0,$01,$e0,$F8,$e0,$00,$e0,$78,$e0,$3E,$e0,$1F,$e0,$F0,$e0,$3F,$e0,$E1,$e0,$F8,$e0,$7F,$e0,$00,$e0,$0F,$e0,$80,$e0,$07,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF
+lineTail
+lineHead
!byte $e2,$FF,$c9,$FF,$4b,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$F8,$e0,$00,$e0,$7F,$e0,$E0,$e0,$7F,$e0,$C0,$e0,$01,$e0,$F8,$e0,$00,$e0,$78,$e0,$3E,$e0,$1F,$e0,$F0,$e0,$3F,$e0,$E1,$e0,$F8,$e0,$7E,$e0,$00,$e0,$0F,$e0,$80,$e0,$07,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF
+lineTail
+lineHead
!byte $e2,$FF,$c9,$FF,$4b,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$F8,$e0,$78,$e0,$3F,$e0,$E0,$e0,$3F,$e0,$C3,$e0,$E0,$e0,$F8,$e0,$00,$e0,$78,$e0,$1E,$e0,$1F,$e0,$F0,$e0,$1F,$e0,$E1,$e0,$F8,$e0,$7E,$e0,$00,$e0,$0F,$e0,$80,$e0,$07,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF
+lineTail
+lineHead
!byte $e2,$FF,$c9,$FF,$4b,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$F8,$e0,$7C,$e0,$3F,$e0,$C0,$e0,$3F,$e0,$C3,$e0,$F0,$e0,$F8,$e0,$7F,$e0,$F8,$e0,$1E,$e0,$1F,$e0,$E0,$e0,$1F,$e0,$E1,$e0,$F8,$e0,$7E,$e0,$0F,$e0,$CF,$e0,$87,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF
+lineTail
+lineHead
!byte $e2,$FF,$c9,$FF,$4b,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$F8,$e0,$7C,$e0,$3F,$e0,$C0,$e0,$3F,$e0,$C3,$e0,$F0,$e0,$F8,$e0,$7F,$e0,$F8,$e0,$0E,$e0,$1F,$e0,$E0,$e0,$1F,$e0,$E1,$e0,$F8,$e0,$7C,$e0,$1F,$e0,$FF,$e0,$87,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF
+lineTail
+lineHead
!byte $e2,$FF,$c9,$FF,$4b,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$F8,$e0,$7C,$e0,$3F,$e0,$C0,$e0,$3F,$e0,$C3,$e0,$F0,$e0,$F8,$e0,$7F,$e0,$F8,$e0,$0E,$e0,$1F,$e0,$E0,$e0,$1F,$e0,$E1,$e0,$F8,$e0,$7C,$e0,$3F,$e0,$FF,$e0,$87,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF
+lineTail
+lineHead
!byte $e2,$FF,$c9,$FF,$4b,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$F8,$e0,$7C,$e0,$3F,$e0,$C2,$e0,$1F,$e0,$C3,$e0,$F0,$e0,$F8,$e0,$7F,$e0,$F8,$e0,$0E,$e0,$1F,$e0,$E1,$e0,$0F,$e0,$E1,$e0,$F8,$e0,$7C,$e0,$3F,$e0,$FF,$e0,$87,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF
+lineTail
+lineHead
!byte $e2,$FF,$c9,$FF,$4b,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$F8,$e0,$7C,$e0,$3F,$e0,$86,$e0,$1F,$e0,$C3,$e0,$F0,$e0,$F8,$e0,$7F,$e0,$F8,$e0,$06,$e0,$1F,$e0,$C3,$e0,$0F,$e0,$E1,$e0,$F8,$e0,$7C,$e0,$3F,$e0,$FF,$e0,$87,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF
+lineTail
+lineHead
!byte $e2,$FF,$c9,$FF,$4b,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$F8,$e0,$78,$e0,$3F,$e0,$86,$e0,$1F,$e0,$C3,$e0,$E1,$e0,$F8,$e0,$00,$e0,$78,$e0,$06,$e0,$1F,$e0,$C3,$e0,$0F,$e0,$E1,$e0,$F8,$e0,$7C,$e0,$3F,$e0,$FF,$e0,$80,$e0,$07,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF
+lineTail
+lineHead
!byte $e2,$FF,$c9,$FF,$4b,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$F8,$e0,$00,$e0,$3F,$e0,$86,$e0,$1F,$e0,$C0,$e0,$01,$e0,$F8,$e0,$00,$e0,$78,$e0,$06,$e0,$1F,$e0,$C3,$e0,$0F,$e0,$E1,$e0,$F8,$e0,$7C,$e0,$30,$e0,$0F,$e0,$80,$e0,$07,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF
+lineTail
+lineHead
!byte $e2,$FF,$c9,$FF,$4b,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$F8,$e0,$00,$e0,$7F,$e0,$86,$e0,$0F,$e0,$C0,$e0,$03,$e0,$F8,$e0,$00,$e0,$78,$e0,$42,$e0,$1F,$e0,$C3,$e0,$07,$e0,$E1,$e0,$F8,$e0,$7C,$e0,$30,$e0,$0F,$e0,$80,$e0,$07,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF
+lineTail
+lineHead
!byte $e2,$FF,$c9,$FF,$4b,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$F8,$e0,$00,$e0,$7F,$e0,$0F,$e0,$0F,$e0,$C0,$e0,$01,$e0,$F8,$e0,$00,$e0,$78,$e0,$42,$e0,$1F,$e0,$87,$e0,$87,$e0,$E1,$e0,$F8,$e0,$7C,$e0,$30,$e0,$0F,$e0,$80,$e0,$07,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF
+lineTail
+lineHead
!byte $e2,$FF,$c9,$FF,$4b,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$F8,$e0,$00,$e0,$FF,$e0,$0F,$e0,$0F,$e0,$C0,$e0,$00,$e0,$F8,$e0,$00,$e0,$78,$e0,$60,$e0,$1F,$e0,$87,$e0,$87,$e0,$E1,$e0,$F8,$e0,$7C,$e0,$30,$e0,$0F,$e0,$80,$e0,$07,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF
+lineTail
+lineHead
!byte $e2,$FF,$c9,$FF,$4b,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$F8,$e0,$03,$e0,$FF,$e0,$0F,$e0,$0F,$e0,$C3,$e0,$F0,$e0,$F8,$e0,$7F,$e0,$F8,$e0,$60,$e0,$1F,$e0,$87,$e0,$87,$e0,$E1,$e0,$F8,$e0,$7C,$e0,$30,$e0,$0F,$e0,$87,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF
+lineTail
+lineHead
!byte $e2,$FF,$c9,$FF,$4b,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$F8,$e0,$61,$e0,$FF,$e0,$0F,$e0,$07,$e0,$C3,$e0,$F8,$e0,$78,$e0,$7F,$e0,$F8,$e0,$60,$e0,$1F,$e0,$87,$e0,$83,$e0,$E1,$e0,$F8,$e0,$7C,$e0,$3F,$e0,$0F,$e0,$87,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF
+lineTail
+lineHead
!byte $e2,$FF,$c9,$FF,$4b,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$F8,$e0,$61,$e0,$FE,$e0,$00,$e0,$07,$e0,$C3,$e0,$F8,$e0,$78,$e0,$7F,$e0,$F8,$e0,$70,$e0,$1F,$e0,$00,$e0,$03,$e0,$E1,$e0,$F8,$e0,$7C,$e0,$3F,$e0,$0F,$e0,$87,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF
+lineTail
+lineHead
!byte $e2,$FF,$c9,$FF,$4b,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$F8,$e0,$60,$e0,$FE,$e0,$00,$e0,$07,$e0,$C3,$e0,$F8,$e0,$78,$e0,$7F,$e0,$F8,$e0,$70,$e0,$1F,$e0,$00,$e0,$03,$e0,$E1,$e0,$F8,$e0,$7C,$e0,$3F,$e0,$0F,$e0,$87,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF
+lineTail
+lineHead
!byte $e2,$FF,$c9,$FF,$4b,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$F8,$e0,$70,$e0,$FE,$e0,$00,$e0,$07,$e0,$C3,$e0,$F8,$e0,$78,$e0,$7F,$e0,$F8,$e0,$70,$e0,$1F,$e0,$00,$e0,$03,$e0,$E0,$e0,$F0,$e0,$7C,$e0,$1F,$e0,$0F,$e0,$87,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF
+lineTail
+lineHead
!byte $e2,$FF,$c9,$FF,$4b,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$F8,$e0,$70,$e0,$7E,$e0,$00,$e0,$03,$e0,$C3,$e0,$F8,$e0,$78,$e0,$7F,$e0,$F8,$e0,$78,$e0,$1F,$e0,$00,$e0,$01,$e0,$E0,$e0,$F0,$e0,$7C,$e0,$1F,$e0,$0F,$e0,$87,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF
+lineTail
+lineHead
!byte $e2,$FF,$c9,$FF,$4b,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$F8,$e0,$78,$e0,$7C,$e0,$00,$e0,$03,$e0,$C3,$e0,$F0,$e0,$78,$e0,$00,$e0,$78,$e0,$78,$e0,$1E,$e0,$00,$e0,$01,$e0,$F0,$e0,$00,$e0,$FE,$e0,$00,$e0,$0F,$e0,$80,$e0,$07,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF
+lineTail
+lineHead
!byte $e2,$FF,$c9,$FF,$4b,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$F8,$e0,$78,$e0,$3C,$e0,$1F,$e0,$C3,$e0,$C0,$e0,$00,$e0,$F8,$e0,$00,$e0,$78,$e0,$7C,$e0,$1E,$e0,$0F,$e0,$E1,$e0,$F0,$e0,$00,$e0,$FE,$e0,$00,$e0,$0F,$e0,$80,$e0,$07,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF
+lineTail
+lineHead
!byte $e2,$FF,$c9,$FF,$4b,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$F8,$e0,$7C,$e0,$3C,$e0,$3F,$e0,$C3,$e0,$C0,$e0,$00,$e0,$F8,$e0,$00,$e0,$78,$e0,$7C,$e0,$1E,$e0,$1F,$e0,$E1,$e0,$F8,$e0,$01,$e0,$FF,$e0,$00,$e0,$0F,$e0,$80,$e0,$07,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF
+lineTail
+lineHead
!byte $e2,$FF,$c9,$FF,$4b,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$F8,$e0,$7C,$e0,$1C,$e0,$3F,$e0,$C3,$e0,$C0,$e0,$01,$e0,$F8,$e0,$00,$e0,$78,$e0,$7C,$e0,$1E,$e0,$1F,$e0,$E1,$e0,$FC,$e0,$03,$e0,$FF,$e0,$00,$e0,$1F,$e0,$80,$e0,$07,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF
+lineTail
+lineHead
!byte $e2,$FF,$c9,$FF,$4b,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$F8,$e0,$7E,$e0,$18,$e0,$3F,$e0,$C1,$e0,$C0,$e0,$07,$e0,$F8,$e0,$00,$e0,$78,$e0,$7E,$e0,$1C,$e0,$1F,$e0,$E0,$e0,$FE,$e0,$07,$e0,$FF,$e0,$C0,$e0,$7F,$e0,$80,$e0,$07,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF
+lineTail
+lineHead
!byte $e2,$FF,$c9,$FF,$4b,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF
+lineTail
+lineHead
!byte $e2,$FF,$c9,$FF,$4b,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF
+lineTail
+lineHead
!byte $e2,$FF,$c9,$FF,$4b,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF
+lineTail
+lineHead
!byte $e2,$FF,$c9,$FF,$4b,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF
+lineTail
+lineHead
!byte $e2,$FF,$c9,$FF,$4b,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF
+lineTail
+lineHead
!byte $e2,$FF,$c9,$FF,$4b,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF
+lineTail
+lineHead
!byte $e2,$FF,$c9,$FF,$4b,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF
+lineTail
+lineHead
!byte $e2,$FF,$c9,$FF,$4b,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF
+lineTail
+lineHead
!byte $e2,$FF,$c9,$FF,$4b,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF
+lineTail
+lineHead
!byte $e2,$FF,$c9,$FF,$4b,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF
+lineTail
+lineHead
!byte $e2,$FF,$c9,$FF,$4b,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF
+lineTail
+lineHead
!byte $e2,$FF,$c9,$FF,$4b,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF
+lineTail
+lineHead
!byte $e2,$FF,$c9,$FF,$4b,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF
+lineTail
+lineHead
!byte $e2,$FF,$c9,$FF,$4b,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF
+lineTail
+lineHead
!byte $e2,$FF,$c9,$FF,$4b,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF
+lineTail
+lineHead
!byte $e2,$FF,$c9,$FF,$4b,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF
+lineTail
+lineHead
!byte $e2,$FF,$c9,$FF,$4b,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF
+lineTail
+lineHead
!byte $e2,$FF,$c9,$FF,$4b,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF
+lineTail
+lineHead
!byte $e2,$FF,$c9,$FF,$4b,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF
+lineTail
+lineHead
!byte $e2,$FF,$c9,$FF,$4b,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF,$e0,$FF
+lineTail
