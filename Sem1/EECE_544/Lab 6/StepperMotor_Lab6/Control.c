
// Control.c
// This software configures the off-board control switches
// Runs on LM4F120 or TM4C123
// Program written by: Hitesh Vijay Oswal and Ankit Vilasrao Komawar
// Date Created: 10/22/15
// Last Modified: 12/04/15 
// Lab number: 6
// Hardware connections PB4-PB2 are connected to off-board switches
// PB4 is used to turn the motor on/off, if PB2 is 1 the motor will be on waiting for commands
// PB3 makes the motor turn clockwise
// PB2 makes the motor turn counter clockwise
// PB4 tirggers edge-trigger interrupts at both edges

#include "tm4c123gh6pm.h"


#define CW_SW 																				(*((volatile unsigned long *)0x40005020))	// PB3
#define CCW_SW 																				(*((volatile unsigned long *)0x40005010))	// PB2
	



// **************Control_Init*********************
// Initialize control switches inputs, called once 
// Input: none 
// Output: none

void Control_Init(void)
{
	volatile unsigned short delay;
	SYSCTL_RCGC2_R 				|=  SYSCTL_RCGC2_GPIOB;								// Activate the clock for Port B
	delay 								 =  0x00;															// Delay for two cycles
	GPIO_PORTB_DIR_R 			&= ~0x1C;															// Set Port B PB2 - PB4 as Input Ports
	GPIO_PORTB_AFSEL_R 		&= ~0x1C;															// Disable alternate functions
	GPIO_PORTB_DEN_R 			|=  0x1C;															// Set PB2 - PB4 as digital PINs
	GPIO_PORTB_AMSEL_R 		&= ~0x1C;															// Disable Analog function
	GPIO_PORTB_PCTL_R 		&= ~0x000FFF00;												// Configure PB2 - PB4 as GPIO
	GPIO_PORTB_PDR_R 			|=  0x1C;															// Activate Pull-Down for PINs PB2 - PB4
	GPIO_PORTB_IS_R 			&= ~0x10;															// Enable Edge Triggered Interrupt
	GPIO_PORTB_IBE_R 			|=  0x10;															// Interrupt on Both the Edges for PB4
	GPIO_PORTB_IM_R 			|=  0x10;															// Enable Interrupts for PINs PB4
	GPIO_PORTB_ICR_R 			|=  0x10;		

	NVIC_PRI0_R 					 = (NVIC_PRI0_R & 0xFFFF00FF)|0x00004000; //Set Priority for Port B interrupts as 2
	NVIC_EN0_R 						|= 	0x02;															// Enable Interrupt for Port B
}	 
	
	
// **************Control_In*********************
// Input from switches  
// Input: none 
// Output: 0 to 7 depending on keys
// PB4 is on/off, PB3 CW, PB2 CCW
// 

unsigned long Control_In(unsigned long Pos)
{ 
	unsigned short Status_R;
	
	if(CW_SW == 0x08 & CCW_SW == 0x00)																		// If Switch 1 is pressed
	{
		Status_R = 0x00;																										// Status = 00
	}
	
	else if(CW_SW == 0x00 & CCW_SW == 0x04)																// If Switch 2 is pressed
	{
		Status_R = 0x01;																										// Status = 00
		}
	
	else if(CW_SW == 0x08 & CCW_SW == 0x04 & Pos <= 100)									// If Switch 1 and Switch 2 are pressed and position = 180 degree(100 steps)
	{
		Status_R = 0x02;																										// Status = 00
	}
	else
	{
		Status_R = 0x03;																										// Status = 00
	}
	
   
	return Status_R;																											// Return Status
}



