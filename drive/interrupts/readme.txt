
in this directory we collect some tests related to interrupts on the drive(s)

using interrupts is somewhat awkward, since we can not manipulate the hardware
vectors, and there is only a software vector provided by jobcode $e0.

timera.asm:
- hooks a timer interrupt (VIA2 timer A) and reads from another timer (VIA1
  timer A) which creates a typical pattern.

watchdog.asm
- a timer interrupt is reset by the c64 periodically polling the drive, so it
  never occurs. this is mostly a test for "freezers", run the test, then freeze
  and restart - the drive will time out and the c64 side will hang.

;-------------------------------------------------------------------------------

CAUTION: when writing IRQ routines for the 1541, keep in mind the system handler
         will already do some things:

         - for VIA1, only CA1 interrupts are handled

         - for VIA2, all types of interrupts can be handled
         - the system handler will read timer a lo, which results in clearing
           the related interrupt flag
         - the system handler will configure CB2 for high output
  
for quick reference (part of) the ROM interrupt handler is shown below:

;-------------------------------------------------------------------------------
; $FE67/65127:   Interrupt routine

FE67: 48        PHA
FE68: 8A        TXA
FE69: 48        PHA             ; save registers
FE6A: 98        TYA
FE6B: 48        PHA

FE6C: AD 0D 18  LDA $180D       ; interrupt from VIA2? (CA1: serial bus)
FE6F: 29 02     AND #$02
FE71: F0 03     BEQ $FE76       ; no
FE73: 20 53 E8  JSR $E853       ; serve serial bus

FE76: AD 0D 1C  LDA $1C0D       ; interrupt from VIA1? (Timer)
FE79: 0A        ASL
FE7A: 10 03     BPL $FE7F       ; no
FE7C: 20 B0 F2  JSR $F2B0       ; IRQ routine for disk controller           <=-

FE7F: 68        PLA
FE80: A8        TAY
FE81: 68        PLA             ; get registers back
FE82: AA        TAX
FE83: 68        PLA
FE84: 40        RTI 

;-------------------------------------------------------------------------------
; $F2B0/62128:   IRQ routine for disk controller

F2B0: BA        TSX
F2B1: 86 49     STX $49         ; save stack pointer
F2B3: AD 04 1C  LDA $1C04       ; erase interrupt flag from timer
F2B6: AD 0C 1C  LDA $1C0C       ; CB2 Output = Hi, IRQ on negative edge
F2B9: 09 0E     ORA #$0E
F2BB: 8D 0C 1C  STA $1C0C

Jump from $F97B:

F2BE: A0 05     LDY #$05

F2C0: B9 00 00  LDA $00,Y       ; command for buffer Y?
F2C3: 10 2E     BPL $F2F3       ; no
F2C5: C9 D0     CMP #$D0        ; execute code for program in buffer
F2C7: D0 04     BNE $F2CD       ; no
F2C9: 98        TYA
F2CA: 4C 70 F3  JMP $F370       ; execute program in buffer                 <=-

F2CD: 29 01     AND #$01        ; isolate drive number
F2CF: F0 07     BEQ $F2D8       ; drive zero?
F2D1: 84 3F     STY $3F
F2D3: A9 0F     LDA #$0F        ; else
F2D5: 4C 69 F9  JMP $F969       ; 74, 'drive not ready'

F2D8: AA        TAX
F2D9: 85 3D     STA $3D
F2DB: C5 3E     CMP $3E         ; motor running?
F2DD: F0 0A     BEQ $F2E9       ; yes
F2DF: 20 7E F9  JSR $F97E       ; turn drive motor on
F2E2: A5 3D     LDA $3D
F2E4: 85 3E     STA $3E         ; set flag
F2E6: 4C 9C F9  JMP $F99C       ; to job loop

F2E9: A5 20     LDA $20
F2EB: 30 03     BMI $F2F0       ; head transport programmed?
F2ED: 0A        ASL
F2EE: 10 09     BPL $F2F9

F2F0: 4C 9C F9  JMP $F99C       ; to job loop

F2F3: 88        DEY
F2F4: 10 CA     BPL $F2C0       ; check next buffer
F2F6: 4C 9C F9  JMP $F99C       ; to job loop

;-------------------------------------------------------------------------------
; $F36E/62318:   Execute program in buffer

Jump from $F369:

F36E: A5 3F     LDA $3F         ; buffer number

Jump from $F2CA:

F370: 18        CLC
F371: 69 03     ADC #$03        ; plus 3
F373: 85 31     STA $31
F375: A9 00     LDA #$00        ; equals address of buffer
F377: 85 30     STA $30
F379: 6C 30 00  JMP ($0030)     ; execute program in buffer                 <=-
