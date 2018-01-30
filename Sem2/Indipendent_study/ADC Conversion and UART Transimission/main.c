//****************************************************************************************************//
//*******************************ADC Conversion with UART Transmission********************************//
// In this Project 2 different analog signals are converted to digital with the precision of 12 bits
// the tested sampling frequency range is from 25 Hz to 6.5 KHz. 
// This converted data is then transmited using UART at the Baudrate of  921600 
// PIN Connection : PE2 - Analog Channel 1
//									PE3 - Analog Channel 2
//									PA0, PA1 - UART Port (USB DEBUG Port)
// Project Created By : Hitesh Vijay Oswal
// Reference used : UART.c 			:  	Class EECE 544 and 
//									Nokia5110.c	:		by Jonathan W. Valvano
//****************************************************************************************************//

#include "tm4c123gh6pm.h"
#include "UART.h"
#include "PLL.h"
#include "SysTick.h"
#include "Timer.h"
#include "ADC.h"
#include "Queue.h"
#include "Nokia5110.h"
#include "main.h"



int main(void)
{
	DisableInterrupts();																					// Disable Global Interrupts	
	PLL_Init();																										// Initilize PLL at 50MHz
	LED_Init();																										// Initilize RGB LED
	Timer0_Init();																								// Initilize Timer 0
	Timer1_Init();																								// Initilize Timer 1
	ADC0_Init();																									// Initilize ADC0
	UART_Init();																									// Initilize UART
//	SysTick_Init();																								// Initilize Systick Only if LCD is required for DEBUG
//	Set_Interrupt();																							// Start Systick interrupt Only if LCD is required for DEBUG
//	Nokia5110_Init();																							// Initilize LCD Only if LCD is required for DEBUG
	EnableInterrupts();																						// Enable Global Interrupts
 
	while(1)
	{  
		WaitForInterrupt();																					// Wait for interrupts
	}
}

	
//****************LED_Init*****************
// Initialize on board RGB LED. 
// inputs: none
// outputs: none

void LED_Init(void)
{
	SYSCTL_RCGCGPIO_R |= 0x20; 																						// activate clock for Port F
	while((SYSCTL_PRGPIO_R & 0x20) == 0){};																// Wait Till 4th bit of PRGPIO = 1
	GPIO_PORTF_DIR_R |= 0x0E;																							// Set PE2 as Input Port
	GPIO_PORTF_AFSEL_R &= ~0x0E;																					// Enable Alternate function for PE2
	GPIO_PORTF_DEN_R |= 0x0E;																							// Disable Digital Function
	GPIO_PORTF_AMSEL_R &= ~0x0E;																					// Enable Analog Function for PE2	
	GPIO_PORTF_PCTL_R &= ~0x0000FFF0; 																		// Set PCTL = 0
	GPIO_PORTF_PUR_R |= 0x0E;																							// Set Pull up registors
	GPIO_PORTF_LOCK_R |= 0x0E;																						// Unlock Port F
	GPIO_PORTF_CR_R = GPIO_LOCK_KEY;
	
}






