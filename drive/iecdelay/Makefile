
all: iec-bus-delay.prg iec-bus-delay-auto.prg

iec-bus-delay.prg:  iec-bus-delay.bas
	petcat -w2 iec-bus-delay.bas > iec-bus-delay.prg
	
iec-bus-delay-auto.prg:  iec-bus-delay.bas
	grep -v "rem noauto" iec-bus-delay.bas > iec-bus-delay-auto.bas
	petcat -w2 iec-bus-delay-auto.bas > iec-bus-delay-auto.prg	
