TARGETS = \
noise_writeback_check_8_to_8_old.prg \
noise_writeback_check_8_to_8_new.prg \
noise_writeback_check_8_to_9_old.prg \
noise_writeback_check_8_to_9_new.prg \
noise_writeback_check_8_to_C_old.prg \
noise_writeback_check_8_to_C_new.prg \
noise_writeback_check_9_to_8_old.prg \
noise_writeback_check_9_to_8_new.prg \
noise_writeback_check_A_to_8_old.prg \
noise_writeback_check_A_to_8_new.prg \
noise_writeback_check_9_to_9_old.prg \
noise_writeback_check_9_to_9_new.prg \
noise_writeback_check_9_to_A_old.prg \
noise_writeback_check_9_to_A_new.prg \
noise_writeback_check_A_to_9_old.prg \
noise_writeback_check_A_to_9_new.prg \
noise_writeback_check_A_to_A_old.prg \
noise_writeback_check_A_to_A_new.prg \
noise_writeback_check_C_to_C_old.prg \
noise_writeback_check_C_to_C_new.prg \
noise_writeback_check_D_to_E_old.prg \
noise_writeback_check_D_to_E_new.prg \
noise_writeback_check_E_to_B_old.prg \
noise_writeback_check_E_to_B_new.prg \
noise_writeback_check_E_to_D_old.prg \
noise_writeback_check_E_to_D_new.prg

all: $(TARGETS) noise_writeback_test1-old.prg noise_writeback_test1-new.prg \
	noise_writeback_test2-old.prg noise_writeback_test2-new.prg noisewriteback.prg

noise_writeback_check_8_to_8_old.prg: noise_writeback_check.asm
	acme -DWAVES=0 -DNEWSID=0 -f cbm -o $@ $<

noise_writeback_check_8_to_8_new.prg: noise_writeback_check.asm
	acme -DWAVES=0 -DNEWSID=1 -f cbm -o $@ $<

noise_writeback_check_8_to_9_old.prg: noise_writeback_check.asm
	acme -DWAVES=1 -DNEWSID=0 -f cbm -o $@ $<

noise_writeback_check_8_to_9_new.prg: noise_writeback_check.asm
	acme -DWAVES=1 -DNEWSID=1 -f cbm -o $@ $<

noise_writeback_check_8_to_C_old.prg: noise_writeback_check.asm
	acme -DWAVES=2 -DNEWSID=0 -f cbm -o $@ $<

noise_writeback_check_8_to_C_new.prg: noise_writeback_check.asm
	acme -DWAVES=2 -DNEWSID=1 -f cbm -o $@ $<

noise_writeback_check_9_to_8_old.prg: noise_writeback_check.asm
	acme -DWAVES=3 -DNEWSID=0 -f cbm -o $@ $<

noise_writeback_check_9_to_8_new.prg: noise_writeback_check.asm
	acme -DWAVES=3 -DNEWSID=1 -f cbm -o $@ $<

noise_writeback_check_A_to_8_old.prg: noise_writeback_check.asm
	acme -DWAVES=4 -DNEWSID=0 -f cbm -o $@ $<

noise_writeback_check_A_to_8_new.prg: noise_writeback_check.asm
	acme -DWAVES=4 -DNEWSID=1 -f cbm -o $@ $<

noise_writeback_check_9_to_9_old.prg: noise_writeback_check.asm
	acme -DWAVES=5 -DNEWSID=0 -f cbm -o $@ $<

noise_writeback_check_9_to_9_new.prg: noise_writeback_check.asm
	acme -DWAVES=5 -DNEWSID=1 -f cbm -o $@ $<

noise_writeback_check_9_to_A_old.prg: noise_writeback_check.asm
	acme -DWAVES=6 -DNEWSID=0 -f cbm -o $@ $<

noise_writeback_check_9_to_A_new.prg: noise_writeback_check.asm
	acme -DWAVES=6 -DNEWSID=1 -f cbm -o $@ $<

noise_writeback_check_A_to_9_old.prg: noise_writeback_check.asm
	acme -DWAVES=7 -DNEWSID=0 -f cbm -o $@ $<

noise_writeback_check_A_to_9_new.prg: noise_writeback_check.asm
	acme -DWAVES=7 -DNEWSID=1 -f cbm -o $@ $<

noise_writeback_check_A_to_A_old.prg: noise_writeback_check.asm
	acme -DWAVES=8 -DNEWSID=0 -f cbm -o $@ $<

noise_writeback_check_A_to_A_new.prg: noise_writeback_check.asm
	acme -DWAVES=8 -DNEWSID=1 -f cbm -o $@ $<

noise_writeback_check_C_to_C_old.prg: noise_writeback_check.asm
	acme -DWAVES=9 -DNEWSID=0 -f cbm -o $@ $<

noise_writeback_check_C_to_C_new.prg: noise_writeback_check.asm
	acme -DWAVES=9 -DNEWSID=1 -f cbm -o $@ $<

noise_writeback_check_D_to_E_old.prg: noise_writeback_check.asm
	acme -DWAVES=10 -DNEWSID=0 -f cbm -o $@ $<

noise_writeback_check_D_to_E_new.prg: noise_writeback_check.asm
	acme -DWAVES=10 -DNEWSID=1 -f cbm -o $@ $<

noise_writeback_check_E_to_B_old.prg: noise_writeback_check.asm
	acme -DWAVES=11 -DNEWSID=0 -f cbm -o $@ $<

noise_writeback_check_E_to_B_new.prg: noise_writeback_check.asm
	acme -DWAVES=11 -DNEWSID=1 -f cbm -o $@ $<

noise_writeback_check_E_to_D_old.prg: noise_writeback_check.asm
	acme -DWAVES=12 -DNEWSID=0 -f cbm -o $@ $<

noise_writeback_check_E_to_D_new.prg: noise_writeback_check.asm
	acme -DWAVES=12 -DNEWSID=1 -f cbm -o $@ $<

noisewriteback.prg:  noisewriteback.asm
	acme -f cbm -o noisewriteback.prg noisewriteback.asm

noise_writeback_test1-old.prg:  noise_writeback_test1.asm
	acme -DNEWSID=0 -f cbm -o noise_writeback_test1-old.prg noise_writeback_test1.asm
noise_writeback_test1-new.prg:  noise_writeback_test1.asm
	acme -DNEWSID=1 -f cbm -o noise_writeback_test1-new.prg noise_writeback_test1.asm

noise_writeback_test2-old.prg:  noise_writeback_test2.asm
	acme -DNEWSID=0 -f cbm -o noise_writeback_test2-old.prg noise_writeback_test2.asm
noise_writeback_test2-new.prg:  noise_writeback_test2.asm
	acme -DNEWSID=1 -f cbm -o noise_writeback_test2-new.prg noise_writeback_test2.asm

clean:
	rm -f noise_writeback_test1-old.prg noise_writeback_test1-new.prg
	rm -f noise_writeback_test2-old.prg noise_writeback_test2-new.prg noisewriteback.prg
	rm -f $(TARGETS)
