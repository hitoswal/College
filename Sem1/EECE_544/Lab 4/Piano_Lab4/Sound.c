// Sound.c, 
// This module contains the SysTick ISR that plays sound
// Runs on LM4F120 or TM4C123
// Program written by: Hitesh Vijay Oswal and Ankit Vilasrao Komawar
// Date Created: 10/26/2015 
// Last Modified: 10/29/2015 
// Lab number: 4

#include "tm4c123gh6pm.h"
#include "dac.h"
#include "Sound.h"


volatile unsigned long Signal[64]={	0x10,0x11,0x13,0x14,0x15,0x17,0x18,0x19,		// Data structure Of Sine Wave Obtained from
																		0x1A,0x1B,0x1C,0x1D,0x1E,0x1E,0x1F,0x1F,		// http://www.daycounter.com/Calculators/Sine-Generator-Calculator.phtml
																		0x1F,0x1F,0x1F,0x1E,0x1E,0x1D,0x1C,0x1B,
																		0x1A,0x19,0x18,0x17,0x15,0x14,0x13,0x11,
																		0x10,0x0E,0x0C,0x0B,0x0A,0x08,0x07,0x06,
																		0x05,0x04,0x03,0x02,0x01,0x01,0x00,0x00,
																		0x00,0x00,0x00,0x01,0x01,0x02,0x03,0x04,
																		0x05,0x06,0x07,0x08,0x0A,0x0B,0x0C,0x0E};
// **************Sound_Init*********************
// Initialize Systick periodic interrupts and calls DAC_Init which will initilize DAC Port
// Called once, with sound initially off
// Input: None
// Output: None
void Sound_Init(void)
{
	DAC_Init();																																		// Initilize DAC
	NVIC_ST_CTRL_R = 0; 																													// Disable SysTick
	NVIC_ST_RELOAD_R = 0;  																												// Clear Reload Registor					
  NVIC_ST_CURRENT_R = 0;																												// Clear Current Register
  NVIC_ST_CTRL_R = 0x00000007;																									// Enable SysTick and SysTick Interrupts
	NVIC_SYS_PRI3_R = (NVIC_SYS_PRI3_R & 0x00FFFFFF) | 0x40000000;								// Set Priority doe Systick Interrupt - 02
}

// **************Sound_Play*********************
// Set Systick interrupt period 
// Input: interrupt period
//           Units to be determined by Reload_Val()
//           Maximum :	4770 (0x12A2)
//           Minimum :	1		 (0x01)
//         	 Input of 1 disable SysTick Interrupt
// Output: none
void Sound_Play(unsigned long period)
{
	NVIC_ST_RELOAD_R = period-1;																									// Reload the Value to Reload Register  								
  NVIC_ST_CURRENT_R = 0;																												// Clear Current Register				
}

// **************SysTick_Handler*********************
// SysTick Interrupt Handler. This function will be executed when SysTick will Interrupt the controller. 
// It Outputs the Data of Sine wave to the DAC (Gives sound output)
// Input: None
// Output: None
void SysTick_Handler(void)
{
	static unsigned long count;																										// Declare Static variable so that it is stored in RAM. 
	Debug ^= 0x20;																																// Set the Debug PIN
	DAC_Out(Signal[count]);																												// Output the Data from Signal Array
	count += 1;																																		// Increment the Count value so it poits to next data in array
	if (count >= 64)
	{
		count = 0;																																	// If Variables is greater than 63 clear the count Variable   
	}																																							// as in data strecture there are only 64 elements ranging from 0 - 63
//	Debug = 0x00;																																	// Clear the Debug PIN
}

// *****************Reload_Val*******************
// Calculates Reload Value
// Input: Frequency
// Output: Reload Value
unsigned long Reload_Val(unsigned long Frequency)
{
	volatile unsigned long Reload;
	Reload = (80000000/Frequency)/64;																							// Calculate the Reload value dependinf upon input frequency
	return Reload;																																// Return the Reload Value
}


