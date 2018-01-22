// Stepper.c
// Runs on LM4F120 or TM4C123
// Index implementation of a Moore finite state machine to operate
// a Stepper Motor
// Hardware connections : Port B	PB2: Switch for rotating in counter clock wise direction
//																PB3: Switch for rotating in clock wise direction
//																PB4: Power Switch
//												Port E	PE0: IC Enable
//																PE1-PE4: 4-Bit Output to the motor
// Discription: When any of the two key is pressed with power key then and only the motor rotates.
//							If Sw1(PB3) is pressed with power key then motor rotates in clock wise direction with the speed of 30 RPM
//							If Sw2(PB2) is pressed with power key then motor rotates in counter clock wise direction with the speed of 30 RPM
//							If Sw1(PB3) and SW2(PB2) are pressed with power key then motor rotates in clock wise direction with the speed of 5 RPM only for 108 degree(100 steps)
// Your Name: Hitesh Vijay Oswal and Ankit Vilasrao Komawar
// created: November 14, 2015
// last modified: December 03, 2015



#include "tm4c123gh6pm.h"
#include "PLL.h"
#include "SysTick.h"
#include "Control.h"
#include "Driver.h" 
#include "Nokia5110.h"
#define Pwr_SW 																							(*((volatile unsigned long *)0x40005040))				// PB4
//#define PE5 																								(*((volatile unsigned long *)0x40024080))				// PE5
void EnableInterrupts(void);
void DisableInterrupts(void);
void PrintString(char*, char*);
void GPIOPortB_Handler1(void)	;
unsigned short Pwr_R;
// Define the Linked data structure
struct State																																// Linklisted structure for a single state
{
	unsigned long Output;																											// Output to be giben on port B
	unsigned long time;																												// Delay Count according to Systick subroutine
	unsigned long Adder;																											// Position Updater
	const struct State *next[4];																							// Array of Pointers to the next state depending on input
};
typedef const struct State STyp;

#define  CW5 		&FSM[0]																												// States Naming Start
#define  CW6		&FSM[1]
#define  CW10		&FSM[2]
#define  CW9 		&FSM[3]
#define  CCW9 	&FSM[4]	
#define  CCW10	&FSM[5]
#define  CCW6 	&FSM[6]
#define  CCW5 	&FSM[7]
#define  SL5	  &FSM[8]	
#define  SL6	 	&FSM[9]
#define  SL10 	&FSM[10]
#define  SL9	 	&FSM[11]
#define  Stop	  &FSM[12]																											// States Naming End


STyp FSM[13] = 																															// Array of State's Structure
{													
	{0x0B, 	10, 0, {CW6,  CCW9,  SL6,  Stop}},																// 9 <- 5 -> 6														
	{0x0D, 	10, 0, {CW10, CCW5,  SL10, Stop}},																// 5 <- 6 -> 10												
	{0x15,	10, 0, {CW9,  CCW6,  SL9,  Stop}},																// 6 <- 10 -> 9
	{0x13,	10, 0, {CW5,  CCW10, SL5,  Stop}},																// 10 <- 9 -> 5												
	{0x13,	10, 0, {CW5,  CCW10, SL5,  Stop}},																// 10 <- 9 -> 5											
	{0x15,	10, 0, {CW9,  CCW6,  SL9,  Stop}}, 																// 6 <- 10 -> 9												
	{0x0D,	10, 0, {CW10, CCW5,  SL10, Stop}},																// 5 <- 6 -> 10											
	{0x0B,	10, 0, {CW6,  CCW9,  SL6,  Stop}},																// 9 <- 5 -> 6
	{0x0B,	60, 1, {CW6,  CCW9,  SL6,  Stop}},																// 9 <- 5 -> 6											
	{0x0D,	60, 1, {CW10, CCW5,  SL10, Stop}},																// 5 <- 6 -> 10											
	{0x15,	60, 1, {CW9,  CCW6,  SL9,  Stop}},																// 6 <- 10 -> 9											
	{0x13,	60, 1, {CW5,  CCW10, SL5,  Stop}},																// 10 <- 9 -> 5												
	{0x00,	10, 0, {CW5,  CCW5,  SL5,  Stop}},																// 5 <- 0 -> 5
};

int main(void)
{ 
	volatile unsigned long delay;
	volatile unsigned long Fun;
	volatile unsigned long Position1, Position2;
	STyp *Pt;
	DisableInterrupts();
	PLL_Init();       																																		// 80 MHz, Program 10.1
  SysTick_Init();   																																		// Program 10.2
	Control_Init();																																				// Initilize Switches PB2-PB4
	Driver_Init();																																				// Initilize output PINS PE0-PE5
	Nokia5110_Init();																																			// Initilize LCD
	Position1 = 0;
	Position2 = 0;
	EnableInterrupts();																																		// Enable global interrupts
//	GPIOPortB_Handler1();
 
	Pt = Stop;  																																					// Point to Stop(stop the motor)
  while(1)
	{
		while(Pwr_R == 0x01)																																// If power switch is pressed
		{
			if (Pt == CW5 | Pt == CW6 | Pt == CW9 | Pt == CW10)																// IF present state is for clock wise rotation
			{
				PrintString("Clock Wise with Speed = 30 RPM", "Turn Right");										// Print string
			}
			else if (Pt == CCW5 | Pt == CCW6 | Pt == CCW9 | Pt == CCW10)											// IF present state is for counter clock wise rotation
			{
				PrintString("Counter Clock Wise with Speed = 30 RPM", "Turn Left");							// Print string
			}
			else if (Pt == SL5 | Pt == SL6 | Pt == SL9 | Pt == SL10)													// IF present state is for clock wise rotation with slow speed
			{
				PrintString("Clock Wise with Speed = 5 RPM", "Half Round");											// Print string
			}
			else
			{
				PrintString("OFF", "Stopped");																									// Print string
			}
						
			Output_Data = Pt->Output;																													// Output 4-Bit Data
			Position1 = Position1 + Pt->Adder;																								// Increment the position by 1 (tracking of porrstion)
			SysTick_Wait1ms(Pt->time);																												// Delay
			Fun = Control_In(Position1);																											// Check the input
			Pt = Pt->next[Fun];																																// Update pointer
			if (Position1 >= 200)																															// reset the tracking variable when 200 steps are over
			{
				Position1 = 0;
			}
		}
		while(Pwr_R == 0x00)																																// If power key is not pressed
		{
			Pt = Pt->next[0x03];																															// update the pointer to stop state																											
			Output_Data = Pt->Output;																													// Output 4-Bit data(0x0)
			Position1 = 0;																																		// Reset Position
			PrintString("OFF", "Stopped");																										// Print String
		}
  }
}

void GPIOPortB_Handler(void)																														// Port B ISR
{
	if((GPIO_PORTB_RIS_R & 0x10) == 0x10)																									// check if PB4 PIN caused interrupt
	{
		if (Pwr_SW == 0x10)																																	// if Interrupt is caused to rising edge triggre
		{
			GPIO_PORTB_ICR_R 	|=  0x10;																												// Acknowledge
			Pwr_R = 0x01;																																			// Set the power Variable
		}
		else if (Pwr_SW == 0x00)																														// if Interrupt is caused to galling edge triggre
		{
			GPIO_PORTB_ICR_R 	|=  0x10;																												// Acknowledge	
			Pwr_R = 0x00;																																			// Clear the power Variable
		}
	}
}

void PrintString(char *Prstring1, char *Prstring2 )
{
	Nokia5110_Clear();																																		// Clear LCD
	Nokia5110_OutString(Prstring1);																												// Print string 1
	Nokia5110_SetCursor(0,5);																															// Update cursor 
	Nokia5110_OutString(Prstring2);																												// Print String 2
}

