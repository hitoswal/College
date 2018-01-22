// dac.c
// This software configures DAC output
// Runs on LM4F120 or TM4C123
// Program written by: Hitesh Vijay Oswal and Ankit Vilasrao Komawar
// Date Created: 10/26/2015 
// Last Modified: 10/29/2015
// Lab number: 4

#include "tm4c123gh6pm.h"
#include "dac.h"

// **************DAC_Init*********************
// Initialize 5-bit DAC, called once 
// Input: none
// Output: none
void DAC_Init(void)
{
	volatile unsigned long Delay;
	SYSCTL_RCGC2_R |= SYSCTL_RCGC2_GPIOE;												// Activate the clock for Port E
	Delay = 0x00;																								// Delay for two cycles
	GPIO_PORTE_DIR_R |= 0x3F;																		// Sir Port E PE0 - PE5 as output PINs
	GPIO_PORTE_AFSEL_R &= ~0x3F;																// Disable alternate functions
	GPIO_PORTE_DEN_R |= 0x3F;																		// Set PE0 - PE5 as digital PINs
	GPIO_PORTE_AMSEL_R &= ~0x3F;																// Disable Analog function
	GPIO_PORTE_PCTL_R &= ~0x00FFFFFF;														// Configure PE0 - PE5 as GPIO
}

// **************DAC_Out*********************
// output to DAC
// Input: 5-bit data, 0 to 31 
// Output: none
void DAC_Out(unsigned long data)
{
	DAC_OutPINs = data;																					// Output the Data to PE0 - PE4
}
