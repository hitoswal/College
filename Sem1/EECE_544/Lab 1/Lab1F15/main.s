; ****************************************** main.s **************************************************************************
; Program written by: Hitesh Vijay Oswal (007385223) and Ankit Vilasrao Komawar (007381362)
; Date Created: 09/11/2015 
; Last Modified: 09/25/2015
; Lab number: 01
; Runs on LM4F120/TM4C123G
; This Program deals with locking and unlocking using 5-bit binary code i.e. 0-32 in decimal. 
; Its Output is given using 2 LEDs, one Red and another Green.
; If locked, Red LED will be on.
; When wrong code is given the Red LED will Blink two times and will switch off. 
; After 2 Sec the red LED will be switched on to show the loacked status.
; When the correct code is entered the green LED blink one time and will be switched on. 
; When is unlocked Green LED will be on.
; When all inputs are equal to zero the both the LEDs will be off.
; ***************************************************************************************************************************
; Hardware connections
; DIP Switch 1-5 are connected to Port E PIN 0-4 respectively. 
; Switch in connected in negative logic.(0 means switch is pressed, 1 means switch is not pressed)
; Internal Pull-Up resistors are used at input port which is connected to switch.
; Red LED is Connected to Port A PIN 3
; Green LED is Connected to Port A PIN 2
; LEDs are connected in Actibe High configuration.
; *****************************************************************************************************************************

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
	BL PortE_Init				; initialize port E here
	BL PortA_Init				; initialize port A here
loop
	LDR	R0, =FIFTHSEC			; R0 = FIFTHSEC (delay 0.2 second)
	BL	delay					; delay at least (3*R0) cycles
	BL	PortE_Input				; read all of the switches on Port E
	MOV	R8, R1					; save input to R8 for further comparison
	CMP	R1,	#0x1F				; R1 = 0x1F?(as per negative logic)
	BEQ	Zero					; If so branch to Zero
	CMP	R1,	#0x1B				; R1 = 0x1B (Correct code) ? Correct code is 0x04 but as per negative logic compare with not(0x04).
	BNE	Wrong					; If not so branch to Wrong
	B	Right					; branch to right


Zero
	LDR	R0, =GPIO_PORTA_DATA_R	; Pointer to Port A Output
	LDR	R1, [R0]
	AND R1, #0xF3				; R1 = 0x00 representation both the LEDs are off
	BL	PortA_Output			; Turn off both the LEDs
B1	
	BL	PortE_Input				; Check all the input PINs
	CMP	R1, R8					; Compare the new input with previous saved input
	BEQ	B1						; If equal branch to B1 to read the input PINs again
	B	loop					; Branch to loop

Right
	LDR	R0, =GPIO_PORTA_DATA_R	; Pointer to Port A Output
	LDR	R1, [R0]				; Read the status of Output Ports
	AND R1, R1,	#0xF7			; and with 0xF7 to Swith off the Red LED
	EOR	R1, R1, #0x04			; XOR with 0x04 to Toggle the green LED
	BL	PortA_Output			; Switch off the Red LED and Toggle the Green LED
	LDR R0, =HALFSEC			; R0 = HALFSEC (delay 0.5 second)
	BL	delay					; delay at least (3*R0) cycles
	EOR	R1, R1, #0x04			; XOR with 0x04 to Toggle the green LED
	BL	PortA_Output			; Toggle Green LED
	LDR R0, =HALFSEC			; R0 = HALFSEC (delay 0.5 second)
	BL	delay					; delay at least (3*R0) cycles
	ORR	R1, R1, #0x04			; OR with 0x04 to switch on the Green LED
	BL	PortA_Output			; Switch on The Green LED
B2
	BL	PortE_Input				; Check all the input PINs
	CMP R1, R8					; Compare the new input with previous saved input
	BEQ	B2						; If equal branch to B2 to read the input PINs again
	B	loop					; Branch to loop

Wrong
	LDR	R0, =GPIO_PORTA_DATA_R	; Pointer to Port A Output
	LDR	R1, [R0]				; Read the status of Output Ports
	AND	R1, R1, #0xFB			; and with 0xFC to Swith off the Green LED
	EOR	R1, R1, #0x08			; XOR with 0x08 to Toggle the Red LED
	BL	PortA_Output			; Switch off the Green LED and Toggle the Red LED
	LDR R0, =HALFSEC			; R0 = HALFSEC (delay 0.5 second)
	BL	delay					; delay at least (3*R0) cycles
	EOR	R1, R1, #0x08			; XOR with 0x08 to Toggle the Red LED
	BL	PortA_Output			; Toggle RED LED
	LDR R0, =HALFSEC			; R0 = HALFSEC (delay 0.5 second)
	BL	delay					; delay at least (3*R0) cycles
	EOR	R1, R1, #0x08			; XOR with 0x08 to Toggle the Red LED
	BL	PortA_Output			; Toggle RED LED
	LDR R0, =HALFSEC			; R0 = HALFSEC (delay 0.5 second)
	BL	delay					; delay at least (3*R0) cycles
	EOR	R1, R1, #0x08			; XOR with 0x08 to Toggle the Red LED
	BL	PortA_Output			; Toggle RED LED
	LDR R0, =HALFSEC			; R0 = HALFSEC (delay 0.5 second)
	BL	delay					; delay at least (3*R0) cycles
	AND	R1, R1, #0xF7			; And with 0xF7 to switch off the Red LED
	BL	PortA_Output			; Switch off the Red LED
	LDR R0, =TWOSEC				; R0 = TWOSEC (delay 2 second)
	BL	delay					; delay at least (3*R0) cycles
	ORR	R1, R1, #0x08			; OR with 0x08 to Switch on the Red LED (Showing Locked Status)
	BL	PortA_Output			; Switch on the Red LED showing the locked status
B3
	BL	PortE_Input				; Check all the input PINs
	CMP R1, R8					; Compare the new input with previous saved input
	BEQ	B3						; If equal branch to B2 to read the input PINs again
	B	loop					; Branch to loop

;-----------------------------------------------------------------------
; delay function
ONESECOND	EQU		5333333		; approximately 1s delay at ~16 MHz clock
QUARTERSEC	EQU		1333333		; approximately 0.25s delay at ~16 MHz clock
HALFSEC		EQU		2666666		; approximately 0.5s delay at ~16 MHz clock
FIFTHSEC	EQU		1066666		; approximately 0.2s delay at ~16 MHz clock
TWOSEC      EQU    10666666     ; approximately 2s delay at ~16 MHz clock

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
    LDR R1, =GPIO_PORTE_PCTL_R      ; 2) configure as GPIO
    MOV R0, #0x00             		; 0 means configure Port E as GPIO
    STR R0, [R1]                  
    LDR R1, =GPIO_PORTE_DIR_R       ; 3) set direction register
    LDR R0, [R1] 
    AND R0, R0, #0xE0               ; PE0-5 input
    STR R0, [R1]                    
    LDR R1, =GPIO_PORTE_AFSEL_R     ; 4) regular port function
    MOV R0, #0x00                   ; 0 means disable alternate function 
    STR R0, [R1] 
	LDR R1, =GPIO_PORTE_PUR_R       ; 5) Pull up Registers
	MOV R0, #0x1F                   ; 1 means enabling pull up registor 
	STR R0, [R1]	
	LDR R1, =GPIO_PORTE_DEN_R       ; 6) enable Port E digital port
    MOV R0, #0xFF                   ; 1 means enable digital I/O
    STR R0, [R1]                   
    BX  LR 

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

;-------------------PortE_Input----------------------------------------------
; Read and return the status of the switches.
; Input: none
; Output: R1, 5 bit code from DIP switches
; Modifies: R0
PortE_Input
	LDR R0, =GPIO_PORTE_DATA_R		; pointer to Port E data
	LDR R1, [R0]					; read all of Port E
	AND R1, R1, #0x1F				; just the input pins PF0-4
	BX 	LR							; return R4 with inputs
	
;-------------------PortA_Output----------------------------------------------
; Set the output state of PA2-3.
; Input: R1 new state of PA
; Output: none
; Modifies: R0
PortA_Output
	LDR R0, =GPIO_PORTA_DATA_R		; pointer to Port A data
	STR R1, [R0]					; write to PA2-3
	BX	LR

	ALIGN        ; make sure the end of this section is aligned
	END          ; end of file