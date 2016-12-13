X64=../../../trunk/vice/src/x64
XVIC=../../../trunk/vice/src/xvic
XPLUS4=../../../trunk/vice/src/xplus4
XDTV=../../../trunk/vice/src/x64dtv
X128=../../../trunk/vice/src/x128
XPET=../../../trunk/vice/src/xpet

################################################################################

X64+=-default -warp -limitcycles 10000000
X64+=+truedrive -virtualdev
X64+=-VICIIdsize -VICIIborders 3

X64OPT+=-VICIIsaturation 1000 -VICIIcontrast 1000 -VICIIbrightness 1000 -VICIItint 1000
X64OPT+=-VICIIoddlinesphase 1000 -VICIIoddlinesoffset 1000
X64OPT+=-VICIIcrtscanlineshade 1000

X64GUIOPT=-limitcycles 50000000

C64PRG=../../crtemulation/colors/colors.prg

################################################################################

X128+=-default -warp -limitcycles 20000000 -80col
X128+=+truedrive -virtualdev
X128+=-VDCdsize +VICIIdsize

X128OPT+=-VDCsaturation 1000 -VDCcontrast 1000 -VDCbrightness 1000 -VDCtint 1000
X128OPT+=-VDCcrtscanlineshade 1000

X128GUIOPT=-limitcycles 60000000

C128PRG=../../crtemulation/c128/colors.prg

################################################################################

XVIC+=-default -warp -limitcycles 25000000
XVIC+=+truedrive -virtualdev
XVIC+=-VICdsize -VICborders 3

XVICOPT+=-VICsaturation 1000 -VICcontrast 1000 -VICbrightness 1000 -VICtint 1000
XVICOPT+=-VICoddlinesphase 1000 -VICoddlinesoffset 1000
XVICOPT+=-VICcrtscanlineshade 1000

XVICGUIOPT=-limitcycles 50000000
XVICGUINTSCOPT=-limitcycles 200000000

VICPRG=../../crtemulation/vic20/colour_test.d64

################################################################################

XPLUS4+=-default -warp -limitcycles 25000000
XPLUS4+=+truedrive -virtualdev
XPLUS4+=-TEDdsize -TEDborders 3

XPLUS4OPT+=-TEDsaturation 1000 -TEDcontrast 1000 -TEDbrightness 1000 -TEDtint 1000
XPLUS4OPT+=-TEDoddlinesphase 1000 -TEDoddlinesoffset 1000
XPLUS4OPT+=-TEDcrtscanlineshade 1000

XPLUS4GUIOPT=-limitcycles 50000000

PLUS4PRG=../../crtemulation/plus4/color_test.prg

################################################################################

XDTV+=-default -warp -limitcycles 25000000
XDTV+=+truedrive -virtualdev
XDTV+=-VICIIdsize -VICIIborders 3

XDTVOPT+=-VICIIsaturation 1000 -VICIIcontrast 1000 -VICIIbrightness 1000 -VICIItint 1000
XDTVOPT+=-VICIIoddlinesphase 1000 -VICIIoddlinesoffset 1000
XDTVOPT+=-VICIIcrtscanlineshade 1000

XDTVGUIOPT=-limitcycles 55000000

DTVPRG=../../crtemulation/DTV/displaytest.prg

################################################################################

XPET+=-default -warp -limitcycles 25000000
XPET+=+truedrive -virtualdev
#XPET+=-CRTCdsize

XPETOPT+=-CRTCsaturation 1000 -CRTCcontrast 1000 -CRTCbrightness 1000
XPETOPT+=-CRTCcrtscanlineshade 1000

XPETGUIOPT=-limitcycles 55000000

PETPRG=../../crtemulation/pet/displaytest.prg

################################################################################

SHUTTER=shutter --min_at_startup --disable_systray -e -n
SHUTTERX64=--delay 1 --window="VICE: C64 emulator"
SHUTTERXVIC=--delay 1 --window="VICE: VIC20 emulator"
SHUTTERXPLUS4=--delay 1 --window="VICE: PLUS4 emulator"
SHUTTERXDTV=--delay 1 --window="VICE: C64DTV emulator"
SHUTTERX128=--delay 4 --window="VICE: C128 emulator"
SHUTTERXPET=--delay 1 --window="VICE: Pet emulator"

################################################################################

all: c64 vic20 plus4 dtv c128 pet

c64: c64-pal c64-ntsc c64-pal-gui c64-ntsc-gui
vic20: vic20-pal vic20-ntsc vic20-pal-gui vic20-ntsc-gui
plus4: plus4-pal plus4-ntsc plus4-pal-gui plus4-ntsc-gui
dtv: dtv-pal dtv-pal-gui
c128: c128-rgb c128-rgb-gui
pet: pet-mono pet-mono-gui

shots:
	mkdir -p shots

################################################################################
	
c64-pal: shots
	-$(X64) $(X64OPT) +VICIIdsize -VICIIfilter 1 -exitscreenshot shots/c64-internal-crt.png $(C64PRG) > /dev/null
	-$(X64) $(X64OPT) +VICIIdsize -VICIIfilter 0 -exitscreenshot shots/c64-internal-unfiltered.png $(C64PRG) > /dev/null

	-$(X64) $(X64OPT) +VICIIdsize -VICIIextpal -VICIIpalette pepto-pal -VICIIfilter 1 -exitscreenshot shots/c64-pepto-crt.png $(C64PRG) > /dev/null
	-$(X64) $(X64OPT) +VICIIdsize -VICIIextpal -VICIIpalette pepto-pal -VICIIfilter 0 -exitscreenshot shots/c64-pepto-unfiltered.png $(C64PRG) > /dev/null

	-$(X64) $(X64OPT) -VICIIdsize -VICIIfilter 1 -exitscreenshot shots/c64-internal-crt-ds.png $(C64PRG) > /dev/null
	-$(X64) $(X64OPT) -VICIIdsize -VICIIfilter 0 -exitscreenshot shots/c64-internal-unfiltered-ds.png $(C64PRG) > /dev/null

	-$(X64) $(X64OPT) -VICIIdsize -VICIIextpal -VICIIpalette pepto-pal -VICIIfilter 1 -exitscreenshot shots/c64-pepto-crt-ds.png $(C64PRG) > /dev/null
	-$(X64) $(X64OPT) -VICIIdsize -VICIIextpal -VICIIpalette pepto-pal -VICIIfilter 0 -exitscreenshot shots/c64-pepto-unfiltered-ds.png $(C64PRG) > /dev/null

c64-ntsc: shots
	-$(X64) $(X64OPT) -ntsc +VICIIdsize -VICIIfilter 1 -exitscreenshot shots/c64-ntsc-internal-crt.png $(C64PRG) > /dev/null
	-$(X64) $(X64OPT) -ntsc +VICIIdsize -VICIIfilter 0 -exitscreenshot shots/c64-ntsc-internal-unfiltered.png $(C64PRG) > /dev/null

	-$(X64) $(X64OPT) -ntsc +VICIIdsize -VICIIextpal -VICIIpalette pepto-ntsc-sony -VICIIfilter 1 -exitscreenshot shots/c64-ntsc-pepto-crt.png $(C64PRG) > /dev/null
	-$(X64) $(X64OPT) -ntsc +VICIIdsize -VICIIextpal -VICIIpalette pepto-ntsc-sony -VICIIfilter 0 -exitscreenshot shots/c64-ntsc-pepto-unfiltered.png $(C64PRG) > /dev/null
	
	-$(X64) $(X64OPT) -ntsc -VICIIdsize -VICIIfilter 1 -exitscreenshot shots/c64-ntsc-internal-crt-ds.png $(C64PRG) > /dev/null
	-$(X64) $(X64OPT) -ntsc -VICIIdsize -VICIIfilter 0 -exitscreenshot shots/c64-ntsc-internal-unfiltered-ds.png $(C64PRG) > /dev/null

	-$(X64) $(X64OPT) -ntsc -VICIIdsize -VICIIextpal -VICIIpalette pepto-ntsc-sony -VICIIfilter 1 -exitscreenshot shots/c64-ntsc-pepto-crt-ds.png $(C64PRG) > /dev/null
	-$(X64) $(X64OPT) -ntsc -VICIIdsize -VICIIextpal -VICIIpalette pepto-ntsc-sony -VICIIfilter 0 -exitscreenshot shots/c64-ntsc-pepto-unfiltered-ds.png $(C64PRG) > /dev/null
	
c64-pal-gui: shots
	-$(X64) -VICIIcrtscanlineshade 1000 -VICIIdsize -VICIIfilter 1 $(X64GUIOPT) $(C64PRG) > /dev/null & \
	 sleep 1 && $(SHUTTER) $(SHUTTERX64) -o shots/c64-gui-default-crt.png > /dev/null
	 
	-$(X64) -VICIIcrtscanlineshade 1000 -VICIIdsize -VICIIfilter 0 $(X64GUIOPT) $(C64PRG) > /dev/null & \
	 sleep 1 && $(SHUTTER) $(SHUTTERX64) -o shots/c64-gui-default-unfiltered.png > /dev/null
	 
	-$(X64) $(X64OPT) +VICIIdsize -VICIIfilter 1 $(X64GUIOPT) $(C64PRG) > /dev/null & \
	 sleep 1 && $(SHUTTER) $(SHUTTERX64) -o shots/c64-gui-internal-crt.png > /dev/null
	 
	-$(X64) $(X64OPT) +VICIIdsize -VICIIfilter 0 $(X64GUIOPT) $(C64PRG) > /dev/null & \
	 sleep 1 && $(SHUTTER) $(SHUTTERX64) -o shots/c64-gui-internal-unfiltered.png > /dev/null
	 
	-$(X64) $(X64OPT) +VICIIdsize -VICIIextpal -VICIIpalette pepto-pal -VICIIfilter 1 $(X64GUIOPT) $(C64PRG) > /dev/null & \
	 sleep 1 && $(SHUTTER) $(SHUTTERX64) -o shots/c64-gui-pepto-crt.png > /dev/null
	 
	-$(X64) $(X64OPT) +VICIIdsize -VICIIextpal -VICIIpalette pepto-pal -VICIIfilter 0 $(X64GUIOPT) $(C64PRG) > /dev/null & \
	 sleep 1 && $(SHUTTER) $(SHUTTERX64) -o shots/c64-gui-pepto-unfiltered.png > /dev/null

	-$(X64) $(X64OPT) -VICIIdsize -VICIIfilter 1 $(X64GUIOPT) $(C64PRG) > /dev/null & \
	 sleep 1 && $(SHUTTER) $(SHUTTERX64) -o shots/c64-gui-internal-crt-ds.png > /dev/null
	 
	-$(X64) $(X64OPT) -VICIIdsize -VICIIfilter 0 $(X64GUIOPT) $(C64PRG) > /dev/null & \
	 sleep 1 && $(SHUTTER) $(SHUTTERX64) -o shots/c64-gui-internal-unfiltered-ds.png > /dev/null
	 
	-$(X64) $(X64OPT) -VICIIdsize -VICIIextpal -VICIIpalette pepto-pal -VICIIfilter 1 $(X64GUIOPT) $(C64PRG) > /dev/null & \
	 sleep 1 && $(SHUTTER) $(SHUTTERX64) -o shots/c64-gui-pepto-crt-ds.png > /dev/null
	 
	-$(X64) $(X64OPT) -VICIIdsize -VICIIextpal -VICIIpalette pepto-pal -VICIIfilter 0 $(X64GUIOPT) $(C64PRG) > /dev/null & \
	 sleep 1 && $(SHUTTER) $(SHUTTERX64) -o shots/c64-gui-pepto-unfiltered-ds.png > /dev/null

c64-ntsc-gui: shots
	-$(X64) -ntsc -VICIIcrtscanlineshade 1000 -VICIIdsize -VICIIfilter 1 $(X64GUIOPT) $(C64PRG) > /dev/null & \
	 sleep 1 && $(SHUTTER) $(SHUTTERX64) -o shots/c64-gui-ntsc-default-crt.png > /dev/null
	 
	-$(X64) -ntsc -VICIIcrtscanlineshade 1000 -VICIIdsize -VICIIfilter 0 $(X64GUIOPT) $(C64PRG) > /dev/null & \
	 sleep 1 && $(SHUTTER) $(SHUTTERX64) -o shots/c64-gui-ntsc-default-unfiltered.png > /dev/null

	-$(X64) $(X64OPT) -ntsc +VICIIdsize -VICIIfilter 1 $(X64GUIOPT) $(C64PRG) > /dev/null & \
	 sleep 1 && $(SHUTTER) $(SHUTTERX64) -o shots/c64-gui-ntsc-internal-crt.png > /dev/null
	 
	-$(X64) $(X64OPT) -ntsc +VICIIdsize -VICIIfilter 0 $(X64GUIOPT) $(C64PRG) > /dev/null & \
	 sleep 1 && $(SHUTTER) $(SHUTTERX64) -o shots/c64-gui-ntsc-internal-unfiltered.png > /dev/null
	 
	-$(X64) $(X64OPT) -ntsc +VICIIdsize -VICIIextpal -VICIIpalette pepto-ntsc-sony -VICIIfilter 1 $(X64GUIOPT) $(C64PRG) > /dev/null & \
	 sleep 1 && $(SHUTTER) $(SHUTTERX64) -o shots/c64-gui-ntsc-pepto-crt.png > /dev/null
	 
	-$(X64) $(X64OPT) -ntsc +VICIIdsize -VICIIextpal -VICIIpalette pepto-ntsc-sony -VICIIfilter 0 $(X64GUIOPT) $(C64PRG) > /dev/null & \
	 sleep 1 && $(SHUTTER) $(SHUTTERX64) -o shots/c64-gui-ntsc-pepto-unfiltered.png > /dev/null

	-$(X64) $(X64OPT) -ntsc -VICIIdsize -VICIIfilter 1 $(X64GUIOPT) $(C64PRG) > /dev/null & \
	 sleep 1 && $(SHUTTER) $(SHUTTERX64) -o shots/c64-gui-ntsc-internal-crt-ds.png > /dev/null
	 
	-$(X64) $(X64OPT) -ntsc -VICIIdsize -VICIIfilter 0 $(X64GUIOPT) $(C64PRG) > /dev/null & \
	 sleep 1 && $(SHUTTER) $(SHUTTERX64) -o shots/c64-gui-ntsc-internal-unfiltered-ds.png > /dev/null
	 
	-$(X64) $(X64OPT) -ntsc -VICIIdsize -VICIIextpal -VICIIpalette pepto-ntsc-sony -VICIIfilter 1 $(X64GUIOPT) $(C64PRG) > /dev/null & \
	 sleep 1 && $(SHUTTER) $(SHUTTERX64) -o shots/c64-gui-ntsc-pepto-crt-ds.png > /dev/null
	 
	-$(X64) $(X64OPT) -ntsc -VICIIdsize -VICIIextpal -VICIIpalette pepto-ntsc-sony -VICIIfilter 0 $(X64GUIOPT) $(C64PRG) > /dev/null & \
	 sleep 1 && $(SHUTTER) $(SHUTTERX64) -o shots/c64-gui-ntsc-pepto-unfiltered-ds.png > /dev/null

################################################################################

vic20-pal: shots
	-$(XVIC) $(XVICOPT) +VICdsize -VICfilter 1 -exitscreenshot shots/vic20-internal-crt.png $(VICPRG) > /dev/null
	-$(XVIC) $(XVICOPT) +VICdsize -VICfilter 0 -exitscreenshot shots/vic20-internal-unfiltered.png $(VICPRG) > /dev/null

	-$(XVIC) $(XVICOPT) +VICdsize -VICextpal -VICpalette mike-pal -VICfilter 1 -exitscreenshot shots/vic20-mike-crt.png $(VICPRG) > /dev/null
	-$(XVIC) $(XVICOPT) +VICdsize -VICextpal -VICpalette mike-pal -VICfilter 0 -exitscreenshot shots/vic20-mike-unfiltered.png $(VICPRG) > /dev/null

	-$(XVIC) $(XVICOPT) -VICdsize -VICfilter 1 -exitscreenshot shots/vic20-internal-crt-ds.png $(VICPRG) > /dev/null
	-$(XVIC) $(XVICOPT) -VICdsize -VICfilter 0 -exitscreenshot shots/vic20-internal-unfiltered-ds.png $(VICPRG) > /dev/null

	-$(XVIC) $(XVICOPT) -VICdsize -VICextpal -VICpalette mike-pal -VICfilter 1 -exitscreenshot shots/vic20-mike-crt-ds.png $(VICPRG) > /dev/null
	-$(XVIC) $(XVICOPT) -VICdsize -VICextpal -VICpalette mike-pal -VICfilter 0 -exitscreenshot shots/vic20-mike-unfiltered-ds.png $(VICPRG) > /dev/null
	
vic20-ntsc: shots
	-$(XVIC) $(XVICOPT) -ntsc +VICdsize -VICfilter 1 -exitscreenshot shots/vic20-ntsc-internal-crt.png $(VICPRG) > /dev/null
	-$(XVIC) $(XVICOPT) -ntsc +VICdsize -VICfilter 0 -exitscreenshot shots/vic20-ntsc-internal-unfiltered.png $(VICPRG) > /dev/null

	-$(XVIC) $(XVICOPT) -ntsc +VICdsize -VICextpal -VICpalette mike-ntsc -VICfilter 1 -exitscreenshot shots/vic20-ntsc-mike-crt.png $(VICPRG) > /dev/null
	-$(XVIC) $(XVICOPT) -ntsc +VICdsize -VICextpal -VICpalette mike-ntsc -VICfilter 0 -exitscreenshot shots/vic20-ntsc-mike-unfiltered.png $(VICPRG) > /dev/null
	
	-$(XVIC) $(XVICOPT) -ntsc -VICdsize -VICfilter 1 -exitscreenshot shots/vic20-ntsc-internal-crt-ds.png $(VICPRG) > /dev/null
	-$(XVIC) $(XVICOPT) -ntsc -VICdsize -VICfilter 0 -exitscreenshot shots/vic20-ntsc-internal-unfiltered-ds.png $(VICPRG) > /dev/null

	-$(XVIC) $(XVICOPT) -ntsc -VICdsize -VICextpal -VICpalette mike-ntsc -VICfilter 1 -exitscreenshot shots/vic20-ntsc-mike-crt-ds.png $(VICPRG) > /dev/null
	-$(XVIC) $(XVICOPT) -ntsc -VICdsize -VICextpal -VICpalette mike-ntsc -VICfilter 0 -exitscreenshot shots/vic20-ntsc-mike-unfiltered-ds.png $(VICPRG) > /dev/null
	
vic20-pal-gui: shots
	-$(XVIC) -VICcrtscanlineshade 1000 -VICdsize -VICfilter 1 $(XVICGUIOPT) $(VICPRG) > /dev/null & \
	 sleep 1 && $(SHUTTER) $(SHUTTERXVIC) -o shots/vic20-gui-default-crt.png > /dev/null

	-$(XVIC) -VICcrtscanlineshade 1000 -VICdsize -VICfilter 0 $(XVICGUIOPT) $(VICPRG) > /dev/null & \
	 sleep 1 && $(SHUTTER) $(SHUTTERXVIC) -o shots/vic20-gui-default-unfiltered.png > /dev/null

	-$(XVIC) $(XVICOPT) +VICdsize -VICfilter 1 $(XVICGUIOPT) $(VICPRG) > /dev/null & \
	 sleep 1 && $(SHUTTER) $(SHUTTERXVIC) -o shots/vic20-gui-internal-crt.png > /dev/null
	 
	-$(XVIC) $(XVICOPT) +VICdsize -VICfilter 0 $(XVICGUIOPT) $(VICPRG) > /dev/null & \
	 sleep 1 && $(SHUTTER) $(SHUTTERXVIC) -o shots/vic20-gui-internal-unfiltered.png > /dev/null
	 
	-$(XVIC) $(XVICOPT) +VICdsize -VICextpal -VICpalette mike-pal -VICfilter 1 $(XVICGUIOPT) $(VICPRG) > /dev/null & \
	 sleep 1 && $(SHUTTER) $(SHUTTERXVIC) -o shots/vic20-gui-mike-crt.png > /dev/null
	 
	-$(XVIC) $(XVICOPT) +VICdsize -VICextpal -VICpalette mike-pal -VICfilter 0 $(XVICGUIOPT) $(VICPRG) > /dev/null & \
	 sleep 1 && $(SHUTTER) $(SHUTTERXVIC) -o shots/vic20-gui-mike-unfiltered.png > /dev/null

	-$(XVIC) $(XVICOPT) -VICdsize -VICfilter 1 $(XVICGUIOPT) $(VICPRG) > /dev/null & \
	 sleep 1 && $(SHUTTER) $(SHUTTERXVIC) -o shots/vic20-gui-internal-crt-ds.png > /dev/null
	 
	-$(XVIC) $(XVICOPT) -VICdsize -VICfilter 0 $(XVICGUIOPT) $(VICPRG) > /dev/null & \
	 sleep 1 && $(SHUTTER) $(SHUTTERXVIC) -o shots/vic20-gui-internal-unfiltered-ds.png > /dev/null
	 
	-$(XVIC) $(XVICOPT) -VICdsize -VICextpal -VICpalette mike-pal -VICfilter 1 $(XVICGUIOPT) $(VICPRG) > /dev/null & \
	 sleep 1 && $(SHUTTER) $(SHUTTERXVIC) -o shots/vic20-gui-mike-crt-ds.png > /dev/null
	 
	-$(XVIC) $(XVICOPT) -VICdsize -VICextpal -VICpalette mike-pal -VICfilter 0 $(XVICGUIOPT) $(VICPRG) > /dev/null & \
	 sleep 1 && $(SHUTTER) $(SHUTTERXVIC) -o shots/vic20-gui-mike-unfiltered-ds.png > /dev/null

vic20-ntsc-gui: shots
	-$(XVIC) -ntsc -VICcrtscanlineshade 1000 -VICdsize -VICfilter 1 $(XVICGUINTSCOPT) $(VICPRG) > /dev/null & \
	 sleep 1 && $(SHUTTER) $(SHUTTERXVIC) -o shots/vic20-gui-ntsc-default-crt.png > /dev/null

	-$(XVIC) -ntsc -VICcrtscanlineshade 1000 -VICdsize -VICfilter 0 $(XVICGUINTSCOPT) $(VICPRG) > /dev/null & \
	 sleep 1 && $(SHUTTER) $(SHUTTERXVIC) -o shots/vic20-gui-ntsc-default-unfiltered.png > /dev/null

	-$(XVIC) $(XVICOPT) -ntsc +VICdsize -VICfilter 1 $(XVICGUINTSCOPT) $(VICPRG) > /dev/null & \
	 sleep 1 && $(SHUTTER) $(SHUTTERXVIC) -o shots/vic20-gui-ntsc-internal-crt.png > /dev/null
	 
	-$(XVIC) $(XVICOPT) -ntsc +VICdsize -VICfilter 0 $(XVICGUINTSCOPT) $(VICPRG) > /dev/null & \
	 sleep 1 && $(SHUTTER) $(SHUTTERXVIC) -o shots/vic20-gui-ntsc-internal-unfiltered.png > /dev/null
	 
	-$(XVIC) $(XVICOPT) -ntsc +VICdsize -VICextpal -VICpalette mike-ntsc -VICfilter 1 $(XVICGUINTSCOPT) $(VICPRG) > /dev/null & \
	 sleep 1 && $(SHUTTER) $(SHUTTERXVIC) -o shots/vic20-gui-ntsc-mike-crt.png > /dev/null
	 
	-$(XVIC) $(XVICOPT) -ntsc +VICdsize -VICextpal -VICpalette mike-ntsc -VICfilter 0 $(XVICGUINTSCOPT) $(VICPRG) > /dev/null & \
	 sleep 1 && $(SHUTTER) $(SHUTTERXVIC) -o shots/vic20-gui-ntsc-mike-unfiltered.png > /dev/null

	-$(XVIC) $(XVICOPT) -ntsc -VICdsize -VICfilter 1 $(XVICGUINTSCOPT) $(VICPRG) > /dev/null & \
	 sleep 1 && $(SHUTTER) $(SHUTTERXVIC) -o shots/vic20-gui-ntsc-internal-crt-ds.png > /dev/null
	 
	-$(XVIC) $(XVICOPT) -ntsc -VICdsize -VICfilter 0 $(XVICGUINTSCOPT) $(VICPRG) > /dev/null & \
	 sleep 1 && $(SHUTTER) $(SHUTTERXVIC) -o shots/vic20-gui-ntsc-internal-unfiltered-ds.png > /dev/null
	 
	-$(XVIC) $(XVICOPT) -ntsc -VICdsize -VICextpal -VICpalette mike-ntsc -VICfilter 1 $(XVICGUINTSCOPT) $(VICPRG) > /dev/null & \
	 sleep 1 && $(SHUTTER) $(SHUTTERXVIC) -o shots/vic20-gui-ntsc-mike-crt-ds.png > /dev/null
	 
	-$(XVIC) $(XVICOPT) -ntsc -VICdsize -VICextpal -VICpalette mike-ntsc -VICfilter 0 $(XVICGUINTSCOPT) $(VICPRG) > /dev/null & \
	 sleep 1 && $(SHUTTER) $(SHUTTERXVIC) -o shots/vic20-gui-ntsc-mike-unfiltered-ds.png > /dev/null

################################################################################
	 
plus4-pal: shots
	-$(XPLUS4) $(XPLUS4OPT) +TEDdsize -TEDfilter 1 -exitscreenshot shots/plus4-internal-crt.png $(PLUS4PRG) > /dev/null
	-$(XPLUS4) $(XPLUS4OPT) +TEDdsize -TEDfilter 0 -exitscreenshot shots/plus4-internal-unfiltered.png $(PLUS4PRG) > /dev/null

	-$(XPLUS4) $(XPLUS4OPT) +TEDdsize -TEDextpal -TEDpalette yape-pal -TEDfilter 1 -exitscreenshot shots/plus4-yape-crt.png $(PLUS4PRG) > /dev/null
	-$(XPLUS4) $(XPLUS4OPT) +TEDdsize -TEDextpal -TEDpalette yape-pal -TEDfilter 0 -exitscreenshot shots/plus4-yape-unfiltered.png $(PLUS4PRG) > /dev/null

	-$(XPLUS4) $(XPLUS4OPT) -TEDdsize -TEDfilter 1 -exitscreenshot shots/plus4-internal-crt-ds.png $(PLUS4PRG) > /dev/null
	-$(XPLUS4) $(XPLUS4OPT) -TEDdsize -TEDfilter 0 -exitscreenshot shots/plus4-internal-unfiltered-ds.png $(PLUS4PRG) > /dev/null

	-$(XPLUS4) $(XPLUS4OPT) -TEDdsize -TEDextpal -TEDpalette yape-pal -TEDfilter 1 -exitscreenshot shots/plus4-yape-crt-ds.png $(PLUS4PRG) > /dev/null
	-$(XPLUS4) $(XPLUS4OPT) -TEDdsize -TEDextpal -TEDpalette yape-pal -TEDfilter 0 -exitscreenshot shots/plus4-yape-unfiltered-ds.png $(PLUS4PRG) > /dev/null

plus4-ntsc: shots
	-$(XPLUS4) $(XPLUS4OPT) -ntsc +TEDdsize -TEDfilter 1 -exitscreenshot shots/plus4-ntsc-internal-crt.png $(PLUS4PRG) > /dev/null
	-$(XPLUS4) $(XPLUS4OPT) -ntsc +TEDdsize -TEDfilter 0 -exitscreenshot shots/plus4-ntsc-internal-unfiltered.png $(PLUS4PRG) > /dev/null

	-$(XPLUS4) $(XPLUS4OPT) -ntsc +TEDdsize -TEDextpal -TEDpalette yape-ntsc -TEDfilter 1 -exitscreenshot shots/plus4-ntsc-yape-crt.png $(PLUS4PRG) > /dev/null
	-$(XPLUS4) $(XPLUS4OPT) -ntsc +TEDdsize -TEDextpal -TEDpalette yape-ntsc -TEDfilter 0 -exitscreenshot shots/plus4-ntsc-yape-unfiltered.png $(PLUS4PRG) > /dev/null
	
	-$(XPLUS4) $(XPLUS4OPT) -ntsc -TEDdsize -TEDfilter 1 -exitscreenshot shots/plus4-ntsc-internal-crt-ds.png $(PLUS4PRG) > /dev/null
	-$(XPLUS4) $(XPLUS4OPT) -ntsc -TEDdsize -TEDfilter 0 -exitscreenshot shots/plus4-ntsc-internal-unfiltered-ds.png $(PLUS4PRG) > /dev/null

	-$(XPLUS4) $(XPLUS4OPT) -ntsc -TEDdsize -TEDextpal -TEDpalette yape-ntsc -TEDfilter 1 -exitscreenshot shots/plus4-ntsc-yape-crt-ds.png $(PLUS4PRG) > /dev/null
	-$(XPLUS4) $(XPLUS4OPT) -ntsc -TEDdsize -TEDextpal -TEDpalette yape-ntsc -TEDfilter 0 -exitscreenshot shots/plus4-ntsc-yape-unfiltered-ds.png $(PLUS4PRG) > /dev/null

plus4-pal-gui:
	-$(XPLUS4) -TEDcrtscanlineshade 1000 -TEDdsize -TEDfilter 1 $(XPLUS4GUIOPT) $(PLUS4PRG) > /dev/null & \
	 sleep 1 && $(SHUTTER) $(SHUTTERXPLUS4) -o shots/plus4-gui-default-crt.png > /dev/null

	-$(XPLUS4) -TEDcrtscanlineshade 1000 -TEDdsize -TEDfilter 0 $(XPLUS4GUIOPT) $(PLUS4PRG) > /dev/null & \
	 sleep 1 && $(SHUTTER) $(SHUTTERXPLUS4) -o shots/plus4-gui-default-unfiltered.png > /dev/null
	
plus4-ntsc-gui:
	-$(XPLUS4) -ntsc -TEDcrtscanlineshade 1000 -TEDdsize -TEDfilter 1 $(XPLUS4GUIOPT) $(PLUS4PRG) > /dev/null & \
	 sleep 1 && $(SHUTTER) $(SHUTTERXPLUS4) -o shots/plus4-gui-ntsc-default-crt.png > /dev/null

	-$(XPLUS4) -ntsc -TEDcrtscanlineshade 1000 -TEDdsize -TEDfilter 0 $(XPLUS4GUIOPT) $(PLUS4PRG) > /dev/null & \
	 sleep 1 && $(SHUTTER) $(SHUTTERXPLUS4) -o shots/plus4-gui-ntsc-default-unfiltered.png > /dev/null
	
################################################################################
	 
dtv-pal: shots
	-$(XDTV) $(XDTVOPT) +VICIIdsize -VICIIfilter 1 -exitscreenshot shots/dtv-internal-crt.png $(DTVPRG) > /dev/null
	-$(XDTV) $(XDTVOPT) +VICIIdsize -VICIIfilter 0 -exitscreenshot shots/dtv-internal-unfiltered.png $(DTVPRG) > /dev/null

	-$(XDTV) $(XDTVOPT) +VICIIdsize -VICIIextpal -VICIIpalette spiff -VICIIfilter 1 -exitscreenshot shots/dtv-spiff-crt.png $(DTVPRG) > /dev/null
	-$(XDTV) $(XDTVOPT) +VICIIdsize -VICIIextpal -VICIIpalette spiff -VICIIfilter 0 -exitscreenshot shots/dtv-spiff-unfiltered.png $(DTVPRG) > /dev/null

	-$(XDTV) $(XDTVOPT) -VICIIdsize -VICIIfilter 1 -exitscreenshot shots/dtv-internal-crt-ds.png $(DTVPRG) > /dev/null
	-$(XDTV) $(XDTVOPT) -VICIIdsize -VICIIfilter 0 -exitscreenshot shots/dtv-internal-unfiltered-ds.png $(DTVPRG) > /dev/null

	-$(XDTV) $(XDTVOPT) -VICIIdsize -VICIIextpal -VICIIpalette spiff -VICIIfilter 1 -exitscreenshot shots/dtv-spiff-crt-ds.png $(DTVPRG) > /dev/null
	-$(XDTV) $(XDTVOPT) -VICIIdsize -VICIIextpal -VICIIpalette spiff -VICIIfilter 0 -exitscreenshot shots/dtv-spiff-unfiltered-ds.png $(DTVPRG) > /dev/null
	
dtv-pal-gui: shots
	-$(XDTV) -VICIIcrtscanlineshade 1000 -VICIIdsize -VICIIfilter 1 $(XDTVGUIOPT) $(DTVPRG) > /dev/null & \
	 sleep 1 && $(SHUTTER) $(SHUTTERXDTV) -o shots/dtv-gui-default-crt.png > /dev/null
	 
	-$(XDTV) -VICIIcrtscanlineshade 1000 -VICIIdsize -VICIIfilter 0 $(XDTVGUIOPT) $(DTVPRG) > /dev/null & \
	 sleep 1 && $(SHUTTER) $(SHUTTERXDTV) -o shots/dtv-gui-default-unfiltered.png > /dev/null
	 
	-$(XDTV) $(XDTVOPT) +VICIIdsize -VICIIfilter 1 $(XDTVGUIOPT) $(DTVPRG) > /dev/null & \
	 sleep 1 && $(SHUTTER) $(SHUTTERXDTV) -o shots/dtv-gui-internal-crt.png > /dev/null
	 
	-$(XDTV) $(XDTVOPT) +VICIIdsize -VICIIfilter 0 $(XDTVGUIOPT) $(DTVPRG) > /dev/null & \
	 sleep 1 && $(SHUTTER) $(SHUTTERXDTV) -o shots/dtv-gui-internal-unfiltered.png > /dev/null
	 
	-$(XDTV) $(XDTVOPT) +VICIIdsize -VICIIextpal -VICIIpalette spiff -VICIIfilter 1 $(XDTVGUIOPT) $(DTVPRG) > /dev/null & \
	 sleep 1 && $(SHUTTER) $(SHUTTERXDTV) -o shots/dtv-gui-spiff-crt.png > /dev/null
	 
	-$(XDTV) $(XDTVOPT) +VICIIdsize -VICIIextpal -VICIIpalette spiff -VICIIfilter 0 $(XDTVGUIOPT) $(DTVPRG) > /dev/null & \
	 sleep 1 && $(SHUTTER) $(SHUTTERXDTV) -o shots/dtv-gui-spiff-unfiltered.png > /dev/null

	-$(XDTV) $(XDTVOPT) -VICIIdsize -VICIIfilter 1 $(XDTVGUIOPT) $(DTVPRG) > /dev/null & \
	 sleep 1 && $(SHUTTER) $(SHUTTERXDTV) -o shots/dtv-gui-internal-crt-ds.png > /dev/null
	 
	-$(XDTV) $(XDTVOPT) -VICIIdsize -VICIIfilter 0 $(XDTVGUIOPT) $(DTVPRG) > /dev/null & \
	 sleep 1 && $(SHUTTER) $(SHUTTERXDTV) -o shots/dtv-gui-internal-unfiltered-ds.png > /dev/null
	 
	-$(XDTV) $(XDTVOPT) -VICIIdsize -VICIIextpal -VICIIpalette spiff -VICIIfilter 1 $(XDTVGUIOPT) $(DTVPRG) > /dev/null & \
	 sleep 1 && $(SHUTTER) $(SHUTTERXDTV) -o shots/dtv-gui-spiff-crt-ds.png > /dev/null
	 
	-$(XDTV) $(XDTVOPT) -VICIIdsize -VICIIextpal -VICIIpalette spiff -VICIIfilter 0 $(XDTVGUIOPT) $(DTVPRG) > /dev/null & \
	 sleep 1 && $(SHUTTER) $(SHUTTERXDTV) -o shots/dtv-gui-spiff-unfiltered-ds.png > /dev/null

################################################################################
	 
c128-rgb: shots
	-$(X128) $(X128OPT) +VDCdsize -VDCfilter 1 -exitscreenshot shots/c128-internal-crt.png $(C128PRG) > /dev/null
	-$(X128) $(X128OPT) +VDCdsize -VDCfilter 0 -exitscreenshot shots/c128-internal-unfiltered.png $(C128PRG) > /dev/null

	-$(X128) $(X128OPT) +VDCdsize -VDCextpal -VDCpalette vdc_deft -VDCfilter 1 -exitscreenshot shots/c128-vice-crt.png $(C128PRG) > /dev/null
	-$(X128) $(X128OPT) +VDCdsize -VDCextpal -VDCpalette vdc_deft -VDCfilter 0 -exitscreenshot shots/c128-vice-unfiltered.png $(C128PRG) > /dev/null

	-$(X128) $(X128OPT) -VDCdsize -VDCfilter 1 -exitscreenshot shots/c128-internal-crt-ds.png $(C128PRG) > /dev/null
	-$(X128) $(X128OPT) -VDCdsize -VDCfilter 0 -exitscreenshot shots/c128-internal-unfiltered-ds.png $(C128PRG) > /dev/null

	-$(X128) $(X128OPT) -VDCdsize -VDCextpal -VDCpalette vdc_deft -VDCfilter 1 -exitscreenshot shots/c128-vice-crt-ds.png $(C128PRG) > /dev/null
	-$(X128) $(X128OPT) -VDCdsize -VDCextpal -VDCpalette vdc_deft -VDCfilter 0 -exitscreenshot shots/c128-vice-unfiltered-ds.png $(C128PRG) > /dev/null
	 
c128-rgb-gui: shots
	-$(X128) +VDCdsize -VDCfilter 1 $(X128GUIOPT) $(C128PRG) > /dev/null & \
	 sleep 2 && $(SHUTTER) $(SHUTTERX128) -o shots/c128-gui-default-crt.png > /dev/null

	 -$(X128) +VDCdsize -VDCfilter 0 $(X128GUIOPT) $(C128PRG) > /dev/null & \
	 sleep 2 && $(SHUTTER) $(SHUTTERX128) -o shots/c128-gui-default-unfiltered.png > /dev/null
	 
	-$(X128) $(X128OPT) +VDCdsize -VDCfilter 1 $(X128GUIOPT) $(C128PRG) > /dev/null & \
	 sleep 2 && $(SHUTTER) $(SHUTTERX128) -o shots/c128-gui-internal-crt.png > /dev/null

	 -$(X128) $(X128OPT) +VDCdsize -VDCfilter 0 $(X128GUIOPT) $(C128PRG) > /dev/null & \
	 sleep 2 && $(SHUTTER) $(SHUTTERX128) -o shots/c128-gui-internal-unfiltered.png > /dev/null
	 
	-$(X128) $(X128OPT) +VDCdsize -VDCextpal -VDCpalette vdc_deft -VDCfilter 1 $(X128GUIOPT) $(C128PRG) > /dev/null & \
	 sleep 2 && $(SHUTTER) $(SHUTTERX128) -o shots/c128-gui-vice-crt.png > /dev/null
	 
	-$(X128) $(X128OPT) +VDCdsize -VDCextpal -VDCpalette vdc_deft -VDCfilter 0 $(X128GUIOPT) $(C128PRG) > /dev/null & \
	 sleep 2 && $(SHUTTER) $(SHUTTERX128) -o shots/c128-gui-vice-unfiltered.png > /dev/null

	-$(X128) $(X128OPT) -VDCdsize -VDCfilter 1 $(X128GUIOPT) $(C128PRG) > /dev/null & \
	 sleep 2 && $(SHUTTER) $(SHUTTERX128) -o shots/c128-gui-internal-crt-ds.png > /dev/null
	 
	-$(X128) $(X128OPT) -VDCdsize -VDCfilter 0 $(X128GUIOPT) $(C128PRG) > /dev/null & \
	 sleep 2 && $(SHUTTER) $(SHUTTERX128) -o shots/c128-gui-internal-unfiltered-ds.png > /dev/null
	 
	-$(X128) $(X128OPT) -VDCdsize -VDCextpal -VDCpalette vdc_deft -VDCfilter 1 $(X128GUIOPT) $(C128PRG) > /dev/null & \
	 sleep 2 && $(SHUTTER) $(SHUTTERX128) -o shots/c128-gui-vice-crt-ds.png > /dev/null
	 
	-$(X128) $(X128OPT) -VDCdsize -VDCextpal -VDCpalette vdc_deft -VDCfilter 0 $(X128GUIOPT) $(C128PRG) > /dev/null & \
	 sleep 2 && $(SHUTTER) $(SHUTTERX128) -o shots/c128-gui-vice-unfiltered-ds.png > /dev/null
	 
################################################################################
	 
pet-mono: shots
	-$(XPET) $(XPETOPT) +CRTCdsize -CRTCfilter 1 -exitscreenshot shots/pet-internal-crt.png $(PETPRG) > /dev/null
	-$(XPET) $(XPETOPT) +CRTCdsize -CRTCfilter 0 -exitscreenshot shots/pet-internal-unfiltered.png $(PETPRG) > /dev/null

	-$(XPET) $(XPETOPT) +CRTCdsize -CRTCextpal -CRTCpalette green -CRTCfilter 1 -exitscreenshot shots/pet-green-crt.png $(PETPRG) > /dev/null
	-$(XPET) $(XPETOPT) +CRTCdsize -CRTCextpal -CRTCpalette green -CRTCfilter 0 -exitscreenshot shots/pet-green-unfiltered.png $(PETPRG) > /dev/null

	-$(XPET) $(XPETOPT) -CRTCdsize -CRTCfilter 1 -exitscreenshot shots/pet-internal-crt-ds.png $(PETPRG) > /dev/null
	-$(XPET) $(XPETOPT) -CRTCdsize -CRTCfilter 0 -exitscreenshot shots/pet-internal-unfiltered-ds.png $(PETPRG) > /dev/null

	-$(XPET) $(XPETOPT) -CRTCdsize -CRTCextpal -CRTCpalette green -CRTCfilter 1 -exitscreenshot shots/pet-green-crt-ds.png $(PETPRG) > /dev/null
	-$(XPET) $(XPETOPT) -CRTCdsize -CRTCextpal -CRTCpalette green -CRTCfilter 0 -exitscreenshot shots/pet-green-unfiltered-ds.png $(PETPRG) > /dev/null

pet-mono-gui: shots
	-$(XPET) +CRTCdsize -CRTCfilter 1 $(XPETGUIOPT) $(PETPRG) > /dev/null & \
	 sleep 2 && $(SHUTTER) $(SHUTTERXPET) -o shots/pet-gui-default-crt.png > /dev/null

	 -$(XPET) +CRTCdsize -CRTCfilter 0 $(XPETGUIOPT) $(PETPRG) > /dev/null & \
	 sleep 2 && $(SHUTTER) $(SHUTTERXPET) -o shots/pet-gui-default-unfiltered.png > /dev/null
	 
	-$(XPET) $(XPETOPT) +CRTCdsize -CRTCfilter 1 $(XPETGUIOPT) $(PETPRG) > /dev/null & \
	 sleep 2 && $(SHUTTER) $(SHUTTERXPET) -o shots/pet-gui-internal-crt.png > /dev/null

	 -$(XPET) $(XPETOPT) +CRTCdsize -CRTCfilter 0 $(XPETGUIOPT) $(PETPRG) > /dev/null & \
	 sleep 2 && $(SHUTTER) $(SHUTTERXPET) -o shots/pet-gui-internal-unfiltered.png > /dev/null
	 
	-$(XPET) $(XPETOPT) +CRTCdsize -CRTCextpal -CRTCpalette green -CRTCfilter 1 $(XPETGUIOPT) $(PETPRG) > /dev/null & \
	 sleep 2 && $(SHUTTER) $(SHUTTERXPET) -o shots/pet-gui-green-crt.png > /dev/null
	 
	-$(XPET) $(XPETOPT) +CRTCdsize -CRTCextpal -CRTCpalette green -CRTCfilter 0 $(XPETGUIOPT) $(PETPRG) > /dev/null & \
	 sleep 2 && $(SHUTTER) $(SHUTTERXPET) -o shots/pet-gui-green-unfiltered.png > /dev/null

	-$(XPET) $(XPETOPT) -CRTCdsize -CRTCfilter 1 $(XPETGUIOPT) $(PETPRG) > /dev/null & \
	 sleep 2 && $(SHUTTER) $(SHUTTERXPET) -o shots/pet-gui-internal-crt-ds.png > /dev/null
	 
	-$(XPET) $(XPETOPT) -CRTCdsize -CRTCfilter 0 $(XPETGUIOPT) $(PETPRG) > /dev/null & \
	 sleep 2 && $(SHUTTER) $(SHUTTERXPET) -o shots/pet-gui-internal-unfiltered-ds.png > /dev/null
	 
	-$(XPET) $(XPETOPT) -CRTCdsize -CRTCextpal -CRTCpalette green -CRTCfilter 1 $(XPETGUIOPT) $(PETPRG) > /dev/null & \
	 sleep 2 && $(SHUTTER) $(SHUTTERXPET) -o shots/pet-gui-green-crt-ds.png > /dev/null
	 
	-$(XPET) $(XPETOPT) -CRTCdsize -CRTCextpal -CRTCpalette green -CRTCfilter 0 $(XPETGUIOPT) $(PETPRG) > /dev/null & \
	 sleep 2 && $(SHUTTER) $(SHUTTERXPET) -o shots/pet-gui-green-unfiltered-ds.png > /dev/null
	
################################################################################
	
clean:
	rm -f shots/*.png
