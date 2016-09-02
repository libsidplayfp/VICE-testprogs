all: writer.prg writer.d64

writer.prg: writer.s
	acme -f cbm -o writer.prg writer.s

writer.d64: writer.prg
	c1541 -format "writer,00" d64 writer.d64 -write writer.prg writer
	
clean:
	rm -f writer.prg writer.d64
