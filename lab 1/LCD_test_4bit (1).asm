; LCD_test_4bit.asm: Initializes and uses an LCD in 4-bit mode
; using the most common procedure found on the internet and datasheets.
$NOLIST
$MODN76E003
$LIST

org 0000H
    ljmp myprogram

;  N76E003 pinout:
;                               -------
;       PWM2/IC6/T0/AIN4/P0.5 -|1    20|- P0.4/AIN5/STADC/PWM3/IC3
;               TXD/AIN3/P0.6 -|2    19|- P0.3/PWM5/IC5/AIN6
;               RXD/AIN2/P0.7 -|3    18|- P0.2/ICPCK/OCDCK/RXD_1/[SCL]
;                    RST/P2.0 -|4    17|- P0.1/PWM4/IC4/MISO
;        INT0/OSCIN/AIN1/P3.0 -|5    16|- P0.0/PWM3/IC3/MOSI/T1
;              INT1/AIN0/P1.7 -|6    15|- P1.0/PWM2/IC2/SPCLK
;                         GND -|7    14|- P1.1/PWM1/IC1/AIN7/CLO
;[SDA]/TXD_1/ICPDA/OCDDA/P1.6 -|8    13|- P1.2/PWM0/IC0
;                         VDD -|9    12|- P1.3/SCL/[STADC]
;            PWM5/IC7/SS/P1.5 -|10   11|- P1.4/SDA/FB/PWM1
;                               -------
;

; These 'equ' must match the hardware wiring
LCD_RS equ P1.3
;LCD_RW equ PX.X ; Not used in this code, connect the pin to GND
LCD_E  equ P1.4
LCD_D4 equ P0.0
LCD_D5 equ P0.1
LCD_D6 equ P0.2
LCD_D7 equ P0.3

; When using a 16.6MHz oscillator in the N76E003
; one cycle takes 1.0/16.6MHz = 60.24 ns

;---------------------------------;
; Wait 40 microseconds            ;
;---------------------------------;
Wait40uSec:
    push AR0
    mov R0, #133
L0:
    nop
    djnz R0, L0 ; 1+4 cycles->5*60.24ns*133=40us
    pop AR0
    ret

;---------------------------------;
; Wait 'R2' milliseconds          ;
;---------------------------------;
WaitmilliSec:
    push AR0
    push AR1
L3: mov R1, #40
L2: mov R0, #104
L1: djnz R0, L1 ; 4 cycles->4*60.24ns*104=25.0us
    djnz R1, L2 ; 25us*40=1.0ms
    djnz R2, L3 ; number of millisecons to wait passed in R2
    pop AR1
    pop AR0
    ret

;---------------------------------;
; Toggles the LCD's 'E' pin       ;
;---------------------------------;
LCD_pulse:
    setb LCD_E
    lcall Wait40uSec
    clr LCD_E
    ret

;---------------------------------;
; Writes data to LCD              ;
;---------------------------------;
WriteData:
    setb LCD_RS
    ljmp LCD_byte

;---------------------------------;
; Writes command to LCD           ;
;---------------------------------;
WriteCommand:
    clr LCD_RS
    ljmp LCD_byte

;---------------------------------;
; Writes acc to LCD in 4-bit mode ;
;---------------------------------;
LCD_byte:
    ; Write high 4 bits first
    mov c, ACC.7
    mov LCD_D7, c
    mov c, ACC.6
    mov LCD_D6, c
    mov c, ACC.5
    mov LCD_D5, c
    mov c, ACC.4
    mov LCD_D4, c
    lcall LCD_pulse

    ; Write low 4 bits next
    mov c, ACC.3
    mov LCD_D7, c
    mov c, ACC.2
    mov LCD_D6, c
    mov c, ACC.1
    mov LCD_D5, c
    mov c, ACC.0
    mov LCD_D4, c
    lcall LCD_pulse
    ret

;---------------------------------;
; Configure LCD in 4-bit mode     ;
;---------------------------------;
LCD_4BIT:
    ret

;---------------------------------;
; Main loop.  Initialize stack,   ;
; ports, LCD, and displays        ;
; letters on the LCD              ;
;---------------------------------;
myprogram:
    mov SP, #7FH
    ; Configure the pins as bi-directional so we can use them as input/output
    mov P0M1, #0x00
    mov P0M2, #0x00
    mov P1M1, #0x00
    mov P1M2, #0x00
    mov P3M2, #0x00
    mov P3M2, #0x00
    
    lcall LCD_4BIT
    
    ;-----------I--------;
    
    mov a, #0x80 ; Move cursor to line 1 column 1
    lcall WriteCommand
    mov a, #'I'
    lcall WriteData
    lcall Waitmillisec
    
    mov a, #0x80 ; Move cursor to line 1 column 1
    lcall WriteCommand
    mov a, #' '
    lcall WriteData
    mov a, #0x81 ; Move cursor to line 1 column 1
    lcall WriteCommand
    mov a, #'I'
    lcall WriteData
    lcall Waitmillisec
    
    mov a, #0x81 ; Move cursor to line 1 column 1
    lcall WriteCommand
    mov a, #' '
    lcall WriteData
    mov a, #0x82 ; Move cursor to line 1 column 1
    lcall WriteCommand
    mov a, #'I'
    lcall WriteData
    lcall Waitmillisec
    
    mov a, #0x82 ; Move cursor to line 1 column 1
    lcall WriteCommand
    mov a, #' '
    lcall WriteData
    mov a, #0x83 ; Move cursor to line 1 column 1
    lcall WriteCommand
    mov a, #'I'
    lcall WriteData
    lcall Waitmillisec
    
    mov a, #0x83 ; Move cursor to line 1 column 1
    lcall WriteCommand
    mov a, #' '
    lcall WriteData
    mov a, #0x84 ; Move cursor to line 1 column 1
    lcall WriteCommand
    mov a, #'I'
    lcall WriteData
    lcall Waitmillisec
    
    mov a, #0x84 ; Move cursor to line 1 column 1
    lcall WriteCommand
    mov a, #' '
    lcall WriteData
    mov a, #0x85 ; Move cursor to line 1 column 1
    lcall WriteCommand
    mov a, #'I'
    lcall WriteData
    lcall Waitmillisec
    
    mov a, #0x85 ; Move cursor to line 1 column 1
    lcall WriteCommand
    mov a, #' '
    lcall WriteData
    mov a, #0x86 ; Move cursor to line 1 column 1
    lcall WriteCommand
    mov a, #'I'
    lcall WriteData
    lcall Waitmillisec
    
    mov a, #0x86 ; Move cursor to line 1 column 1
    lcall WriteCommand
    mov a, #' '
    lcall WriteData
    mov a, #0x87 ; Move cursor to line 1 column 1
    lcall WriteCommand
    mov a, #'I'
    lcall WriteData
    lcall Waitmillisec
    
    mov a, #0x87 ; Move cursor to line 1 column 1
    lcall WriteCommand
    mov a, #' '
    lcall WriteData
    mov a, #0x88 ; Move cursor to line 1 column 1
    lcall WriteCommand
    mov a, #'I'
    lcall WriteData
    lcall Waitmillisec
    
    ;-----------U--------;
    
    mov a, #0x80 ; Move cursor to line 1 column 1
    lcall WriteCommand
    mov a, #'U'
    lcall WriteData
    lcall Waitmillisec
    
    mov a, #0x80 ; Move cursor to line 1 column 1
    lcall WriteCommand
    mov a, #' '
    lcall WriteData
    mov a, #0x81 ; Move cursor to line 1 column 1
    lcall WriteCommand
    mov a, #'U'
    lcall WriteData
    lcall Waitmillisec
    
    mov a, #0x81 ; Move cursor to line 1 column 1
    lcall WriteCommand
    mov a, #' '
    lcall WriteData
    mov a, #0x82 ; Move cursor to line 1 column 1
    lcall WriteCommand
    mov a, #'U'
    lcall WriteData
    lcall Waitmillisec
    
    mov a, #0x82 ; Move cursor to line 1 column 1
    lcall WriteCommand
    mov a, #' '
    lcall WriteData
    mov a, #0x83 ; Move cursor to line 1 column 1
    lcall WriteCommand
    mov a, #'U'
    lcall WriteData
    lcall Waitmillisec
    
    mov a, #0x83 ; Move cursor to line 1 column 1
    lcall WriteCommand
    mov a, #' '
    lcall WriteData
    mov a, #0x84 ; Move cursor to line 1 column 1
    lcall WriteCommand
    mov a, #'U'
    lcall WriteData
    lcall Waitmillisec
    
    mov a, #0x84 ; Move cursor to line 1 column 1
    lcall WriteCommand
    mov a, #' '
    lcall WriteData
    mov a, #0x85 ; Move cursor to line 1 column 1
    lcall WriteCommand
    mov a, #'U'
    lcall WriteData
    lcall Waitmillisec
    
    mov a, #0x85 ; Move cursor to line 1 column 1
    lcall WriteCommand
    mov a, #' '
    lcall WriteData
    mov a, #0x86 ; Move cursor to line 1 column 1
    lcall WriteCommand
    mov a, #'U'
    lcall WriteData
    lcall Waitmillisec
    
    mov a, #0x86 ; Move cursor to line 1 column 1
    lcall WriteCommand
    mov a, #' '
    lcall WriteData
    mov a, #0x87 ; Move cursor to line 1 column 1
    lcall WriteCommand
    mov a, #'U'
    lcall WriteData
    lcall Waitmillisec
    
    ;-----------H--------;
    
    mov a, #0x80 ; Move cursor to line 1 column 1
    lcall WriteCommand
    mov a, #'H'
    lcall WriteData
    lcall Waitmillisec
    
    mov a, #0x80 ; Move cursor to line 1 column 1
    lcall WriteCommand
    mov a, #' '
    lcall WriteData
    mov a, #0x81 ; Move cursor to line 1 column 1
    lcall WriteCommand
    mov a, #'H'
    lcall WriteData
    lcall Waitmillisec
    
    mov a, #0x81 ; Move cursor to line 1 column 1
    lcall WriteCommand
    mov a, #' '
    lcall WriteData
    mov a, #0x82 ; Move cursor to line 1 column 1
    lcall WriteCommand
    mov a, #'H'
    lcall WriteData
    lcall Waitmillisec
    
    mov a, #0x82 ; Move cursor to line 1 column 1
    lcall WriteCommand
    mov a, #' '
    lcall WriteData
    mov a, #0x83 ; Move cursor to line 1 column 1
    lcall WriteCommand
    mov a, #'H'
    lcall WriteData
    lcall Waitmillisec
    
    mov a, #0x83 ; Move cursor to line 1 column 1
    lcall WriteCommand
    mov a, #' '
    lcall WriteData
    mov a, #0x84 ; Move cursor to line 1 column 1
    lcall WriteCommand
    mov a, #'H'
    lcall WriteData
    lcall Waitmillisec
    
    mov a, #0x84 ; Move cursor to line 1 column 1
    lcall WriteCommand
    mov a, #' '
    lcall WriteData
    mov a, #0x85 ; Move cursor to line 1 column 1
    lcall WriteCommand
    mov a, #'H'
    lcall WriteData
    lcall Waitmillisec
    
    mov a, #0x85 ; Move cursor to line 1 column 1
    lcall WriteCommand
    mov a, #' '
    lcall WriteData
    mov a, #0x86 ; Move cursor to line 1 column 1
    lcall WriteCommand
    mov a, #'H'
    lcall WriteData
    lcall Waitmillisec
    
    ;-----------Y--------;
    
    mov a, #0x80 ; Move cursor to line 1 column 1
    lcall WriteCommand
    mov a, #'Y'
    lcall WriteData
    lcall Waitmillisec
    
    mov a, #0x80 ; Move cursor to line 1 column 1
    lcall WriteCommand
    mov a, #' '
    lcall WriteData
    mov a, #0x81 ; Move cursor to line 1 column 1
    lcall WriteCommand
    mov a, #'Y'
    lcall WriteData
    lcall Waitmillisec
    
    mov a, #0x81 ; Move cursor to line 1 column 1
    lcall WriteCommand
    mov a, #' '
    lcall WriteData
    mov a, #0x82 ; Move cursor to line 1 column 1
    lcall WriteCommand
    mov a, #'Y'
    lcall WriteData
    lcall Waitmillisec
    
    mov a, #0x82 ; Move cursor to line 1 column 1
    lcall WriteCommand
    mov a, #' '
    lcall WriteData
    mov a, #0x83 ; Move cursor to line 1 column 1
    lcall WriteCommand
    mov a, #'Y'
    lcall WriteData
    lcall Waitmillisec
    
    mov a, #0x83 ; Move cursor to line 1 column 1
    lcall WriteCommand
    mov a, #' '
    lcall WriteData
    mov a, #0x84 ; Move cursor to line 1 column 1
    lcall WriteCommand
    mov a, #'Y'
    lcall WriteData
    lcall Waitmillisec
    
    ;-----------N--------;
    
    mov a, #0x80 ; Move cursor to line 1 column 1
    lcall WriteCommand
    mov a, #'N'
    lcall WriteData
    lcall Waitmillisec
    
    mov a, #0x80 ; Move cursor to line 1 column 1
    lcall WriteCommand
    mov a, #' '
    lcall WriteData
    mov a, #0x81 ; Move cursor to line 1 column 1
    lcall WriteCommand
    mov a, #'N'
    lcall WriteData
    lcall Waitmillisec
    
    mov a, #0x81 ; Move cursor to line 1 column 1
    lcall WriteCommand
    mov a, #' '
    lcall WriteData
    mov a, #0x82 ; Move cursor to line 1 column 1
    lcall WriteCommand
    mov a, #'N'
    lcall WriteData
    lcall Waitmillisec
    
    mov a, #0x82 ; Move cursor to line 1 column 1
    lcall WriteCommand
    mov a, #' '
    lcall WriteData
    mov a, #0x83 ; Move cursor to line 1 column 1
    lcall WriteCommand
    mov a, #'N'
    lcall WriteData
    lcall Waitmillisec
    
    ;-----------N--------;
    
    mov a, #0x80 ; Move cursor to line 1 column 1
    lcall WriteCommand
    mov a, #'N'
    lcall WriteData
    lcall Waitmillisec
    
    mov a, #0x80 ; Move cursor to line 1 column 1
    lcall WriteCommand
    mov a, #' '
    lcall WriteData
    mov a, #0x81 ; Move cursor to line 1 column 1
    lcall WriteCommand
    mov a, #'N'
    lcall WriteData
    lcall Waitmillisec
    
    mov a, #0x81 ; Move cursor to line 1 column 1
    lcall WriteCommand
    mov a, #' '
    lcall WriteData
    mov a, #0x82 ; Move cursor to line 1 column 1
    lcall WriteCommand
    mov a, #'N'
    lcall WriteData
    lcall Waitmillisec
    
    ;-----------E--------;
    
    mov a, #0x80 ; Move cursor to line 1 column 1
    lcall WriteCommand
    mov a, #'E'
    lcall WriteData
    lcall Waitmillisec
    
    mov a, #0x80 ; Move cursor to line 1 column 1
    lcall WriteCommand
    mov a, #' '
    lcall WriteData
    mov a, #0x81 ; Move cursor to line 1 column 1
    lcall WriteCommand
    mov a, #'E'
    lcall WriteData
    lcall Waitmillisec
    
    ;-----------B--------;
    
    mov a, #0x80 ; Move cursor to line 1 column 1
    lcall WriteCommand
    mov a, #'B'
    lcall WriteData
   
    ;---------------------------------------------------------------------------------------------------;
    
    ;-----------2--------;
    
    mov a, #0xB7 ; Move cursor to line 1 column 1
    lcall WriteCommand
    mov a, #'2'
    lcall WriteData
    lcall Waitmillisec
    
    mov a, #0xB7 ; Move cursor to line 1 column 1
    lcall WriteCommand
    mov a, #' '
    lcall WriteData
    mov a, #0xB6 ; Move cursor to line 1 column 1
    lcall WriteCommand
    mov a, #'2'
    lcall WriteData
    lcall Waitmillisec
    
    mov a, #0xB6 ; Move cursor to line 1 column 1
    lcall WriteCommand
    mov a, #' '
    lcall WriteData
    mov a, #0xB5 ; Move cursor to line 1 column 1
    lcall WriteCommand
    mov a, #'2'
    lcall WriteData
    lcall Waitmillisec
    
    mov a, #0xB5 ; Move cursor to line 1 column 1
    lcall WriteCommand
    mov a, #' '
    lcall WriteData
    mov a, #0xB4 ; Move cursor to line 1 column 1
    lcall WriteCommand
    mov a, #'2'
    lcall WriteData
    lcall Waitmillisec
    
    mov a, #0xB4 ; Move cursor to line 1 column 1
    lcall WriteCommand
    mov a, #' '
    lcall WriteData
    mov a, #0xB3 ; Move cursor to line 1 column 1
    lcall WriteCommand
    mov a, #'2'
    lcall WriteData
    lcall Waitmillisec
    
    mov a, #0xB3 ; Move cursor to line 1 column 1
    lcall WriteCommand
    mov a, #' '
    lcall WriteData
    mov a, #0xB2 ; Move cursor to line 1 column 1
    lcall WriteCommand
    mov a, #'2'
    lcall WriteData
    lcall Waitmillisec
    
    mov a, #0xB2 ; Move cursor to line 1 column 1
    lcall WriteCommand
    mov a, #' '
    lcall WriteData
    mov a, #0xB1 ; Move cursor to line 1 column 1
    lcall WriteCommand
    mov a, #'2'
    lcall WriteData
    lcall Waitmillisec
    
    mov a, #0xB1 ; Move cursor to line 1 column 1
    lcall WriteCommand
    mov a, #' '
    lcall WriteData
    mov a, #0xC9 ; Move cursor to line 1 column 1
    lcall WriteCommand
    mov a, #'2'
    lcall WriteData
    lcall Waitmillisec
    
    mov a, #0xC9 ; Move cursor to line 1 column 1
    lcall WriteCommand
    mov a, #' '
    lcall WriteData
    mov a, #0xC8 ; Move cursor to line 1 column 1
    lcall WriteCommand
    mov a, #'2'
    lcall WriteData
    lcall Waitmillisec
    
    mov a, #0xC8 ; Move cursor to line 1 column 1
    lcall WriteCommand
    mov a, #' '
    lcall WriteData
    mov a, #0xC7 ; Move cursor to line 1 column 1
    lcall WriteCommand
    mov a, #'2'
    lcall WriteData
    lcall Waitmillisec
    
    mov a, #0xC7 ; Move cursor to line 1 column 1
    lcall WriteCommand
    mov a, #' '
    lcall WriteData
    mov a, #0xC6 ; Move cursor to line 1 column 1
    lcall WriteCommand
    mov a, #'2'
    lcall WriteData
    lcall Waitmillisec
    
    mov a, #0xC6 ; Move cursor to line 1 column 1
    lcall WriteCommand
    mov a, #' '
    lcall WriteData
    mov a, #0xC5 ; Move cursor to line 1 column 1
    lcall WriteCommand
    mov a, #'2'
    lcall WriteData
    lcall Waitmillisec
    
    mov a, #0xC5 ; Move cursor to line 1 column 1
    lcall WriteCommand
    mov a, #' '
    lcall WriteData
    mov a, #0xC4 ; Move cursor to line 1 column 1
    lcall WriteCommand
    mov a, #'2'
    lcall WriteData
    lcall Waitmillisec
    
    mov a, #0xC4 ; Move cursor to line 1 column 1
    lcall WriteCommand
    mov a, #' '
    lcall WriteData
    mov a, #0xC3 ; Move cursor to line 1 column 1
    lcall WriteCommand
    mov a, #'2'
    lcall WriteData
    lcall Waitmillisec
    
    mov a, #0xC3 ; Move cursor to line 1 column 1
    lcall WriteCommand
    mov a, #' '
    lcall WriteData
    mov a, #0xC2 ; Move cursor to line 1 column 1
    lcall WriteCommand
    mov a, #'2'
    lcall WriteData
    lcall Waitmillisec
    
    mov a, #0xC2 ; Move cursor to line 1 column 1
    lcall WriteCommand
    mov a, #' '
    lcall WriteData
    mov a, #0xC1 ; Move cursor to line 1 column 1
    lcall WriteCommand
    mov a, #'2'
    lcall WriteData
    lcall Waitmillisec
    
    mov a, #0xC1 ; Move cursor to line 1 column 1
    lcall WriteCommand
    mov a, #' '
    lcall WriteData
    mov a, #0xC0 ; Move cursor to line 1 column 1
    lcall WriteCommand
    mov a, #'2'
    lcall WriteData
    lcall Waitmillisec
    
    ;-----------9--------;
    
    mov a, #0xB7 ; Move cursor to line 1 column 1
    lcall WriteCommand
    mov a, #'9'
    lcall WriteData
    lcall Waitmillisec
    
    mov a, #0xB7 ; Move cursor to line 1 column 1
    lcall WriteCommand
    mov a, #' '
    lcall WriteData
    mov a, #0xB6 ; Move cursor to line 1 column 1
    lcall WriteCommand
    mov a, #'9'
    lcall WriteData
    lcall Waitmillisec
    
    mov a, #0xB6 ; Move cursor to line 1 column 1
    lcall WriteCommand
    mov a, #' '
    lcall WriteData
    mov a, #0xB5 ; Move cursor to line 1 column 1
    lcall WriteCommand
    mov a, #'9'
    lcall WriteData
    lcall Waitmillisec
    
    mov a, #0xB5 ; Move cursor to line 1 column 1
    lcall WriteCommand
    mov a, #' '
    lcall WriteData
    mov a, #0xB4 ; Move cursor to line 1 column 1
    lcall WriteCommand
    mov a, #'9'
    lcall WriteData
    lcall Waitmillisec
    
    mov a, #0xB4 ; Move cursor to line 1 column 1
    lcall WriteCommand
    mov a, #' '
    lcall WriteData
    mov a, #0xB3 ; Move cursor to line 1 column 1
    lcall WriteCommand
    mov a, #'9'
    lcall WriteData
    lcall Waitmillisec
    
    mov a, #0xB3 ; Move cursor to line 1 column 1
    lcall WriteCommand
    mov a, #' '
    lcall WriteData
    mov a, #0xB2 ; Move cursor to line 1 column 1
    lcall WriteCommand
    mov a, #'9'
    lcall WriteData
    lcall Waitmillisec
    
    mov a, #0xB2 ; Move cursor to line 1 column 1
    lcall WriteCommand
    mov a, #' '
    lcall WriteData
    mov a, #0xB1 ; Move cursor to line 1 column 1
    lcall WriteCommand
    mov a, #'9'
    lcall WriteData
    lcall Waitmillisec
    
    mov a, #0xB1 ; Move cursor to line 1 column 1
    lcall WriteCommand
    mov a, #' '
    lcall WriteData
    mov a, #0xC9 ; Move cursor to line 1 column 1
    lcall WriteCommand
    mov a, #'9'
    lcall WriteData
    lcall Waitmillisec
    
    mov a, #0xC9 ; Move cursor to line 1 column 1
    lcall WriteCommand
    mov a, #' '
    lcall WriteData
    mov a, #0xC8 ; Move cursor to line 1 column 1
    lcall WriteCommand
    mov a, #'9'
    lcall WriteData
    lcall Waitmillisec
    
    mov a, #0xC8 ; Move cursor to line 1 column 1
    lcall WriteCommand
    mov a, #' '
    lcall WriteData
    mov a, #0xC7 ; Move cursor to line 1 column 1
    lcall WriteCommand
    mov a, #'9'
    lcall WriteData
    lcall Waitmillisec
    
    mov a, #0xC7 ; Move cursor to line 1 column 1
    lcall WriteCommand
    mov a, #' '
    lcall WriteData
    mov a, #0xC6 ; Move cursor to line 1 column 1
    lcall WriteCommand
    mov a, #'9'
    lcall WriteData
    lcall Waitmillisec
    
    mov a, #0xC6 ; Move cursor to line 1 column 1
    lcall WriteCommand
    mov a, #' '
    lcall WriteData
    mov a, #0xC5 ; Move cursor to line 1 column 1
    lcall WriteCommand
    mov a, #'9'
    lcall WriteData
    lcall Waitmillisec
    
    mov a, #0xC5 ; Move cursor to line 1 column 1
    lcall WriteCommand
    mov a, #' '
    lcall WriteData
    mov a, #0xC4 ; Move cursor to line 1 column 1
    lcall WriteCommand
    mov a, #'9'
    lcall WriteData
    lcall Waitmillisec
    
    mov a, #0xC4 ; Move cursor to line 1 column 1
    lcall WriteCommand
    mov a, #' '
    lcall WriteData
    mov a, #0xC3 ; Move cursor to line 1 column 1
    lcall WriteCommand
    mov a, #'9'
    lcall WriteData
    lcall Waitmillisec
    
    mov a, #0xC3 ; Move cursor to line 1 column 1
    lcall WriteCommand
    mov a, #' '
    lcall WriteData
    mov a, #0xC2 ; Move cursor to line 1 column 1
    lcall WriteCommand
    mov a, #'9'
    lcall WriteData
    lcall Waitmillisec
    
    mov a, #0xC2 ; Move cursor to line 1 column 1
    lcall WriteCommand
    mov a, #' '
    lcall WriteData
    mov a, #0xC1 ; Move cursor to line 1 column 1
    lcall WriteCommand
    mov a, #'9'
    lcall WriteData
    lcall Waitmillisec
    
    ;-----------7--------;
    
    mov a, #0xB7 ; Move cursor to line 1 column 1
    lcall WriteCommand
    mov a, #'7'
    lcall WriteData
    lcall Waitmillisec
    
    mov a, #0xB7 ; Move cursor to line 1 column 1
    lcall WriteCommand
    mov a, #' '
    lcall WriteData
    mov a, #0xB6 ; Move cursor to line 1 column 1
    lcall WriteCommand
    mov a, #'7'
    lcall WriteData
    lcall Waitmillisec
    
    mov a, #0xB6 ; Move cursor to line 1 column 1
    lcall WriteCommand
    mov a, #' '
    lcall WriteData
    mov a, #0xB5 ; Move cursor to line 1 column 1
    lcall WriteCommand
    mov a, #'7'
    lcall WriteData
    lcall Waitmillisec
    
    mov a, #0xB5 ; Move cursor to line 1 column 1
    lcall WriteCommand
    mov a, #' '
    lcall WriteData
    mov a, #0xB4 ; Move cursor to line 1 column 1
    lcall WriteCommand
    mov a, #'7'
    lcall WriteData
    lcall Waitmillisec
    
    mov a, #0xB4 ; Move cursor to line 1 column 1
    lcall WriteCommand
    mov a, #' '
    lcall WriteData
    mov a, #0xB3 ; Move cursor to line 1 column 1
    lcall WriteCommand
    mov a, #'7'
    lcall WriteData
    lcall Waitmillisec
    
    mov a, #0xB3 ; Move cursor to line 1 column 1
    lcall WriteCommand
    mov a, #' '
    lcall WriteData
    mov a, #0xB2 ; Move cursor to line 1 column 1
    lcall WriteCommand
    mov a, #'7'
    lcall WriteData
    lcall Waitmillisec
    
    mov a, #0xB2 ; Move cursor to line 1 column 1
    lcall WriteCommand
    mov a, #' '
    lcall WriteData
    mov a, #0xB1 ; Move cursor to line 1 column 1
    lcall WriteCommand
    mov a, #'7'
    lcall WriteData
    lcall Waitmillisec
    
    mov a, #0xB1 ; Move cursor to line 1 column 1
    lcall WriteCommand
    mov a, #' '
    lcall WriteData
    mov a, #0xC9 ; Move cursor to line 1 column 1
    lcall WriteCommand
    mov a, #'7'
    lcall WriteData
    lcall Waitmillisec
    
    mov a, #0xC9 ; Move cursor to line 1 column 1
    lcall WriteCommand
    mov a, #' '
    lcall WriteData
    mov a, #0xC8 ; Move cursor to line 1 column 1
    lcall WriteCommand
    mov a, #'7'
    lcall WriteData
    lcall Waitmillisec
    
    mov a, #0xC8 ; Move cursor to line 1 column 1
    lcall WriteCommand
    mov a, #' '
    lcall WriteData
    mov a, #0xC7 ; Move cursor to line 1 column 1
    lcall WriteCommand
    mov a, #'7'
    lcall WriteData
    lcall Waitmillisec
    
    mov a, #0xC7 ; Move cursor to line 1 column 1
    lcall WriteCommand
    mov a, #' '
    lcall WriteData
    mov a, #0xC6 ; Move cursor to line 1 column 1
    lcall WriteCommand
    mov a, #'7'
    lcall WriteData
    lcall Waitmillisec
    
    mov a, #0xC6 ; Move cursor to line 1 column 1
    lcall WriteCommand
    mov a, #' '
    lcall WriteData
    mov a, #0xC5 ; Move cursor to line 1 column 1
    lcall WriteCommand
    mov a, #'7'
    lcall WriteData
    lcall Waitmillisec
    
    mov a, #0xC5 ; Move cursor to line 1 column 1
    lcall WriteCommand
    mov a, #' '
    lcall WriteData
    mov a, #0xC4 ; Move cursor to line 1 column 1
    lcall WriteCommand
    mov a, #'7'
    lcall WriteData
    lcall Waitmillisec
    
    mov a, #0xC4 ; Move cursor to line 1 column 1
    lcall WriteCommand
    mov a, #' '
    lcall WriteData
    mov a, #0xC3 ; Move cursor to line 1 column 1
    lcall WriteCommand
    mov a, #'7'
    lcall WriteData
    lcall Waitmillisec
    
    mov a, #0xC3 ; Move cursor to line 1 column 1
    lcall WriteCommand
    mov a, #' '
    lcall WriteData
    mov a, #0xC2 ; Move cursor to line 1 column 1
    lcall WriteCommand
    mov a, #'7'
    lcall WriteData
    lcall Waitmillisec
    
    ;-----------3--------;
    
    mov a, #0xB7 ; Move cursor to line 1 column 1
    lcall WriteCommand
    mov a, #'3'
    lcall WriteData
    lcall Waitmillisec
    
    mov a, #0xB7 ; Move cursor to line 1 column 1
    lcall WriteCommand
    mov a, #' '
    lcall WriteData
    mov a, #0xB6 ; Move cursor to line 1 column 1
    lcall WriteCommand
    mov a, #'3'
    lcall WriteData
    lcall Waitmillisec
    
    mov a, #0xB6 ; Move cursor to line 1 column 1
    lcall WriteCommand
    mov a, #' '
    lcall WriteData
    mov a, #0xB5 ; Move cursor to line 1 column 1
    lcall WriteCommand
    mov a, #'3'
    lcall WriteData
    lcall Waitmillisec
    
    mov a, #0xB5 ; Move cursor to line 1 column 1
    lcall WriteCommand
    mov a, #' '
    lcall WriteData
    mov a, #0xB4 ; Move cursor to line 1 column 1
    lcall WriteCommand
    mov a, #'3'
    lcall WriteData
    lcall Waitmillisec
    
    mov a, #0xB4 ; Move cursor to line 1 column 1
    lcall WriteCommand
    mov a, #' '
    lcall WriteData
    mov a, #0xB3 ; Move cursor to line 1 column 1
    lcall WriteCommand
    mov a, #'3'
    lcall WriteData
    lcall Waitmillisec
    
    mov a, #0xB3 ; Move cursor to line 1 column 1
    lcall WriteCommand
    mov a, #' '
    lcall WriteData
    mov a, #0xB2 ; Move cursor to line 1 column 1
    lcall WriteCommand
    mov a, #'3'
    lcall WriteData
    lcall Waitmillisec
    
    mov a, #0xB2 ; Move cursor to line 1 column 1
    lcall WriteCommand
    mov a, #' '
    lcall WriteData
    mov a, #0xB1 ; Move cursor to line 1 column 1
    lcall WriteCommand
    mov a, #'3'
    lcall WriteData
    lcall Waitmillisec
    
    mov a, #0xB1 ; Move cursor to line 1 column 1
    lcall WriteCommand
    mov a, #' '
    lcall WriteData
    mov a, #0xC9 ; Move cursor to line 1 column 1
    lcall WriteCommand
    mov a, #'3'
    lcall WriteData
    lcall Waitmillisec
    
    mov a, #0xC9 ; Move cursor to line 1 column 1
    lcall WriteCommand
    mov a, #' '
    lcall WriteData
    mov a, #0xC8 ; Move cursor to line 1 column 1
    lcall WriteCommand
    mov a, #'3'
    lcall WriteData
    lcall Waitmillisec
    
    mov a, #0xC8 ; Move cursor to line 1 column 1
    lcall WriteCommand
    mov a, #' '
    lcall WriteData
    mov a, #0xC7 ; Move cursor to line 1 column 1
    lcall WriteCommand
    mov a, #'3'
    lcall WriteData
    lcall Waitmillisec
    
    mov a, #0xC7 ; Move cursor to line 1 column 1
    lcall WriteCommand
    mov a, #' '
    lcall WriteData
    mov a, #0xC6 ; Move cursor to line 1 column 1
    lcall WriteCommand
    mov a, #'3'
    lcall WriteData
    lcall Waitmillisec
    
    mov a, #0xC6 ; Move cursor to line 1 column 1
    lcall WriteCommand
    mov a, #' '
    lcall WriteData
    mov a, #0xC5 ; Move cursor to line 1 column 1
    lcall WriteCommand
    mov a, #'3'
    lcall WriteData
    lcall Waitmillisec
    
    mov a, #0xC5 ; Move cursor to line 1 column 1
    lcall WriteCommand
    mov a, #' '
    lcall WriteData
    mov a, #0xC4 ; Move cursor to line 1 column 1
    lcall WriteCommand
    mov a, #'3'
    lcall WriteData
    lcall Waitmillisec
    
    mov a, #0xC4 ; Move cursor to line 1 column 1
    lcall WriteCommand
    mov a, #' '
    lcall WriteData
    mov a, #0xC3 ; Move cursor to line 1 column 1
    lcall WriteCommand
    mov a, #'3'
    lcall WriteData
    lcall Waitmillisec
    
    ;-----------8--------;
    
    mov a, #0xB7 ; Move cursor to line 1 column 1
    lcall WriteCommand
    mov a, #'8'
    lcall WriteData
    lcall Waitmillisec
    
    mov a, #0xB7 ; Move cursor to line 1 column 1
    lcall WriteCommand
    mov a, #' '
    lcall WriteData
    mov a, #0xB6 ; Move cursor to line 1 column 1
    lcall WriteCommand
    mov a, #'8'
    lcall WriteData
    lcall Waitmillisec
    
    mov a, #0xB6 ; Move cursor to line 1 column 1
    lcall WriteCommand
    mov a, #' '
    lcall WriteData
    mov a, #0xB5 ; Move cursor to line 1 column 1
    lcall WriteCommand
    mov a, #'8'
    lcall WriteData
    lcall Waitmillisec
    
    mov a, #0xB5 ; Move cursor to line 1 column 1
    lcall WriteCommand
    mov a, #' '
    lcall WriteData
    mov a, #0xB4 ; Move cursor to line 1 column 1
    lcall WriteCommand
    mov a, #'8'
    lcall WriteData
    lcall Waitmillisec
    
    mov a, #0xB4 ; Move cursor to line 1 column 1
    lcall WriteCommand
    mov a, #' '
    lcall WriteData
    mov a, #0xB3 ; Move cursor to line 1 column 1
    lcall WriteCommand
    mov a, #'8'
    lcall WriteData
    lcall Waitmillisec
    
    mov a, #0xB3 ; Move cursor to line 1 column 1
    lcall WriteCommand
    mov a, #' '
    lcall WriteData
    mov a, #0xB2 ; Move cursor to line 1 column 1
    lcall WriteCommand
    mov a, #'8'
    lcall WriteData
    lcall Waitmillisec
    
    mov a, #0xB2 ; Move cursor to line 1 column 1
    lcall WriteCommand
    mov a, #' '
    lcall WriteData
    mov a, #0xB1 ; Move cursor to line 1 column 1
    lcall WriteCommand
    mov a, #'8'
    lcall WriteData
    lcall Waitmillisec
    
    mov a, #0xB1 ; Move cursor to line 1 column 1
    lcall WriteCommand
    mov a, #' '
    lcall WriteData
    mov a, #0xC9 ; Move cursor to line 1 column 1
    lcall WriteCommand
    mov a, #'8'
    lcall WriteData
    lcall Waitmillisec
    
    mov a, #0xC9 ; Move cursor to line 1 column 1
    lcall WriteCommand
    mov a, #' '
    lcall WriteData
    mov a, #0xC8 ; Move cursor to line 1 column 1
    lcall WriteCommand
    mov a, #'8'
    lcall WriteData
    lcall Waitmillisec
    
    mov a, #0xC8 ; Move cursor to line 1 column 1
    lcall WriteCommand
    mov a, #' '
    lcall WriteData
    mov a, #0xC7 ; Move cursor to line 1 column 1
    lcall WriteCommand
    mov a, #'8'
    lcall WriteData
    lcall Waitmillisec
    
    mov a, #0xC7 ; Move cursor to line 1 column 1
    lcall WriteCommand
    mov a, #' '
    lcall WriteData
    mov a, #0xC6 ; Move cursor to line 1 column 1
    lcall WriteCommand
    mov a, #'8'
    lcall WriteData
    lcall Waitmillisec
    
    mov a, #0xC6 ; Move cursor to line 1 column 1
    lcall WriteCommand
    mov a, #' '
    lcall WriteData
    mov a, #0xC5 ; Move cursor to line 1 column 1
    lcall WriteCommand
    mov a, #'8'
    lcall WriteData
    lcall Waitmillisec
    
    mov a, #0xC5 ; Move cursor to line 1 column 1
    lcall WriteCommand
    mov a, #' '
    lcall WriteData
    mov a, #0xC4 ; Move cursor to line 1 column 1
    lcall WriteCommand
    mov a, #'8'
    lcall WriteData
    lcall Waitmillisec
    
    ;-----------3--------;
    
    mov a, #0xB7 ; Move cursor to line 1 column 1
    lcall WriteCommand
    mov a, #'3'
    lcall WriteData
    lcall Waitmillisec
    
    mov a, #0xB7 ; Move cursor to line 1 column 1
    lcall WriteCommand
    mov a, #' '
    lcall WriteData
    mov a, #0xB6 ; Move cursor to line 1 column 1
    lcall WriteCommand
    mov a, #'3'
    lcall WriteData
    lcall Waitmillisec
    
    mov a, #0xB6 ; Move cursor to line 1 column 1
    lcall WriteCommand
    mov a, #' '
    lcall WriteData
    mov a, #0xB5 ; Move cursor to line 1 column 1
    lcall WriteCommand
    mov a, #'3'
    lcall WriteData
    lcall Waitmillisec
    
    mov a, #0xB5 ; Move cursor to line 1 column 1
    lcall WriteCommand
    mov a, #' '
    lcall WriteData
    mov a, #0xB4 ; Move cursor to line 1 column 1
    lcall WriteCommand
    mov a, #'3'
    lcall WriteData
    lcall Waitmillisec
    
    mov a, #0xB4 ; Move cursor to line 1 column 1
    lcall WriteCommand
    mov a, #' '
    lcall WriteData
    mov a, #0xB3 ; Move cursor to line 1 column 1
    lcall WriteCommand
    mov a, #'3'
    lcall WriteData
    lcall Waitmillisec
    
    mov a, #0xB3 ; Move cursor to line 1 column 1
    lcall WriteCommand
    mov a, #' '
    lcall WriteData
    mov a, #0xB2 ; Move cursor to line 1 column 1
    lcall WriteCommand
    mov a, #'3'
    lcall WriteData
    lcall Waitmillisec
    
    mov a, #0xB2 ; Move cursor to line 1 column 1
    lcall WriteCommand
    mov a, #' '
    lcall WriteData
    mov a, #0xB1 ; Move cursor to line 1 column 1
    lcall WriteCommand
    mov a, #'3'
    lcall WriteData
    lcall Waitmillisec
    
    mov a, #0xB1 ; Move cursor to line 1 column 1
    lcall WriteCommand
    mov a, #' '
    lcall WriteData
    mov a, #0xC9 ; Move cursor to line 1 column 1
    lcall WriteCommand
    mov a, #'3'
    lcall WriteData
    lcall Waitmillisec
    
    mov a, #0xC9 ; Move cursor to line 1 column 1
    lcall WriteCommand
    mov a, #' '
    lcall WriteData
    mov a, #0xC8 ; Move cursor to line 1 column 1
    lcall WriteCommand
    mov a, #'3'
    lcall WriteData
    lcall Waitmillisec
    
    mov a, #0xC8 ; Move cursor to line 1 column 1
    lcall WriteCommand
    mov a, #' '
    lcall WriteData
    mov a, #0xC7 ; Move cursor to line 1 column 1
    lcall WriteCommand
    mov a, #'3'
    lcall WriteData
    lcall Waitmillisec
    
    mov a, #0xC7 ; Move cursor to line 1 column 1
    lcall WriteCommand
    mov a, #' '
    lcall WriteData
    mov a, #0xC6 ; Move cursor to line 1 column 1
    lcall WriteCommand
    mov a, #'3'
    lcall WriteData
    lcall Waitmillisec
    
    mov a, #0xC6 ; Move cursor to line 1 column 1
    lcall WriteCommand
    mov a, #' '
    lcall WriteData
    mov a, #0xC5 ; Move cursor to line 1 column 1
    lcall WriteCommand
    mov a, #'3'
    lcall WriteData
    lcall Waitmillisec
    
    ;-----------9--------;
    
    mov a, #0xB7 ; Move cursor to line 1 column 1
    lcall WriteCommand
    mov a, #'9'
    lcall WriteData
    lcall Waitmillisec
    
    mov a, #0xB7 ; Move cursor to line 1 column 1
    lcall WriteCommand
    mov a, #' '
    lcall WriteData
    mov a, #0xB6 ; Move cursor to line 1 column 1
    lcall WriteCommand
    mov a, #'9'
    lcall WriteData
    lcall Waitmillisec
    
    mov a, #0xB6 ; Move cursor to line 1 column 1
    lcall WriteCommand
    mov a, #' '
    lcall WriteData
    mov a, #0xB5 ; Move cursor to line 1 column 1
    lcall WriteCommand
    mov a, #'9'
    lcall WriteData
    lcall Waitmillisec
    
    mov a, #0xB5 ; Move cursor to line 1 column 1
    lcall WriteCommand
    mov a, #' '
    lcall WriteData
    mov a, #0xB4 ; Move cursor to line 1 column 1
    lcall WriteCommand
    mov a, #'9'
    lcall WriteData
    lcall Waitmillisec
    
    mov a, #0xB4 ; Move cursor to line 1 column 1
    lcall WriteCommand
    mov a, #' '
    lcall WriteData
    mov a, #0xB3 ; Move cursor to line 1 column 1
    lcall WriteCommand
    mov a, #'9'
    lcall WriteData
    lcall Waitmillisec
    
    mov a, #0xB3 ; Move cursor to line 1 column 1
    lcall WriteCommand
    mov a, #' '
    lcall WriteData
    mov a, #0xB2 ; Move cursor to line 1 column 1
    lcall WriteCommand
    mov a, #'9'
    lcall WriteData
    lcall Waitmillisec
    
    mov a, #0xB2 ; Move cursor to line 1 column 1
    lcall WriteCommand
    mov a, #' '
    lcall WriteData
    mov a, #0xB1 ; Move cursor to line 1 column 1
    lcall WriteCommand
    mov a, #'9'
    lcall WriteData
    lcall Waitmillisec
    
    mov a, #0xB1 ; Move cursor to line 1 column 1
    lcall WriteCommand
    mov a, #' '
    lcall WriteData
    mov a, #0xC9 ; Move cursor to line 1 column 1
    lcall WriteCommand
    mov a, #'9'
    lcall WriteData
    lcall Waitmillisec
    
    mov a, #0xC9 ; Move cursor to line 1 column 1
    lcall WriteCommand
    mov a, #' '
    lcall WriteData
    mov a, #0xC8 ; Move cursor to line 1 column 1
    lcall WriteCommand
    mov a, #'9'
    lcall WriteData
    lcall Waitmillisec
    
    mov a, #0xC8 ; Move cursor to line 1 column 1
    lcall WriteCommand
    mov a, #' '
    lcall WriteData
    mov a, #0xC7 ; Move cursor to line 1 column 1
    lcall WriteCommand
    mov a, #'9'
    lcall WriteData
    lcall Waitmillisec
    
    mov a, #0xC7 ; Move cursor to line 1 column 1
    lcall WriteCommand
    mov a, #' '
    lcall WriteData
    mov a, #0xC6 ; Move cursor to line 1 column 1
    lcall WriteCommand
    mov a, #'9'
    lcall WriteData
    lcall Waitmillisec
    
    ;-----------0--------;
    
    mov a, #0xB7 ; Move cursor to line 1 column 1
    lcall WriteCommand
    mov a, #'0'
    lcall WriteData
    lcall Waitmillisec
    
    mov a, #0xB7 ; Move cursor to line 1 column 1
    lcall WriteCommand
    mov a, #' '
    lcall WriteData
    mov a, #0xB6 ; Move cursor to line 1 column 1
    lcall WriteCommand
    mov a, #'0'
    lcall WriteData
    lcall Waitmillisec
    
    mov a, #0xB6 ; Move cursor to line 1 column 1
    lcall WriteCommand
    mov a, #' '
    lcall WriteData
    mov a, #0xB5 ; Move cursor to line 1 column 1
    lcall WriteCommand
    mov a, #'0'
    lcall WriteData
    lcall Waitmillisec
    
    mov a, #0xB5 ; Move cursor to line 1 column 1
    lcall WriteCommand
    mov a, #' '
    lcall WriteData
    mov a, #0xB4 ; Move cursor to line 1 column 1
    lcall WriteCommand
    mov a, #'0'
    lcall WriteData
    lcall Waitmillisec
    
    mov a, #0xB4 ; Move cursor to line 1 column 1
    lcall WriteCommand
    mov a, #' '
    lcall WriteData
    mov a, #0xB3 ; Move cursor to line 1 column 1
    lcall WriteCommand
    mov a, #'0'
    lcall WriteData
    lcall Waitmillisec
    
    mov a, #0xB3 ; Move cursor to line 1 column 1
    lcall WriteCommand
    mov a, #' '
    lcall WriteData
    mov a, #0xB2 ; Move cursor to line 1 column 1
    lcall WriteCommand
    mov a, #'0'
    lcall WriteData
    lcall Waitmillisec
    
    mov a, #0xB2 ; Move cursor to line 1 column 1
    lcall WriteCommand
    mov a, #' '
    lcall WriteData
    mov a, #0xB1 ; Move cursor to line 1 column 1
    lcall WriteCommand
    mov a, #'0'
    lcall WriteData
    lcall Waitmillisec
    
    mov a, #0xB1 ; Move cursor to line 1 column 1
    lcall WriteCommand
    mov a, #' '
    lcall WriteData
    mov a, #0xC9 ; Move cursor to line 1 column 1
    lcall WriteCommand
    mov a, #'0'
    lcall WriteData
    lcall Waitmillisec
    
    mov a, #0xC9 ; Move cursor to line 1 column 1
    lcall WriteCommand
    mov a, #' '
    lcall WriteData
    mov a, #0xC8 ; Move cursor to line 1 column 1
    lcall WriteCommand
    mov a, #'0'
    lcall WriteData
    lcall Waitmillisec
    
    mov a, #0xC8 ; Move cursor to line 1 column 1
    lcall WriteCommand
    mov a, #' '
    lcall WriteData
    mov a, #0xC7 ; Move cursor to line 1 column 1
    lcall WriteCommand
    mov a, #'0'
    lcall WriteData
    lcall Waitmillisec
    
    ;----------X---------;
    
    mov a, #0x80 ; Move cursor to line 1 column 1
    lcall WriteCommand
    mov a, #'I'
    lcall WriteData
    mov a, #0xC0 ; Move cursor to line 1 column 1
    lcall WriteCommand
    mov a, #'I'
    lcall WriteData
    lcall Waitmillisec
    
    mov a, #0x80 ; Move cursor to line 1 column 1
    lcall WriteCommand
    mov a, #'2'
    lcall WriteData
    mov a, #0x81 ; Move cursor to line 1 column 1
    lcall WriteCommand
    mov a, #'I'
    lcall WriteData
    mov a, #0xC0 ; Move cursor to line 1 column 1
    lcall WriteCommand
    mov a, #'B'
    lcall WriteData
    mov a, #0xC1 ; Move cursor to line 1 column 1
    lcall WriteCommand
    mov a, #'I'
    lcall WriteData
    lcall Waitmillisec
    
    mov a, #0x81 ; Move cursor to line 1 column 1
    lcall WriteCommand
    mov a, #'9'
    lcall WriteData
    mov a, #0x82 ; Move cursor to line 1 column 1
    lcall WriteCommand
    mov a, #'I'
    lcall WriteData
    mov a, #0xC1 ; Move cursor to line 1 column 1
    lcall WriteCommand
    mov a, #'E'
    lcall WriteData
    mov a, #0xC2 ; Move cursor to line 1 column 1
    lcall WriteCommand
    mov a, #'I'
    lcall WriteData
    lcall Waitmillisec
    
    mov a, #0x82 ; Move cursor to line 1 column 1
    lcall WriteCommand
    mov a, #'7'
    lcall WriteData
    mov a, #0x83 ; Move cursor to line 1 column 1
    lcall WriteCommand
    mov a, #'I'
    lcall WriteData
    mov a, #0xC2 ; Move cursor to line 1 column 1
    lcall WriteCommand
    mov a, #'N'
    lcall WriteData
    mov a, #0xC3 ; Move cursor to line 1 column 1
    lcall WriteCommand
    mov a, #'I'
    lcall WriteData
    lcall Waitmillisec
    
    mov a, #0x83 ; Move cursor to line 1 column 1
    lcall WriteCommand
    mov a, #'3'
    lcall WriteData
    mov a, #0x84 ; Move cursor to line 1 column 1
    lcall WriteCommand
    mov a, #'I'
    lcall WriteData
    mov a, #0xC3 ; Move cursor to line 1 column 1
    lcall WriteCommand
    mov a, #'N'
    lcall WriteData
    mov a, #0xC4 ; Move cursor to line 1 column 1
    lcall WriteCommand
    mov a, #'I'
    lcall WriteData
    lcall Waitmillisec
    
    mov a, #0x84 ; Move cursor to line 1 column 1
    lcall WriteCommand
    mov a, #'8'
    lcall WriteData
    mov a, #0x85 ; Move cursor to line 1 column 1
    lcall WriteCommand
    mov a, #'I'
    lcall WriteData
    mov a, #0xC4 ; Move cursor to line 1 column 1
    lcall WriteCommand
    mov a, #'Y'
    lcall WriteData
    mov a, #0xC5 ; Move cursor to line 1 column 1
    lcall WriteCommand
    mov a, #'I'
    lcall WriteData
    lcall Waitmillisec
    
    mov a, #0x85 ; Move cursor to line 1 column 1
    lcall WriteCommand
    mov a, #'3'
    lcall WriteData
    mov a, #0x86 ; Move cursor to line 1 column 1
    lcall WriteCommand
    mov a, #'I'
    lcall WriteData
    mov a, #0xC5 ; Move cursor to line 1 column 1
    lcall WriteCommand
    mov a, #' '
    lcall WriteData
    mov a, #0xC6 ; Move cursor to line 1 column 1
    lcall WriteCommand
    mov a, #'I'
    lcall WriteData
    lcall Waitmillisec
    
    mov a, #0x86 ; Move cursor to line 1 column 1
    lcall WriteCommand
    mov a, #'9'
    lcall WriteData
    mov a, #0x87 ; Move cursor to line 1 column 1
    lcall WriteCommand
    mov a, #' '
    lcall WriteData
    mov a, #0xC6 ; Move cursor to line 1 column 1
    lcall WriteCommand
    mov a, #'H'
    lcall WriteData
    mov a, #0xC7 ; Move cursor to line 1 column 1
    lcall WriteCommand
    mov a, #'I'
    lcall WriteData
    lcall Waitmillisec
    
    mov a, #0x87 ; Move cursor to line 1 column 1
    lcall WriteCommand
    mov a, #'0'
    lcall WriteData
    mov a, #0x88 ; Move cursor to line 1 column 1
    lcall WriteCommand
    mov a, #' '
    lcall WriteData
    mov a, #0xC7 ; Move cursor to line 1 column 1
    lcall WriteCommand
    mov a, #'U'
    lcall WriteData
    mov a, #0xC8 ; Move cursor to line 1 column 1
    lcall WriteCommand
    mov a, #'I'
    lcall WriteData
    lcall Waitmillisec
 
    
    
forever:
    
    sjmp forever
END
