these tests check the serial shift register of the VIA 

press/hold space to see the expected data

viasr??.prg: checks shift register mode ??
viasr??exp.prg: same for expanded VIC-20

viasr??ifr.prg: checks ifr when in shift register mode ??
viasr??iex.prg: same for expanded VIC-20

All viasr??.prg should pass.

The *ifr* cases fail, for example:

For all shift-in modes (dump00i.bin) the expected result turns on
    VIA_IM_CA2 in sample $07 (counting from $00)
    VIA_IM_T2             0D  (this is correctly emulated)
    VIA_IM_T1             18

For all shift-out modes (dump14i.bin) the expected result turns on
    VIA_IM_CB2 in sample $00 (i.e. from the start)
    VIA_IM_CA2            07
    VIA_IM_T2             0D (this is correctly emulated)
    VIA_IM_T1             18

