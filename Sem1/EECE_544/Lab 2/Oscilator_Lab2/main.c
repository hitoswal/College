// 0.Documentation Section 
// Oscilator, main.c

// Runs on LM4F120 or TM4C123 LaunchPad
// Input from PF4(SW1) and output to PF0-PF3
// Pressing and releasing SW1 will increment the counter
// Wait 10 ms in between reading the switch to remove switch bounce 
// When the switch reaches 15 (1111), it rolls back to 0(0000) 


// Author: Enter your name here
// Date: 

// 1. Pre-processor Directives Section
// Constant declarations to access port registers using 
// symbolic names instead of addresses
#define GPIO_PORTF_DATA_R       (*((volatile unsigned long *)0x400253FC))
#define GPIO_PORTF_DIR_R        (*((volatile unsigned long *)0x40025400))
#define GPIO_PORTF_AFSEL_R      (*((volatile unsigned long *)0x40025420))
#define GPIO_PORTF_PUR_R        (*((volatile unsigned long *)0x40025510))
#define GPIO_PORTF_DEN_R        (*((volatile unsigned long *)0x4002551C))
#define GPIO_PORTF_LOCK_R       (*((volatile unsigned long *)0x40025520))
#define GPIO_PORTF_CR_R         (*((volatile unsigned long *)0x40025524))
#define GPIO_PORTF_AMSEL_R      (*((volatile unsigned long *)0x40025528))
#define GPIO_PORTF_PCTL_R       (*((volatile unsigned long *)0x4002552C))
//#define PF04										(*((volatile unsigned long *)0x4005D044))

#define SYSCTL_RCGC2_R          (*((volatile unsigned long *)0x400FE108))

#define GPIO_PORTE_DATA_R       (*((volatile unsigned long *)0x400243FC))
#define GPIO_PORTE_DIR_R        (*((volatile unsigned long *)0x40024400))
#define GPIO_PORTE_AFSEL_R      (*((volatile unsigned long *)0x40024420))
#define GPIO_PORTE_DEN_R        (*((volatile unsigned long *)0x4002451C))
#define GPIO_PORTE_LOCK_R       (*((volatile unsigned long *)0x40024520))
#define GPIO_PORTE_CR_R         (*((volatile unsigned long *)0x40024524))
#define GPIO_PORTE_AMSEL_R      (*((volatile unsigned long *)0x40024528))
#define GPIO_PORTE_PCTL_R       (*((volatile unsigned long *)0x4002452C))
#define PE2											(*((volatile unsigned long *)0x4005C010))
#define PE3											(*((volatile unsigned long *)0x4005C020))

// 2. Declarations Section
//   Global Variables
//void Delay(unsigned long frequency);
void Delay_T(unsigned long period);
void freq_262(void);
void freq_392(void);
void no_out(void);
void Delay_freq262(void);
void Delay_freq392(void);
unsigned long read_input(void);

//   Insert Function Prototypes here
void PortF_Init(void);
void PortE_Init(void);

// 3. Subroutines Section
// MAIN: Mandatory for a C Program to be executable
int main(void)
	{

//Initialize the ports here
	PortF_Init();
	PortE_Init();
	Delay_T(10);
  
	while(1)
		{
//		Insert your code here
			volatile unsigned long  in;
			in = read_input();
			if (in == 0x01)
			{
				PE2 = 1;
//				freq_262();
			}
			if (in == 0x10)
			{
				PE3 = 1;
//				freq_392();
			}
			if (in == 0x11)
			{
				while(in)
				{
				GPIO_PORTF_DATA_R = 0x0C;
					Delay_T(10);
				GPIO_PORTF_DATA_R = 0x00;
					Delay_T(10);
				in = read_input();
				}
//				no_out();
			}
			Delay_T(10);
		}
	}


unsigned long read_input(void)
{
	volatile unsigned long input;
	input = GPIO_PORTF_DATA_R;
	return input;
}

void freq_262(void)
{
	volatile unsigned long input;
	while(input == 0x01)
	{
		PE2 = 1;
//		Delay_freq262();
//		PE2 = 0;
//		Delay_freq262();
		input = read_input();
	}
}	

void freq_392(void)
{
	volatile unsigned long input;
	while(input == 0x10)
	{
		PE3 = 1;
//		Delay_freq392();
//		PE3 = 0;
//		Delay_freq392();
		input = read_input();
	}	
}
	
void no_out(void)
{
	volatile unsigned long input;
	while(input == 0x11)
	{
		PE2 = 1;
		PE3 = 1;
		input = read_input();
	}
	
	
}	
// Insert a subroutine to initialize ports for input and output
// 
// Inputs: None
// Outputs: None
// Notes: ...
	
void PortF_Init(void)
	{ 
		volatile unsigned long delay;
		SYSCTL_RCGC2_R |= 0x00000020;     // 1) activate clock for Port F
		delay = SYSCTL_RCGC2_R;           // allow time for clock to start
		GPIO_PORTF_LOCK_R = 0x4C4F434B;
		GPIO_PORTF_CR_R = 0x1F; 					 // allow changes to PF4-0
		GPIO_PORTF_AMSEL_R = 0x00;        // 2) disable analog on PF
		GPIO_PORTF_PCTL_R = 0x00000000;   // 3) PCTL GPIO on PF1-2
		GPIO_PORTF_DIR_R &= ~0x11;        	// 5) PF2,PF1 In
		GPIO_PORTF_AFSEL_R = 0x00;        // 6) disable alt funct on PF7-0
		GPIO_PORTF_PUR_R = 0x00;          // 7) Disable pull-up 
		GPIO_PORTF_DEN_R = 0xFF;          // 7) enable digital I/O on PF7-0
	}
	
	
	


// Insert a subroutine to initialize port E here 

	void PortE_Init(void)
		{ 
			volatile unsigned long delay;
			SYSCTL_RCGC2_R |= 0x00000010;     // 1) activate clock for Port F
			delay = SYSCTL_RCGC2_R;           // allow time for clock to start
			GPIO_PORTE_AMSEL_R = 0x00;        // 2) disable analog on PF
			GPIO_PORTE_PCTL_R = 0x00000000;   // 3) Port E GPIO 
			GPIO_PORTE_DIR_R |= 0x0C;        // 4) PE2,PE3 out
			GPIO_PORTE_AFSEL_R = 0x00;        // 5) disable alt funct on PF7-0
			GPIO_PORTE_DEN_R = 0xFF;          // 6) enable digital I/O on PF4-0
		}
	
	
	
	

// MODIFY and use the following delay function to create delay periods
// We will make a precise estimate later: 
//   For now we assume it takes 0.1 sec to count down
//   from 145448 down to zero
// Inputs: Modify as needed
// Outputs: None
// Notes: ...

//void Delay(unsigned long frequency)
//	{
//		unsigned long volatile time;
//		time = 145448;
//		while(time)
//			{
//				time--;
//			}
//	}
	void Delay_T(unsigned long period)
	{
		unsigned long volatile time;
		time = 145448/10;
		while(time)
			{
				time--;
			}
	}
void Delay_freq262(void)
	{
		unsigned long volatile time;
		time = 2775;
		while(time)
			{
				time--;
			}
	}
	void Delay_freq392(void)
	{
		unsigned long volatile time;
		time = 1855;
		while(time)
			{
				time--;
			}
	}
