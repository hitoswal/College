// Lab4.c
// Runs on TM4C123
// Program written by: Hitesh Vijay Oswal and Ankit Vilasrao Komawar
// Date Created: 10/26/2015
// Last Modified: 10/28/2015
// Lab number: 4
// In this project 4 Keys Piano is creates with the notes of C, D, E, and F having frequency 262Hz, 294Hz, 330Hz and 349Hz respectively
// The controller gives 5-bit digital output which converted to analog signal using 5-bit DAC.
// Systic Interrupts are used to output a perticular Digital data at every time intervel according to the frequency of the output signal.
// The Digital Array representing the sine wave is generated using the following link
// http://www.daycounter.com/Calculators/Sine-Generator-Calculator.phtml
// The controller works with the frequency of 80MHz which is generated using PLL
// Input Keys: Port D 	PD0: KEY_0, Note: C (262Hz)
//											PD1: KEY_1, Note: D (294Hz)
//											PD2: KEY_2, Note: E (330Hz)
//											PD3: KEY_3, Note: F (349Hz)
// DAC Output: Port E		PE0: BIT-0 Resistor Connected (in Kohm): 24
//											PE1: BIT-1 Resistor Connected (in Kohm): 12
//											PE2: BIT-2 Resistor Connected (in Kohm): 6
//											PE3: BIT-3 Resistor Connected (in Kohm): 3
//											PE4: BIT-4 Resistor Connected (in Kohm): 1.5
// DAC output range: 0V - 3.3V, Resolution: 0.1064 
// No of Samples: 64


#include "tm4c123gh6pm.h"
#include "PLL.h"
#include "Sound.h"
#include "Piano.h"

void DisableInterrupts(void); 														// Declaration of Disable interrupts
void EnableInterrupts(void);  														// Declaration of Enable interrupts

int main(void){      
  DisableInterrupts();																		// Disable interrupts to Initilize the system 
	PLL_Init();          																		// bus clock at 80 MHz
	Piano_Init();																						// Initilization of Piano Keys (Input Port)
	Sound_Init();																						// Initilization of Systick and DAC output.
  EnableInterrupts();																			// Enable interrupts to Initilize the system
  
	while(1)
	{ 
		volatile unsigned long Input;
		Input = Piano_In();																		// Check which key is pressed (If any)
		if (Input == 0x01)																		// If KEY_0 is Pressed
		{
			Sound_Play(Reload_Val(262));												// Reload the Systick with the vlaue for 262Hz. Value is calculated in Reload_Val() function
			while(Key_0 == 0x01)																// Do nothing till KEY_0 is pressed
			{}
			Input = 0x00;																				// After the KEY_0 is released acknowledge by clearing the input variable
			Sound_Play(1);																			// Reset the SysTick to 0 so that it cannot inturrept
		}
		else if (Input == 0x02)																// If KEY_1 is Pressed
		{
			Sound_Play(Reload_Val(294));												// Reload the Systick with the vlaue for 294Hz. Value is calculated in Reload_Val() function
			while(Key_1 == 0x02)																// Do nothing till KEY_1 is pressed
			{}
			Input = 0x00;																				// After the KEY_0 is released acknowledge by clearing the input variable
			Sound_Play(1);
		}
		else if (Input == 0x04)																// If KEY_2 is Pressed
		{
			Sound_Play(Reload_Val(330));												// Reload the Systick with the vlaue for 330Hz. Value is calculated in Reload_Val() function
			while(Key_2 == 0x04)																// Do nothing till KEY_2 is pressed
			{}
			Input = 0x00;																				// After the KEY_0 is released acknowledge by clearing the input variable
			Sound_Play(1);																			// Reset the SysTick to 0 so that it cannot inturrept
		}
		else if (Input == 0x08)																// If KEY_3 is Pressed
		{
			Sound_Play(Reload_Val(349));												// Reload the Systick with the vlaue for 349Hz. Value is calculated in Reload_Val() function
			while(Key_3 == 0x08)																// Do nothing till KEY_3 is pressed
			{}
			Input = 0x00;																				// After the KEY_0 is released acknowledge by clearing the input variable
			Sound_Play(1);																			// Reset the SysTick to 0 so that it cannot inturrept
		}
  }             
}


