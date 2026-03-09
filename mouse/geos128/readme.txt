related to: https://sourceforge.net/p/vice-emu/bugs/2208/

This code is modelled after the GEOS128 default 1351 mouse driver. This driver
does something odd: it first selects the POT port correctly, and also introduces
a (long enough) delay before reading the POT values, but shortly before doing
that, it sets the DDR to _input_, which effectively causes both paddle ports
to be selected. As a consequence, the code will no more work correctly, when
a device using the POT inputs is connected to "the other" port as well.
