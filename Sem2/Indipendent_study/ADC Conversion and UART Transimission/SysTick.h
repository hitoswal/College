//********SysTick_Init*****************
// Initialize Systick With interrupt.
// Interrupt priority is 7
// inputs: none
// outputs: none
void SysTick_Init(void);

//********Set_Interrupt*****************
// Load Systick value for 30 Hz.
// inputs: none
// outputs: none
// assumes: system clock rate of 50 MHz

void Set_Interrupt(void);

//********SysTick_Handler*****************
// Update LCD Display at the frequency of 30Hz.
// inputs: none
// outputs: none
// Global Variable used: Data1, Data2

void SysTick_Handler(void);

