// Control.c
// This software configures the off-board control switches
// Runs on LM4F120 or TM4C123
// Program written by: Hitesh Vijay Oswal and Ankit Vilasrao Komawar
// Date Created: 10/22/15
// Last Modified: 12/04/15 
// Lab number: 6
// Hardware connections PB4-PB2 are connected to off-board switches
// PB4 is used to turn the motor on/off, if PB2 is 1 the motor will be on waiting for commands
// PB3 makes the motor turn clockwise
// PB2 makes the motor turn counter clockwise
// PB4 tirggers edge-trigger interrupts at both edges


// Header files contain the prototypes for public functions
// this file explains what the module does

// **************Control_Init*********************
// Initialize switches inputs, called once 
// Input: none 
// Output: none
void Control_Init(void);

// **************Control_In*********************
// Input from switches inputs 
// Input: Present Position
// Output: 0 to 3 depending on keys 
unsigned long Control_In(unsigned long);

// **************GPIOPortB_Handler*********************
// ISR for Port B 
// Input: none
// Output: none
// global variables: 0 or 1 depending on Power Key(updates Gloabl Variable)
void GPIOPortB_Handler(void);
