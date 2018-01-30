#include "tm4c123gh6pm.h"
#include "Timer.h"
#include "UART.h"
#include "Queue.h"
#include "Nokia5110.h"

// To change the Sampling frequency change the value over here.
#define Timer_Val		10000 																// ADC Sampling Frequency = 5KHz (50MHz/5KHz)


//****************Timer0_Init*****************
// Initialize Timer 0 in Periodic mode. 
// It interrupts after every "Timer_Val/2" no. of clock cycles
// Its interrupt pirority is 3
// inputs: none
// outputs: none

void Timer0_Init(void)
{
	SYSCTL_RCGCTIMER_R |= 0x01; 																// Enable Timer 0 Clock 
	while((SYSCTL_PRTIMER_R & 0x01) == 0){};										// Wait till PRTimer bit is set
	TIMER0_CTL_R = (TIMER0_CTL_R & 0xFFFFFFFE); 								// Disable Timer 0
	TIMER0_CFG_R = 0x00;																				// Set as 32-Bit timer Configuration
	TIMER0_TAMR_R |= 0x02;																			// Set Timer 0 as Periodic Mode
	TIMER0_TAILR_R  = Timer_Val/2-1; 														// Load the Timer Value
	TIMER0_IMR_R |= 0x01;   																		// Enable Timer 0interrupt mask
	TIMER0_ICR_R = 0x01;																				// Clear RIS Reg by writing 1 to ICR Register
	NVIC_EN0_R |= (1 << 19) ;																		// Enable Timer Interrupt in NVIC
	NVIC_PRI4_R = (NVIC_PRI4_R & 0x0FFFFFFF) + (3<< 29);				// Set the priority as 3
	TIMER0_CTL_R = (TIMER0_CTL_R & 0xFFFFFFFE) | 0x00000001; 		// Enable Timer 0
}	


//****************Timer1_Init*****************
// Initialize Timer 1 in Periodic mode. 
// It triggers ADC 0 after every "Timer_Val" no. of clock cycles
// inputs: none
// outputs: none

void Timer1_Init(void)
{
	SYSCTL_RCGCTIMER_R |= 0x02;																	// Enable Timer 1 Clock 
	while((SYSCTL_PRTIMER_R & 0x02) == 0){};										// Wait till PRTimer bit is set
	TIMER1_CTL_R = (TIMER1_CTL_R & 0xFFFFFFFE); 								// Disable Timer 1
	TIMER1_CFG_R = 0x00;																				// Set as 32-Bit timer Configuration
	TIMER1_TAMR_R |= 0x02;																			// Set Timer 1 as Periodic Mode
	TIMER1_TAILR_R  = Timer_Val-1; 															// Load the Timer Value
	TIMER1_CTL_R = (TIMER1_CTL_R & 0xFFFFFFDE) | 0x00000021; 		// Enable Timer and Configure it to trigger ADC0
}	


//****************Timer0A_Handler*****************
// Timer 0 Interrupt Handler 
// Reads Data from Queue and Transmitis Data Packet with dilimiter "*" using UART
// inputs: none
// outputs: none

void Timer0A_Handler(void)
{
	unsigned long Data;																							// Local variable to hold data
	if((TIMER0_RIS_R & 0x01) == 0x01)																// Acknowledge Interrupt by writing 1 in ICR bit 
	{
		TIMER0_ICR_R = 0x01;
		if(QueueStat() != QEmpty)																			// Check if Queue is Empty
			{	
				Data = QueueRead();																				// Read Data From Queue
				if((Data & 0xF000) == 0xF000)															// If Data from PE2 (Ain1) 
				{
					UART_OutUDec((Data&0xFFF));															// Transmit data
					UART_OutChar('A');																			// Transmit Identifier
					UART_OutChar('*');																			// Transmit Dilimiter
				}
				else if ((Data & 0xF000) == 0x8000)                       // If Data from PE3 (Ain0)
				{
					UART_OutUDec((Data&0xFFF));															// Transmit data
					UART_OutChar('B');																			// Transmit Identifier
					UART_OutChar('*');                                      // Transmit Dilimiter
				}				
			}
		GPIO_PORTF_DATA_R ^= 0x04;																		// Toggle Blue LED
	}		
}

