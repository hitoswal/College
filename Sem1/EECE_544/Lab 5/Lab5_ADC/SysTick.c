// SysTick.c
// Runs on LM4F120/TM4C123
// Provide functions that initialize SysTick to Interrupt at frequency of 40Hz
// Created by: Hitesh Vijay Oswal and Ankit Vilasrao Komawar
// Created on: 11/10/2015
// Last Modified on: 11/12/2015

#include "tm4c123gh6pm.h"
#include "ADC.h"
#define PF2       (*((volatile unsigned long *)0x40025010))

extern unsigned long ADCMail;																												// Re Declare Global variable as Extern
extern unsigned long ADCStatus;																											// Re Declare Global variable as Extern

//------------SysTick_Init------------
// Initilize the Systick and Set up SysTick Interrupt
// Input: none
// Output: none
void SysTick_Init(void)
{
	NVIC_ST_CTRL_R = 0x00; 																														// Disable SysTick
	NVIC_ST_RELOAD_R = 0x00;  																												// Clear Reload Registor					
  NVIC_ST_CURRENT_R = 0x00;																													// Clear Current Register
  NVIC_ST_CTRL_R = 0x00000007;																											// Enable SysTick and SysTick Interrupts
	NVIC_SYS_PRI3_R = (NVIC_SYS_PRI3_R & 0x00FFFFFF) | 0x40000000;										// Set Priority doe Systick Interrupt - 02
}

//------------Set_Interrupt------------
// Update Reload value for 40Hz frequency
// Input: none
// Output: none
void Set_Interrupt(void)
{
	NVIC_ST_RELOAD_R = 1000000-1;																										// Reload Value for 40Hz Frequency				
  NVIC_ST_CURRENT_R = 0x00;																													// Clear Current Register
}

//------------SysTick_Handler------------
// This block is executed when SysTick Interrupts takes place
// Busy-wait Analog to digital conversion and saving ADC Data to ADC Mail
// Setting ADC Status Flag
// Modifies: ADCMail and ADCStatus (Global Variables)
void SysTick_Handler(void)
{
	PF2 ^= 0x04;     																																	// Heartbeat
	ADCMail = ADC0_SSFIFO3_R&0xFFF;																										// Read the 12-bit data from FIFO
	ADC0_ISC_R = 0x0008;																														// Acknowledge (Set ISC bit) to clear the RIS bit
//	ADCMail = ADC_In(); 																														// sample 12-bit channel 1
	ADCStatus = 0x01;																																	// Set the ADC Status Flag representating avalibality of new data
	PF2 ^= 0x04;    																																	// Heartbeat
}
