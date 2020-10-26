; io.asm include file by Walt of Bonzai - Version 1.0
; adapted for VICE testbench by gpz

VIC_Sprite0_X			= $d000
VIC_Sprite0_Y			= $d001
VIC_Sprite1_X			= $d002
VIC_Sprite1_Y			= $d003
VIC_Sprite2_X			= $d004
VIC_Sprite2_Y			= $d005
VIC_Sprite3_X			= $d006
VIC_Sprite3_Y			= $d007
VIC_Sprite4_X			= $d008
VIC_Sprite4_Y			= $d009
VIC_Sprite5_X			= $d00a
VIC_Sprite5_Y			= $d00b
VIC_Sprite6_X			= $d00c
VIC_Sprite6_Y			= $d00d
VIC_Sprite7_X			= $d00e
VIC_Sprite7_Y			= $d00f
VIC_Sprite_XMSB		= $d010
VIC_Screen_YPos		= $d011
VIC_Raster_Position	= $d012
VIC_LightPenXPos		= $d013
VIC_LightPenYPos		= $d014
VIC_Sprite_Enable		= $d015
VIC_Screen_XPos		= $d016
VIC_Sprite_Expand_Y	= $d017
VIC_ScreenMemory		= $d018
VIC_Interrupt			= $d019
VIC_Interrupt_Control	= $d01a
VIC_Sprite_Priority	= $d01b
VIC_Sprite_Multicolor	= $d01c
VIC_Sprite_Expand_X	= $d01d
VIC_Sprite_Sprite_Coll	= $d01e
VIC_Sprite_Back_Coll	= $d01f
VIC_BorderColor		= $d020
VIC_ScreenColor		= $d021
VIC_ScreenMC1			= $d022
VIC_ScreenMC2			= $d023
VIC_ScreenMC3			= $d024
VIC_Sprite_MC1			= $d025
VIC_Sprite_MC2			= $d026
VIC_Sprite0_Color		= $d027
VIC_Sprite1_Color		= $d028
VIC_Sprite2_Color		= $d029
VIC_Sprite3_Color		= $d02a
VIC_Sprite4_Color		= $d02b
VIC_Sprite5_Color		= $d02c
VIC_Sprite6_Color		= $d02d
VIC_Sprite7_Color		= $d02e

ColorRAM				= $d800

BankSelect				= $dd00
