// SysTick.c
// Runs on LM4F120/TM4C123
// Provide functions that initialize SysTick to Interrupt at frequency of 40Hz
// Created by: Hitesh Vijay Oswal and Ankit Vilasrao Komawar
// Created on: 11/10/2015
// Last Modified on: 11/12/2015

//------------SysTick_Init------------
// Initilize the Systick and Set up SysTick Interrupt
// Input: none
// Output: none
void SysTick_Init(void);

//------------Set_Interrupt------------
// Update Reload value for 40Hz frequency
// Input: none
// Output: none
void Set_Interrupt(void);

//------------SysTick_Handler------------
// This block is executed when SysTick Interrupts takes place
// Busy-wait Analog to digital conversion and saving ADC Data to ADC Mail
// Setting ADC Status Flag
// Modifies: ADCMail and ADCStatus (Global Variables)
void SysTick_Handler(void);
