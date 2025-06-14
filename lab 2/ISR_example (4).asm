; ISR_example.asm: a) Increments/decrements a BCD variable every half second using
; an ISR for timer 2; b) Generates a 2kHz square wave at pin P1.7 using
; an ISR for timer 0; and c) in the 'main' loop it displays the variable
; incremented/decremented using the ISR for timer 2 on the LCD.  Also resets it to 
; zero if the 'CLEAR' push button connected to P1.5 is pressed.
$NOLIST
$MODN76E003
$LIST

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

CLK           EQU 16600000 ; Microcontroller system frequency in Hz
TIMER0_RATE   EQU 4096     ; 2048Hz squarewave (peak amplitude of CEM-1203 speaker)
TIMER0_RELOAD EQU ((65536-(CLK/TIMER0_RATE)))
TIMER2_RATE   EQU 1000     ; 1000Hz, for a timer tick of 1ms
TIMER2_RELOAD EQU ((65536-(CLK/TIMER2_RATE)))

TIMER_BUTTON equ P1.0
TIMER_HOUR equ P1.1
TIMER_MINUTE equ P1.2
TIMER_SECOND equ p1.3
CLEAR_BUTTON  equ P1.5
UPDOWN        equ P1.6
SOUND_OUT     equ P1.7

; Reset vector
org 0x0000
    ljmp main

; External interrupt 0 vector (not used in this code)
org 0x0003
	reti

; Timer/Counter 0 overflow interrupt vector
org 0x000B
	ljmp Timer0_ISR

; External interrupt 1 vector (not used in this code)
org 0x0013
	reti

; Timer/Counter 1 overflow interrupt vector (not used in this code)
org 0x001B
	reti

; Serial port receive/transmit interrupt vector (not used in this code)
org 0x0023 
	reti
	
; Timer/Counter 2 overflow interrupt vector
org 0x002B
	ljmp Timer2_ISR

; In the 8051 we can define direct access variables starting at location 0x30 up to location 0x7F
dseg at 0x30
Count1ms:     ds 2 ; Used to determine when half second has passed
Seconds:  ds 1 ; The BCD counter incrememted in the ISR and displayed in the main loop
Minutes: ds 1
Hours: ds 1

; In the 8051 we have variables that are 1-bit in size.  We can use the setb, clr, jb, and jnb
; instructions with these variables.  This is how you define a 1-bit variable:
bseg
half_seconds_flag: dbit 1 ; Set to one in the ISR every time 500 ms had passed
AM_PM: dbit 1

cseg
; These 'equ' must match the hardware wiring
LCD_RS equ P1.3
;LCD_RW equ PX.X ; Not used in this code, connect the pin to GND
LCD_E  equ P1.4
LCD_D4 equ P0.0
LCD_D5 equ P0.1
LCD_D6 equ P0.2
LCD_D7 equ P0.3

$NOLIST
$include(LCD_4bit.inc) ; A library of LCD related functions and utility macros
$LIST

;                     1234567890123456    <- This helps determine the location of the counter
Initial_Message:  db 'Time', 0
Second_Message: db 'Alarm', 0
BlankSpace: db ' ', 0
Colon_M: db ':',0
AM: db 'A',0
PM: db 'M',0
On_Alarm: db 'On ',0
Off_Alarm: db 'Off',0
Blank: db ' ',0

;---------------------------------;
; Routine to initialize the ISR   ;
; for timer 0                     ;
;---------------------------------;
Timer0_Init:
	orl CKCON, #0b00001000 ; Input for timer 0 is sysclk/1
	mov a, TMOD
	anl a, #0xf0 ; 11110000 Clear the bits for timer 0
	orl a, #0x01 ; 00000001 Configure timer 0 as 16-timer
	mov TMOD, a
	mov TH0, #high(TIMER0_RELOAD)
	mov TL0, #low(TIMER0_RELOAD)
	; Enable the timer and interrupts
    setb ET0  ; Enable timer 0 interrupt
    setb TR0  ; Start timer 0
	ret

;---------------------------------;
; ISR for timer 0.  Set to execute;
; every 1/4096Hz to generate a    ;
; 2048 Hz wave at pin SOUND_OUT   ;
;---------------------------------;
Timer0_ISR:
	;clr TF0  ; According to the data sheet this is done for us already.
	; Timer 0 doesn't have 16-bit auto-reload, so
	clr TR0
	mov TH0, #high(TIMER0_RELOAD)
	mov TL0, #low(TIMER0_RELOAD)
	setb TR0
	cpl SOUND_OUT ; Connect speaker the pin assigned to 'SOUND_OUT'!
	reti

;---------------------------------;
; Routine to initialize the ISR   ;
; for timer 2                     ;
;---------------------------------;
Timer2_Init:
	mov T2CON, #0 ; Stop timer/counter.  Autoreload mode.
	mov TH2, #high(TIMER2_RELOAD)
	mov TL2, #low(TIMER2_RELOAD)
	; Set the reload value
	orl T2MOD, #0x80 ; Enable timer 2 autoreload
	mov RCMP2H, #high(TIMER2_RELOAD)
	mov RCMP2L, #low(TIMER2_RELOAD)
	; Init One millisecond interrupt counter.  It is a 16-bit variable made with two 8-bit parts
	clr a
	mov Count1ms+0, a
	mov Count1ms+1, a
	; Enable the timer and interrupts
	orl EIE, #0x80 ; Enable timer 2 interrupt ET2=1
    setb TR2  ; Enable timer 2
	ret

;---------------------------------;
; ISR for timer 2                 ;
;---------------------------------;
Timer2_ISR:
	clr TF2  ; Timer 2 doesn't clear TF2 automatically. Do it in the ISR.  It is bit addressable.
	cpl P0.4 ; To check the interrupt rate with oscilloscope. It must be precisely a 1 ms pulse.
	
	; The two registers used in the ISR must be saved in the stack
	push acc
	push psw
	
	; Increment the 16-bit one mili second counter
	inc Count1ms+0    ; Increment the low 8-bits first
	mov a, Count1ms+0 ; If the low 8-bits overflow, then increment high 8-bits
	jnz Inc_Done
	inc Count1ms+1

Inc_Done:
	; Check if half second has passed
	mov a, Count1ms+0
	cjne a, #low(1000), Timer2_ISR_done ; Warning: this instruction changes the carry flag!
	mov a, Count1ms+1
	cjne a, #high(1000), Timer2_ISR_done
	
	; 500 milliseconds have passed.  Set a flag so the main program knows
	setb half_seconds_flag ; Let the main program know half second had passed
	cpl TR0 ; Enable/disable timer/counter 0. This line creates a beep-silence-beep-silence sound.
	; Reset to zero the milli-seconds counter, it is a 16-bit variable
	clr a
	mov Count1ms+0, a
	mov Count1ms+1, a
	
	; Increment the Seconds
	mov a, Seconds
	add a, #0x01
	da a
	cjne a, #0x60, Update_Seconds
	clr a
	mov Seconds, #0x00
	
	mov a, Minutes
	add a, #0x01
	da a
	cjne a, #0x60, Update_Minutes
	clr a
	mov Minutes, #0x00
	
	mov a, Hours
	add a, #0x01
	da a
	cjne a, #0x13, Update_Hours
	clr a
	mov Hours, #0x01
	cpl AM_PM
	
Update_Hours:
	mov Hours, a
	mov Hours, #0x01
Update_Minutes:
	mov Minutes, a
Update_Seconds:
	mov Seconds, a
	
Timer2_ISR_done:
	pop psw
	pop acc
	reti

;---------------------------------;
; Main program. Includes hardware ;
; initialization and 'forever'    ;
; loop.                           ;
;---------------------------------;
main:
	; Initialization
    mov SP, #0x7F
    mov P0M1, #0x00
    mov P0M2, #0x00
    mov P1M1, #0x00
    mov P1M2, #0x00
    mov P3M2, #0x00
    mov P3M2, #0x00
          
    lcall Timer0_Init
    lcall Timer2_Init
    setb EA   ; Enable Global interrupts
    lcall LCD_4BIT
    ; For convenience a few handy macros are included in 'LCD_4bit.inc':
	Set_Cursor(1,1)
    Send_Constant_String(#Initial_Message)
    Set_Cursor(2,1)
    Send_Constant_String(#Second_Message)
    Set_Cursor(1,9)
    Send_Constant_String(#Colon_M)
    Set_Cursor(1,12)
    Send_Constant_String(#Colon_M)
    Set_Cursor(2,9)
    Send_Constant_String(#Colon_M)
    setb half_seconds_flag
    mov Seconds, #0x50
    mov Minutes, #0x59
    mov Hours, #0x12
    Set_Cursor(1,15)
    Send_Constant_String(#AM)
	
	; After initialization the program stays in this 'forever' loop
	
	
loop:
	
	jb CLEAR_BUTTON, loop_a  ; if the 'CLEAR' button is not pressed skip
	Wait_Milli_Seconds(#50)	; Debounce delay.  This macro is also in 'LCD_4bit.inc'
	jb CLEAR_BUTTON, loop_a  ; if the 'CLEAR' button is not pressed skip
	jnb CLEAR_BUTTON, $		; Wait for button release.  The '$' means: jump to same instruction.
	; A valid press of the 'CLEAR' button has been detected, reset the BCD counter.
	; But first stop timer 2 and reset the milli-seconds counter, to resync everything.
	clr TR2                 ; Stop timer 2
	clr a
	mov Count1ms+0, a
	mov Count1ms+1, a
	; Now clear the BCD counter
	mov Seconds, a
	mov Minutes, a
	mov Hours, a 
	setb TR2                ; Start timer 2
	sjmp loop_b             ; Display the new value
	
loop_a:
	jnb half_seconds_flag, loop
	
loop_b:
	clr a
	mov a, Seconds
    clr half_seconds_flag ; We clear this flag in the main loop, but it is set in the ISR for timer 2
	
	Set_Cursor(1, 13)     ; the place in the LCD where we want the BCD counter value
	Display_BCD(Seconds) ; This macro is also in 'LCD_4bit.inc'
	
	Set_Cursor(1, 10)
	Display_BCD(Minutes)
	
	Set_Cursor(1, 7)
	Display_BCD(Hours)
	
	Set_Cursor(2, 10)
	Display_BCD(Minutes)
	
	Set_Cursor(2, 7)
	Display_BCD(Hours)
	
	Set_Cursor(2,13)
    Send_Constant_String(#Off_Alarm)
    jb TIMER_BUTTON, SwitchOnOff
	
	Set_Cursor(2,12)
	Send_Constant_String(#AM)
	
	Set_Cursor(1,15)
	jnb AM_PM, Display
	Send_Constant_String(#PM)
	ljmp loop
	
SwitchOnOff:
	Set_Cursor(2,13)
	Send_Constant_String(#On_Alarm)
	Set_Cursor(2,16)
	Send_COnstant_String(#Blank)
	
Display:
	Send_Constant_String(#AM)
    ljmp loop
    
loop_hour:
	Wait_Milli_Seconds(#50)
	jb TIMER_HOUR, loop_hour_continue
	jnb TIMER_HOUR, loop_hour
	
loop_hour_continue:
	clr a
	mov a, Hours
	add a, #0x01
	da a
	cjne a, #0x13, loop_hour_update
	mov a, #0x01
	
loop_hour_update:
	mov Hours, a
	ljmp loop
	
loop_minute:
	Wait_Milli_Seconds(#50)
	jb TIMER_MINUTE, loop_minute_continue
	jnb TIMER_MINUTE, loop_minute
	
loop_minute_continue:
	clr a
	mov a, Minutes
	add a, #0x01
	da a
	cjne a, #0x60, loop_minute_update
	clr a
	
loop_minute_update:
	mov Minutes, a
	ljmp loop
	
loop_second:
	Wait_Milli_Seconds(#50)
	jb TIMER_SECOND, loop_second_continue
	jnb TIMER_SECOND, loop_second
	
loop_second_continue:
	clr a
	mov a, Seconds
	add a, #0x01
	da a
	cjne a, #0x60, loop_second_update
	clr a
	
loop_second_update:
	mov Seconds, a
	ljmp loop
	
loop_timer:
	Wait_Milli_Seconds(#50)
	jnb TIMER_BUTTON, $
	ljmp loop

    
END
