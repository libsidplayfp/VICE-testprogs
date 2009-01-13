; -- Test configuration

; - release
; 0: For measuring att/dec times
; 1: For measuring release (gate off after reaching env = $ff)
;
RELEASE = 1

!if RELEASE = 0 {
; AD value (SR = $00)
A_D = $11
} else {
; R value (AD = $00, S = $f)
REL = $2
}
