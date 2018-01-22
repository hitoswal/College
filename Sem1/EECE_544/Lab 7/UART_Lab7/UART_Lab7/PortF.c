// Port F initialization and information
// Runs on TM4C123
// Input from PF4 and PF0, output to PF1-PF3
// Author: Hadil Mustafa
// Date: Novermber 22, 2015

// LaunchPad built-in hardware
// SW1 left switch is negative logic PF4 on the Launchpad
// SW2 right switch is negative logic PF0 on the Launchpad
// red LED connected to PF1 on the Launchpad
// blue LED connected to PF2 on the Launchpad
// green LED connected to PF3 on the Launchpad

// 1. Pre-processor Directives Section
// Constant declarations to access port registers using 
// symbolic names instead of addresses



#include "tm4c123gh6pm.h"




void PortF_Init(void)
{
	volatile unsigned long delay;
	SYSCTL_RCGC2_R |= 0x20;
	delay = 0x00;
	GPIO_PORTF_DIR_R |= 0x06;
	GPIO_PORTF_DIR_R &= ~0x11;
	GPIO_PORTF_DEN_R |= 0x17;
	GPIO_PORTF_AFSEL_R &= ~0x17;
	GPIO_PORTF_AMSEL_R &= ~0x17;
	GPIO_PORTF_PCTL_R &= ~0x000F0FFF;
	GPIO_PORTF_PUR_R  |= 0x11;
}
// Color    LED(s) PortF
// dark     ---    0
// red      R--    0x02
// blue     --B    0x04
// green    -G-    0x08
// yellow   RG-    0x0A
// sky blue -GB    0x0C
// white    RGB    0x0E
// pink     R-B    0x06
