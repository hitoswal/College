// Lab5.c
// this lab creates a position measurment software that outputs the result on LCD
// The software samples analog input signal and use calibration to output the position
// Runs on LM4F120 or TM4C123
// Use the SysTick timer to request interrupts at a particular period.
// Hardware Connections:	Port E, PIN 	PE2 : Analog Input
//												Port F,	PIN 	PF2	:	Heartbeat Signal
//												Port A, PINS 	PA3	: SSI0Fss (SCE, pin 3 of LCD) 
// 																			PA7	: Reset (RST, pin 4 of LCD)  
// 																			PA6	:	Data/Command  (D/C, pin 5 of LCD)
// 																			PA5	:	SSI0Tx (DN,  pin 6 of LCD)
// 																			PA2	:	SSI0Clk (SCLK, pin 7 of LCD)
// Created by: Hitesh Vijay Oswal and Ankit Vilasrao Komawar
// Created on: 11/10/2015
// Last Modified on: 11/12/2015




#include "Nokia5110.h"
#include "pll.h"
#include "ADC.h"
#include "tm4c123gh6pm.h"
#include "SysTick.h"

#define PF2       (*((volatile unsigned long *)0x40025010))

//------------DisableInterrupts------------
// Disable Golobal Interrupts
// Input: none
// Output: none
void DisableInterrupts(void); 

//------------EnableInterrupts------------
// Enable Golobal Interrupts
// Input: none
// Output: none
void EnableInterrupts(void); 

//------------PortF_Init------------
// Initilize Port F, PIN PF2 as output PIN
// Input: none
// Output: none
void PortF_Init(void);

//------------Convert------------
// Converts the 12 bit ADC data to Respective Value representing position
// using Calibration formulae : y = (0.4123*X) + 144.5.
// This formulae in converterd to Fixed point format y = ((211 * X) + 73984)/512 where Delta = 2^9
// Input: 12 bit ADC Data
// Output: Converted Fixed point Data
unsigned long Convert(unsigned long);

//------------Print_Data------------
// Prints the present Position and ADC Value on LCD
// Input: Converted Fixed point Data and ADC Value
// Output: none
void Print_Data(unsigned long, unsigned long);


unsigned long ADCMail;																									// Global variable giving ADC value from SysTick Interrupt Handler
unsigned long ADCStatus;																								// Global variable giving status of New data


int main(void)
{ 
	unsigned long Data;      																							
	unsigned long Position;  																							
	DisableInterrupts();																									// Disable Global Interrupts
	PLL_Init();        																										// Bus clock is 40 MHz 
	PortF_Init();																													// Initilize Port F
	ADC_Init();        																										// turn on ADC, set channel to 1
	SysTick_Init();																												// Initilize SysTick and SysTick Interrupts
	Nokia5110_Init();																											// Initilize LCD
	ADCMail = 0x00;																												// Clear Data in ADC Mail
	ADCStatus = 0x00;																											// Clear ADC Status Flag
	EnableInterrupts();																										// Enable Global Interrupls
	Set_Interrupt();																											// Set SysTick Interrupts to 40 Hz Frequency
	while(1)
	{  
		while( ADCStatus == 0x01)																						// Check Whether New Data Is avaliable
		{
			Data = ADCMail;																										// Read the Data from ADC Mail
			ADCStatus = 0x00;																									// Clear the ADCStatus Flag
			Position = Convert(Data); 																				// Convert and Calibrate the ADC Data to its Position Value 
			Print_Data(Position, Data);																				// Print Data to LCD
			ADC0_PSSI_R = 0x0008;																							// Start the ADC conversion
			while((ADC0_RIS_R&0x08)==0)																				// Wait till Data is Converted (Wait for RIS bit)
			{}
		}
	}
}

//------------PortF_Init------------
// Initilize Port F, PIN PF2 as output PIN
// Input: none
// Output: none
void PortF_Init(void)
{
	unsigned long volatile delay;
	SYSCTL_RCGC2_R |= 0x20; 																							// activate clock for Port E
	delay = 0;																														// wait for 2 cycles
	GPIO_PORTF_LOCK_R = 0x4C4F434B; 																			// Unlock Port F
	GPIO_PORTF_CR_R |= 0x04;																							// Commit 
	GPIO_PORTF_DIR_R |= 0x04;																							// Set Diriction as output for PF2
	GPIO_PORTF_DEN_R |= 0x04;																							// Set Pin as Digital Pin
	GPIO_PORTF_AMSEL_R &= ~0x04;																					// Deactivate Analog function
	GPIO_PORTF_AFSEL_R &= ~0x04;																					// Deactivate Alternate Function
	GPIO_PORTF_PCTL_R  &= ~0x00000F00;																		// Set PF2 as GPIO
}

//------------Convert------------
// Converts the 12 bit ADC data to Respective Value representing position
// using Calibration formulae : y = (0.4123*X) + 144.5.
// This formulae in converterd to Fixed point format y = ((211 * X) + 73984)/512 where Delta = 2^9
// Input: 12 bit ADC Data
// Output: Converted Fixed point Data
unsigned long Convert(unsigned long input)
{
	volatile unsigned long conv_data;
	conv_data = (211 * input + 73984)/512;																	// Calibration using Fixed Point Format with delta = 2^9
	return conv_data;																												// Return converted Data
}

//------------Print_Data------------
// Prints the present Position and ADC Value on LCD
// Input: Converted Fixed point Data and ADC Value
// Output: none
void Print_Data(unsigned long Data, unsigned long ADC_Val)
{
	unsigned long Inte, frac;
	Inte = Data / 1000;																											// Seperate Integer Part of the Data
	frac = Data % 1000;																											// Seperate Fraction Part of the Data
	Nokia5110_Clear();																											// Clear Screen
	Nokia5110_OutString("Position:");																				// Print "Position:"
	Nokia5110_SetCursor(0,1);																								// New Line
	Nokia5110_OutUDec_Int(Inte);																						// Print Integer Part of The Data
	Nokia5110_OutString(".");																								// Print decimial point "."
	Nokia5110_OutUDec_Frac(frac);																						// Print Fraction Part of The Data
	Nokia5110_OutString("cm");																							// Print Unit "cm"
	Nokia5110_SetCursor(0,2);																								// New Line
	Nokia5110_OutString("ADC Value:");																			// Print "ADC Value:"
	Nokia5110_SetCursor(0,3);																								// New Line
	Nokia5110_OutUDec(ADC_Val);																							// Print ADC Value.
}

