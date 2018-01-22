// UARTTestMain.c
// Runs on TM4C123
// UART Lab 7 
// Name: 
// Last Modified: 

// Insert description of the program here.



#include "PLL.h"
#include "UART.h"
#include "tm4c123gh6pm.h"
#include "PortF.h"
#include "SysTick.h"
#include "Nokia5110.h"
#define SW1											(*((volatile unsigned long *)0x40025004))
#define SW2											(*((volatile unsigned long *)0x40025040))
#define LEDR										(*((volatile unsigned long *)0x40025008))
#define LEDB										(*((volatile unsigned long *)0x40025010))


int main(void)
{
	
	volatile char input;
	Nokia5110_Init();
	PortF_Init();
	UART_Init();
	SysTick_Init();
	PLL_Init();
	


  while(1)
	{
		if(SW1 == 0x00)
		{
			LEDB |= 0x04;
			UART_OutString("b");
		}
		else
		{
			LEDB &= ~0x04;
		}
		if(SW2 == 0x00)
		{
			LEDR |= 0x02;
			UART_OutString("r");
		}
		else
		{
			LEDR &= ~0x02;
		}

		input = UART_InChar_NB();
		if(input == 'b')
		{
			Nokia5110_Clear();
			Nokia5110_OutString("BLUE");
		}
		else
		{
			Nokia5110_Clear();
		}
		if(input == 'r')
		{
			Nokia5110_Clear();
			Nokia5110_OutString("RED");
		}
		else
		{
			Nokia5110_Clear();
		}
	}
		
}	
