
!macro BWORD value {
    !byte (value >> 8) & $ff
    !byte (value >> 0) & $ff
}
!macro BLONG value {
    !byte (value >> 24) & $ff
    !byte (value >> 16) & $ff
    !byte (value >> 8) & $ff
    !byte (value >> 0) & $ff
}
;-------------------------------------------------------------------------------

!if (headerversion > $0001) {
    headerlen = $7c
} else {
    headerlen = $76
}

    * = imagestart - (headerlen + 2)

h00    !byte $50,$53,$49,$44     ;magicID: ``PSID'' or ``RSID''
h04    +BWORD headerversion      ; version
h06    +BWORD headerlen          ; offset to data
h08    +BWORD $0000              ;loadAddress
h0A    +BWORD init               ;initAddress
h0C    +BWORD play               ;playAddress
h0E    +BWORD $01                ;songs
h10    +BWORD $01                ;startSong
h12    +BLONG $00000000          ;speed

;    ``<name>''
h16 !byte $30,$31,$32,$33,$34,$35,$36,$37,$38,$39,$30,$31,$32,$33,$34,$35,$36,$37,$38,$39,$30,$31,$32,$33,$34,$35,$36,$37,$38,$39,$30,$31
;    ``<author>''
h36 !byte $30,$31,$32,$33,$34,$35,$36,$37,$38,$39,$30,$31,$32,$33,$34,$35,$36,$37,$38,$39,$30,$31,$32,$33,$34,$35,$36,$37,$38,$39,$30,$31
;    ``<released>'' (once known as ``<copyright>'')
h56 !byte $30,$31,$32,$33,$34,$35,$36,$37,$38,$39,$30,$31,$32,$33,$34,$35,$36,$37,$38,$39,$30,$31,$32,$33,$34,$35,$36,$37,$38,$39,$30,$31

!if (headerversion = $0002) {
h76    +BWORD $0000     ;flags
h78    !BYTE $00        ;startPage (relocStartPage)
h79    !BYTE $00        ;pageLength (relocPages)
h7A    !BYTE $00        ;secondSIDAddress (v3 only, should be 0)
h7B    !BYTE $00        ;reserved (should be 0)
}
!if (headerversion = $0003) {
h76    +BWORD $0000     ;flags
h78    !BYTE $00        ;startPage (relocStartPage)
h79    !BYTE $00        ;pageLength (relocPages)
h7A    !BYTE $00        ;secondSIDAddress
h7B    !BYTE $00        ;reserved (should be 0)
}
    ; binary load address (if not in header)
    ; not really part of the psid header
    * = (imagestart - 2)
    !word imagestart

 
