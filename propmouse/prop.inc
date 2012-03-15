
;; ---------------------------------------------------------------------------
;; Inits the driver, resets the exported coordinates and the error counter
;; in:	none
;; overwrites:	A, X, Y
;; ---------------------------------------------------------------------------
.import prop_init
;; ---------------------------------------------------------------------------
;; Updates the internal driver state with a sample of the joystick bits. Based
;; on this, the driver will then update the exported coordinates and/or
;; increase the error counter.
;; in:	A	The sample to process, the four least significant bits are
;;		used. The joystick directions are mapped to these bits like
;;		this: 0=up, 1=down, 2:left, 3:right
;; overwrites A, X, Y
;; ---------------------------------------------------------------------------
.import prop_update
;; ---------------------------------------------------------------------------
;; The X-coordinate, increases from left to right
;; size:	byte
;; ---------------------------------------------------------------------------
.import prop_x
;; ---------------------------------------------------------------------------
;; The Y-coordinate, increases from top to bottom
;; size:	byte
;; ---------------------------------------------------------------------------
.import prop_y
;; ---------------------------------------------------------------------------
;; If the driver detects that the prop-device is moved faster than the polling
;; interval can reliably detect then the error counter will be increased.
;; size:	word
;; ---------------------------------------------------------------------------
.import   prop_err
