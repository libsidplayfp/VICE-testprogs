/*
 * op.h
 */

#define OP_CLC (0x18)
#define OP_CLD (0xd8)
#define OP_SEC (0x38)
#define OP_SED (0xf8)

#define OP_CLI (0x58)
#define OP_SEI (0x78)
#define OP_XCE (0xfb)
#define OP_REP (0xc2)
#define OP_SEP (0xe2)

#define OP_NOP (0xea)

#define OP_DEA (0x3a)
#define OP_DEX (0xca)
#define OP_DEY (0x88)
#define OP_INA (0x1a)
#define OP_INX (0xe8)
#define OP_INY (0xc8)

#define OP_DEC_dp (0xc6)
#define OP_INC_dp (0xe6)

#define OP_ADC_dp (0x65)
#define OP_AND_dp (0x25)
#define OP_CMP_dp (0xc5)
#define OP_CPX_dp (0xe4)
#define OP_CPY_dp (0xc4)
#define OP_EOR_dp (0x45)
#define OP_LDA_dp (0xa5)
#define OP_LDX_dp (0xa6)
#define OP_LDY_dp (0xa4)
#define OP_ORA_dp (0x05)
#define OP_SBC_dp (0xe5)
#define OP_STA_dp (0x85)
#define OP_STX_dp (0x86)
#define OP_STY_dp (0x84)
#define OP_STZ_dp (0x64)

#define OP_ADC_dp_x (0x75)
#define OP_AND_dp_x (0x35)
#define OP_CMP_dp_x (0xd5)
#define OP_EOR_dp_x (0x55)
#define OP_LDA_dp_x (0xb5)
#define OP_ORA_dp_x (0x15)
#define OP_SBC_dp_x (0xf5)
#define OP_STA_dp_x (0x95)
#define OP_STZ_dp_x (0x74)

#define OP_ADC_imm (0x69)
#define OP_AND_imm (0x29)
#define OP_CMP_imm (0xc9)
#define OP_CPX_imm (0xe0)
#define OP_CPY_imm (0xc0)
#define OP_EOR_imm (0x49)
#define OP_LDA_imm (0xa9)
#define OP_LDX_imm (0xa2)
#define OP_LDY_imm (0xa0)
#define OP_ORA_imm (0x09)
#define OP_SBC_imm (0xe9)

#define OP_ADC_long (0x6f)
#define OP_AND_long (0x2f)
#define OP_CMP_long (0xcf)
#define OP_EOR_long (0x4f)
#define OP_LDA_long (0xaf)
#define OP_ORA_long (0x0f)
#define OP_SBC_long (0xef)
#define OP_STA_long (0x8f)

#define OP_ADC_abs (0x6d)
#define OP_AND_abs (0x2d)
#define OP_CMP_abs (0xcd)
#define OP_EOR_abs (0x4d)
#define OP_LDA_abs (0xad)
#define OP_LDX_abs (0xae)
#define OP_LDY_abs (0xac)
#define OP_ORA_abs (0x0d)
#define OP_SBC_abs (0xed)
#define OP_STA_abs (0x8d)
#define OP_STX_abs (0x8e)
#define OP_STY_abs (0x8c)
#define OP_STZ_abs (0x9c)

#define OP_ADC_long_x (0x7f)
#define OP_AND_long_x (0x3f)
#define OP_CMP_long_x (0xdf)
#define OP_EOR_long_x (0x5f)
#define OP_LDA_long_x (0xbf)
#define OP_ORA_long_x (0x1f)
#define OP_SBC_long_x (0xff)
#define OP_STA_long_x (0x9f)

#define OP_ASL_a (0x0a)
#define OP_LSR_a (0x4a)
#define OP_ROL_a (0x2a)
#define OP_ROR_a (0x6a)

#define OP_ASL_dp (0x06)
#define OP_LSR_dp (0x46)
#define OP_ROL_dp (0x26)
#define OP_ROR_dp (0x66)

#define OP_LDA_ind_long (0xa7)
#define OP_LDA_ind_long_y (0xb7)
#define OP_STA_ind_long (0x87)
#define OP_STA_ind_long_y (0x97)

#define OP_BEQ_imm (0xf0)
#define OP_BNE_imm (0xd0)

#define OP_BCC_imm (0x90)
#define OP_BCS_imm (0xb0)
#define OP_BMI_imm (0x30)
#define OP_BPL_imm (0x10)
#define OP_BVC_imm (0x50)
#define OP_BVS_imm (0x70)
#define OP_BRA_imm (0x80)

#define OP_JMP_addr (0x4c)
#define OP_JMP_long (0x5c)
#define OP_JMP_ind_long (0xdc)

#define OP_TAX (0xaa)
#define OP_TAY (0xa8)
#define OP_TXA (0x8a)
#define OP_TYA (0x98)
#define OP_TXY (0x9b)
#define OP_TYX (0xbb)
#define OP_XBA (0xeb)

#define OP_WDM (0x42)

#define OP_PEA_imm (0xf4)

#define OP_PHA (0x48)
#define OP_PHB (0x8b)
#define OP_PHD (0x0b)
#define OP_PHK (0x4b)
#define OP_PHP (0x08)
#define OP_PHX (0xda)
#define OP_PHY (0x5a)

#define OP_PLA (0x68)
#define OP_PLB (0xab)
#define OP_PLD (0x2b)
#define OP_PLP (0x28)
#define OP_PLX (0xfa)
#define OP_PLY (0x7a)

#define OP_JMP_ind_long (0xdc)

#define OP_BLT_imm BCC_imm
#define OP_BGE_imm BCS_imm

#define	OP_AS *dst++ = SEP; *dst++ = 0x20
#define	OP_AL *dst++ = REP; *dst++ = 0x20
#define	OP_XS *dst++ = SEP; *dst++ = 0x10
#define	OP_XL *dst++ = REP; *dst++ = 0x10
#define	OP_AS *dst++ = SEP; *dst++ = 0x20
#define	OP_AXS *dst++ = SEP; *dst++ = 0x30
#define	OP_AXL *dst++ = REP; *dst++ = 0x30
