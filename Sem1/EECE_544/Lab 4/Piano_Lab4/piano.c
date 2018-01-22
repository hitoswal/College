// Piano.c
// This software configures the off-board piano keys
// Runs on LM4F120 or TM4C123
// Program written by: Hitesh Vijay Oswal and Ankit Vilasrao Komawar
// Date Created: 10/26/2015 
// Last Modified: 10/29/2015
// Lab number: 4


#include "tm4c123gh6pm.h"
#include "Piano.h"
										

// **************Piano_Init*********************
// Initialize piano key inputs, called once 
// Input: none 
// Output: none
void Piano_Init(void)
{ 
  volatile unsigned long Delay;
	SYSCTL_RCGC2_R 				|=  SYSCTL_RCGC2_GPIOD;								// Activate the clock for Port D
	Delay 								 =  0x00;															// Delay for two cycles
	GPIO_PORTD_LOCK_R 		 =  0x4C4F434B; 											// Unlock Port D
	GPIO_PORTD_CR_R 			|=  0x0F;
	GPIO_PORTD_DIR_R 			&= ~0x0F;															// Set Port D PD0 - PD3 as Input Ports
	GPIO_PORTD_AFSEL_R 		&= ~0x0F;															// Disable alternate functions
	GPIO_PORTD_DEN_R 			|=  0x0F;															// Set PD0 - PD3 as digital PINs
	GPIO_PORTD_AMSEL_R 		&= ~0x0F;															// Disable Analog function
	GPIO_PORTD_PCTL_R 		&= ~0x0000FFFF;												// Configure PD0 - PD3 as GPIO
	GPIO_PORTD_PDR_R 			|=  0x0F;															// Activate Pull-Down for PINs PD0 - PD3
}
// **************Piano_In*********************
// Input from piano key inputs 
// Input: none 
// Output: 0 to 8 depending on keys
// 0x01 is just Key_0, 0x02 is just Key_1, 0x04 is just Key_2, 0x08 is just Key_3
unsigned long Piano_In(void)
{ 
  if (Key_0 == 0x01)
	{
		return 0x01;																							// If Key_0 is pressed return 0x01
	}
	else if (Key_1 == 0x02)
	{
		return 0x02;																							// If Key_1 is pressed return 0x02
	}
	else if (Key_2 == 0x04)
	{
		return 0x04;																							// If Key_2 is pressed return 0x04
	}
	else if (Key_3 == 0x08)
	{
		return 0x08; 																							// If Key_3 is pressed return 0x08
	}
	return 0x00;																								// If no key is pressed return 0x00
}

