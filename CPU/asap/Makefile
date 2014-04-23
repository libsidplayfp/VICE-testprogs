
all: cpu_ane.prg cpu_anx.prg cpu_las.prg cpu_shx.prg cpu_decimal.prg

cpu_ane.prg:  cpu_ane.asm
	acme -o cpu_ane.prg cpu_ane.asm

cpu_anx.prg:  cpu_anx.asm
	acme -o cpu_anx.prg cpu_anx.asm

cpu_las.prg:  cpu_las.asm
	acme -o cpu_las.prg cpu_las.asm

cpu_shx.prg:  cpu_shx.asm
	acme -o cpu_shx.prg cpu_shx.asm

cpu_decimal.prg:  cpu_decimal.asm
	acme -o cpu_decimal.prg cpu_decimal.asm

clean:
	rm	-f cpu_ane.prg cpu_anx.prg cpu_las.prg cpu_shx.prg cpu_decimal.prg
	rm	-f *~