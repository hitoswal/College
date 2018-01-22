// Driver.c
// This software configures the driver input
// Runs on LM4F120 or TM4C123
// Program written by: Hitesh Vijay Oswal and Ankit Vilasrao Komawae
// Date Created: 10/22/15
// Last Modified: 12/04/15 
// Lab number: 6
// Hardware connections PE4-PE0 are connected to L293 motor driver
// PE4 connect to Enable Pins 1 and 9
// PE3 PIN 2
// PE2 PIN 7
// PE1 PIN 10
// PE0 PIN 15

// connect the rest of the Driver PINs as follows:
// PINs 4,5,12,13 Ground
// PIN 16 to 5V from your microcontroller
// PIN 8 outside voltage source for the motor. DON'T CONNECT THIS PIN TO YOUR MICROCONTROLLER
// DON'T SUPPLEY MORE THAN 5 V from the outside, make sure to use the same common ground
// PIN 3 RED wire on the Stepper motor
// PIN 6 BLUE wire on the stepper motor
// PIN 11 GREEN wire on the stepper motor
// PIN 14 BLACK wire on the stepper motor

// Header files contain the prototypes for public functions
// this file explains what the module does

#define Output_Data 																				(*((volatile unsigned long *)0x4002407C))	// PE0 - PE4

// **************Driver_Init*********************
// Initialize pins output to the L293 Driver, called once 
// Input: none 
// Output: none
void Driver_Init(void);
