
.SILENT:

include Makefile.config

all: c64 vic20 plus4 c128

c64:
	@./cartconv-test.sh $(C64CARTS) c64
vic20:
	@./cartconv-test.sh $(VIC20CARTS) vic20
plus4:
	@./cartconv-test.sh $(PLUS4CARTS) plus4
c128:
	@./cartconv-test.sh $(C128CARTS) c128

clean:
	@$(RM) -rf test
