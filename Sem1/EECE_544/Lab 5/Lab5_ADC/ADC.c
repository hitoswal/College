// ADC.c
// Runs on LM4F120/TM4C123
// Provide functions that initialize ADC0 SS3 to be triggered by
// software and trigger a conversion, wait for it to finish,
// and return the result.
// Created by: Hitesh Vijay Oswal and Ankit Vilasrao Komawar
// Created on: 11/10/2015
// Last Modified on: 11/12/2015


#include "tm4c123gh6pm.h"
//------------ADC_Init------------
// This initialization function 
// Max sample rate: <=125,000 samples/second
// Sequencer 0 priority: 1st (highest)
// Sequencer 1 priority: 2nd
// Sequencer 2 priority: 3rd
// Sequencer 3 priority: 4th (lowest)
// SS3 triggering event: software trigger
// SS3 1st sample source: Ain1 (PE2)
// SS3 interrupts: flag set on completion but no interrupt requested

void ADC_Init(void)
	{ 
		volatile unsigned long delay;
		SYSCTL_RCGCGPIO_R |= 0x10; 																						// activate clock for Port E
		while((SYSCTL_PRGPIO_R & 0x10) == 0){};																// Wait Till 4th bit of PRGPIO = 1
		GPIO_PORTE_DIR_R &= ~0x04;																						// Set PE2 as Input Port
		GPIO_PORTE_AFSEL_R |= 0x04;																						// Enable Alternate function for PE2
		GPIO_PORTE_DEN_R &= ~0x04;																						// Disable Digital Function
		GPIO_PORTE_AMSEL_R |= 0x04;																						// Enable Analog Function for PE2
		SYSCTL_RCGCADC_R |= 0x01;																							// Enable clock for ADC Module 0
		while((SYSCTL_PRADC_R&0x01) == 0){};																	// Wait Till 1st bit of PRADC = 1
		ADC0_PC_R = 0x01;																											// Set Sampling frequency to 125KHz
		ADC0_SSPRI_R = 0x0123;																								// Set highest Priority for Sequencer 3
		ADC0_ACTSS_R &= ~0x08;																								// Disable Sequencer 3 to configure it
		ADC0_EMUX_R &= ~0xF000;																								// Set Software Start trigger event
		ADC0_SSMUX3_R = (ADC0_SSMUX3_R &0xFFFFFFF0) + 1;											// Connect PE2(Ain1) to the Sequencer 3 channel
		ADC0_SSCTL3_R = 0x06;																									// Activate Interrupt, Set Step1 as End of Sequence, Disable Temp Sensor and Sample Differential Input
		ADC0_IM_R &= ~0x0008; 																								// 13) disable SS3 interrupts
		ADC0_ACTSS_R |= 0x08;																									// Enable Sequencer 3 to configure it
	}

//------------ADC_In------------
// Busy-wait Analog to digital conversion
// Input: none
// Output: 12-bit result of ADC conversion
unsigned long ADC_In(void)
	{ 
		volatile unsigned long Data;
/*		ADC0_PSSI_R = 0x0008;																									// Start the conversion
		while((ADC0_RIS_R&0x08)==0)																						// Wait till Data is Converted (Wait for RIS bit)
		{}*/
		Data = ADC0_SSFIFO3_R&0xFFF;																					// Read the 12-bit data from FIFO
		ADC0_ISC_R = 0x0008;																									// Acknowledge (Set ISC bit) to clear the RIS bit
		return Data;																													// Return the 12-bit data
	}


