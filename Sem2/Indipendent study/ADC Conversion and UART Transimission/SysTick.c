#include "tm4c123gh6pm.h"
#include "UART.h"
#include "SysTick.h"
#include "Queue.h"
#include "Nokia5110.h"

extern unsigned long Data1, Data2;																									// Global Variables 

//********SysTick_Init*****************
// Initialize Systick With interrupt.
// Interrupt priority is 7
// inputs: none
// outputs: none


void SysTick_Init(void)
{
  NVIC_ST_CTRL_R = 0x00; 																														// Disable SysTick
	NVIC_ST_RELOAD_R = 0x00;  																												// Clear Reload Registor					
  NVIC_ST_CURRENT_R = 0x00;																													// Clear Current Register
  NVIC_ST_CTRL_R = 0x00000007;																											// Enable SysTick and SysTick Interrupts
	NVIC_SYS_PRI3_R = (NVIC_SYS_PRI3_R & 0x0FFFFFFF) + (7<<29);												// Set Priority doe Systick Interrupt - 7
}

//********Set_Interrupt*****************
// Load Systick value for 30 Hz.
// inputs: none
// outputs: none
// assumes: system clock rate of 50 MHz

void Set_Interrupt(void)
{
	NVIC_ST_RELOAD_R = 1666667-1;																											// Load Systick value for 30Hz				
  NVIC_ST_CURRENT_R = 0x00;																													// Clear Current Register
}

//********SysTick_Handler*****************
// Update LCD Display at the frequency of 30Hz.
// inputs: none
// outputs: none
// Global Variable used: Data1, Data2

void SysTick_Handler(void)
{
	Nokia5110_Clear();																																// Clear LCD
	Nokia5110_SetCursor(0,0);																													// Set Cursor to top Left corner (0,0)
	Nokia5110_OutString("Data1");																											// Print "Data1"
	Nokia5110_SetCursor(0,1);																													// Update Cursor to next line
	Nokia5110_OutUDec((Data1&0x0FFF));																								// Print value of Data1 in Decimal format
	Nokia5110_OutChar('A');																														// Print Identifier
	Nokia5110_SetCursor(0,2);																													// Update Cursor to next line
	Nokia5110_OutHex(Data1);																													// Print value of Data1 in Hexadecimal format
	Nokia5110_OutChar('A');																														// Print Identifier
	Nokia5110_SetCursor(0,3);																													// Update Cursor to next line
	Nokia5110_OutString("Data2");																											// Print "Data2"
	Nokia5110_SetCursor(0,4);																													// Update Cursor to next line
	Nokia5110_OutUDec((Data2&0xFFF));																									// Print value of Data2 in Decimal format
	Nokia5110_OutChar('B');																														// Print Identifier
	Nokia5110_SetCursor(0,5);																													// Update Cursor to next line
	Nokia5110_OutHex(Data2);																													// Print value of Data2 in Hexadecimal format
	Nokia5110_OutChar('B');																														// Print Identifier
}

