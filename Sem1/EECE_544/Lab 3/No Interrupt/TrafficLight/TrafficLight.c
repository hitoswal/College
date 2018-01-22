// TrafficLight.c
// Runs on LM4F120 or TM4C123
// Index implementation of a Moore finite state machine to operate
// a traffic light.
// Your Name: Hitesh Vijay Oswal and Ankit Vilasrao Komawar
// created: 10/11/2015
// last modified by Hitesh Vijay Oswal: 10/12/15
// 
// Hardware Description: 	Port B PIN 3-5 Used For Side Street Signal PB3 - Green, PB4 - Yellow, PB5 - Red
//												Port E PIN 3-5 Used For Main Street Signal PE3 - Green, PE4 - Yellow, PE5 - Red
//												Port E PIN 2 Used For Walk Signal
//												Port E PIN 0-1 and Port F PIN 0-1 Used For Four Walk Input Switch
//												Port F PIN 2 Used for Side Lane Sensor Input
// For Output LEDs are in active high configuration i.e. When Port PINs are high(1), LEDs are switched on and when Port PINs are
// low(0), LEDs are switched off. All PINs connected to Switches uses Internal Pull-Up Resistors and hence are in Negative logic
// configuration i.e. when pressed(closed) output is 0 and when not pressed(open) output is 1. Clock frequency used is 80MHz. This
// frequency is obtained using PLL. SysTick is used to obtain required delay.

/* This example accompanies the book
   "Embedded Systems: Introduction to ARM Cortex M Microcontrollers",
   ISBN: 978-1469998749, Jonathan Valvano, copyright (c) 2013
   Volume 1 Program 6.8, Example 6.4
   "Embedded Systems: Real Time Interfacing to ARM Cortex M Microcontrollers",
   ISBN: 978-1463590154, Jonathan Valvano, copyright (c) 2013
   Volume 2 Program 3.1, Example 3.1

 Copyright 2013 by Jonathan W. Valvano, valvano@mail.utexas.edu
    You may use, edit, run or distribute this file
    as long as the above copyright notice remains
 THIS SOFTWARE IS PROVIDED "AS IS".  NO WARRANTIES, WHETHER EXPRESS, IMPLIED
 OR STATUTORY, INCLUDING, BUT NOT LIMITED TO, IMPLIED WARRANTIES OF
 MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE APPLY TO THIS SOFTWARE.
 VALVANO SHALL NOT, IN ANY CIRCUMSTANCES, BE LIABLE FOR SPECIAL, INCIDENTAL,
 OR CONSEQUENTIAL DAMAGES, FOR ANY REASON WHATSOEVER.
 For more information about my classes, my research, and my books, see
 http://users.ece.utexas.edu/~valvano/
 */

//-----------------------------------------------------------------------------------------------------
#include "PLL.h"
#include "SysTick.h"
//-----------------------------------------------------------------------------------------------------
#define GPIO_PORTB_DATA_R       (*((volatile unsigned long *)0x400053FC))		// Port B Registers Address defination START
#define GPIO_PORTB_DIR_R        (*((volatile unsigned long *)0x40005400))
#define GPIO_PORTB_AFSEL_R      (*((volatile unsigned long *)0x40005420))
#define GPIO_PORTB_PUR_R				(*((volatile unsigned long *)0x40005510))
#define GPIO_PORTB_DEN_R        (*((volatile unsigned long *)0x4000551C))
#define GPIO_PORTB_AMSEL_R      (*((volatile unsigned long *)0x40005528))
#define GPIO_PORTB_PCTL_R       (*((volatile unsigned long *)0x4000552C))		// Port F Registers Address defination END 
//-----------------------------------------------------------------------------------------------------
#define GPIO_PORTE_DATA_R       (*((volatile unsigned long *)0x400243FC))		// Port E Registers Address defination START
#define GPIO_PORTE_DIR_R        (*((volatile unsigned long *)0x40024400))
#define GPIO_PORTE_AFSEL_R      (*((volatile unsigned long *)0x40024420))
#define GPIO_PORTE_PUR_R				(*((volatile unsigned long *)0x40024510))
#define GPIO_PORTE_DEN_R        (*((volatile unsigned long *)0x4002451C))
#define GPIO_PORTE_AMSEL_R      (*((volatile unsigned long *)0x40024528))
#define GPIO_PORTE_PCTL_R       (*((volatile unsigned long *)0x4002452C))		// Port F Registers Address defination END 
//-----------------------------------------------------------------------------------------------------
#define SYSCTL_RCGC2_R          (*((volatile unsigned long *)0x400FE108))		// Port Clock Address defination
#define SYSCTL_RCGC2_GPIOB      0x00000002  // port B Clock Gating Control
#define SYSCTL_RCGC2_GPIOE      0x00000010  // port E Clock Gating Control
#define SYSCTL_RCGC2_GPIOF      0x00000020  // port B Clock Gating Control
//-----------------------------------------------------------------------------------------------------
#define GPIO_PORTF_DATA_R       (*((volatile unsigned long *)0x400253FC))		// Port F Registers Address defination START
#define GPIO_PORTF_DIR_R        (*((volatile unsigned long *)0x40025400))
#define GPIO_PORTF_AFSEL_R      (*((volatile unsigned long *)0x40025420))
#define GPIO_PORTF_PUR_R        (*((volatile unsigned long *)0x40025510))
#define GPIO_PORTF_DEN_R        (*((volatile unsigned long *)0x4002551C))
#define GPIO_PORTF_LOCK_R       (*((volatile unsigned long *)0x40025520))
#define GPIO_PORTF_CR_R         (*((volatile unsigned long *)0x40025524))
#define GPIO_PORTF_AMSEL_R      (*((volatile unsigned long *)0x40025528))
#define GPIO_PORTF_PCTL_R       (*((volatile unsigned long *)0x4002552C))		// Port F Registers Address defination END 
//-----------------------------------------------------------------------------------------------------
struct State																																// Linklisted structure for a single state
{
	unsigned long out_PB;																											// Output to be giben on port B
	unsigned long out_PE;																											// Output to be giben on port E
	unsigned long time;																												// Delay Count according to Systick subroutine
	const struct State *next[4];																							// Array of Pointers to the next state depending on input
};
typedef const struct State STyp;																						// Redefining the name for structure
//-----------------------------------------------------------------------------------------------------
#define GoM  &FSM[0]																												// States Naming Start
#define WaM  &FSM[1]
#define GoS  &FSM[2]
#define WaS  &FSM[3]
#define Walk  &FSM[4]																												// States Naming End

STyp FSM[5] = 																															// Array of State's Structure
{
	{0x20, 0x08, 300, {GoM, WaM, WaM, WaM}},																	// Go Main State Data
	{0x20, 0x10, 100, {GoS, GoS, Walk, Walk}},																// Wait Main State Data
	{0x08, 0x20, 300, {WaS, WaS, WaS, WaS}},																	// Go Side State Data
	{0x10, 0x20, 100, {GoM, GoM, Walk, GoM}},																	// Wait Side State Data
	{0x20, 0x24, 400, {GoM, GoS, GoM, GoS}}																		// Walk State Data
};
//-----------------------------------------------------------------------------------------------------
void Init_PortB(void);																											// Used Function Declaration Start
void Init_PortE(void);
void Init_PortF(void);
unsigned long Read_PortE(void);
unsigned long Read_PortF(void);
unsigned long Cal_Input(void);																							// Used Function Declaration End
//-----------------------------------------------------------------------------------------------------	
int main(void)																															// Main Function
{ 
	volatile unsigned long delay;																							//Variable Declaration
	volatile unsigned long input;
	STyp *Pt;																																	// Structures Pointer Declaration
	
	PLL_Init();       																												// Initilize PLL for Frequenct 80 MHz, Program 10.1
	Init_PortB();																															// Initilize Port B
	Init_PortE();																															// Initilize Port E
	Init_PortF();																															// Initilize Port F
		
	
	Pt = GoM; 																																// Set Pointed to Go Main State
	while(1)
	{
		GPIO_PORTB_DATA_R |= Pt->out_PB;																				// Switch on the required LEDs connected to Port B according to current state
		GPIO_PORTB_DATA_R &= Pt->out_PB;																				// Switch off the required LEDs connected to Port B according to current state
		GPIO_PORTE_DATA_R |= Pt->out_PE;																				// Switch on the required LEDs connected to Port E according to current state
		GPIO_PORTE_DATA_R &= Pt->out_PE;																				// Switch off the required LEDs connected to Port E according to current state
		SysTick_Wait10ms(Pt->time);																							// Call the SysTick for Required Delay according to current state
		input = Cal_Input();																										// Check the Input
		Pt = Pt->next[input];   																								// Update the pointer to next state depending op on the input
	
	}
}
//-----------------------------------------------------------------------------------------------------
void Init_PortB(void)																												// Initilization of Port B
{
	volatile unsigned long delay;																							
	SYSCTL_RCGC2_R |= 0x02;      																							// Activate the clock for Port B
	delay = SYSCTL_RCGC2_R; 																									// Delay for 2 cycles 
	GPIO_PORTB_AMSEL_R &= ~0x38;      																				// Switch off analog function for PINs PB3-PB5 																		
	GPIO_PORTB_PCTL_R &= ~0x00FFF000;   																			// Set PINs PB3-PB5 as General Purpose IO																
	GPIO_PORTB_DIR_R |= 0x38;        																					// Set Direction as Output for PINs PB3-PB5																	
	GPIO_PORTB_AFSEL_R &= ~0x38;     																					// Switch off alternate function for PINs PB3-PB5  																		
	GPIO_PORTB_DEN_R |= 0x38;																									// Set PINs PB3-PB5 as Digital 
	
}
//-----------------------------------------------------------------------------------------------------
void Init_PortE(void)																												// Initilization of Port E
{
	volatile unsigned long delay;
	SYSCTL_RCGC2_R |= 0x10;     																							// Activate the clock for Port E
	delay = SYSCTL_RCGC2_R;																										// Delay for 2 cycles
	GPIO_PORTE_AMSEL_R &= ~0x3F;     																					// Switch off analog function for PINs PE0-PE5  																		
	GPIO_PORTE_PCTL_R &= ~0x00FFFFFF;   																			// Set PINs PE0-PE5 as General Purpose IO															
	GPIO_PORTE_DIR_R &= ~0x03;																								// Set Direction as Input for PINs PE0-PE1
	GPIO_PORTE_DIR_R |= 0x3C;																									// Set Direction as Output for PIN PE2-PE5
	GPIO_PORTE_AFSEL_R &= ~0x3F;        																			// Switch off alternate function for PINs PE0-PE5																	
	GPIO_PORTE_DEN_R |= 0x3F;																									// Set PINs PE0-PE5 as Digital
	GPIO_PORTE_PUR_R |= 0x03;																									// Switch on the Pull-Up resistores for PINs PE0-PE1
}
//-----------------------------------------------------------------------------------------------------
void Init_PortF(void)																												// Initilization of Port F
{
	volatile unsigned long delay;
	SYSCTL_RCGC2_R |= 0x20;     																							// Activate the clock for Port F
	delay = SYSCTL_RCGC2_R;																										// Delay for 2 cycles
	GPIO_PORTF_LOCK_R = 0x4C4F434B;   																				// Unlock Port F
	GPIO_PORTF_CR_R = 0x1F;																										
	GPIO_PORTF_AMSEL_R &= ~0x07;        																			// Switch off analog function for PINs PF0-PF2
	GPIO_PORTF_PCTL_R &= ~0x00000FFF;   																			// Set PINs PF0-PF2 as General Purpose IO
	GPIO_PORTF_DIR_R &= ~0x07;        																				// Set Direction as Input for PINs PF0-PF2
	GPIO_PORTF_AFSEL_R &= ~0x07;        																			// Switch off alternate function for PINs PF0-PF2
	GPIO_PORTF_DEN_R |= 0x07;																									// Set PINs PF0-PF2 as Digital
	GPIO_PORTF_PUR_R |= 0x07;																									// Switch on the Pull-Up resistores for PINs PF0-PF2
}
//-----------------------------------------------------------------------------------------------------
unsigned long Read_PortE(void)																							// Read Data From Port E
{
	volatile unsigned long Input;																							
	Input = ~GPIO_PORTE_DATA_R;																								// As Swictch are Connected in active Low configuration Not the Data in Data register
	Input &= 0x03;																														// Mask the Data For PINs 0 and 1
	return Input;																															// Return the Input Data
}
//-----------------------------------------------------------------------------------------------------
unsigned long Read_PortF(void)																							// Read Data From Port F
{
	volatile unsigned long Input;																							
	Input = ~GPIO_PORTF_DATA_R;																								// As Swictch are Connected in active Low configuration Not the Data in Data register
	Input &= 0x07;																														// Mask the Data For PINs 0 and 2
	return Input;																															// Return the Input Data
}
//-----------------------------------------------------------------------------------------------------
unsigned long Cal_Input(void)
{
	volatile unsigned long Input, Data_E, Data_F_SW, Data_F_Sen;							
	Data_E = Read_PortE();																										// Read the Data from Port E 
	Data_F_SW = Read_PortF();																									// Read the Data from Port F
	Data_F_SW &= 0x03;																												// Mast the Data to Get data of PINs 0 and 1
	Data_F_Sen = Read_PortF();																								// Read the Data from Port F
	Data_F_Sen &= 0x04;																												// Mast the Data to Get data of PINs 2
	
	Input = 0x00;																															// initilize a variable to 0x00
	if((Data_E <= 0x03 & Data_E > 0x00) | (Data_F_SW <= 0x03 & Data_F_SW > 0x00))	// check if one or more Walk Switch is Pressed
	{
		Input |= 0x02;																													// If Pressed Set Bit-1 of Input variable
	}
	if (Data_F_Sen == 0x04)																										// Check for vehicles on side road
	{
		Input |= 0x01;																													// if ues Set Bit-0 of Input variable 
	}																																					// If vehicles on side street is avaliable Input == 0x01, 
																																						// If one or more Walk switch is pressed Input == 0x02 
																																						// and if both vehicles are available and one or more  
																																						// walk switch is pressed then Input == 0x03
	return Input;																															// return the Input variable
}
//-----------------------------------------------------------------------------------------------------
