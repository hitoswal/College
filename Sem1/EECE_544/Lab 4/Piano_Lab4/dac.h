// dac.h
// This software configures DAC output
// Runs on LM4F120 or TM4C123
// Program written by: Hitesh Vijay Oswal and Ankit Vilasrao Komawar
// Date Created: 10/26/2015 
// Last Modified: 10/29/2015
// Lab number: 4

// Hardware connections

#define DAC_OutPINs 						(*((volatile unsigned long *)0x4002407C))			//Port E PINs PE0-PE4
	

// **************DAC_Init*********************
// Initialize 4-bit DAC, called once 
// Input: none
// Output: none
void DAC_Init(void);


// **************DAC_Out*********************
// output to DAC
// Input: 5-bit data, 0 to 31
// Output: none
void DAC_Out(unsigned long data);


