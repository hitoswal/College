// Driver.c
// This software configures the driver input
// Runs on LM4F120 or TM4C123
// Program written by: Hitesh Vijay Oswal and Ankit Vilasrao Komawae
// Date Created: 10/22/15
// Last Modified: 12/04/15 
// Lab number: 6
// Hardware connections PE4-PE0 are connected to L293 motor driver


// connect the rest of the L293 Driver PINs as follows:
// PINs 4,5,12,13 Ground
// PIN 16 to 5V from your microcontroller
// PIN 8 outside voltage source for the motor. DON'T CONNECT THIS PIN TO YOUR MICROCONTROLLER
// DON'T SUPPLEY MORE THAN 5 V from the outside, make sure to use the same common ground
// PIN 3 RED wire on the Stepper motor
// PIN 6 BLUE wire on the stepper motor
// PIN 11 GREEN wire on the stepper motor
// PIN 14 BLACK wire on the stepper motor

#include "tm4c123gh6pm.h"
// Define Ports registers locations here


// **************Driver_Init*********************
// Initialize control driver, called once 
// Input: none 
// Output: none

void Driver_Init(void)
{
	volatile unsigned short delay;
	SYSCTL_RCGC2_R 				|=  SYSCTL_RCGC2_GPIOE;								// Activate the clock for Port E
	delay 								 =  0x00;															// Delay for two cycles
	GPIO_PORTE_DIR_R 			|=  0x2F;															// Set Port E PE0 - PE4 as Output Ports
	GPIO_PORTE_AFSEL_R 		&= ~0x2F;															// Disable alternate functions
	GPIO_PORTE_DEN_R 			|=  0x2F;															// Set PE0 - PE4 as digital PINs
	GPIO_PORTE_AMSEL_R 		&= ~0x2F;															// Disable Analog function
	GPIO_PORTE_PCTL_R 		&= ~0x00FFFFFF;												// Configure PE0 - PE4 as GPIO 
	
}

