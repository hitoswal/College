//****************ADC0_Init*****************
// Initialize ADC 0 in at the sampling rate if 125KHz.
// ADC is trigerred by Timer
// It interrupts after  both the conversions are complete.
// Its interrupt pirority is 1
// It is connected to Channel PE2(Ain1) - Step 0 and PE3(Ain0) - Step 1
// inputs: none
// outputs: none

void ADC0_Init(void);

//****************ADC0Seq2_Handler*****************
// ADC0 Sequencer 2 Interrupt Handler
// Reads the data from FIFO and saves it in a Queue	
// inputs: none
// outputs: none

void ADC0Seq2_Handler	(void);
