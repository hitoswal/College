// Piano.c
// This software configures the off-board piano keys
// Runs on LM4F120 or TM4C123
// Program written by: Hitesh Vijay Oswal and Ankit Vilasrao Komawar
// Date Created: 10/26/2015 
// Last Modified: 10/29/2015
// Lab number: 4

#include "tm4c123gh6pm.h"
#include "Piano.h"

unsigned long Input_Key;

// **************Piano_Init*********************
// Initialize piano key inputs, called once 
// Input: none 
// Output: none
void Piano_Init(void)
{ 
  volatile unsigned long Delay;
	SYSCTL_RCGC2_R 				|=  SYSCTL_RCGC2_GPIOD;								// Activate the clock for Port D
	Delay 								 =  0x00;															// Delay for two cycles
	GPIO_PORTD_LOCK_R 		 =  0x4C4F434B; 											// Unlock Port D 
	GPIO_PORTD_CR_R 			|=  0x0F;															
	GPIO_PORTD_DIR_R 			&= ~0x0F;															// Set Port D PD0 - PD3 as Input Ports
	GPIO_PORTD_AFSEL_R 		&= ~0x0F;															// Disable alternate functions
	GPIO_PORTD_DEN_R 			|=  0x0F;															// Set PD0 - PD3 as digital PINs
	GPIO_PORTD_AMSEL_R 		&= ~0x0F;															// Disable Analog function
	GPIO_PORTD_PCTL_R 		&= ~0x0000FFFF;												// Configure PD0 - PD3 as GPIO
	GPIO_PORTD_PDR_R 			|=  0x0F;															// Activate Pull-Down for PINs PD0 - PD3
	GPIO_PORTD_IS_R 			&= ~0x0F;															// Enable Edge Triggered Interrupt
	GPIO_PORTD_IBE_R 			|=  0x0F;															// Interrupt on Both the Edges
//	GPIO_PORTD_IEV_R 			|=  0x0F;
	GPIO_PORTD_IM_R 			|=  0x0F;															// Enable Interrupts for PINs PD0 - PD3
	GPIO_PORTD_ICR_R 			|=  0x0F;															// Clear RIS for PINs PD0 - PD3
	
	SYSCTL_RCGC2_R 				|=  SYSCTL_RCGC2_GPIOC;								// Activate the clock for Port D
	Delay 								 =  0x00;															// Delay for two cycles
	GPIO_PORTC_LOCK_R 		 =  0x4C4F434B; 											// Unlock Port C
	GPIO_PORTC_CR_R 			|=  0xFF;															
	GPIO_PORTC_DIR_R 			&= ~0xF0;															// Set Port C PC4 - PC7 as Input Ports
	GPIO_PORTC_AFSEL_R 		&= ~0xF0;															// Disable Analog function
	GPIO_PORTC_DEN_R 			|=  0xF0;															// Set PC4 - PC7 as digital PINs
	GPIO_PORTC_AMSEL_R 		&= ~0xF0;															// Disable Analog function															
	GPIO_PORTC_PCTL_R 		&= ~0xFFFF0000;												// Configure PC4 - PC7 as GPIO
	GPIO_PORTC_PDR_R 			|=  0xF0;															// Activate Pull-Down for PINs PC4 - PC7
	GPIO_PORTC_IS_R 			&= ~0xF0;															// Enable Edge Triggered Interrupt
	GPIO_PORTC_IBE_R 			|=  0xF0;															// Interrupt on Both the Edges
//	GPIO_PORTC_IEV_R 			|=  0xF0;
	GPIO_PORTC_IM_R 			|=  0xF0;															// Enable Interrupts for PINs PC4 - PC7
	GPIO_PORTC_ICR_R 			|=  0xF0;															// Clear RIS for PINs PC4 - PC7
	
	NVIC_PRI0_R 					 = (NVIC_PRI0_R & 0x0000FFFF)|0x40400000; //Set Priority for Port C and Port D interrupts. Both have the same priority of 2
	NVIC_EN0_R 						|= 	0x0C;															// Enable Interrupt for Port C and Port D
}

// **************Piano_In*********************
// Input from piano key inputs 
// Input: none 
// Output: 0 to 8 depending on keys
// 0x01 is just Key_0, 0x02 is just Key_1, 0x04 is just Key_2, 0x08 is just Key_3, 0x10 is just Key_4, 0x20 is just Key_5, 0x40 is just Key_6, 0x80 is just Key_7
unsigned long Piano_In(void)
{
	return Input_Key;
}
/*{ 
  if (Input_Key == 0x01)
	{
		return 0x01;																							// If Key_0 is pressed return 0x01
	}
	else if (Input_Key == 0x02)
	{
		return 0x02;																							// If Key_1 is pressed return 0x02
	}
	else if (Input_Key == 0x04)
	{
		return 0x04;																							// If Key_2 is pressed return 0x04  
	}
	else if (Input_Key == 0x08)
	{
		return 0x08;																							// If Key_3 is pressed return 0x08
	}
	else if (Input_Key == 0x10)
	{
		return 0x10;																							// If Key_4 is pressed return 0x10																							// If Key_0 is pressed return 0x01 
	}
	else if (Input_Key == 0x20)
	{
		return 0x20;																							// If Key_5 is pressed return 0x20
	}
	else if (Input_Key == 0x40)
	{
		return 0x40;																							// If Key_6 is pressed return 0x40 
	}
	else if (Input_Key == 0x80)
	{
		return 0x80;																							// If Key_7 is pressed return 0x80  
	}
	return 0x00;																								// If No Key is pressed return 0x00
}*/

// **************GPIOPortD_Handler*********************
// Port D interrupt Handler. This function will update the Global Register Input_Key according to the key Pressed or Released 
// Input: none 
// Output: non
void GPIOPortD_Handler(void)
{
	if ((GPIO_PORTD_RIS_R & 0x01) == 0x01)													// If Interrupt is occured due to Key_0
	{
		GPIO_PORTD_ICR_R 			|=  0x01;																// Acknowledge the Interrupt
		if (Key_0 == 0x01)																						// If Interrupt is occured due to Positive Edge trigger
		{
			Input_Key |= 0x01;																					// Update Global Variable Input_Key. Set the BIT-0 of the Variable
		}
		if (Key_0 == 0x00)																						// If Interrupt is occured due to Negative Edge trigger
		{
			Input_Key &= ~0x01;																					// Update Global Variable Input_Key. Clear the BIT-0 of the Variable
		}
		
	}
	else if ((GPIO_PORTD_RIS_R & 0x02) == 0x02)											// If Interrupt is occured due to Key_1
	{
		GPIO_PORTD_ICR_R 			|=  0x02;																// Acknowledge the Interrupt
		if (Key_1 == 0x02)																						// If Interrupt is occured due to Positive Edge trigger
		{
			Input_Key |= 0x02;																					// Update Global Variable Input_Key. Set the BIT-1 of the Variable
		}
		if (Key_1 == 0x00)																						// If Interrupt is occured due to Negative Edge trigger
		{
			Input_Key &= ~0x02;																					// Update Global Variable Input_Key. Clear the BIT-1 of the Variable
		}
	}
	else if ((GPIO_PORTD_RIS_R & 0x04) == 0x04)											// If Interrupt is occured due to Key_2
	{
		GPIO_PORTD_ICR_R 			|=  0x04;																// Acknowledge the Interrupt
		if (Key_2 == 0x04)																						// If Interrupt is occured due to Positive Edge trigger
		{
			Input_Key |= 0x04;																					// Update Global Variable Input_Key. Set the BIT-2 of the Variable
		}
		if (Key_2 == 0x00)																						// If Interrupt is occured due to Negative Edge trigger
		{
			Input_Key &= ~0x04;																					// Update Global Variable Input_Key. Clear the BIT-2 of the Variable
		}
	}
	else if ((GPIO_PORTD_RIS_R & 0x08) == 0x08)											// If Interrupt is occured due to Key_3
	{
		GPIO_PORTD_ICR_R 			|=  0x08;																// Acknowledge the Interrupt
		if (Key_3 == 0x08)																						// If Interrupt is occured due to Positive Edge trigger
		{
			Input_Key |= 0x08;																					// Update Global Variable Input_Key. Set the BIT-3 of the Variable
		}
		if (Key_3 == 0x00)																						// If Interrupt is occured due to Negative Edge trigger
		{
			Input_Key &= ~0x08;																					// Update Global Variable Input_Key. Clear the BIT-3 of the Variable
		}
	}
}

// **************GPIOPortC_Handler*********************
// Port C interrupt Handler. This function will update the Global Register Input_Key according to the key Pressed or Released  
// Input: none 
// Output: none
void GPIOPortC_Handler(void)
{
	if ((GPIO_PORTC_RIS_R & 0x10) == 0x10)													// If Interrupt is occured due to Key_4
	{
		GPIO_PORTC_ICR_R 			|=  0x10;																// Acknowledge the Interrupt
		if (Key_4 == 0x10)																						// If Interrupt is occured due to Positive Edge trigger
		{
			Input_Key |= 0x10;																					// Update Global Variable Input_Key. Set the BIT-4 of the Variable
		}
		if (Key_4 == 0x00)																						// If Interrupt is occured due to Negative Edge trigger
		{
			Input_Key &= ~0x10;																					// Update Global Variable Input_Key. Clear the BIT-4 of the Variable
		}
	}
	else if ((GPIO_PORTC_RIS_R & 0x20) == 0x20)											// If Interrupt is occured due to Key_5
	{
		GPIO_PORTC_ICR_R 			|=  0x20;																// Acknowledge the Interrupt
		if (Key_5 == 0x20)																						// If Interrupt is occured due to Positive Edge trigger
		{
			Input_Key |= 0x20;																					// Update Global Variable Input_Key. Set the BIT-5 of the Variable
		}
		if (Key_5 == 0x00)																						// If Interrupt is occured due to Negative Edge trigger
		{
			Input_Key &= ~0x20;																					// Update Global Variable Input_Key. Clear the BIT-5 of the Variable
		}
	}
	else if ((GPIO_PORTC_RIS_R & 0x40) == 0x40)											// If Interrupt is occured due to Key_6
	{
		GPIO_PORTC_ICR_R 			|=  0x40;																// Acknowledge the Interrupt
		if (Key_6 == 0x40)																						// If Interrupt is occured due to Positive Edge trigger
		{
			Input_Key |= 0x40;																					// Update Global Variable Input_Key. Set the BIT-6 of the Variable
		}
		if (Key_6 == 0x00)																						// If Interrupt is occured due to Negative Edge trigger
		{
			Input_Key &= ~0x40;																					// Update Global Variable Input_Key. Clear the BIT-6 of the Variable
		}
	}
	else if ((GPIO_PORTC_RIS_R & 0x80) == 0x80)											// If Interrupt is occured due to Key_7
	{
		GPIO_PORTC_ICR_R 			|=  0x80;																// Acknowledge the Interrupt
		if (Key_7 == 0x80)																						// If Interrupt is occured due to Positive Edge trigger
		{
			Input_Key |= 0x80;																					// Update Global Variable Input_Key. Set the BIT-7 of the Variable
		}
		if (Key_7 == 0x00)																						// If Interrupt is occured due to Negative Edge trigger
		{
			Input_Key &= ~0x80;																					// Update Global Variable Input_Key. Clear the BIT-7 of the Variable
		}
	}
}
