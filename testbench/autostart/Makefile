
TARGETS=\
	autostart-c64-none.prg \
	autostart-c64-tde.prg \
	autostart-c64-vdrive.prg \
	autostart-c64-vfs.prg \
	autostart-c64-tde-disk.prg \
	autostart-c64-vdrive-disk.prg \
	autostart-c64-none-image.prg \
	autostart-c64-tde-image.prg \
	autostart-c64-vdrive-image.prg \
	\
	autostart-c64-none.d64 \
	autostart-c64-tde.d64 \
	autostart-c64-vdrive.d64 \
	autostart-c64-vfs.d64 \
	autostart-c64-tde-disk.d64 \
	autostart-c64-vdrive-disk.d64 \
	autostart-c64-none-image.d64 \
	autostart-c64-tde-image.d64 \
	autostart-c64-vdrive-image.d64

all: $(TARGETS)

autostart-c64-none.prg: autostart.bas
	cpp -DEXPECT_TDE=0 -DEXPECT_VDRIVE=0 -DEXPECT_VFS=0 -DEXPECT_AUTOSTART_DISK=0 -DEXPECT_DISKIMAGE=0 -DDEBUGREG=55295 -E $< | grep -v "^#" | petcat -w2 -o $@
autostart-c64-tde.prg: autostart.bas
	cpp -DEXPECT_TDE=1 -DEXPECT_VDRIVE=0 -DEXPECT_VFS=0 -DEXPECT_AUTOSTART_DISK=0 -DEXPECT_DISKIMAGE=0 -DDEBUGREG=55295 -E $< | grep -v "^#" | petcat -w2 -o $@
autostart-c64-vdrive.prg: autostart.bas
	cpp -DEXPECT_TDE=0 -DEXPECT_VDRIVE=1 -DEXPECT_VFS=0 -DEXPECT_AUTOSTART_DISK=0 -DEXPECT_DISKIMAGE=0 -DDEBUGREG=55295 -E $< | grep -v "^#" | petcat -w2 -o $@
autostart-c64-vfs.prg: autostart.bas
	cpp -DEXPECT_TDE=0 -DEXPECT_VDRIVE=0 -DEXPECT_VFS=1 -DEXPECT_AUTOSTART_DISK=0 -DEXPECT_DISKIMAGE=0 -DDEBUGREG=55295 -E $< | grep -v "^#" | petcat -w2 -o $@
autostart-c64-tde-disk.prg: autostart.bas
	cpp -DEXPECT_TDE=1 -DEXPECT_VDRIVE=0 -DEXPECT_VFS=0 -DEXPECT_AUTOSTART_DISK=1 -DEXPECT_DISKIMAGE=0 -DDEBUGREG=55295 -E $< | grep -v "^#" | petcat -w2 -o $@
autostart-c64-vdrive-disk.prg: autostart.bas
	cpp -DEXPECT_TDE=0 -DEXPECT_VDRIVE=1 -DEXPECT_VFS=0 -DEXPECT_AUTOSTART_DISK=1 -DEXPECT_DISKIMAGE=0 -DDEBUGREG=55295 -E $< | grep -v "^#" | petcat -w2 -o $@

autostart-c64-none-image.prg: autostart.bas
	cpp -DEXPECT_TDE=0 -DEXPECT_VDRIVE=0 -DEXPECT_VFS=0 -DEXPECT_AUTOSTART_DISK=0 -DEXPECT_DISKIMAGE=0 -DDEBUGREG=55295 -E $< | grep -v "^#" | petcat -w2 -o $@
autostart-c64-tde-image.prg: autostart.bas
	cpp -DEXPECT_TDE=1 -DEXPECT_VDRIVE=0 -DEXPECT_VFS=0 -DEXPECT_AUTOSTART_DISK=0 -DEXPECT_DISKIMAGE=1 -DDEBUGREG=55295 -E $< | grep -v "^#" | petcat -w2 -o $@
autostart-c64-vdrive-image.prg: autostart.bas
	cpp -DEXPECT_TDE=0 -DEXPECT_VDRIVE=1 -DEXPECT_VFS=0 -DEXPECT_AUTOSTART_DISK=0 -DEXPECT_DISKIMAGE=1 -DDEBUGREG=55295 -E $< | grep -v "^#" | petcat -w2 -o $@
	
autostart-c64-none.d64: autostart-c64-none.prg
	c1541 -format "testdisk,00" d64 $@ -write $< "test"
autostart-c64-tde.d64: autostart-c64-tde.prg
	c1541 -format "testdisk,00" d64 $@ -write $< "test"
autostart-c64-vdrive.d64: autostart-c64-vdrive.prg
	c1541 -format "testdisk,00" d64 $@ -write $< "test"
autostart-c64-vfs.d64: autostart-c64-vfs.prg
	c1541 -format "testdisk,00" d64 $@ -write $< "test"
autostart-c64-tde-disk.d64: autostart-c64-tde-disk.prg
	c1541 -format "testdisk,00" d64 $@ -write $< "test"
autostart-c64-vdrive-disk.d64: autostart-c64-vdrive-disk.prg
	c1541 -format "testdisk,00" d64 $@ -write $< "test"

autostart-c64-none-image.d64: autostart-c64-none-image.prg
	c1541 -format "testdisk,00" d64 $@ -write $< "test"
autostart-c64-tde-image.d64: autostart-c64-tde-image.prg
	c1541 -format "testdisk,00" d64 $@ -write $< "test"
autostart-c64-vdrive-image.d64: autostart-c64-vdrive-image.prg
	c1541 -format "testdisk,00" d64 $@ -write $< "test"
	
.PHONY: test
	
test: $(TARGETS)
	./autostart.sh x64
	./autostart.sh x64sc

clean:
	$(RM) *.prg
