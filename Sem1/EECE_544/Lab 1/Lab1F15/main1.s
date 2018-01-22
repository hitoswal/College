;****************** main.s ***************
; Program written by: Hitesh Oswal
; Date Created: 09/11/2015 
; Last Modified: 09/11/2015
; Lab number: 1
; This Program deals with locking and unlocking of door using 5-bit binary code i.e. 0-32 in decimal. Its Output in given using 2 LEDs, 
; one Red and another Green. When wrong code is given the Red light will Blink and will switch off. If door is locked Red LED will ne on.
; when door is unlocked Green light will be on.
; The overall objective of this system is a digital lock
; Hardware connections
; PORTE is switch input  (1 means switch is pressed, 0 means switch is not pressed)
;  
; PORTA is LED output (0 means door is locked, 1 means door is unlocked) 

GPIO_PORTE_DATA_R       EQU   0x400243FC
GPIO_PORTE_DIR_R        EQU   0x40024400
GPIO_PORTE_LOCK_R       EQU   0x40024520
GPIO_PORTE_AFSEL_R      EQU   0x40024420
GPIO_PORTE_DEN_R        EQU   0x4002451C
GPIO_PORTE_AMSEL_R      EQU   0x40024528
GPIO_PORTE_PCTL_R       EQU   0x4002452C
GPIO_PORTE_CR_R         EQU   0x40024524
GPIO_PORTE_PUR_R        EQU   0x40024510
	
GPIO_PORTA_DATA_R 		EQU	  0x400043FC
GPIO_PORTA_DIR_R		EQU   0x40004400
GPIO_PORTA_LOCK_R		EQU   0x40004520
GPIO_PORTA_AFSEL_R		EQU   0x40004420
GPIO_PORTA_DEN_R		EQU   0x4000451C
GPIO_PORTA_AMSEL_R		EQU   0x40004528
GPIO_PORTA_PCTL_R		EQU   0x4000452C
GPIO_PORTA_CR_R			EQU   0x40004524
GPIO_PORTA_PUR_R		EQU   0x40004510

SYSCTL_RCGC2_R          EQU   0x400FE108
SYSCTL_RCGCGPIO_R4		EQU	  0x00000010
SYSCTL_RCGC2_GPIOE     	EQU   0x00000010



      AREA    |.text|, CODE, READONLY, ALIGN=2
      THUMB
      EXPORT  Start
Start
	BL PortE_Init	; initialize port E here
	BL PortA_Init	; initialize port A here
loop
	LDR R0, =FIFTHSEC
	BL	delay
	BL	PortE_Input
	MOV R8, R1
	CMP R1, #0x00
	BEQ	Zero
	CMP R1, #0x11
	BNE	Wrong
	BL	Right
	B	loop

Wrong
	LDR	R0, =GPIO_PORTA_DATA_R
	LDR	R1, [R0]
	AND	R1, R1, #0xFB
	EOR	R1, R1, #0x08
	BL	PortA_Output
	LDR R0, =QUARTERSEC
	BL	delay
	EOR	R1, R1, #0x08
	BL	PortA_Output
	LDR R0, =QUARTERSEC
	BL	delay
	EOR	R1, R1, #0x08
	BL	PortA_Output
	LDR R0, =QUARTERSEC
	BL	delay
	EOR	R1, R1, #0x08
	BL	PortA_Output
	LDR R0, =QUARTERSEC
	BL	delay
	AND	R1, R1, #0xF7
	BL	PortA_Output
	LDR R0, =ONESECOND
	BL	delay
	LDR R0, =ONESECOND
	BL	delay
	LDR R0, =ONESECOND
	BL	delay
	ORR	R1, R1, #0x08
	BL	PortA_Output
Here1
	BL	PortE_Input
	CMP R1, R8
	BEQ	Here1
	B	loop

Right
	LDR	R0, =GPIO_PORTA_DATA_R
	LDR	R1, [R0]
	AND R1, R1,	#0xF7
	EOR	R1, R1, #0x04
	BL	PortA_Output
	LDR R0, =QUARTERSEC
	BL	delay
	EOR	R1, R1, #0x04
	BL	PortA_Output
	LDR R0, =QUARTERSEC
	BL	delay
	ORR	R1, R1, #0x04
	BL	PortA_Output
Here
	BL	PortE_Input
	CMP R1, R8
	BEQ	Here
	B	loop
	
Zero
	LDR	R0, =GPIO_PORTA_DATA_R
	LDR	R1, [R0]
	AND	R1, R1, #0xF3
	BL	PortA_Output
Here2
	BL	PortE_Input
	CMP R1, R8
	BEQ	Here2
	B	loop
;-----------------------------------------------------------------------
; delay function
ONESECOND	EQU		5333333		; approximately 1s delay at ~16 MHz clock
QUARTERSEC	EQU		1333333		; approximately 0.25s delay at ~16 MHz clock
FIFTHSEC	EQU		1066666		; approximately 0.2s delay at ~16 MHz clock

delay

	SUBS	R0, R0, #1			; R0 = R0 - 1 (count = count - 1)
	BNE		delay				; if count (R0) != 0, skip to 'delay'
	BX		LR					; return




;--------------------------------------------------------------------------

;-------------------PortE_Init----------------------------------------------

PortE_Init
	LDR R1, =SYSCTL_RCGC2_R         ; 1) activate clock for Port E
    LDR R0, [R1]                 
    ORR R0, R0, #0x10               ; set bit 4 to turn on clock
    STR R0, [R1]                  
    NOP
    NOP                             ; allow time for clock to finish
    LDR R1, =GPIO_PORTE_PCTL_R      ; 4) configure as GPIO
    MOV R0, #0x00             	; 0 means configure Port E as GPIO
    STR R0, [R1]                  
    LDR R1, =GPIO_PORTE_DIR_R       ; 5) set direction register
    LDR R0, [R1] 
    AND R0, R0, #0xE0               ; PE0-5 input
    STR R0, [R1]                    
    LDR R1, =GPIO_PORTE_AFSEL_R     ; 6) regular port function
    MOV R0, #0x00                   ; 0 means disable alternate function 
    STR R0, [R1]                    
	LDR R1, =GPIO_PORTE_DEN_R       ; 7) enable Port E digital port
    MOV R0, #0xFF                   ; 1 means enable digital I/O
    STR R0, [R1]                   
    BX  LR
; initialize port E here 

;-------------------PortA_Init----------------------------------------------



PortA_Init
	LDR R1, =SYSCTL_RCGC2_R         ; 1) activate clock for Port A
    LDR R0, [R1]                 
    ORR R0, R0, #0x01               ; set bit 5 to turn on clock
    STR R0, [R1]                  
    NOP
    NOP                             ; allow time for clock to finish
    LDR R1, =GPIO_PORTA_PCTL_R      ; 2) configure as GPIO
    MOV R0, #0x00		            ; 0 means configure Port A as GPIO
    STR R0, [R1]                  
    LDR R1, =GPIO_PORTA_DIR_R       ; 3) set direction register
    LDR R0, [R1]
    ORR R0, R0, #0x0C               ; PA2 and PA3 Output
    STR R0, [R1]                    
    LDR R1, =GPIO_PORTA_AFSEL_R     ; 4) regular port function
    MOV R0, #0x00                   ; 0 means disable alternate function 
    STR R0, [R1]                    
    LDR R1, =GPIO_PORTA_DEN_R       ; 5) enable Port A digital port
    MOV R0, #0xFF                   ; 1 means enable digital I/O
    STR R0, [R1]                   
	BX  LR

; initialize port A here

;-------------------PortE_Input----------------------------------------------
; Read and return the status of the switches.
; Input: none
; Output: R4 5 bit code from DIP switches
; Modifies: R3
PortE_Input
	LDR R0, =GPIO_PORTE_DATA_R		; pointer to Port E data
	LDR R1, [R0]					; read all of Port E
	AND R1, R1, #0x1F				; just the input pins PF0-4
	BX 	LR							; return R4 with inputs
	
;-------------------PortA_Output----------------------------------------------
; Set the output state of PA2-3.
; Input: R4  new state of PA
; Output: none
; Modifies: R3
PortA_Output
	LDR R0, =GPIO_PORTA_DATA_R		; pointer to Port A data
	STR R1, [R0]					; write to PA2-3
	BX	LR

	ALIGN        ; make sure the end of this section is aligned
	END          ; end of file