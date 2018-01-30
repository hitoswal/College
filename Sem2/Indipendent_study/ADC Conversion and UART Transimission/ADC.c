#include "tm4c123gh6pm.h"
#include "ADC.h"
#include "Queue.h"
#include "Nokia5110.h"

unsigned long Data1, Data2;																								// Global Variables

//****************ADC0_Init*****************
// Initialize ADC 0 in at the sampling rate if 125KHz.
// ADC is trigerred by Timer
// It interrupts after  both the conversions are complete.
// Its interrupt pirority is 1
// It is connected to Channel PE2(Ain1) - Step 0 and PE3(Ain0) - Step 1
// inputs: none
// outputs: none

void ADC0_Init(void)
	{ 
		SYSCTL_RCGCGPIO_R |= 0x10; 																						// activate clock for Port E
		while((SYSCTL_PRGPIO_R & 0x10) == 0){};																// Wait Till 4th bit of PRGPIO = 1
		GPIO_PORTE_DIR_R &= ~0x0C;																						// Set PE2 and PE3 as Input Port
		GPIO_PORTE_AFSEL_R |= 0x0C;																						// Enable Alternate function for PE2 and PE3
		GPIO_PORTE_DEN_R &= ~0x0C;																						// Disable Digital Function
		GPIO_PORTE_AMSEL_R |= 0x0C;																						// Enable Analog Function for PE2 and PE3
		SYSCTL_RCGCADC_R |= 0x01;																							// Enable clock for ADC Module 0
		while((SYSCTL_PRADC_R&0x01) == 0){};																	// Wait Till 1st bit of PRADC = 1
		ADC0_PC_R = 0x01;																											// Set Sampling frequency to 125KHz
		ADC0_SSPRI_R = 0x1023;																								// Set highest Priority for Sequencer 2 
		ADC0_ACTSS_R &= ~0x04;																								// Disable Sequencer 2 to configure it
		ADC0_EMUX_R |= 0x0500;																								// Set Trigger as Timer Trigger
		ADC0_SSMUX2_R |= (1 << ADC_SSMUX2_MUX0_S) | (0 << ADC_SSMUX2_MUX1_S); // Connect PE2(Ain1) to the Sequencer 2 Step 0 and PE3(Ain0) to the Sequencer 2 Step 1
		ADC0_SSCTL2_R = ADC_SSCTL2_END1 | ADC_SSCTL2_IE1;											// Set End bit and Interrupt bit for Step 1
		ADC0_IM_R |= 0x0004;																									// Set Interrupt Mask 
		NVIC_EN0_R |= (1 << 16) ;																							// Enable ADC Interrupt In NVIC
		NVIC_PRI4_R = (NVIC_PRI4_R & 0xFFFFFF0F) + (1 << 5);									// Set Priority as 1
		ADC0_ACTSS_R |= 0x04;																									// Enable Sequencer 2
	}	

//****************ADC0Seq2_Handler*****************
// ADC0 Sequencer 2 Interrupt Handler
// Reads the data from FIFO and saves it in a Queue	
// inputs: none
// outputs: none

void ADC0Seq2_Handler	(void)
{	
	if((ADC0_RIS_R&0x04) == 0x04)																						// Wait till Data is Converted (Wait for RIS bit)
	{
		ADC0_ISC_R = 0x0004;																									// Acknowledge (Set ISC bit) to clear the RIS bit
	}
	Data1 = (ADC0_SSFIFO2_R & 0xFFF) | 0xF000;															// Read the Data from ADC_FIFO and concate with 0xF at MSB represeting Ain1 (PE2)
	Data2 = (ADC0_SSFIFO2_R & 0xFFF) | 0x8000;															// Read the Data from ADC_FIFO and concate with 0x8 at MSB represeting Ain0 (PE3)
	if(QueueStat() != QFull)																								// Check if Queue is Full
	{	
		QueueInsert(Data1);																										// Save the Data in Queue
	}
	else
	{
		GPIO_PORTF_DATA_R = 0x02;																							// Turn Red LED On
		Error_Handler();																											// Error Handler
	}
	if(QueueStat() != QFull)																								// Check if Queue is Full
	{	
		QueueInsert(Data2);																					      		// Save the Data in Queue
	}
	else
	{
		GPIO_PORTF_DATA_R = 0x02;																							// Turn Red LED on
		Error_Handler();																											// Error Handler
	}
}

