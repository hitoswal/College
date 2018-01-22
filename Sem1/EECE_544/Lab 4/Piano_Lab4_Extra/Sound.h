// Sound.h
// This module contains the SysTick ISR that plays sound
// Runs on LM4F120 or TM4C123
// Program written by: Hitesh Vijay Oswal and Ankit Vilasrao Komawar
// Date Created: 10/26/2015 
// Last Modified: 10/29/2015
// Lab number: 4


// Hardware connections
#define Debug				(*((volatile unsigned long *)0x40024080))						// Port E PE5: Used for Debuging(HeartBeat Waveform)

// **************Sound_Init*********************
// Initialize Systick periodic interrupts and calls DAC_Init which will initilize DAC Port
// Called once, with sound initially off
// Input: None
// Output: None
void Sound_Init(void);


// **************Sound_Play*********************
// Set Systick interrupt period 
// Input: interrupt period
//           Units to be determined by Reload_Val()
//           Maximum :	4770 (0x12A2)
//           Minimum :	1		 (0x01)
//         	 Input of 1 disable SysTick Interrupt
// Output: none
void Sound_Play(unsigned long period);

// **************Reload_Val*********************
// Calculates Reload Value
// Input: Frequency
// Output: Reload Value
unsigned long Reload_Val(unsigned long Frequency);

// **************SysTick_Handler*********************
// SysTick Interrupt Handler. This function will be executed when SysTick will Interrupt the controller. 
// It Outputs the Data of Sine wave to the DAC (Gives sound output)
// Input: None
// Output: None
void SysTick_Handler(void);

