//****************Timer0_Init*****************
// Initialize Timer 0 in Periodic mode. 
// It interrupts after every "Timer_Val/2" no. of clock cycles
// Its interrupt pirority is 3
// inputs: none
// outputs: none

void Timer0_Init(void);


//****************Timer1_Init*****************
// Initialize Timer 1 in Periodic mode. 
// It triggers ADC 0 after every "Timer_Val" no. of clock cycles
// inputs: none
// outputs: none

void Timer1_Init(void);


//****************Timer0A_Handler*****************
// Timer 0 Interrupt Handler 
// Transmitis Data using UART
// inputs: none
// outputs: none

void Timer0A_Handler(void);

