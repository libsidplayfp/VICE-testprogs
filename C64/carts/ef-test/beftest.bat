..\..\cc65\bin\cl65 -v -vm -m ef_test.map -l -t none -C ef_test.link ef_test.asm -o ef_test.bin
..\..\cc65\bin\cl65 -v -vm -m ef_0.map -l -t none -C ef_8k.link ef_0.asm -o ef_0.bin
..\..\cc65\bin\cl65 -v -vm -m ef_1.map -l -t none -C ef_8k.link ef_1.asm -o ef_1.bin
..\..\cc65\bin\cl65 -v -vm -m ef_2.map -l -t none -C ef_8k.link ef_2.asm -o ef_2.bin
..\..\cc65\bin\cl65 -v -vm -m ef_3.map -l -t none -C ef_8k.link ef_3.asm -o ef_3.bin
..\..\cc65\bin\cl65 -v -vm -m ef_4.map -l -t none -C ef_8k.link ef_4.asm -o ef_4.bin
..\..\cc65\bin\cl65 -v -vm -m ef_5.map -l -t none -C ef_8k.link ef_5.asm -o ef_5.bin
..\..\cc65\bin\cl65 -v -vm -m ef_6.map -l -t none -C ef_8k.link ef_6.asm -o ef_6.bin
copy /b ef_0.bin + /b ef_test.bin + /b ef_1.bin + /b ef_2.bin ef_4x_1.bin
copy /b ef_3.bin + /b ef_4.bin + /b ef_5.bin + /b ef_6.bin ef_4x_2.bin
copy /b ef_4x_1.bin + /b ef_4x_2.bin ef_8x.bin
copy /b ef_8x.bin + /b ef_8x.bin ef_16x.bin
copy /b ef_16x.bin + /b ef_16x.bin ef_32x.bin
copy /b ef_32x.bin + /b ef_32x.bin + /b ef_32x.bin + /b ef_32x.bin ef_combined.bin
cartconv.exe -t easy -i ef_combined.bin -o ef_test.crt