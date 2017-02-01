	

all: ef_test.crt	
	
ef_combined.bin: ef_test.asm ef_0.asm ef_1.asm ef_2.asm ef_3.asm ef_4.asm ef_5.asm ef_6.asm ef_test.link ef_8k.link
	cl65 -t none -v -vm -m ef_test.map -l ef_test.lst -C ef_test.link ef_test.asm -o ef_test.bin
	cl65 -t none -v -vm -m ef_0.map -l ef_0.lst -C ef_8k.link ef_0.asm -o ef_0.bin
	cl65 -t none -v -vm -m ef_1.map -l ef_1.lst -C ef_8k.link ef_1.asm -o ef_1.bin
	cl65 -t none -v -vm -m ef_2.map -l ef_2.lst -C ef_8k.link ef_2.asm -o ef_2.bin
	cl65 -t none -v -vm -m ef_3.map -l ef_3.lst -C ef_8k.link ef_3.asm -o ef_3.bin
	cl65 -t none -v -vm -m ef_4.map -l ef_4.lst -C ef_8k.link ef_4.asm -o ef_4.bin
	cl65 -t none -v -vm -m ef_5.map -l ef_5.lst -C ef_8k.link ef_5.asm -o ef_5.bin
	cl65 -t none -v -vm -m ef_6.map -l ef_6.lst -C ef_8k.link ef_6.asm -o ef_6.bin
	cat ef_0.bin ef_test.bin ef_1.bin ef_2.bin \
	    ef_3.bin ef_4.bin    ef_5.bin ef_6.bin \
	    ef_0.bin ef_test.bin ef_1.bin ef_2.bin \
	    ef_3.bin ef_4.bin    ef_5.bin ef_6.bin \
	    ef_0.bin ef_test.bin ef_1.bin ef_2.bin \
	    ef_3.bin ef_4.bin    ef_5.bin ef_6.bin \
	    ef_0.bin ef_test.bin ef_1.bin ef_2.bin \
	    ef_3.bin ef_4.bin    ef_5.bin ef_6.bin \
	    ef_0.bin ef_test.bin ef_1.bin ef_2.bin \
	    ef_3.bin ef_4.bin    ef_5.bin ef_6.bin \
	    ef_0.bin ef_test.bin ef_1.bin ef_2.bin \
	    ef_3.bin ef_4.bin    ef_5.bin ef_6.bin \
	    ef_0.bin ef_test.bin ef_1.bin ef_2.bin \
	    ef_3.bin ef_4.bin    ef_5.bin ef_6.bin \
	    ef_0.bin ef_test.bin ef_1.bin ef_2.bin \
	    ef_3.bin ef_4.bin    ef_5.bin ef_6.bin \
	    ef_0.bin ef_test.bin ef_1.bin ef_2.bin \
	    ef_3.bin ef_4.bin    ef_5.bin ef_6.bin \
	    ef_0.bin ef_test.bin ef_1.bin ef_2.bin \
	    ef_3.bin ef_4.bin    ef_5.bin ef_6.bin \
	    ef_0.bin ef_test.bin ef_1.bin ef_2.bin \
	    ef_3.bin ef_4.bin    ef_5.bin ef_6.bin \
	    ef_0.bin ef_test.bin ef_1.bin ef_2.bin \
	    ef_3.bin ef_4.bin    ef_5.bin ef_6.bin \
	    ef_0.bin ef_test.bin ef_1.bin ef_2.bin \
	    ef_3.bin ef_4.bin    ef_5.bin ef_6.bin \
	    ef_0.bin ef_test.bin ef_1.bin ef_2.bin \
	    ef_3.bin ef_4.bin    ef_5.bin ef_6.bin \
	    ef_0.bin ef_test.bin ef_1.bin ef_2.bin \
	    ef_3.bin ef_4.bin    ef_5.bin ef_6.bin \
	    ef_0.bin ef_test.bin ef_1.bin ef_2.bin \
	    ef_3.bin ef_4.bin    ef_5.bin ef_6.bin \
		> ef_combined.bin
	rm -f ef_0.bin ef_1.bin ef_2.bin ef_3.bin
	rm -f ef_4.bin ef_5.bin ef_6.bin ef_test.bin

ef_test.crt: ef_combined.bin
	cartconv -t easy -i ef_combined.bin -o ef_test.crt 

clean:
	rm -f ef_test.crt ef_combined.bin
	rm -f ef_0.bin ef_1.bin ef_2.bin ef_3.bin
	rm -f ef_4.bin ef_5.bin ef_6.bin ef_test.bin
	rm -f ef_0.o ef_1.o ef_2.o ef_3.o
	rm -f ef_4.o ef_5.o ef_6.o ef_test.o
	rm -f ef_0.lst ef_1.lst ef_2.lst ef_3.lst
	rm -f ef_4.lst ef_5.lst ef_6.lst ef_test.lst
	rm -f ef_0.map ef_1.map ef_2.map ef_3.map
	rm -f ef_4.map ef_5.map ef_6.map ef_test.map
	
